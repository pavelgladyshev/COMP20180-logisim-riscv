/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This example shows how graphics display can be used to dsisplay pictures.
 * 
 * the showpic() function that fills graphics display with the given picture is 
 * written in assembly language (it is in the file showpic.s). 
 * It is declared at the end of lib.h
 * 
 * The picture data for two pictures is defined in pictures.c file,
 * the pictures[] array is declared in pictures.h header file.
 */

#include "lib.h"
#include "pictures.h"

int main()
{
    int i;
    
    printstr("Displaying pictures...\n");
    
    for( i=0 ;; i=(i+1) % PICTURES_TOTAL)   // Looping through the pictures forever
    {
        showpic(pictures[i]);               // output next picture to the graphics display
    }
    
}
