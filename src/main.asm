SECTION "rom", ROM0

INCLUDE "interrupts.inc"
INCLUDE "constants.inc"

; $0100-0103 is reserved for entry point
; https://gbdev.io/pandocs/#_0100-0103-entry-point
SECTION "entry_point", ROM0[$0100]
	nop
	jp	MainLoop

INCLUDE "header.inc"

SECTION "Mainloop", ROM0
MainLoop:
.init
	di
	xor a
	ld [$FF26], a ; shut off sound
	call Counting_init
	call Tomato_init
.update
.waitForVBlank
	ld	a,	[$FF44]	; LCDC (LCD Controller) Y-Coordinate
	cp 144	; is it at the bottom of the screen?
	jr	c,	.waitForVBlank

	call Screen_turnOff
	call Counting_update 
	call Tomato_draw

	call Screen_prepare
	call Screen_turnOn
	jp .update