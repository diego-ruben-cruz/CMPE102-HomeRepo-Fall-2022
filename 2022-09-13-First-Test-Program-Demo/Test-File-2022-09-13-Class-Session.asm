COMMENT!
Description: First project to test
Name: Diego Cruz
Project Number: 001
Date: 13 September 2022
!
.386	
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:dword	;	prototype

.data
num1	BYTE	10h	;	AKA 0001 0000 in hexadecimal
num2	BYTE	20h	;	AKA 0010 0000 in hexadecimal
sum		BYTE	?	;	variable for sum of num1 + num2

.code
main	PROC
	mov eax, 0h		;	Initialize ax
	mov al, num1	;	
	mov sum, al		;	
	mov al, num2	;	
	add sum, al		;	

	INVOKE ExitProcess,0
main	ENDP
end		main