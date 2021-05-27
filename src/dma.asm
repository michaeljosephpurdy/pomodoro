SECTION "Shadow OAM", WRAM0,ALIGN[8]
wShadowOAM::
  ds 4 * 40 ; This is the buffer we'll write sprite data to
wShadowOAMEnd::

SECTION "DMA init", ROM0
DMAInit::
  ld a, $C1
  ld [$FF46], a
  ; DMA transfer begins, we need to wait 160 microseconds while it transfers
  ; the following loop takes exactly that long
  ld      a, 40
.loop
  dec     a
  jr      nz, .loop
  ret

SECTION "DMA routine", ROM0
CopyDMARoutine:
  ld  hl, DMARoutine
  ld  b, DMARoutineEnd - DMARoutine ; Number of bytes to copy
  ld  c, LOW(hOAMDMA) ; Low byte of the destination address
.copy
  ld  a, [hli]
  ldh [c], a
  inc c
  dec b
  jr  nz, .copy
  ret

DMARoutine:
  ldh [$FF46], a
  ld  a, 40
.wait
  dec a
  jr  nz, .wait
  ret
DMARoutineEnd:

ShadowOAMClear::
  ld de, wShadowOAMEnd
  ld hl, wShadowOAM
.loop
  xor a
  ld [hli], a
  ld a, h
  cp d
  jr nz, .loop
  ld a, l
  cp e
  jr nz, .loop
  ret

SECTION "OAM DMA", HRAM
hOAMDMA::
  ds DMARoutineEnd - DMARoutine ; Reserve space to copy the routine to
