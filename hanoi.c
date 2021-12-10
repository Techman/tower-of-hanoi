/* hanoi.c
 * Richard Ilson
 */
#include <stdio.h>

/*
	N is the number of disks to move
  src is the source from which the disks are coming
  aux is the temporary tower used to hold disks
  dst is the destination for the disks from src
*/
int hanoiMoves(int N, char src, char aux, char dst) {
	if (N == 1) {
		printf("Move from tower %c to tower %c\n", src, dst);
		return 1;
  	}
	int moves = 0; // Make sure you set this to 0 first in MIPS
	moves += hanoiMoves(N-1, src, dst, aux); // move N-1 disks from S to A
	moves += hanoiMoves(  1, src, aux, dst); // move   1 disk  from S to D
	moves += hanoiMoves(N-1, aux, src, dst); // move N-1 disks from A to D
	return moves;
}


int main() {
	int N;
	printf("How many disks: ");
	scanf("%d", &N);
	int cN = hanoiMoves(N, 'S', 'A', 'D');
	printf("Moves: %d\n", cN);
}
