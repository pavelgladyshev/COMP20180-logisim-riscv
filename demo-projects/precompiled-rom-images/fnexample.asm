
fnexample:     file format elf32-littleriscv


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
  400014:	038000ef          	jal	ra,40004c <main>

00400018 <exit>:
exit:
	j exit                    # keep looping forever after main() returns
  400018:	0000006f          	j	400018 <exit>

Disassembly of section .text:

0040001c <square>:
#include "lib.h"

int square(int y)
{
  40001c:	fe010113          	addi	sp,sp,-32
  400020:	00812e23          	sw	s0,28(sp)
  400024:	02010413          	addi	s0,sp,32
  400028:	fea42623          	sw	a0,-20(s0)
    y = y*y;
  40002c:	fec42783          	lw	a5,-20(s0)
  400030:	02f787b3          	mul	a5,a5,a5
  400034:	fef42623          	sw	a5,-20(s0)
    return y;
  400038:	fec42783          	lw	a5,-20(s0)
}
  40003c:	00078513          	mv	a0,a5
  400040:	01c12403          	lw	s0,28(sp)
  400044:	02010113          	addi	sp,sp,32
  400048:	00008067          	ret

0040004c <main>:

int main()
{
  40004c:	fe010113          	addi	sp,sp,-32
  400050:	00112e23          	sw	ra,28(sp)
  400054:	00812c23          	sw	s0,24(sp)
  400058:	02010413          	addi	s0,sp,32
    int x=3;
  40005c:	00300793          	li	a5,3
  400060:	fef42623          	sw	a5,-20(s0)
    printint(square(x));
  400064:	fec42503          	lw	a0,-20(s0)
  400068:	fb5ff0ef          	jal	ra,40001c <square>
  40006c:	00050793          	mv	a5,a0
  400070:	00078513          	mv	a0,a5
  400074:	110000ef          	jal	ra,400184 <printint>
    printint(x);
  400078:	fec42503          	lw	a0,-20(s0)
  40007c:	108000ef          	jal	ra,400184 <printint>
    return 0;
  400080:	00000793          	li	a5,0
}
  400084:	00078513          	mv	a0,a5
  400088:	01c12083          	lw	ra,28(sp)
  40008c:	01812403          	lw	s0,24(sp)
  400090:	02010113          	addi	sp,sp,32
  400094:	00008067          	ret

00400098 <abs>:
 */

#include "lib.h"

// returns absolute value of its integer argument - a replacement of the standard library function abs() 
inline int abs(int n) { return (n < 0) ? (-n) : n; }
  400098:	fe010113          	addi	sp,sp,-32
  40009c:	00812e23          	sw	s0,28(sp)
  4000a0:	02010413          	addi	s0,sp,32
  4000a4:	fea42623          	sw	a0,-20(s0)
  4000a8:	fec42783          	lw	a5,-20(s0)
  4000ac:	41f7d713          	srai	a4,a5,0x1f
  4000b0:	fec42783          	lw	a5,-20(s0)
  4000b4:	00f747b3          	xor	a5,a4,a5
  4000b8:	40e787b3          	sub	a5,a5,a4
  4000bc:	00078513          	mv	a0,a5
  4000c0:	01c12403          	lw	s0,28(sp)
  4000c4:	02010113          	addi	sp,sp,32
  4000c8:	00008067          	ret

004000cc <printchar>:

// prints single character to console - a substitute for the standard library funciton putch(int chr)
inline void printchar(char chr) { *((volatile int *)0xffff000c) = chr; }  // write into TDR (don't forget to specify "volatile" !)
  4000cc:	fe010113          	addi	sp,sp,-32
  4000d0:	00812e23          	sw	s0,28(sp)
  4000d4:	02010413          	addi	s0,sp,32
  4000d8:	00050793          	mv	a5,a0
  4000dc:	fef407a3          	sb	a5,-17(s0)
  4000e0:	ffff07b7          	lui	a5,0xffff0
  4000e4:	00c78793          	addi	a5,a5,12 # ffff000c <__stack_init+0xeffe0010>
  4000e8:	fef44703          	lbu	a4,-17(s0)
  4000ec:	00e7a023          	sw	a4,0(a5)
  4000f0:	00000013          	nop
  4000f4:	01c12403          	lw	s0,28(sp)
  4000f8:	02010113          	addi	sp,sp,32
  4000fc:	00008067          	ret

