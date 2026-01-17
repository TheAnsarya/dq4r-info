# Dragon Quest IV Remix - Project Plan

## Overview

**Project**: Dragon Quest IV Remix (DQ4r)  
**Target Platform**: SNES (65816 architecture)  
**Engine Base**: Dragon Quest III Remake (DQ3r) - to be backported  
**Game Source**: Dragon Warrior IV (NES) / Dragon Quest IV (Famicom)  
**Status**: 🔴 Phase 0 - Pre-Production

## Project Goals

### Primary Objectives
1. Port Dragon Warrior IV from NES to SNES using DQ3r engine
2. Enhance graphics with 4bpp SNES capabilities
3. Improve audio with SPC700 sound synthesis
4. Modern localization with improved English translation
5. Quality-of-life improvements (speed up, dash, convenience features)

### Technical Goals
1. Establish roundtrip workflow (disassemble → modify → reassemble)
2. Create comprehensive asset extraction pipeline
3. Build modular engine compatible with DQ4's unique features
4. Implement bank-switching strategy (likely F8 or F6)
5. Create tools for automated ROM generation

## Project Phases

### Phase 0: Foundation (Current)
- [ ] Set up build infrastructure (Poppy compiler)
- [ ] Establish roundtrip disassembly workflow
- [ ] Create asset extraction framework
- [ ] Document DW4 engine and data structures
- [ ] Plan engine modifications needed from DQ3r
- **Est. Duration**: 2-3 weeks

