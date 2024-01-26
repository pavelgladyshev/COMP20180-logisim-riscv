/*
 * Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
 * licensed under Creative Commons Attribution International license 4.0
 *
 * This is a very simple C program, which prints Hello World message to MMIO Display 
 */

void printstr(char *str)
{
    char *ptr;    // pointer to the next character in the string to be printed. I could 
                  // have used str pointer itself, but I use separate pointer variable
                  // for clarity
                  
    volatile int *TDR; // pointer to MMIO Display Transmitter Data Register. 
                       // volatile keyword informs C compiler that the value pointed to by TDR pointer
                       // could potentially change over time (e.g. as a result of hardware opreration)
                       // and its permanence should not be assumed for code optimisation purposes
 
    ptr = str;    // set pointer to the start of the string
    
#ifdef QEMU20180
    TDR = (volatile int *)0x10000000;  // Address of console transmitter in QEMU comp20180 machine.
#else
    TDR = (volatile int *)0xffff000c;  // set TDR pointer to the address of Logisim memory-mapped Transmitter Data Register
                                       // the (volatile int *)0xffff000c expession "casts" 0xffff000c as the value 
                                       // for the pointer (i.e. as memory address)  
#endif

    while (*ptr != '\0')  // keep printing characters until we reach NUL character ('\0') at the end of the string
    {
        *TDR = *ptr;      // get next char (pointed to by *ptr) from the string and write it to the memory location pointed to by TDR
     
        ptr = ptr+1;      // advance ptr forward in memory by the size of 1 char (i.e. increase its value by 1).
    }                                               
}
    

int main()
{
    printstr("Hello World!\n");
}
