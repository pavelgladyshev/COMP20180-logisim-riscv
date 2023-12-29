# Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
# licensed under Creative Commons Attribution International license 4.0

    .text

    # void showpic(int picture[32]) - displays 32x32 picture filling the entire graphcis display
    #
    # input: a0 = starting address of the array with picture data (32 words) 
    #
    # This is an example of a function written in assembly language.
    # According to the RISC-V function calling convention (ilp32), CPU registers t0-t6 and a0-a7
    # can be modified by the function and do not need to be saved on the stack
    # as long as this function is not calling other functions.
    
    .globl showpic
    
showpic:
    li t0,0xffff8000    # starting address of the graphics display
    li t1,32            # number of lines on the display (each word encodes one line) 
loop:
    lw t2,0(a0)         # load next line (word) of the picture data
    sw t2,0(t0)         # write it to the corresponding line of the graphics display
    addi t0,t0,4        # move to the next line of the graphics display
    addi a0,a0,4        # move to the next line of the picture data
    addi t1,t1,-1       # reduce the number of remaining lines
    bnez t1,loop        # keep going until all lines on the display are filled with data
    jr ra               # return 
    
