.include "constants.s"
.include "header.s"
; ===================================================================== CHR ROM
.segment "TILES"
.incbin "../resources/bg.chr"
.incbin "../resources/sprite.chr"

; ===================================================================== Vectors
.segment "VECTORS"
.word nmi
.word reset
.word irq

.segment "CODE"
reset:
    sei ; disable IRQs
    cld ; disable decimal mode
    jmp main
    rti

.macro transfer_oam
    lda #.lobyte(OAM_RAM_ADDR)
    sta OAM_ADDR
    lda #.hibyte(OAM_RAM_ADDR)
    sta OAM_DMA
.endmacro

nmi:
    transfer_oam
    rti

irq:
    rti

; ======================================================================== main
.segment "CODE"

main:
    jsr load_palette_data
    jsr demo_load_sprite
    lda #%10000000   ; enable NMI, sprites from Pattern Table 0
    sta PPU_CTRL
    lda #%00010000   ; no intensify (black background), enable sprites
    sta PPU_MASK
:   jmp :-        ; hang

load_palette_data:
    lda PPU_STATUS ; read PPU status to reset the high/low latch to high
    lda #.hibyte(PALETTE_STRT_ADDR)
    sta PPU_ADDR
    lda #.lobyte(PALETTE_STRT_ADDR)
    sta PPU_ADDR
    ldx #$00
    :
        lda palette_data, x
        sta PPU_DATA
        inx
        cpx #$20
        bne :-
    rts

demo_load_sprite:
    ldx #$00
    ; y pos
    lda #$78
    sta OAM_RAM_ADDR, x
    inx
    ; tile number
    lda #211
    sta OAM_RAM_ADDR, x
    inx
    ; attributes
    lda #%00000000
    sta OAM_RAM_ADDR, x
    inx
    ; x pos
    lda #$80
    sta OAM_RAM_ADDR, x
    rts

; ============================================================== Read-Only Data
.segment "RODATA"
palette_data:
.incbin "../resources/bg.palette"
.incbin "../resources/sprite.palette"