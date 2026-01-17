# DQ4r Build System Guide

## Quick Start

### Requirements
- **Poppy**: Custom SNES 65816 assembler (.NET 10)
- **Peony**: Disassembler for analysis (optional)
- **.NET 10 Runtime**: Required for tools
- **Emulator**: Mesen2 or Snes9x for testing

### Build the ROM

```powershell
# From dq4r-info directory
.\build.ps1
```

This will:
1. Assemble all source files
2. Link them into a single ROM
3. Generate symbol files
4. Output `build/dq4r.sfc`

## Project Structure

```
dq4r-info/
├── src/                    # Assembly source code
│   ├── main.asm            # Entry point
│   ├── includes/           # Shared definitions
│   ├── engine/             # Core engine modules
│   ├── game/               # Gameplay systems
│   ├── chapters/           # Story content
│   └── data/               # Game data (auto-generated)
├── assets/                 # Raw assets
│   ├── graphics/           # PNG images
│   ├── audio/              # Music/SFX
│   └── text/               # Dialogue JSON
├── tools/                  # Build tools
│   ├── build.ps1           # Main build script
│   ├── extract.py          # Asset extraction
│   ├── convert.py          # Format conversion
│   └── verify.py           # ROM validation
├── docs/                   # Documentation
├── build/                  # Build output (gitignored)
│   ├── dq4r.sfc            # Final ROM
│   ├── dq4r.sym            # Symbol map
│   └── listings/           # Assembly listings
└── tests/                  # Test ROMs and validation
```

## Build System Components

### 1. Poppy Assembler Integration

DQ4r uses the **Poppy** custom assembler for 65816 code:

```powershell
# Using Poppy directly
dotnet run --project <poppy-repo>/src/Poppy.Cli -- assemble main.asm -o dq4r.sfc
```

**Configuration**: `src/main.asm` includes:
- `lorom` directive (LoROM memory layout)
- `.system:snes` directive (SNES platform)
- `.bank`, `.org` for addressing
- Cross-bank jumps via long addressing

### 2. Asset Processing

Assets go through a conversion pipeline:

```
Raw Assets (PNG/JSON/WAV)
    ↓
[Extract Tools]
    ↓
Binary Intermediate (CHR/DAT)
    ↓
[Convert Tools]
    ↓
Assembly Data Files (*.asm)
    ↓
[Poppy Compiler]
    ↓
ROM with embedded assets
```

**Tools**:
- `tools/extract_assets.py` - PNG → CHR, JSON → DAT
- `tools/convert_assets.py` - Binary → Assembly includes
- `tools/verify_rom.py` - Validate output ROM

### 3. Build Phases

#### Phase 1: Source Assembly
```powershell
dotnet build <poppy-repo>/Poppy.sln
$romPath = dotnet run --project src/Poppy.Cli -- assemble src/main.asm
```

**Output**: `build/dq4r.sfc` (32 MB initially, padded)

#### Phase 2: Asset Compilation
```powershell
# Convert all PNG graphics to CHR format
python tools/extract_assets.py --graphics assets/graphics/ --output src/data/graphics.asm

# Convert data tables
python tools/extract_assets.py --data assets/data/ --output src/data/tables.asm
```

#### Phase 3: Linking
```powershell
# Re-run assembly with all assets
dotnet run --project <poppy-repo>/src/Poppy.Cli -- assemble src/main.asm -o build/dq4r.sfc
```

#### Phase 4: Validation
```powershell
python tools/verify_rom.py build/dq4r.sfc
```

## Build Script (build.ps1)

