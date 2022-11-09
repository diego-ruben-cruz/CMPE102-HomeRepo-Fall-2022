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

; Start Phase
promptInit BYTE "Start? (y/n): ",0

; Standby Phase
strStandby BYTE "System Standby",0
promptStandby BYTE "Standby bit (1/0): ",0

; Ready Phase
promptReady BYTE "Ready? (y/n): ",0
strReady BYTE "System Ready",0
strReadyFailed BYTE "System not ready. Standby bit was not set",0
promptReadyBit BYTE "Ready bit (1/0): ",0

; Fire phase
promptFire BYTE "Fire? (y/n): ",0
strFired BYTE "System Fired",0
strUnfired BYTE "Unable to fire. Ready bit was not set",0

; Program End Message
strTerminate BYTE "--- System Shutdown ---",0

; Input Error Message
strInputError BYTE "Invalid Input. Try Again",0

.code; to include assembly statement inside

displayTitle PROC ; Prints the project title 
	mov edx, OFFSET strTitle; Gets pointer/reference to title string
	call WriteString; Irvine operation to write string stored in edx to console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent to return but for procedures outside of main
displayTitle ENDP

endProgram PROC ; Prints the termination message
	mov edx, OFFSET strTerminate; Gets pointer/reference to program termination string
	call WriteString; Irvine operation to write string stored in edx to console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent to return but for procedure outside of main
endProgram ENDP

initStart PROC ; Outputs initial prompt
	mov edx, OFFSET promptInit; Gets pointer/reference for initial prompt string
	call WriteString; Irvine operation to write string stored in edx to console
	ret; Equivalent to return but for procedure outside of main
initStart ENDP

ynStringInput PROC ; Takes in input from console and stores it in the EAX register as storage demands
	mov edx, OFFSET stringIn; Gets pointer for storing the string input
	mov ecx, 2d; sets a limit for the string input to be 2 chars or less, including nullchar
	call ReadString; Irvine operation to take string as input from console
	ret; Equivalent to return but for procedure outside of main
ynStringInput ENDP

invalidInput PROC ; Writes input error message to console
	mov edx, OFFSET strInputError; Gets pointer/reference to input error string
	call WriteString; Irvine operation to write string stored in edx to console
	call Crlf; Irvine operation to create line break on console
	ret; Equivalent o return but for procedure outside of main
invalidInput ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
	call displayTitle; Refer to displayTitle Proc
	start:
		; initializes with start prompt and collects input from user
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
		mov edx, OFFSET strStandby; Gets pointer/reference to standby string
		call WriteString; Irvine operation to write string stored in edx to console
		call Crlf; Irvine operation to create line break on console
		mov edx, OFFSET promptStandby; Gets pointer/reference to standby prompt string
		call WriteString; Irvine operation to write string stored in edx to console
		call ReadInt; Reads integer input from console and stores it in EAX register

		; Compares input to 0, jumps to standby if equal
		cmp ax, 0
		je standbyGreenlight; jump to standbyGreenlight marker

		; Compares input to 1, jumps to standbyGreenlight if equal
		cmp ax, 1
		je standbyGreenlight; jump to standbyGreenlight marker

		; If neither comparison is successful, it calls an error message and repeats the process
		call invalidInput; Refer to invalidInput proc
		jmp standby; jumps back to standby marker

	standbyGreenlight:
		mov intIn, al; takes int input and stores it in intIn var
		shl intIn, 7; shifts intIn var 7 places to the left, sets MSB
		mov eax, 0; cleanup for standby phase
		mov edx, 0; cleanup for standby phase
		jmp ready; Begins ready phase
		
	ready:
		; writes a prompt to determine 
		call Crlf; Irvine operation to insert line break in console
		mov edx, OFFSET promptReady; Gets pointer/reference for initial prompt string
		call WriteString; Irvine operation to write string stored in edx to console
		call ynStringInput; refer to ynStringInput procedure
		
		; Compares input to 'y' to confirm if user wants to continue into readyGreenLight phase
		cmp stringIn, "y"
		je readyGreenlight; jumps to readyGreenLight marker

		; Compares input to 'n' to confirm if user wants to rollback into standby phase
		cmp stringIn, "n"
		je standby; jumps back to standby marker

		; If neither comparison is successful, it calls an error message and repeats the process
		call invalidInput
		jmp ready
 
	readyGreenlight:
		; Compares input stored variable to see if MSB is clear
		cmp intIn, 00000000b
		je readyFailed; Jumps to readyFailed marker because MSB was not set

		; Writes ready string to console
		mov edx, OFFSET strReady; Gets pointer/reference for ready string
		call WriteString; Irvine operation to write string stored in edx to console
		call Crlf; Irvine operation to create line break on console

		; Writes ready prompt string to console and collects input from user
		mov edx, OFFSET promptReadyBit; Gets pointer/reference to ready prompt string
		call WriteString; Irvine operation to write string stored in edx to console
		call ReadInt; Reads integer input from console and stores it in EAX register

		; Compares input to 0, then jumps to fire if it equals 0
		cmp ax, 0
		je fire; Jumps to fire marker

		; Compares input to 1, then jumps to fire if it equals 1
		cmp ax, 1
		je fire; Jumps to fire marker

		; If neither comparison is successful, it calls an error message and repeats the process
		call invalidInput
		jmp readyGreenlight; Jumps to ReadyGreenlight to repeat the process.
		
	readyFailed:
		; Writes a readystate failed message because the standby bit was not set.
		mov edx, OFFSET strReadyFailed; Gets pointer/reference to failed readystate string
		call WriteString; Irvine operation to write string stored in edx to console
		jmp standby; returns to standby marker

	fire:
		; Initializes intIn variable with MSB set because if user reaches this marker,
		; it is already understood that they already set the standby bit.
		mov intIn, 10000000b
		add intIn, al; Adds readyGreenlight int input to stored variable
		mov eax, 0; Cleanup for ready phase
		mov edx, 0; Cleanup for ready phase
		
		mov edx, OFFSET promptFire; Gets pointer/reference for initial prompt string
		call WriteString; Irvine operation to write string stored in edx to console
		call ynStringInput; Refer to ynStringInput proc

		; Compares input to 'y' to confirm if user wants to fire laser
		cmp stringIn, "y"
		je fireGreenlight; jumps to top marker

		; Compares input to 'n' to confirm if user wants to go back to the start
		cmp stringIn, "n"
		je start; jumps to start marker

		; If neither comparison is successful, it calls an invalid input and repeats the process
		call invalidInput
		jmp fire; jumps back to fire marker
		
	fireGreenlight:
		; Compares intIn var to see if MSB and LSB are set
		cmp intIn, 10000001b
		je fireSuccess; Jumps to fireSuccess marker

		; Compares intIn var to see if only MSB is set
		cmp intIn, 10000000b
		je fireFailed; Jumps to fireFailed marker

	fireSuccess:
		; Writes fire success message, then returns to firing prompt
		mov edx, OFFSET strFired; Gets pointer/reference to fired string
		call WriteString; Irvine operation to write string stored in edx to console
		call Crlf; Irvine operation to create line break on console
		jmp fire; jumps to fire phase

	fireFailed:
		; Writes fire failed message, then returns to readyGreenlight to prompt ready bit
		mov edx, OFFSET strUnfired; Gets pointer/reference to unfired string
		call WriteString; Irvine operation to write string stored in edx to console
		call Crlf; Irvine operation to create line break on console
		jmp readyGreenlight; jumps to readyGreenlight phase
	
	closure:
		call endProgram; Refer to endProgram proc
	invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
		; 0 = param to pass
main ENDP
End main