SECTION "Tomato_wram", WRAM0
TomatoX: DS 1
TomatoY: DS 1

SECTION "Tomato_rom", ROM0
TomatoSprite:
  DB $aa, $00, $01, $00, $80, $00, $01, $00
  DB $80, $00, $01, $00, $80, $00, $55, $00
  DB $aa, $00, $01, $00, $80, $00, $01, $00
  DB $80, $00, $01, $00, $80, $00, $55, $00
  DB $aa, $00, $01, $00, $80, $00, $01, $00
  DB $80, $00, $01, $00, $80, $00, $55, $00
  DB $aa, $00, $01, $00, $80, $00, $01, $00
  DB $80, $00, $01, $00, $80, $00, $55, $00

SECTION "Tomato_init", ROM0
Tomato_oam1 EQU $FE00
Tomato_oam2 EQU $FE04
Tomato_oam3 EQU $FE08
Tomato_oam4 EQU $FE0C
Tomato_init::
  ld a, 20
  ld [TomatoX], a
  ld a, 40
  ld [TomatoY], a
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
.setup_oam

  ; top left
  ld hl, Tomato_oam1
  ld a, [TomatoY]
  ld [hli], a
  ld a, [TomatoX]
  ld [hli], a
  ld a, 0
  ld [hli], a
  xor a
  ld [hli], a

  ; top right
  ld hl, Tomato_oam2
  ld a, [TomatoY]
  ld [hli], a
  ld a, [TomatoX]
  add a, 8
  ld [hli], a
  ld a, 1
  ld [hli], a
  xor a
  ld [hl], a

  ; bot left 
  ld hl, Tomato_oam3
  ld a, [TomatoY]
  add a, 8
  ld [hli], a
  ld a, [TomatoX]
  ld [hli], a
  ld a, 2
  ld [hli], a
  xor a
  ld [hl], a

  ; bot right
  ld hl, Tomato_oam4
  ld a, [TomatoY]
  add a, 8
  ld [hli], a
  ld a, [TomatoX]
  add a, 8
  ld [hli], a
  ld a, 3
  ld [hli], a
  xor a
  ld [hl], a
  ret
