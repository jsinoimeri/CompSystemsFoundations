;
; 	Name: Jeton Sinoimeri
; 	Student number: 100875046
;
; SYSC2001 - Lab 3
; Program to complete 8-bit unsigned shift & add multiplication
; AH = A; CH = Q; BH = M; Final 16-bit result in AX

.ORG 0000h
Data:
	Y:	.DB 5		; Multiplicand
	X: 	.DB 2		; Multiplier



	
.ORG 0010h
Init:
			MOV AX, 0		; Initialize AX to zero. AH serves as accumulator and AX will hold product
			MOV CH, [X]		; Initialize CH (Q) = X
			MOV BH, [Y]		; Init BH (M) = Y
			MOV DL, 8		; Init DL as a loop counter with number of iterations required
	
mainLoop:
				SHR CH, 1	; Shift out the lsb of the multiplier (Q[0]) into the carry flag
				JNC shift	; Check the carry flag: If Q[0] was not set, skip over Add and just shift
AddM:
				ADD AH, BH	; A = A + M
shift:
				SHR AX, 1 ; Shift AH and AL (16-bit result will be here eventually). Also need to shift C into MSb of AH...
				dec DL	; Decrement loop counter
				JNE mainLoop	; If loop counter reaches zero, quit, else, loop back
quit:
	HLT
.END	Init