```powershell
#requires -Version 7.0

param(
    [switch]$Clean,
    [switch]$Release,
    [string]$PoppyRepo = "../poppy"
)

$ErrorActionPreference = "Stop"

# Directories
$srcDir = "src"
$buildDir = "build"
$toolsDir = "tools"
$docsDir = "docs"

# Clean if requested
if ($Clean) {
    Write-Host "Cleaning build artifacts..." -ForegroundColor Cyan
    Remove-Item $buildDir -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$srcDir/data/generated" -Recurse -Force -ErrorAction SilentlyContinue
}

# Create directories
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
New-Item -ItemType Directory -Path "$srcDir/data" -Force | Out-Null

# Verify Poppy
if (-not (Test-Path "$PoppyRepo/src/Poppy.Cli/Program.cs")) {
    Write-Error "Poppy repository not found at: $PoppyRepo"
}

# Build Poppy
Write-Host "Building Poppy compiler..." -ForegroundColor Cyan
dotnet build "$PoppyRepo/Poppy.sln" -c Release --nologo -q
if ($LASTEXITCODE -ne 0) { 
    throw "Poppy build failed"
}

# Extract/Convert Assets
Write-Host "Processing assets..." -ForegroundColor Cyan
python "$toolsDir/extract_assets.py" --input "assets/" --output "$srcDir/data/generated.asm"
if ($LASTEXITCODE -ne 0) {
    throw "Asset extraction failed"
}

# Assemble
Write-Host "Assembling ROM..." -ForegroundColor Cyan
$config = @{
    "source" = "$srcDir/main.asm"
    "output" = "$buildDir/dq4r.sfc"
    "symbols" = "$buildDir/dq4r.sym"
    "listingDir" = "$buildDir/listings"
}

$configJson = $config | ConvertTo-Json
$configJson | Out-File -Encoding UTF8 "$buildDir/config.json"

dotnet run --project "$PoppyRepo/src/Poppy.Cli" -- `
    assemble `
    --input $config.source `
    --output $config.output `
    --symbols $config.symbols `
    --listings $config.listingDir

if ($LASTEXITCODE -ne 0) {
    throw "Assembly failed"
}

# Validate
Write-Host "Validating ROM..." -ForegroundColor Cyan
python "$toolsDir/verify_rom.py" $config.output

# Generate documentation
if ($Release) {
    Write-Host "Generating documentation..." -ForegroundColor Cyan
    python "$toolsDir/generate_docs.py" --input "$buildDir/dq4r.sym" --output "$docsDir/API.md"
}

Write-Host "Build complete!" -ForegroundColor Green
Write-Host "Output: $($config.output)"
```

## Assembly Structure

### Main Entry Point (`src/main.asm`)

```asm
.system:snes
lorom

; Include hardware definitions
.include "includes/hardware.asm"
.include "includes/macros.asm"
.include "includes/defines.asm"

; ============================================
; HEADER (0x00FFC0-0x00FFDF)
; ============================================
.org $FFC0
.header
    Title = "DQ4 REMIX         " ; 21 bytes
    ROMType = $31              ; LoROM + FastROM
    ROMSize = $0C              ; 4 MB
    RAMSize = $03              ; 8 KB
    CountryCode = $01          ; USA

; ============================================
; VECTORS (0x00FFE4-0x00FFFF)
; ============================================
.org $FFE4
    .dw NMI_Native
    .dw 0
    .dw 0
    .dw 0

.org $FFEA
    .dw 0
    .dw 0

.org $FFFA
    .dw NMI_Emulation
    .dw Reset
    .dw IRQ_Emulation

; ============================================
; CODE (0x008000+)
; ============================================
.bank 0
.org $8000

.include "engine/core.asm"
.include "engine/graphics.asm"
.include "engine/input.asm"
.include "engine/state.asm"
.include "game/menus.asm"
.include "game/battle.asm"
.include "game/world.asm"
.include "chapters/main.asm"

; ============================================
; DATA
; ============================================
.include "data/generated.asm"
.include "data/monsters.asm"
.include "data/items.asm"
.include "data/spells.asm"
```

### Includes Directory (`src/includes/`)

**hardware.asm** - PPU/APU register definitions
```asm
; PPU Registers
PPU_CONTROL     = $2100    ; Control register
PPU_DISPLAYCTRL = $2101    ; Display control
PPU_OAMADDR     = $2102    ; OAM address
PPU_OAMDATA     = $2104    ; OAM data
PPU_BGMODE      = $2105    ; BG mode and character size
...

; APU Registers
APU_PORT0       = $2140
APU_PORT1       = $2141
APU_PORT2       = $2142
APU_PORT3       = $2143
```

**macros.asm** - Helpful assembly macros
```asm
macro WaitVBlank()
    lda #$80
