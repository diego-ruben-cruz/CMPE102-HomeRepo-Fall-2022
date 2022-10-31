;for file header on top of the file
COMMENT @ 
Description: 	
	Write a program that controls the laser system at a medical devices company.

Name: Diego Cruz
Project: 003
Date: 31 October 2022
@

INCLUDE Irvine32.inc ; Use Irvine32

; Comment block out if you are using Irvine 32
; =======================================
	; .386; to indicate 32 bit program

	; .model flat, stdcall
	;flat = protected mode
	;stdcall = standard calling convention
	;.model = ?

	; .stack 4096; define stack size for all apps. This is big enough 
	; stack size = 4096 bytes

	;ExitProcess PROTO, dwExitCode : dword  
				COMMENT @
				PROTOTYPE, comment out if you are using Irvine32
				ExitProcess PROTO = fn/procedure prototype to transfer/return execution to windows services
				otherwise, windows cannot run any execution & windows crashes
				dwExitCode is parameter
				dword = data type
				@
; =======================================

.data; below declare data label
; Variables that are set by user input
intIn BYTE 0 ; Input bit will be stored here
stringIn BYTE 2 DUP(?) ; 2 Dup(?) denotes that it will initialize as "??"

; Messages for communicating from console
strTitle BYTE "Medical Laser System",0 ; 0 denotes nullchar to end string	
promptInit BYTE "Start? (y/n): ",0

strStandby BYTE "System Standby",0
promptStandby BYTE "Standby bit (1/0): ",0

promptReady BYTE "Ready? (y/n): ",0
strReady BYTE "System Ready",0
promptReadyBit BYTE "Ready bit (1/0): ",0
promptFire BYTE "Fire? (y/n): ",0
strFired BYTE "System Fired",0
strUnfired BYTE "Unable to fire.",0


promptCont BYTE "Continue? (y/n): ",0


strTerminate BYTE "--- System Shutdown ---",0

strInputError BYTE "Invalid Input. Try Again",0

.code; to include assembly statement inside

displayTitle PROC ; Prints the project title 
	mov edx,OFFSET strTitle; Gets pointer to title string
	call WriteString; Irvine operation to write string to console
	call Crlf; Irvine operation to create line break on console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent to return but for procedures outside of main
displayTitle ENDP

endProgram PROC ; Prints the termination message
	mov edx,OFFSET strTerminate; Gets pointer to program termination string
	call WriteString; Irvine operation to write string to console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent to return but for procedure outside of main
endProgram ENDP

initStart PROC
	; Outputs initial prompt
	; Accepts user input for a string
	mov edx, OFFSET promptInit; Gets pointer for initial prompt string
	call WriteString; Irvine operation to write string to console
	ret; Equivalent to return but for procedure outside of main
initStart ENDP

ynStringInput PROC
	mov edx, OFFSET stringIn; Gets pointer for storing the string input
	mov ecx, 2d; sets a limit for the string input to be 2 chars or less, including nullchar
	call ReadString; Irvine operation to take string as input from console
	ret; Equivalent to return but for procedure outside of main
ynStringInput ENDP

invalidInput PROC
	mov edx, OFFSET strInputError; Gets marker to input error string
	call WriteString; Irvine operation to write string to console
	call Crlf; Irvine operation to create line break on console
	ret
invalidInput ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
	call displayTitle; Refer to displayTitle Proc
	start:
		; fetches input string from user
		call Crlf; Irvine operation to create line break on console
		call initStart; Refer to initStart procedure
		call ynStringInput; Refer to ynStringInput procedure

		; Compares input to 'y' to confirm if user wants to continue into standby
		cmp stringIn, "y"
		je standby; jumps to standby marker

		; Compares input to 'n' to confirm if user wants to end program
		cmp stringIn, "n"
		je closure; jumps to closure marker to end program

	standby:
		call Crlf; Irvine operation to create line break on console
		mov edx, OFFSET strStandby; Gets pointer to standby string
		call WriteString; Irvine operation to write string stored in edx
		call Crlf; Irvine operation to create line break on console
		mov edx, OFFSET promptStandby; Gets pointer to standby prompt string
		call WriteString; Irvine operation to write string stored in edx
		call ReadInt; Irvine operation to intake int input in eax

		; Compares input to 0, jumps to standby if equal.
		cmp ax, 0
		je standby

		; Compares input to 1, jumps to standbyGreenlight if equal
		cmp ax, 1
		je standbyGreenlight

		; If neither comparison is successful, it calls an error message and repeats the process
		call invalidInput
		jmp standby

	standbyGreenlight:
		mov intIn, al; takes int input and stores it in intIn var
		shl intIn, 7; shifts intIn var 7 places to the left, sets MSB
		mov eax, 0; cleanup for standby phase
		mov edx, 0; cleanup for standby phase
		jmp ready; Begins ready phase
		
	ready:
		call Crlf; Irvine operation to insert line break in console
		mov edx, OFFSET promptReady; Gets pointer for initial prompt string
		call WriteString; Irvine operation to write string to console
		call ynStringInput; refer to ynStringInput procedure
		
		; Compares input to 'y' to confirm if user wants to continue into readyGreenLight phase
		cmp stringIn, "y"
		je readyGreenlight; jumps to top marker

		; Compares input to 'n' to confirm if user wants to rollback into standby phase
		cmp stringIn, "n"
		je standby; jumps back to standby marker

		; If neither comparison is successful, it calls an error message and repeats the process
		call invalidInput
		jmp ready
 
	readyGreenlight:
		call Crlf; Irvine operation to insert line break in console
		mov edx, OFFSET strReady
		call Writestring
		call Crlf
		mov edx, OFFSET promptReadyBit
		call WriteString
		call ReadInt

		; Compares input to 0, then jumps to fire if it equals 0
		cmp ax, 0
		je fire

		; Compares input to 1, then jumps to fire if it equals 1
		cmp ax, 1
		je fire

		; If neither comparison is successful, it calls an error message and repeats the process
		call invalidInput
		jmp readyGreenlight

	fire:
		mov intIn, 10000000b
		add intIn, al
		mov eax, 0
		mov edx, 0
		
		call Crlf
		mov edx, OFFSET promptFire; Gets pointer for initial prompt string
		call WriteString; Irvine operation to write string to console
		call ynStringInput

		; Compares input to 'y' to confirm if user wants to fire laser
		cmp stringIn, "y"
		je fireGreenlight; jumps to top marker

		; Compares input to 'n' to confirm if user wants to go back to the start
		cmp stringIn, "n"
		je start; jumps back to start marker

		call invalidInput
		jmp fire
		
	fireGreenlight:
		cmp intIn, 10000001b
		je fireSuccess

		cmp intIn, 10000000b
		je fireFailed

	fireSuccess:
		call Crlf
		mov edx, OFFSET strFired
		call WriteString
		jmp fire

	fireFailed:
		call Crlf
		mov edx, OFFSET strUnfired
		call WriteString
		jmp readyGreenlight
	
	closure:
		call endProgram; Refer to endProgram proc
	invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
		; 0 = param to pass
main ENDP
End main