; iNES Header
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