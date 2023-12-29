
c-and-assembly:     file format elf32-littleriscv


Disassembly of section .init:

00400000 <_start>:
    .extern __stack_init      # address of the initial top of C call stack (calculated externally 
                              # by linker)

	.globl _start
_start:                       # this is where CPU starts executing instructions after reset / power-on
	la sp,__stack_init        # initialise sp (with the value that points to the last word of RAM)
  400000:	0fc10117          	auipc	sp,0xfc10
  400004:	ffc10113          	addi	sp,sp,-4 # 1000fffc <__stack_init>
	li a0,0                   # populate optional main() parameters with dummy values (just in case)
  400008:	00000513          	li	a0,0
	li a1,0
  40000c:	00000593          	li	a1,0
	li a2,0
  400010:	00000613          	li	a2,0
	jal main                  # call C main() function
  400014:	008000ef          	jal	ra,40001c <main>

00400018 <exit>:
exit:
	j exit                    # keep looping forever after main() returns
  400018:	0000006f          	j	400018 <exit>

Disassembly of section .text:

0040001c <main>:

#include "lib.h"
#include "pictures.h"

int main()
{
  40001c:	ff010113          	addi	sp,sp,-16
  400020:	00112623          	sw	ra,12(sp)
  400024:	00812423          	sw	s0,8(sp)
  400028:	00912223          	sw	s1,4(sp)
    int i;
    
    printstr("Displaying pictures...\n");
  40002c:	00400537          	lui	a0,0x400
  400030:	22450513          	addi	a0,a0,548 # 400224 <loop+0x1c>
  400034:	060000ef          	jal	ra,400094 <printstr>
    
    for( i=0 ;; i=(i+1) % PICTURES_TOTAL)   // Looping through the pictures forever
  400038:	00000413          	li	s0,0
    {
        showpic(pictures[i]);               // output next picture to the graphics display
  40003c:	004004b7          	lui	s1,0x400
  400040:	23c48493          	addi	s1,s1,572 # 40023c <pictures>
  400044:	00741513          	slli	a0,s0,0x7
  400048:	00a48533          	add	a0,s1,a0
  40004c:	1b4000ef          	jal	ra,400200 <showpic>
    for( i=0 ;; i=(i+1) % PICTURES_TOTAL)   // Looping through the pictures forever
  400050:	00140413          	addi	s0,s0,1
  400054:	01f45793          	srli	a5,s0,0x1f
  400058:	00f40433          	add	s0,s0,a5
  40005c:	00147413          	andi	s0,s0,1
  400060:	40f40433          	sub	s0,s0,a5
  400064:	fe1ff06f          	j	400044 <main+0x28>

00400068 <abs>:
 */

#include "lib.h"

// returns absolute value of its integer argument - a replacement of the standard library function abs() 
inline int abs(int n) { return (n < 0) ? (-n) : n; }
  400068:	41f55793          	srai	a5,a0,0x1f
  40006c:	00a7c533          	xor	a0,a5,a0
  400070:	40f50533          	sub	a0,a0,a5
  400074:	00008067          	ret

00400078 <printchar>:

// prints single character to console - a substitute for the standard library funciton putch(int chr)
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  400078:	ffff07b7          	lui	a5,0xffff0
  40007c:	00a7a623          	sw	a0,12(a5) # ffff000c <__stack_init+0xeffe0010>
  400080:	00008067          	ret

00400084 <println>:
  400084:	ffff07b7          	lui	a5,0xffff0
  400088:	00a00713          	li	a4,10
  40008c:	00e7a623          	sw	a4,12(a5) # ffff000c <__stack_init+0xeffe0010>

// prints newline character to console
void println() { printchar('\n'); }
  400090:	00008067          	ret

00400094 <printstr>:

// prints given string of characters to console - a substitute for the standard library function puts(char *s)
void printstr(char *str)
{
    while (*str != '\0') 
  400094:	00054783          	lbu	a5,0(a0)
  400098:	00078c63          	beqz	a5,4000b0 <printstr+0x1c>
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  40009c:	ffff0737          	lui	a4,0xffff0
  4000a0:	00f72623          	sw	a5,12(a4) # ffff000c <__stack_init+0xeffe0010>
    {
        printchar(*str);
        str += 1;
  4000a4:	00150513          	addi	a0,a0,1
    while (*str != '\0') 
  4000a8:	00054783          	lbu	a5,0(a0)
  4000ac:	fe079ae3          	bnez	a5,4000a0 <printstr+0xc>
    }
}
  4000b0:	00008067          	ret

004000b4 <printint>:

// prints given integer as a signed decimal number
void printint(int n)
{
  4000b4:	ff010113          	addi	sp,sp,-16
    {
        sign = '-';
    }
    else
    {
        sign = '\0';
  4000b8:	41f55813          	srai	a6,a0,0x1f
  4000bc:	02d87813          	andi	a6,a6,45
  4000c0:	00410713          	addi	a4,sp,4
  4000c4:	00900613          	li	a2,9
    
    // produce decimal digits of the number going from right to left, keep them in num[] array.
    do 
    {
        i = i - 1;
        num[i] = abs(n % 10) + '0';
  4000c8:	00a00593          	li	a1,10
        i = i - 1;
  4000cc:	fff60613          	addi	a2,a2,-1
        num[i] = abs(n % 10) + '0';
  4000d0:	02b567b3          	rem	a5,a0,a1
  4000d4:	41f7d693          	srai	a3,a5,0x1f
  4000d8:	00f6c7b3          	xor	a5,a3,a5
  4000dc:	40d787b3          	sub	a5,a5,a3
  4000e0:	03078793          	addi	a5,a5,48
  4000e4:	00f70423          	sb	a5,8(a4)
        n = n / 10;
  4000e8:	02b54533          	div	a0,a0,a1
    } while (n != 0);
  4000ec:	fff70713          	addi	a4,a4,-1
  4000f0:	fc051ee3          	bnez	a0,4000cc <printint+0x18>
    
    //now print the sign of the number and its digits left-to-right.
    if (sign) 
  4000f4:	00080663          	beqz	a6,400100 <printint+0x4c>
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  4000f8:	ffff07b7          	lui	a5,0xffff0
  4000fc:	0107a623          	sw	a6,12(a5) # ffff000c <__stack_init+0xeffe0010>
    {
        printchar(sign);
    }
    
    while(i < MAX_INT_DIGITS)
  400100:	00900793          	li	a5,9
  400104:	02c7c263          	blt	a5,a2,400128 <printint+0x74>
  400108:	00410793          	addi	a5,sp,4
  40010c:	00c787b3          	add	a5,a5,a2
  400110:	00e10693          	addi	a3,sp,14
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  400114:	ffff0637          	lui	a2,0xffff0
  400118:	0007c703          	lbu	a4,0(a5)
  40011c:	00e62623          	sw	a4,12(a2) # ffff000c <__stack_init+0xeffe0010>
    while(i < MAX_INT_DIGITS)
  400120:	00178793          	addi	a5,a5,1
  400124:	fed79ae3          	bne	a5,a3,400118 <printint+0x64>
    {
        printchar(num[i]);
        i=i+1;
    }
}
  400128:	01010113          	addi	sp,sp,16
  40012c:	00008067          	ret

00400130 <pollkbd>:


// check if keyboard buffer has some data
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400130:	ffff07b7          	lui	a5,0xffff0
  400134:	0007a503          	lw	a0,0(a5) # ffff0000 <__stack_init+0xeffe0004>
  400138:	00008067          	ret

0040013c <readchar>:

// read next character from keyboard buffer
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  40013c:	ffff07b7          	lui	a5,0xffff0
  400140:	0047a503          	lw	a0,4(a5) # ffff0004 <__stack_init+0xeffe0008>
  400144:	00008067          	ret

00400148 <readstr>:

// read characters into provided buffer until either user presses enter or the buffer size is reached.
int readstr(char *buf, int size)
{
  400148:	00050693          	mv	a3,a0
    int count;
    
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  40014c:	00100793          	li	a5,1
  400150:	04b7d263          	bge	a5,a1,400194 <readstr+0x4c>
  400154:	fff58613          	addi	a2,a1,-1
    
    count = 0;
  400158:	00000513          	li	a0,0
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  40015c:	ffff0737          	lui	a4,0xffff0
       
       // read next character into the current element of the buffer
       *buf = (char)readchar();
       
       // if the user pressed Enter, stop reading
       if (*buf == '\n') 
  400160:	00a00593          	li	a1,10
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400164:	00072783          	lw	a5,0(a4) # ffff0000 <__stack_init+0xeffe0004>
       while (pollkbd() == 0) 
  400168:	fe078ee3          	beqz	a5,400164 <readstr+0x1c>
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  40016c:	00472783          	lw	a5,4(a4)
       *buf = (char)readchar();
  400170:	0ff7f793          	andi	a5,a5,255
  400174:	00f68023          	sb	a5,0(a3)
       if (*buf == '\n') 
  400178:	00b78a63          	beq	a5,a1,40018c <readstr+0x44>
       {
           break;
       }
       
       // move pointer to the next element of the buffer
       buf += 1;
  40017c:	00168693          	addi	a3,a3,1
       
       // increase the number of characters in the buffer
       count += 1;
  400180:	00150513          	addi	a0,a0,1
       
       // decrease the remaining space in the buffer
       size -= 1;
       
    } while(size > 1);  // keep going until one empty char remains (to hold the final '\0' character
  400184:	fec510e3          	bne	a0,a2,400164 <readstr+0x1c>
       count += 1;
  400188:	00060513          	mv	a0,a2
    
    *buf = '\0';  // add the end-of-string marker '\0'
  40018c:	00068023          	sb	zero,0(a3)
    
    return count; // return the number of characters in the read string
  400190:	00008067          	ret
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  400194:	fff00513          	li	a0,-1
}
  400198:	00008067          	ret

0040019c <readint>:

//read signed integer
int readint()
{
    int res = 0;
    int sign = 1;
  40019c:	00100593          	li	a1,1
    int res = 0;
  4001a0:	00000513          	li	a0,0
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  4001a4:	ffff0737          	lui	a4,0xffff0
           sign = -1;
       }
       else
       {
           // otherwise, if a non-digit is read, it signifies the end of the number
           if (chr < '0' || chr > '9') 
  4001a8:	00900613          	li	a2,9
       if (res == 0 && sign == 1 && chr == '-') 
  4001ac:	00100813          	li	a6,1
  4001b0:	02d00893          	li	a7,45
           sign = -1;
  4001b4:	fff00313          	li	t1,-1
  4001b8:	0200006f          	j	4001d8 <readint+0x3c>
           if (chr < '0' || chr > '9') 
  4001bc:	fd068793          	addi	a5,a3,-48
  4001c0:	02f66c63          	bltu	a2,a5,4001f8 <readint+0x5c>
           {
               break;
           }
           // incorporate the read digit into the number (N.B. chr - '0' gived the digit value).
           res = res * 10 + (chr - '0');
  4001c4:	00251793          	slli	a5,a0,0x2
  4001c8:	00a787b3          	add	a5,a5,a0
  4001cc:	00179793          	slli	a5,a5,0x1
  4001d0:	fd068693          	addi	a3,a3,-48
  4001d4:	00f68533          	add	a0,a3,a5
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  4001d8:	00072783          	lw	a5,0(a4) # ffff0000 <__stack_init+0xeffe0004>
       while (pollkbd() == 0) 
  4001dc:	fe078ee3          	beqz	a5,4001d8 <readint+0x3c>
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  4001e0:	00472683          	lw	a3,4(a4)
       if (res == 0 && sign == 1 && chr == '-') 
  4001e4:	fc051ce3          	bnez	a0,4001bc <readint+0x20>
  4001e8:	fd059ae3          	bne	a1,a6,4001bc <readint+0x20>
  4001ec:	fd1698e3          	bne	a3,a7,4001bc <readint+0x20>
           sign = -1;
  4001f0:	00030593          	mv	a1,t1
  4001f4:	fe5ff06f          	j	4001d8 <readint+0x3c>
       }
    }
    
    // return the absolute value of the number (constructed from entered digits) multiplied by the sign.
    return sign * res;
}
  4001f8:	02b50533          	mul	a0,a0,a1
  4001fc:	00008067          	ret

00400200 <showpic>:
    # as long as this function is not calling other functions.
    
    .globl showpic
    
showpic:
    li t0,0xffff8000    # starting address of the graphics display
  400200:	ffff82b7          	lui	t0,0xffff8
    li t1,32            # number of lines on the display (each word encodes one line) 
  400204:	02000313          	li	t1,32

00400208 <loop>:
loop:
    lw t2,0(a0)         # load next line (word) of the picture data
  400208:	00052383          	lw	t2,0(a0)
    sw t2,0(t0)         # write it to the corresponding line of the graphics display
  40020c:	0072a023          	sw	t2,0(t0) # ffff8000 <__stack_init+0xeffe8004>
    addi t0,t0,4        # move to the next line of the graphics display
  400210:	00428293          	addi	t0,t0,4
    addi a0,a0,4        # move to the next line of the picture data
  400214:	00450513          	addi	a0,a0,4
    addi t1,t1,-1       # reduce the number of remaining lines
  400218:	fff30313          	addi	t1,t1,-1
    bnez t1,loop        # keep going until all lines on the display are filled with data
  40021c:	fe0316e3          	bnez	t1,400208 <loop>
    jr ra               # return 
  400220:	00008067          	ret
