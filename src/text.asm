SECTION "Text_variables", WRAM0

SECTION "Text_init", ROM0
Text_init::
.copyFont
  ld hl, $9000 ; 9000 is where the background starts
  ld de, FontTiles
  ld bc, FontTilesEnd - FontTiles
.copyFontLoop
  ld a, [de]
  ld [hli], a
  inc de
  dec bc
  ld a, b
  or c
  jr nz, .copyFontLoop
  ret

SECTION "Text_draw", ROM0
Text_draw::
;.copyFont
;  ld hl, $9000 ; 9000 is where the background starts
;  ld de, FontTiles
;  ld bc, FontTilesEnd - FontTiles
;.copyFontLoop
;  ld a, [de]
;  ld [hli], a
;  inc de
;  dec bc
;  ld a, b
;  or c
;  jr nz, .copyFontLoop

.copyString
  ld hl, $9800 ; background map
  ld de, HelloWorldString
.copyStringLoop
  ld a, [de]
  ld [hli], a
  inc de
  and a
  jr nz, .copyStringLoop
  ret

SECTION "Text_font", ROM0
FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello world string", ROM0
HelloWorldString:
  db "hello world", 0