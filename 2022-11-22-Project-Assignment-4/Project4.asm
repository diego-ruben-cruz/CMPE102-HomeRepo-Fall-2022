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

; displayText MACRO text, newLine    ; Macro to write text within code to console
    ;      I tried to get this macro to work, but I kept running into a 
    ;      'constant value too large' error, which means I could not use direct quotes 
    ;      encased in ""

    ;      Furthermore, I could not use immediate operands, which did not allow me to use
    ;      strings I placed in .data
    ;      As such, I decided to use two separate macros which would do the job.
;     pushad
;     mov edx, OFFSET text; Gets pointer to text input
;     call WriteString; Irvine32 operation to write string to console
;     .IF newLine == 1
;         call Crlf
;     .ENDIF
;     popad
; ENDM

displayText MACRO text    ; Macro to write text within code to console
    pushad
    mov edx, OFFSET text; Gets pointer to text input
    call WriteString; Irvine32 operation to write string to console
    popad
ENDM

displayLine MACRO text  ; Macro to write text with a newline included to console
    pushad
    mov edx, OFFSET text; Gets pointer to text input
    call WriteString; Irvine32 operation to write string to console
    call Crlf; Irvine 32 operation to write newline to console
    popad
ENDM

.data; below declare data label
; Variables listed here
num1 DWORD 1h
num2 DWORD 2h
num3 DWORD 3h
num4 DWORD 4h
num5 DWORD 5h

; Strings listed here
strTitle BYTE "System Parameters on Stack",0
strLineInsert BYTE "========================================",0
strAddress BYTE "Address: ",0
strArrowAppend BYTE " => ",0
strContent BYTE "Content: ",0
strHexAppend BYTE "H",0 ; 0 denotes null char to end string


.code; to include assembly statement inside
runLevelOne PROC    ; Basic procedure to initialize the program and stack
    displayLine strTitle
    displayLine strLineInsert
    push num5
    push num4
    push num3
    push num2
    push num1
    call runLevelTwo ; Refer to runLevelTwo Procedure
    ret
runLevelOne ENDP

runLevelTwo PROC    ; Iterates through the stack and prints out the effective memAddress and contents
    pop eax
    ; 1h
    displayText strAddress
    mov eax, esp
    call WriteHex
    displayText strHexAppend
    displayText strArrowAppend
    displayText strContent
    pop eax
    call WriteHex
    displayLine strHexAppend

    ; 2h
    displayText strAddress
    mov eax, esp
    call WriteHex
    displayText strHexAppend
    displayText strArrowAppend
    displayText strContent
    pop eax
    call WriteHex
    displayLine strHexAppend

    ; 3h
    displayText strAddress
    mov eax, esp
    call WriteHex
    displayText strHexAppend
    displayText strArrowAppend
    displayText strContent
    pop eax
    call WriteHex
    displayLine strHexAppend

    ; 4h
    displayText strAddress
    mov eax, esp
    call WriteHex
    displayText strHexAppend
    displayText strArrowAppend
    displayText strContent
    pop eax
    call WriteHex
    displayLine strHexAppend

    ; 5h
    displayText strAddress
    mov eax, esp
    call WriteHex
    displayText strHexAppend
    displayText strArrowAppend
    displayText strContent
    pop eax
    call WriteHex
    displayLine strHexAppend

    displayLine strLineInsert
    ret
runLevelTwo ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
    call runLevelOne
    invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
        ; 0 = param to pass
main ENDP
End main