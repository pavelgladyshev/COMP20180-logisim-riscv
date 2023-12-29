
set-pixel-asm:     file format elf32-littleriscv


Disassembly of section .text:

00400000 <start>:

    .text
    .globl start 
    
start:
    li a0, 5            # X
  400000:	00500513          	li	a0,5
    li a1, 8            # Y
  400004:	00800593          	li	a1,8
    li t0, 0xffff8000   # base address of display
  400008:	ffff82b7          	lui	t0,0xffff8
    
    # calculate address of the correct word in display memory
    sll a1,a1,2         # Y=Y*4
  40000c:	00259593          	slli	a1,a1,0x2
    add t0,t0,a1        # t0 = base address of display + Y*4
  400010:	00b282b3          	add	t0,t0,a1
    
    # prepare bitmask by shifting 1 into appropriate position
    li t1,1             # t1 = 00000000000000000000000000000001
  400014:	00100313          	li	t1,1
    sll t1,t1,a0        # shift t1 to the left by X bits
  400018:	00a31333          	sll	t1,t1,a0
    
    # apply bitmask to the word in display RAM
    lw t2, 0(t0)        # load word
  40001c:	0002a383          	lw	t2,0(t0) # ffff8000 <loop+0xffbf7fd8>
    or t2,t2,t1         # apply mask with OR to set bit
  400020:	0063e3b3          	or	t2,t2,t1
    sw t2, 0(t0)        # write the result back to memory
  400024:	0072a023          	sw	t2,0(t0)

00400028 <loop>:
loop:
    j loop               # loop forever
  400028:	0000006f          	j	400028 <loop>
