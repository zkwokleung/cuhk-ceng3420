.global _start

.data
array1: .word -1 22 8 35 5 4 11 2 1 16
newline: .ascii "\n"
space: .ascii " "

.macro push (%reg)
	addi sp, sp, -4
	sw %reg, 0(sp)
.end_macro

.macro pop (%reg)
	lw %reg, 0(sp)
	addi sp, sp, 4
.end_macro

.macro nextline
	li a7, 4
	la a0, newline
	ecall
.end_macro

.text
_start:
	# print the array before quick sort
	jal print_array1
	
	la a0, array1
	li a1, 0
	li a2, 9
	jal quick_sort
	
	# print the array after quick sort
	jal print_array1
			
	# Exit
	li a7, 10
	ecall
	
# quicksort(a0 : A, a1 : low, a2 : high)
quick_sort:
	# jump to the end if low >= high
	bge a1, a2, end_quick_sort
	
	# save ra for recursion
	push ra
	
	# save a0, a1, a2
	push a2
	push a1
	push a0
	
	jal partition
	
	# save the return value to s0
	mv s0, a0
	
	# retrieve a0, a1
	pop a0
	pop a1
	
	# a2 = p - 1
	addi a2, s0, -1
	
	# save the array and the return value into the stack
	push a0
	push s0
	
	# quick sort left half
	jal quick_sort
	
	# retrieve the array and p
	pop s0
	pop a0
	pop a2
	
	# a1 = p + 1
	addi a1, s0, 1
	
	# quick sort the right half
	jal quick_sort
	
	end_quick_sort:
		pop ra
		ret

# partition(a0 : A, a1 : low, a2 : high)
partition:
	push ra

	# load the pivot into s0
	lb s0, 36(a0)
	
	# load the low pointer into s1
	li s1, 0
	
	# load the high pointer into s2
	li s2, 9
	
	# load i into s3
	li s3, -1
	
	# load j into s4
	li s4, 0
	
	# i <- lo-1
	li t0, 0
	addi t0, t0, -1
	
	partition_loop:
		# get array[s4]
		# store the address of array[a1] into t1
		slli t0, s4, 2
		add t0, t0, a0
		lb t1, (t0)
		
		# jump to the end of the if statement if s4 > s0
		bgt t1, s0, end_partition_if
		
		# i <- i + 1
		addi s3, s3, 1
		
		# swap A[i] with A[j];
		la a0, array1
		mv a1, s3
		mv a2, s4
		jal swap
		
		end_partition_if:
			# back to the start of the loop if s1 < s2 and increase s1
			addi s4, s4, 1
			blt s4, s2, partition_loop
		
	end_partition_loop:
		# i + 1
		addi s3, s3, 1
		
		# swap A[i+1] with A[hi]
		la a0, array1
		mv a1, s3
		mv a2, s2
		jal swap
		
		# return i + 1 in a0
		mv a0, s3
		
		# return
		pop ra
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
	

	
print_array1:
	# Load array1[0] into t0
	la t0, array1
	# Load the tail of the array into t1
	la t1, array1
	addi t1, t1, 36
	
	nextline
	 
	loop_print_array1:
		# Loop until reach the end of array1
		bgt t0, t1, end_print_array1
		
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
			nextline
			
			ret
