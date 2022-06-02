.global hook

.section .data
msg: .ascii "This code was hacked by Ella Lee's gang\n"
endmsg:

.section .text
hook:

  #making a.o not to exit after printing
  #ret is c3
  movb $0xc3, _start+0x1e

  #print original msg
  call _start
  
  #should come back here
  #printing our message
  movq $0x1, %rax
  movq $0x1, %rdi
  movq $msg, %rsi
  movq $endmsg-msg, %rdx
  syscall
  
  #going back to a.o as if nothing happened
  call _start+0x26
  
  movq $60, %rax
  movq $0, %rdi
  syscall
