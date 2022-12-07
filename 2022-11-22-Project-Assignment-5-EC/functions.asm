;for file header on top of the file
COMMENT @ 
Description:     
    Extra Credit project for CMPE 102 Fall 2022
    Creates a sales reporting system for 50 months at a time
    Flawed in that you can only store 12 unique months at a time


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
    month BYTE MON_SIZE dup(?)  ; Mon_Size is 4, 3 letters, one nullchar
                                ;example: "Jan", 0
    align DWORD; Aligns to nearest DWORD-based address
    amount DWORD 0d ; 32bit/4-byte decimal value
                    ; Initialized to 0
salesRecord ENDS

; PrintText macro that can create new line if number is entered other than default
printText MACRO text, newLine:=<-1>
    local msg; local variable to store text param
    .data
    msg BYTE text, 0; Adds nullchar to end of string for cleanup purposes
    
    .code
    pusha; Stack preservation
    mov edx, OFFSET msg; Basic operation to setup writestring
    call WriteString; Irvine32 operation to write string to console
    .IF newLine eq -1
        nop; void-like operation to not do anything 
    .ELSE
        call Crlf; inserts new line if newLine input is 
    .ENDIF
    popa; Cleaning house
ENDM

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
fetchMonth BYTE 4 dup(?); Stores month from array into local variable
fetchAmount DWORD ?; Stores amount from array into local variable 
recordArray QWORD ARR_SIZE dup(0); Internal-use array for possible testing in main method


.code; to include assembly statement inside

show PROC c, address:DWORD
        mov ecx, ARR_SIZE; sets counter to size of the array
        mov edi, address; Uses address param to reference the address of the array to be probed
                        ; Could be used with recordArray in main with OFFSET?
        mov eax, 0; Initializes eax
        mov ebx, 0; Initializes ebx
    L1:
        mov ebx, [edi]; fetches the month from edi into EBX
        mov edx, OFFSET fetchMonth; Used inspiration from ReadString
        add [edx], ebx; Should move content from ebx into fetchMonth

        cmp fetchMonth, 0; Compares month value to 0, jumps out of loop if true
        je closure

        displayText fetchMonth; Prints out fetchMonth to console
        printText "     "; Prints out spacer between month and amount value
        printText "$"; Prints out $ sign for amount

        add edi, DWORD; gets address pointer to amount

        mov eax, [edi]; fetch the amount into eax
        call WriteDec; Irvine32 operation to write decimal to console
        call Crlf; Breaks a line
        loop L1; Loops back if ecx has not been exhausted
    closure:
        ; Basic cleanup of registers 
        mov ecx, 0
        mov edi, 0
        mov eax, 0
        mov ebx, 0
    ret
show ENDP

hi PROC c
        ; Initialize registers for loops and the like
        mov ecx, ARR_SIZE
        mov edi, OFFSET recordArray ; Not sure if this is proper, or if we should
                                    ; use an address parameter like in show PROC
        add edi, DWORD; initializes edi to first amount value 
        mov eax, [edi]; intializes  eax value to first amount value
    L1:
        .IF eax < [edi] ; Compares amount value to next amount value in the array
                        ; Except the first time around
                        ; If true, it replaces the eax with the current value that
                        ; edi points to
            mov eax, [edi]
        .ENDIF
        add edi, QWORD; gets address pointer to next amount value
        Loop L1
        printText "The highest sales amount: $"; Prints out high msg
        call WriteDec; Irvine32 operation to write decimal to console
        call Crlf; Irvine32 operation to linebreak
        ; Basic cleanup of registers
        mov ecx, 0
        mov edi, 0
        mov eax, 0
    ret
hi ENDP

lo PROC c
        ; Initialize registers for loops and the like
        mov ecx, ARR_SIZE
        mov edi, OFFSET recordArray ; Not sure if this is proper, or if we should
                                    ; use an address parameter like in show PROC
        add edi, DWORD; initializes edi to first amount value 
        mov eax, [edi]; intializes  eax value to first amount value
    L1:
        .IF eax > [edi] ; Compares amount value to next amount value in the array
                        ; Except the first time around
                        ; If true, it replaces the eax with the current value that
                        ; edi points to
            mov eax, [edi]
        .ENDIF
        add edi, QWORD; gets address pointer to next amount value
        Loop L1
        printText "The lowest sales amount: $"; Prints out low msg
        call WriteDec; Irvine32 operation to write decimal to console
        call Crlf; Irvine32 operation to linebreak
        ; Basic cleanup of registers
        mov eax, 0
        mov edi, 0
        mov ecx, 0

    ret
lo ENDP

view PROC c
    ret
view ENDP

edit PROC c
    ret
edit ENDP

total PROC c
        ; Initialize registers for loops and the like
        mov ecx, ARR_SIZE
        mov edi, OFFSET recordArray ; Not sure if this is proper, or if we should
                                    ; use an address parameter like in show PROC
        add edi, DWORD; initializes edi to first amount value 
        mov eax, 0; intializes eax to 0
    L1:
        add eax, [edi]; Adds on to eax to get total value from eax eventually
        add edi, QWORD; gets address pointer to next amout value
        Loop L1
        printText "Total Sales: $"; Prints out total msg
        call WriteDec; Irvine32 operation to write decimal to console
        call Crlf; Irvine32 operation to linebreak
        ; Basic cleanup of registers
        mov ecx, 0
        mov edi, 0
        mov eax, 0
    ret
total ENDP

main PROC ; Gets user input and calls other procedures. Main function, like in Obj-Oriented Langs.
    invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
        ; 0 = param to pass
main ENDP
End main