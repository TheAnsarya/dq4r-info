# DQ4r Project TODO List

## Foundation Phase (M1) - Current Focus

### Build System & Infrastructure
- [x] **Issue #1**: Set up Poppy Compiler Integration
  - [x] Reference Poppy repository
  - [x] Create build.ps1 with Poppy invocation
  - [x] Implement test ROM compilation
  - [x] Add symbol file generation
  - [x] Setup build artifact management
  - [x] Validate output ROM and commit success report

- [ ] **Issue #2**: Create Asset Processing Pipeline
  - [ ] Design asset directory structure
  - [ ] Implement PNG → CHR converter (8x8 tiles)
  - [ ] Create JSON → assembly data converter
  - [ ] Auto-generate assembly includes during build
  - [ ] Add compression support (optional first phase)

- [ ] **Issue #3**: Establish Roundtrip Disassembly Workflow
  - [ ] Use Peony to disassemble target ROM
  - [ ] Verify label generation for all branches
  - [ ] Test reassembly with Poppy
  - [ ] Fix any label/branch issues in Peony
  - [ ] Document complete workflow

- [ ] **Issue #4**: Create Comprehensive Documentation
  - [ ] PROJECT_PLAN.md ✅ (Done)
  - [ ] ARCHITECTURE.md ✅ (Done)
  - [ ] BUILD_GUIDE.md ✅ (Done)
  - [ ] API_REFERENCE.md (Pending)
  - [ ] Update README with links ✅ (Done)
  - [ ] Create CONTRIBUTING.md

### Research & Analysis
- [ ] Extract DW4 NES ROM structure using Peony
- [ ] Analyze DW4 engine code and data
- [ ] Identify key differences from DQ3
- [ ] Document engine modification requirements
- [ ] Create comparison matrix (NES vs SNES)

## Engine Core Phase (M2) - Weeks 4-9

### Bootstrap & Initialization
- [ ] **Issue #5**: Implement Bootstrap & Initialization
  - [ ] Create ROM header (0x00FFC0)
  - [ ] Populate vector table (0x00FFE4-0x00FFFF)
  - [ ] Write Reset handler
  - [ ] PPU initialization sequence
  - [ ] APU initialization sequence
  - [ ] WRAM clear routine
  - [ ] Test in Mesen2

### Game Loop
- [ ] **Issue #6**: Implement Main Game Loop
  - [ ] V-Blank detection routine
  - [ ] 60 Hz synchronization
  - [ ] Input buffer management
  - [ ] Game state update dispatcher
  - [ ] Graphics queue system
  - [ ] Audio queue system

#### New Near-Term Tasks (M2 bootstrap)
- [ ] Enable NMI (write $4200 NMITIMEN) and confirm WAI resumes
- [ ] Add `read_input` stub (read $4218/$4219) and store to WRAM
- [ ] Add simple PPU init (BG mode, brightness) and keep screen on

### Graphics
- [ ] **Issue #7**: Graphics Engine - Tile Rendering
  - [ ] Tile data VRAM management
  - [ ] BG mode 1 configuration
  - [ ] Metatile (16x16) decompression
  - [ ] Palette system (4 banks × 16 colors)
  - [ ] Scrolling calculation
  - [ ] Test ROM with colored grid

- [ ] **Issue #8**: Graphics Engine - Sprite Management
  - [ ] OAM management routines
  - [ ] Object positioning system
  - [ ] Sprite flipping (horizontal/vertical)
  - [ ] Object size variants
  - [ ] Animation frame system
  - [ ] Test ROM with animated sprite

### Input
- [ ] **Issue #9**: Input System Implementation
  - [ ] Joypad1 reading routine
  - [ ] Input debouncing logic
  - [ ] Press vs. hold detection
  - [ ] NES-compatible button mapping
  - [ ] Multi-button combo support
  - [ ] Input debug display

### Audio
- [ ] **Issue #10**: Sound Driver Integration
  - [ ] SPC700 loader implementation
  - [ ] Driver communication protocol
  - [ ] Music playback system
  - [ ] Sound effect system
  - [ ] Volume/pan control
  - [ ] Fade effects
  - [ ] Test ROM with sound

## Gameplay Features Phase (M3) - Weeks 10-15

