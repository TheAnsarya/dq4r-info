; Dragon Quest IV Remix - Main Assembly File
; Target: SNES (65816 CPU, LoROM configuration)
; Assembler: Poppy (custom .NET 10 compiler)

.system:snes
lorom

; ============================================
; Include common definitions
; ============================================
.include "includes/hardware.asm"
.include "includes/defines.asm"
.include "includes/macros.asm"

; ============================================
; ROM HEADER (0x00FFC0-0x00FFDF)
; ============================================
.bank 0
.org $FFC0

db "DQ4 REMIX           "      ; Game title (21 bytes, padded)
db $31                         ; Map mode (LoROM + FastROM = $31)
db $02                         ; Cartridge type (ROM + RAM + Battery)
db $0C                         ; ROM size (4 MB = $0C)
db $03                         ; SRAM size (8 KB = $03)
db $01                         ; Country (North America)
db $33                         ; Developer ID (unofficial = $33)
db $00                         ; Cartridge version (0)
dw $0000                       ; Checksum complement (calculated)
dw $FFFF                       ; Checksum (calculated)

; ============================================
; INTERRUPT VECTORS (0x00FFE4-0x00FFFF)
; ============================================

; Native mode vectors (65816 native)
.org $FFE4
dw 0                           ; COP (unused)
dw 0                           ; BRK (unused)
dw 0                           ; ABORT (unused)
dw NMI_Native                  ; Native mode NMI

; Emulation mode vectors (6502 compatible)
.org $FFEA
dw 0                           ; Emulation COP (unused)
dw 0                           ; Emulation BRK (unused)

.org $FFFA
dw NMI_Emulation               ; Emulation NMI (unused on SNES)
dw Reset                       ; RESET vector (on power-up)
dw IRQ_Emulation               ; Emulation IRQ (unused on SNES)

; ============================================
; CODE - BANK 0 (0x008000-0x00FFFF, 32 KB)
; ============================================
.bank 0
.org $8000

; ============================================
; Reset Handler
; ============================================
Reset:
	sei                        ; Disable interrupts
	clc                        ; Clear carry (needed for native mode switch)
	xce                        ; Switch to native mode (65816)
	rep #$38                   ; Clear MX flags: A/X/Y 16-bit, decimal off
	
	; Initialize stack
	lda #$1FFF                 ; Stack at top of WRAM
	tcs                        ; Set stack pointer
	
	; Clear WRAM (0x0000-0x1FFF = 8 KB)
	jsr ClearWRAM
	
	; Initialize hardware
	jsr InitHardware
	
	; Load test graphics
	jsr LoadTestGraphics
	
	; Enter main loop
.MainLoop:
	jsr WaitVBlank
	jsr ProcessInput
	jsr UpdateGame
	jsr UpdateGraphics
	bra .MainLoop

; ============================================
; Initialize Hardware (PPU, APU, etc.)
; ============================================
InitHardware:
	php                        ; Save flags
	rep #$30                   ; A/X/Y = 16-bit
	
	; Disable all PPU outputs
	lda #$8F                   ; Force blank, full brightness
	sta $2100                  ; PPU_CONTROL
	
	; Set up video mode
	lda #$01                   ; BG Mode 1
	sta $2105                  ; PPU_BGMODE
	
	; Initialize background 1
	lda #$00
	sta $210B                  ; BG1SC (screen base)
	lda #$00
	sta $210D                  ; BG12NBA (name/character base)
	
	; Set palette to 0
	lda #$00
	sta $2121                  ; CGADD (palette address)
	
	; Initialize OAM
	lda #$00
	sta $2102                  ; OAMADDR
	sta $2103                  ; OAMADDR (high byte)
	
	; Initialize scroll registers
	lda #$00
	sta $210E                  ; BG1HOFS
	sta $210E                  ; BG1HOFS
	sta $210F                  ; BG1VOFS
	sta $210F                  ; BG1VOFS
	
	; Re-enable display
	lda #$0F                   ; Display enable, full brightness
	sta $2100                  ; PPU_CONTROL
	
	plp                        ; Restore flags
	rts

; ============================================
; Clear WRAM (8 KB at $0000-$1FFF)
; ============================================
ClearWRAM:
	php                        ; Save flags
	rep #$30                   ; A/X/Y = 16-bit
	
	lda #$0000                 ; A = 0
	ldx #$0000                 ; X = 0
.ClearLoop:
	sta $0000,x                ; Write to WRAM
	sta $1000,x                ; Write to WRAM+4KB
	inx
	inx                        ; X += 2 (16-bit increment)
	cpx #$1000                 ; Compare X to 4KB
	bne .ClearLoop
	
	plp                        ; Restore flags
	rts

; ============================================
; Wait for V-Blank
; ============================================
WaitVBlank:
	php                        ; Save flags
	sep #$30                   ; A/X/Y = 8-bit
	
.WaitLoop:
	lda $2130                  ; Read PPU_VBLANK
	bit #$80                   ; Test bit 7 (V-Blank)
	beq .WaitLoop              ; Loop if not set
	
	plp                        ; Restore flags
	rts

; ============================================
; Process Input (Placeholder)
; ============================================
ProcessInput:
	; TODO: Read joypad and update game state
	rts

; ============================================
; Update Game (Placeholder)
; ============================================
UpdateGame:
	; TODO: Main game logic
	rts

; ============================================
; Update Graphics (Placeholder)
; ============================================
UpdateGraphics:
	; TODO: Update graphics buffers
	rts

; ============================================
; Load Test Graphics (Colored squares for testing)
; ============================================
LoadTestGraphics:
	php                        ; Save flags
	rep #$30                   ; A/X/Y = 16-bit
	
	; Load a simple 8x8 tile pattern to VRAM
	; This is a placeholder - will be replaced with real asset pipeline
	
	; Set VRAM write address
	lda #$0000                 ; VRAM address 0
	sta $2116                  ; VMADDR (low byte)
	sta $2117                  ; VMADDR (high byte)
	
	; Write simple tile data (8x8 pixels, 4 colors)
	; This creates a test pattern: alternating colored squares
	
	ldy #$0000                 ; Counter
.TileLoop:
	; Create simple pattern: alternating color values
	tya                        ; A = loop counter
	and #$0F                   ; Mask to 4 bits
	ora #$00                   ; Combine with tile pattern
	sta $2118                  ; VRAM data
	sta $2119                  ; VRAM data (high byte)
	
	iny
	cpy #$0100                 ; Load 256 bytes of tile data
	bne .TileLoop
	
	plp                        ; Restore flags
	rts

; ============================================
; Interrupt Handlers
; ============================================

; Native Mode NMI (V-Blank)
NMI_Native:
	rti

; Emulation Mode NMI (unused on SNES)
NMI_Emulation:
	rti

; Emulation Mode IRQ (unused on SNES)
IRQ_Emulation:
	rti

; ============================================
; Game Code Modules (to be included)
; ============================================

; .include "engine/core.asm"
; .include "engine/graphics.asm"
; .include "engine/input.asm"
; .include "engine/state.asm"
; .include "game/battle.asm"
; .include "game/menus.asm"
; .include "game/world.asm"

; ============================================
; Game Data (auto-generated from assets)
; ============================================

; .include "data/generated.asm"
; .include "data/monsters.asm"
; .include "data/items.asm"
; .include "data/spells.asm"

; End of ROM
