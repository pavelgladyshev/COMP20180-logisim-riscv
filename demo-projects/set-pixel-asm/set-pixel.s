
    .text
    .globl _start 
    
_start:
    li a0, 5            # X
    li a1, 8            # Y
    li t0, 0xffff8000   # base address of display
    
    # calculate address of the correct word in display memory
    sll a1,a1,2         # Y=Y*4
    add t0,t0,a1        # t0 = base address of display + Y*4
    
    # prepare bitmask by shifting 1 into appropriate position
    li t1,1             # t1 = 00000000000000000000000000000001
    sll t1,t1,a0        # shift t1 to the left by X bits
    
    # apply bitmask to the word in display RAM
    lw t2, 0(t0)        # load word
    or t2,t2,t1         # apply mask with OR to set bit
    sw t2, 0(t0)        # write the result back to memory
loop:
    j loop               # loop forever

    
