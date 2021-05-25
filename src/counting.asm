SECTION "Counting_variables", WRAM0
;Timer_ms: DS 2
Timer_s: DS 2
Timer_m: DS 2
Timer_goal: DS 2
Timer_shouldCount: DS 1
Timer_pause: DS 1
Timer_done: DS 1
Time_left_m: DS 1
Time_left_s: DS 1

SECTION "CountingInit", ROM0
Counting_init::
	;xor a
	;ld [Timer_ms], a
	xor a
	ld [Timer_s], a
	xor a
	ld [Timer_m], a
	ld a, 1
	ld [Timer_goal], a
	ld a, 1
	ld [Timer_shouldCount], a
	call Counting_resume
	call Counting_reset
	ret

SECTION "CountingToggle", ROM0
Counting_toggle::
	ld a, [Timer_pause]
  cp 1
	jr z, .resume
	call Counting_pause
	ret
.resume
	call Counting_resume
	ret
Counting_resume::
	xor a
	ld [Timer_pause], a
	ret
Counting_pause::
	ld a, 1
	ld [Timer_pause], a
	ret
Counting_reset::
	xor a
	ld [Timer_done], a
	ret

SECTION "CountingUpdate", ROM0
Counting_update::
	; should we count?
	ld a, [Timer_shouldCount]
	and 1
	jr z, .doneCounting
	; are we paused?
	ld a, [Timer_pause]
	cp 1
	jr z, .stopCounting
;.incrementMilliseconds
	;ld a, [Timer_ms]
	;inc a
	;ld [Timer_ms], a
	;cp 60
	;jr z, .incrementSeconds
	;jr .stopCounting
.incrementSeconds
	;xor a
	;ld [Timer_ms], a
	ld a, [Timer_s]
	inc a
	ld [Timer_s], a
	cp 60
	jr z, .incrementMinutes
	jr .stopCounting
.incrementMinutes
	xor a
	ld [Timer_s], a
	ld a, [Timer_m]
	inc a
	ld [Timer_m], a
	ld l, a
	; check to see if we have reached our goal
	ld a, [Timer_goal]
	sub a, l
	jr z, .checkIfDone
.stopCounting
  ret
.checkIfDone
	ld a, [Timer_goal]
	ld b, a
	ld a, [Timer_m]
	cp b
	jr z, .doneCounting
	ret
.doneCounting
	xor a
	ld [Timer_shouldCount], a
	ld a, 1
	ld [Timer_done], a
	ret