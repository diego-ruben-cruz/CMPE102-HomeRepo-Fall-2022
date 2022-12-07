;for file header on top of the file
COMMENT @ 
Description:     
    Insert Program desc here

Name: Diego Cruz
Project: EC
Date: 07 December 2022
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

MON_SIZE = 4
MONTHS = 12
ARR_SIZE = 50

salesRecord STRUCT
    month BYTE MON_SIZE dup(?)
    align DWORD
    amount DWORD
salesRecord ENDS

printText MACRO text, newLine:=<-99>
    local msg
    .data
    msg BYTE text, 0
    
    .code
    pusha
    mov edx, OFFSET msg
    call WriteString
    .IF newLine eq -99
    nop
    .ELSE
    call Crlf
    .ENDIF
    popa
ENDM

.data; below declare data label


.code; to include assembly statement inside

show PROC c, address:DWORD 
    ret
view ENDP

hi PROC c
    ret
hi ENDP

lo PROC c
    ret
lo ENDP

view PROC c
    ret
view ENDP

edit PROC c
    ret
edit ENDP

total PROC c
    ret
total ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
    call printTitle
    mov ecx, numCars
    mov edi, 0

L1:
    push ecx
    printText "Model: "
    lea edx, (BMW PTR inventory[edi]).model
    mov ecx, stringSize
    call readString

    printText "Series: "
    call readDec
    mov (BMW PTR inventory[edi]).series, eax

    printText "Price: "
    call readDec
    mov (BMW PTR inventory[edi]).price, eax

    add edi, TYPE BMW
    pop ecx
    loop L1
    invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
        ; 0 = param to pass
main ENDP
End main