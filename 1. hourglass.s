.data
msg1:	.asciiz "enter a number: "
msg2:	.asciiz "*"
msg3:	.asciiz " "
msg4:	.asciiz "\n"

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

# jump to procedure factorial
  		jal star
  		
  		li $v0, 10					# call system call: exit
  		syscall						# run the syscall
		


#------------------------- procedure factorial -----------------------------
# load argument n in a0, return value in v0. 
.text
star:		addi $sp, $sp, -4
		sw $ra, 0($sp)		
		addi $t2, $a1, 1		# t2 = a1 + 1 (temp)
		srl $t2, $t2, 1		# t2 = t2 / 2
		srl $t7, $a1, 1		# t7 = a1 / 2
		beq $t2, $t7, nosub	# if t2 == t7 (a1 is even)
		addi $t2, $t2, -1	# t2 = t2 - 1 
nosub:		add $t0, $zero, $zero	# j for for2_1
		add $t1, $zero, $zero	# i for for1
		add $t3, $zero, $zero	# j for for2_2
for1:		slt $t9, $t1, $t2	# if i < 0, go to reverse part 
		beq $t9, $zero, reverse
		add $t0, $zero, $zero	# reset j for for2_1
		add $t3, $zero, $zero	# reset j for for2_2
for2_1:		slt $t9, $t0, $t1	# j < i
		beq $t9, $zero, count	# if false, go to exit1
		li      $v0, 4		# call system call: print string
		la      $a0, msg3
		syscall
		addi $t0, $t0, 1		# j++
		j for2_1			# for2_1 loop end
count:		add $t6, $a1, $zero	# calculate the upper bound of for2_2
		sll $t4, $t1, 1		
		sub $t6, $t6, $t4
for2_2:		slt $t9, $t3, $t6	# j < n - i * 2
		beq $t9, $zero, exit1	
		li      $v0, 4		# call system call: print string
		la      $a0, msg2
		syscall
		addi $t3, $t3, 1
		j for2_2	
exit1:		addi $t1, $t1, 1
		li      $v0, 4		# call system call: print string
		la      $a0, msg4
		syscall
		j for1
		
reverse:		addi $t2, $a1, 1		# t2 = a1 + 1 (temp)
		srl $t2, $t2, 1		# t2 = t2 / 2	
		addi $t1, $t2, -1	# i = temp - 1
re_for1:		slt $t9, $t1, $zero	# if i < 0, go to reverse part 
		bne $t9, $zero, out
		add $t0, $zero, $zero	# reset j for for2_1
		add $t3, $zero, $zero	# reset j for for2_2
re_for2_1:	slt $t9, $t0, $t1	# j < i
		beq $t9, $zero, re_count	# if false, go to exit1
		li      $v0, 4		# call system call: print string
		la      $a0, msg3
		syscall
		addi $t0, $t0, 1		# j++
		j re_for2_1			# for2_1 loop end
re_count:	add $t6, $a1, $zero	# calculate the upper bound of for2_2
		sll $t4, $t1, 1		
		sub $t6, $t6, $t4
re_for2_2:	slt $t9, $t3, $t6	# j < n - i * 2
		beq $t9, $zero, exit2	
		li      $v0, 4		# call system call: print string
		la      $a0, msg2
		syscall
		addi $t3, $t3, 1
		j re_for2_2	
exit2:		addi $t1, $t1, -1
		li      $v0, 4		# call system call: print string
		la      $a0, msg4
		syscall
		j re_for1	

out:		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra
