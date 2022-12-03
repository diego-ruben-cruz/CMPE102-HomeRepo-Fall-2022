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

; Here is my attempt at implementing the displayText macro under professor's definition
    ; displayText MACRO text, newLine    ; Macro to write text within code to console
    ;         ;  I tried to get this macro to work, but I kept running into a 
    ;         ;  'constant value too large' error, which means I could not use direct quotes 
    ;         ;  encased in ""

    ;         ;  Furthermore, I could not use immediate operands if I used, 
    ;         ;  which did not allow me to use data string variables stored in memory
    ;         ;  strings I placed in .data
    ;         ;  As such, I decided to use two separate macros which would do the job.
    ;     pushad
    ;     mov edx, OFFSET text; Gets pointer to text input
    ;     call WriteString; Irvine32 operation to write string to console
    ;     .IF newLine == 1
    ;         call Crlf
    ;     .ENDIF
    ;     popad
    ; ENDM
;

displayText MACRO text    ; Macro to write text within code to console
    pushad; pushes content of all registers onto stack for preservation
    ; Note, pushad does 32bit values, pusha does 16bit values
    mov edx, OFFSET text; Gets pointer to text input
    call WriteString; Irvine32 operation to write string to console
    popad; pops content of stack onto all respective registers
ENDM

displayLine MACRO text  ; Macro to write text with a newline included to console
    pushad; pushes content of all registers onto stack for preservation
    mov edx, OFFSET text; Gets pointer to text input
    call WriteString; Irvine32 operation to write string to console
    call Crlf; Irvine 32 operation to write newline to console
    popad; pops content of stack onto all respective registers
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
    displayLine strTitle; Refer to displayLine Macro
    displayLine strLineInsert; Refer to displayLine Macro
    ; Pushes content of all variables onto the stack
    ; Remember, FILO principle when it comes to the stack
    push num5
    push num4
    push num3
    push num2
    push num1
    call runLevelTwo ; Refer to runLevelTwo Procedure
	ret; Equivalent to return but for procedures outside of main
runLevelOne ENDP

runLevelTwo PROC    ; Iterates through the stack and prints out the effective memAddress and contents
    pop eax; Pops eax for cleaning house, gets it ready to iterate through the rest of the stack.
    
    ; 1h
    displayText strAddress; refer to displayText macro
    mov eax, esp; Copies value of address into eax
    call WriteHex; Irvine operation to write eax onto the console as a hexadecimal
    displayText strHexAppend; Refer to displayText macro
    displayText strArrowAppend; Refer to displayText macro
    displayText strContent; Refer to displayText macro
    pop eax; Pops value from stack into eax
    call WriteHex; Irvine operation to write eax onto the console as a hexadecimal
    displayLine strHexAppend; Refer to displayLine macro

    ;Refer to comments made in 1h for play-by-play of each line for the steps below.
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
    call WritwHex
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
	ret; Equivalent to return but for procedures outside of main
runLevelTwo ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
    call runLevelOne; Refer to runLevelOne Proc
    invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
        ; 0 = param to pass
main ENDP
End main