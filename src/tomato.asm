SECTION "Tomato_wram", WRAM0
Tomato_dataStart::
Tomato_x: DS 1
Tomato_y: DS 1
Tomato_dataEnd::

SECTION "Tomato_rom", ROM0
TomatoSprite:
  DB $aa, $01, $01, $00, $80, $00, $01, $00
  DB $80, $01, $01, $00, $80, $00, $55, $00
  DB $aa, $01, $01, $00, $80, $00, $01, $00
  DB $80, $01, $01, $00, $80, $00, $55, $00
  DB $aa, $01, $01, $00, $80, $00, $01, $00
  DB $80, $01, $01, $00, $80, $00, $55, $00
  DB $aa, $01, $01, $00, $80, $00, $01, $00
  DB $80, $01, $01, $00, $80, $00, $55, $00

SECTION "Tomato_init", ROM0
Tomato_oam1 EQU $FE00
Tomato_oam2 EQU $FE04
Tomato_oam3 EQU $FE08
Tomato_oam4 EQU $FE0C
Tomato_init::
  ld a, 20
  ld [Tomato_x], a
  ld a, 40
  ld [Tomato_y], a
  ret

SECTION "Tomato_move", ROM0
Tomato_moveX::
  ld a, [Tomato_x]
  inc a
  ld [Tomato_x], a
  ret
Tomato_moveY::
  ld a, [Tomato_y]
  inc a
  ld [Tomato_y], a
  ret

SECTION "Tomato_draw", ROM0
Tomato_draw::
  ; we need to copy the data from ROM into VRAM
  ld hl, TomatoSprite ; label where the sprite data exists
  ; get the location _not_ the value
  ld de, $8000 ; set the destination for the copy
  ld b, 64 ; size counter - how much we'll copy
  ; it doesn't look like it is 16 bytes
  ; but the shorthand ` is decieving
.loop
  ld a, [hli] ; grab a byte and increment
  ld [de], a ; copy it to the destination
  inc de     ; increment the low-byte (e) of the destination
  dec b      ; decrement the size counter
  jr nz, .loop ; if b isn't 0, keep working
  ret

SECTION "Tomato_update", ROM0
Tomato_update::
.setup_oam

  ; top left
  ld hl, wShadowOAM
  ld a, [Tomato_y]
  ld [hli], a
  ld a, [Tomato_x]
  ld [hli], a
  ld a, %00000000
  ld [hli], a
  xor a
  ld [hli], a

  ; top right
  ;ld hl, Tomato_oam2
  ld hl, wShadowOAM + 4
  ld a, [Tomato_y]
  ld [hli], a
  ld a, [Tomato_x]
  add a, 8
  ld [hli], a
  ld a, $01
  ld [hli], a
  xor a
  ld [hl], a

  ; bot left 
  ;ld hl, Tomato_oam3
  ld hl, wShadowOAM + 8
  ld a, [Tomato_y]
  add a, 8
  ld [hli], a
  ld a, [Tomato_x]
  ld [hli], a
  ld a, $02
  ld [hli], a
  xor a
  ld [hl], a

  ; bot right
  ;ld hl, Tomato_oam4
  ld hl, wShadowOAM + 16
  ld a, [Tomato_y]
  add a, 8
  ld [hli], a
  ld a, [Tomato_x]
  add a, 8
  ld [hli], a
  ld a, $03
  ld [hli], a
  xor a
  ld [hl], a
  ret
