.global _start

.macro print_newline
	# Print new line
	li a7, 4
	la a0, newline
	ecall
.end_macro

.macro println(%val)
	# Print the value 
	li a7, 1
	lb a0, %val
	ecall
	
	print_newline
.end_macro

.macro printAln(%val)
	# Print the Address of val
	li a7, 1
	la a0, %val
	ecall
	
	# New line
	print_newline
.end_macro

#########################################
#	1: define variables
#########################################
.data
var1: .byte 15
var2: .byte 19
newline: .ascii "\n"

.text
_start:
#########################################
#	2: print addresses of variables
#########################################
	# Print the address of var1
	printAln var1
	
	# Print the addres of var2
	printAln var2
	
#########################################
#	3: Change the value of var1 and var2
#########################################
	# Increase var1 by 1
	la t0, var1
	lb t1, (t0)
	addi t1, t1, 1
	
	# multiply var2 by 4
	la t0, var2
	lb t2, (t0)
	slli t2, t2, 2
	
	# store resulting addition back to var1
	sb t1, var1, t0
	
	# store resulting multiplciation back to var2
	sb t2, var2, t0
	
#########################################
#	4: print var1 and var2
#########################################
	jal print_vars
	
#########################################
#	5: Swap and print
#########################################
	# store resulting addition to var2
	sb t1, var2, t0
	
	# store resulting multiplciation to var1
	sb t2, var1, t0
	
	jal print_vars
	
	# Exit
	li a7, 10
	ecall
	
print_vars:
	# Print the value of var1
	println var1
	
	# Print the value of var2
	println var2
	
	ret
