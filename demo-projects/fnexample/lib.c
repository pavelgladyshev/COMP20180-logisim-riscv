/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This is a collection of utility functions for reading and writing strings and numbers
 * from/to MMIO Display and Keyboard 
 */

#include "lib.h"

// returns absolute value of its integer argument - a replacement of the standard library function abs() 
inline int abs(int n) { return (n < 0) ? (-n) : n; }

// prints single character to console - a substitute for the standard library funciton putch(int chr)
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)

// prints newline character to console
void println() { printchar('\n'); }

// prints given string of characters to console - a substitute for the standard library function puts(char *s)
void printstr(char *str)
{
    while (*str != '\0') 
    {
        printchar(*str);
        str += 1;
    }
}

// prints given integer as a signed decimal number
void printint(int n)
{

// a 32 bit integer has at most 10 digits  
#define MAX_INT_DIGITS (10)

    char num[MAX_INT_DIGITS];  
    int i;         // index of the next digit;
    char sign;     // sign of the number
    
    i = MAX_INT_DIGITS-1;  // i points to the last element of the array
    
    // if the number is negative, specify '-' as the sign.
    if (n<0) 
    {
        sign = '-';
    }
    else
    {
        sign = '\0';
    }
    
    // produce decimal digits of the number going from right to left, keep them in num[] array.
    do 
    {
        i = i - 1;
        num[i] = abs(n % 10) + '0';
        n = n / 10;
    } while (n != 0);
    
    //now print the sign of the number and its digits left-to-right.
    if (sign) 
    {
        printchar(sign);
    }
    
    while(i < MAX_INT_DIGITS)
    {
        printchar(num[i]);
        i=i+1;
    }
}


// check if keyboard buffer has some data
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 

// read next character from keyboard buffer
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 

// read characters into provided buffer until either user presses enter or the buffer size is reached.
int readstr(char *buf, int size)
{
    int count;
    
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
    
    count = 0;
    do
    {
       // wait until user presses some key
       while (pollkbd() == 0) 
       {
       }
       
       // read next character into the current element of the buffer
       *buf = (char)readchar();
       
       // if the user pressed Enter, stop reading
       if (*buf == '\n') 
       {
           break;
       }
       
       // move pointer to the next element of the buffer
       buf += 1;
       
       // increase the number of characters in the buffer
       count += 1;
       
       // decrease the remaining space in the buffer
       size -= 1;
       
    } while(size > 1);  // keep going until one empty char remains (to hold the final '\0' character
    
    *buf = '\0';  // add the end-of-string marker '\0'
    
    return count; // return the number of characters in the read string
}

//read signed integer
int readint()
{
    int res = 0;
    int sign = 1;
    int chr;
    
    for(;;)
    {
       // wait until user presses some key
       while (pollkbd() == 0) 
       {
       }
       
       // read character
       chr = readchar();
       
       // if no digits have yet been read, '-' is interpreted as a negative sign
       if (res == 0 && sign == 1 && chr == '-') 
       {
           sign = -1;
       }
       else
       {
           // otherwise, if a non-digit is read, it signifies the end of the number
           if (chr < '0' || chr > '9') 
           {
               break;
           }
           // incorporate the read digit into the number (N.B. chr - '0' gived the digit value).
           res = res * 10 + (chr - '0');
       }
    }
    
    // return the absolute value of the number (constructed from entered digits) multiplied by the sign.
    return sign * res;
}
    
    
    
    
    
    
       
