# DQ4r GitHub Issues Specification

This document lists all planned GitHub issues for the DQ4r project with issue numbers and descriptions.

## Epic 1: Foundation & Setup

### Issue #1: Set up Poppy Compiler Integration
**Type**: Feature  
**Priority**: Critical  
**Milestone**: Foundation (M1)

**Description**:
Set up integration with the Poppy custom SNES 65816 assembler for building DQ4r ROMs.

**Acceptance Criteria**:
- [x] Poppy repository cloned/referenced
- [x] build.ps1 script created with Poppy integration
- [x] Test ROM compiles successfully
- [x] Symbol generation working
- [x] Build artifacts in gitignore

**Tasks**:
- Verify Poppy supports `.system:snes`
- Create build.ps1 with Poppy invocation
- Test compile of existing main.asm
- Add build output validation
- Document build process

**Status**:
- Build system implemented and verified with first successful ROM (32 KB)
- Poppy CLI auto-discovery and compilation working
- Listings and symbols generated to `build/`

**Related**: #2, #3

---

### Issue #2: Create Asset Processing Pipeline
**Type**: Feature  
**Priority**: High  
**Milestone**: Foundation (M1)

**Description**:
Build automated pipeline for extracting, converting, and embedding game assets (graphics, data, audio) into the ROM.

**Acceptance Criteria**:
- [ ] Asset directory structure defined
- [ ] PNG → CHR conversion working
- [ ] JSON → assembly data conversion
- [ ] Auto-generated assembly files included in build
- [ ] Compression support for large assets

**Tasks**:
- Create tools/extract_assets.py
- Implement PNG tile extraction (8x8)
- Create JSON → asm converter
- Add asset validation
- Document asset formats

**Related**: #4, #5

---

### Issue #3: Establish Roundtrip Disassembly Workflow
**Type**: Feature  
**Priority**: High  
**Milestone**: Foundation (M1)

**Description**:
Create workflow to disassemble existing DW4 NES or DQ4 Famicom ROM, analyze it, and enable reassembly with modifications using Peony + Poppy.

**Acceptance Criteria**:
- [ ] Peony disassembles target ROM without errors
- [ ] Labels generated for all branch targets
- [ ] Disassembly reassembles to identical ROM
- [ ] Bank switching directives correctly applied
- [ ] Documentation of workflow complete

**Tasks**:
- Use Peony to disassemble DW4 NES
- Verify label coverage
- Test reassembly with Poppy
- Document roundtrip process
- Create test script

**Related**: #1, #2

---

### Issue #4: Create Comprehensive Documentation
**Type**: Documentation  
**Priority**: High  
**Milestone**: Foundation (M1)

**Description**:
Create all necessary documentation for DQ4r including architecture, API reference, build guide, and developer guide.

**Acceptance Criteria**:
- [ ] PROJECT_PLAN.md complete
- [ ] ARCHITECTURE.md complete
- [ ] BUILD_GUIDE.md complete
- [ ] API_REFERENCE.md complete
- [ ] README.md updated with links
- [ ] All docs accessible from main README

**Tasks**:
- Write architecture overview
- Document memory layout
- Create coding standards
- Build guide with examples
- API reference generation script

**Related**: #1, #2, #3

---

## Epic 2: Core Engine

### Issue #5: Implement Bootstrap & Initialization
**Type**: Feature  
**Priority**: Critical  
**Milestone**: Engine Core (M2)

**Description**:
Implement ROM bootstrap code including SNES header, vectors, and initialization routines.

**Acceptance Criteria**:
- [ ] Valid SNES ROM header generated
- [ ] All vectors populated correctly
- [ ] Reset handler initializes hardware
- [ ] CPU/PPU/APU configured
- [ ] WRAM cleared on startup
- [ ] Boots in Mesen2 without errors

**Tasks**:
- Create ROM header with proper metadata
- Implement vector table
- Write Reset handler
- PPU initialization routine
- APU initialization routine
- WRAM clear routine

**Related**: #1, #6, #7

---

### Issue #6: Implement Main Game Loop
**Type**: Feature  
**Priority**: Critical  
**Milestone**: Engine Core (M2)

