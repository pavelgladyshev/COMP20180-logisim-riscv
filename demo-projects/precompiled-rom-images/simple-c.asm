
simple-c:     file format elf32-littleriscv


Disassembly of section .init:

00400000 <_start>:

    .extern __stack_init      # address of the initial top of C call stack (calculated externally by linker)

	.globl _start
_start:                       # this is where CPU starts executing instructions after reset / power-on
	la sp,__stack_init        # initialise stack pointer (with the value that points to the last word of RAM)
  400000:	0fc10117          	auipc	sp,0xfc10
  400004:	ffc10113          	addi	sp,sp,-4 # 1000fffc <__stack_init>
	li a0,0                   # populate optional main() parameters with dummy values (just in case)
  400008:	00000513          	li	a0,0
	li a1,0
  40000c:	00000593          	li	a1,0
	li a2,0
  400010:	00000613          	li	a2,0
	jal main                  # call C main() function
  400014:	028000ef          	jal	ra,40003c <main>

00400018 <exit>:
exit:
	j exit                    # keep looping forever after main() returns
  400018:	0000006f          	j	400018 <exit>

Disassembly of section .text:

0040001c <printstr>:
    
    TDR = (volatile int *)0xffff000c;  // set TDR pointer to the address of the memory-mapped Transmitter Data Register
                                       // the (volatile int *)0xffff000c expession "casts" 0xffff000c as the value for the pointer 
                                       // (i.e. as memory address)  
    
    while (*ptr != '\0')  // keep printing characters until we reach NUL character ('\0') at the end of the string
  40001c:	00054783          	lbu	a5,0(a0)
  400020:	00078c63          	beqz	a5,400038 <printstr+0x1c>
    {
        *TDR = *ptr;      // get next char (pointed to by *ptr) from the string and write it to the memory location pointed to by TDR
  400024:	ffff0737          	lui	a4,0xffff0
  400028:	00f72623          	sw	a5,12(a4) # ffff000c <__stack_init+0xeffe0010>
     
        ptr = ptr+1;      // advance ptr forward in memory by the size of 1 char (i.e. increase its value by 1).
  40002c:	00150513          	addi	a0,a0,1
    while (*ptr != '\0')  // keep printing characters until we reach NUL character ('\0') at the end of the string
  400030:	00054783          	lbu	a5,0(a0)
  400034:	fe079ae3          	bnez	a5,400028 <printstr+0xc>
    }                                               
}
  400038:	00008067          	ret

0040003c <main>:
    

int main()
{
  40003c:	ff010113          	addi	sp,sp,-16
  400040:	00112623          	sw	ra,12(sp)
    printstr("Hello World!\n");
  400044:	00400537          	lui	a0,0x400
  400048:	06050513          	addi	a0,a0,96 # 400060 <main+0x24>
  40004c:	fd1ff0ef          	jal	ra,40001c <printstr>
}
  400050:	00000513          	li	a0,0
  400054:	00c12083          	lw	ra,12(sp)
  400058:	01010113          	addi	sp,sp,16
  40005c:	00008067          	ret
