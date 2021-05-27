SECTION "Main", ROM0
Main:
.init
	call ScreenTurnOff
	call Main_init
	call ScreenTurnOn
.gameLoop
	call Main_update
	halt
	jr .gameLoop

SECTION "Main Init", ROM0
Main_init:
	call DMACopyToHRAM 
	call TextCopyToVRAM
	call TomatoCopyToVRAM

	call CountingInit
	call InputInit
	call TomatoInit
	call TextInit

	call DMAClearShadowOAM 
	call ScreenResetScrollRegisters
	call ScreenSetPallette
	;timer
	ld a, $0
	ld [$FF06], a
	ld a, %0100 ; enable timer @ cpu clock / 16 = something
	ld [$FF07], a
	call InterruptsInit
	ret

SECTION "Main Update", ROM0
Main_update:
	call InputUpdate
	call TextUpdate
	call TomatoUpdate
	ret 