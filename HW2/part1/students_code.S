.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss 
.lcomm path, 1024


.section .text
read_input:
  push %rbp
  movq %rsp, %rbp
  subq $8, %rsp #leaving place for mishtanim in the stack (to use for reading n)
    
  lea path(%rip), %rdi
  push %rdi
  call get_path #now path contains file path
  pop %rdi
  #now we open
  movq $2, %rax
  xor %rsi, %rsi
  syscall
  movq %rax, %rdi
  
  #now we read in a loop
  xor %rcx, %rcx
  reading_first_number_loop_HW2:
  movq $0, %rax
  movq $1, %rdx
  lea -7(%rbp, %rcx), %rsi    #(trying to) save each char we read in the stack- specifically, in the place we gave for mishtanim
  push %rcx
  syscall
  pop %rcx
  #movb (%rbp, %rcx), %al
  movb -7(%rbp, %rcx), %al
  
  cmpb $0xa, %al #comparing latest read character with "\n"
  je continue_reading_HW2
  inc %rcx
  jmp reading_first_number_loop_HW2
  
  continue_reading_HW2:
  movb $0, -7(%rbp, %rcx) #null termination of the string
  push %rdi
  lea -7(%rbp), %rdi
  xor %rax, %rax
  call atam_atol
  movq %rax, %rdx
  #now rdx holds n
  pop %rdi  #rdi once again holds file descriptor
  
  movq $0, %rax #?? dont remember what it does
  lea codeword(%rip), %rsi
  push %rdx
  push %rdi
  push %rsi
  syscall
  pop %rsi
  pop %rdi
  pop %rdx
  #closing the file:
  movq $3, %rax
  push %rdx
  push %rdi
  push %rsi
  syscall
  pop %rsi
  pop %rdi
  pop %rdx
  
  #return value:
  movq %rdx, %rax
  shr $3, %rax
  leave
  ret

hamming_weight:
  push %rbp
  movq %rsp, %rbp
  push %r8
  push %r9
  
  #codeword adress is in rdi
  #len is in esi
  mov %esi, %esi #for zero extension purposes
  xor %r9, %r9  #r9 counts 'len' loops 
  xor %rax, %rax #rax counts number of 1's
  
  numbers_loop_HW2:
  xor %ecx, %ecx
  lea (%rdi, %r9, 8), %rbx
  movq (%rbx), %r8
  
      #count how many 1's in number
      while_loop_HW2:
      rorq %r8    #shift right in cycle
      jae bit_is_not_1_HW2  
      inc %rax
    
      bit_is_not_1_HW2:
      inc %ecx
      cmpl $63, %ecx
      jne while_loop_HW2
  
  inc %r9
  cmpq %r9, %rsi
  jne numbers_loop_HW2
  

  pop %r9
  pop %r8
  leave
  
  ret

negate_first_k:
  pushq %rbp
  movq %rsp, %rbp
  #codeword is in rdi
  #k is in sil
  #cmp $64, %esi
  #je k_is_64_HW2    #then we just "not" it as a whole
  movb %sil, %cl    #moving k to cl for shr syntax
  movq $0xffffffffffffffff, %rdx #initialize rdx to be 64 1 bits
  shl %cl, %rdx #rdx is 1bits and k last bits are 0
  not %rdx
  xor %rdx, %rdi  #rdx holds rdi with k fliped bits
  jmp negate_end_HW2
  #k_is_64_HW2:
  #not %rdi
  negate_end_HW2:
  movq %rdi, %rax  #moves return val to rcx
  leave
  ret

bring_balance_to_the_word:
  #codeword adress in rdi
  #len in rsi
  
  push %rbp
  movq %rsp, %rbp
  
  push %r8
  push %r9
  push %r10
  push %r12
  xor %rbx, %rbx    #rbx counts index
  xor %rcx, %rcx    #rcx holds number of k bits out of 64 in each iteration
  xor %rdx, %rdx    #rdx holds number of 8byte portions we already passed
  
  movq %rdi, %r10   #r10 holds backup of original codeword address
  
  movq %rsi, %r8    #r8 holds number of 8-byte parts
  movq %rsi, %r9
  shl $3, %r9   #here r9 holds number of *bytes* in codeword
  shl $3, %r9   #here r9 holds number of *bits* in codeword
  shr $1, %r9   #now, finally r9 holds n/2 - the ideal hamming weight
  
  debug1:
  
  balance_loop_HW2:
  
      check_hamming_HW2:
      push %rdi
      push %rsi
      push %rbx
      push %rcx
      push %rdx
      
      call hamming_weight
      
      pop %rdx
      pop %rcx
      pop %rbx
      pop %rsi
      pop %rdi
      debug5:
      cmpq %rax, %r9 #checking if its balanced
      je end_knuth_HW2 
      jmp after_balance_check_HW2
      
       
              bits_loop_HW2:
              inc %rcx
              inc %rbx
              
              cmpq $64, %rcx
              jne doing_not_on_k_bits_HW2
              lea (%rdi, %rdx, 8), %r10 #stav moved here
              notq (%r10)
              jmp negate_previous_portions_HW2
              
              
                  doing_not_on_k_bits_HW2:
                  push %rdi
                  push %rsi
                  push %rbx
                  push %rcx
                  push %rdx
                          
                  movq (%r10), %rdi #neg needs codeword and not address
                  xor %rsi, %rsi
                  movb %cl, %sil
                  call negate_first_k
                  movq %rax, (%r10)
                 
                  pop %rdx
                  pop %rcx
                  pop %rbx
                  pop %rsi
                  pop %rdi
                  
                  negate_previous_portions_HW2:
                  cmpq $0, %rdx
                  je negate_previous_portions_end_HW2
                  push %rdx
                  push %r10
                  
                      negate_previous_portions_loop_HW2:
                      
                      dec %rdx
                      
                      flip_portion_HW2:
                      lea (%rdi, %rdx, 8), %r10
                      notq (%r10)
                      
                      cmpq $0, %rdx
                      jne negate_previous_portions_loop_HW2
                  
                  
                  pop %r10
                  pop %rdx
                  negate_previous_portions_end_HW2:
                  cmpq $1, %r11
                  je negate_back_end_HW2
              
              
              jmp check_hamming_HW2
              
              after_balance_check_HW2:
              xor %r12, %r12
              add %rdx, %r12
              add %rcx, %r12
              cmpq $0, %r12
              je negate_back_end_HW2
              negate_back_HW2:
              movq $1, %r11
              jmp doing_not_on_k_bits_HW2
              negate_back_end_HW2:
              movq $0, %r11
              
              
              debug2:
              
              cmpq $64, %rcx
              jne bits_loop_HW2
              je next_8byte_portion_HW2
              
          
          next_8byte_portion_HW2:
          
          inc %rdx  #next 8byte portion
          cmpq %rdx, %r8    #checking we're not outside of codeword
          je end_knuth_HW2
          xor %rcx, %rcx
          inc %rbx
          jmp negate_previous_portions_HW2
          #pop %rdi
  
  end_knuth_HW2: 
  debug4:
  movq %rbx, %rax   #returning index
  pop %r12
  pop %r10
  pop %r9
  pop %r8
  leave
  ret
  