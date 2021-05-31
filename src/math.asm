SECTION "Math Variables", WRAM0
wMathInput:: DS 1
wMathOutputTensPlace:: DS 1
wMathOutputOnesPlace:: DS 1

SECTION "Math Split", ROM0
MathSplitDigits::
.setup
  xor a
  ld [wMathOutputTensPlace], a
  ld [wMathOutputOnesPlace], a
.countTensPlace
  ld a, [wMathInput]
  cp 10
  jr z, .noMoreTensLeft
  jr c, .noMoreTensLeft
  ld a, [wMathInput]
  sub 10
  ld [wMathInput], a
  ld a, [wMathOutputTensPlace]
  inc a
  ld [wMathOutputTensPlace], a
  jr .countTensPlace
.noMoreTensLeft
.countOnesPlace
  ; since we've subtracted all of the tens
  ; there should only be ones left
  ld a, [wMathInput]
  ld [wMathOutputOnesPlace], a
  ret
