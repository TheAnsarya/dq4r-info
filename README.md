# Dragon Quest IV Remix (DQ4r)

A SNES port of Dragon Warrior IV (NES) using the DQ3r engine.

## Project Status

🔴 **Phase 0: Pre-Production** - Research and planning

## Overview

DQ4r aims to recreate Dragon Warrior IV on the SNES platform, utilizing the Dragon Quest III Remake (DQ3r) engine as a foundation. This project ports the NES game's content while taking advantage of SNES hardware capabilities.

## Goals

- Faithful recreation of all Dragon Warrior IV content
- SNES-quality graphics (4bpp tiles, Mode 7 where appropriate)
- Enhanced audio using SPC700
- Improved translation incorporating modern localization
- Quality-of-life improvements (faster text, dash, etc.)

## Repository Structure

```
dq4r-info/
├── src/               # 65816 Assembly source
│   ├── main.asm       # Main entry point
│   ├── includes/      # Common includes
│   ├── engine/        # Core engine (from DQ3r)
│   ├── chapters/      # Chapter-specific code
│   └── data/          # Game data includes
├── assets/            # Source assets
│   ├── graphics/      # PNG/BMP source graphics
│   ├── audio/         # Music/SFX sources
│   ├── text/          # JSON dialog/text
│   └── maps/          # Map data
├── tools/             # Build tools
├── docs/              # Documentation
└── build/             # Build output (gitignored)
```

## Building

*Build instructions TBD*

## Related Projects

- [dragon-warrior-4-info](https://github.com/TheAnsarya/dragon-warrior-4-info) - DW4 NES analysis and documentation
- [dq3r-info](https://github.com/TheAnsarya/dq3r-info) - DQ3r SNES project (engine source)
- [logsmall](https://github.com/TheAnsarya/logsmall) - C# tools for asset conversion

## License

TBD

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
