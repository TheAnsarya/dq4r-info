; Game Constants and Equates

; ============================================
; Game Constants
; ============================================

; Maximum values
MAX_PARTY_SIZE  = 6           ; Maximum party members
MAX_INVENTORY   = 20          ; Max items in inventory
MAX_SPELLS      = 8           ; Spells per character
MAX_EQUIPMENT   = 4           ; Equipment slots (weapon, armor, shield, helmet)

MAX_LEVEL       = 99          ; Maximum character level
MAX_EXP         = 999999      ; Maximum experience
MAX_HP          = 9999        ; Maximum HP
MAX_MP          = 999         ; Maximum MP

MAX_MONSTERS    = 60          ; Monster types
MAX_ITEMS       = 100         ; Item database size
MAX_SPELLS_DB   = 50          ; Spell database size
MAX_MAPS        = 256         ; Map database size

MAX_MONEY       = 65535       ; Maximum gold (16-bit)

; ============================================
; Character IDs
; ============================================

CHARACTER_HERO          = 0
CHARACTER_PRINCESS      = 1
CHARACTER_MERCHANT      = 2
CHARACTER_WINGED_MAN    = 3
CHARACTER_HEALER        = 4
CHARACTER_SAGE          = 5

; ============================================
; Equipment Types
; ============================================

EQUIP_WEAPON    = 0
EQUIP_ARMOR     = 1
EQUIP_SHIELD    = 2
EQUIP_HELMET    = 3

; ============================================
; Item Types
; ============================================

ITEM_CONSUMABLE = 0
ITEM_WEAPON     = 1
ITEM_ARMOR      = 2
ITEM_SHIELD     = 3
ITEM_HELMET     = 4
ITEM_KEY        = 5

; ============================================
; Spell Types
; ============================================

SPELL_HEAL      = 0
SPELL_DAMAGE    = 1
SPELL_BUFF      = 2
SPELL_DEBUFF    = 3
SPELL_SUPPORT   = 4

; ============================================
; Status Effects
; ============================================

STATUS_NORMAL   = $00
STATUS_POISON   = $01
STATUS_SLEEP    = $02
STATUS_CONFUSION= $04
STATUS_CURSE    = $08
STATUS_SILENCE  = $10
STATUS_SEALED   = $20

; ============================================
; Battle Constants
; ============================================

BATTLE_MODE_NORMAL  = 0
BATTLE_MODE_ENCOUNTER = 1
BATTLE_MODE_BOSS    = 2

MAX_ENEMY_GROUP = 32        ; Maximum different enemy groups

; ============================================
; Menu States
; ============================================

MENU_NONE       = 0
MENU_MAIN       = 1
MENU_STATUS     = 2
MENU_EQUIPMENT  = 3
MENU_ITEMS      = 4
MENU_MAGIC      = 5
MENU_SAVE       = 6
MENU_LOAD       = 7
MENU_BATTLE     = 8

; ============================================
; Map IDs
; ============================================

MAP_TITLE_SCREEN    = 0
MAP_TOWN_1          = 1
MAP_DUNGEON_1       = 2
MAP_WORLD_MAP       = 3
MAP_FINAL_DUNGEON   = 255

; ============================================
; Game Flags (0-255 total)
; ============================================

; Story progression flags (0-63)
FLAG_CHAPTER_1_START    = 0
FLAG_CHAPTER_1_COMPLETE = 1
FLAG_CHAPTER_2_START    = 2
FLAG_CHAPTER_2_COMPLETE = 3
FLAG_CHAPTER_3_START    = 4
FLAG_CHAPTER_3_COMPLETE = 5
FLAG_CHAPTER_4_START    = 6
FLAG_CHAPTER_4_COMPLETE = 7
FLAG_CHAPTER_5_START    = 8
FLAG_CHAPTER_5_COMPLETE = 9

; Town/dungeon state flags (64-127)
FLAG_TOWN_1_VISITED     = 64
FLAG_DUNGEON_1_CLEAR    = 65

; NPC interaction flags (128-191)
FLAG_NPC_1_MET          = 128
FLAG_NPC_1_QUEST_DONE   = 129

