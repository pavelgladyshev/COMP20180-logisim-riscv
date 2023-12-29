
c-input-output:     file format elf32-littleriscv


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
  400014:	008000ef          	jal	ra,40001c <main>

00400018 <exit>:
exit:
	j exit                    # keep looping forever after main() returns
  400018:	0000006f          	j	400018 <exit>

Disassembly of section .text:

0040001c <main>:
 */

#include "lib.h"

int main()
{
  40001c:	fd010113          	addi	sp,sp,-48
  400020:	02112623          	sw	ra,44(sp)
  400024:	02812423          	sw	s0,40(sp)
    char name[20];   // space for the user's name
    int num;         // space for the user's student number (integer)
    
    printstr("RISC-V RV32IM Computer System\n\n");
  400028:	00400537          	lui	a0,0x400
  40002c:	23c50513          	addi	a0,a0,572 # 40023c <readint+0x64>
  400030:	0a0000ef          	jal	ra,4000d0 <printstr>
 
    printstr("Type your name on MMIO Keyboard\n");
  400034:	00400537          	lui	a0,0x400
  400038:	25c50513          	addi	a0,a0,604 # 40025c <readint+0x84>
  40003c:	094000ef          	jal	ra,4000d0 <printstr>
    
    readstr(name,sizeof(name));
  400040:	01400593          	li	a1,20
  400044:	00c10513          	addi	a0,sp,12
  400048:	13c000ef          	jal	ra,400184 <readstr>
    
    printstr("Hello, "); printstr(name); println();
  40004c:	00400537          	lui	a0,0x400
  400050:	28050513          	addi	a0,a0,640 # 400280 <readint+0xa8>
  400054:	07c000ef          	jal	ra,4000d0 <printstr>
  400058:	00c10513          	addi	a0,sp,12
  40005c:	074000ef          	jal	ra,4000d0 <printstr>
  400060:	060000ef          	jal	ra,4000c0 <println>

    printstr("Type your student No\n");
  400064:	00400537          	lui	a0,0x400
  400068:	28850513          	addi	a0,a0,648 # 400288 <readint+0xb0>
  40006c:	064000ef          	jal	ra,4000d0 <printstr>
    
    num = readint();
  400070:	168000ef          	jal	ra,4001d8 <readint>
  400074:	00050413          	mv	s0,a0
    
    printstr("You entered "); printint(num); println();
  400078:	00400537          	lui	a0,0x400
  40007c:	2a050513          	addi	a0,a0,672 # 4002a0 <readint+0xc8>
  400080:	050000ef          	jal	ra,4000d0 <printstr>
  400084:	00040513          	mv	a0,s0
  400088:	068000ef          	jal	ra,4000f0 <printint>
  40008c:	034000ef          	jal	ra,4000c0 <println>

}
  400090:	00000513          	li	a0,0
  400094:	02c12083          	lw	ra,44(sp)
  400098:	02812403          	lw	s0,40(sp)
  40009c:	03010113          	addi	sp,sp,48
  4000a0:	00008067          	ret

004000a4 <abs>:
 */

#include "lib.h"

// returns absolute value of its integer argument - a replacement of the standard library function abs() 
inline int abs(int n) { return (n < 0) ? (-n) : n; }
  4000a4:	41f55793          	srai	a5,a0,0x1f
  4000a8:	00a7c533          	xor	a0,a5,a0
  4000ac:	40f50533          	sub	a0,a0,a5
  4000b0:	00008067          	ret

004000b4 <printchar>:

// prints single character to console - a substitute for the standard library funciton putch(int chr)
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  4000b4:	ffff07b7          	lui	a5,0xffff0
  4000b8:	00a7a623          	sw	a0,12(a5) # ffff000c <__stack_init+0xeffe0010>
  4000bc:	00008067          	ret

004000c0 <println>:
  4000c0:	ffff07b7          	lui	a5,0xffff0
  4000c4:	00a00713          	li	a4,10
  4000c8:	00e7a623          	sw	a4,12(a5) # ffff000c <__stack_init+0xeffe0010>

// prints newline character to console
void println() { printchar('\n'); }
  4000cc:	00008067          	ret

004000d0 <printstr>:

