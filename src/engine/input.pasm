; ============================================================================
; DQ3r Engine Input - Skeleton
; ============================================================================

ENGINE_INPUT_LO = $7e0000
ENGINE_INPUT_HI = $7e0001
ENGINE_INPUT_PREV_LO = $7e0002
ENGINE_INPUT_PREV_HI = $7e0003
ENGINE_INPUT_JUST_LO = $7e0004
ENGINE_INPUT_JUST_HI = $7e0005

; ----------------------------------------------------------------------------
; read_input: Reads Joypad 1 into WRAM
; ----------------------------------------------------------------------------
read_input:
	sep #$20               ; 8-bit A
	; Save previous state
	lda ENGINE_INPUT_LO
	sta ENGINE_INPUT_PREV_LO
	lda ENGINE_INPUT_HI
	sta ENGINE_INPUT_PREV_HI
	lda JOY1L
	sta ENGINE_INPUT_LO
	lda JOY1H
	sta ENGINE_INPUT_HI
	; Compute just-pressed = current & (~prev)
	; Low byte
	lda ENGINE_INPUT_PREV_LO
	eor #$ff
	and ENGINE_INPUT_LO
	sta ENGINE_INPUT_JUST_LO
	; High byte
	lda ENGINE_INPUT_PREV_HI
	eor #$ff
	and ENGINE_INPUT_HI
	sta ENGINE_INPUT_JUST_HI
	rep #$20               ; 16-bit A
	rts
