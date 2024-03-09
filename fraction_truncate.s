# f = A/B in fa0 
# n in a0
# return rounded double F in fa0
#.data
#big: .double 0.2697368
#.text
#start:
#la a0 big
#fld fa0 (a0)
#li a0 7
#li a7 5
#ecall
#mv s1 a0
#li a7 5
#ecall
#mv s2 a0
#li a7 5
#ecall

#jal fruncate_traction
#li a7 3
#ecall
#li a7 10
#ecall
.macro print_char(%x)
  li   a7, 11
  li   a0, %x
  ecall
.end_macro

.macro newline
  print_char('\n')
.end_macro

.text
start:
li a7 5
ecall
mv s1 a0
li a7 5
ecall
mv s2 a0
li a7 5
ecall
fcvt.d.w fa4 s1
fcvt.d.w fa5 s2
fdiv.d fa0 fa4 fa5
jal fraction_truncate
li a7 3
ecall
newline
li a7 10
ecall
fraction_truncate:
	li a1 1
	li a2 10
	li a5 10
	bgt a0 a1 while 
	j end
while: 
	ble a0 a1 end
	mul a2 a2 a5
	addi a1 a1 1
	j while
end:
        bgt a1 a0 uvel
        j no_uv
        uvel:
        li a2 1
        no_uv:
	fcvt.d.w fa2 a2
	mul a2 a2 a5 # дополнительное умножение на 10 для проверки
	fcvt.d.w fa6 a2 # запись нового f регистра для сравнения
	fmul.d fa3 fa2 fa0
	fmul.d fa7 fa6 fa0 # записываем результат умножения в fa7 
	fcvt.w.d s4 fa7 # число для сравнения, оно в 10 раз больше нашего числа
	fcvt.w.d a4 fa3 
	mul s7 a4 a5 # умножаем наше число на 10 для сравнение  и нахождения остатка
	sub s5 s4 s7 # находим разницу между нашими числами
	# if s5 > 4...
	li s6 4
	li s9 2
	bgt s9 a1 nl
	bgt s6 s5 labell # число должны сделать -1
	j nl
	labell:
	li s6 1
	sub a4 a4 s6
	nl:
	fcvt.d.w fa3 a4
	fdiv.d fa0 fa3 fa2
	ret
