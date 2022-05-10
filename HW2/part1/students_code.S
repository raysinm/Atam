.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss 
.lcomm path, 1024


.section .text
read_input:
  push %rbp
  movq %rsp, %rbp
  subq $8, %rsp
  
  movq $path, %rdi
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
  lea (%rbp, %rcx, -1), %rsi
  push %rcx
  syscall
  pop %rcx
  
  cmpq $0xa, (%rbp, %rcx, -1) #comparing latest read character with "\n"
  je continue_reading_HW2
  inc %rcx
  jmp reading_first_number_loop_HW2
  
  continue_reading_HW2:
  movb $0, (%rbp, %rcx, -1) #null termination of the string
  push %rdi
  movq $num, %rdi
  xor %rax, %rax
  call atam_atol
  movq %rax, %rdx
  #now %rdx holds n
  pop %rdi  #rdi once again holds file descriptor
  
  movq $0, %rax #?? dont remember what it does
  movq $codeword, %rsi
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
  movq $64, %rcx
  xor %r9d, %r9d  #r9 counts 'len' loops 
  numbers_loop_HW2:
  inc %r9d
  movl (%rdi), %r8

      #count how many 1's in number
      while_loop_HW2:
      rorq %r8    #shift right in cycle
      jae bit_is_not_1_HW2  
      inc %rax
    
      bit_is_not_1_HW2:
      loop while_loop_HW2
  
  cmpq %r9d, %esi
  jne numbers_loop_HW2
  leave
  ret

negate_first_k:
  pushq %rbp
  movq %rsp, %rbp
  #codeword is in rdi
  #ks is in esi
  movq $0xffffffff, %rcx #initialize rcx to be 64 1 bits
  shr %esi, %rcx #rcx is 1bits and k last bits are 0
  not %rcx
  xor %rdi, %rcx  #rcx holds rdi with k fliped bits
  movq %rcx, %rax  #moves return val to rcx
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
  xor %r13, %r13 #counter for remainder bits to flip
  xor %r15, %r15 #counter for bytes to flip
  
    is_balanced_loop_HW2:
      #codeword adress is in rdi
      #len is in esi
      push %rdi
      push %esi
      call hamming_weight
      pop %rdi
      pop %esi
      cmp %rax, %r14
      je end_knuth_HW2
      cmp $63, %r13
      je left_is_8_HW2:
      inc %r13
      xor %r12, %r12
      jmp not_first_k_bits_loop_HW2
    
    left_is_8_HW2:
      xor %r13, %r13
      add %r15
      xor %r12, %r12 #12 is saved by callee - pg 30 tirgul 4 - backup in callee!!!
    	
    not_first_k_bits_loop_HW2:
      cmp %r12, %r15
      jne not_first_k_bits_btyes_HW2
      test %r13, %r13
      jnz not_first_k_bits_left_HW2
      jmp is_balanced_loop_HW2
    
    not_first_k_bits_btyes_HW2:
      lea codeword(,%r12,8), %rdi
      movl $64, %esi
      push %rdi
      push %esi
      call negate_first_k
      pop %rdi
      pop %esi
      movq %rax, (%rdi)
      inc %r12
      jmp not_first_k_bits_loop_HW2:
    	
    not_first_k_bits_left_HW2:
      lea codeword(,%r15,8), %rdi
      movl %r13, %esi
      push %rdi
      push %esi
      call negate_first_k
      pop %rdi
      pop %esi
      movq %rax, (%rdi)
      jmp is_balanced_loop_HW2
    
    end_knuth_HW2:
      shl $3, %r15 #multiply r15 by 8 to turn to bits
      add %r13, %r15 #add r13 to %r15*8
      movq %r15, %rax  #index to return
      pop %r15
      pop %r14
      pop %r13
      pop %r12
      leave
      ret