.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss 
.lcomm path, 1024


.section .text
read_input:
  push %rbp
  movq %rsp, %rbp
  subq $8, %rsp #leaving place for mishtanim in the stack (to use for reading n)
    
  lea path(%rip), %rdi
  call get_path #now path contains file path
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
  lea (%rbp, %rcx), %rsi    #(trying to) save each char we read in the stack- specifically, in the place we gave for mishtanim
  push %rcx
  syscall
  pop %rcx
  movb (%rbp, %rcx), %al
  cmpb $0xa, %al #comparing latest read character with "\n"
  je continue_reading_HW2
  dec %rcx
  jmp reading_first_number_loop_HW2
  
  continue_reading_HW2:
  movb $0, (%rbp, %rcx) #null termination of the string
  push %rdi
  movq %rbp, %rdi
  xor %rax, %rax
  call atam_atol
  movq %rax, %rdx
  #now rdx holds n
  pop %rdi  #rdi once again holds file descriptor
  
  movq $0, %rax #?? dont remember what it does
  lea codeword(%rip), %rsi
  syscall
 
  #closing the file:
  movq $3, %rax
  syscall
  
  #return value:
  movq %rdx, %rax
  shr $3, %rax
  leave
  ret

hamming_weight:
  push %rbp
  movq %rsp, %rbp
  #codeword adress is in rdi
  #len is in esi
  mov %esi, %esi #for zero extension purposes
  xor %r9d, %r9d  #r9 counts 'len' loops 
  xor %rax, %rax
  numbers_loop_HW2:
  xor %ecx, %ecx
  inc %r9
  lea (%rdi, %r9, 8), %rbx
  movq (%rbx), %r8
      #count how many 1's in number
      while_loop_HW2:
      rorq %r8    #shift right in cycle
      jae bit_is_not_1_HW2  
      inc %rax
    
      bit_is_not_1_HW2:
      cmpl $63, %ecx
      jne while_loop_HW2
  
  cmpq %r9, %rsi
  jne numbers_loop_HW2
  leave
  ret

negate_first_k:
  pushq %rbp
  movq %rsp, %rbp
  #codeword is in rdi
  #k is in esi
  movq (%rdi), %rdi
  cmp $64, %esi
  je k_is_64_HW2    #then we just "not" it as a whole
  movb %sil, %cl    #moving k to cl for shr syntax
  movq $0xffffffff, %rdx #initialize rdx to be 64 1 bits
  shr %cl, %rdx #rdx is 1bits and k last bits are 0
  not %rdx
  xor %rdx, %rdi  #rdx holds rdi with k fliped bits
  jmp negate_end_HW2
  k_is_64_HW2:
  not %rdi
  negate_end_HW2:
  movq %rdi, %rax  #moves return val to rcx
  leave
  ret

bring_balance_to_the_word:
  pushq %rbp
  movq %rsp, %rbp
  push %r15
  push %r14
  push %r13
  push %r12
  
  #codeword adress is in rdi 
  #len is in esi    
  call read_input
  shl $2, %rax #n returns as n/8 so multiply it by 4
  movq %rax, %r14 #r14 holsd n/2 to compare to hamming weight
  xor %r13, %r13 #counter for remainder bits to flip that dont belong to a full 8 byte row
  xor %r15, %r15 #counter for bits to flip that belong to full 8 byte rows
  
  
    is_balanced_loop_HW2:
      #codeword adress is in rdi
      #len is in esi
      #movzx %esi, %rsi     #wont let me do it 32->64, i hope the zero extension has already happened (tirgul 2 page 19)
      push %rdi
      push %rsi
      call hamming_weight
      pop %rsi
      pop %rdi
      cmp %rax, %r14
      je end_knuth_HW2
      cmp $63, %r13
      je left_is_8_HW2
      inc %r13
      xor %r12, %r12
      jmp not_first_k_bits_loop_HW2
    
    left_is_8_HW2:
      xor %r13, %r13
      add $64, %r15
      xor %r12, %r12 #counter for the full 8 byte rows we already sent to negate_first_k
    	
    not_first_k_bits_loop_HW2:
      cmp %r12, %r15
      jne not_first_k_bits_btyes_HW2
      test %r13, %r13
      jnz not_first_k_bits_left_HW2
      jmp is_balanced_loop_HW2
    
    not_first_k_bits_btyes_HW2:
      lea (%rdi,%r12), %rdi
      movq $64, %rsi
      push %rdi
      push %rsi
      call negate_first_k
      pop %rsi
      pop %rdi
      
      movq %rax, (%rdi)
      add $64, %r12
      jmp not_first_k_bits_loop_HW2
    	
    not_first_k_bits_left_HW2:
      lea (%rdi,%r15), %rdi
      movq %r13, %rsi
      push %rdi
      push %rsi
      call negate_first_k
      pop %rsi
      pop %rdi
      
      movq %rax, (%rdi)
      jmp is_balanced_loop_HW2
    
    end_knuth_HW2:
      add %r13, %r15 #add r13 to %r15
      movq %r15, %rax  #index to return
      pop %r12
      pop %r13
      pop %r14
      pop %r15
      leave
      ret