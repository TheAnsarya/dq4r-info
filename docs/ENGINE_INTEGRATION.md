# DQ4r Engine Integration (DQ3r Base)

## Overview
This project uses the DQ3r engine as the core runtime while bringing in Dragon Warrior IV data/content. The goal is to leverage DQ3r's proven scheduling, input, and scene management patterns and adapt them to DW4 assets.

## Strategy
- **Engine Base (DQ3r)**: Input, scheduler, vblank loop, scene transitions
- **Content (DW4)**: Data tables (items, spells, monsters), maps, text
- **Bridging**: Adapters that translate DW4 data formats into DQ3r engine structures

## Initial Skeleton
- `src/engine/core.pasm`: `engine_init`, `engine_tick`, `engine_vblank`
- `src/engine/input.pasm`: `read_input` stub
- `src/main.pasm`: Calls `engine_init`, `read_input`, `engine_tick`, and runs `engine_vblank` in NMI

## Next Steps
- Map DW4 data tables into WRAM structures
- Implement scheduler and scene stubs mirroring DQ3r
- Add PPU init and a simple test scene (title or static BG)
- Confirm NMI tick increments and input sampling in emulator

## References
- dq3r-info: analysis and engine patterns
- dragon-warrior-4-info: asset structure and data formats
