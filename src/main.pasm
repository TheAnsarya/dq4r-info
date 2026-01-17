; ============================================================================
; Dragon Quest IV Remix - Minimal Working Build
; ============================================================================

.system:snes
lorom

; ============================================================================
; Minimal Hardware Constants
; ============================================================================
PPU_INIDISP = $2100           ; Screen display

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

; Main loop - just wait for interrupt
loop1:
wai                        ; Wait for V-Blank
jmp loop1                  ; Loop forever

; ============================================================================
; Interrupt Handlers
; ============================================================================

nmi_handler:
rti

irq_handler:
rti

cop_handler:
rti

brk_handler:
rti

abort_handler:
rti

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
