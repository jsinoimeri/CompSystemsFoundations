; simple Libra program that displays 'Hi'

start:
        mov     DX, 04E9h	; load the display port I/O address into register DX (16 bits wide)
        mov     AL, 'H'		; load the ASCII value of the character 'H' into register AL (8 bits wide)
        out     DX, al		; send the ASCII character in AL out to the display at the port number in DX
		
        mov     AL, 'i'		; load the ASCII value of the character 'H' into register AL (8 bits wide)
        out     DX, al		; send the ASCII character in AL out to the display at the port number in DX

        hlt					;  STOP the Libra CPU!
		
        .END     start				; Directive to assembler: this is the end of the program. The entry point of the program should be at the "start:" label
