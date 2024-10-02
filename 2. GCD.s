.data
msg1:	.asciiz "Enter first number: "
msg2:	.asciiz "Enter second number: "
msg3:	.asciiz "\n"
msg4:	.asciiz "The GCD is: "

.text
.globl main
#------------------------- main -----------------------------
main:
# print msg1 on the console interface
		li      $v0, 4				# call system call: print string
		la      $a0, msg1			# load address of string into $a0
		syscall                 	# run the syscall
 
# read the input integer in $v0
 		li      $v0, 5          	# call system call: read integer
  		syscall                 	# run the syscall
  		move    $a1, $v0      	# store input in $a0 (set arugument of procedure factorial)

# print msg2 on the console interface
		li      $v0, 4				# call system call: print string
		la      $a0, msg2			# load address of string into $a0
		syscall                 	# run the syscall

# read the input integer in $v0
 		li      $v0, 5          	# call system call: read integer
  		syscall                 	# run the syscall
  		move    $a2, $v0      	# store input in $a0 (set arugument of procedure factorial)

# jump to procedure factorial
  		jal gcd
  		
# print msg1 on the console interface
		li      $v0, 4		# call system call: print string
		la      $a0, msg4	# load address of string into $a0
		syscall                 	# run the syscall

# print the result of procedure factorial on the console interface
		move $a0, $t0			
		li $v0, 1		# call system call: print integer
		syscall 			# run the syscall  		
  		
  		li $v0, 10		# call system call: exit
  		syscall			# run the syscall
		


#------------------------- procedure factorial -----------------------------
# load argument n in a0, return value in v0. 
.text

gcd:		slt $t9, $a1, $a2
		bne $t9, $zero, check
		sub $a1, $a1, $a2
		j gcd
check:		beq $a1, $zero, return
		move $t1, $a1
		move $a1, $a2
		move $a2, $t1
		j gcd
return:		move $t0, $a2
		jr $ra