// prints given string of characters to console - a substitute for the standard library function puts(char *s)
void printstr(char *str)
{
    while (*str != '\0') 
  4000d0:	00054783          	lbu	a5,0(a0)
  4000d4:	00078c63          	beqz	a5,4000ec <printstr+0x1c>
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  4000d8:	ffff0737          	lui	a4,0xffff0
  4000dc:	00f72623          	sw	a5,12(a4) # ffff000c <__stack_init+0xeffe0010>
    {
        printchar(*str);
        str += 1;
  4000e0:	00150513          	addi	a0,a0,1
    while (*str != '\0') 
  4000e4:	00054783          	lbu	a5,0(a0)
  4000e8:	fe079ae3          	bnez	a5,4000dc <printstr+0xc>
    }
}
  4000ec:	00008067          	ret

004000f0 <printint>:

// prints given integer as a signed decimal number
void printint(int n)
{
  4000f0:	ff010113          	addi	sp,sp,-16
    {
        sign = '-';
    }
    else
    {
        sign = '\0';
  4000f4:	41f55813          	srai	a6,a0,0x1f
  4000f8:	02d87813          	andi	a6,a6,45
  4000fc:	00410713          	addi	a4,sp,4
  400100:	00900613          	li	a2,9
    
    // produce decimal digits of the number going from right to left, keep them in num[] array.
    do 
    {
        i = i - 1;
        num[i] = abs(n % 10) + '0';
  400104:	00a00593          	li	a1,10
        i = i - 1;
  400108:	fff60613          	addi	a2,a2,-1
        num[i] = abs(n % 10) + '0';
  40010c:	02b567b3          	rem	a5,a0,a1
  400110:	41f7d693          	srai	a3,a5,0x1f
  400114:	00f6c7b3          	xor	a5,a3,a5
  400118:	40d787b3          	sub	a5,a5,a3
  40011c:	03078793          	addi	a5,a5,48
  400120:	00f70423          	sb	a5,8(a4)
        n = n / 10;
  400124:	02b54533          	div	a0,a0,a1
    } while (n != 0);
  400128:	fff70713          	addi	a4,a4,-1
  40012c:	fc051ee3          	bnez	a0,400108 <printint+0x18>
    
    //now print the sign of the number and its digits left-to-right.
    if (sign) 
  400130:	00080663          	beqz	a6,40013c <printint+0x4c>
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  400134:	ffff07b7          	lui	a5,0xffff0
  400138:	0107a623          	sw	a6,12(a5) # ffff000c <__stack_init+0xeffe0010>
    {
        printchar(sign);
    }
    
    while(i < MAX_INT_DIGITS)
  40013c:	00900793          	li	a5,9
  400140:	02c7c263          	blt	a5,a2,400164 <printint+0x74>
  400144:	00410793          	addi	a5,sp,4
  400148:	00c787b3          	add	a5,a5,a2
  40014c:	00e10693          	addi	a3,sp,14
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  400150:	ffff0637          	lui	a2,0xffff0
  400154:	0007c703          	lbu	a4,0(a5)
  400158:	00e62623          	sw	a4,12(a2) # ffff000c <__stack_init+0xeffe0010>
    while(i < MAX_INT_DIGITS)
  40015c:	00178793          	addi	a5,a5,1
  400160:	fed79ae3          	bne	a5,a3,400154 <printint+0x64>
    {
        printchar(num[i]);
        i=i+1;
    }
}
  400164:	01010113          	addi	sp,sp,16
  400168:	00008067          	ret

0040016c <pollkbd>:


// check if keyboard buffer has some data
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  40016c:	ffff07b7          	lui	a5,0xffff0
  400170:	0007a503          	lw	a0,0(a5) # ffff0000 <__stack_init+0xeffe0004>
  400174:	00008067          	ret

00400178 <readchar>:

// read next character from keyboard buffer
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  400178:	ffff07b7          	lui	a5,0xffff0
  40017c:	0047a503          	lw	a0,4(a5) # ffff0004 <__stack_init+0xeffe0008>
  400180:	00008067          	ret

00400184 <readstr>:

// read characters into provided buffer until either user presses enter or the buffer size is reached.
int readstr(char *buf, int size)
{
  400184:	00050693          	mv	a3,a0
    int count;
    
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  400188:	00100793          	li	a5,1
  40018c:	04b7d263          	bge	a5,a1,4001d0 <readstr+0x4c>
  400190:	fff58613          	addi	a2,a1,-1
    
    count = 0;
  400194:	00000513          	li	a0,0
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400198:	ffff0737          	lui	a4,0xffff0
       
       // read next character into the current element of the buffer
       *buf = (char)readchar();
       
       // if the user pressed Enter, stop reading
       if (*buf == '\n') 
  40019c:	00a00593          	li	a1,10
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  4001a0:	00072783          	lw	a5,0(a4) # ffff0000 <__stack_init+0xeffe0004>
       while (pollkbd() == 0) 
  4001a4:	fe078ee3          	beqz	a5,4001a0 <readstr+0x1c>
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  4001a8:	00472783          	lw	a5,4(a4)
       *buf = (char)readchar();
  4001ac:	0ff7f793          	andi	a5,a5,255
  4001b0:	00f68023          	sb	a5,0(a3)
       if (*buf == '\n') 
  4001b4:	00b78a63          	beq	a5,a1,4001c8 <readstr+0x44>
       {
           break;
       }
       
       // move pointer to the next element of the buffer
       buf += 1;
  4001b8:	00168693          	addi	a3,a3,1
       
       // increase the number of characters in the buffer
       count += 1;
  4001bc:	00150513          	addi	a0,a0,1
       
       // decrease the remaining space in the buffer
       size -= 1;
       
    } while(size > 1);  // keep going until one empty char remains (to hold the final '\0' character
  4001c0:	fec510e3          	bne	a0,a2,4001a0 <readstr+0x1c>
       count += 1;
  4001c4:	00060513          	mv	a0,a2
    
    *buf = '\0';  // add the end-of-string marker '\0'
  4001c8:	00068023          	sb	zero,0(a3)
    
    return count; // return the number of characters in the read string
  4001cc:	00008067          	ret
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  4001d0:	fff00513          	li	a0,-1
}
  4001d4:	00008067          	ret

