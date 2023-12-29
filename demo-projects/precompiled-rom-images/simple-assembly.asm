
simple-assembly:     file format elf32-littleriscv


Disassembly of section .text:

00400000 <start>:

    .text
    .globl start 
    
start:
    li t0, 0xffff0010    # load memory address of the right-most LED indicator into t0
  400000:	ffff02b7          	lui	t0,0xffff0
  400004:	01028293          	addi	t0,t0,16 # ffff0010 <loop+0xffbf0000>
    li t1, 0x06          # load bit-pattern corresponding to digit '1' into t1
  400008:	00600313          	li	t1,6
    sb t1, 0(t0)         # write the least significant byte from t1 into the LED MMIO register memory location (address in t0)
  40000c:	00628023          	sb	t1,0(t0)

00400010 <loop>:
loop:
    j loop               # loop forever
  400010:	0000006f          	j	400010 <loop>
