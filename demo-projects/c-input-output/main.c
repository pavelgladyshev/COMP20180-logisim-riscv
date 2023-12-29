/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This is an example of a C project split across multiple files.
 *
 * The main program is in main.c
 *
 * Utility functions for MMIO Display and Keypoard input-ouptut are contained in lib.c
 * and declared in lib.h
 *
 * This program shows simple console interaction that involves reading and printing
 * string and numbers from/to MMIO Display and Keyboard
 */

#include "lib.h"

int main()
{
    char name[20];   // space for the user's name
    int num;         // space for the user's student number (integer)
    
    printstr("RISC-V RV32IM Computer System\n\n");
 
    printstr("Type your name on MMIO Keyboard\n");
    
    readstr(name,sizeof(name));
    
    printstr("Hello, "); printstr(name); println();

    printstr("Type your student No\n");
    
    num = readint();
    
    printstr("You entered "); printint(num); println();

}
