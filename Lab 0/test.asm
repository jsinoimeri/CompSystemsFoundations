Init:
			MOV AL, 0FFh	; Initialize AX to zero. AH serves as accumulator and AX will hold product
			ADD AL, 2h		; Initialize CH (Q) = X
			RCR AL, 1		; Init BH (M) = Y

quit:
	HLT
.END	Init