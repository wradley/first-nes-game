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
    jsr update_player_pos
    rti

irq:
    rti

; ======================================================================== main
.segment "RAM"
player_x: .res 1
player_y: .res 1

.segment "CODE"

main:
    jsr load_palette_data
    jsr demo_load_sprite
    lda #%10000000   ; enable NMI, sprites from Pattern Table 0
    sta PPU_CTRL
    lda #%00010000   ; no intensify (black background), enable sprites
    sta PPU_MASK
    lda #10
    sta player_x
    sta player_y
    :
        jsr demo_load_sprite
        jmp :-        ; hang

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
    lda player_y
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
    lda player_x
    sta OAM_RAM_ADDR, x
    rts

update_player_pos:
    lda #$01
    sta CONTROLLER1
    lda #$00
    sta CONTROLLER1     ; tell both the controllers to latch buttons

    lda CONTROLLER1     ; player 1 - A
    lda CONTROLLER1     ; player 1 - B
    lda CONTROLLER1     ; player 1 - Select
    lda CONTROLLER1     ; player 1 - Start
    ldx player_x
    ldy player_y
    lda CONTROLLER1     ; player 1 - Up
    and #$01
    beq :+
        dey
        :
    lda CONTROLLER1     ; player 1 - Down
    and #$01
    beq :+
        iny
        :
    lda CONTROLLER1     ; player 1 - Left
    and #$01
    beq :+
        dex
        :
    lda CONTROLLER1     ; player 1 - Right
    and #$01
    beq :+
        inx
        :
    stx player_x
    sty player_y
    rts

; ============================================================== Read-Only Data
.segment "RODATA"
palette_data:
.incbin "../resources/bg.palette"
.incbin "../resources/sprite.palette"