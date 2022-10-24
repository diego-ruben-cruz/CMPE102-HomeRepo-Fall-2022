;for file header on top of the file
COMMENT @ 
Description: 	
	Write a program that reads an integer which is an index of 
	one array and copies elements of that array to another array.

Name: Diego Cruz
Project: 002
Date: 23 October 2022
@

INCLUDE Irvine32.inc ; Use Irvine32

; .386; to indicate 32 bit program, comment out if you are using Irvine32

; .model flat, stdcall; ; comment out if you are using Irvine32
;flat = protected mode
;stdcall = standard calling convention
;.model = ?


; .stack 4096; define stack size for all apps. This is big enough 
; stack size = 4096 bytes
; Comment out if using Irvine32

;ExitProcess PROTO, dwExitCode : dword  
			COMMENT @
			PROTOTYPE, comment out if you are using Irvine32
			ExitProcess PROTO = fn/procedure prototype to transfer/return execution to windows services
			otherwise, windows cannot run any execution & windows crashes
			dwExitCode is parameter
			dword = data type
			@

.data; below declare data label
; Arrays for program
ArrayB1 BYTE 01h, 02h, 03h, 04h, 05h
ArrayB2 BYTE 00h, 00h, 00h, 00h, 00h

; Variables that are set by user input
startIndex BYTE ? ; Input will be stored here
stringIn BYTE 2 DUP(?) ; 2 Dup(?) denotes that it will initialize as ??

; Messages for communicating from console
strTitle BYTE "--- Array Copier ---",0 ; 0 denotes nullchar to end string
promptInit BYTE "Index (0 - 4): ",0
strTerminate BYTE "--- Program Terminated ---",0
promptCont BYTE "Continue? (y/n): ",0
strInputError BYTE "Invalid Input. Try Again",0
strHexAppend BYTE "H",0

.code; to include assembly statement inside

displayTitle PROC ; Prints the project title 
	mov edx,OFFSET strTitle; Gets pointer to title string
	call WriteString; Irvine operation to write string to console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent to return but for procedures outside of main
displayTitle ENDP

copyArray PROC ; Copies elements from ArrayB1 to ArrayB2
		mov ecx, LENGTHOF ArrayB2; initializes counter with length of arrayB2
		mov edi, OFFSET ArrayB2; Gets pointer to ArrayB2
		mov eax, 0; initizalizes eax to 0 for cleanup purposes
	L1:
		; resets ArrayB2 before copy occurs
		mov al, 00h; sets value of al to 00h
		mov [edi], al; copies value of al to arrayB2 index
		add edi, TYPE ArrayB2; points to next num in arrayB2
		loop L1
		
		mov ecx, LENGTHOF ArrayB2; initializes counter with length of arrayB2
		mov edi, OFFSET ArrayB1; Gets pointer to arrayB1
		mov eax, TYPE ArrayB1; Begin operation to start on index defined by input
		mul startIndex; multiplies eax by the startIndex and creates offset defined by user input
		add edi, eax; adds the offset defined by input to arrayB1
		mov esi, OFFSET ArrayB2; Gets pointer to arrayB2
		mov eax, 0; initializes eax to 0
	L2:
		cmp startIndex, LENGTHOF ArrayB1; compares startIndex to length of arrayB1
		je closure; if startIndex = length of arrayB1, then it will jump out of loop

		add al, [edi]; fetches num from ArrayB1

		add [esi], al; Updates index in ArrayB2
		add edi, TYPE ArrayB1; point to next num in ArrayB1
		add esi, TYPE ArrayB2; point to next num in arrayB2

		inc startIndex; increments startIndex for keeping track of when to finish loop
		mov al,0; initializes al to 0 for next loop iteration
		loop L2
	closure:
	
	ret; Equivalent to return but for procedure outside of main
copyArray ENDP

showArray PROC ; Displays array contents on the console
	mov ecx, LENGTHOF ArrayB2; initializes counter with length of arrayB2
	mov edi, OFFSET ArrayB2; Gets pointer to arrayB2
	mov eax, 0; initializes eax to 0 for cleanup purposes
	L1:
		; Iterates through ArrayB2 and prints out the content
		add al, [edi]; fetches num from arrayB2
		add edi, TYPE ArrayB2; point to next num in arrayB2
		call WriteHex; Writes out the number in al in hexadecimal form
		mov edx, OFFSET strHexAppend; Gets pointer to H string to be appended
		call WriteString; Irvine operation to write string to console
		call Crlf; Creates linebreak for next number
		mov al, 0; initializes al to 0 for next loop iteration
		loop L1 

	ret; Equivalent to return but for procedure outside of main
showArray ENDP

endProgram PROC ; Prints the termination message
	mov edx,OFFSET strTerminate; Gets pointer to program termination string
	call WriteString; Irvine operation to write string to console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent to return but for procedure outside of main
endProgram ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
	call displayTitle; Refer to displayTitle Proc
	top:
		; Outputs initial prompt
		; Accepts user input for an integer
		mov edx, OFFSET promptInit; Gets pointer for initial prompt string
		call WriteString; Irvine operation to write string to console
		call ReadInt; Takes input from console - 32bit signed int

		; Compares input to see if less than 0, if true, then it goes to invalid marker
		cmp ax, 0
		jb invalid

		; Compares input to see if greater than 4, if true, then it goes to invalid marker
		cmp ax, 4
		ja invalid

		; If it is in the range of [0-4], then it copies arrayB1 
		; starting on the predefined index and prints the modified version of
		; arrayB2 on the console
		mov startIndex, al; stores input int value in startIndex
		mov eax, 0; Cleanup of registers used during top marker
		mov edx, 0; Cleanup of registers used during top marker
		call copyArray; Refer to copyArray Proc
		call showArray; Refer to showArray Proc
		jmp continue; Jumps to continue marker
		
	invalid:
		; Communicates when user has input something invalid
		; Jumps to continue marker.

		mov edx, offset strInputError; Gets marker to input error string
		call WriteString; Irvine operation to write string to console
		call Crlf; Irvine operation to create line break on console
		jmp continue; Jumps to continue marker

	continue:
		; outputs prompt to determine if user wants to continue
		; Accepts input of string
		mov edx, OFFSET promptCont; Gets marker to continue prompt string
		call WriteString; Irvine operation to write string to console
		mov edx, OFFSET stringIn; Gets marker to input string
		mov ecx, 2d; Sets limit for number of characters of input
					; including implied null char
		call ReadString; Irvine operation to take string as input from console
		
		; Compares input to 'y' to confirm if user wants to continue program
		cmp stringIn, "y"
		je top; jumps to top marker

		; Compares input to 'n' to confirm if user wants to end program
		cmp stringIn, "n"
		je closure; jumps to closure marker

		jmp invalid; Jumps to invalid marker if none of the tests are passed

	closure:
		call endProgram; Refer to endProgram proc
	invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
		; 0 = param to pass
main ENDP
End main