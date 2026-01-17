#requires -Version 7.0

<#
.SYNOPSIS
Build script for Dragon Quest IV Remix (DQ4r) SNES ROM

.DESCRIPTION
Assembles 65816 source code using Poppy compiler, processes assets, and generates ROM image.

.PARAMETER Clean
Remove all build artifacts before building

.PARAMETER Release
Build with optimizations (vs Debug with symbols)

.PARAMETER Verbose
Show detailed build output

.EXAMPLE
.\build.ps1                          # Standard debug build
.\build.ps1 -Clean                   # Clean rebuild
.\build.ps1 -Release                 # Optimized build

.NOTES
This script requires:
- PowerShell 7.0+
- cc65 toolchain (ca65 assembler, ld65 linker)
- Python 3.11+ for asset processing (optional)

Author: DQ4r Development Team
License: Unlicensed (ROM hack project)
#>

param(
	[switch]$Clean,
	[switch]$Release,
	[switch]$Verbose
)

$ErrorActionPreference = "Stop"
$VerbosePreference = if ($Verbose) { "Continue" } else { "SilentlyContinue" }

# Configuration
$srcDir = "$PSScriptRoot/src"
$buildDir = "$PSScriptRoot/build"
$toolsDir = "$PSScriptRoot/tools"
$docsDir = "$PSScriptRoot/docs"
$assetsDir = "$PSScriptRoot/assets"

# Assembler configuration (using Poppy .NET compiler)
$PoppyRepo = "C:\Users\me\source\repos\poppy"
$PoppySln = "$PoppyRepo/src/Poppy.sln"

# Build artifact names
$mainAsm = "$srcDir/main.pasm"
$outputRom = "$buildDir/dq4r.sfc"
$symbolFile = "$buildDir/dq4r.sym"
$listingDir = "$buildDir/listings"

function Write-Header {
	param([string]$Message)
	Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
	Write-Host "║ $Message" -ForegroundColor Cyan
	Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
}

function Write-Step {
	param([string]$Message)
	Write-Host "➜ $Message" -ForegroundColor Yellow
}

function Write-Success {
	param([string]$Message)
	Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
	param([string]$Message)
	Write-Host "✗ $Message" -ForegroundColor Red
	exit 1
}

# ============================================
# Validation
# ============================================
Write-Header "Dragon Quest IV Remix (DQ4r) Build System"

Write-Step "Validating prerequisites..."

# Check Poppy repository
if (-not (Test-Path $PoppySln)) {
	Write-Error-Custom "Poppy solution not found at: $PoppySln"
}
Write-Success "Poppy repository found"

# Check .NET SDK
$dotnetCheck = & { dotnet --version 2>&1 }
if ($LASTEXITCODE -ne 0) {
	Write-Error-Custom "dotnet SDK not found. Please install .NET 10 SDK`nDownload: https://dotnet.microsoft.com/download"
}
Write-Success "dotnet SDK found: $dotnetCheck"

# Check source files
if (-not (Test-Path $srcDir)) {
	Write-Error-Custom "Source directory not found: $srcDir"
}
Write-Success "Source directory exists"

# Check main assembly
if (-not (Test-Path $mainAsm)) {
	Write-Error-Custom "Main assembly file not found: $mainAsm"
}
Write-Success "Main assembly file found"

# ============================================
# Clean Phase
# ============================================
if ($Clean) {
	Write-Header "Cleaning Build Artifacts"
	
	Write-Step "Removing build output..."
	Remove-Item $buildDir -Recurse -Force -ErrorAction SilentlyContinue
	Write-Success "Build directory cleaned"
	
	Write-Step "Removing generated assets..."
	Remove-Item "$srcDir/data/generated" -Recurse -Force -ErrorAction SilentlyContinue
	Write-Success "Generated assets cleaned"
}

# ============================================
# Build Poppy Compiler
# ============================================
Write-Header "Building Poppy Compiler"

Write-Step "Building Poppy ($($Release ? 'Release' : 'Debug'))..."
$poppy_config = $Release ? "Release" : "Debug"
$buildOutput = dotnet build $PoppySln `
	-c $poppy_config `
	--nologo `
	-q `
	2>&1

if ($LASTEXITCODE -ne 0) {
	Write-Error-Custom "Poppy build failed:`n$buildOutput"
}
Write-Success "Poppy built successfully"

# Find Poppy CLI executable
$poppy_build_path = "$PoppyRepo/src/Poppy.CLI/bin/$poppy_config"
$poppyExe = Get-ChildItem -Path $poppy_build_path -Include "poppy.dll" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $poppyExe) {
	# Try to find any poppy executable
	$poppyExe = Get-ChildItem -Path "$PoppyRepo/src" -Include "poppy.dll" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
}

if (-not $poppyExe) {
	Write-Error-Custom "Could not find poppy.dll after build"
}
Write-Success "Poppy CLI found: $($poppyExe.FullName)"

# ============================================
# Setup Phase
# ============================================
Write-Header "Setting Up Build Environment"