.waitloop
    cmp PPU_VBLANK
    bne .waitloop
endmacro

macro SetBank(bank)
    lda #bank
    pha
    plb
endmacro
```

**defines.asm** - Constants and equates
```asm
; Memory locations
GAME_STATE      = $7E0000
GAME_STATE_SIZE = $0100

CHARACTER_DATA  = $7E0100
CHARACTER_SIZE  = $0020
MAX_CHARACTERS  = 6

INVENTORY       = $7E0200
INVENTORY_SIZE  = 20

; Gameplay constants
MAX_LEVEL       = 99
MAX_HP          = 999
MAX_MP          = 999
MAX_MONEY       = 65535
```

## Conditional Assembly

You can build different versions:

```powershell
# Debug build with symbols
.\build.ps1

# Release build (optimized)
.\build.ps1 -Release

# Clean rebuild
.\build.ps1 -Clean

# Specify custom Poppy location
.\build.ps1 -PoppyRepo "C:\path\to\poppy"
```

## Poppy Syntax Reference

DQ4r uses Poppy's enhanced 65816 assembler:

### Directives
- `.system:snes` - Target SNES platform
- `.bank N` - Select bank N
- `.org $XXXX` - Set origin address
- `.header` - ROM header block
- `.include "file.asm"` - Include file

### Addressing Modes
```asm
lda #$00              ; Immediate (8-bit)
lda #$0000            ; Immediate (16-bit)
lda $2000             ; Absolute
lda $2000,x           ; Absolute, X indexed
jsr $C00000           ; Long absolute
jsr $C00000,x         ; Long absolute, X indexed
```

### 65816 Extensions
```asm
rep #$20              ; Clear 16-bit accumulator flag
sep #$20              ; Set 16-bit accumulator flag
phd                   ; Push direct page
plb                   ; Pull data bank
```

### Labels and Symbols
```asm
Reset:
    sei
    clc
    xce
    
    jmp MainLoop      ; Forward reference OK
    
MainLoop:
    wai               ; Wait for interrupt
    jmp MainLoop
```

## Testing the Build

### Run in Emulator
```powershell
# Using Mesen2
Start-Process "C:\Program Files\Mesen2\Mesen2.exe" -ArgumentList "build\dq4r.sfc"

# Using Snes9x
Start-Process "C:\Program Files\Snes9x\snes9x.exe" -ArgumentList "build\dq4r.sfc"
```

### Debug Symbols
```powershell
# Load symbols in Mesen2
# Tools → Debugger → File → Load Symbol File → build/dq4r.sym

# This allows:
# - Breakpoint by name (e.g., "Reset")
# - View variable values
# - Disassembly with labels
# - Memory watches
```

### Automated Verification
```powershell
python tools/verify_rom.py build/dq4r.sfc
```

Checks:
- Valid SNES header
- Correct ROM size
- Vector table integrity
- Bank boundaries
- No unresolved references

## Build Troubleshooting

### "Poppy assembly failed"
1. Check `build/listings/` for errors
2. Verify all includes exist
3. Check for circular includes
4. Validate syntax in `.asm` files

### "Asset extraction failed"
1. Verify assets in `assets/` directory
2. Check PNG dimensions (must be multiple of 8)
3. Ensure JSON syntax is valid
4. Run tool with `--verbose` flag

### "Symbol mismatch"
1. Rebuild with `.\build.ps1 -Clean`
2. Check for duplicate label names
3. Verify bank assignments
4. Use unique labels per include file

### "ROM won't boot"
1. Verify vectors at $00FFFA-$00FFFF
2. Check header format
3. Ensure Reset vector points to valid code
4. Validate FastROM flag in header

## CI/CD Integration

### GitHub Actions (Planned)
```yaml
name: Build DQ4r

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '10.x'
      - run: dotnet build poppy/Poppy.sln
      - run: ./build.ps1
      - uses: actions/upload-artifact@v3
        with:
          name: dq4r-rom
          path: build/dq4r.sfc
```

## Next Steps

1. Set up initial ROM structure
2. Test graphics rendering
3. Implement input system
4. Build battle test ROM
5. Integrate audio driver

