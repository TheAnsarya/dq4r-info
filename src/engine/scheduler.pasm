; ============================================================================
; DQ3r Engine Scheduler - Skeleton
; ============================================================================

; Simple per-frame scheduler flags
SCHED_FLAGS      = $7e0020
SCHED_RUN_VBLANK = $0001
SCHED_RUN_TICK   = $0002

scheduler_init:
	sep #$20
	lda #$00
	sta SCHED_FLAGS
	sta SCHED_FLAGS+1
	rep #$20
	rts

scheduler_tick:
	; TODO: invoke tasks queued for this frame
	rts

scheduler_vblank:
	; TODO: invoke vblank-specific tasks (VRAM/CGRAM DMA)
	rts