### Game State
- [ ] **Issue #11**: Game State Management System
  - [ ] Define all data structures
  - [ ] Character data system
  - [ ] Inventory management
  - [ ] Flag/switch system
  - [ ] Memory layout optimization
  - [ ] Save state preparation

- [ ] **Issue #12**: Save/Load System
  - [ ] SRAM access routines
  - [ ] Save format specification
  - [ ] Data compression
  - [ ] Checksum validation
  - [ ] Multiple save slots
  - [ ] Load verification

### Battle System
- [ ] **Issue #13**: Battle System Implementation
  - [ ] Battle state machine
  - [ ] Command menu UI
  - [ ] Turn order calculation
  - [ ] Physical damage engine
  - [ ] Magic damage engine
  - [ ] Item usage in battle
  - [ ] Status effects
  - [ ] Win/loss conditions
  - [ ] EXP/item rewards
  - [ ] Battle test ROM

### Menus & UI
- [ ] **Issue #14**: Menu System
  - [ ] Menu framework
  - [ ] Status screen
  - [ ] Equipment menu
  - [ ] Item menu
  - [ ] Magic menu
  - [ ] Save/load menus
  - [ ] Smooth animations
  - [ ] Text rendering

### Dialogue & Events
- [ ] **Issue #15**: NPC & Dialogue System
  - [ ] NPC interaction system
  - [ ] Text box rendering
  - [ ] Dialogue script format
  - [ ] Event triggering
  - [ ] Character name substitution
  - [ ] Quest flag system

## Content Integration Phase (M4) - Weeks 16-23

### World & Maps
- [ ] **Issue #16**: Map System & World Navigation
  - [ ] Map data format
  - [ ] Map loading routines
  - [ ] Character positioning
  - [ ] Movement system
  - [ ] Collision detection
  - [ ] Town/dungeon transitions
  - [ ] Warp system

### Gameplay Content
- [ ] **Issue #17**: Monster & Enemy System
  - [ ] Monster data structures
  - [ ] Implement 60+ monsters
  - [ ] Sprite loading system
  - [ ] Encounter table system
  - [ ] Random encounter algorithm
  - [ ] Boss scripting system
  - [ ] Monster AI

- [ ] **Issue #18**: Character & Leveling System
  - [ ] Character definitions (6 classes)
  - [ ] Leveling formulas
  - [ ] Stat progression
  - [ ] Spell learning tables
  - [ ] Equipment compatibility
  - [ ] Starting stats

- [ ] **Issue #19**: Item & Inventory System
  - [ ] Item database (50+)
  - [ ] Equipment system
  - [ ] Item effects
  - [ ] Shop system
  - [ ] Item drop probabilities
  - [ ] Inventory constraints

## Testing & Release Phase (M5) - Weeks 24-27

### Testing Framework
- [ ] **Issue #20**: ROM Testing & Validation
  - [ ] ROM header validator
  - [ ] Vector table checker
  - [ ] Symbol resolution validator
  - [ ] Memory clash detector
  - [ ] Performance profiler
  - [ ] Emulator compatibility tests

### Documentation & Polish
- [ ] **Issue #21**: Documentation & Code Comments
  - [ ] Function documentation
  - [ ] Code comments
  - [ ] API reference
  - [ ] Developer guide
  - [ ] Contributing guide
  - [ ] Troubleshooting guide

## Future (Post-Release)

### Enhancements
- [ ] Mode 7 world map implementation
- [ ] Custom sprite animations
- [ ] Additional sound/music
- [ ] Graphics improvements
- [ ] Performance optimization

### Extended Content
- [ ] Bonus chapters
- [ ] Monster spawning improvements
- [ ] Equipment variety expansion
- [ ] Spell set customization

---

## Tracking Notes

**Last Updated**: 2026-01-17  
**Current Phase**: M1 Foundation  
**Estimated Completion**: Q3/Q4 2026 (for MVP)

**Progress Summary**:
- Foundation Phase: 10% (Documentation created, planning complete)
- Engine Core Phase: 0% (Not started)
- Gameplay Features Phase: 0% (Not started)
- Content Integration Phase: 0% (Not started)
- Testing & Release Phase: 0% (Not started)

**Key Blockers**:
- None currently - ready to begin Issue #1

**Next Immediate Actions**:
1. Create GitHub Issues from specification
2. Begin Issue #1: Poppy integration
3. Create build.ps1 script
4. Test ROM compilation

