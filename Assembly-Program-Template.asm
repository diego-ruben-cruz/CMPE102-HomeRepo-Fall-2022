;for file header on top of the file
COMMENT! 
Description:
Name:
Project:
Date:
!

.386 ; to indicate 32 bit program

.model flat stdcall; ; assuming not including irvine library. If u include then ignore the red highlighted lines
;flat = protected mode
;stdcall vs ccall?! convention
;MODEL


.stack 4096 ;define stack size for all apps. This is big enough ; SIZE ; 4096 bytes?

ExitProcess PROTO, dwExitCode : dword  ; PROTOTYPE
; ExitProcess PROTO = fn/procedure prototype to transfer/return execution to windows services
; otherwise, windows can’t run any execution & windows crashes
; dwExitCode is parameter
; dword = data type

.data
; below declare data label

.code
; to include assembly statement inside

; NEED TO FOLLOW THIS FOR 1ST PROJECT

main PROC


	invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
; 0 = param to pass
main ENDP
End main

; for practice exercise:
;Define 2 #s, initialize them to 0, 10 or 20
