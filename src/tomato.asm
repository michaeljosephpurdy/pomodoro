SECTION "Tomato Variables", WRAM0
wTomato_dataStart::
wTomato_x: DS 1
wTomato_y: DS 1
wTomato_dataEnd::

SECTION "Tomato Sprite", ROM0
TomatoSprite:
  INCBIN "tomato.2bpp"

SECTION "Tomato Init", ROM0
TomatoInit::
  ld a, 8
  ld [wTomato_x], a
  ld a, 16
  ld [wTomato_y], a
  ret

SECTION "Tomato Move", ROM0
TomatoMoveX::
  ld a, [wTomato_x]
  inc a
  ld [wTomato_x], a
  ret
TomatoMoveY::
  ld a, [wTomato_y]
  inc a
  ld [wTomato_y], a
  ret

SECTION "Tomato Draw", ROM0
TomatoCopyToVRAM::
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

SECTION "Tomato Update", ROM0
TomatoUpdate::
 	ld a, %11100100
 	ld [$FF48], a ; $FF48 - Object palette 
.topLeft
  ld hl, wShadowOAM
  ld a, [wTomato_y]
  ld [hli], a       ; y position
  ld a, [wTomato_x]
  ld [hli], a       ; x position
  xor a             ; 0 sprite
  ld [hli], a
  xor a             ; 0 palette
  ld [hli], a
.topRight
  ld hl, wShadowOAM + 4
  ld a, [wTomato_y]
  ld [hli], a       ; y position
  ld a, [wTomato_x]
  add a, 8          ; x position
  ld [hli], a
  ld a, 1           ; 1 sprite
  ld [hli], a
  xor a             ; 0 palette
  ld [hl], a
.bottomLeft
  ld hl, wShadowOAM + 8
  ld a, [wTomato_y]
  add a, 8
  ld [hli], a       ; y position
  ld a, [wTomato_x]
  ld [hli], a       ; x position
  ld a, 2
  ld [hli], a       ; 2 sprite
  xor a
  ld [hl], a        ; 0 palette
.bottomRight
  ld hl, wShadowOAM + 16
  ld a, [wTomato_y]
  add a, 8          ; y position
  ld [hli], a
  ld a, [wTomato_x]
  add a, 8
  ld [hli], a       ; x position
  ld a, 3
  ld [hli], a       ; 3 sprite
  xor 0
  ld [hl], a        ; 0 palette
  ret
