.global _start

.section .text
_start:
#your code here

xor %r8, %r8    #r8 will count number of src in list
xor %r9, %r9    #r9 will count number of dst in list

movq (head), %rax   #rax = adress of A
movq (src), %r11
movq (dst), %r12

test %rax, %rax #checking if head is null
jz end_HW1

cmp %r11, %r12  #checking if src = dst
je end_HW1

#going over list to find number of src and dst in list
list_first_loop_HW1:
test %rax, %rax #checking if node is null
cmovz (head), %rax
jz first_loop_done_HW1
movq (%rax), %rbx
movq %rax, %r15 #backup
movq 8(%rax), %rax  #node = node->next

cmp %r11, %rbx  #see if we found something
je src_found_HW1
cmp %r12, %rbx
je dst_found_HW1
jmp list_first_loop_HW1

src_found_HW1:
inc %r8
movq %r15, %r13 #r13 is &src
jmp list_first_loop_HW1

dst_found_HW1:
inc %r9
movq %r15, %r14 #r14 is &dst
jmp list_first_loop_HW1

first_loop_done_HW1:
cmp $1, %r8
jne end_HW1
cmp $1, %r9
jne end_HW1

movq (head), %rax

movq 8(%r13), %rsi  #next values in regs
movq 8(%r14), %rdi

list_second_loop_HW1:
test %rax, %rax
jz head_check_HW1

movq %rax, %r9  #backup
movq 8(%rax), %rax  #node = node->next

cmp 8(%r9), %r13
#cmove %r14, 8(%rax)  #(src)previous->next = &dst
je next_node_is_src_HW1
cmp 8(%r9), %r14
#cmove %r13, 8(%rax) #(dst)previous->next = &src
je next_node_is_dst_HW1

jmp list_second_loop_HW1

next_node_is_src_HW1:
cmpq %r9, %r14
je dst_next_src_HW1 #they are neighbours
movq %r14, 8(%r9)  #(src)previous->next = &dst
jmp list_second_loop_HW1

next_node_is_dst_HW1:
cmpq %r9, %r13
je src_next_dst_HW1 #they are neighbours
movq %r13, 8(%r9) #(dst)previous->next = &src
jmp list_second_loop_HW1

#have to add seperate case of one of them being the first 
head_check_HW1:
cmpq (head), %r13
#cmove %r14, (head)    
je src_is_head_HW1
cmpq (head), %r14
#cmove %r13, (head)
je dst_is_head_HW1   

#if not next to each other
moving_nexts_HW1:
movq %rdi, 8(%r13)  #src->next = dst->next
movq %rsi, 8(%r14) #dst->next = src->next
jmp end_HW1

src_is_head_HW1:
movq %r14, (head)
jmp moving_nexts_HW1

dst_is_head_HW1:
movq %r13, (head)
jmp moving_nexts_HW1

src_next_dst_HW1:
movq %r13, %rsi
jmp head_check_HW1

dst_next_src_HW1:
movq %r14, %rdi
jmp head_check_HW1


end_HW1:

