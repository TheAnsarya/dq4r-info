# Dragon Quest IV Remix (DQ4r)

A SNES port of Dragon Warrior IV (NES) using the DQ3r engine.

## Project Status

� **Phase 0: Pre-Production** - Foundation & planning

## Quick Links

- 📋 **[Project Plan](docs/PROJECT_PLAN.md)** - Detailed roadmap, phases, and timeline
- 🏗️ **[Architecture](docs/ARCHITECTURE.md)** - System design and technical documentation
- 🔨 **[Build Guide](docs/BUILD_GUIDE.md)** - How to build the ROM
- 🎯 **[GitHub Issues Spec](docs/GITHUB_ISSUES.md)** - List of all planned issues (21 total)

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

## Current Phase: Foundation

### What's Being Done
1. **Build System Setup** - Integrating Poppy (custom SNES assembler)
2. **Documentation** - Architecture, technical design, roadmap
3. **Asset Pipeline** - Tools for converting graphics and data
4. **Roundtrip Workflow** - Disassembly and reassembly tools

### Next Steps
- Create GitHub issues for all 21 planned tasks
- Set up Poppy compiler integration
- Implement ROM bootstrap code
- Create test ROM with graphics/sound

## Building (Future)

```powershell
# Build from source
.\build.ps1

# Build with Poppy compiler
dotnet run --project ../poppy/src/Poppy.Cli -- assemble src/main.asm -o build/dq4r.sfc
```

## Project Timeline

| Phase | Duration | Status | Deliverable |
|-------|----------|--------|-------------|
| **M1: Foundation** | Weeks 1-3 | Planning | Build system, documentation |
| **M2: Engine Core** | Weeks 4-9 | Planned | Test ROM with graphics/sound |
| **M3: Gameplay** | Weeks 10-15 | Planned | Core mechanics |
| **M4: Content** | Weeks 16-23 | Planned | Full game playable |
| **M5: Testing** | Weeks 24-27 | Planned | Release-ready ROM |

**Total Estimated**: 6-9 months (part-time development)

## Contributing

This is a solo project at the moment, but contributions are planned to be organized via GitHub Issues.

**Current Work**:
- [ ] Create 21 GitHub issues (see [GITHUB_ISSUES.md](docs/GITHUB_ISSUES.md))
- [ ] Set up Poppy integration
- [ ] Implement bootstrap code
- [ ] Create graphics test ROM

## Technical Stack

- **Assembler**: Poppy (custom .NET 10 65816 compiler)
- **Disassembler**: Peony (for roundtrip workflows)
- **Target**: SNES (65816, LoROM 4MB ROM + 8KB SRAM)
- **Build Tools**: PowerShell, Python 3.11+
- **Testing**: Mesen2, Snes9x

## Related Projects

- [dragon-warrior-4-info](https://github.com/TheAnsarya/dragon-warrior-4-info) - DW4 NES analysis and documentation
- [dq3r-info](https://github.com/TheAnsarya/dq3r-info) - DQ3r SNES project (engine reference)
- [logsmall](https://github.com/TheAnsarya/logsmall) - C# tools for asset conversion
- [poppy](https://github.com/TheAnsarya/poppy) - SNES 65816 assembler
- [peony](https://github.com/TheAnsarya/peony) - Multi-system disassembler

## License

Unlicensed - This is a ROM hack project for educational and preservation purposes.

## License

TBD

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
