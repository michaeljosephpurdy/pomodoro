SECTION "InterruptsInit", ROM0
InterruptsInit::
	; https://gbdev.io/pandocs/Interrupts.html#ffff---ie---interrupt-enable-rw
	; Interrupt flag
	; Bit 0: VBlank
	; Bit 1: LCD STAT
	; Bit 2: Timer
	; Bit 3: Serial
	; Bit 4: Joypad
	ld a, %00000101
	ld [$FFFF], a ; $FFFF 
	xor a
	ld [$FF0F], a
	reti ; enable interrupts

SECTION "interrupts_vblank", ROM0[$0040]
	jp VBlankHandler

SECTION "interrupts_vblankHandler", ROM0
VBlankHandler:
  push af
  push bc
  push de
  push hl
.setpalettes
 	ld a, %11100100	
 	ld [$FF47], a ; $FF47 - Background palette 
 	ld [$FF48], a ; $FF48 - Object palette 
	ld  a, HIGH(wShadowOAM)
  call hOAMDMA
  call TextUpdate
  call TextDraw
  pop hl
  pop de
  pop bc
  pop af
  reti

SECTION "interrupts_lcd", ROM0[$0048]
  ret
  
SECTION "interrupts_timer", ROM0[$0050]
  jp TimerHandler

SECTION "interrupts_timerHandler", ROM0
TimerHandler:
  push af
  push bc
  push de
  push hl
	call CountingUpdate
  pop hl
  pop de
  pop bc
  pop af
  reti
  
SECTION "interrupts_serial", ROM0[$0058]
  ret
  
SECTION "interrupts_joypad", ROM0[$0060]
  ret
