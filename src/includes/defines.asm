; DQ4r - Hardware defines
; SNES register definitions

; PPU Registers
!INIDISP    = $2100    ; Display control
!OBSEL      = $2101    ; Object size and base
!OAMADDL    = $2102    ; OAM address low
!OAMADDH    = $2103    ; OAM address high
!OAMDATA    = $2104    ; OAM data
!BGMODE     = $2105    ; BG mode and tile size
!MOSAIC     = $2106    ; Mosaic effect
!BG1SC      = $2107    ; BG1 tilemap address
!BG2SC      = $2108    ; BG2 tilemap address
!BG3SC      = $2109    ; BG3 tilemap address
!BG4SC      = $210A    ; BG4 tilemap address
!BG12NBA    = $210B    ; BG1/2 tile base
!BG34NBA    = $210C    ; BG3/4 tile base
!BG1HOFS    = $210D    ; BG1 horizontal scroll
!BG1VOFS    = $210E    ; BG1 vertical scroll
!BG2HOFS    = $210F    ; BG2 horizontal scroll
!BG2VOFS    = $2110    ; BG2 vertical scroll
!BG3HOFS    = $2111    ; BG3 horizontal scroll
!BG3VOFS    = $2112    ; BG3 vertical scroll
!BG4HOFS    = $2113    ; BG4 horizontal scroll
!BG4VOFS    = $2114    ; BG4 vertical scroll
!VMAINC     = $2115    ; VRAM address increment
!VMADDL     = $2116    ; VRAM address low
!VMADDH     = $2117    ; VRAM address high
!VMDATAL    = $2118    ; VRAM data low
!VMDATAH    = $2119    ; VRAM data high
!M7SEL      = $211A    ; Mode 7 settings
!M7A        = $211B    ; Mode 7 matrix A
!M7B        = $211C    ; Mode 7 matrix B
!M7C        = $211D    ; Mode 7 matrix C
!M7D        = $211E    ; Mode 7 matrix D
!M7X        = $211F    ; Mode 7 center X
!M7Y        = $2120    ; Mode 7 center Y
!CGADD      = $2121    ; CGRAM address
!CGDATA     = $2122    ; CGRAM data
!W12SEL     = $2123    ; Window mask BG1/2
!W34SEL     = $2124    ; Window mask BG3/4
!WOBJSEL    = $2125    ; Window mask OBJ/color
!WH0        = $2126    ; Window 1 left
!WH1        = $2127    ; Window 1 right
!WH2        = $2128    ; Window 2 left
!WH3        = $2129    ; Window 2 right
!WBGLOG     = $212A    ; Window logic BG
!WOBJLOG    = $212B    ; Window logic OBJ
!TM         = $212C    ; Main screen enable
!TS         = $212D    ; Sub screen enable
!TMW        = $212E    ; Main screen window
!TSW        = $212F    ; Sub screen window
!CGWSEL     = $2130    ; Color math control A
!CGADSUB    = $2131    ; Color math control B
!COLDATA    = $2132    ; Color data
!SETINI     = $2133    ; Screen mode select

; APU Registers
!APUIO0     = $2140    ; APU I/O port 0
!APUIO1     = $2141    ; APU I/O port 1
!APUIO2     = $2142    ; APU I/O port 2
!APUIO3     = $2143    ; APU I/O port 3

; CPU Registers
!NMITIMEN   = $4200    ; NMI/Timer/Controller enable
!WRIO       = $4201    ; Programmable I/O port
!WRMPYA     = $4202    ; Multiply A
!WRMPYB     = $4203    ; Multiply B
!WRDIVL     = $4204    ; Dividend low
!WRDIVH     = $4205    ; Dividend high
!WRDIVB     = $4206    ; Divisor
!HTIMEL     = $4207    ; H timer low
!HTIMEH     = $4208    ; H timer high
!VTIMEL     = $4209    ; V timer low
!VTIMEH     = $420A    ; V timer high
!MDMAEN     = $420B    ; DMA enable
!HDMAEN     = $420C    ; HDMA enable
!MEMSEL     = $420D    ; ROM speed

; Controller Registers
!JOY1L      = $4218    ; Joypad 1 low
!JOY1H      = $4219    ; Joypad 1 high
!JOY2L      = $421A    ; Joypad 2 low
!JOY2H      = $421B    ; Joypad 2 high

; DMA Registers (channel 0)
!DMAP0      = $4300    ; DMA control
!BBAD0      = $4301    ; DMA destination
!A1T0L      = $4302    ; DMA source low
!A1T0H      = $4303    ; DMA source high
!A1B0       = $4304    ; DMA source bank
!DAS0L      = $4305    ; DMA size low
!DAS0H      = $4306    ; DMA size high
