; ============================================================================
; DW4 Monster Data - Converted to DQ3r SNES Format
; ============================================================================
; Auto-generated from DW4 JSON by json_to_pasm converter
; Each monster: HP(2) EXP(2) Gold(2) ATK(1) DEF(1) AGI(1) Drop(1) Rate(1)
; ============================================================================

MONSTER_COUNT = $32

MONSTER_TABLE:

; Monster $00: Unknown
monster_00:
	.word $0404		; HP 1028
	.word $0108		; Experience 264
	.word $0102		; Gold 258
	.byte $402		; Attack 1026
	.byte $02		; Defense 2
	.byte $05		; Agility 5
	.byte $03		; Drop Item
	.byte $01		; Drop Rate

; Monster $01: Unknown
monster_01:
	.word $0503		; HP 1283
	.word $0203		; Experience 515
	.word $0205		; Gold 517
	.byte $304		; Attack 772
	.byte $02		; Defense 2
	.byte $02		; Agility 2
	.byte $01		; Drop Item
	.byte $01		; Drop Rate

; Monster $02: Unknown
monster_02:
	.word $0102		; HP 258
	.word $0102		; Experience 258
	.word $0101		; Gold 257
	.byte $102		; Attack 258
	.byte $03		; Defense 3
	.byte $03		; Agility 3
	.byte $0a		; Drop Item
	.byte $02		; Drop Rate

; Monster $03: Unknown
monster_03:
	.word $0702		; HP 1794
	.word $0201		; Experience 513
	.word $0103		; Gold 259
	.byte $70a		; Attack 1802
	.byte $03		; Defense 3
	.byte $06		; Agility 6
	.byte $11		; Drop Item
	.byte $01		; Drop Rate

; Monster $04: Unknown
monster_04:
	.word $0b05		; HP 2821
	.word $b7f9		; Experience 47097
	.word $0000		; Gold 0
	.byte $408		; Attack 1032
	.byte $02		; Defense 2
	.byte $0a		; Agility 10
	.byte $0f		; Drop Item
	.byte $1a		; Drop Rate

; Monster $05: Unknown
monster_05:
	.word $1b0f		; HP 6927
	.word $0301		; Experience 769
	.word $0900		; Gold 2304
	.byte $02		; Attack 2
	.byte $00		; Defense 0
	.byte $1d		; Agility 29
	.byte $1d		; Drop Item
	.byte $00		; Drop Rate

; Monster $06: Unknown
monster_06:
	.word $0020		; HP 32
	.word $0006		; Experience 6
	.word $1d10		; Gold 7440
	.byte $1101		; Attack 4353
	.byte $1f		; Defense 31
	.byte $00		; Agility 0
	.byte $00		; Drop Item
	.byte $07		; Drop Rate

; Monster $07: Unknown
monster_07:
	.word $0801		; HP 2049
	.word $1000		; Experience 4096
	.word $001b		; Gold 27
	.byte $1810		; Attack 6160
	.byte $00		; Defense 0
	.byte $09		; Agility 9
	.byte $0a		; Drop Item
	.byte $00		; Drop Rate

; Monster $08: Unknown
monster_08:
	.word $000b		; HP 11
	.word $0b1f		; Experience 2847
	.word $0d07		; Gold 3335
	.byte $430		; Attack 1072
	.byte $0c		; Defense 12
	.byte $00		; Agility 0
	.byte $00		; Drop Item
	.byte $00		; Drop Rate

; Monster $09: Unknown
monster_09:
	.word $0a00		; HP 2560
	.word $0600		; Experience 1536
	.word $0010		; Gold 16
	.byte $f04		; Attack 3844
	.byte $00		; Defense 0
	.byte $16		; Agility 22
	.byte $0d		; Drop Item
	.byte $21		; Drop Rate

; Monster $0A: Unknown
monster_0A:
	.word $2526		; HP 9510
	.word $1304		; Experience 4868
	.word $0c00		; Gold 3072
	.byte $12		; Attack 18
	.byte $0d		; Defense 13
	.byte $19		; Agility 25
	.byte $19		; Drop Item
	.byte $04		; Drop Rate

; Monster $0B: Unknown
monster_0B:
	.word $0418		; HP 1048
	.word $0016		; Experience 22
	.word $0d00		; Gold 3328
	.byte $1300		; Attack 4864
	.byte $1b		; Defense 27
	.byte $04		; Agility 4
	.byte $05		; Drop Item
	.byte $17		; Drop Rate