### Phase 1: Engine Core
- [ ] Backport DQ3r engine to SNES architecture
- [ ] Implement 6-character party system (vs DW4's 4 + recruits)
- [ ] Create game state management
- [ ] Implement save/load system
- [ ] Build title screen and menu system
- **Est. Duration**: 4-6 weeks

### Phase 2: Gameplay Features
- [ ] Character status and equipment systems
- [ ] Combat system (turn-based battle engine)
- [ ] Magic and special abilities
- [ ] Monster AI system
- [ ] Experience/level system
- **Est. Duration**: 4-6 weeks

### Phase 3: Content Integration
- [ ] Story and dialogue system
- [ ] Map layout and navigation
- [ ] Dungeon and town layouts
- [ ] NPC systems and interactions
- [ ] Event scripting system
- **Est. Duration**: 6-8 weeks

### Phase 4: Enhancement
- [ ] SNES graphics improvements
- [ ] Custom sprite animations
- [ ] Mode 7 effects (world map)
- [ ] SPC audio implementation
- [ ] UI polish and refinement
- **Est. Duration**: 4-6 weeks

### Phase 5: Content
- [ ] All chapters implementation
- [ ] All monsters and items
- [ ] All spells and special abilities
- [ ] Full dialogue and story
- [ ] Localization and translation
- **Est. Duration**: 8-10 weeks

### Phase 6: Testing & Release
- [ ] Comprehensive testing
- [ ] Bug fixes and optimization
- [ ] Performance tuning
- [ ] Final polish
- [ ] Documentation
- **Est. Duration**: 2-4 weeks

## Technical Architecture

### Build System
- **Compiler**: Poppy (custom .NET 10 assembler)
- **Target**: SNES LoROM, FastROM variant
- **ROM Size**: 4 MB (bank 00-3F for code, 40-7F for graphics/data)
- **RAM**: 128 KB (system + game)
- **Video RAM**: 64 KB (background/sprite data)

### Memory Map
```
$000000 - $007FFF: System ROM (vectors, constants)
$008000 - $00FFFF: Bank 00 (reset, main engine)
$010000 - $1FFFFF: Banks 01-1F (code)
$200000 - $3FFFFF: Banks 20-3F (graphics, tables)

WRAM: $000000 - $01FFFF (128 KB)
VRAM: $000000 - $0FFFF (64 KB)
CGRAM: $000000 - $01FF (512 bytes palette)
OAM: $000000 - $01FF (sprite data)
```

### Key Modules
1. **Graphics Engine**
   - 8x8 tile rendering
   - 16x16 metatile system
   - Sprite management (256 sprites max)
   - Mode 7 for world map
   
2. **Sound Engine**
   - SPC700 sound driver
   - Music sequencing
   - SFX playback
   
3. **Game Engine**
   - State machine
   - Event system
   - Script interpreter
   - Save/load manager
   
4. **Combat System**
   - Turn-based battle resolution
   - Damage calculation
   - Magic effects
   - Monster AI
   
5. **Data Systems**
   - Monster definitions
   - Item database
   - Magic/ability database
   - Map data
   - NPC data

## Dependencies & Related Projects

### Required
- **Poppy**: SNES 65816 assembler (TheAnsarya/poppy)
- **Peony**: Disassembler for roundtrip workflows (TheAnsarya/peony)
- **GameInfo**: Asset extraction and tools (TheAnsarya/GameInfo)

### Reference
- **dq3r-info**: DQ3r SNES analysis and tools (TheAnsarya/dq3r-info)
- **dragon-warrior-4-info**: DW4 NES analysis (TheAnsarya/dragon-warrior-4-info)
- **logsmall**: C# build tools (TheAnsarya/logsmall)

## Asset Requirements

### Graphics
- Character sprites (32 total: 8 base + variants)
- Monster sprites (60+ unique monsters)
- World map graphics
- Dungeon/town tiles
- UI graphics (menus, dialogs, status screens)

### Audio
- Title theme
- Field music (10+ variations)
- Battle music
- Boss music (4+ variations)
- Shop/town music
- SFX (100+ sound effects)

### Data
- Monster stats and abilities
- Item database
- Magic/spell database
- NPC dialogue
- Map layouts
- Event scripts

## Success Criteria

### Minimum Viable Product (MVP)
- [ ] Playable game with all 4 chapters
- [ ] All mandatory party members
- [ ] All unique monsters from original
- [ ] Core combat system
- [ ] Save/load functionality
- [ ] English dialogue

### Full Release
- [ ] All 5 chapters (including DW4-exclusive content)
- [ ] All 6-character party system fully utilized
- [ ] Enhanced graphics
- [ ] Complete SPC audio
- [ ] All quality-of-life features
- [ ] Comprehensive documentation

## Risks & Mitigation

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| Engine too large for 4MB ROM | Medium | Critical | Implement compression, banked data loading |
| DQ3r engine incompatible | Low | High | Design modular engine, use as reference only |
| Sound synthesis complexity | Medium | Medium | Start with simple SPC700, iterate |
| Testing coverage insufficient | High | Medium | Automated testing, emulator testing |
| Team burnout (solo project) | High | Medium | Milestone-based breaks, scope control |

## Timeline Estimate

**Total Project Duration**: 26-37 weeks (~6-9 months)

Assuming part-time development (10-15 hours/week):
- Realistic completion: 12-15 months
- Conservative estimate: 18-20 months

## Success Metrics

- [ ] Compiles successfully to valid SNES ROM
- [ ] Runs in emulator without crashes
- [ ] All game systems functional
- [ ] Gameplay matches or exceeds original NES version
- [ ] Community feedback positive
- [ ] Documentation complete

## File Structure (Target)

```
dq4r-info/
├── src/
│   ├── main.asm
│   ├── includes/
│   │   ├── defines.asm
│   │   ├── macros.asm
│   │   └── hardware.asm
│   ├── engine/
│   │   ├── core.asm
│   │   ├── graphics.asm
│   │   ├── sound.asm
│   │   ├── input.asm
│   │   └── state.asm
│   ├── game/
│   │   ├── battle.asm
│   │   ├── menus.asm
│   │   ├── world.asm
│   │   ├── dungeons.asm
│   │   └── npc.asm
│   ├── chapters/
│   │   ├── chapter1.asm
│   │   ├── chapter2.asm
│   │   ├── chapter3.asm
│   │   ├── chapter4.asm
│   │   └── chapter5.asm
│   └── data/
│       ├── monsters.asm
│       ├── items.asm
│       ├── spells.asm
│       ├── maps.asm
│       └── dialogue.asm
├── assets/
│   ├── graphics/
│   ├── audio/
│   ├── text/
│   └── maps/
├── tools/
│   ├── build.ps1
│   ├── extract_assets.py
│   ├── test_rom.ps1
│   └── generate_docs.py
├── docs/
│   ├── PROJECT_PLAN.md (this file)
│   ├── ARCHITECTURE.md
│   ├── ASSET_PIPELINE.md
│   ├── BUILD_GUIDE.md
│   └── API_REFERENCE.md
├── tests/
│   ├── unit/
│   └── integration/
└── build/
    └── dq4r.sfc (target output)
```

## Next Steps

1. **Create GitHub Issues** (21 issues across 5 milestones)
2. **Set up build system** with Poppy compiler
3. **Establish roundtrip workflow** (Peony disasm → Poppy assemble)
4. **Extract DW4 engine** from NES ROM using Peony
5. **Begin engine architecture documentation**

