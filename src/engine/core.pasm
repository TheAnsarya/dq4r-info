; ============================================================================
; DQ3r Engine Core - Skeleton
; ============================================================================

; WRAM layout (temporary)
ENGINE_TICK_COUNT = $7e0010   ; 16-bit tick counter
ENGINE_FLAGS  = $7e0012   ; 16-bit flags
ITEM_TABLE_PTR = $7e0030   ; Pointer to item table (16-bit address for now)

; ----------------------------------------------------------------------------
; engine_init: Initialize basic engine state
; ----------------------------------------------------------------------------
engine_init:
	sep #$20               ; 8-bit A
	lda #$00
	sta ENGINE_TICK_COUNT        ; low byte
	sta ENGINE_TICK_COUNT+1      ; high byte
	sta ENGINE_FLAGS
	sta ENGINE_FLAGS+1
	; Init scheduler
	jsr scheduler_init
	; Point to item table (ROM address placeholder)
	rep #$20
	lda #ITEM_TABLE
	sta ITEM_TABLE_PTR
	rep #$20               ; 16-bit A
	rts

; ----------------------------------------------------------------------------
; engine_tick: Per-frame logic executed from main loop
; ----------------------------------------------------------------------------
engine_tick:
	; TODO: Call scheduler, scene manager, etc. (DQ3r base)
	jsr scheduler_tick
	rts

; ----------------------------------------------------------------------------
; engine_vblank: Runs during NMI/VBlank
; ----------------------------------------------------------------------------
engine_vblank:
	rep #$20               ; 16-bit A
	lda ENGINE_TICK_COUNT
	clc
	adc #$0001
	sta ENGINE_TICK_COUNT
	jsr scheduler_vblank
	rts
