; Lab 4
; indices 100-109, 200-209 are not displayed correctly


DisplayPort .EQU 04E9h

.ORG 0000h
HayStack: 
 					.DB 8
					.DB 2
					.DB 4
					.DB 9
					

.ORG 00FEh
EndList:
				 .DB '!'			; End of list of numbers
					
					
.ORG 00FFh
Needle:			; Value of needle
					.DB 2

.ORG 0100h
Message:
	FoundItMsg: 
								.DB 'Found the needle at index $'
	
	NotFoundMsg: 
								.DB 'Needle not found $'


.ORG 0200h
Main:								
			MOV CX, 0 				; initialize CX to 0 in order to hold final value of pointer
			MOV AL, [Needle] 	; initialize AL to the value of needle
	
			MOV  SI, HayStack	 	; Create pointer to HayStack
	
			isNeedle:
									CMP AL, [SI] 	; Compares Pointer to AL
									JZ Found			; Found Needle in HayStack, jump to Found
									
									SUB  SI, HayStack
									
									inc SI
								
									CMP SI, EndList   ; Compares Pointer to end of list
									JZ notFound 			; Loops back to isNeedle if pointer is not at end of list
									JNZ isNeedle			; Jumps to notFound if pointer is at end of list
			
			Found:
									MOV CX, SI					  ; Value of pointer gets stored in AH
									MOV BX, FoundItMsg		; BX gets initalized to begining of message
									JMP LoadPort					; Unconditional jump to LoadPort
							
			notFound:
									MOV BX, NotFoundMsg		; BX gets initalized to begining of message
			
			LoadPort:
									MOV DX, DisplayPort	; Loads DisplayPort to DX
									
			CompareMsg:
									MOV AL, [BX]			; Load individual characters of message into AL
									CMP AL, '$'				; Compare AL with delimiter
									JZ CompareIndex		; Jump to CompareIndex if zero
			
			PrintMsg: 
									out DX, AL				; Display character on screen
									inc BX						; increment BX
									JMP CompareMsg		; Unconditional jump to CompareMsg
								
			CompareIndex:
											CMP CX, SI			; Compares AH with pointer
											JNZ Quit				; Jumps to Quit if not zero
			
			MovIndex:
									MOV AX, CX
									CMP AX, 64h
									JB Index10

			Index100:
									MOV CL, 64h
									JMP CalcIndex
			Index10:
								MOV CL, 0xAh
			
			CalcIndex:	
										DIV CL
										MOV CL, AH
										
			PrintIndex:
										ADD AL, 30H			; Adds 30H to AL to turn into integer for display
										out DX, AL			; Displays the value of AL
										
										CMP CL, 0xAh
										JAE MovIndex
										
										MOV AL, CL
										ADD AL, 30H			; Adds 30H to AL to turn into integer for display
										out DX, AL			; Displays the value of AL
										
			Quit: 			; Program done
						HLT
.END Main