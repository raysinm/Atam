.global _start

.section .text
_start:
#your code here

movl (num), %r8d        #moving all memory contents to registers
movq $source, %rax         # -"-
movq $destination, %rbx        # -"-

test %r8d, %r8d
jz end_HW1

xor %rsi, %rsi
xor %rdi, %rdi

xor %rcx, %rcx

add $0, %r8d
jns num_is_pos_HW1

# %%%%% num is negative - we copy dest -> src %%%%%%

#converting num to unsigned
not %r8d
inc %r8d    

#checking if source and dest overlap:

not %rbx
inc %rbx
lea (%rax, %rbx), %r11d #r11d = src - dst

not %rbx
inc %rbx
xor %ecx, %ecx

add  $0, %r11d
js loop_dest_src_HW1

cmp %r11d, %r8d #if distance smaller than num
jbe loop_dest_src_HW1   #no overlap

movl %r8d, %ecx

loop_dest_src_overlap_HW1: #yes overlap

dec %ecx
movb destination(%ecx), %r9b
movb %r9b, source(%ecx)

test %ecx, %ecx
jz end_HW1
jmp loop_dest_src_overlap_HW1

loop_dest_src_HW1:
movb destination(%ecx), %r9b
movb %r9b, source(%ecx)

inc %ecx

cmp %r8d, %ecx
jae end_HW1
jmp loop_dest_src_HW1

#%%%%%%%# num positive #%%%%%%%#

num_is_pos_HW1:
dec %rax
not %rax

lea (%rbx, %rax), %r11d # r11 = dst - src

not %rax
inc %rax
xor %ecx, %ecx

add  $0, %r11d
js loop_src_dest_HW1
break:
cmp %r11d, %r8d #if distance smaller than num
jbe loop_src_dest_HW1   #no overlap

movl %r8d, %ecx
loop_src_dest_overlap_HW1: #yes overlap

dec %ecx

movb source(%ecx), %r9b
movb %r9b, destination(%ecx)

test %ecx, %ecx
jz end_HW1
jmp loop_src_dest_overlap_HW1

loop_src_dest_HW1:
movb source(%ecx), %r9b
movb %r9b, destination(%ecx)

inc %ecx

cmp %r8d, %ecx
jae end_HW1
jmp loop_src_dest_HW1

end_HW1:




