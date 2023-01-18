.global _start

.data
var1: .byte 15
var2: .byte 19
newline: .ascii "\n"

.text
_start:
	# Print the address of var1
	li a7, 1
	la a0, var1
	ecall
	
	# New line
	jal print_newline
	
	# Print the addres of var2
	li a7, 1
	la a0, var2
	ecall
	
	# New line
	jal print_newline
	
	# Increase var1 by 1
	la t0, var1
	lb t1, (t0)
	addi t1, t1, 1
	
	# multiply var2 by 4
	la t0, var2
	lb t2, (t0)
	slli t2, t2, 2
	
	# print var1
	li a7, 1
	mv a0, t1
	ecall
	
	# New line
	jal print_newline
	
	# print var2
	li a7, 1
	mv a0, t2
	ecall
	
	# New line
	jal print_newline
	
	# store resulting addition to var2
	sb t1, var2, t0
	
	# store resulting multiplciation to var1
	sb t2, var1, t0
	
	
	# Print the value of var1
	li a7, 1
	lb a0, var1
	ecall
	
	# New line
	jal print_newline
	
	# Print the value of var2
	li a7, 1
	lb a0, var2
	ecall
	
	# Exit
	li a7, 10
	ecall
	
print_newline:
	li a7, 4
	la a0, newline
	ecall
	ret
