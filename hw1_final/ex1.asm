.global _start


.section .text
_start:
#your code here

#num label exists

movq (num), %r8    #moving num to register to reduce access to memory
xorl %eax, %eax     #rax is counter = 0
movq $64, %rcx       

.while_loop_HW1:    
    rorq num    #shift right in cycle
    jae .bit_is_not_1_HW1  
    inc %eax

    .bit_is_not_1_HW1:
    loop .while_loop_HW1
    
movl %eax, CountBits

    

 
  
 