; Monster $0C: Unknown
monster_0C:
	.word $1805		; HP 6149
	.word $0000		; Experience 0
	.word $050a		; Gold 1290
	.byte $1d0a		; Attack 7434
	.byte $05		; Defense 5
	.byte $19		; Agility 25
	.byte $1a		; Drop Item
	.byte $20		; Drop Rate

; Monster $0D: Unknown
monster_0D:
	.word $001b		; HP 27
	.word $100d		; Experience 4109
	.word $1d04		; Gold 7428
	.byte $713		; Attack 1811
	.byte $1c		; Defense 28
	.byte $00		; Agility 0
	.byte $00		; Drop Item
	.byte $04		; Drop Rate

; Monster $0E: Unknown
monster_0E:
	.word $0500		; HP 1280
	.word $0c0d		; Experience 3085
	.word $0020		; Gold 32
	.byte $1f0c		; Attack 7948
	.byte $00		; Defense 0
	.byte $07		; Agility 7
	.byte $06		; Drop Item
	.byte $0c		; Drop Rate

; Monster $0F: Unknown
monster_0F:
	.word $0a00		; HP 2560
	.word $230c		; Experience 8972
	.word $0700		; Gold 1792
	.byte $22		; Attack 34
	.byte $08		; Defense 8
	.byte $0f		; Agility 15
	.byte $12		; Drop Item
	.byte $0c		; Drop Rate

; Monster $10: Unknown
monster_10:
	.word $0d05		; HP 3333
	.word $6026		; Experience 24614
	.word $1507		; Gold 5383
	.byte $901		; Attack 2305
	.byte $10		; Defense 16
	.byte $0c		; Agility 12
	.byte $0c		; Drop Item
	.byte $27		; Drop Rate

; Monster $11: Unknown
monster_11:
	.word $280e		; HP 10254
	.word $0860		; Experience 2144
	.word $0c0a		; Gold 3082
	.byte $904		; Attack 2308
	.byte $0c		; Defense 12
	.byte $29		; Agility 41
	.byte $2a		; Drop Item
	.byte $e0		; Drop Rate

; Monster $12: Unknown
monster_12:
	.word $002b		; HP 43
	.word $0013		; Experience 19
	.word $2d0e		; Gold 11534
	.byte $c04		; Attack 3076
	.byte $2c		; Defense 44
	.byte $00		; Agility 0
	.byte $00		; Drop Item
	.byte $07		; Drop Rate

; Monster $13: Unknown
monster_13:
	.word $1200		; HP 4608
	.word $9702		; Experience 38658
	.word $0130		; Gold 304
	.byte $2f94		; Attack 12180
	.byte $00		; Defense 0
	.byte $19		; Agility 25
	.byte $0e		; Drop Item
	.byte $09		; Drop Rate

; Monster $14: Unknown
monster_14:
	.word $2411		; HP 9233
	.word $3397		; Experience 13207
	.word $1400		; Gold 5120
	.byte $132		; Attack 306
	.byte $23		; Defense 35
	.byte $08		; Agility 8
	.byte $02		; Drop Item
	.byte $96		; Drop Rate

; Monster $15: Unknown
monster_15:
	.word $971a		; HP 38682
	.word $0036		; Experience 54
	.word $030b		; Gold 779
	.byte $31a0		; Attack 12704
	.byte $1b		; Defense 27
	.byte $97		; Agility 151
	.byte $97		; Drop Item
	.byte $37		; Drop Rate

; Monster $16: Unknown
monster_16:
	.word $3897		; HP 14487
	.word $0380		; Experience 896
	.word $9703		; Gold 38659
	.byte $1303		; Attack 4867
	.byte $97		; Defense 151
	.byte $39		; Agility 57
	.byte $3a		; Drop Item
	.byte $80		; Drop Rate

; Monster $17: Unknown
monster_17:
	.word $003b		; HP 59
	.word $2515		; Experience 9493
	.word $3d14		; Gold 15636
	.byte $971f		; Attack 38687
	.byte $3c		; Defense 60
	.byte $e0		; Agility 224
	.byte $20		; Drop Item
	.byte $13		; Drop Rate

; Monster $18: Unknown
monster_18:
	.word $0ca0		; HP 3232
	.word $101f		; Experience 4127
	.word $0540		; Gold 1344
	.byte $3f9e		; Attack 16286
	.byte $03		; Defense 3
	.byte $15		; Agility 21
	.byte $10		; Drop Item
	.byte $19		; Drop Rate