**Description**:
Create the core game loop that drives all gameplay: input handling, game state updates, graphics rendering, and audio.

**Acceptance Criteria**:
- [ ] V-Blank detection working
- [ ] Main loop runs at 60 Hz
- [ ] Input buffer functional
- [ ] State update framework in place
- [ ] Graphics update queue functional
- [ ] Audio queue functional

**Tasks**:
- Implement V-Blank wait routine
- Create main loop structure
- Input buffering system
- Game state update dispatcher
- Graphics DMA queue
- Audio command queue

**Related**: #5, #7, #8, #9, #10

---

### Issue #7: Graphics Engine - Tile Rendering
**Type**: Feature  
**Priority**: High  
**Milestone**: Engine Core (M2)

**Description**:
Implement SNES background layer rendering with support for 8x8 tiles and 16x16 metatiles.

**Acceptance Criteria**:
- [ ] Tile data loaded to VRAM
- [ ] Background layers 1/2/3 configurable
- [ ] Metatile system functional (16x16)
- [ ] Palette swapping working
- [ ] Smooth scrolling support
- [ ] Test ROM displays colored squares

**Tasks**:
- Create tile upload routine
- Implement metatile decompression
- BG mode 1 setup
- Tile map management
- Palette system implementation
- Scrolling calculation

**Related**: #6, #8, #9

---

### Issue #8: Graphics Engine - Sprite Management
**Type**: Feature  
**Priority**: High  
**Milestone**: Engine Core (M2)

**Description**:
Implement sprite rendering system with support for up to 128 objects with animation and flipping.

**Acceptance Criteria**:
- [ ] OAM upload working
- [ ] 128 objects manageable
- [ ] X/Y positioning correct
- [ ] Sprite flipping (H/V) working
- [ ] Object size variants supported
- [ ] Test ROM shows animated sprite

**Tasks**:
- OAM management routines
- Sprite positioning system
- Flipping flag support
- Object size selection
- Animation frame calculation
- DMA for OAM updates

**Related**: #6, #7, #9

---

### Issue #9: Input System Implementation
**Type**: Feature  
**Priority**: High  
**Milestone**: Engine Core (M2)

**Description**:
Implement joypad input reading with debouncing, press detection, and NES-compatible button mapping.

**Acceptance Criteria**:
- [ ] Joypad1 reading every frame
- [ ] Debouncing functional
- [ ] Press vs. hold detection
- [ ] NES-compatible button mapping
- [ ] Multi-button combos supported
- [ ] Test ROM shows input feedback

**Tasks**:
- Joypad read routine
- Input state buffer
- Press detection logic
- Button mapping definition
- Combo detection
- Debug input display

**Related**: #6, #11, #12

---

### Issue #10: Sound Driver Integration
**Type**: Feature  
**Priority**: Medium  
**Milestone**: Engine Core (M2)

**Description**:
Integrate SPC700 sound driver for music and sound effects playback.

**Acceptance Criteria**:
- [ ] SPC loader functional
- [ ] Music playback working
- [ ] Sound effect system
- [ ] Volume control
- [ ] Fade in/out effects
- [ ] Test ROM plays sound

**Tasks**:
- SPC loader implementation
- IPL boot code
- Driver communication protocol
- Music queue system
- SFX priority system
- Volume/pan control

**Related**: #6, #5

---

## Epic 3: Game Systems

### Issue #11: Game State Management System
**Type**: Feature  
**Priority**: High  
**Milestone**: Gameplay Features (M3)

**Description**:
Create game state data structures and management for characters, inventory, flags, and global game data.

**Acceptance Criteria**:
- [ ] Game state structures defined
- [ ] Character data system working
- [ ] Inventory system functional
- [ ] Flag/switch management
- [ ] Save state support ready
- [ ] Memory layout optimized

**Tasks**:
- Define game state structures
- Character data management
- Inventory system implementation
- Flag/switch system
- Save state preparation
- Memory usage documentation

**Related**: #6, #12, #13, #14

---

