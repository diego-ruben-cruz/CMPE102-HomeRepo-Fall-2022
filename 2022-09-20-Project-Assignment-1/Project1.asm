COMMENT @
Description: Write a program that calculates the following expression: 
				total =  (num3 + num4) - (num1 + num2) + 1
Name: Diego Cruz
SID: 013540384
Course: CMPE 102
Project: 001
Date: 25 September 2022
@

;INCLUDE Irvine32.inc; Use Irvine32

.386; to indicate 32 bit program - comment out if you are using Irvine32

.model flat, stdcall; comment out if you are using Irvine32
; flat = protected mode
; stdcall vs ccall? convention
; MODEL = ?


.stack 4096 ; define stack size for all apps. This is big enough
; stack size = 4096 bytes
; Comment out if using Irvine32

ExitProcess PROTO, dwExitCode : dword
			COMMENT @
			PROTOTYPE, comment out if you are using Irvine32
			ExitProcess PROTO = fn/procedure prototype to transfer/return execution to windows services
			otherwise, windows can�t run any execution & windows crashes
			dwExitCode is parameter
			dword = data type
			@

.data; below declare data label
arrayB1 WORD 1000h, 2000h, 3000h, 4000h
num1 WORD 1
num2 WORD 2
num3 WORD 4
num4 WORD 8
total WORD ? ; ? char denotes that total is yet to be defined.

.code; to include assembly statement inside
main PROC
	; Doing operation to add all array elements to each num variable
	MOV eax, 0h; initialize eax with 0
	MOV ax, num1; initialize ax with num1 before addition
	ADD ax, [arrayB1]; add array element 1
	MOV num1, ax; num1 has now added element 1 of the array
	
	MOV eax, 0h; initialize eax with 0
	MOV ax, num2; initialize ax with num2 before addition
	ADD ax, [arrayB1+2] 
						COMMENT @
						add array element 2, 
						the +2 denotes going further 2 bytes
						meaning another word.
						This then navigates to the next element of the
						array.
						@
	;ADD ax, [arrayB1+WORD]; This is also acceptable for previous instruction
	MOV num2, ax; num2 has now added element 2 of the array
	
	MOV eax, 0h; initialize eax with 0
	MOV ax, num3; initialize ax with num3 before addition
	ADD ax, [arrayB1+ 4]; add array element 3
	;ADD ax, [arrayB1+ 2*WORD]; This is also acceptable for previous instruction
	MOV num3, ax; num3 has now added element 3 of the array
	
	MOV eax, 0h; initialize eax with 0
	MOV ax, num4; initialize ax with num4 before addition
	ADD ax, [arrayB1+6]; add array element 4
	;ADD ax, [arrayB1+ 3*WORD]; This is also acceptable for previous instruction
	MOV num4, ax; num4 has now added element 4 of the array

	; Commencing operation to compute num1 + num2
	MOV eax, 0h; initialize eax with 0
	MOV ax, num1; initialize ax with num1
	ADD ax, num2; adding num1 + num2
	
	; Commencing operation to compute num3 + num4
	MOV ebx, 0h; initialize ebx with 0
	MOV bx, num3; initialize bx with num3
	ADD bx, num4; adding num3 + num4
	
	; Commencing operation to compute (num3 + num4) - (num1 + num2)
	MOV esi, 0h; initialize esi with 0
	MOV esi, ebx; initialize esi with (num3 + num4)
	SUB esi, eax; subtract esi with (num1 + num2)
	
	; Increment esi register by 1
	INC esi
	MOV eax, 0; initialize eax to 0
	MOV eax, esi; compress esi into ax
	
	; Store esi result to total data label
	MOV total, ax
	
	invoke ExitProcess, 0 	
			COMMENT @ 
			to return execution to windows services 
			otherwise prog crashes
			0 = param to pass
			@
main ENDP
End main