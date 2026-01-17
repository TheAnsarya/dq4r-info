; ============================================================================
; Dragon Quest IV Remix - Minimal Working Build
; ============================================================================

.system:snes
lorom

; ============================================================================
; Minimal Hardware Constants
; ============================================================================
PPU_INIDISP = $2100           ; Screen display
PPU_BGMODE  = $2105           ; BG mode/size
PPU_TM      = $212c           ; Enable BG layers
PPU_CGADDR  = $2121           ; CGRAM address
PPU_CGDATA  = $2122           ; CGRAM data
NMITIMEN    = $4200           ; Interrupt enable (NMI/IRQ, joypad auto-read)
RDNMI       = $4210           ; NMI flag (read to acknowledge)
JOY1L       = $4218           ; Joypad 1 low byte
JOY1H       = $4219           ; Joypad 1 high byte

; Engine modules
.include "engine/core.pasm"
.include "engine/input.pasm"
.include "engine/scheduler.pasm"
.include "data/items.pasm"

; ============================================================================
; Code Entry Point
; ============================================================================

.org $8000

reset:
sei                        ; Disable interrupts
clc                        ; For native mode
xce                        ; Switch to native mode
rep #$30                   ; 16-bit A/X/Y

lda #$1fff                 ; Stack pointer
tcs                        ; Set stack

; Enable NMI and joypad auto-read
sep #$20                   ; 8-bit A
lda #$81                   ; b7=NMI enable, b0=joypad auto-read
sta NMITIMEN
rep #$20                   ; 16-bit A

; Initialize engine state (DQ3r-based)
jsr engine_init

; Basic PPU init (keep screen on)
jsr init_ppu

; Main loop - just wait for interrupt
loop1:
jsr read_input            ; Read joypad into WRAM
jsr engine_tick           ; Per-frame engine work
wai                        ; Wait for V-Blank
jmp loop1                  ; Loop forever

; ============================================================================
; Interrupt Handlers
; ============================================================================

nmi_handler:
sep #$20                   ; 8-bit A
lda RDNMI                  ; Acknowledge NMI
rep #$20                   ; 16-bit A
jsr engine_vblank          ; Run engine VBlank logic
rti

irq_handler:
rti

cop_handler:
rti

brk_handler:
rti

abort_handler:
rti

; =========================================================================
; Basic PPU Initialization
; =========================================================================
init_ppu:
	sep #$20                   ; 8-bit A
	lda #$8f                   ; Forced blank + brightness 15
	sta PPU_INIDISP
	lda #$00                   ; Mode 0
	sta PPU_BGMODE
	lda #$01                   ; Enable BG1 only
	sta PPU_TM
	; Simple palette: CGRAM color 0 = black, color 1 = white
	lda #$00
	sta PPU_CGADDR             ; CGRAM addr = 0
	lda #$00                   ; color 0 = $0000
	sta PPU_CGDATA
	sta PPU_CGDATA
	lda #$01                   ; CGRAM addr = 1
	sta PPU_CGADDR
	lda #$ff                   ; white low byte (BGR555)
	sta PPU_CGDATA
	lda #$7f                   ; white high byte
	sta PPU_CGDATA
	lda #$0f                   ; Turn display on (brightness 15)
	sta PPU_INIDISP
	rep #$20                   ; 16-bit A
	rts

; ============================================================================
; ROM Header (0xFFC0)
; ============================================================================

.org $ffc0

.byte "DQ4 REMIX" 
.byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
.byte $31                      ; LoROM + FastROM
.byte $02                      ; ROM type
.byte $0c                      ; ROM size (4 MB)
.byte $03                      ; SRAM size (8 KB)
.byte $01                      ; Country (North America)
.byte $33                      ; Developer
.byte $00                      ; Version

.word $0000                    ; Checksum complement
.word $ffff                    ; Checksum

; ============================================================================
; Native Mode Vectors (0xFFE0)
; ============================================================================

.org $ffe0

.word $0000
.word $0000
.word cop_handler
.word brk_handler
.word abort_handler
.word nmi_handler

; ============================================================================
; Emulation Mode Vectors (0xFFEA)
; ============================================================================

.org $ffea

.word cop_handler
.word brk_handler

; ============================================================================
; 6502/Emulation Vectors (0xFFFA)
; ============================================================================

.org $fffa

.word nmi_handler
.word reset
.word irq_handler
