SECTION "Input_wram", WRAM0
Somelocation: DS 1
Input_lastInput: DS 1
Input_buttonDown: DS 1

Input_currentDirection: DS 1
Input_lastDirection: DS 1

Input_currentButtonDown: DS 1
Input_lastButtonDown: DS 1

SECTION "Input", ROM0
Input_init::
  ld a, $CD
  ld [Somelocation], a 
  call Input_reset
  ret
Input_reset:
  xor a
  ld [Input_buttonDown], a
  ret
Input_update::
  ; FF00 is joypad read/write
  ; if you want to get the A button, you need to write to bit 4
  ; to tell it that we want 'action' buttons and not 'directional' buttons
  ld a, %11010000
  ld [$FF00], a
  ld a, [$FF00]
  ld a, [$FF00]
  ld [Input_currentButtonDown], a

  ; We want to handle the first button press
  ; not button holds
  ld b, a
  ld a, [Input_lastButtonDown]
  cp b
  jr z, .done

  ld a, [Input_currentButtonDown]
  ld [Input_lastButtonDown], a

  ; A button
  xor $DE
  jr z, .aPressed

  ; B button
  ld a, [Input_currentButtonDown]
  xor $DD
  jr z, .bPressed
  ret
.aPressed
  call Tomato_moveX
  call Counting_toggle
  ld a, 1
  ld [Input_buttonDown], a
  jr .done
.bPressed
  call Tomato_moveY
  ld a, 1
  ld [Input_buttonDown], a
  jr .done
.done
  ret
  
.readInput
  ld [$FF00], a
  ld a, [$FF00]
  ld a, [$FF00]
  ld a, [$FF00]
  ret