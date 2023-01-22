.global _start

.data
array1: .word -1 22 8 35 5 4 11 2 1 78
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

.text
_start:
	jal print_array1

	la a0, array1
	li a1, 0
	li a2, 9
	jal quick_sort
	
	jal print_array1
			
	# Exit
	li a7, 10
	ecall
	
# Quicksort(A, lo, hi)
# Use a0 as A, a1 as lo, a2 as hi
quick_sort:
	# Jump to the end if lo >= hi
	bge a1, a2, quick_sort_end
	
	# Reserve ra for recursion
	push ra
	
	# store high and low in the stack
	push a2
	push a1
	
	jal partition
	
	jal print_array1

	# p - 1
	mv t0, s0
	addi t0, t0, -1
	
	# quicksort(A, lo, p-1)
	la a0, array1
	pop a1
	mv a2, t0
	
	# store the result of partition in the stack
	push s0
	
	jal quick_sort
	
	jal print_array1
	
	# p + 1
	pop t0
	addi t0, t0, 1
	
	# quicksort(A, p+1, hi)
	la a0, array1
	mv a1, t0
	pop a2
	jal quick_sort
	
	jal print_array1

	pop ra
	
	quick_sort_end:
		ret
	
# function Partition(A, lo, hi)
# Use a0 as A, a1 as lo, a2 as hi
# return i + 1 in s0
partition:
	# partition the array
	# load the pivot into t0
	slli t0, a2, 2
	add t0, t0, a0
	
	# t1 <- i <- lo - 1
	mv t1, a1
	addi t1, t1, -1
	
	# t2 <- j <- lo
	mv t2, a1
	
	# t3 <- hi - 1
	mv t3, a2
	addi t3, t3, -1
	
	partition_loop:
		# jump to the end of the if statement if j > hi - 1
		bgt t2, t3, end_partition_loop
		
		# i <- i + 1
		addi t1, t1, 1
		
		# store the address of array[j] into t4
		slli t4, t2, 2
		add t4, t4, a0
		
		# store the value of array[j] into t5
		lw t5, (t4)
		
		# Jump to end_if if array[j] > pivot
		bgt t5, t0, end_partition_if
		
		# i <- i + 1
		addi t1, t1, 1
		
		# temporary store a1, a2, t0, t1, t2, t3 in the stack
		push a1
		push a2
		push t0
		push t1
		push t2
		push t3
		
		# swap A[i] with A[j];
		la a0, array1
		mv a1, t1
		mv a2, t2
		jal swap
		
		# retrieve the values from stack
		pop t3
		pop t2
		pop t1
		pop t0
		pop a2
		pop a1
		
		end_partition_if:
			# increament j
			addi t2, t2, 1
			# back to the start of the loop if j <= high - 1
			ble t2, t3, partition_loop
		
		end_partition_loop:
			# i + 1
			addi t1, t1, 1
			
			push t1
			
			# swap A[i+1] with A[hi]
			la a0, array1
			mv a1, t1
			mv a2, a2
			jal swap
			
			pop t1
			
			# save i + 1 to s0
			mv s0, t1
	
			# return
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
			li a7, 4
			la a0, newline
			ecall
			ret
			