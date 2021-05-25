SECTION "rom", ROM0

; $0100-0103 is reserved for entry point
; https://gbdev.io/pandocs/#_0100-0103-entry-point
SECTION "entry_point", ROM0[$0100]
	di
	jp	Main

SECTION "Main", ROM0
Main:
.init
	call Screen_turnOff
	call Main_init
	call Tomato_draw
	call ShadowOAM_clear
	call CopyDMARoutine
	call Screen_turnOn
	ld a, $0
	ld [$FF06], a
	ld a, %0100 ; enable timer @ cpu clock / 16 = something
	ld [$FF07], a
	call Interrupts_init
.gameLoop
	call Main_update
	halt
	jr .gameLoop

Main_init:
	;call Counting_init
	call Input_init
	call Tomato_init
	ret

Main_update:
	call Input_update
	;call Counting_update
	call Tomato_update
	ret 