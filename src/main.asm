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
	call InterruptsInit
	ret

SECTION "Main Update", ROM0
Main_update:
	call InputUpdate
	call TomatoUpdate
	ret 