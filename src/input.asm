SECTION "wInput_wram", WRAM0
wSomeLocation: DS 1
wInputAWasPressed:: DS 1
wInputBWasPressed:: DS 1
wInputAIsDown:: DS 1
wInputBIsDown:: DS 1
wInput_currentButtonDown: DS 1
wInput_lastButtonDown: DS 1

SECTION "Input", ROM0
InputInit::
  ld a, $CD
  ld [wSomeLocation], a 
  call InputReset
  ret
InputReset:
  xor a
  ld [wInputAWasPressed], a
  ld [wInputAIsDown], a
  ld [wInputBWasPressed], a
  ld [wInputBIsDown], a
  ret
InputUpdate::
  call InputReset
  ; FF00 is joypad read/write
  ; if you want to get the A button, you need to write to bit 4
  ; to tell it that we want 'action' buttons and not 'directional' buttons
  ld a, %11010000
  ld [$FF00], a
  ld a, [$FF00]
  ld a, [$FF00]
  ld [wInput_currentButtonDown], a

  ; We want to handle the first button press
  ; not button holds
  ld b, a
  ld a, [wInput_lastButtonDown]
  cp b
  jr z, .checkPressedButtonsEnd

  ld a, [wInput_currentButtonDown]
  ld [wInput_lastButtonDown], a
.checkPressedButtons
  ; A button
  xor $DE
  jr z, .aPressed

  ; B button
  ld a, [wInput_currentButtonDown]
  xor $DD
  jr z, .bPressed
  ret
.aPressed
  ld a, 1
  ld [wInputAWasPressed], a
	ld a, %0100 ; enable timer
	ld [$FF07], a
  jr .checkPressedButtonsEnd
.bPressed
  ld a, 1
  ld [wInputBWasPressed], a
	ld a, %0000 ; enable timer
	ld [$FF07], a
  jr .checkPressedButtonsEnd
.checkPressedButtonsEnd
.checkDownButtons
  ld a, [wInput_currentButtonDown]
  xor $DE
  jr nz, .aDownEnd
.aDown
  ld a, 1
  ld [wInputAIsDown], a
.aDownEnd
  ld a, [wInput_currentButtonDown]
  ;b button
  xor $DD
  jr nz, .bDownEnd
.bDown
  ld a, 1
  ld [wInputBIsDown], a
.bDownEnd
.checkDownButtonsEnd
  ret
  
.readInput
  ld [$FF00], a
  ld a, [$FF00]
  ld a, [$FF00]
  ld a, [$FF00]
  ret