### Issue #12: Save/Load System
**Type**: Feature  
**Priority**: High  
**Milestone**: Gameplay Features (M3)

**Description**:
Implement save and load functionality using cartridge SRAM with compression and validation.

**Acceptance Criteria**:
- [ ] Save to SRAM working
- [ ] Load from SRAM working
- [ ] Multiple save slots (3+)
- [ ] Save validation (checksum)
- [ ] Compression reduces save size
- [ ] Load time <1 second

**Tasks**:
- SRAM access routines
- Save format definition
- Compression algorithm
- Checksum validation
- Multiple slot management
- Load verification

**Related**: #11, #13

---

### Issue #13: Battle System Implementation
**Type**: Feature  
**Priority**: Critical  
**Milestone**: Gameplay Features (M3)

**Description**:
Implement core turn-based battle engine including combat calculations, magic, items, and AI.

**Acceptance Criteria**:
- [ ] Battle mode initialization
- [ ] Command menu system
- [ ] Turn order calculation (by agility)
- [ ] Physical damage calculation
- [ ] Magic damage calculation
- [ ] Item usage in battle
- [ ] Status effects applied
- [ ] Win/loss conditions
- [ ] EXP and item rewards
- [ ] Battle test ROM working

**Tasks**:
- Battle state machine
- Command menu interface
- Turn order system
- Damage calculation engine
- Magic system
- Item effects
- Status effect system
- AI routines
- Reward distribution

**Related**: #6, #11, #14, #15

---

### Issue #14: Menu System
**Type**: Feature  
**Priority**: High  
**Milestone**: Gameplay Features (M3)

**Description**:
Create menus for status, equipment, items, magic, and save/load accessed from the game world.

**Acceptance Criteria**:
- [ ] Status menu shows character info
- [ ] Equipment menu allows equipping
- [ ] Item menu for consumables
- [ ] Magic menu for spell casting
- [ ] Save menu functional
- [ ] Load menu functional
- [ ] Menu animations smooth
- [ ] Test ROM shows all menus

**Tasks**:
- Menu framework system
- Status display routines
- Equipment management
- Item management
- Magic selection
- Save/load menus
- Menu navigation
- Text rendering in menus

**Related**: #6, #11, #12, #13

---

### Issue #15: NPC & Dialogue System
**Type**: Feature  
**Priority**: High  
**Milestone**: Gameplay Features (M3)

**Description**:
Implement NPC interaction system with dialogue, quest triggers, and event scripting.

**Acceptance Criteria**:
- [ ] NPC detection and interaction
- [ ] Text rendering system
- [ ] Dialogue scripting language
- [ ] Event triggering working
- [ ] Quest flags functional
- [ ] Character name substitution
- [ ] Test ROM shows NPCs

**Tasks**:
- NPC data structure
- Collision detection
- Dialogue text system
- Script interpreter
- Event triggering
- Flag management
- Text box rendering

**Related**: #6, #11, #16, #17

---

## Epic 4: Content & Features

### Issue #16: Map System & World Navigation
**Type**: Feature  
**Priority**: High  
**Milestone**: Content Integration (M4)

**Description**:
Create map loading, world navigation, party movement, and dungeon exploration systems.

**Acceptance Criteria**:
- [ ] Map data format defined
- [ ] Map loading working
- [ ] Party movement responsive
- [ ] Collision detection working
- [ ] Town/dungeon transitions smooth
- [ ] Test ROM shows playable maps

**Tasks**:
- Map data format specification
- Map loading routines
- Character position tracking
- Movement system
- Collision system
- Map transition handling
- Warp system

**Related**: #6, #7, #15, #17

---

### Issue #17: Monster & Enemy System
**Type**: Feature  
**Priority**: High  
**Milestone**: Content Integration (M4)

**Description**:
Create monster definitions, data tables, and encounter system for random and scripted battles.

**Acceptance Criteria**:
- [ ] Monster data structure defined
- [ ] 60+ monsters implemented
- [ ] Monster graphics loaded
- [ ] Encounter system working
- [ ] Boss encounter scripting
- [ ] Monster AI implemented