; Monster $19: Unknown
monster_19:
	.word $2110		; HP 8464
	.word $4310		; Experience 17168
	.word $3106		; Gold 12550
	.byte $442		; Attack 1090
	.byte $0e		; Defense 14
	.byte $1d		; Agility 29
	.byte $13		; Drop Item
	.byte $07		; Drop Rate

; Monster $1A: Unknown
monster_1A:
	.word $0c0d		; HP 3085
	.word $2046		; Experience 8262
	.word $1f10		; Gold 7952
	.byte $1d60		; Attack 7520
	.byte $24		; Defense 36
	.byte $18		; Agility 24
	.byte $1c		; Drop Item
	.byte $47		; Drop Rate

; Monster $1B: Unknown
monster_1B:
	.word $488c		; HP 18572
	.word $3e46		; Experience 15942
	.word $0c00		; Gold 3072
	.byte $130a		; Attack 4874
	.byte $14		; Defense 20
	.byte $ff		; Agility 255
	.byte $06		; Drop Item
	.byte $82		; Drop Rate

; Monster $1C: Unknown
monster_1C:
	.word $090b		; HP 2315
	.word $0361		; Experience 865
	.word $0164		; Gold 356
	.byte $76ff		; Attack 30463
	.byte $b9		; Defense 185
	.byte $00		; Agility 0
	.byte $e4		; Drop Item
	.byte $00		; Drop Rate

; Monster $1D: Unknown
monster_1D:
	.word $6202		; HP 25090
	.word $0061		; Experience 97
	.word $0161		; Gold 353
	.byte $e0		; Attack 224
	.byte $63		; Defense 99
	.byte $00		; Agility 0
	.byte $e1		; Drop Item
	.byte $02		; Drop Rate

; Monster $1E: Unknown
monster_1E:
	.word $e002		; HP 57346
	.word $0062		; Experience 98
	.word $00e0		; Gold 224
	.byte $1ff		; Attack 511
	.byte $e1		; Defense 225
	.byte $01		; Agility 1
	.byte $e1		; Drop Item
	.byte $00		; Drop Rate

; Monster $1F: Unknown
monster_1F:
	.word $e301		; HP 58113
	.word $0061		; Experience 97
	.word $01e1		; Gold 481
	.byte $62		; Attack 98
	.byte $e2		; Defense 226
	.byte $01		; Agility 1
	.byte $60		; Drop Item
	.byte $01		; Drop Rate

; Monster $20: Unknown
monster_20:
	.word $6203		; HP 25091
	.word $0262		; Experience 610
	.word $0162		; Gold 354
	.byte $61		; Attack 97
	.byte $61		; Defense 97
	.byte $01		; Agility 1
	.byte $63		; Drop Item
	.byte $00		; Drop Rate

; Monster $21: Unknown
monster_21:
	.word $6003		; HP 24579
	.word $0060		; Experience 96
	.word $0460		; Gold 1120
	.byte $260		; Attack 608
	.byte $e0		; Defense 224
	.byte $06		; Agility 6
	.byte $60		; Drop Item
	.byte $03		; Drop Rate

; Monster $22: Unknown
monster_22:
	.word $ff05		; HP 65285
	.word $0169		; Experience 361
	.word $0261		; Gold 609
	.byte $6a		; Attack 106
	.byte $6b		; Defense 107
	.byte $00		; Agility 0
	.byte $e8		; Drop Item
	.byte $00		; Drop Rate

; Monster $23: Unknown
monster_23:
	.word $6e03		; HP 28163
	.word $0166		; Experience 358
	.word $01e5		; Gold 485
	.byte $6d		; Attack 109
	.byte $65		; Defense 101
	.byte $00		; Agility 0
	.byte $69		; Drop Item
	.byte $00		; Drop Rate

; Monster $24: Unknown
monster_24:
	.word $6201		; HP 25089
	.word $03e2		; Experience 994
	.word $016e		; Gold 366
	.byte $4e2		; Attack 1250
	.byte $6c		; Defense 108
	.byte $00		; Agility 0
	.byte $ee		; Drop Item
	.byte $00		; Drop Rate

