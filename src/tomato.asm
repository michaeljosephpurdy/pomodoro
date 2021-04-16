SECTION "Tomato_wram", WRAM0
TomatoX: DS 1
TomatoY: DS 1

SECTION "Tomato_rom", ROM0
TomatoSprite:
  dw `00000000
  dw `00000000
  dw `00002200
  dw `00222222
  dw `00222222
  dw `00222222
  dw `00022233
  dw `00022233
  dw `00000000
  dw `00000000
  dw `00000000
  dw `22220000
  dw `22220000
  dw `22220000
  dw `22220000
  dw `22220000

SECTION "Tomato_init", ROM0
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
  ld de, $8010 ; set the destination for the copy
  ld b, 32 ; size counter - how much we'll copy
  ; it doesn't look like it is 16 bytes
  ; but the shorthand ` is decieving
.loop
  ld a, [hli] ; grab a byte and increment
  ld [de], a ; copy it to the destination
  inc e     ; increment the low-byte (e) of the destination
  dec b      ; decrement the size counter
  jr nz, .loop ; if b isn't 0, keep working
.setup_oam
  ; top left
  ld hl, $FE04
  ld a, [TomatoX]
  ld [hli], a
  ld a, [TomatoY]
  ld [hli], a
  ld a, 1
  ld [hli], a
  xor a
  ld [hl], a
  ret
