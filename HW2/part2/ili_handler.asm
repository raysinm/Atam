.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
  
  pop %rsi  #rip is a *pointer* to the instruction, sitting on top of the kernel stack, the instruction contains opcode
  
  push %rbp
  movq %rsp, %rbp

  #testing the opcode(assuming opcode is in rip)
    opcode_test_HW2:
    movw (%rsi), %dx    #getting the opcode itself
    ror %dx, $1
    cmpb %dl, $0x0f
    je offset_is_2_bytes_HW2
    
    #push %rdi   #backing up rdi which holds old_ili_handler
    movw %dl, %dil   #sending opcode as parameter to what_to_do
    jmp calling_what_to_do_HW2
    
    offset_is_2_bytes_HW2:
    ror %dx, $1
    movw %dl, %dil   #sending opcode as parameter to what_to_do
    
    calling_what_to_do_HW2:
    #push %dx
    call what_to_do
    #pop %dx 
    #pop %rdi #rdi should hold old_ili_handler
    #movq %rdi, %rbx #copying rdi to rbx to avoid clashing with rdi in the near future
    
    checking_return_value_HW2:
    cmp %eax, $0
    jne what_to_do_is_NOT_zero_HW2
    
    movq %rbp, %rsp #exiting this handler and (trying to be) causing rip to go to old_ili_handler
    pop %rbp    
    push %rsi
    jmp *old_ili_handler
    #code SHOULD stop here because we jmp somewhere far far away
    
    what_to_do_is_NOT_zero_HW2:
    xor %rdi, %rdi  #moving the return value of what_to_do to rdi as requested
    movl %eax, %edi
    movq %rbp, %rsp #exiting this handler
    pop %rbp 
    lea 8(%rsi), %rsi #these two return rip to stack with +8, so that it points to the next instruction
    push %rsi 
  
  iretq
