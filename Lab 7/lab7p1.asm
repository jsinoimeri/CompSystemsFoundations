; Lab7b Part I - Subroutine to prompt the user to enter a key
;				get a character from the keyboard
; 				and check if the user presses 'y'

; Constant definitions
DISPLAY	.EQU 04E9h	; address of Libra display


;---------------------------
;Insert subroutines printStr and newLine from Lab 5 here
;---------------------------
;;;;;;;;;;;;;;;;;
; printStr: Subroutine to print a '$'-terminated string
; Input parameters:
; 	SI: Address of start of string to be printed
; Output parameters:
;	None.
printStr:
	; Save registers modified by this subroutine
	PUSH AX			; Push AX into Stack
	PUSH SI			; Push SI into Stack
	PUSH DX			; Push DX into Stack

	MOV DX, DISPLAY
LoopPS:
	MOV AL, [SI]	; Load the next char to be printed - USING INPUT PARAMETER SI
	CMP AL, '$'		; Compare the char to '$'
	JE quitPS		; If it is equal, then quit subroutine and return to calling code
	OUT DX,AL		; If it is not equal to '$', then print it
	INC SI			; Point to the next char to be printed
	jmp LoopPS		; Jump back to the top of the loop
quitPS:
	; Restore registers
	POP DX			; POP DX from Stack
	POP SI			; POP SI from Stack
	POP AX			; POP AX from Stack

	RET
	
	
;;;;;;;;;;;;;;;;;
; newLine: Subroutine to print a newline and a linefeed character
; Input parameters:
; 	None.
; Output parameters:
;	None.

; Constants for this subroutine:
s_CR .EQU 0Dh		; ASCII value for Carriage return
s_LF .EQU 0Ah		; ASCII value for NewLine

newLine:
	; Save registers modified by this subroutine
	PUSH AX			; Push AX into Stack
	PUSH DX			; Push DX into Stack
	
	MOV DX, DISPLAY		; Initialize the output port number in DX
	MOV AL, s_LF		; Load line feed (LF) into AL
	out DX,AL		; print the char
	MOV AL, s_CR		; Load carriage return (CR) into AL
	out DX,AL		; print the char
	
	; Restore registers
	POP DX			; POP DX from Stack
	POP AX			; POP AX from Stack
	
	RET	
	
;---------------------------
;End of subroutines printStr and newLine from Lab 5 here
;---------------------------


;;;;;;;;;;;;;;;;;
; getChar: waits for a keypress and returns pressed key in AL
; Input parameters:
; 	none.
; Output parameters:
;	AL: ASCII Value of key pressed by user

; Constants used by this subroutine
KBSTATUS .EQU 64h			; port number of keyboard STATUS reg
KBBUFFER .EQU 60h			; port number of keyboard BUFFER reg

getChar:
				push DX        					; save reg used
GCWait:
				MOV DX, KBSTATUS				; load addr of keybrd STATUS
				IN AL, DX								; Read contents of keyboard STATUS register
				CMP AL, 0								; key pressed?
				JZ GCWait								; no, go back and check again for keypress

				MOV DX, KBBUFFER				; load port number of kbrd BUFFER register
				IN AL, DX								; get key into AL from BUFFER
GCDone:
				pop DX        	; restore regs
				ret

	
Message1: .DB	'Do you want to quit? (y/n)$'		; Message to be printed on screen
		
;;;;;;;;;;;;;
; Main function: Asks the user whether they want to quit or not. 
; 				Repeats until user presses 'y'
;
;				Uses printStr, newline, and getChar subroutines.
main:
			MOV SI, 	Message1					;Move starting address of Message1 to SI
			
			Call newLine						;Print a new line
			Call printStr						;Call prtstr to print Message1
			Call newLine						;Print a new line
			
			Call getChar						;call Getchar to get value from keyboard
			Call newLine						;Print a new line
			
			mov DX, DISPLAY
			out DX, AL						; Echo the character back to the display	
									
			CMP AL, 'y'						; compare input character with 'y'
			JNZ main							;If user did not press 'y', then re-prompt (start over)
			
	;Quit
	HLT
	
	

.END main		;Entry point of program is main()