SECTION "wInput_wram", WRAM0
wSomeLocation: DS 1
wInput_lastInput: DS 1
wInput_buttonDown: DS 1
wInput_currentDirection: DS 1
wInput_lastDirection: DS 1
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
  ld [wInput_buttonDown], a
  ret
InputUpdate::
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
  jr z, .done

  ld a, [wInput_currentButtonDown]
  ld [wInput_lastButtonDown], a

  ; A button
  xor $DE
  jr z, .aPressed

  ; B button
  ld a, [wInput_currentButtonDown]
  xor $DD
  jr z, .bPressed
  ret
.aPressed
  call TomatoMoveX
  call Counting_toggle
  ld a, 1
  ld [wInput_buttonDown], a
  jr .done
.bPressed
  call TomatoMoveY
  ld a, 1
  ld [wInput_buttonDown], a
  jr .done
.done
  ret
  
.readInput
  ld [$FF00], a
  ld a, [$FF00]
  ld a, [$FF00]
  ld a, [$FF00]
  ret