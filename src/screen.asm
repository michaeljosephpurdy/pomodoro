SECTION "Screen", ROM0
Screen_turnOff::
	; turn off the LCD so we can properly read and write to registers in the PPU
	xor	a	; turn off LCD
	ld a, 0
	ld [$FF40], a; $FF40 is the LCDC
	ret
Screen_prepare::
 	; Init display registers
 	ld a, %11100100	
 	ld [$FF47], a ; set pallete 
 	ld [$FF48], a ; set pallete 
 	xor a ; ld a, 0
 	ld [$FF42], a ; set scroll y to 0
 	ld [$FF43], a	; set scroll x to 0
	ret
Screen_turnOn::
	; turn LCD back on
	ld a, %10000010
	ld [$FF40], a; $FF40 is the LCDC
	ret