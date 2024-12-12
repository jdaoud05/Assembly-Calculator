#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
	# Function prologue
	enter $0, $0

	# If the user does not input four arguments, jump to the arguments function
	cmp $4, %rdi
	jne arguments

  	# Variable mappings:
  	# op -> %r12
  	# arg1 -> %r13
  	# arg2 -> %r14
	movq 8(%rsi), %r12  # op = argv[1]
	movq 16(%rsi), %r13 # arg1 = argv[2]
	movq 24(%rsi), %r14 # arg2 = argv[3]
  
	
	movb 0(%r12), %bl # Setting the first argument to %bl register


	# Converts the second argument (%r13) to a long int
	movq %r13, %rdi 
        call atol
        movq %rax, %r13

	# Converts the third argument (%r14) to a long int
        movq %r14, %rdi
        call atol
        movq %rax, %r14
	

	# If the first argument is +, jump to the addition function
        cmp $'+', %bl
        je addition

	# If the first argument is -, jump to the subtraction function
        cmp $'-', %bl
        je subtraction

	# If the first argument is *, jump to the multiplication function
        cmp $'*', %bl
        je multiplication

	# If the first argument is /, jump to the division function
        cmp $'/', %bl
        je division

	# Jump to the error function if the first argument doesn't match with any of the above operands
	jmp error


addition:
	movq %r13, %rax 	# Moves %r13 to the %rax register
	addq %r14, %rax		# Adds the first argument (%r14) to the %rax register (arg1 + arg2)
	jmp done		# Jump to the done function to print the result

subtraction:
        movq %r13, %rax  	# Moves %r13 to the %rax register
        subq %r14, %rax	 	# Subtracts the first argument (%r14) to the %rax register (arg1 - arg2)	
	jmp done	 	# Jump to the done function to print the result

multiplication:
        movq %r13, %rax	 	# Moves %r13 to the %rax register
        imulq %r14, %rax 	# Multiplies the first argument (%r14) to the %rax register (arg1 * arg2)
	jmp done	 	# Jump to the done function to print the result

division:        

	# If the second argument is 0 (for division), jump to the divide_zero function
	cmp $0, %r14
	je divide_zero

	movq %r13, %rax		# Moves %r13 to the %rax register
        cqto			# Sign-extends the value in %rax into %rdx:%ra and prepares %rax and %rdx for a signed division operation
        idivq %r14		# Divides %r13 by %r14 (arg1 / arg2)
        jmp done		# Jump to the done function to print the result
	
error:

	# Print the "Unknown Operation" error
	movq %rax, %rsi			# Move the result into %rsi
	movq $invalid_operation, %rdi	# Move the format string into %rdi
	xor %rax, %rax			# Clear the %rax register
	call printf			# Call printf
	jmp end				# Jump to end function to finish the program

divide_zero:

	# Print the "Cannot divide by zero error"
	movq %rax, %rsi
	movq $zero_msg, %rdi
	xor %rax, %rax
	call printf
	jmp end

arguments:

	# Print the "Too many arguments" error
	movq %rax, %rsi
	movq $argument, %rdi
	xor %rax, %rax
	call printf
	jmp end

done:

	# Function that prints out the result
	movq %rax, %rsi 
	movq $format, %rdi
	xor %rax, %rax
	call printf

	movq $1, %rax # Returns 1


end:	
	# Function Epilogue
	leave
	ret
	


# Start of the data section
.data

format:
	.asciz "%ld\n"
invalid_operation:
	.asciz "Unknown Operation\n"
zero_msg:
	.asciz "Cannot divide by zero\n"
argument:
	.asciz "Too many arguments\n"