00400100 <println>:

// prints newline character to console
void println() { printchar('\n'); }
  400100:	ff010113          	addi	sp,sp,-16
  400104:	00112623          	sw	ra,12(sp)
  400108:	00812423          	sw	s0,8(sp)
  40010c:	01010413          	addi	s0,sp,16
  400110:	00a00513          	li	a0,10
  400114:	fb9ff0ef          	jal	ra,4000cc <printchar>
  400118:	00000013          	nop
  40011c:	00c12083          	lw	ra,12(sp)
  400120:	00812403          	lw	s0,8(sp)
  400124:	01010113          	addi	sp,sp,16
  400128:	00008067          	ret

0040012c <printstr>:

// prints given string of characters to console - a substitute for the standard library function puts(char *s)
void printstr(char *str)
{
  40012c:	fe010113          	addi	sp,sp,-32
  400130:	00112e23          	sw	ra,28(sp)
  400134:	00812c23          	sw	s0,24(sp)
  400138:	02010413          	addi	s0,sp,32
  40013c:	fea42623          	sw	a0,-20(s0)
    while (*str != '\0') 
  400140:	0200006f          	j	400160 <printstr+0x34>
    {
        printchar(*str);
  400144:	fec42783          	lw	a5,-20(s0)
  400148:	0007c783          	lbu	a5,0(a5)
  40014c:	00078513          	mv	a0,a5
  400150:	f7dff0ef          	jal	ra,4000cc <printchar>
        str += 1;
  400154:	fec42783          	lw	a5,-20(s0)
  400158:	00178793          	addi	a5,a5,1
  40015c:	fef42623          	sw	a5,-20(s0)
    while (*str != '\0') 
  400160:	fec42783          	lw	a5,-20(s0)
  400164:	0007c783          	lbu	a5,0(a5)
  400168:	fc079ee3          	bnez	a5,400144 <printstr+0x18>
    }
}
  40016c:	00000013          	nop
  400170:	00000013          	nop
  400174:	01c12083          	lw	ra,28(sp)
  400178:	01812403          	lw	s0,24(sp)
  40017c:	02010113          	addi	sp,sp,32
  400180:	00008067          	ret

00400184 <printint>:

// prints given integer as a signed decimal number
void printint(int n)
{
  400184:	fd010113          	addi	sp,sp,-48
  400188:	02112623          	sw	ra,44(sp)
  40018c:	02812423          	sw	s0,40(sp)
  400190:	03010413          	addi	s0,sp,48
  400194:	fca42e23          	sw	a0,-36(s0)

    char num[MAX_INT_DIGITS];  
    int i;         // index of the next digit;
    char sign;     // sign of the number
    
    i = MAX_INT_DIGITS-1;  // i points to the last element of the array
  400198:	00900793          	li	a5,9
  40019c:	fef42623          	sw	a5,-20(s0)
    
    // if the number is negative, specify '-' as the sign.
    if (n<0) 
  4001a0:	fdc42783          	lw	a5,-36(s0)
  4001a4:	0007d863          	bgez	a5,4001b4 <printint+0x30>
    {
        sign = '-';
  4001a8:	02d00793          	li	a5,45
  4001ac:	fef405a3          	sb	a5,-21(s0)
  4001b0:	0080006f          	j	4001b8 <printint+0x34>
    }
    else
    {
        sign = '\0';
  4001b4:	fe0405a3          	sb	zero,-21(s0)
    }
    
    // produce decimal digits of the number going from right to left, keep them in num[] array.
    do 
    {
        i = i - 1;
  4001b8:	fec42783          	lw	a5,-20(s0)
  4001bc:	fff78793          	addi	a5,a5,-1
  4001c0:	fef42623          	sw	a5,-20(s0)
        num[i] = abs(n % 10) + '0';
  4001c4:	fdc42703          	lw	a4,-36(s0)
  4001c8:	00a00793          	li	a5,10
  4001cc:	02f767b3          	rem	a5,a4,a5
  4001d0:	41f7d713          	srai	a4,a5,0x1f
  4001d4:	00f747b3          	xor	a5,a4,a5
  4001d8:	40e787b3          	sub	a5,a5,a4
  4001dc:	0ff7f793          	andi	a5,a5,255
  4001e0:	03078793          	addi	a5,a5,48
  4001e4:	0ff7f713          	andi	a4,a5,255
  4001e8:	fec42783          	lw	a5,-20(s0)
  4001ec:	ff040693          	addi	a3,s0,-16
  4001f0:	00f687b3          	add	a5,a3,a5
  4001f4:	fee78823          	sb	a4,-16(a5)
        n = n / 10;
  4001f8:	fdc42703          	lw	a4,-36(s0)
  4001fc:	00a00793          	li	a5,10
  400200:	02f747b3          	div	a5,a4,a5
  400204:	fcf42e23          	sw	a5,-36(s0)
    } while (n != 0);
  400208:	fdc42783          	lw	a5,-36(s0)
  40020c:	fa0796e3          	bnez	a5,4001b8 <printint+0x34>
    
    //now print the sign of the number and its digits left-to-right.
    if (sign) 
  400210:	feb44783          	lbu	a5,-21(s0)
  400214:	02078c63          	beqz	a5,40024c <printint+0xc8>
    {
        printchar(sign);
  400218:	feb44783          	lbu	a5,-21(s0)
  40021c:	00078513          	mv	a0,a5
  400220:	eadff0ef          	jal	ra,4000cc <printchar>
    }
    
    while(i < MAX_INT_DIGITS)
  400224:	0280006f          	j	40024c <printint+0xc8>
    {
        printchar(num[i]);
  400228:	fec42783          	lw	a5,-20(s0)
  40022c:	ff040713          	addi	a4,s0,-16
  400230:	00f707b3          	add	a5,a4,a5
  400234:	ff07c783          	lbu	a5,-16(a5)
  400238:	00078513          	mv	a0,a5
  40023c:	e91ff0ef          	jal	ra,4000cc <printchar>
        i=i+1;
  400240:	fec42783          	lw	a5,-20(s0)
  400244:	00178793          	addi	a5,a5,1
  400248:	fef42623          	sw	a5,-20(s0)
    while(i < MAX_INT_DIGITS)
  40024c:	fec42703          	lw	a4,-20(s0)
  400250:	00900793          	li	a5,9
  400254:	fce7dae3          	bge	a5,a4,400228 <printint+0xa4>
    }
}
  400258:	00000013          	nop
  40025c:	00000013          	nop
  400260:	02c12083          	lw	ra,44(sp)
  400264:	02812403          	lw	s0,40(sp)
  400268:	03010113          	addi	sp,sp,48
  40026c:	00008067          	ret

00400270 <pollkbd>:


// check if keyboard buffer has some data
inline int pollkbd() { return *((volatile int *)0xffff0000); } // returns value of RCR  (don't forget to specify "volatile"!) 
  400270:	ff010113          	addi	sp,sp,-16
  400274:	00812623          	sw	s0,12(sp)
  400278:	01010413          	addi	s0,sp,16
  40027c:	ffff07b7          	lui	a5,0xffff0
  400280:	0007a783          	lw	a5,0(a5) # ffff0000 <__stack_init+0xeffe0004>
  400284:	00078513          	mv	a0,a5
  400288:	00c12403          	lw	s0,12(sp)
  40028c:	01010113          	addi	sp,sp,16
  400290:	00008067          	ret

00400294 <readchar>:

