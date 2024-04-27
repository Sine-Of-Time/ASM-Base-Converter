.data
testBinary: .asciiz "110" #It goes from MSB to LSB for some reason. AKA left -> right!

testHex: .asciiz "A2C" #It goes from MSB to LSB for some reason. AKA left -> right!

testDec: .asciiz "498" #It goes from MSB to LSB for some reason. AKA left -> right!

binaryASCIIarr: .word 48,49

decimalASCIIarr: .word 48,49,50,51,52,53,54,55,56,57

hexASCIIarr: .word 48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70

newLine: .asciiz "\n"

msg1: .asciiz "1.Binary to hexadecimal and decimal"

msg2: .asciiz "2.Hexadecimal to bianry and decimal"

msg3: .asciiz "3.Decimal to binary and hexadecimal"

msg4: .asciiz "4.Exit"

exitMsg: .asciiz "Exiting Program."

binValidMsg: .asciiz "Please enter a Binary string with only 1's and 0's"

decValidMsg: .asciiz "Please enter a decimal string with with characters from [0,9]"

hexValidMsg: .asciiz "Please enter a Hexadecimal string with  characters from [0,9] and [A,F]"

invalidStr: .asciiz "Your String Is Invalid \n"

yourNumDec: .asciiz "Your number in base 10 is "

yourNumHex: .asciiz "Your number in base 16 is "

yourNumBin: .asciiz "Your number in base 2 is "

userInput: .space 20

.text
main:

#All validate methods work 4/4/23
#Main must also be in a loop
li $t1,1
li $t2,2
li $t3,3

jal diplayMenu
move $t0,$v0
beq $t0,$t1,binaryInput
beq $t0,$t2,hexInput
beq $t0,$t3,decInput

binaryInput:
jal validateBinStr
move $a0,$v0
jal displayDecInAllBase
j main

hexInput:
jal validateHexStr
move $a0,$v0
jal displayDecInAllBase
j main

decInput:
jal validateDecStr
move $a0,$v0 
jal displayDecInAllBase
j main


li $v0,10
syscall
#a0 will be the binary string,a1 will be the string len
binaryToHexadecimal:#This is a MIP as of 4/3/23 because I want to see what LI says on 4/4/23
addi $sp,$sp, -24
sw $ra,0($sp)
sw $s0,4($sp)
sw $s1,8($sp)
sw $t0,12($sp)
sw $t6,16($sp)
sw $s3,20($sp)

li $s0,0 #This will be the nunber in hex
li $s1,0 #This will be the remainder after the div
li $t0,10 #This will be 10 which will be used for div
li $t6,16 #This will be 16 which will be used for div
li $s3,0 #This will be where base 10 is stored

jal binaryToDecimal
move $s3,$v0


whileLoopBinToHex:
beq $s3,$zero,exitLoopBinToHex#If the base 0 is zero then break
div $s3,$t6 #base10/16 to get rem
mfhi $s1 #Getting the remainder to pipe into $s1
slt $t2,$s1,$t0 #remainder($s1)<10($t0)
#beq $t2,$t1,remGreater #If the above is true, branch
add $s0,$s1,$s0 #Adding the remainder to the hex number


exitLoopBinToHex:

lw $s3,20($sp)
lw $t6,16($sp)
lw $t0,12($sp)
lw $s1,8($sp)
lw $s0,4($sp)
lw $ra,0($ra)
jr $ra


#a0 will be the binary string,a1 will be the string len
binaryToDecimal: #Works as of 4/3/23
addi $sp, $sp, -24  

sw $s0,0($sp)
sw $s1,4($sp)
sw $t0,8($sp)
sw $t1,12($sp) 
sw $t2,16($sp)
sw $t3,20($sp)


li $s0,0 #This will be base10
move $s1,$a1 #This will be the length
li $t0,0 #This will be i
li $t1,1 #For use with sll
li $t2,0
move $t3,$a1# This is the counter that is used to raise to a 2^n


loopBinToDec:
li $t2,0
lb $t1, 0($a0) # load the next character into t1
sub $t1,$t1,48
beq $s1,$t0,exitBinToDec
beqz $t1, zero # check for zero
#--#The char is 1 Start#--#
subi $t3,$t3,1 #Decrement the length
sllv $t2,$t1,$t3 #2^n
add  $s0,$s0,$t2 #adding 2^n
addi $a0, $a0,1 # increment the string pointer
addi $t0, $t0,1 # increment the count
j loopBinToDec# return to the top of the loop 
#--#The char is 1 End#--#
zero:
subi $t3,$t3,1 #Decrement the length
addi $a0, $a0,1 # increment the string pointer
addi $t0, $t0,1 # increment the count
j loopBinToDec# return to the top of the loop