; Misc flags (192-255)
FLAG_SPECIAL_EVENT_1    = 192
FLAG_ITEM_RECEIVED_1    = 193

; ============================================
; Switch Constants (0-255 total)
; ============================================

; Gameplay switches
SWITCH_GAME_PAUSED      = 0
SWITCH_BATTLE_ACTIVE    = 1
SWITCH_MENU_OPEN        = 2
SWITCH_DIALOG_ACTIVE    = 3
SWITCH_ANIMATION_RUNNING = 4

; Map switches
SWITCH_MAP_BLOCKED      = 5
SWITCH_ENEMY_SPAWN      = 6

; ============================================
; Damage Calculation Constants
; ============================================

DAMAGE_VARIANCE         = 25  ; ±25% damage variance

; Attack power modifiers
ATTACK_CRITICAL         = 2   ; Critical hit multiplier (2x)
ATTACK_WEAK             = 50  ; Weak hit (50%)
ATTACK_STRONG           = 150 ; Strong hit (150%)

; Magic resistance
MAGIC_RESIST_NONE       = 0
MAGIC_RESIST_LOW        = 25  ; 25% reduction
MAGIC_RESIST_MEDIUM     = 50  ; 50% reduction
MAGIC_RESIST_HIGH       = 75  ; 75% reduction

; ============================================
; Experience Values
; ============================================

EXP_NORMAL_ENEMY        = 10
EXP_STRONG_ENEMY        = 25
EXP_BOSS_ENEMY          = 100

; ============================================
; Item/Equipment Properties
; ============================================

; Equipment bonuses
BONUS_ATTACK            = 5   ; Attack increase per unit
BONUS_DEFENSE           = 3   ; Defense increase per unit
BONUS_MAGIC             = 2   ; Magic power increase per unit

; ============================================
; Movement Constants
; ============================================

SPEED_NORMAL            = 1   ; 1 pixel per frame
SPEED_WALK              = 2   ; 2 pixels per frame
SPEED_RUN               = 3   ; 3 pixels per frame

; ============================================
; Frame Timing
; ============================================

FRAMES_PER_SECOND       = 60
FRAMES_PER_ANIMATION    = 4   ; Animation frames
FRAMES_PER_TEXT_CHAR    = 2   ; Text scroll speed

; ============================================
; Color Constants (BGR555 format)
; ============================================

; Palette index constants
COLOR_BLACK             = 0
COLOR_WHITE             = 31
COLOR_RED               = 1
COLOR_GREEN             = 2
COLOR_BLUE              = 4
COLOR_YELLOW            = (1 + 2)
COLOR_CYAN              = (2 + 4)
COLOR_MAGENTA           = (1 + 4)

; ============================================
; Audio Constants
; ============================================

; Music IDs
MUSIC_TITLE_THEME       = 0
MUSIC_FIELD_THEME       = 1
MUSIC_TOWN_THEME        = 2
MUSIC_DUNGEON_THEME     = 3
MUSIC_BOSS_THEME        = 4
MUSIC_BATTLE_THEME      = 5
MUSIC_VICTORY_THEME     = 6

; Sound effect IDs
SFX_SELECTION           = 0
SFX_ACCEPT              = 1
SFX_CANCEL              = 2
SFX_ATTACK              = 3
SFX_MAGIC               = 4
SFX_DAMAGE              = 5
SFX_HEAL                = 6
SFX_LEVEL_UP            = 7

; ============================================
; Controller Input
; ============================================

; Input states
INPUT_IDLE              = 0
INPUT_MENU              = 1
INPUT_BATTLE            = 2
INPUT_DIALOG            = 3

; Button masks
BTN_A               = $0001
BTN_B               = $0002
BTN_X               = $0004
BTN_Y               = $0008
BTN_START           = $0010
BTN_SELECT          = $0020
BTN_L               = $0040
BTN_R               = $0080

; Direction buttons
DIR_UP              = $0100
DIR_DOWN            = $0200
DIR_LEFT            = $0400
DIR_RIGHT           = $0800

