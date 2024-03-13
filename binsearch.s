binary_search:
  mv t0 a0
  bgt a2 a3 return_neg
  mv t1 a2
  neg t1 t1
  add t1 t1 a3
  li t2 2
  div t1 t1 t2
  add t1 t1 a2
  
  li t2 4
  mul t1 t1 t2
  add t0 t0 t1
  lw t3 (t0)
  
  beq t3 a1 return_eq
  bgt t3 a1 return_larger
  j return  

return_neg:
  li a0 -1
  ret
return_eq:
  div t1 t1 t2
  mv a0 t1
  ret
return_larger:
  mv t6 ra
  addi sp sp -4
  sw t6 (sp)
  
  div t1 t1 t2
  addi a3 t1 -1
  jal binary_search
  
  lw ra (sp)
  addi sp sp 4
  ret
return:
  mv t6 ra
  addi sp sp -4
  sw t6 (sp)
  
  div t1 t1 t2
  addi a2 t1 1
  jal binary_search
  
  lw ra (sp)
  addi sp sp 4
  ret
