; ============================================================================
; DW4 Items (subset) - Example integration
; ============================================================================

; Structure (example): id, price (16-bit), flags (16-bit)

ITEM_TABLE:
	.word $0001, $0064, $0000   ; Herb
	.word $0002, $00c8, $0000   ; Antidote
	.word $0003, $0137, $0001   ; Torch (flag: consumable)
	.word $0004, $0bb8, $0002   ; Iron Spear (flag: weapon)
	.word $0005, $1f40, $0002   ; Steel Sword (flag: weapon)
ITEM_TABLE_END:

ITEM_COUNT:
	.word $0005
