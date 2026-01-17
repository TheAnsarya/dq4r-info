# DQ4r ROM Integration - Data Converter Guide

This guide documents how the DW4 game data extraction and conversion pipeline works.

## Quick Start: Building the ROM

### Build with Current Data
```bash
cd C:\Users\me\source\repos\dq4r-info
pwsh -NoProfile -ExecutionPolicy Bypass -File ".\build.ps1"
```

Output: `build/dq4r.sfc` (64 KB SNES ROM)

## Data Extraction & Conversion Pipeline

### Overview

```
DW4 NES ROM (512 KB)
    ↓
Pre-extracted JSON Assets (dragon-warrior-4-info/)
    ↓
Python Converters (tools/)
    ↓
.pasm Data Files (src/data/)
    ↓
Poppy Assembler
    ↓
dq4r.sfc (64 KB SNES ROM)
```

### Stage 1: JSON Assets

**Location:** `C:\Users\me\source\repos\dragon-warrior-4-info\assets\json\`

Available datasets:
- `monsters/monster_*.json` - 50 individual monster files
- `items.json` - 128 items with prices and types
- `shops.json` - 180 shop configurations
- `spells/spells.json` - 50 spells with properties
- `encounters.json` - 7005 encounter group definitions
- `characters.json` - 8 party members + 8 companions

### Stage 2: Python Converters

Each converter:
1. Loads JSON data from dragon-warrior-4-info
2. Parses and validates data structures
3. Generates `.pasm` source code
4. Writes output to `src/data/*.pasm`

#### Monster Converter
**File:** `tools/json_to_pasm.py`

```bash
python tools/json_to_pasm.py
```

**Input:** `monster_*.json` (50 files)  
**Output:** `src/data/monsters_dw4.pasm` (509 lines)

**Format (8 bytes per monster):**
```pasm
.word HP           ; 16-bit
.word EXP          ; 16-bit
.word Gold         ; 16-bit
.byte ATK          ; 8-bit
.byte DEF          ; 8-bit
.byte AGI          ; 8-bit
.byte DropID       ; 8-bit
.byte DropRate     ; 8-bit
```

#### Items & Shops Converter
**File:** `tools/items_shops_simple.py`

```bash
python tools/items_shops_simple.py
```

**Input:** 
- `items.json` (128 items)
- `shops.json` (180 shops)

**Output:**
- `src/data/items_dw4.pasm` (131 lines)
- `src/data/shops_dw4.pasm` (183 lines)

**Key Feature:** `safe_int()` helper handles:
- Hex string IDs (`'0x00'`)
- Null/None values
- String type enumerations (`'weapon'`, `'armor'`)

#### Spells Converter
**File:** `tools/spells_converter.py`

```bash
python tools/spells_converter.py
```

**Input:** `spells.json` (50 spells)  
**Output:** `src/data/spells_dw4.pasm` (60 lines)

**Format (6 bytes per spell):**
```pasm
.byte MP_Cost, Effect, Power, Target, Element, Accuracy
```

#### Encounters Converter
**File:** `tools/encounters_converter.py`

```bash
python tools/encounters_converter.py
```

**Input:** `encounters.json` (7005 groups)  
**Output:** `src/data/encounters_dw4.pasm` (7008 lines)

**Format (6 bytes per encounter group):**
```pasm
.byte Monster[6]   ; Up to 6 monsters per group
```

#### Characters Converter
**File:** `tools/characters_converter.py`

```bash
python tools/characters_converter.py
```

**Input:** `characters.json` (16 total: 8 party + 8 companions)  
**Output:** `src/data/characters_dw4.pasm` (19 lines)

**Format (2 bytes per character):**
```pasm
.byte ID, Chapter
```

### Stage 3: .pasm Data Files

**Location:** `src/data/`

All generated files use Poppy `.pasm` syntax:
```pasm
; Comments (semicolon)
CONSTANT = $value        ; Named constants
LABEL: .byte $xx         ; 8-bit data
LABEL: .word $xxxx       ; 16-bit data
.include "other.pasm"    ; Include other files
```

### Stage 4: Poppy Assembly

**Main File:** `src/main.pasm`

Includes all data files:
```pasm
.include "data/monsters_dw4.pasm"
.include "data/items_dw4.pasm"
.include "data/shops_dw4.pasm"
.include "data/spells_dw4.pasm"
.include "data/encounters_dw4.pasm"
.include "data/characters_dw4.pasm"
```

### Stage 5: Build Output

**CLI Invocation:**
```bash
dotnet C:\Users\me\source\repos\poppy\src\Poppy.CLI\bin\Debug\net10.0\poppy.dll \
    --input src/main.pasm \
    --output build/dq4r.sfc
```

**Outputs:**
- `build/dq4r.sfc` - Compiled ROM (64 KB)
- `build/dq4r.sym` - Symbol file (for Mesen2 debugger)
- `build/listings/` - Assembly listings (.lst files)

## Adding New Data

### Example: Add Monster AI Data

1. **Create converter** (`tools/ai_converter.py`):
```python
import json

json_path = "C:/Users/me/source/repos/dragon-warrior-4-info/assets/json/ai.json"
output_path = "src/data/ai_dw4.pasm"

with open(json_path) as f:
    data = json.load(f)

ai_entries = data.get("ai_routines", [])

pasm_lines = ["AI_COUNT = ${:02x}".format(len(ai_entries)), "", "AI_TABLE:"]

for idx, ai in enumerate(ai_entries):
    pasm_lines.append(f"ai_{idx:02x}: .byte ... ; {ai.get('name')}")

with open(output_path, 'w') as f:
    f.write('\n'.join(pasm_lines))
```

2. **Run converter**:
```bash
python tools/ai_converter.py
```

3. **Add to main.pasm**:
```pasm
.include "data/ai_dw4.pasm"
```

4. **Rebuild ROM**:
```bash
pwsh -NoProfile -ExecutionPolicy Bypass -File ".\build.ps1"
```

## Extending the Converters

### Common Pattern

All converters follow this pattern:

```python
#!/usr/bin/env python3
"""Convert [DATA_TYPE] JSON to .pasm format."""

import json
from pathlib import Path

def safe_int(val, default=0):
    """Safely convert value to int."""
    if val is None:
        return default
    if isinstance(val, int):
        return val
    if isinstance(val, str):
        if val.startswith('0x'):
            try:
                return int(val, 16)
            except ValueError:
                return default
        try:
            return int(val)
        except ValueError:
            return default
    return default

# 1. Define input/output paths
json_path = Path("path/to/data.json")
output_pasm = Path("src/data/output.pasm")

# 2. Load JSON
with open(json_path) as f:
    data = json.load(f)

items = data.get("items", [])

# 3. Generate .pasm
pasm_lines = [
    f"; {len(items)} items",
    f"ITEM_COUNT = ${len(items):02x}",
    "",
    "ITEM_TABLE:",
]

for item in items:
    # Convert JSON to .pasm
    pasm_lines.append(f"item_{item['id']:02x}: .byte ...")

# 4. Write output
output_pasm.parent.mkdir(parents=True, exist_ok=True)
with open(output_pasm, 'w') as f:
    f.write('\n'.join(pasm_lines))

print(f"Wrote {output_pasm}")
```

## Testing & Debugging

### 1. Verify ROM Builds
```bash
pwsh build.ps1
# Check for ✓ symbols in output
```

### 2. Check Generated .pasm
```bash
Get-Content src/data/monsters_dw4.pasm | Select-Object -First 20
```

### 3. View Assembly Listings
```bash
Get-Content build/listings/main.lst | Select-Object -First 100
```

### 4. Load in Mesen2 Debugger
```bash
# Open ROM
mesen2 build/dq4r.sfc

# Load symbols
Tools → Debugger → Load Symbol File → build/dq4r.sym

# Browse data tables in debugger
```

## Performance Notes

### Current ROM Size
- **Total:** 64 KB
- **Monster data:** ~400 bytes (50 × 8)
- **Item data:** ~256 bytes (128 × 2)
- **Shop data:** ~360 bytes (180 × 2)
- **Spell data:** ~300 bytes (50 × 6)
- **Encounters data:** ~42 KB (7005 × 6)
- **Characters data:** ~32 bytes (16 × 2)

### Expansion Strategy
For larger data sets (maps, text):
- Use SNES banking (up to 6 MB ROM)
- Implement address mapping for data access
- Consider data compression (LZSS, RLE)

## File Organization

```
dq4r-info/
├── src/
│   ├── main.pasm
│   ├── engine/
│   │   ├── core.pasm
│   │   ├── input.pasm
│   │   └── scheduler.pasm
│   └── data/
│       ├── monsters_dw4.pasm
│       ├── items_dw4.pasm
│       ├── shops_dw4.pasm
│       ├── spells_dw4.pasm
│       ├── encounters_dw4.pasm
│       └── characters_dw4.pasm
├── tools/
│   ├── json_to_pasm.py
│   ├── items_shops_simple.py
│   ├── spells_converter.py
│   ├── encounters_converter.py
│   ├── characters_converter.py
│   └── verify_rom_data.py
├── build/
│   ├── dq4r.sfc
│   ├── dq4r.sym
│   └── listings/
└── build.ps1
```

## Next Steps

Priority order for extending DQ4r:

1. **Maps** - Requires decompression logic, ~16 KB data
2. **Text/Dialogue** - 641+ strings with encoding, ~8-16 KB
3. **Tilesets** - Graphics data, requires 2bpp conversion
4. **Audio** - NSF extraction and conversion
5. **Palettes** - Color definitions for graphics
6. **Equipment Stats** - Armor/weapon definitions
7. **Spell Effects** - Battle formula implementations

---

**Last Updated:** 2025-01-XX  
**Status:** ✅ Functional for 7400+ records (monsters, items, shops, spells, encounters, characters)