Write-Step "Creating output directories..."
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
New-Item -ItemType Directory -Path $listingDir -Force | Out-Null
New-Item -ItemType Directory -Path "$srcDir/data" -Force | Out-Null
Write-Success "Directories created"

# ============================================
# Asset Processing Phase
# ============================================
Write-Header "Processing Assets"

if (Test-Path "$toolsDir/extract_assets.py") {
	Write-Step "Extracting graphics and data assets..."
	
	# Check for Python
	try {
		$pythonVersion = python --version 2>&1
		Write-Success "Python available: $pythonVersion"
		
		# Run asset extraction
		python "$toolsDir/extract_assets.py" `
			--input "$assetsDir" `
			--output "$srcDir/data/generated.asm" `
			--verbose:$Verbose
		
		if ($LASTEXITCODE -eq 0) {
			Write-Success "Assets extracted successfully"
		} else {
			Write-Host "⚠ Asset extraction had issues (non-fatal)" -ForegroundColor Yellow
		}
	} catch {
		Write-Host "⚠ Python not available (optional) - skipping asset extraction" -ForegroundColor Yellow
	}
} else {
	Write-Host "⚠ Asset extraction tool not found (optional)" -ForegroundColor Yellow
}

# Create stub if not exists
if (-not (Test-Path "$srcDir/data/generated.asm")) {
	Write-Step "Creating empty generated.asm stub..."
	@"
; Auto-generated assets (stub)
; This file will be populated by asset extraction tools

; Placeholder for graphics data
; Placeholder for table data
; Placeholder for text data

"@ | Out-File "$srcDir/data/generated.asm" -Encoding UTF8
	Write-Success "Stub created"
}

# ============================================
# Assembly Phase
# ============================================
Write-Header "Assembling ROM"

# Create build directories
if (-not (Test-Path $buildDir)) {
	New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}
if (-not (Test-Path $listingDir)) {
	New-Item -ItemType Directory -Path $listingDir -Force | Out-Null
}

Write-Step "Assembling $mainAsm with Poppy..."

# Create config JSON for reference
$buildConfig = @{
	source = $mainAsm
	output = $outputRom
	symbols = $symbolFile
	listingDir = $listingDir
	timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
	config = "DQ4r - Dragon Quest IV Remix"
	assembler = "Poppy .NET Compiler"
}

$buildConfig | ConvertTo-Json | Out-File "$buildDir/build-config.json" -Encoding UTF8

# Run Poppy assembler via dotnet
$assemblyOutput = dotnet $poppyExe `
	-t snes `
	-o "$outputRom" `
	-l "$listingDir/dq4r.lst" `
	-s "$symbolFile" `
	"$mainAsm" `
	2>&1

if ($LASTEXITCODE -ne 0) {
	Write-Error-Custom "Poppy assembly failed:`n$assemblyOutput"
}

Write-Success "Poppy assembly completed"

# Check output ROM
if (-not (Test-Path $outputRom)) {
	Write-Error-Custom "Output ROM not created: $outputRom"
}

$romSize = (Get-Item $outputRom).Length
Write-Success "ROM created: $(Split-Path $outputRom -Leaf) ($([Math]::Round($romSize/1024,2)) KB)"

# ============================================
# Validation Phase
# ============================================
Write-Header "Validating Build"

Write-Step "Verifying ROM integrity..."

# Check ROM header
$romData = Get-Content $outputRom -AsByteStream
if ($romData.Length -lt 32784) {
	Write-Error-Custom "ROM size invalid (minimum 32 KB required)"
}
Write-Success "ROM size valid"

# Check for valid SNES header
$headerAddr = 0x7FC0
if ($romData[$headerAddr] -eq 0x00 -or $romData[$headerAddr] -eq 0xFF) {
	Write-Host "⚠ ROM header appears empty (may be invalid)" -ForegroundColor Yellow
}

# Check vectors are set (at end of ROM)
$vectorAddr = $romData.Length - 16
if ($romData[$vectorAddr] -eq 0x00 -and $romData[$vectorAddr + 1] -eq 0x00) {
	Write-Host "⚠ Reset vector appears unset" -ForegroundColor Yellow
}

Write-Success "ROM validation passed"

# ============================================
# Completion
# ============================================
Write-Header "Build Complete!"

Write-Host @"
Output ROM:     $outputRom
ROM Size:       $([Math]::Round($romSize/1024,2)) KB
Symbol File:    $symbolFile
Listing Dir:    $listingDir

Next Steps:
1. Test in Mesen2: mesen2 $outputRom
2. View symbols: mesen2 → Tools → Debugger → Load Symbol File → $symbolFile
3. Check listings: $listingDir

"@ -ForegroundColor Green

Write-Host "Emulator Commands:" -ForegroundColor Cyan
Write-Host "  Mesen2:  mesen2 $outputRom" -ForegroundColor Gray
Write-Host "  Snes9x:  snes9x $outputRom" -ForegroundColor Gray
Write-Host ""

exit 0

