# DQ4r SNES Architecture Design

## Hardware Overview

### Processor
- **CPU**: 65816 (16-bit, 3.58 MHz in normal mode, 2.68 MHz in FastROM)
- **Co-processors**: SA1 available (not planned for initial release)
- **Math**: Multiplication/division via hardware multiply (optional)

### Memory Layout
```
Native 24-bit address space $000000-$FFFFFF

Bank Structure (LoROM):
$000000-$007FFF: System ROM (mirrors)
$008000-$FFFF:   Usable ROM per bank
$800000+:        Mirror of $000000-$FFFFFF (for compatibility)

WRAM: $000000-$01FFFF (128 KB)
VRAM: PPU register at $2100-$213F
```

### Cartridge Configuration
- **Memory Type**: LoROM + FastROM variant
- **Total Size**: 4 MB (32 Mbit)
- **ROM Speed**: 120 ns (FastROM)
- **SRAM**: 8 KB (for save game)
- **Expansion**: Possible but not planned

## Engine Architecture

### Core Components

#### 1. Bootstrap & Initialization
```
$008000: Reset Handler
  └─ Clear WRAM
  └─ Clear VRAM  
  └─ Initialize PPU
  └─ Initialize APU
  └─ Load title screen
  └─ Enter main loop
```

#### 2. Main Loop Structure
```
Each frame (60 Hz):
  ├─ Wait for V-Blank
  ├─ Process Input (joypad)
  ├─ Update Game State
  │  ├─ AI calculations
  │  ├─ Event processing
  │  └─ Script interpreter
  ├─ Update Graphics
  │  ├─ Render maps/sprites
  │  └─ Update palette
  └─ Update Audio
     └─ Process sound queue
```

#### 3. Graphics Engine

**Tile System**
- 8x8 pixels per tile
- 16x16 metatiles (4x4 tiles)
- 4bpp color depth (16 colors per tile)
- 4 palette banks × 16 colors each

**Sprite System**
- OAM: 128 objects max
- Object size variants: 8x8, 16x16, 32x32, etc.
- 4bpp graphics (same palette system as tiles)
- X/Y position and flipping support

**Background Layers**
- Mode 1: 3 layers (BG1, BG2 priority, BG3)
- BG1: 64x64 tiles, prioritized
- BG2: 32x32 tiles, behind sprites  
- BG3: 32x32 tiles, behind BG2
- Window masking for effects

**Special Effects**
- Mode 7: Rotation/scaling for world map
- Mosaic effect for screen wipes
- Color addition for lighting effects
- Pseudo-3D for dungeon view (if implemented)

#### 4. Sound Engine

**SPC Architecture**
- **8-bit 65C816 @ 1 MHz** in separate processor
- **64 KB ROM**: 32 KB loader + 32 KB program space
- **64 KB RAM**: Shared with APU
- **8 audio channels** (8 bit PCM per channel)

**Driver Responsibility**
- Music playback (from MML or SPC sequences)
- SFX queueing and prioritization
- Volume/pitch/pan control
- Fade in/out support

#### 5. Input System
```
Joypad Buffering:
  ├─ Read: $4218 (joypad1), $4219 (joypad2)
  ├─ Debounce (multiple samples)
  ├─ Detect presses vs. holds
  └─ Route to game logic
```

**Button Mapping** (NES-compatible)
- A = Select/Cancel
- B = Back/Run  
- X = Item menu
- Y = Magic menu
- L = Previous character
- R = Next character
- Start = Menu
- Select = Equipment

#### 6. Game State Management

**Global Game State**
```cpp
struct GameState {
    uint8 chapter;              // 1-5
    uint16 playtime;            // In frames
    uint8 partySize;            // 1-6
    uint8 partyMembers[6];      // Character IDs
    uint16 money;               // Gold
    uint8 inventory[20];        // Items held
    
    uint8 flags[256];           // Event flags
    uint8 switches[128];        // Gameplay switches
    uint16 mapID;               // Current map
    uint8 x, y;                 // Party position
}
```

**Character Data (per member)**
```cpp
struct Character {
    uint8 id;                   // Character ID
    uint8 level;                // 1-99
    uint16 exp;                 // Experience points
    uint16 hp, maxHP;           // Health
    uint16 mp, maxMP;           // Magic points
    uint8 str, agi, wis, vit;   // Stats
    uint16 equip[4];            // Weapon, Armor, Shield, Hat
    uint16 spells[8];           // Known spells
    uint8 status;               // Poison, sleep, etc.
}
```

#### 7. Combat System

**Battle States**
```
BattleStart
  ├─ Load enemy team
  ├─ Position player party
  ├─ Load backgrounds
  └─ Initialize UI
  
BattleRound
  ├─ Get player actions
  ├─ Calculate enemy turns
  ├─ Execute actions (order by agility)
  │  ├─ Attack
  │  ├─ Magic
  │  ├─ Item
  │  └─ Defend
  ├─ Update HP/effects
  └─ Check win/loss
  
BattleEnd
  ├─ Award EXP/items
  ├─ Check level ups
  └─ Return to map
```

