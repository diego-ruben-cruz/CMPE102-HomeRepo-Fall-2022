;for file header on top of the file
COMMENT ! 
Description:
Name:
Project:
Date:
!

;INCLUDE Irvine32.inc ; Use Irvine32

.386 ; to indicate 32 bit program, comment out if you are using Irvine32

.model flat stdcall; ; comment out if you are using Irvine32
;flat = protected mode
;stdcall vs ccall?! convention
;MODEL


.stack 4096 ;define stack size for all apps. This is big enough ; SIZE ; 4096 bytes? Comment out if using Irvine32

ExitProcess PROTO, dwExitCode : dword  ; PROTOTYPE, comment out if you are using Irvine32
; ExitProcess PROTO = fn/procedure prototype to transfer/return execution to windows services
; otherwise, windows can’t run any execution & windows crashes
; dwExitCode is parameter
; dword = data type

.data; below declare data label

.code; to include assembly statement inside

main PROC


	invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
; 0 = param to pass
main ENDP
End main