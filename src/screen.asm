SECTION "Screen", ROM0
Screen_waitForVblank::
.waitForVBlank
	ld	a,	[$FF44]	; LCDC (LCD Controller) Y-Coordinate
	cp 144	; is it at the bottom of the screen?
	jr	c,	.waitForVBlank
	ret
Screen_turnOff::
	; turn off the LCD so we can properly read and write to registers in the PPU
	xor	a
	ld [$FF40], a; $FF40 - LCDC
	ret
Screen_turnOn::
.setPalletes
 	ld a, %11100100	
 	ld [$FF47], a ; $FF47 - Background pallete 
 	ld [$FF48], a ; $FF48 - Object pallete 
.setScrollValues
 	xor a
 	ld [$FF42], a ; $FF42 - Scroll Y
 	ld [$FF43], a	; $FF43 - Scroll X
.turnOnScreen
	ld a, %10000011
	ld [$FF40], a ; $FF40 - LCDC
	ret