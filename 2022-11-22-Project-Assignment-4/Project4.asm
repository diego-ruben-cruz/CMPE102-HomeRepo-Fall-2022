;for file header on top of the file
COMMENT @ 
Description:     
    Insert Program desc here

Name: Diego Cruz
Project: 04
Date: 4 December 2022
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
; Variables listed here

; Strings listed here
strTitle BYTE "System Parameters on Stack",0
strLineInsert BYTE "====================================",0
strAddress BYTE "Address: ",0
strArrowAppend BYTE " => ",0
strContent BYTE "Content: ",0
strHexAppend BYTE "H",0 ; 0 denotes null char to end string


.code; to include assembly statement inside

displayText MACRO text, newLine    ; Macro to write text within code to console
    push edx; pushes content of edx onto the stack
    mov edx, OFFSET text; Gets pointer to text input
    call WriteString; Irvine32 operation to write string to console
    pop edx; pops content of edx out from the stack

    .IF newLine == 1    ; compares newLine input to 1
        call Crlf       ; makes new line if newLine = 1
    .ENDIF
ENDM

runLevelOne PROC
    displayText strTitle,1
    displayText strLineInsert,1
    call runLevelTwo
    ; Can insert the meat of the program here
    ret
runLevelOne ENDP

runLevelTwo PROC
    ; Can insert the meat of the program here
    displayText strLineInsert,1
    ret
runLevelTwo ENDP

; showArray PROC ; Displays array contents on the console
; 	mov ecx, LENGTHOF arrayDW; initializes counter with length of arrayB2
; 	mov edi, OFFSET arrayDW; Gets pointer to arrayB2
; 	mov eax, 0; initializes eax to 0 for cleanup purposes
; 	L1:
; 		; Iterates through ArrayB2 and prints out the content
; 		add al, [edi]; fetches num from arrayB2
; 		add edi, TYPE arrayDW; point to next num in arrayB2
; 		call WriteHex; Writes out the number in al in hexadecimal form
; 		mov edx, OFFSET strHexAppend; Gets pointer to H string to be appended
; 		call WriteString; Irvine operation to write string to console
; 		call Crlf; Creates linebreak for next number
; 		mov al, 0; initializes al to 0 for next loop iteration
; 		loop L1 

; 	ret; Equivalent to return but for procedure outside of main
; showArray ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
    ; Insert your code here
    call runLevelOne
    popad
    invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
        ; 0 = param to pass
main ENDP
End main