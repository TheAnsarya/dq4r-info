# 🐉 Dragon Quest IV Remix (DQ4r) - SNES ROM Hack

**Status:** 🟢 **Active Development**  
**ROM Built:** ✅ 64 KB SNES LoROM with 7,400+ game records  
**Framework:** Poppy .NET 10 Assembler + Python data pipeline

## Overview

DQ4r is a modernized SNES remix of **Dragon Warrior IV (NES)** running on the DQ3 SNES engine framework. This project demonstrates a complete ROM hacking pipeline:

- **Extract** DW4 game data from pre-extracted JSON assets
- **Convert** to SNES-compatible formats via Python utilities
- **Assemble** into a working SNES ROM using Poppy
- **Extend** with new mechanics and features

### Current Features

✅ **Game Data Integration:**
- 50 Monsters with stats (HP, EXP, Gold, ATK, DEF, AGI)
- 128 Items with prices and types
- 180 Shop configurations
- 50 Spells with MP costs and effects
- 7,005 Monster encounter groups (for 73+ maps)
- 16 Playable characters (8 party + 8 companions)

✅ **Build System:**
- Automated ROM compilation via PowerShell
- Symbol file generation for debugging
- Assembly listings for verification
- Git-tracked development history

## Quick Start

### Build the ROM

```bash
cd C:\Users\me\source\repos\dq4r-info
pwsh -NoProfile -ExecutionPolicy Bypass -File ".\build.ps1"
```

**Output:** `build/dq4r.sfc` (64 KB SNES ROM)

### Test in Emulator

```bash
# Using Mesen2 (with debugger symbols)
mesen2 build/dq4r.sfc

# Using Snes9x
snes9x build/dq4r.sfc
```

## Project Structure

```
dq4r-info/
├── README.md                           # This file
├── ROM_INTEGRATION_SUMMARY.md          # Integration achievements & stats
├── DATA_CONVERTER_GUIDE.md             # How to extend with new data
├── build.ps1                           # Build automation script
│
├── src/                                # SNES assembly source
│   ├── main.pasm                       # Boot code, NMI/VBlank handlers
│   ├── engine/
│   │   ├── core.pasm                   # Engine initialization
│   │   ├── input.pasm                  # Joypad handling
│   │   └── scheduler.pasm              # Frame scheduler (stub)
│   └── data/                           # Game data tables (.pasm)
│       ├── monsters_dw4.pasm           # 50 monsters × 8 bytes
│       ├── items_dw4.pasm              # 128 items
│       ├── shops_dw4.pasm              # 180 shops
│       ├── spells_dw4.pasm             # 50 spells × 6 bytes
│       ├── encounters_dw4.pasm         # 7005 encounters × 6 bytes
│       └── characters_dw4.pasm         # 16 characters × 2 bytes
│
├── tools/                              # Python data converters
│   ├── json_to_pasm.py                 # Monster JSON → .pasm
│   ├── items_shops_simple.py           # Items/shops JSON → .pasm
│   ├── spells_converter.py             # Spells JSON → .pasm
│   ├── encounters_converter.py         # Encounters JSON → .pasm
│   ├── characters_converter.py         # Characters JSON → .pasm
│   └── verify_rom_data.py              # ROM data verification
│
├── build/                              # Build outputs
│   ├── dq4r.sfc                        # Compiled ROM (64 KB)
│   ├── dq4r.sym                        # Debug symbol file
│   ├── dq4r.map                        # Memory map
│   └── listings/                       # Assembly listings (.lst files)
│
└── roms/                               # Input ROMs (not in repo)
    └── Dragon Warrior IV (1992-10)(Enix)(US).nes
```

## Data Integration Pipeline

### Overview

```
DW4 NES ROM (512 KB)
    ↓ (Pre-extraction complete)
JSON Assets (/dragon-warrior-4-info/assets/json/)
    ↓ (Python converters)
.pasm Data Files (/src/data/)
    ↓ (Poppy assembly)
SNES ROM (64 KB) ← dq4r.sfc
```

### Data Statistics

| Data Type | Count | Bytes | .pasm Lines |
|-----------|-------|-------|-------------|
| Monsters | 50 | 400 | 509 |
| Items | 128 | 256 | 131 |
| Shops | 180 | 360 | 183 |
| Spells | 50 | 300 | 60 |
| Encounters | 7,005 | 42,030 | 7,008 |
| Characters | 16 | 32 | 19 |
| **TOTAL** | **7,429** | **43,378** | **7,910** |

## Roadmap

