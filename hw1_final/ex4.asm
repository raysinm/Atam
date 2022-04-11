.global _start

.section .text
_start:
pos1:
movq new_node, %r8          #copy new_node val to reg
movq (root), %rbx          #copy root address to reg
pos2:
movq %rbx, %r9          #move rbx address to reg	
test %r9, %r9
jz .insert_new_node_root_HW1        #jump to insert the node if root is 0
jmp .main_loop_HW1

.main_loop_HW1:
   movq (%rbx), %r12          #move rbx value to reg
   movq 8(%rbx), %r10        #r10 keeps left son
   movq 16(%rbx), %r11        #r11 keeps right son
	cmp %r12, %r8
	je .end_HW1			#jump to end if val found in tree
	ja .go_right_HW1		#jump right if bigger than node
	jb .go_left_HW1			#jump left if bigger than node

.go_left_HW1:
   test %r10, %r10
   jz .insert_new_node_left_HW1
	movq 8(%rbx), %rbx        #put left son address into %rbx
	jmp .main_loop_HW1
	
.go_right_HW1:
   test %r11, %r11
   jz .insert_new_node_right_HW1
	movq 16(%rbx), %rbx        #put right son address into %rbx
	jmp .main_loop_HW1

.insert_new_node_root_HW1:
    movq $new_node, (root)
    jmp .end_HW1
    	
.insert_new_node_left_HW1:
    movq $new_node, 8(%rbx)
    jmp .end_HW1

.insert_new_node_right_HW1:
    movq $new_node, 16(%rbx)
    jmp .end_HW1

.end_HW1:
