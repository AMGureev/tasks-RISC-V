.data
charArray: .space 256

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

.macro check_if_equal (%x %y %z %otv)
	beq %x %y pro1
	j nou
	pro1:
	beq %x %z end
	nou:
	add t0 %x %y
	add t1 %x %z
	add t2 %y %z
	bgt %z t0 bad
	bgt %y t1 bad
	bgt %x t2 bad
	good:
	li %otv 1
	j end_mac
	bad:
	li %otv 2
	j end_mac
	end:
	li %otv 0
	end_mac:
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

.macro add_char (%res)
	li a1 1
	bgt %res a1 N
	bgtz %res Y
	j end_m
	Y: 
	jal addCharToCharArray_Y
	jal addCharToCharArray_s
	j end_m
	N:
	jal addCharToCharArray_N
	jal addCharToCharArray_s
	j end_m
	end_m:
.end_macro

.text
.globl	main
main:
while:
read_int (a3)
read_int (a4)
read_int (a5)
check_if_equal a3 a4 a5 a6
add_char (a6)
bnez a6 while
jal deleteLastChar
la a0, charArray
li a7, 4
ecall
li a7 10
ecall

addCharToCharArray_Y:
    la a0, charArray
    li a2, 'Y'
    findNullLoop:
        lb a1, 0(a0)
        beq a1, zero, foundNull
        addi a0, a0, 1
        j findNullLoop

    foundNull:

    sb a2, 0(a0)
    ret
addCharToCharArray_N:
    la a0, charArray
    li a2, 'N'
    findNullLoop_N:
        lb a1, 0(a0)
        beq a1, zero, foundNull_N
        addi a0, a0, 1
        j findNullLoop_N

    foundNull_N:

    sb a2, 0(a0)
    ret
addCharToCharArray_s:
    la a0, charArray
    li a2, '\n'
    findNullLoop_s:
        lb a1, 0(a0)
        beq a1, zero, foundNull_s
        addi a0, a0, 1
        j findNullLoop_s

    foundNull_s:

    sb a2, 0(a0)
    ret
deleteLastChar:
    la a0 charArray
    beq a0, zero, endDelete
    lb t0, 0(a0)
    beqz t0, endDelete

    findNullLoop_k:
        lb t1, 0(a0)
        beqz t1, replaceWithNull
        addi a0, a0, 1
        j findNullLoop_k

    replaceWithNull:
    sb zero, -1(a0)
    endDelete:
    ret