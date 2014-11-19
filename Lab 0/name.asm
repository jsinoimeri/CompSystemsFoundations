; simple Libra program that displays 'name'

start:
        mov     DX, 04E9h	; load the display port I/O address into register DX (16 bits wide)
        mov     AL, 'J'		; load the ASCII value of the character 'J' into register AL (8 bits wide)
        out     DX, al		; send the ASCII character in AL out to the display at the port number in DX
		
        mov     AL, 'e'		; load the ASCII value of the character 'e' into register AL (8 bits wide)
        out     DX, al		; send the ASCII character in AL out to the display at the port number in DX

	mov 	AL, 't' 	; load the ASCII value of the character 't' into register AL (8 bits wide)
	out	DX, al 		; send the ASCII character in AL out to the display at the port number in DX

	mov     AL, 'o'		; load the ASCII value of the character 'o' into register AL (8 bits wide)
        out     DX, al		; send the ASCII character in AL out to the display at the port number in DX

	mov 	AL, 'n' 	; load the ASCII value of the character 'n' into register AL (8 bits wide)
	out	DX, al 		; send the ASCII character in AL out to the display at the port number in DX

        hlt					;  STOP the Libra CPU!
		
        .END     start				; Directive to assembler: this is the end of the program. The entry point of the program should be at the "start:" label
