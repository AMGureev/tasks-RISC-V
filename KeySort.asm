.macro read_array %int %intR           # Макрос для обработки массива
  addi  sp sp -4
  sw   ra (sp)
  mv   a0 %int
  mv   a1 %intR
  jal   _readArray
  lw   ra (sp)
  addi   sp sp 4
.end_macro


.macro print_array %int %intR
        addi  sp sp -4
  sw   ra (sp)
  mv   a0 %int
  mv   a1 %intR
  jal   _print
  lw   ra (sp)
  addi   sp sp 4
.end_macro

.macro print_int (%x)
  li   a7, 1
  mv   a0, %x
  ecall
.end_macro

.macro read_int(%x)
  li   a7, 5
  ecall
  mv   %x, a0
.end_macro

.macro print_str (%x)
  .data
    str:   .asciz %x
  .text
    li  a7, 4
    la   a0, str
    ecall
.end_macro

.macro print_char(%x)
  li   a7, 11
  li   a0, %x
  ecall
.end_macro

.macro swap %a %b
	lw t5 (%a)
	lw t6 (%b)
	sw t5 (%b)
	sw t6 (%a)
.end_macro 

.macro newline
  print_char('\n')
.end_macro
.data
  .align   2
  array:   .space   25000
  space: .ascii " "
  .align 3
  next: .ascii "\n"
.text
.globl  main
main:
  start:  
    read_int(a0)
    li   t0 1
    mv   s0 a0
    read_int(s3)
    la   s1 array
    li   s6 0
    read_array s1 s0
    mv   s2 a0
    print_array s1 s0
    la t0,array
li t1,0 #indexF
addi s0 s0 -1
mv t2,s0 #end index

li s5 1
li a1 0
beq s3 s5 bubble_sort
loop1:
    bge t1,t2,exit1
    slli s10,t1,2
    add s1,t0,s10
    li s7 1
    
    addi a1,t1,1
    loop2:
        bgt a1,t2,exit2
        slli a2,a1,2
        add a3,t0,a2
        lw a0,0(s1)
        lw a4,0(a3)
        
        bgt a4,a0,skip
        sw a4,0(s1)
        sw a0,0(a3)
        skip:
        addi a1,a1,1
        
        beq zero,zero,loop2
        exit2:
        addi t1,t1,1
    beq zero,zero,loop1
    j exit1
bubble_sort:
loop1_1:
    bge t1,t2,exit1
    
    li a5 0
    addi a1,a5 1
    
    loop2_1:
    	li s9 4
        mul s10 a5 s9
        add s1,t0,s10
        li s7 1
    
        bgt a1,t2,exit2_1
        li s9 4
    	mul a2 a1 s9
        add a3,t0,a2
        lw s4,0(s1)
        lw a4,0(a3)
        
        mv s9 s4
        mv s8 a4
        li s7 10
        rem s9 s9 s7
        rem s8 s8 s7

        bge s9,s8,skip_1
        swap s1 a3
        
        skip_1:
        addi a1,a1,1
        addi a5 a5 1
        
        beq zero,zero,loop2_1
        exit2_1:
        addi t2 t2 -1
    beq zero,zero,loop1_1
    j exit1

exit1:



mv x6 zero
la x5, array
  
    nop
    j   end
  end:

li t0 0
la t1 array
addi s0 s0 1
addi s10 s0 -1
loop4:
  bge t0 s0 end4
  lw a1 (t1)
  li a7 1
  mv a0 a1
  ecall
  li a7 4
  la a0 next
  ecall
  addi t0 t0 1
  addi t1 t1 4
  j loop4
  

end4:
    li   a7 10
    ecall
  _readArray:
    mv   t0 a0
    mv   t1 a1
    li   t3 0
  loop_1:
    read_int(a0)
    sw   a0 0(t0)
    addi   t3 t3 1
    addi   t0 t0 4
    blt   t3 t1 loop_1
    ret
   _print:
     mv   t0 a0
    mv   t1 a1
    li   t3 0
     ret
   loop_2:
    addi   s7 s7 1          # Считаем кол-во обработанных программой строк
    lw   t3 0(t0)
    xor   t5 t4 t3 
    srli   t5 t5 31
    add   t4 t4 t3
    addi   t1 t1 1
    addi   t0 t0 4
    blt   t1 a1 loop_2
    mv   a0 t4
    ret
