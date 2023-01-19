.global _start

.data

.text
_start:
	
			
	# Exit
	li a7, 10
	ecall

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

swap: 
	# Swap array[a1] and array[a2]
	# Assume a0 store the address of the first element
	
	# store the address of array[a1] into t0
	slli t0, a1, 2
	add t0, t0, a0
	
	# store the address of array[a2] into t1
	slli t1, a2, 2
	add t1, t1, a0
	
	# load array[a1] to t2
	lw t2, (t0)
	
	# load array[a2] to t3
	lw t3, (t1)
	
	# store t3 to array[a1]
	sw t3, (t0)
	
	# store t2 to array[a2]
	sw t2, (t1)
	
	ret
	