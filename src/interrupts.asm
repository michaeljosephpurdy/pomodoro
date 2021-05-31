SECTION "Interrupts Init", ROM0
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
	;timer
	ld a, $C0
	ld [$FF06], a
	ld a, %0100 ; enable timer
	ld [$FF07], a
	reti ; enable interrupts

SECTION "Interrupts VBlank", ROM0[$0040]
	jp VBlankHandler

SECTION "Interrupts VBlank Handler", ROM0
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
  call TextCopyToVRAM 
  call TextUpdate
  pop hl
  pop de
  pop bc
  pop af
  reti

SECTION "Interrupts LCD", ROM0[$0048]
  ret
  
SECTION "Interrupts Timer", ROM0[$0050]
  jp TimerHandler

SECTION "Interrupts Timer Handler", ROM0
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
  
SECTION "Interrupts Serial", ROM0[$0058]
  ret
  
SECTION "Interrupts Joypad", ROM0[$0060]
  ret