**Damage Calculation**
```
PhysicalDamage = ((ATK * 2 + 8) * Level / 8) - DEF/2 ± variance
MagicDamage = (Magic Power * 2 + 4) - Enemy Resistance ± variance
Variance = Damage * (random 25% to -25%)
Critical = 1/32 chance, doubles damage
```

#### 8. Map System

**Map Structure**
```
MapHeader:
  - Tileset reference
  - Width/Height
  - Metatile data (32-bit pointers per metatile)
  - Collision data
  - Event data

Layers:
  - Background: Static metatiles
  - Events: NPCs, chests, warps
  - Sprites: Player, party members, monsters
```

**Coordinate System**
- Pixels: 0-383 (X) × 0-223 (Y) on screen
- Tiles: 0-47 (X) × 0-27 (Y) visible  
- Metatiles: Map-dependent (e.g., 128×128 metatiles for towns)
- Collision: 1 pixel granularity using collision map

#### 9. Script/Event System

**Event Types**
- NPC dialogue triggers
- Treasure chest interactions
- Door/portal warps
- Battle encounters
- State changes (flags)
- Animation sequences

**Simple Interpreter**
```
EventScript (16-bit tokens):
  00 DD LL HH: Dialog ID (LL=low, HH=high)
  01 FF: Set flag FF
  02 FF: Clear flag FF
  03 XX YY: Warp to map XX, position YY
  04 MM: Start battle with monster group MM
  05 II: Add item ID II to inventory
  06 00: Exit script
```

## Banking Strategy

### ROM Organization
```
Bank 00: $8000-$FFFF Reset & core engine (32 KB)
Banks 01-1F: Additional code (480 KB total)
Banks 20-3F: Graphics & large data (512 KB total)

Total: 1 MB code, 0.5 MB graphics, 2.5 MB data/unused
```

### Bank Switching
- **Method**: LoROM implicit (address bits 15-14)
- **No special mapper** (unlike SA1)
- **Long addressing**: 24-bit addresses for cross-bank calls

### Graphics Bank Strategy
- Tiles: Banks 20-25
- Sprites: Banks 26-2F
- Palettes: Banks 30-37 (small, mostly unused)
- Compressed assets: Decompressed at runtime to VRAM

## Data Structures

### Enemy Definitions
```
EnemyData (32 bytes):
  Offset  Size    Description
  $00     2       HP max
  $02     2       MP max
  $04     1       Attack power
  $05     1       Defense
  $06     1       Intelligence
  $07     1       Agility
  $08     2       Experience reward
  $09     2       Gold reward
  $0A     1       Spell set ID
  $0B     1       Item drop ID
  $0C     1       Sprite ID
  ...
```

### Item Definitions
```
ItemData (16 bytes):
  Offset  Size    Description
  $00     1       Type (weapon/armor/item)
  $01     1       Equipment slot
  $02     2       Price
  $03     1       Power (attack/defense)
  $04     1       Effects
  $05     1       Usable by mask (6 bits)
  ...
```

### Spell Definitions
```
SpellData (8 bytes):
  Offset  Size    Description
  $00     1       MP cost
  $01     1       Power
  $02     1       Type (heal/damage/buff/debuff)
  $03     1       Target (single/party/all)
  $04     1       Accuracy (0-100%)
  $05     1       Effect ID
```

## Performance Considerations

### VRAM Update Limits
- Max 32 KB transferred per frame (via DMA)
- Plan graphics updates carefully
- Avoid scrolling with excessive tile swaps

### CPU Cycle Budget
- 3.58 MHz processor (~60,000 cycles per frame @ 60 Hz)
- Minus ~8000 cycles for SNES hardware operations
- Remaining: ~52,000 cycles for game logic
- Battle calculations should cache results when possible

### Memory Constraints
- WRAM: 128 KB total
- Current estimated usage: ~80 KB (game state + buffers)
- 48 KB available for dynamic allocation
- VRAM: 64 KB (16000 tiles, 256 sprites max)

## Comparison: NES vs SNES

| Feature | NES (DW4) | SNES (DQ4r) | Advantage |
|---------|-----------|-------------|-----------|
| Resolution | 256×240 | 256×224 | SNES slightly narrower |
| Colors | 4 palettes × 4 colors | 4 palettes × 16 colors | SNES 4× more color |
| Sprites | 64 max | 128 max | SNES more action |
| Tiles | 8×8 only | 8×8 + larger | SNES flexible |
| Effects | None | Scaling, rotation, fade | SNES interactive |
| Audio | Square/Triangle | PCM 8-channel | SNES richer audio |
| Storage | 768 KB max | 4 MB | SNES massive expansion |

## Next Steps

1. Implement core bootstrap code
2. Create graphics/sprite test ROMs
3. Build input/joypad system
4. Implement main game loop framework
5. Build tile/map rendering pipeline
6. Integrate sound driver
7. Implement battle system
8. Add event/script interpreter

