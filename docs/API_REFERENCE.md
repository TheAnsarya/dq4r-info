# DQ4r Assembly API Reference

**Status**: Work in Progress - Base structures documented, implementations TBD  
**Last Updated**: 2026-01-17

## Overview

This document describes the public API for DQ4r assembly modules. Functions are organized by system and include calling conventions, parameters, return values, and side effects.

## Calling Conventions

### Registers on Entry
- **A**: Often parameter (depends on function)
- **X/Y**: Preserves caller values (callee must push if using)
- **D**: Direct page pointer (usually $0000)
- **B**: Data bank (function-dependent)
- **S**: Stack pointer (function manages)

### Registers on Exit
- **A**: Return value (if applicable)
- **X/Y**: Preserved (pushed/pulled by function)
- **Flags**: May be modified, check function documentation
- **Other**: Caller must assume modified

### Stack Usage
- Return address: 3 bytes (24-bit)
- Local variables: As needed
- Parameter passing: Via stack when needed

## Core Engine (engine/core.asm)

### Reset Handler
```asm
Reset:
```
**Purpose**: SNES initialization sequence  
**Called**: On power-up via vector at $00FFFA  
**Returns**: Never (enters main loop)  
**Side Effects**: Initializes all hardware

**Sequence**:
1. Disable interrupts (SEI)
2. Switch to native mode (XCE)
3. Set 16-bit A/X/Y (REP #$38)
4. Clear WRAM
5. Initialize PPU registers
6. Initialize APU
7. Load title screen
8. Enter MainLoop

---

### WaitVBlank
```asm
WaitVBlank:
```
**Purpose**: Synchronize to vertical blank period  
**Input**: None  
**Output**: None  
**Registers**: A (modified), X (preserved)  
**Timing**: ~12 cycles (normal) to ~550 cycles (max wait)  

**Description**: Polls PPU_VBLANK ($2130) bit 7 until vertical blank occurs. Used to synchronize game updates with screen refresh.

**Usage**:
```asm
jsr WaitVBlank    ; Wait for next V-Blank
; ... update graphics here ...
jsr WaitVBlank    ; Wait for completion
```

---

### ProcessInput
```asm
ProcessInput:
```
**Purpose**: Read joypad and update input state  
**Input**: None  
**Output**: Input state in WRAM  
**Registers**: A/X (modified)  
**Timing**: ~50 cycles  

**Description**: Reads joypad1 ($4218/$4219), debounces, and updates game input state in WRAM:
- `INPUT_CURRENT`: Current pressed buttons
- `INPUT_PRESSED`: Buttons newly pressed this frame
- `INPUT_RELEASED`: Buttons released this frame

**Button Layout**:
```
Bit 7: Start
Bit 6: Select
Bit 5: Y
Bit 4: X
Bit 3: L
Bit 2: R
Bit 1: B
Bit 0: A
```

---

### UpdateGame
```asm
UpdateGame:
```
**Purpose**: Update all game logic for current frame  
**Input**: None  
**Output**: Game state updated  
**Registers**: All (may modify)  
**Timing**: Varies (see performance)  

**Calls**:
- AI calculation routines
- Event processing
- Script interpreter
- State machine updates

---

## Graphics Engine (engine/graphics.asm)

### LoadTileset
```asm
LoadTileset:
; A = Tileset ID
```
**Purpose**: Load tile graphics into VRAM  
**Input**: A = Tileset ID (0-7)  
**Output**: VRAM updated  
**Registers**: A/X/Y (modified)  
**Timing**: ~5000 cycles (one tileset)  

**Description**: Decompresses tileset data from ROM and loads into VRAM at appropriate offset for tileset ID.

**VRAM Layout**:
- Tileset 0: $0000-$3FFF (32 KB, 2048 tiles)
- Tileset 1: $4000-$7FFF
- Tileset 2-7: Additional 32 KB blocks

---

### SetBGMode
```asm
SetBGMode:
; A = Mode (1-7)
```
**Purpose**: Configure SNES background mode  
**Input**: A = BGMode (1, 3, or 7)  
**Output**: PPU configured  
**Registers**: A (modified)  
**Timing**: ~100 cycles  

**Description**: Sets PPU_BGMODE ($2105) register to requested mode and initializes associated layer configuration.

**Mode 1** (Most common): 3 layers (BG1/BG2 + priority, BG3)
- BG1/BG2: 8x8 or 16x16 tiles
- BG3: Always 8x8
- Supported for world/dungeon maps

**Mode 7**: Rotation/scaling
- Single BG layer with affine transformation
- Used for world map rotation effect

---

### SetPalette
```asm
SetPalette:
; A = Palette set (0-3)
```
**Purpose**: Load palette from ROM to CGRAM  
**Input**: A = Palette set (0-3)  
**Output**: CGRAM updated  
**Registers**: A/X (modified)  
**Timing**: ~500 cycles  

**Description**: Transfers 16-color palette from ROM to CGRAM for specified set.

**Palette Organization**:
- Set 0: Colors 0-15 (UI, common)
- Set 1: Colors 16-31 (Enemies/NPCs)
- Set 2: Colors 32-47 (Special effects)
- Set 3: Colors 48-63 (Reserved)

---

### UpdateScrollPosition
```asm
UpdateScrollPosition:
; A = Scroll X (low byte)
; X = Scroll Y (low byte)
```
**Purpose**: Set background layer scroll position  
**Input**: A = X position, X = Y position  
**Output**: PPU_BGSCROLL registers updated  
**Registers**: A/X (modified)  
**Timing**: ~50 cycles  

**Description**: Updates BG1 scroll position. Call during V-Blank for smooth scrolling.

---

## Input System (engine/input.asm)

### Joypad1Read
```asm
Joypad1Read:
; Returns: A = Button state (8 bits)
```
**Purpose**: Read raw joypad1 state  
**Input**: None  
**Output**: A = Button bits  
**Registers**: A (modified)  
**Timing**: ~300 cycles (10 samples + debounce)  

**Return Value** (bit 0 = Button A):
```
$00 = No buttons
$01 = A pressed
$02 = B pressed
$04 = Select pressed
$08 = Start pressed
... etc
```

---

## Game State (game/state.asm)

### GetCharacter
```asm
GetCharacter:
; A = Character index (0-5)
; Returns: X = Address of character data
```
**Purpose**: Get pointer to character data structure  
**Input**: A = Character ID (0-5)  
**Output**: X = WRAM address of CHARACTER_DATA[index]  
**Registers**: X (modified), A (preserved)  
**Timing**: ~20 cycles  

**Character Data Layout** (32 bytes):
```
Offset  Size    Field
+$00    1       Character ID
+$01    1       Level (1-99)
+$02    2       Experience points
+$04    2       HP current
+$06    2       HP max
+$08    2       MP current
+$0A    2       MP max
+$0C    1       Strength stat
+$0D    1       Agility stat
+$0E    1       Wisdom stat
+$0F    1       Vitality stat
+$10    2       Weapon equipped
+$12    2       Armor equipped
+$14    2       Shield equipped
+$16    2       Helmet equipped
+$18    2       Spells known (bitmap)
+$1A    1       Status flags
+$1B    5       Padding
```

---

### SetFlag
```asm
SetFlag:
; A = Flag number (0-255)
```
**Purpose**: Set a game event flag  
**Input**: A = Flag index  
**Output**: Flag array updated  
**Registers**: A/X (modified)  
**Timing**: ~30 cycles  

**Storage**: FLAG_ARRAY at WRAM $7E0300 (256 flags, 32 bytes)

**Flag Ranges**:
- 0-63: Story progression
- 64-127: Town/dungeon state
- 128-191: NPC interactions
- 192-255: Misc conditions

---

### ClearFlag
```asm
ClearFlag:
; A = Flag number (0-255)
```
**Purpose**: Clear a game event flag  
**Input**: A = Flag index  
**Output**: Flag array updated  
**Registers**: A/X (modified)  
**Timing**: ~30 cycles  

---

### IsFlagSet
```asm
IsFlagSet:
; A = Flag number (0-255)
; Returns: Z flag set if flag is SET
```
**Purpose**: Check if flag is set  
**Input**: A = Flag index  
**Output**: Z flag = 1 if set, 0 if clear  
**Registers**: A/X (modified)  
**Timing**: ~40 cycles  

**Usage**:
```asm
lda #CHAPEL_VISITED
jsr IsFlagSet
beq .chapel_new       ; Branch if flag not set
bra .chapel_revisit   ; Flag is set, already visited
```

---

## Battle System (game/battle.asm)

### StartBattle
```asm
StartBattle:
; A = Enemy group ID (0-31)
```
**Purpose**: Initiate a battle with specified enemy group  
**Input**: A = Enemy group index  
**Output**: Battle state initialized, switches to battle screen  
**Registers**: All (modified)  
**Timing**: ~2000 cycles (loading assets)  

**Side Effects**:
- GAME_STATE.in_battle = 1
- Party positioned at bottom
- Enemies positioned at top
- Background loaded
- Music switched to battle theme

---

### ExecuteAction
```asm
ExecuteAction:
; A = Action type (ATTACK/MAGIC/ITEM/DEFEND)
; X = Action parameter (target/spell/item ID)
```
**Purpose**: Execute player action during battle turn  
**Input**: A = action, X = parameter  
**Output**: Action resolved, damage applied, state updated  
**Registers**: All (modified)  
**Timing**: ~300-1000 cycles depending on action  

**Action Types**:
- 0 = ATTACK (X = target index)
- 1 = MAGIC (X = spell ID)
- 2 = ITEM (X = item ID)
- 3 = DEFEND (X = unused)

---

## Data Structures

### Game State (WRAM $7E0000, 256 bytes)
```asm
struct GameState {
    +$00    Chapter (1-5)
    +$01    In battle (0/1)
    +$02    Map ID (0-255)
    +$03    Party X position
    +$04    Party Y position
    +$05    Party size (1-6)
    +$06-0B Party member IDs [6]
    +$0C    Money (16-bit)
    +$0E    Current menu (0=none)
    +$0F    Flags array index (for cycling)
    ...
}
```

### Character Data (WRAM $7E0100 per character, 32 bytes each)
```asm
struct Character {
    +$00    ID
    +$01    Level
    +$02    Experience (16-bit)
    +$04    HP current (16-bit)
    +$06    HP max (16-bit)
    +$08    MP current (16-bit)
    +$0A    MP max (16-bit)
    +$0C    Strength
    +$0D    Agility
    +$0E    Wisdom
    +$0F    Vitality
    +$10    Weapon ID (16-bit)
    +$12    Armor ID (16-bit)
    +$14    Shield ID (16-bit)
    +$16    Helmet ID (16-bit)
    +$18    Known spells (bitmap, 16-bit)
    +$1A    Status flags
    +$1B    ... padding
}
```

---

## Memory Map

```
WRAM Layout:

$7E0000-$7E00FF: Game state (256 bytes)
$7E0100-$7E01BF: Character data [6 × 32 bytes]
$7E01C0-$7E01FF: Reserved
$7E0200-$7E02FF: Inventory (20 items max)
$7E0300-$7E037F: Event flags (256 flags, 32 bytes)
$7E0380-$7E03FF: Switch states
$7E0400-$7E3FFF: Free space for buffers (~15 KB)
$7E4000-$7FFFFF: Free space (~12 KB remaining)
```

---

## Constants & Macros

### Hardware Registers (engine/hardware.asm)

**PPU Registers**:
- `PPU_CONTROL = $2100`
- `PPU_BGMODE = $2105`
- `PPU_OAMADDR = $2102`
- `PPU_OAMDATA = $2104`
- `PPU_BGSCROLL = $210D`
- `PPU_VBLANK = $2130`

**APU Ports**:
- `APU_PORT0 = $2140` through `$2143`

---

## Performance Budgets

### Per Frame (60 Hz, ~3.58 MHz)

**Total CPU Cycles**: ~60,000  
**SNES Hardware**: ~8,000 (PPU/APU operations)  
**Available for Game**: ~52,000 cycles

**Typical Distribution**:
- Graphics DMA: 8,000 cycles
- Input processing: 200 cycles
- Game logic: 20,000 cycles
- Battle calculations: 15,000 cycles (if in battle)
- Scripting: 5,000 cycles
- Unused buffer: 3,800 cycles

### VRAM Transfer Limits

**Max DMA per frame**: 32 KB  
**Typical tile updates**: 1-4 KB  
**Sprite updates**: 0.5-2 KB  
**Palette updates**: 0.1-1 KB

---

## Future API Additions

These functions will be documented as implemented:

- [ ] `CompressGraphics` - Compress tile/sprite data
- [ ] `DecompressGraphics` - Decompress on-the-fly
- [ ] `InterpolateAnimation` - Smooth sprite animation
- [ ] `ApplyStatusEffect` - Handle poison/sleep/etc
- [ ] `CalculateDamage` - Damage formula engine
- [ ] `ExecuteAI` - Enemy AI routines
- [ ] `PlayAnimation` - Sprite animation sequencer
- [ ] `ScriptExecute` - Execute event scripts
- [ ] `DialogDisplay` - Show dialogue text

