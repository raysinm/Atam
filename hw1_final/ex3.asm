.global _start

.section .text
_start:
#your code here

#movq (array1), %rax #indexes to arrays, should be incremented by 4 bytes each time
#movq (array2), %rbx

xorq %rax, %rax #indexes to arrays, should be incremented by 4 bytes each time
xorq %rbx, %rbx
xorq %rcx, %rcx #index for merged


.main_loop_HW1:

movl array1(%rax), %r11d    #moving array values into registers
movl array2(%rbx), %r12d

test %r11d, %r11d
jz .array1_empty_HW1

test %r12d, %r12d
jz .array2_empty_HW1


cmpl %r12d, %r11d
jae .array1_bigger_HW1

.array2_bigger_HW1:
movl %r12d, %r8d
add $4, %rbx
jmp .main_func_HW1

.array1_bigger_HW1:
movl %r11d, %r8d
add $4, %rax
jmp .main_func_HW1

.main_func_HW1:

test %rcx, %rcx
jnz .merged_is_not_empty_HW1

.arrayx_enters_merged_HW1:
movl %r8d, mergedArray(%rcx)
add $4, %rcx
jmp .main_loop_HW1

.merged_is_not_empty_HW1:   #comparing with previous value in merged
movq %rcx, %r9
sub $4, %r9
movl mergedArray(%r9), %r13d
cmp %r13d, %r8d
je .main_loop_HW1
jmp .arrayx_enters_merged_HW1

.array1_empty_HW1:  #if one of the arrays is empty
test %r12d, %r12d   #if both arrays are empty we end
jz .end_HW1
jmp .array2_bigger_HW1

.array2_empty_HW1:
test %r11d, %r11d   #if both arrays are empty we end
jz .end_HW1
jmp .array1_bigger_HW1

.end_HW1:
movl $0, mergedArray(%rcx)
