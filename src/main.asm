SECTION "rom", ROM0

INCLUDE "interrupts.inc"
INCLUDE "constants.inc"

; $0100-0103 is reserved for entry point
; https://gbdev.io/pandocs/#_0100-0103-entry-point
SECTION "entry_point", ROM0[$0100]
	nop
	jp	$0150 

INCLUDE "header.inc"

SECTION "main", ROM0[$0150]
	di
	jp MainLoop 

SECTION "game", ROM0
MainLoop:
.init
	xor a
	ld [$FF26], a ; shut off sound
	call InitCheck
	call Counting_init
	call Tomato_init
.update
.waitForVBlank
	ld	a,	[$FF44]	; LCDC (LCD Controller) Y-Coordinate
	cp 144	; is it at the bottom of the screen?
	jr	c,	.waitForVBlank
	call TurnLCDOff
	call Counting_update 
	call PrepareSprites
	call Tomato_draw

	call PrepareDisplay
	call TurnLCDOn
	jp .update

TurnLCDOff:
	; turn off the LCD so we can properly read and write to registers in the PPU
	xor	a	; turn off LCD
	ld a, 0
	ld [$FF40], a; $FF40 is the LCDC
	ret

PrepareSprites:
	call LoadCheckTileData
	call UpdateCheck
	call SetupCheckOAM
	ret

PrepareDisplay:
 	; Init display registers
 	ld a, %11100100	
 	ld [$FF47], a ; set pallete 
 	ld [$FF48], a ; set pallete 
 	xor a ; ld a, 0
 	ld [$FF42], a ; set scroll y to 0
 	ld [$FF43], a	; set scroll x to 0
	ret

TurnLCDOn:
	; turn LCD back on
	ld a, %10000010
	ld [$FF40], a; $FF40 is the LCDC
	ret

SECTION "CheckData", WRAM0
CheckX: DS 1
CheckY: DS 1

SECTION "CheckTileData", ROM0
InitCheck:
	ld a, 0
	ld [CheckX], a
	ld a, 16
	ld [CheckY], a
	ret
CheckTileData:
	dw `12233221
	dw `12233221
	dw `12233221
	dw `12233221
	dw `12233221
	dw `12233221
	dw `12233221
	dw `12233221
LoadCheckTileData:
	ld hl, CheckTileData
	ld de, $8000				; destination
	ld b, 16						; size (one byte)
.loop
  ld a, [hli]					; grab a byte
	ld [de], a					; copy it into the destination
	inc e								; only increment low byte
	dec b								; decrement b
	jr nz, .loop				; if the result of decrementing d IS NOT ZERO, then loop
	ret
SetupCheckOAM:				; OAM - Object Attribute Memory 
	ld hl, $FE00				; point HL to the OAM memory locations
	ld a, [CheckY]			; grab the check Y position
	ld [hli], a					; store it in hl (OAM memory location) and increment hl
	ld a, [CheckX]			; grab the check X position
	ld [hli], a					; store it in hl and increment again
	xor a;ld a, $00						; set a to 0
	ld [hli], a					; store it in hl and increment again
	ld [hl], a					; store it in hl
	ret
UpdateCheck:
	ld a, [CheckX]
	inc a
	ld [CheckX], a
	ret