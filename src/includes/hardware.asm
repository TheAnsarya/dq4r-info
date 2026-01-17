; SNES Hardware Definitions
; PPU and APU register addresses

; ============================================
; PPU Registers ($2100-$213F)
; ============================================

PPU_CONTROL     = $2100       ; Forced blank, brightness, screen enable
PPU_BGMODE      = $2105       ; Background mode and tile size
PPU_BGSC        = $2107       ; BG1 Screen Base Address
PPU_BG2SC       = $2108       ; BG2 Screen Base Address
PPU_BG3SC       = $2109       ; BG3 Screen Base Address
PPU_BG4SC       = $210A       ; BG4 Screen Base Address

PPU_BG12NBA     = $210B       ; BG1/2 Tile Data Address
PPU_BG34NBA     = $210C       ; BG3/4 Tile Data Address

PPU_BG1HOFS     = $210D       ; BG1 Horizontal Scroll
PPU_BG1VOFS     = $210E       ; BG1 Vertical Scroll
PPU_BG2HOFS     = $210F       ; BG2 Horizontal Scroll
PPU_BG2VOFS     = $2110       ; BG2 Vertical Scroll
PPU_BG3HOFS     = $2111       ; BG3 Horizontal Scroll
PPU_BG3VOFS     = $2112       ; BG3 Vertical Scroll
PPU_BG4HOFS     = $2113       ; BG4 Horizontal Scroll
PPU_BG4VOFS     = $2114       ; BG4 Vertical Scroll

PPU_VMAIN       = $2115       ; VRAM Port Control
PPU_VMADDR      = $2116       ; VRAM Address (low byte)
PPU_VMDATAL     = $2118       ; VRAM Data (low byte)
PPU_VMDATAH     = $2119       ; VRAM Data (high byte)

PPU_CGADD       = $2121       ; CGRAM Address
PPU_CGDATA      = $2122       ; CGRAM Data

PPU_OAMADDR     = $2102       ; OAM Address
PPU_OAMADDH     = $2103       ; OAM Address (high)
PPU_OAMDATA     = $2104       ; OAM Data (write)

PPU_BGWINDOW    = $2123       ; Window 1 BG
PPU_OBJWINDOW   = $2124       ; Window 1 OBJ
PPU_WHMASK      = $2125       ; Window Position Mask

PPU_VBLANK      = $2130       ; VBLANK/HBLANK status
PPU_STAT77      = $2137       ; STAT77 status

; ============================================
; DMA Registers ($4300-$437F)
; ============================================

DMA_CONTROL0    = $4300       ; DMA 0 Control
DMA_BBADD0      = $4301       ; DMA 0 B-Bus Address
DMA_A1LO0       = $4302       ; DMA 0 A-Bus Address (low)
DMA_A1HI0       = $4303       ; DMA 0 A-Bus Address (high)
DMA_A1B0        = $4304       ; DMA 0 A-Bus Address (bank)
DMA_SIZE0       = $4305       ; DMA 0 Transfer Size (low)
DMA_SIZE0H      = $4306       ; DMA 0 Transfer Size (high)
DMA_MDEST0      = $4307       ; DMA 0 Indirect Address (low)
DMA_MDEST0H     = $4308       ; DMA 0 Indirect Address (high)

; ============================================
; APU Registers ($2140-$2143)
; ============================================

APU_PORT0       = $2140       ; APU Input Port 0
APU_PORT1       = $2141       ; APU Input Port 1
APU_PORT2       = $2142       ; APU Input Port 2
APU_PORT3       = $2143       ; APU Input Port 3

; ============================================
; Joypad Registers ($4016, $4017, $4218, $4219)
; ============================================

JOY_STROBE      = $4016       ; Joypad strobe (write)
JOY_PORT1       = $4218       ; Joypad 1 data (read, low byte)
JOY_PORT1H      = $4219       ; Joypad 1 data (read, high byte)
JOY_PORT2       = $421A       ; Joypad 2 data (read, low byte)
JOY_PORT2H      = $421B       ; Joypad 2 data (read, high byte)

; ============================================
; Joypad Button Bits
; ============================================

