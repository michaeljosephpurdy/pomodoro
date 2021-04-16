SECTION "Counting_variables", WRAM0
TimerMS: DS 1
TimerS: DS 1
TimerM: DS 1
TimerShouldCount: DS 1

SECTION "CountingInit", ROM0
Counting_init::
	push af
	xor a
	ld [TimerMS], a
	ld [TimerS], a
	ld [TimerM], a
	pop af
	ret

SECTION "CountingUpdate", ROM0
Counting_update::
	ld a, [TimerMS]
	inc a
	ld [TimerMS], a
	cp 60
	jr z, .countSeconds
	jr .stopCounting
.countSeconds:
	xor a
	ld [TimerMS], a
	ld a, [TimerS]
	inc a
	ld [TimerS], a
	cp 60
	jr z, .countMinutes
	jr .stopCounting
.countMinutes:
	xor a
	ld [TimerS], a
	ld a, [TimerM]
	inc a
	ld [TimerM], a
.stopCounting:
  ret