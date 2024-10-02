.data
msg1:	.asciiz "Enter a number: "
msg2:	.asciiz " is a prime."
msg3:	.asciiz " is not a prime, the nearest prime is"
msg4:	.asciiz " "

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
  		move    $t0, $a1
  		
# print the result of procedure factorial on the console interface
		move $a0, $t0			
		li $v0, 1		# call system call: print integer
		syscall 			# run the s

# jump to procedure factorial
		move $a2, $a1
		move $a3, $a1
  		jal prime
  		
  		beq $v1, $zero, continue
# print msg1 on the console interface
		li      $v0, 4				# call system call: print string
		la      $a0, msg2			# load address of string into $a0
		syscall                 	# run the syscall
		
  		li $v0, 10					# call system call: exit
  		syscall						# run the syscall
		
continue:	li      $v0, 4				# call system call: print string
		la      $a0, msg3			# load address of string into $a0
		syscall                 	# run the syscall
find_near_prime:	addi $a1, $a2, 1
		addi $a2, $a2, 1
		jal prime
		move $s5, $v1
		
		addi $a1, $a3, -1
		addi $a3, $a3, -1
		jal prime
		move $s6, $v1
		
		bne $s6, $s5, outputone
		bne $s5, $zero, output
		j find_near_prime
output:		li      $v0, 4				# call system call: print string
		la      $a0, msg4			# load address of string into $a0
		syscall                 	# run the syscal
		move $a0, $a3			
		li $v0, 1		# call system call: print integer
		syscall 			# run the s
		li      $v0, 4				# call system call: print string
		la      $a0, msg4			# load address of string into $a0
		syscall                 	# run the syscal
		move $a0, $a2			
		li $v0, 1		# call system call: print integer
		syscall 			# run the s
		li $v0, 10					# call system call: exit
  		syscall	
outputone:	beq $s5, $zero, s6
		li      $v0, 4				# call system call: print string
		la      $a0, msg4			# load address of string into $a0
		syscall                 	# run the syscal
		move $a0, $a2			
		li $v0, 1		# call system call: print integer
		syscall 			# run the s
		li $v0, 10					# call system call: exit
  		syscall	
s6:		li      $v0, 4				# call system call: print string
		la      $a0, msg4			# load address of string into $a0
		syscall                 	# run the syscal
		move $a0, $a3			
		li $v0, 1		# call system call: print integer
		syscall 			# run the s
		li $v0, 10					# call system call: exit
  		syscall	

#------------------------- procedure factorial -----------------------------
# load argument n in a0, return value in v0. 
.text
prime:		addi $sp, $sp, -4
		sw $ra, 0($sp)
		beq $a1, 1, return0		# check if input is 1
		addi $t1, $zero, 2		# i = 2
for:		mul $t8, $t1, $t1		# count i * i
		slt $t9, $a1, $t8		# if i * i > n, t9 = 1
		bne $t9, $zero, return1		# when different, go to return0
		move $t2, $a1			# set tmp = n
getremain:	slt $t9, $t2, $t1
		bne $t9, $zero, check
		sub $t2, $t2, $t1
		j getremain
check:		beq $t2, $zero, return0
		addi $t1, $t1, 1
		j for
		
return0:		add $v1, $zero, $zero
		jr $ra
return1:		addi $v1, $zero, 1
		jr $ra		
