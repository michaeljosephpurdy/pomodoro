SECTION "interrupts_init", ROM0
Interrupts_init::
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
	jp VBlank_handler

SECTION "interrupts_vblankHandler", ROM0
VBlank_handler:
  push af
  push bc
  push de
  push hl
	ld  a, HIGH(wShadowOAM)
  call hOAMDMA
  pop hl
  pop de
  pop bc
  pop af
  reti

SECTION "interrupts_lcd", ROM0[$0048]
  ret
  
SECTION "interrupts_timer", ROM0[$0050]
  jp Timer_handler

SECTION "interrupts_timerHandler", ROM0
Timer_handler:
  push af
  push bc
  push de
  push hl
	nop
	nop
	nop
	call Counting_update
	nop
	nop
	nop
  pop hl
  pop de
  pop bc
  pop af
  reti
  
SECTION "interrupts_serial", ROM0[$0058]
  ret
  
SECTION "interrupts_joypad", ROM0[$0060]
  ret