// read next character from keyboard buffer
inline int readchar() { return *((volatile int *)0xffff0004); } // returns value of RDR  (don't forget to specify "volatile"!) 
  400294:	ff010113          	addi	sp,sp,-16
  400298:	00812623          	sw	s0,12(sp)
  40029c:	01010413          	addi	s0,sp,16
  4002a0:	ffff07b7          	lui	a5,0xffff0
  4002a4:	00478793          	addi	a5,a5,4 # ffff0004 <__stack_init+0xeffe0008>
  4002a8:	0007a783          	lw	a5,0(a5)
  4002ac:	00078513          	mv	a0,a5
  4002b0:	00c12403          	lw	s0,12(sp)
  4002b4:	01010113          	addi	sp,sp,16
  4002b8:	00008067          	ret

004002bc <readstr>:

// read characters into provided buffer until either user presses enter or the buffer size is reached.
int readstr(char *buf, int size)
{
  4002bc:	fd010113          	addi	sp,sp,-48
  4002c0:	02112623          	sw	ra,44(sp)
  4002c4:	02812423          	sw	s0,40(sp)
  4002c8:	03010413          	addi	s0,sp,48
  4002cc:	fca42e23          	sw	a0,-36(s0)
  4002d0:	fcb42c23          	sw	a1,-40(s0)
    int count;
    
    if (size < 2) return -1; // needs at least 2 bytes in the buffer to read at least 1 character 
  4002d4:	fd842703          	lw	a4,-40(s0)
  4002d8:	00100793          	li	a5,1
  4002dc:	00e7c663          	blt	a5,a4,4002e8 <readstr+0x2c>
  4002e0:	fff00793          	li	a5,-1
  4002e4:	0800006f          	j	400364 <readstr+0xa8>
    
    count = 0;
  4002e8:	fe042623          	sw	zero,-20(s0)
    do
    {
       // wait until user presses some key
       while (pollkbd() == 0) 
  4002ec:	00000013          	nop
  4002f0:	f81ff0ef          	jal	ra,400270 <pollkbd>
  4002f4:	00050793          	mv	a5,a0
  4002f8:	fe078ce3          	beqz	a5,4002f0 <readstr+0x34>
       {
       }
       
       // read next character into the current element of the buffer
       *buf = (char)readchar();
  4002fc:	f99ff0ef          	jal	ra,400294 <readchar>
  400300:	00050793          	mv	a5,a0
  400304:	0ff7f713          	andi	a4,a5,255
  400308:	fdc42783          	lw	a5,-36(s0)
  40030c:	00e78023          	sb	a4,0(a5)
       
       // if the user pressed Enter, stop reading
       if (*buf == '\n') 
  400310:	fdc42783          	lw	a5,-36(s0)
  400314:	0007c703          	lbu	a4,0(a5)
  400318:	00a00793          	li	a5,10
  40031c:	02f70c63          	beq	a4,a5,400354 <readstr+0x98>
       {
           break;
       }
       
       // move pointer to the next element of the buffer
       buf += 1;
  400320:	fdc42783          	lw	a5,-36(s0)
  400324:	00178793          	addi	a5,a5,1
  400328:	fcf42e23          	sw	a5,-36(s0)
       
       // increase the number of characters in the buffer
       count += 1;
  40032c:	fec42783          	lw	a5,-20(s0)
  400330:	00178793          	addi	a5,a5,1
  400334:	fef42623          	sw	a5,-20(s0)
       
       // decrease the remaining space in the buffer
       size -= 1;
  400338:	fd842783          	lw	a5,-40(s0)
  40033c:	fff78793          	addi	a5,a5,-1
  400340:	fcf42c23          	sw	a5,-40(s0)
       
    } while(size > 1);  // keep going until one empty char remains (to hold the final '\0' character
  400344:	fd842703          	lw	a4,-40(s0)
  400348:	00100793          	li	a5,1
  40034c:	fae7c0e3          	blt	a5,a4,4002ec <readstr+0x30>
  400350:	0080006f          	j	400358 <readstr+0x9c>
           break;
  400354:	00000013          	nop
    
    *buf = '\0';  // add the end-of-string marker '\0'
  400358:	fdc42783          	lw	a5,-36(s0)
  40035c:	00078023          	sb	zero,0(a5)
    
    return count; // return the number of characters in the read string
  400360:	fec42783          	lw	a5,-20(s0)
}
  400364:	00078513          	mv	a0,a5
  400368:	02c12083          	lw	ra,44(sp)
  40036c:	02812403          	lw	s0,40(sp)
  400370:	03010113          	addi	sp,sp,48
  400374:	00008067          	ret