exitBinToDec:
move $v0,$s0

lw $t3,20($sp)
lw $t2,16($sp)
lw $t1,12($sp)
lw $t0,8($sp)
lw $s1,4($sp)
lw $s0,0($sp)
jr $ra

strlen:
li $t0, 0 # initialize the count to zero
loop:
lb $t1, 0($a0) # load the next character into t1
beqz $t1, exit # check for the null character
addi $a0,$a0, 1 # increment the string pointer
addi $t0,$t0, 1 # increment the count
j loop # return to the top of the loop

exit:
move $v0,$t0
jr $ra


diplayMenu: 

li $t1,1
li $t2,2
li $t3,3


la $a0 msg1
li $v0,4
syscall

la $a0 newLine
li $v0,4
syscall

la $a0 msg2
li $v0,4
syscall

la $a0 newLine
li $v0,4
syscall

la $a0 msg3
li $v0,4
syscall

la $a0 newLine
li $v0,4
syscall

la $a0 msg4
li $v0,4
syscall

la $a0 newLine
li $v0,4
syscall

li $v0,5
syscall

move $t0,$v0

beq $t0,$t1,return
beq $t0,$t2,return
beq $t0,$t3,return

li $v0, 4
la $a0,exitMsg
syscall

li $v0,10#Exiting
syscall

return:
move $v0,$t0
jr $ra

#a0 will the str, a1 will be the length
validateBinStr:#Works 4/4/23
addi $sp,$sp,-36
sw $t0, 0($sp)
sw $t1,4($sp)
sw $t2,8($sp)
sw $t4,12($sp)
sw $t6,16($sp)
sw $t7,20($sp)
sw $s7,24($sp)
sw $s5,28($sp)
move $a2,$ra


resetValidateBinStr:

li $t1,0 #i
li $t2,0 #j
li $t0,0 #True/False
li $t4,3 #2
li $t3,1#Set to 1
li $s5,0 #This will be the sum
la $s7,binaryASCIIarr


la $a0,binValidMsg
li $v0,4
syscall

li $v0,8
la $a0,userInput 
li $a1,20
syscall

jal strlen
move $a1,$v0

la $a0,userInput#This should reset the pointer to the base


subi $a1,$a1,1#This will decrease the length by one so the newline does not get input
li $t0,0
startOfILoop:
beq $t1,$a1,exitBinValid
#-------
startofJLoop:
slt $t5,$t4,$t2#if (j<2)
beq $t5,$t3,secondHalfOfILoop
lb $t7,0($a0)#Loading bit from str
lb $t6,0($s7)#Loading bit from arr
beq $t7,$t6,changeT0
addi $s7,$s7,4#Incrementing arr
addi $t2,$t2,1#Incrementing j
#sub $t7, $t7,48 #Adjusting the nubmer
#add $s5,$s5,$t7 #Adding the char

li $t0,0#Setting back to 0 for t/f register
j startofJLoop
#-------
secondHalfOfILoop:
beq $t0,$zero,badInput
addi $t1,$t1,1#Incrementing i
addi $a0,$a0,1#Incrementing str
la $s7,binaryASCIIarr
li $t2,0
j startOfILoop


changeT0:
li $t0,1#Setting to true
j secondHalfOfILoop

badInput:
la $a0,invalidStr
li $v0,4
syscall
j resetValidateBinStr

exitBinValid:
la $a0,userInput

jal binaryToDecimal
move $ra,$a2

#lw $ra,32($sp)
lw $s5,28($sp)
lw $s7,24($sp)
lw $t7,20($sp)
lw $t6,16($sp)
lw $t4,12($sp)
lw $t2,8($sp)
lw $t1,4($sp)
lw $t0,0($sp)
jr $ra

#-----------------------------------------------------------------
#a0 will the str, a1 will be the length
#a0 will the str, a1 will be the length
validateHexStr:#Works 4/4/23
addi $sp,$sp,-36
sw $t0, 0($sp)
sw $t1,4($sp)
sw $t2,8($sp)
sw $t4,12($sp)
sw $t6,16($sp)
sw $t7,20($sp)
sw $s7,24($sp)
sw $s5,28($sp)
move $a2,$ra


resetValidateHexStr:

li $t1,0 #i
li $t2,0 #j
li $t0,0 #True/False
li $t4,17 #2
li $t3,1#Set to 1
li $s5,0 #This will be the sum
la $s7,hexASCIIarr


la $a0,hexValidMsg
li $v0,4
syscall

li $v0,8
la $a0,userInput 
li $a1,20
syscall

jal strlen
move $a1,$v0

la $a0,userInput#This should reset the pointer to the base


subi $a1,$a1,1#This will decrease the length by one so the newline does not get input
li $t0,0
startOfILoopHex:
beq $t1,$a1,exitHexValid
#-------
startofJLoopHex:
slt $t5,$t4,$t2#if (j<2)
beq $t5,$t3,secondHalfOfILoopHex
lb $t7,0($a0)#Loading bit from str
lb $t6,0($s7)#Loading bit from arr
beq $t7,$t6,changeT0Hex
addi $s7,$s7,4#Incrementing arr
addi $t2,$t2,1#Incrementing j
#sub $t7, $t7,48 #Adjusting the nubmer
#add $s5,$s5,$t7 #Adding the char

li $t0,0#Setting back to 0 for t/f register
j startofJLoopHex
#-------
secondHalfOfILoopHex:
beq $t0,$zero,badInputHex
li $t2,0
addi $t1,$t1,1#Incrementing i
addi $a0,$a0,1#Incrementing str
la $s7,hexASCIIarr
j startOfILoopHex


changeT0Hex:
li $t0,1#Setting to true
j secondHalfOfILoopHex

badInputHex:
la $a0,invalidStr
li $v0,4
syscall
j resetValidateHexStr

exitHexValid:
la $a0,userInput

jal hexToDecimal
move $ra,$a2

#lw $ra,32($sp)
lw $s5,28($sp)
lw $s7,24($sp)
lw $t7,20($sp)
lw $t6,16($sp)
lw $t4,12($sp)
lw $t2,8($sp)
lw $t1,4($sp)
lw $t0,0($sp)
jr $ra

#Have to transfrom this to deciaml check 4/6/23
#-----------------------------------------------------------------
#a0 will the str, a1 will be the length
validateDecStr:#Works 4/4/23
addi $sp,$sp,-36
sw $t0, 0($sp)
sw $t1,4($sp)
sw $t2,8($sp)
sw $t4,12($sp)
sw $t6,16($sp)
sw $t7,20($sp)
sw $s7,24($sp)
sw $s5,28($sp)
move $a2,$ra


resetValidateDecStr:

li $t1,0 #i
li $t2,0 #j
li $t0,0 #True/False
li $t4,17 #2
li $t3,1#Set to 1
li $s5,0 #This will be the sum
la $s7,decimalASCIIarr


la $a0,decValidMsg
li $v0,4
syscall

li $v0,8
la $a0,userInput 
li $a1,20
syscall

jal strlen
move $a1,$v0

la $a0,userInput#This should reset the pointer to the base


subi $a1,$a1,1#This will decrease the length by one so the newline does not get input
li $t0,0
startOfILoopDec:
beq $t1,$a1,exitDecValid
#-------
startofJLoopDec:
slt $t5,$t4,$t2#if (j<2)
beq $t5,$t3,secondHalfOfILoopDec
lb $t7,0($a0)#Loading bit from str
lb $t6,0($s7)#Loading bit from arr
beq $t7,$t6,changeT0Dec
addi $s7,$s7,4#Incrementing arr
addi $t2,$t2,1#Incrementing j
#sub $t7, $t7,48 #Adjusting the nubmer
#add $s5,$s5,$t7 #Adding the char

li $t0,0#Setting back to 0 for t/f register
j startofJLoopDec
#-------
secondHalfOfILoopDec:
beq $t0,$zero,badInputDec
li $t2,0
addi $t1,$t1,1#Incrementing i
addi $a0,$a0,1#Incrementing str
la $s7,decimalASCIIarr
j startOfILoopDec


changeT0Dec:
li $t0,1#Setting to true
j secondHalfOfILoopDec

badInputDec:
la $a0,invalidStr
li $v0,4
syscall
j resetValidateDecStr

exitDecValid:
la $a0,userInput

jal strToDecimal
move $ra,$a2



#lw $ra,32($sp)
lw $s5,28($sp)
lw $s7,24($sp)
lw $t7,20($sp)
lw $t6,16($sp)
lw $t4,12($sp)
lw $t2,8($sp)
lw $t1,4($sp)
lw $t0,0($sp)
jr $ra


