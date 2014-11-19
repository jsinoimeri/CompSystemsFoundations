; Lab8 Part II - Program to prompt the user to enter a string
;				Gets characters from the keyboard one at a time
; 				Checks if the user presses 'ENTER'
;				Once 'ENTER' is pressed, echos the string back from the stack in CORRECT order

; Constant definitions
DISPLAY	.EQU 04E9h							; address of Libra display


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Insert Sub-routines getChar, printStr, and newLine from Lab 7 here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
; printStr: Subroutine to print a '$'-terminated string
; Input parameters:
; 	SI: Address of start of string to be printed
; Output parameters:
;	None.
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
; END OF SUBROUTINES FROM lab7.asm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;
; printRevStr: Subroutine to print a '$'-terminated string
;			Each character in the string is stored
; 			as a 2-byte value. Only the lower byte is meaningful
; Input parameters:
; 	SI: Address of start of string to be printed
; Output parameters:
;	None.
printRevStr:
							; Save registers modified by this subroutine
							PUSH AX									; Push AX into Stack
							PUSH SI									; Push SI into Stack
							PUSH DX									; Push DX into Stack
						
							MOV DX, DISPLAY					; Copy value of DISPLAY to DX
		
							MOV SI, 0000h						; Copy the value 0000h into SI
							
							LoopPS2:
												SUB SI, 2			; Subtract 2 from SI to get next character entered
												MOV AL, [SI]	; Load the next char to be printed - USING INPUT PARAMETER SI
												CMP AL, '$'		; Compare the char to '$'
												JE quitPS2		; If it is equal, then quit subroutine and return to calling code
												
												OUT DX,AL			; If it is not equal to '$', then print it
												jmp LoopPS2		; Jump back to the top of the loop
							
							quitPS2:
												; Restore registers
												POP DX				; POP DX from Stack
												POP SI				; POP SI from Stack
												POP AX				; POP AX from Stack
				
							RET

	
Message1: .DB	'Enter a string$'				; Prompt to be printed on screen

		
;;;;;;;;;;;;;
; Main function: Asks the user to enter a string 
; 				Echos the string to screen in reverse order.
;				Uses printStr, newline, and getChar subroutines.
main:
			mov SI, Message1								; Prompt the user
			call printStr										; Print Message1
			call newLine										;	Print new line
			
			MOV CX, 0												; Initialize CX to 0 for counting number of characters
			
			gsAgain:
								CALL 	getChar					; Get a character
								CMP AL, s_LF 					; Check if AL is the ascii value of line feed (enter)
								JE gsPrint						; if it is then proceed to gsPrint
								
								INC CX								; Increment the counter by 1
								PUSH AX								; Push the character as a 16-bit value
								JMP gsAgain						; Get the next char
			
			gsPrint:
								CMP CX, 0							; compare CX to 0
								JE gsDone							; if equal then go to gsDone
								
								MOV AX, '$'						; Copy the ascii value of $ to AX
								PUSH AX								; Push AX onto stack
								
								INC CX								; Increment the counter by 1

								CALL printRevStr			; Print the string in correct order
								CALL 	newLine					; Print new line
								
			gsClear:				
										POP AX						; POP the contents of stack into AX
										DEC CX						; Decrement CX
													
										CMP CX, 0					; Compare CX with 0
										JNE gsClear				; Loop back to clear if not equal
			
			gsJumpMain:														
									JMP main						; Loop back to main
			
			gsDone:
							HLT											;Quit
							
.END main															;Entry point of program is main()