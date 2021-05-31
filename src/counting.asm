SECTION "Counting_variables", WRAM0
wTimer_ms: DS 1
wTimer_s: DS 1
wTimer_m: DS 1
wTimer_goal: DS 1
wTimer_shouldCount: DS 1
wTimer_pause: DS 1
wTimer_done: DS 1
wTime_left_m:: DS 1
wTime_left_s:: DS 1

SECTION "CountingInit", ROM0
CountingInit::
	xor a
	ld [wTimer_ms], a
	ld [wTimer_s], a
	ld [wTimer_m], a
	ld a, 2
	ld [wTimer_goal], a
	ld a, 1
	ld [wTimer_shouldCount], a
	call CountingResume
	call CountingReset
	ret

SECTION "CountingToggle", ROM0
Counting_toggle::
	ld a, [wTimer_pause]
  cp 1
	jr z, .resume
	call CountingPause
	ret
.resume
	call CountingResume
	ret
CountingResume::
	xor a
	ld [wTimer_pause], a
	ret
CountingPause::
	ld a, 1
	ld [wTimer_pause], a
	ret
CountingReset::
	xor a
	ld [wTimer_done], a
	ret

SECTION "CountingUpdate", ROM0
CountingUpdate::
	ld d, 60
	; should we count?
	ld a, [wTimer_shouldCount]
	and 1
	jr z, .doneCounting
	; are we paused?
	ld a, [wTimer_pause]
	cp 1
	jr z, .stopCounting
.incrementMilliseconds
	ld a, [wTimer_ms]
	inc a
	ld [wTimer_ms], a
	cp d
	jr z, .incrementSeconds
	jr .stopCounting
.incrementSeconds
	xor a
	ld [wTimer_ms], a
	ld a, [wTimer_s]
	inc a
	ld [wTimer_s], a
	cp d
	jr z, .incrementMinutes
	jr .stopCounting
.incrementMinutes
	xor a
	ld [wTimer_s], a
	ld a, [wTimer_m]
	inc a
	ld [wTimer_m], a
	ld l, a
	; check to see if we have reached our goal
	ld a, [wTimer_goal]
	sub a, l
	jr z, .checkIfDone
.stopCounting
.calculateSecondsLeft
	ld a, [wTimer_s]
	ld b, a 
	ld a, 60
	sub a, b
	ld [wTime_left_s], a
.calculateMinutesLeft
	ld a, [wTimer_m]
	ld b, a
	ld a, [wTimer_goal]
	sub a, b
	ld [wTime_left_m], a
  ret
.checkIfDone
	ld a, [wTimer_goal]
	ld b, a
	ld a, [wTimer_m]
	cp b
	jr z, .doneCounting
	ret
.doneCounting
	xor a
	ld [wTimer_shouldCount], a
	ld a, 1
	ld [wTimer_done], a
	ret