#a0 will be the address of the string, a1 is length. Will only be feed valid hex strings!
hexToDecimal:#Works 4/6/23 BY ENSURING REGISTER WIPE AND PROTEC
addi $sp,$sp,-40
sw $s0,0($sp)
sw $s1,4($sp)
sw $t0,8($sp)
sw $t1,12($sp)
sw $t2,16($sp)
sw $t3,20($sp)
sw $t4,24($sp)
sw $t5,28($sp)
sw $t6,32($sp)
sw $t7,36($sp)

li $s0,0#Decimal value
li $s1,1#Base 
li $t0,0#i
li $t1,0 #Holder
li $t2,0
li $t3,0
li $t4,0
li $t5,0
li $t6,0
li $t7,0

move $t2,$a1
subi $t2,$t2,1 #This will be the n in 16 ^n
baseLoop:
beq $t3,$t2,doneBaseLoop
mul $s1,$s1,16
addi $t3,$t3,1
j baseLoop

doneBaseLoop:
li $t7,58
li $t4,47

hexToDecLoop:#Its got to be the max, like the largest basically, and then we get smaller
beq $t0,$a1,hexToDecExit
lb $t1,0($a0)
bge $t1,$t7,hexCharCheck
ble $t1,$t4,hexCharCheck #Above to lines ensure [0,9]
subi $t1,$t1,48
mul $t5,$t1,$s1 #So a register need to hold $s1 correct 
add $s0,$s0,$t5

div $s1,$s1,16
addi $a0,$a0,1
addi $t0,$t0,1
j hexToDecLoop

hexCharCheck:
subi $t1,$t1,55
mul $t5,$t1,$s1 #This is base * num
add $s0,$s0,$t5

div $s1,$s1,16
addi $a0,$a0,1
addi $t0,$t0,1
j hexToDecLoop


hexToDecExit:
move $v0,$s0

lw $t7,36($sp)
lw $t6,32($sp)
lw $t5,28($sp)
lw $t4,24($sp)
lw $t3,20($sp)
lw $t2,16($sp)
lw $t1,12($sp)
lw $t0,8($sp)
lw $s1,4($sp)
lw $s0,0($sp)
jr $ra
#a0 will be the address of the string, a1 is length. Will only be feed valid dec strings!
strToDecimal:
addi $sp,$sp,-36
sw $s0,0($sp)
sw $s1,4($sp)
sw $t0,8($sp)
sw $t1,12($sp)
sw $t2,16($sp)
sw $t3,20($sp)
sw $t4,24($sp)
sw $t5,28($sp)
sw $t7,32($sp)

li $t2,0
li $t3,0
li $t4,0
li $t5,0
li $t7,0
li $s0,0#Decimal value
li $s1,1#Base 
li $t0,0#i
li $t1,0 #Holder
move $t2,$a1
subi $t2,$t2,1 #This will be the n in 10 ^n
strBaseLoop:
beq $t3,$t2,strDoneBaseLoop
mul $s1,$s1,10
addi $t3,$t3,1
j strBaseLoop

strDoneBaseLoop:
li $t7,57
li $t4,48

StrToDecLoop:
beq $t0,$a1,StrToDecExit
lb $t1,0($a0)
subi $t1,$t1,48
mul $t5,$t1,$s1 #So a register need to hold $s1 correct 
add $s0,$s0,$t5

div $s1,$s1,10
addi $a0,$a0,1
addi $t0,$t0,1
j StrToDecLoop

StrToDecExit:
move $v0,$s0

lw $t7,32($sp)
lw $t5,28($sp)
lw $t4,24($sp)
lw $t3,20($sp)
lw $t2,16($sp)
lw $t1,12($sp)
lw $t0,8($sp)
lw $s1,4($sp)
lw $s0,0($sp)

jr $ra
#This is just used to take in a decimal and display in the other bases
#$a0 will be the base
displayDecInAllBase:

move $a2,$a0

la $a0,yourNumDec
li $v0,4
syscall

move $a0,$a2
li $v0,1
syscall
#move $a2,$a0 Might be redundant

la $a0,newLine
li $v0,4
syscall

la $a0,yourNumHex
li $v0,4
syscall

move $a0,$a2
li $v0,34
syscall
#move $a2,$a0 Might be redundant

la $a0,newLine
li $v0,4
syscall

la $a0,yourNumBin
li $v0,4
syscall

move $a0,$a2
li $v0,35
syscall
#move $a2,$a0 Might be redundant

la $a0,newLine
li $v0,4
syscall

jr $ra
