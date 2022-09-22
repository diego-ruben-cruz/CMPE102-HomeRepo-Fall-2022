;INCLUDE Irvine32.inc

;for file header on top of the file
COMMENT ! 
Description: Write a program that calculates the following expression: 
				total =  (num3 + num4) - (num1 + num2) + 1
Name: Diego Cruz
SID: 013540384
Course: CMPE 102
Project: 001
Date: 25 September 2022
!

.386; to indicate 32 bit program - comment out if you are using Irvine32

.model flat stdcall; comment out if you are using Irvine32
;flat = protected mode
;stdcall vs ccall?! convention
;MODEL = ?


stack 4096 ; define stack size for all apps. This is big enough
;SIZE  4096 bytes

ExitProcess PROTO, dwExitCode : dword
; PROTOTYPE, comment out if you are using Irvine32
; ExitProcess PROTO = fn/procedure prototype to transfer/return execution to windows services
; otherwise, windows can’t run any execution & windows crashes
; dwExitCode is parameter
; dword = data type

.data; below declare data label
arrayB1 WORD 1000h, 2000h, 3000h, 4000h
WORD num1 1
WORD num2 2
WORD num3 4
WORD num4 8
DWORD total

.code; to include assembly statement inside
main PROC


	invoke ExitProcess, 0 ; to return execution to windows services otherwise prog crashes
; 0 = param to pass
main ENDP
End main