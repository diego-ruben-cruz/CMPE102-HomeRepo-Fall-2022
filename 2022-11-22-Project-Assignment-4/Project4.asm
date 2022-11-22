;for file header on top of the file
COMMENT @ 
Description:     
    Displays stack addresses and 32-bit values which are 
    pushed on the stack when the procedures are called.

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
    ; push values on the stack
    call runLevelTwo
    ret
runLevelOne ENDP

runLevelTwo PROC
    ; Insert the logic statements meat of the program here
    displayText strLineInsert,1
    ret
runLevelTwo ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
    ; Insert your code here
    call runLevelOne
    popad
    invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
        ; 0 = param to pass
main ENDP
End main