; Monster $25: Unknown
monster_25:
	.word $6000		; HP 24576
	.word $00e4		; Experience 228
	.word $01e0		; Gold 480
	.byte $1e3		; Attack 483
	.byte $60		; Defense 96
	.byte $00		; Agility 0
	.byte $e6		; Drop Item
	.byte $00		; Drop Rate

; Monster $26: Unknown
monster_26:
	.word $6d03		; HP 27907
	.word $026d		; Experience 621
	.word $04ed		; Gold 1261
	.byte $16d		; Attack 365
	.byte $6d		; Defense 109
	.byte $06		; Agility 6
	.byte $67		; Drop Item
	.byte $01		; Drop Rate

; Monster $27: Unknown
monster_27:
	.word $ff00		; HP 65280
	.word $06ff		; Experience 1791
	.word $0061		; Gold 97
	.byte $e1		; Attack 225
	.byte $e0		; Defense 224
	.byte $00		; Agility 0
	.byte $61		; Drop Item
	.byte $01		; Drop Rate

; Monster $28: Unknown
monster_28:
	.word $6000		; HP 24576
	.word $03e0		; Experience 992
	.word $07ff		; Gold 2047
	.byte $1e0		; Attack 480
	.byte $e0		; Defense 224
	.byte $02		; Agility 2
	.byte $e1		; Drop Item
	.byte $00		; Drop Rate

; Monster $29: Unknown
monster_29:
	.word $8008		; HP 32776
	.word $e201		; Experience 57857
	.word $e100		; Gold 57600
	.byte $6400		; Attack 25600
	.byte $00		; Defense 0
	.byte $63		; Agility 99
	.byte $03		; Drop Item
	.byte $61		; Drop Rate

; Monster $2A: Unknown
monster_2A:
	.word $01e1		; HP 481
	.word $0163		; Experience 355
	.word $00e3		; Gold 227
	.byte $e709		; Attack 59145
	.byte $00		; Defense 0
	.byte $80		; Agility 128
	.byte $62		; Drop Item
	.byte $01		; Drop Rate

; Monster $2B: Unknown
monster_2B:
	.word $e300		; HP 58112
	.word $0aff		; Experience 2815
	.word $01a0		; Gold 416
	.byte $8080		; Attack 32896
	.byte $e0		; Defense 224
	.byte $00		; Agility 0
	.byte $2d		; Drop Item
	.byte $ff		; Drop Rate

; Monster $2C: Unknown
monster_2C:
	.word $00e1		; HP 225
	.word $800c		; Experience 32780
	.word $0dff		; Gold 3583
	.byte $e001		; Attack 57345
	.byte $00		; Defense 0
	.byte $ff		; Agility 255
	.byte $61		; Drop Item
	.byte $02		; Drop Rate

; Monster $2D: Unknown
monster_2D:
	.word $6101		; HP 24833
	.word $0eff		; Experience 3839
	.word $ff80		; Gold 65408
	.byte $e0		; Attack 224
	.byte $e0		; Defense 224
	.byte $01		; Agility 1
	.byte $0f		; Drop Item
	.byte $61		; Drop Rate

; Monster $2E: Unknown
monster_2E:
	.word $0261		; HP 609
	.word $02e0		; Experience 736
	.word $10ff		; Gold 4351
	.byte $160		; Attack 352
	.byte $60		; Defense 96
	.byte $00		; Agility 0
	.byte $62		; Drop Item
	.byte $00		; Drop Rate

; Monster $2F: Unknown
monster_2F:
	.word $e000		; HP 57344
	.word $11ff		; Experience 4607
	.word $0161		; Gold 353
	.byte $e0		; Attack 224
	.byte $e0		; Defense 224
	.byte $01		; Agility 1
	.byte $62		; Drop Item
	.byte $00		; Drop Rate

; Monster $30: Unknown
monster_30:
	.word $e002		; HP 57346
	.word $00e4		; Experience 228
	.word $01e3		; Gold 483
	.byte $1e0		; Attack 480
	.byte $65		; Defense 101
	.byte $00		; Agility 0
	.byte $e3		; Drop Item
	.byte $00		; Drop Rate

; Monster $31: Unknown
monster_31:
	.word $6100		; HP 24832
	.word $03e1		; Experience 993
	.word $0260		; Gold 608
	.byte $61		; Attack 97
	.byte $61		; Defense 97
	.byte $01		; Agility 1
	.byte $60		; Drop Item
	.byte $03		; Drop Rate

MONSTER_TABLE_END: