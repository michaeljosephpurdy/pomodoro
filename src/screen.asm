SECTION "Screen", ROM0
ScreenWaitForVBlank::
.waitForVBlank
	ld	a,	[$FF44]	; LCDC (LCD Controller) Y-Coordinate
	cp 144	; is it at the bottom of the screen?
	jr	c,	.waitForVBlank
	ret
ScreenTurnOff::
	; turn off the LCD so we can properly read and write to registers in the PPU
	xor	a
	ld [$FF40], a; $FF40 - LCDC
	ret

ScreenSetPallette::
 	ld a, %11100100	
 	ld [$FF47], a ; $FF47 - Background pallette
 	ld [$FF48], a ; $FF48 - Object pallette
	ret

ScreenResetScrollRegisters::
 	xor a
 	ld [$FF42], a ; $FF42 - Scroll Y
 	ld [$FF43], a	; $FF43 - Scroll X
	ret

ScreenTurnOn::
.turnOnScreen
	ld a, %10000011
	ld [$FF40], a ; $FF40 - LCDC
	ret