**Tasks**:
- Monster data structure
- Monster stat extraction
- Sprite loading system
- Encounter table creation
- Random encounter algorithm
- Boss encounter scripting
- Monster ability implementation

**Related**: #13, #15, #18, #19

---

### Issue #18: Character & Leveling System
**Type**: Feature  
**Priority**: High  
**Milestone**: Content Integration (M4)

**Description**:
Implement character definitions, leveling, stat progression, and equipment systems.

**Acceptance Criteria**:
- [ ] All 6 character classes defined
- [ ] Leveling system functional
- [ ] Stat progression working
- [ ] Spell learning system
- [ ] Equipment system complete
- [ ] Level up animations

**Tasks**:
- Character stat tables
- Level progression formulas
- Spell learning tables
- Equipment compatibility
- Stat calculation system
- Animation triggers
- Starting equipment

**Related**: #11, #13, #14, #19

---

### Issue #19: Item & Inventory System
**Type**: Feature  
**Priority**: High  
**Milestone**: Content Integration (M4)

**Description**:
Create item database, inventory management, and item usage (consumption, equipment effects).

**Acceptance Criteria**:
- [ ] 50+ items defined
- [ ] Item descriptions working
- [ ] Equipment slots functional
- [ ] Item effects implemented
- [ ] Shop system working
- [ ] Item drop system

**Tasks**:
- Item data structure
- Item stat tables
- Equipment slot management
- Item effect system
- Shop purchase/sell logic
- Item drop probability tables
- Inventory limit enforcement

**Related**: #11, #13, #14, #18

---

## Epic 5: Polish & Testing

### Issue #20: ROM Testing & Validation Framework
**Type**: Feature  
**Priority**: Medium  
**Milestone**: Testing & Release (M5)

**Description**:
Create automated testing framework to validate ROM integrity, functionality, and performance.

**Acceptance Criteria**:
- [ ] Header validation
- [ ] Vector integrity checks
- [ ] ROM size validation
- [ ] Symbol resolution validation
- [ ] Memory address clash detection
- [ ] Performance profiling
- [ ] Emulator compatibility tests

**Tasks**:
- ROM validator script
- Header format checker
- Vector table validator
- Symbol resolution checker
- Memory usage profiler
- Emulator test runner
- Performance benchmarks

**Related**: #1, #21

---

### Issue #21: Documentation & Code Comments
**Type**: Documentation  
**Priority**: Medium  
**Milestone**: Testing & Release (M5)

**Description**:
Ensure all code is well-commented with architecture documentation and development guides.

**Acceptance Criteria**:
- [ ] All functions documented
- [ ] Code comments explain logic
- [ ] Architecture decisions recorded
- [ ] API reference complete
- [ ] Developer guide written
- [ ] Tutorial for new contributors

**Tasks**:
- Function documentation
- Code comment review
- Architecture documentation
- API reference generation
- Developer onboarding guide
- Contributing guide

**Related**: #4, #20

---

## Milestones

### M1: Foundation (Weeks 1-3)
- Issue #1: Poppy integration
- Issue #2: Asset pipeline
- Issue #3: Roundtrip workflow
- Issue #4: Documentation

**Goal**: Working build system and development workflow

### M2: Engine Core (Weeks 4-9)
- Issue #5: Bootstrap
- Issue #6: Main loop
- Issue #7: Tile rendering
- Issue #8: Sprites
- Issue #9: Input
- Issue #10: Sound

**Goal**: Playable test ROM with graphics and sound

### M3: Gameplay Features (Weeks 10-15)
- Issue #11: Game state
- Issue #12: Save/load
- Issue #13: Battle system
- Issue #14: Menus
- Issue #15: NPCs/Dialogue

**Goal**: Core gameplay mechanics functional

### M4: Content Integration (Weeks 16-23)
- Issue #16: Maps & world
- Issue #17: Monsters
- Issue #18: Characters
- Issue #19: Items

**Goal**: Full game content playable

### M5: Testing & Release (Weeks 24-27)
- Issue #20: Testing framework
- Issue #21: Documentation

**Goal**: Polished, documented, release-ready ROM