JOY_B           = $0001       ; B button
JOY_Y           = $0002       ; Y button
JOY_SELECT      = $0004       ; Select button
JOY_START       = $0008       ; Start button
JOY_UP          = $0010       ; Up direction
JOY_DOWN        = $0020       ; Down direction
JOY_LEFT        = $0040       ; Left direction
JOY_RIGHT       = $0080       ; Right direction
JOY_A           = $0100       ; A button
JOY_X           = $0200       ; X button
JOY_L           = $0400       ; L button
JOY_R           = $0800       ; R button

; ============================================
; PPU Control Bits ($2100)
; ============================================

PPU_FORCED_BLANK = $80        ; Bit 7: Force blank
PPU_BRIGHTNESS  = $0F        ; Bits 0-3: Brightness

; ============================================
; BG Mode Bits ($2105)
; ============================================

BGMODE_1        = $01        ; Mode 1 (2x2 bpp, 2x2 bpp, 2x2 bpp)
BGMODE_3        = $03        ; Mode 3 (8bpp BG1, 4bpp BG2)
BGMODE_7        = $07        ; Mode 7 (rotation/scaling)

; ============================================
; Color Formats
; ============================================

; Standard SNES color (15-bit, BGR555)
; Bit 15: unused
; Bits 14-10: Blue (0-31)
; Bits 9-5: Green (0-31)
; Bits 4-0: Red (0-31)

; Black
BLACK           = $0000

; Primary colors
RED             = $001F       ; $F = 31 red
GREEN           = $03E0       ; $1F0 = 31 green shifted
BLUE            = $7C00       ; $7C00 = 31 blue shifted

; White
WHITE           = $7FFF       ; All components at max

; ============================================
; WRAM Locations
; ============================================

WRAM_START      = $7E0000
WRAM_SIZE       = $20000      ; 128 KB

; Game state
GAME_STATE      = $7E0000    ; Base of game state
GAME_STATE_SIZE = $0100      ; 256 bytes

; Character data
CHARACTER_DATA  = $7E0100    ; Character 0 data starts here
CHARACTER_SIZE  = $0020      ; 32 bytes per character
MAX_CHARACTERS  = 6

; Inventory
INVENTORY       = $7E0200
INVENTORY_SIZE  = $0014      ; 20 items

; Event flags
FLAG_ARRAY      = $7E0300
FLAG_SIZE       = $0020      ; 32 bytes = 256 flags

; Switch states
SWITCH_ARRAY    = $7E0380
SWITCH_SIZE     = $0020      ; 32 bytes = 256 switches

; General buffers
BUFFER_1        = $7E0400
BUFFER_2        = $7E0500

; ============================================
; VRAM Locations
; ============================================

; Graphics data
TILE_DATA_BG1   = $0000      ; BG1 tiles
TILE_DATA_BG2   = $4000      ; BG2 tiles
TILE_MAP_BG1    = $8000      ; BG1 map
TILE_MAP_BG2    = $A000      ; BG2 map

; OAM (Sprite data)
OAM_START       = $0000
OAM_SIZE        = $0220      ; 512 bytes (128 sprites × 4 bytes)

; Palette (CGRAM)
PALETTE_START   = $00
PALETTE_SIZE    = $0100      ; 256 colors (512 bytes)

; ============================================
; Constants
; ============================================

SCREEN_WIDTH    = 256        ; Pixels
SCREEN_HEIGHT   = 224        ; Pixels

TILE_SIZE       = 8          ; 8x8 pixels per tile
METATILE_SIZE   = 16         ; 16x16 pixels per metatile

TILES_PER_ROW   = 32         ; 256 / 8
METATILES_PER_ROW = 16       ; 256 / 16

MAX_SPRITES     = 128        ; Maximum OAM objects
MAX_TILEMAPS    = 4          ; BG1-BG4

; ============================================
; Macros and convenience constants
; ============================================

; BG Mode values
MODE_1BPP       = $00        ; 2bpp mode
MODE_2BPP       = $01        ; 2bpp mode
MODE_4BPP       = $02        ; 4bpp mode
MODE_8BPP       = $03        ; 8bpp mode

