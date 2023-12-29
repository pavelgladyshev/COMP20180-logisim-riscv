/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This example shows how graphics display data can be specified using integer array initialisers and binary constants.
 */

#pragma once

// number of pictures in the array it is good practice to surround the entire #define'd value with ( ) to avoid
// problems arithmetic with operation precedence when #define'd value is used in some arithmetic expression
#define PICTURES_TOTAL (2)  

// "extern" keyword declares picture array as defined in *some* .o file, not necessarily in the file where we use it.
// this way C compiler will not complain that pictures[] array is undefined, when we use it in the main program. 

extern int pictures[PICTURES_TOTAL][32];
