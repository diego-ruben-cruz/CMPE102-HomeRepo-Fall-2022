INCLUDE Irvine32.inc

.data
num1	WORD	1h
num2	word	2h
sum		word	?

.code
main	PROC
	mov eax, 0h
	mov ax, num1
	mov sum, ax
	mov ax, num2
	add sum, ax
	mov ax, sum
	call WriteInt
	exit
main	ENDP
end		main