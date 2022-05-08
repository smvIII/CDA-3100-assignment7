# Stanley Vossler -- 04/19/2022 (due date extended due to sickness)
# assignment7_1.asm - This program takes an array of integers and finds
# 		the max order within that array. The order being m if
#		the integer falls between [2^m, 2^m+1). 

.data

	msg: .asciiz "The highest order in this array is " 
	A:   .word   90, 2, 93, 66, 8, 120, 121, 11, 33, 9

# function main -- written by Stanley Vossler -- 4/19/2022
#	initializaes the parameters $a0 and then calls findmaxorder
# Register use:
#	$a0	argument that stores starting address of A, passed to findmaxorder
#	$a1	argument that stores length of array A, also passed to findmaxorder
#	$v0	syscall parameter

.text
.globl main

main:
	#initialize parameters
	la $a0, A
	addi $a1, $0, 10
	jal findmaxorder
	
	done: 	li $v0, 10
		syscall

# function findmaxorder -- written by Stanley Vossler -- 4/19/2022
#	This function simply goes through the entire array and finds the
#	biggest element in the array. Once it does it sends that value to
#	getorder.
# Register use:
#	$a0	argument passed from main
#	$a1	argument passed from main
#	$t0	incrementer
#	$t1	current value of array
#	$t8	return address back to main
#	$t9	biggest element
		
findmaxorder:
	addi $t0, $0, 0 # incrementer
	lw $t9, A($zero)
	add $t8, $0, $ra
	
	LOOP1:
		beq $t0, $a1, next
		lw  $t1, ($a0) #current variable
		addi $a0, $a0, 4
		blt $t9, $t1, L1
		addi $t0, $t0, 1
		j LOOP1
		
	    L1: add $t9, $0, $t1
	    	addi $t0, $t0, 1
	    	j	LOOP1
		
		next: 	add $a0, $0, $t9
			jal getorder
			
# function getorder -- written by Stanley Vossler -- 4/19/2022
#	This function finds the order of the integer passed
#	from findmaxorder. It does so by repeatedly comparing
#	the integer's value to powers of 2, utilizing the sllv
#	instruction. Afterwards it prints out the value of the
#	highest order in the array.
# Register use:
#	$a0	parameter passed from findmaxorder,
#		also used as syscall parameter later
#	$v0	syscall parameter
#	$t3	power of 2
#	$t4	exponent of 2, or "m"
#	$t5	bool for loop
#	$t8	address to return back to main

getorder:
	
	addi $t3, $0, 1 #power of two, 
	addi $t4, $0, 0 #exponent or "m" where order will be stored
	addi $t5, $0, 0 #bool for loop
	
	
	LOOP2:
		beq  $t5, 1, print
		sllv $t3, $t3, $t4
		bge  $t3, $a0, L3
		
		addi $t4, $t4, 1
		addi $t3, $0, 1
		beq  $t5, $0, LOOP2
		
	L3: 	addi $t5, $0, 1
		sub  $t4, $t4, 1
	
	print:  li $v0, 4
		la $a0, msg
		syscall
		li $v0, 1
		add $a0, $0, $t4
		syscall
		jr $t8