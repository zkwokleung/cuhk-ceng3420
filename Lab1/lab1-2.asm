.global _start

.data
array1: .word -1 22 8 35 5 4 11 2 1 78
low: .byte 0
high: .byte 9
i: .byte -1
j: .byte 0
newline: .ascii "\n"
space: .ascii " "

.text
_start:
	# Print the array before the partition
	jal print_array1

	# Swap the 3rd element in the array to the end 
	la a0, array1
	li a1, 2
	li a2, 9
	jal swap

	# partition the array
	# load the pivot into s0
	lb s0, 36(a0)
	
	# load the low pointer into s1
	la s1, low
	
	# load the high pointer into s2
	la s2, high
	
	# load i into s3
	la s3, i
	
	# load j into s4
	la s4, j
	
	partition_loop:
		
		
		# jump to the end of the if statement if s4 > s0
		bgt s4, s0, end_partition_if
		
		# increment s3 and swap array[s3] and array[s1]
		la a0, array1
		lb a1, (s3)
		lb a2, (s1)
		jal swap
		
		end_partition_if:
			# back to the start of the loop if s1 < s2 and increase s1
			addi s1, s1, 1
			blt s1, s2, partition_loop
		
		end_partition_loop:
			# swap array[s3+1] with array[s2]
			la a0, array1
			lb a1, (s3)
			lb a2, (s2)
			jal swap
	
			# Printing the array
			jal print_array1
			
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
	