### Phase 1: ✅ Foundation (Complete)
- [x] Monster data integration
- [x] Item/shop data integration  
- [x] Spell data integration
- [x] Encounter system (7000+ groups)
- [x] Character roster
- [x] Build automation

### Phase 2: 🔄 Map System (In Progress)
- [ ] Extract 73+ maps from DW4
- [ ] Convert metatile format for SNES
- [ ] Generate world map layout
- [ ] Implement collision detection

### Phase 3: 📝 Text & Dialogue (Planned)
- [ ] Extract 641+ strings from DW4
- [ ] Convert encoding to SNES format
- [ ] Integrate dialogue engine
- [ ] Add script support

### Phase 4: 🎨 Graphics & Tileset (Planned)
- [ ] Extract CHR-ROM tiles from DW4
- [ ] Convert to 2bpp/4bpp SNES format
- [ ] Create metatile definitions
- [ ] Add palette support

### Phase 5: 🎵 Audio (Optional)
- [ ] Extract NSF music from DW4
- [ ] Convert to SNES audio format
- [ ] Implement sound driver

## Development Workflow

### Building & Testing

```bash
# 1. Generate data files from JSON
python tools/json_to_pasm.py
python tools/items_shops_simple.py
python tools/spells_converter.py
python tools/encounters_converter.py
python tools/characters_converter.py

# 2. Build ROM
pwsh build.ps1

# 3. Check output
Test-Path build/dq4r.sfc         # ROM exists?
Test-Path build/dq4r.sym         # Symbols exist?
Get-ChildItem build/listings/     # Listings generated?

# 4. Test in emulator
mesen2 build/dq4r.sfc            # Load in debugger
```

### Adding New Data

See [DATA_CONVERTER_GUIDE.md](./DATA_CONVERTER_GUIDE.md) for complete documentation on:
- How each converter works
- Pattern for creating new converters
- Testing and debugging techniques

## Documentation

- 📄 [ROM_INTEGRATION_SUMMARY.md](./ROM_INTEGRATION_SUMMARY.md) - Integration achievements & statistics
- 📄 [DATA_CONVERTER_GUIDE.md](./DATA_CONVERTER_GUIDE.md) - How to extend with new game data
- 📄 [build.ps1](./build.ps1) - Build automation script

## Technical Details

### ROM Format

- **System:** SNES (Super Famicom)
- **Mapper:** LoROM (16 MB addressable, 6 MB max ROM)
- **Size:** 64 KB (current), expandable to 256+ KB with banking
- **Entry Point:** $8000 (reset handler)

### Assembly Language

Using **Poppy** `.pasm` syntax (SNES-specific assembler):
```pasm
.system:snes              ; SNES target
lorom                     ; LoROM mapping

.include "engine/core.pasm"  ; Modular includes

reset:                    ; Code label
	sei                   ; Disable interrupts
	rep #$30              ; 16-bit A/X/Y
	jsr engine_init       ; Call engine
```

## Contributing

To extend DQ4r:

1. **Extract new data:**
   - Place JSON in `/dragon-warrior-4-info/assets/json/`
   - Create Python converter in `tools/`
   - Generate `.pasm` data file
   - Add `.include` to `src/main.pasm`

2. **Implement game logic:**
   - Add `.pasm` files to `src/engine/`
   - Call from main event loop
   - Test with Mesen2 debugger

3. **Update documentation:**
   - Document data structures
   - Add usage examples
   - Update this README

4. **Commit changes:**
   ```bash
   git add .
   git commit -m "feat: [Description of what was added]"
   git push
   ```

## References

- **Poppy Assembler:** [../poppy/](../poppy/) - .NET 10 SNES assembler
- **DW4 Data Source:** [../dragon-warrior-4-info/](../dragon-warrior-4-info/) - Complete DW4 disassembly & extraction
- **DQ3r Base:** [../dq3r-info/](../dq3r-info/) - DQ3 SNES ROM documentation
- **GameInfo:** [../GameInfo/](../GameInfo/) - Complete ROM hacking toolkit
- **logsmall:** [../logsmall/](../logsmall/) - C# game analysis libraries

## Support

For issues or questions:
1. Check [ROM_INTEGRATION_SUMMARY.md](./ROM_INTEGRATION_SUMMARY.md) for achievements
2. Review [DATA_CONVERTER_GUIDE.md](./DATA_CONVERTER_GUIDE.md) for extending
3. Load ROM in Mesen2 with `build/dq4r.sym` for debugging
4. Check `build/listings/` for assembly output

---

**Last Updated:** January 2025  
**Built By:** GitHub Copilot (AI Coding Agent)  
**Status:** 🟢 Functional ROM with 7,400+ game records
