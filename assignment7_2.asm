# Stanley Vossler -- 04/19/2022 (due date extended due to sickness)
# assignment7_2.asm - This program takes a float between 0 and 1 and approximates
#       it within the expanded log(1-x) Maclaurin series to the 9th term and returns
#       the value in $v0.

.data

	myFloat: .float .25
	i: .float 1.0
	zero: .float 0.0
	
.text
.globl main

# functions main -- written by Stanley Vossler -- 4/19/2022
#   initializes the parameters and calls the function applog
# Register use:
#   $f0     floating point register loaded from memory
#   $a0     argument that stores the float, passed to applog
#   $v0     syscall parameter

main:
		
	l.s $f0, myFloat
	mfc1 $a0, $f0
	jal applog
	
done:   li $v0, 10
	syscall
    
# function applog -- written by Stanley Vossler -- 4/19/2022
#   This programfunction that does all the math for the approximation.
#   It is passed in the integer to be approximated from main and then
#   goes a nested loop to find the approximated value. The main loop keeps
#   track of the current expression. The exponent loop keep tracks of how many
#   times the current element needs to multiply by itself.
# Register use:
#   $a0     argument passed from main
#   $f0     copy of .25
#   $f1     float incrementer 1.0
#   $f2     current expression
#   $f3     current power of .25
#   $f4     current subtrahend
#   $f5     copy of -.25
#   $f7     float 0.0
#   $f8     copy of 1.0 (does not change)
	
applog: 
	mtc1  $a0, $f0
	mtc1  $a0, $f2 
	mtc1  $a0, $f3 
	neg.s $f5, $f0 
 	l.s   $f1, i
 	l.s   $f8, i
	l.s   $f7, zero
	addi  $t0, $0, 0
	addi  $t1, $0, 0
	addi  $t2, $0, 1
	 
	LOOP:
		beq   $t0, 9, return
		
		exponent_loop:
			beq   $t1, $t2, L1
			mul.s $f3, $f3, $f0
			addi  $t1, $t1, 1
			j exponent_loop
			
		    L1: addi  $t2, $t2, 1
		    	addi  $t1, $0, 0
		    	add.s $f1, $f1, $f8
		    	#add.s $f2, $f0, $f7
		    	j divide
		    
	divide:  div.s $f4, $f3, $f1
		 beq   $t2, 2, L2
		 sub.s $f2, $f2, $f4
		 add.s $f3, $f7, $f0
		 addi  $t1, $0, 0
		 addi  $t0, $t0, 1
		 j LOOP
	     
	     L2: sub.s $f2, $f5, $f4
	     	 addi  $t0, $t0, 1
	     	 add.s  $f3, $f7, $f0
	     	 j LOOP
		
		return:
			mfc1 $v0, $f2
			jr $ra