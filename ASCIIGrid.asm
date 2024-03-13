.data
charArrayM: .space 256
charArrayN: .space 256
line: .ascii "\n"
.macro print_int (%x)
	li 	a7, 1
	mv 	a0, %x
	ecall
.end_macro

.macro read_int(%x)
	li 	a7, 5
	ecall
	mv 	%x, a0
.end_macro

.macro print_str (%x)
	.data
		str:	 .asciz %x
	.text
		li	a7, 4
		la 	a0, str
		ecall
.end_macro

.macro print_char(%x)
	li 	a7, 11
	li 	a0, %x
	ecall
.end_macro

.macro add_row (%res)
	li s1 1
	ble s1 %res arr
	j end_m
	arr: 
	bgt s1 %res oio
	jal addCharToCharArray_T
	jal addCharToCharArray_Y
	addi s1 s1 1
	j arr
	oio:
	li s1 1
	ble s1 %res arr_1
	arr_1: 
	bgt s1 %res end_m
	jal addCharToCharArray_p
	jal addCharToCharArray_N
	addi s1 s1 1
	j arr_1
	end_m:
.end_macro

.macro print_new_line (%res)
	li s1 1
	ble s1 %res arr
	j end_m
	arr:
	bgt s1 %res end_m
	la a0, charArrayM
	li a7, 4
	ecall
	la a0 line
	li a7, 4
	ecall
	la a0, charArrayN
	li a7, 4
	ecall
	la a0 line
	li a7, 4
	ecall
	addi s1 s1 1
	j arr
	j end_m
	end_m:
.end_macro


.text
.globl	main
main:
read_int (a3)
read_int (a4)
jal addCharToCharArray_Y
jal addCharToCharArray_N
add_row (a3)
print_new_line (a4)
la a0, charArrayM
li a7, 4
ecall
la a0 line # заглушка...
li a7, 4
ecall
la a0 line # заглушка...
li a7, 4
ecall
li a7 10
ecall

addCharToCharArray_Y:
    la a0, charArrayM
    li a2, '+'
    findNullLoop:
        lb a1, 0(a0)
        beq a1, zero, foundNull
        addi a0, a0, 1
        j findNullLoop

    foundNull:

    sb a2, 0(a0)
    ret
addCharToCharArray_N:
    la a0, charArrayN
    li a2, '|'
    findNullLoop_N:
        lb a1, 0(a0)
        beq a1, zero, foundNull_N
        addi a0, a0, 1
        j findNullLoop_N

    foundNull_N:

    sb a2, 0(a0)
    ret
addCharToCharArray_T:
    la a0, charArrayM
    li a2, '-'
    findNullLoop_t:
        lb a1, 0(a0)
        beq a1, zero, foundNull_t
        addi a0, a0, 1
        j findNullLoop_t

    foundNull_t:

    sb a2, 0(a0)
    ret
addCharToCharArray_p:
    la a0, charArrayN
    li a2, ' '
    findNullLoop_p:
        lb a1, 0(a0)
        beq a1, zero, foundNull_p
        addi a0, a0, 1
        j findNullLoop_p

    foundNull_p:

    sb a2, 0(a0)
    ret