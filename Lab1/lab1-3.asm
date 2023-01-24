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

.macro print_int (%reg)
	li a7, 1
	mv a0, %reg
	ecall
.end_macro

.macro print_int_hex (%reg)
	li a7, 34
	mv a0, %reg
	ecall
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
	
	# quicksort
	la a0, array1
	li a1, 0
	li a2, 9
	jal quicksort
	
	# print the array after quick sort
	jal print_array1
			
	# Exit
	li a7, 10
	ecall
	
# quicksort(a0 : A, a1 : low, a2 : high)
quicksort:
	# jump to the end if low >= high
	bge a1, a2, end_quicksort
	
	# save ra for recursion
	push ra
	
	# save high, low, A
	push a2
	push a1
	push a0
	
	jal partition
	
	# save the return value p into s0
	mv s0, a0
	
	# retrieve A, low
	pop a0
	pop a1
	
	# p - 1
	addi a2, s0, -1	
	
	# save A, p
	push a0
	push s0
	
	# quicksort(A, low, p - 1)
	jal quicksort
	
	# retrieve p, A, high
	pop s0
	pop a0
	pop a2
	
	# p + 1
	addi a1, s0, 1
	
	# quicksort(A, p + 1, high)
	jal quicksort
	
	jal print_array1
	
	pop ra	
	end_quicksort:
		ret

# partition(a0 : A, a1 : low, a2 : high)
partition:
	push ra
	
	# s0 <- a0
	mv s0, a0
	
	# s1 <- a1
	mv s1, a1
	
	# s2 <- a2
	mv s2, a2

	# load the pivot into s3
	slli s3, s2, 2
	add s3, s3, s0
	lw s3, (s3)
	
	# s4 <- i <- low - 1
	addi s4, s1, -1
	
	# s5 <- j <- low
	mv s5, s1
	
	partition_loop:
		# t3 <- A[j]
		slli s6, s5, 2
		add s6, s6, a0
		lb s6, (s6)
		
		# jump to the end of the if statement if A[j] > pivot
		bgt s6, s3, end_partition_if
		
		# i <- i + 1
		addi s4, s4, 1
		
		# swap A[i] with A[j];
		mv a0, s0
		mv a1, s4
		mv a2, s5
		jal swap
		
		end_partition_if:
			#  increament j
			addi s5, s5, 1
			
			# back to the start of the loop if j < high
			blt s5, s2, partition_loop
		
	end_partition_loop:
		# i += 1
		addi s4, s4, 1

		# swap A[i+1] with A[high]
		mv a0, s0
		mv a1, s4
		mv a2, s2
		jal swap
				
		# save i into a0
		mv a0, s4
		
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
