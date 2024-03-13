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
    la   s1 array
    li   s6 0
    read_array s1 s0
    mv   s2 a0
    print_array s1 s0
    la x5,array
li x6,0 #index
addi s0 s0 -1
mv x7,s0 #end index
loop1:
    bge x6,x7,exit1
    slli s10,x6,2
    add x9,x5,s10
    li s7 1
    
    addi x11,x6,1
    loop2:
        bgt x11,x7,exit2
        slli x12,x11,2
        add x13,x5,x12
        lw x10,0(x9)
        lw x14,0(x13)
        
        bgt x14,x10,skip
        sw x14,0(x9)
        sw x10,0(x13)
        skip:
        addi x11,x11,1
        
        beq x0,x0,loop2
        exit2:
        addi x6,x6,1
    beq x0,x0,loop1
exit1:
mv x6 zero
la x5, array
  
    nop
    j   end
  end:

li t0 0
la t1 array
addi s0 s0 1
loop4:
  bge t0 s0 end4
  lw a1 (t1)
  li a7 1
  mv a0 a1
  ecall
  li a7 4
  la a0 space
  ecall
  addi t0 t0 1
  addi t1 t1 4
  j loop4
  

end4:
  la a0 next
  li a7 4
  ecall
  
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
