# Tower of Hanoi: MIPS assembly version
# Copyright (C) 2020 Michael Hazell <michaelhazell@hotmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

.text
.globl main

main:
	li $v0, 4 # Load "print string" syscall code
	la $a0, prompt_str # Load the prompt into arg0
	syscall # Print the prompt

	li $v0, 5 # Load "read integer" syscall code
	syscall
	slti $t0, $v0, 1 # Set if $v0 (the input) is less than 1
	bne $t0, $0, error # Branch to error if input was less than 1
	# Set up function call for hanoi(int N, char src, char aux, char dst)
	move $a0, $v0
	li $a1, 'S' # Assembler puts the proper hex for the characters in the register
	li $a2, 'A'
	li $a3, 'D'
	jal hanoi

	# Move return from hanoi and print
	move $s0, $v0
	li $v0, 4 # Load "print string" syscall code
	la $a0, moves_str
	syscall
	li $v0, 1 # Load "print integer" syscall code
	move $a0, $s0
	syscall
	li $v0, 11 # Load "print character" syscall code
	li $a0, '\n'
	syscall
	j done

hanoi: # hanoi(int N, char src, char aux, char dst)
	addi $sp, $sp, -24 # Reserve space on the stack
	# Store register state
	sw $a0, 20($sp)
	sw $a1, 16($sp)
	sw $a2, 12($sp)
	sw $a3, 8($sp)
	sw $ra, 4($sp)
	sw $s0, 0($sp) # Gonna store 'moves' in $s0
	li $t0, 1
	bne $a0, $t0, hanoi_else

	# Print the move and exit
	li $v0, 4 # Load "print string" syscall code
	la $a0, move0_str
	syscall
	li $v0, 11 # Load "print character" syscall code
	move $a0, $a1
	syscall
	li $v0, 4 # Load "print string" syscall code
	la $a0, move1_str
	syscall
	li $v0, 11 # Load "print character" syscall code
	move $a0, $a3
	syscall
	li $a0, '\n' # line feed (\n) character
	syscall

	# Restore register state
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	lw $a3, 8($sp)
	lw $a2, 12($sp)
	lw $a1, 16($sp)
	lw $a0, 20($sp)
	addi $sp, $sp, 24 # Free space in stack
	li $v0, 1 # Return 1
	jr $ra # $ra was never changed by this portion of the code

hanoi_else: # Covers everything after if (N==1) conditional
	# $s0 = moves
	li $s0, 0 # Set to 0
	# $a1 = src
	# $a2 = aux
	# $a3 = dst                                $a0  $a1  $a2  $a3
	# Move N-1 disks from S to A -> hanoiMoves(N-1, src, dst, aux)
	addi $a0, $a0, -1
	# $a0 remains the same since it is already src
	move $t0, $a2 # Store aux
	move $a2, $a3 # $a2 = dst
	move $a3, $t0 # $a3 = aux
	jal hanoi
	# Restore N
	addi $a0, $a0, 1 # N + 1
	# Add result of this function call to moves
	add $s0, $s0, $v0

	#                                          $a0  $a1  $a2  $a3
	# Move   1 disk  from S to D -> hanoiMoves(  1, src, aux, dst)
	# Store N
	add $t1, $0, $a0
	li $a0, 1
	# $a1 is still src at this point
	# $a2 is currently dst
	# $a3 is currently aux
	move $t0, $a2 # Store dst
	move $a2, $a3 # $a2 = aux
	move $a3, $t0 # $a3 = dst
	jal hanoi
	# Restore N
	add $a0, $0, $t1
	# Add result of this function call to moves
	add $s0, $s0, $v0

	#                                          $a0  $a1  $a2  $a3
	# move N-1 disks from A to D -> hanoiMoves(N-1, aux, src, dst)
	addi $a0, $a0, -1 # N-1
	# $a1 is still src
	# $a2 is currently aux
	# $a3 is currently dst
	move $t0, $a1 # Store src
	move $a1, $a2 # $a1 = aux
	move $a2, $t0 # $a2 = src
	jal hanoi
	# Restore N
	addi $a0, $a0, 1 # N+1
	# Add result of this function call to moves
	add $s0, $s0, $v0

	# Set the return value to be the updated moves count
	move $v0, $s0

	# Restore register state
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	lw $a3, 8($sp)
	lw $a2, 12($sp)
	lw $a1, 16($sp)
	lw $a0, 20($sp)
	addi $sp, $sp, 24 # Free space in stack
	jr $ra

done:
	li $v0, 10
	syscall

error:
	li $v0, 4 # Load "print string" syscall code
	la $a0, error_str
	syscall
	li $v0, 10 # Load "exit" syscall code
	syscall

.data
prompt_str:
	.asciiz "How many disks? "

error_str:
	.asciiz "An error has occurred. Is your integer greater than 0?"

moves_str:
	.asciiz "Moves: "

move0_str:
	.asciiz "Move from tower "

move1_str:
	.asciiz " to tower "
