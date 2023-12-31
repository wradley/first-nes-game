
; ================================================================= iNES Header
.segment "HEADER"

INES_MAPPER = 0 ; 0 = NROM https://www.nesdev.org/wiki/NROM
INES_MIRROR = 1 ; 0 = horizontal mirroring, 1 = vertical mirroring
INES_SRAM   = 0 ; 1 = Cartridge contains battery-backed PRG RAM ($6000-7FFF) 
                ;     or other persistent memory

.byte 'N', 'E', 'S', $1A
.byte $02 ; 32KB PRG ROM
.byte $01 ; 8KB CHR ROM
.byte ((INES_MAPPER & $f) << 4) | (INES_SRAM << 1) | INES_MIRROR
.byte (INES_MAPPER & $f0)
.byte $0, $0, $0, $0, $0, $0, $0, $0 ; padding

; ===================================================================== CHR ROM
.segment "TILES"
.incbin "background.chr"
.incbin "sprite.chr"

; ===================================================================== Vectors
.segment "VECTORS"
.word nmi
.word reset
.word irq

.segment "CODE"
reset:
    sei ; disable IRQs
    cld ; disable decimal mode
    rti

nmi:
    rti

irq:
    rti

; ======================================================================== main

PPU_MASK = $2001

main:
    lda %10000000 ; intensify blues
    sta PPU_MASK
:   jmp :-        ; hang