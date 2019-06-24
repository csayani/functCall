#funct_call.asm
#by Chait Sayani
#a simple protocall that calls a function that calculates the nth fibbonacci number

.data
n: .word 6

.text
main:                      #the main function that loads our parameters and calls fib
      la $a0, n            #load address of n into $a0
      lw $a0, 0($a0)       #load n into $a0
      la $a1, fib          #load address of procedure into a1
      jal call             #jump and link call
      
      add $a0, $zero, $v0  #insert the sum of $v0 and $zero into $a0
      li $v0, 1            #print call
      syscall
      
      li $v0, 10           #call to exit
      syscall
       
call:                      #call function that creates a 4-word stack and stores the parameters and return address
      subu $sp, $sp, 16    #create 4 words for the stack
      sw $a0, 0($sp)       #store our parameter from $a0 into the first word
      sw $ra, 4($sp)       #store our return address into the second word
      jr $a1               #jump to our procedure
      
fib:                       #calculates the nth fibbonacci number
      slti $t1, $a0, 2     #if our parameter is less than 2, set $t1 == 1
      beqz $t1, help       #branch to help if $t1==0, meaning n > 1
      sw $t1, 12($sp)      #store 1 into the fourth word of the stack
      j return             #jump to return

help:                      #helper function for fib
      lw $t2, 0($sp)       #load our parameter from the stack into $t2
      subi $a0, $t2, 1     #store n-1 into $a0
      jal call             #call fib with an updated $a0
      sw $s4, 8($sp)       #store previous return value into the 3rd word in the stack
      
      lw $t3, 0($sp)       #load our parameter from the stack into $t3
      subi $a0, $t3, 2     #store n-2 into $a0
      jal call             #call fib with an updated $a0
      
      lw $s1, 8($sp)       #load our (n-2) return value from the stack into $s1
      addu $s2, $s1, $s4   #add $s4 and $s1 and store in $s2
      sw $s2, 12($sp)      #push our newly added fib(n-1) + fib(n-2) into the return value slot in the stack
      j return             #jump to return
   
return:                    #return function that wipes the stack and returns to the return addresss
      lw $s4, 12($sp)      #load our return value into $s4
      addu $v0, $zero, $s4 #transfer $s4 into $v0
      lw $t4, 4($sp)       #load the return address into $t4
      addi $sp, $sp, 16    #wipe the stack
      jr $t4               #jump to our return address stored in $t4
      
      
      