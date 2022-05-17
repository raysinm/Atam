.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
 
   
  push %rbp
  movq %rsp, %rbp

  xor %rdi, %rdi
  xor %rsi, %rsi
  xor %rdx, %rdx
  xor %rax, %rax

  movq 8(%rbp), %rsi  #rip is a *pointer* to the instruction, sitting on top of the kernel stack, the instruction contains opcode

  #testing the opcode(assuming opcode is in rip)
    opcode_test_HW2:
    movw (%rsi), %dx    #getting the opcode itself
    #ror  $8, %dx
    cmpb $0x0f, %dl
    je offset_is_2_bytes_HW2
    
    add $1, %rsi    #rsi will point to next instruction
    #push %rdi   #backing up rdi which holds old_ili_handler
    movb %dl, %al   #sending opcode as parameter to what_to_do
    movq %rax, %rdi
    jmp calling_what_to_do_HW2
    
    offset_is_2_bytes_HW2:
    add $2, %rsi    #rsi will point to next instruction
    #ror $8, %dx
    xor %rax, %rax
    movb %dh, %al   #sending opcode as parameter to what_to_do (two steps due to syntax)
    movq %rax, %rdi
    
    calling_what_to_do_HW2:
    #push %dx
    push %rsi
    call what_to_do
    pop %rsi
    #pop %dx 
    #pop %rdi #rdi should hold old_ili_handler
    #movq %rdi, %rbx #copying rdi to rbx to avoid clashing with rdi in the near future
    
    checking_return_value_HW2:
    cmp $0, %rax
    jne what_to_do_is_NOT_zero_HW2
       
        #old handler
    movq %rbp, %rsp #exiting this handler and (trying to be) causing rip to go to old_ili_handler
    pop %rbp    #taking out rip and exchanging with rsi
    push %rsi
    jmp *old_ili_handler
    #code SHOULD stop here because we jmp somewhere far far away
    jmp finish #just in case
    what_to_do_is_NOT_zero_HW2: #our handler
     
    movq %rax, %rdi     #moving the return value of what_to_do to rdi as requested
    

    movq %rbp, %rsp #exiting this handler
    pop %rbp 

    pop %rcx
    push %rsi
  finish:
  
  iretq
