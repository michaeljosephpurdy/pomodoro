SECTION "Text Variables", WRAM0
wTextPosition: DS 1

SECTION "Text Init", ROM0
TextInit::
  ld a, 250
  ld [wTextPosition], a
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

SECTION "Text Update", ROM0
TextUpdate::
.updatePosition
  ld a, [wTextPosition]
  inc a
  ld [wTextPosition], a
;.updateText
;  ld hl, $9800
;  ld a, HIGH(wTime_left_m)
;  ld [hli], a
;  ld a, LOW(wTime_left_m)
;  ld [hli], a
;  ld a, "m"
;  ld [hli], a
;  ld a, " "
;  ld [hli], a
;  ld a, HIGH(wTime_left_s)
;  ld [hli], a
;  ld a, LOW(wTime_left_s)
;  ld [hli], a
;  ld a, "s"
;  ld [hli], a
  ret


SECTION "Text Draw", ROM0
TextCopyToVRAM::
.copyString
  ld hl, $9800 ; background map
  ld de, HelloWorldString
.copyStringLoop
  ld a, [de]
  ld [hli], a
  inc de
  and a
  jr nz, .copyStringLoop
.positionText
  ld a, [wTextPosition]
  ld [$FF43], a ; $FF43 is background scroll x
  ret

SECTION "Text_font", ROM0
FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Hello world string", ROM0
HelloWorldString:
  db "Pomodoro", 0
HelloWorldStringEnd:
