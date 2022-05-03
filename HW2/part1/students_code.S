.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss num, 8
.lcomm path, 1024


.section .text
read_input:
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
  lea num(%rcx), %rsi
  push %rcx
  syscall
  pop %rcx
  
  cmpq $0xa, num(%rcx) #comparing latest read character with "\n"
  je continue_reading_HW2
  inc %rcx
  jmp reading_first_number_loop_HW2
  
  continue_reading_HW2:
  movb $0, num(%rcx) #null termination of the string
  push %rdi
  movq $num, %rdi
  xor %rax, %rax
  call atam_atol
  movq %rax, %rdx
  #now %rdx holds n
  pop %rdi  #rdi once again holds file descriptor
  
  movq $0, %rax
  movq $codeword, %rsi
  syscall
 
  #closing the file:
  movq $3, %rax
  syscall
  
  #return value:
  movq %rdx, %rax
  ret

hamming_weight:
  #codeword adress is in rdi
  #len is in esi
  movq $64, %rcx
  xor %r9d, %r9d  #r9 counts 'len' loops 
  numbers_loop_HW2:
  inc %r9d
  movl (%rdi), %r8

      #count how many 1's in number
      while_loop_HW1:
      rorq %r8    #shift right in cycle
      jae bit_is_not_1_HW2  
      inc %rax
    
      bit_is_not_1_HW2:
      loop while_loop_HW1
  
  cmpq %r9d, %esi
  jne numbers_loop_HW2

  ret

negate_first_k:
  ret

bring_balance_to_the_word:
  ret
