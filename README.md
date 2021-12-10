# Tower of Hanoi (in MIPS!)

This repository contains a program that solves the [Tower of Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi) puzzle by use of recursion. It is implemented in MIPS assembly, based off of an original C version, designed to be run in the [MARS](https://courses.missouristate.edu/KenVollmar/MARS/) MIPS simulator.

This program is an exercise in stack management and recursion. While all modern languages (including C) make handling of the stack essentially transparent thanks to the compiler, writing in assembly forces the programmer to manually manage the stack when making recursive function calls.

One could say that an appreciation for modern languages is developed after having to write something as tedious as this. I think this is true. It is a valueable learning experience in how computers actually work at the hardware level.

## Building
1. Download [MARS](https://courses.missouristate.edu/KenVollmar/MARS/), and run it.
2. Open the `hanoi.asm` file by navigating to File -> Open
3. Assemble the program by navigating to Run -> Assemble, or pressing F3
4. Run the program by navigating to Run -> Go, or pressing F5

## Debugging
Additional debugging controls are visible under the Run menu. You can place breakpoints within MARS after assembling.