004001d8 <readint>:

//read signed integer
int readint()
{
    int res = 0;
    int sign = 1;
  4001d8:	00100593          	li	a1,1
    int res = 0;
  4001dc:	00000513          	li	a0,0
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  4001e0:	ffff0737          	lui	a4,0xffff0
           sign = -1;
       }
       else
       {
           // otherwise, if a non-digit is read, it signifies the end of the number
           if (chr < '0' || chr > '9') 
  4001e4:	00900613          	li	a2,9
       if (res == 0 && sign == 1 && chr == '-') 
  4001e8:	00100813          	li	a6,1
  4001ec:	02d00893          	li	a7,45
           sign = -1;
  4001f0:	fff00313          	li	t1,-1
  4001f4:	0200006f          	j	400214 <readint+0x3c>
           if (chr < '0' || chr > '9') 
  4001f8:	fd068793          	addi	a5,a3,-48
  4001fc:	02f66c63          	bltu	a2,a5,400234 <readint+0x5c>
           {
               break;
           }
           // incorporate the read digit into the number (N.B. chr - '0' gived the digit value).
           res = res * 10 + (chr - '0');
  400200:	00251793          	slli	a5,a0,0x2
  400204:	00a787b3          	add	a5,a5,a0
  400208:	00179793          	slli	a5,a5,0x1
  40020c:	fd068693          	addi	a3,a3,-48
  400210:	00f68533          	add	a0,a3,a5
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400214:	00072783          	lw	a5,0(a4) # ffff0000 <__stack_init+0xeffe0004>
       while (pollkbd() == 0) 
  400218:	fe078ee3          	beqz	a5,400214 <readint+0x3c>
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  40021c:	00472683          	lw	a3,4(a4)
       if (res == 0 && sign == 1 && chr == '-') 
  400220:	fc051ce3          	bnez	a0,4001f8 <readint+0x20>
  400224:	fd059ae3          	bne	a1,a6,4001f8 <readint+0x20>
  400228:	fd1698e3          	bne	a3,a7,4001f8 <readint+0x20>
           sign = -1;
  40022c:	00030593          	mv	a1,t1
  400230:	fe5ff06f          	j	400214 <readint+0x3c>
       }
    }
    
    // return the absolute value of the number (constructed from entered digits) multiplied by the sign.
    return sign * res;
}
  400234:	02b50533          	mul	a0,a0,a1
  400238:	00008067          	ret
