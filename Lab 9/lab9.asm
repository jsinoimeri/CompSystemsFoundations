; Program to accept a signed decimal number in the format +/-xxxx
; Calculate the 8-bit "quarter precision" IEEE-754 encoding and print it to screen.
; 

; Format -/+xxxx in decimal, entered as ASCII.
; 1) Get sign
; 2) Get number
; 3) Normalize number to get exponent
; 3) Compute bias-** representation of exponent
; 4) Create final IEEE-754 representation

; Constant definitions
DISPLAY	.EQU 04E9h	; address of Libra display

; Global variables
.ORG 0000
SIGN:	.DB	0		; Sign of entered number (0=positive, 1=negative)
SUM:	.DB	0		; Unsigned  binary representation of entered number
EXP:	.DB	0		; Excess/bias representation of exponent (only uses lower 3 bits)
FP:		.DB	0		; 8-bit quarter-precision IEEE-754 representation of number

.ORG 1000h
;---------------------------
;Insert Sub-routines getChar, printStr, and newLine from Lab 8 here
;---------------------------
printStr:
					; Save registers modified by this subroutine
					PUSH AX								; Push AX into Stack
					PUSH SI								; Push SI into Stack
					PUSH DX								; Push DX into Stack

					MOV DX, DISPLAY				; Copy value of DISPLAY to DX
					
					LoopPS:
									MOV AL, [SI]	; Load the next char to be printed - USING INPUT PARAMETER SI
									CMP AL, '$'		; Compare the char to '$'
									JE quitPS			; If it is equal, then quit subroutine and return to calling code
									
									OUT DX,AL			; If it is not equal to '$', then print it
									INC SI				; Point to the next char to be printed
									jmp LoopPS		; Jump back to the top of the loop
					quitPS:
									; Restore registers
									POP DX				; POP DX from Stack
									POP SI				; POP SI from Stack
									POP AX				; POP AX from Stack

					RET
	
	
;;;;;;;;;;;;;;;;;
; newLine: Subroutine to print a newline and a linefeed character
; Input parameters:
; 	None.
; Output parameters:
;	None.

; Constants for this subroutine:
s_CR .EQU 0Dh								; ASCII value for Carriage return
s_LF .EQU 0Ah								; ASCII value for NewLine

newLine:
					; Save registers modified by this subroutine
					PUSH AX						; Push AX into Stack
					PUSH DX						; Push DX into Stack
					
					MOV DX, DISPLAY		; Initialize the output port number in DX
					MOV AL, s_LF			; Load line feed (LF) into AL
					out DX,AL					; print the char
					MOV AL, s_CR			; Load carriage return (CR) into AL
					out DX,AL					; print the char
					
					; Restore registers
					POP DX						; POP DX from Stack
					POP AX						; POP AX from Stack
					
					RET	
	
	
	;;;;;;;;;;;;;;;;;
; getChar: waits for a keypress and returns pressed key in AL
; Input parameters:
; 	none.
; Output parameters:
;	AL: ASCII Value of key pressed by user

; Constants used by this subroutine
KBSTATUS .EQU 64h												; port number of keyboard STATUS reg
KBBUFFER .EQU 60h												; port number of keyboard BUFFER reg

getChar:
				PUSH DX        									; save reg used
				
				GCWait:
								MOV DX, KBSTATUS				; load addr of keybrd STATUS
								IN AL, DX								; Read contents of keyboard STATUS register
								CMP AL, 0								; key pressed?
								JZ GCWait								; no, go back and check again for keypress
				
								MOV DX, KBBUFFER				; load port number of kbrd BUFFER register
								IN AL, DX								; get key into AL from BUFFER
								
				GCDone:
								POP DX        					; restore regs
				RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END OF SUBROUTINES FROM lab8.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FIX ME -- Complete entire subroutine. Suggest you create a flow chart first!
;;;;;;;;;;;;;;;;;
; getSign: waits for user to press '+' or '-'. Ignores other chars. 
;          Valid input sign character is echoed to screen.
; Input parameters:
; 	none.
; Output parameters:
;	AL: Returns a zero for '+' and one for '-'
getSign:
	
		CALL getChar
		CMP AL, '+'
		JE plus_sign
		
		CMP AL, '-'
		JNE getSign
	
	neg_sign:
			MOV AH, 1
			JMP print_sign
	
	plus_sign:
			MOV AH, 0
	
	print_sign:
			MOV DX, DISPLAY
			OUT DX, AL
			
			MOV AL, AH
				

	RET
	

;;;;;;;;;;;;;;;;;
; getDigit: waits for user to press 0-9 digit. Ignores other chars except RETURN
; Input parameters:
; 	none.
; Output parameters:
;	AL: Returns binary value of digit in AL. Returns 99 if user presses ENTER

; Constants used by this subroutine
ENTERK .EQU 0Ah

getDigit:
	CALL getChar		
	CMP AL, ENTERK					; Check for ENTER Key (ENTERK)
	JNE skipGD
	MOV AL, 99 					; if yes, return 99 in AL
	RET
skipGD:
	CMP AL, 30h					; check for '0'
	JB getDigit					; if below '0', get another char
	CMP AL, 39h					; check for '9'
	JA getDigit				; if above '9', get another char
	PUSH DX					; Echo digit back to screen (remember to save/restore any used registers)
	MOV DX, DISPLAY
	OUT DX, AL
	POP DX
	
	SUB AL, 30h			
	;SHR AL, 1					; Shift ASCII --> binary
	RET
	

;;;;;;;;;;;;;;;;;
; getNumber: Accepts a series of decimal digits and builds a binary number using shift-add
; Input parameters:
; 	none.
; Output parameters:
;	AL: Returns binary value of number in AL. 

; Constants used by this subroutine
DONE .EQU 99

getNumber:				; FIX ME -- complete entire subroutine
	PUSH CX				; Save CX register
	MOV CH, 0			; Use CH for running sum
	MOV CL, 10			; Use CL for multiplier=10
loopGN:
	CALL getDigit					; get a digit
	CMP AL, DONE					; Check if user pressed ENTER
	JE doneGN					; If so, we are done this subroutine
	PUSH AX					; Save entered character onto stack
	MOV AL, CH					; Copy running sum into AL
	MUL CL					; Compute AX=sum*10 (then ignore AH)
	MOV CH, AL					; Move running sum back into CH
	POP AX					; Restore saved character
	ADD CH, AL					; Add entered digit to shifted running sum
	JMP loopGN
doneGN:
	MOV AL, CH					; Put final sum into AL
	POP CX				; Restore CX
	RET
	

Message1: .DB	'Enter a number BW -128 to +127.$'		; FIX ME -- Message to be printed on screen

		
;;;;;;;;;;;;;
; Main function: Asks the user to enter a signed number between -MAX to +MAX 
; 				Computes quarter-precision 8-bit IEEE-754 representation
;
;				Uses printStr, newline, and getChar subroutines.
main:
	MOV SI, Message1
	CALL 	printStr					;Print prompt
	CALL newLine						;
	MOV AL, 0
	MOV [SUM], AL					;

part1:			
	CALL getSign						;call getSign to get +/- sign from keyboard
	MOV BYTE PTR [SIGN], AL			;Save sign to global variable SIGN
	CALL getNumber						;call getNumber to get the unsigned number
	MOV [SUM], AL						;Save number to global variable SUM

;Quit
	HLT
	
	

.END main		;Entry point of program is main()