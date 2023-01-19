.global _start

.data
array1: .word -1 22 8 35 5 4 11 2 1 78
newline: .ascii "\n"
space: .ascii " "

.text
_start:
	# Load array1[0] into t0
	la t0, array1
	
	jal print_array1
	
	# Exit
	li a7, 10
	ecall
	
partition:
	# Load array1[2] (the pivot) into t1
	lw t1, 8(t0)
	

print_array1:
	# Load array1[0] into t0
	la t0, array1
	# Load the tail of the array into t6
	la t6, array1
	addi t6, t6, 36
	 
	loop_print_array1:
		# Loop until reach the end of array1
		bgt t0, t6, end_print_array1
		
		# Do the printing
		li a7, 1
		lw a0, (t0)
		ecall
		
		# print a new space
		li a7, 4
		la a0, space
		ecall
		
		# Move to array1[i+1]
		addi t0, t0, 4
		b loop_print_array1
		
		end_print_array1:
			# Print new line
			li a7, 4
			la a0, newline
			ecall
			ret
		
print_newline:
	li a7, 4
	la a0, newline
	ecall
	ret

