; ============================================================================
; DQ4r - Utility Subroutines and Common Patterns
; ============================================================================
; Poppy does not support macro definitions (unlike ASAR/ca65).
; These are documented assembly patterns for common operations.
; To use these, copy the relevant code section into your assembly files.
; ============================================================================

; ============================================================================
; V-Blank Synchronization Pattern
; ============================================================================
; Usage: Inline this code wherever you need V-Blank synchronization
; 
; wait_vblank:
;     lda PPU_VBLANK        ; Read V-Blank status
;     bit #$80              ; Test bit 7
;     beq wait_vblank       ; Loop if not in V-Blank
;
; No parameters, preserves X and Y

; ============================================================================
; Switch to Native Mode Pattern
; ============================================================================
; Usage: Call at startup to switch from emulation to native mode
;
; switch_native:
;     clc                   ; Clear carry
;     xce                   ; Exchange with emulation flag
;     rep #$30              ; 16-bit A/X/Y
;

; ============================================================================
; Memory Operations - 16-bit Patterns
; ============================================================================
; Load 16-bit constant:
;     rep #$20              ; 16-bit accumulator
;     lda #$1234            ; Load 16-bit value
;     sep #$20              ; Back to 8-bit
;
; Increment 16-bit address:
;     rep #$20
;     inc addr
;     sep #$20
;     
; Decrement 16-bit address:
;     rep #$20
;     dec addr
;     sep #$20

; ============================================================================
; Copy Memory Block Pattern
; ============================================================================
; Copy count bytes from src to dst
;
; copy_block:
;     ldx #0                ; Start at offset 0
; copy_loop:
;     lda src,x             ; Load source byte
;     sta dst,x             ; Store to destination
;     inx                   ; Next byte
;     cpx #count            ; Check count
;     bne copy_loop         ; Continue if not done

; ============================================================================
; DMA Setup Pattern (for PPU transfers)
; ============================================================================
; Example: Copy data to VRAM via DMA
;
; dma_setup:
;     sep #$20              ; 8-bit mode
;     lda #$01              ; DMA mode (fixed source, increment dest)
;     sta $4300             ; DMA control byte for channel 0
;     lda #$18              ; VRAM data register
;     sta $4301             ; B-Bus address
;     ; Set source address, bank, and size as needed

; ============================================================================
; Utility Subroutines (actual code, not patterns)
; ============================================================================

; Clear 8 KB of WRAM - useful for initialization
clear_wram:
sep #$20                   ; 8-bit mode
lda #$00                   ; Value to store
ldx #$0000                 ; Index
@clear_loop:
sta $7E0000,x              ; Store in WRAM
inx
cpx #$2000                 ; 8 KB = $2000 bytes
bne @clear_loop            ; Continue until done
rts

; ============================================================================
; Notes
; ============================================================================
; - Poppy does not support macro definitions or include files with macros
; - Refer to these patterns and copy relevant code into your assembly files
; - Always ensure processor mode (8-bit vs 16-bit A/X/Y) matches expectations
; - Comments should clarify whether code is 8-bit or 16-bit mode