00400378 <readint>:

//read signed integer
int readint()
{
  400378:	fe010113          	addi	sp,sp,-32
  40037c:	00112e23          	sw	ra,28(sp)
  400380:	00812c23          	sw	s0,24(sp)
  400384:	02010413          	addi	s0,sp,32
    int res = 0;
  400388:	fe042623          	sw	zero,-20(s0)
    int sign = 1;
  40038c:	00100793          	li	a5,1
  400390:	fef42423          	sw	a5,-24(s0)
    int chr;
    
    for(;;)
    {
       // wait until user presses some key
       while (pollkbd() == 0) 
  400394:	00000013          	nop
  400398:	ed9ff0ef          	jal	ra,400270 <pollkbd>
  40039c:	00050793          	mv	a5,a0
  4003a0:	fe078ce3          	beqz	a5,400398 <readint+0x20>
       {
       }
       
       // read character
       chr = readchar();
  4003a4:	ef1ff0ef          	jal	ra,400294 <readchar>
  4003a8:	fea42223          	sw	a0,-28(s0)
       
       // if no digits have yet been read, '-' is interpreted as a negative sign
       if (res == 0 && sign == 1 && chr == '-') 
  4003ac:	fec42783          	lw	a5,-20(s0)
  4003b0:	02079463          	bnez	a5,4003d8 <readint+0x60>
  4003b4:	fe842703          	lw	a4,-24(s0)
  4003b8:	00100793          	li	a5,1
  4003bc:	00f71e63          	bne	a4,a5,4003d8 <readint+0x60>
  4003c0:	fe442703          	lw	a4,-28(s0)
  4003c4:	02d00793          	li	a5,45
  4003c8:	00f71863          	bne	a4,a5,4003d8 <readint+0x60>
       {
           sign = -1;
  4003cc:	fff00793          	li	a5,-1
  4003d0:	fef42423          	sw	a5,-24(s0)
  4003d4:	0440006f          	j	400418 <readint+0xa0>
       }
       else
       {
           // otherwise, if a non-digit is read, it signifies the end of the number
           if (chr < '0' || chr > '9') 
  4003d8:	fe442703          	lw	a4,-28(s0)
  4003dc:	02f00793          	li	a5,47
  4003e0:	02e7de63          	bge	a5,a4,40041c <readint+0xa4>
  4003e4:	fe442703          	lw	a4,-28(s0)
  4003e8:	03900793          	li	a5,57
  4003ec:	02e7c863          	blt	a5,a4,40041c <readint+0xa4>
           {
               break;
           }
           // incorporate the read digit into the number (N.B. chr - '0' gived the digit value).
           res = res * 10 + (chr - '0');
  4003f0:	fec42703          	lw	a4,-20(s0)
  4003f4:	00070793          	mv	a5,a4
  4003f8:	00279793          	slli	a5,a5,0x2
  4003fc:	00e787b3          	add	a5,a5,a4
  400400:	00179793          	slli	a5,a5,0x1
  400404:	00078713          	mv	a4,a5
  400408:	fe442783          	lw	a5,-28(s0)
  40040c:	fd078793          	addi	a5,a5,-48
  400410:	00f707b3          	add	a5,a4,a5
  400414:	fef42623          	sw	a5,-20(s0)
       while (pollkbd() == 0) 
  400418:	f7dff06f          	j	400394 <readint+0x1c>
       }
    }
    
    // return the absolute value of the number (constructed from entered digits) multiplied by the sign.
    return sign * res;
  40041c:	fe842703          	lw	a4,-24(s0)
  400420:	fec42783          	lw	a5,-20(s0)
  400424:	02f707b3          	mul	a5,a4,a5
}
  400428:	00078513          	mv	a0,a5
  40042c:	01c12083          	lw	ra,28(sp)
  400430:	01812403          	lw	s0,24(sp)
  400434:	02010113          	addi	sp,sp,32
  400438:	00008067          	ret
