SECTION "Counting_variables", WRAM0
Timer_ms: DS 2
Timer_s: DS 2
Timer_m: DS 2
Timer_goal: DS 2
Timer_shouldCount: DS 1

SECTION "CountingInit", ROM0
Counting_init::
	xor a
	ld [Timer_ms], hl
	ld [Timer_s], a
	ld [Timer_m], a
	ld a, 1 
	ld [Timer_goal], a
	ld a, 1
	ld [Timer_shouldCount], a
	ret

SECTION "CountingUpdate", ROM0
Counting_update::
	ld a, [Timer_shouldCount]
	sub a, 1
	jr z, .done
	ld a, [Timer_ms]
	inc a
	ld [Timer_ms], a
	cp 60
	jr z, .incrementSeconds
	jr .stopCounting
.incrementSeconds:
	xor a
	ld [Timer_ms], a
	ld a, [Timer_s]
	inc a
	ld [Timer_s], a
	cp 60
	jr z, .incrementMinutes
	jr .stopCounting
.incrementMinutes:
	xor a
	ld [Timer_s], a
	ld a, [Timer_m]
	inc a
	ld [Timer_m], a
	ld l, a
	; check to see if we have reached our goal
	ld a, [Timer_goal]
	sub a, l
	jr z, .done
.stopCounting:
  ret
.done:
	xor a
	ld [Timer_shouldCount], a
	ret