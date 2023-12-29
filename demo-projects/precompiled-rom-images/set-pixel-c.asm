
set-pixel-c:     file format elf32-littleriscv


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
  400014:	054000ef          	jal	ra,400068 <main>

00400018 <exit>:
exit:
	j exit                    # keep looping forever after main() returns
  400018:	0000006f          	j	400018 <exit>

Disassembly of section .text:

0040001c <setpixel>:

void setpixel(int x, int y)
{
    volatile unsigned int *display = (volatile unsigned int *)0xffff8000;
    
    display[y] = display[y] | (0x1 << x);
  40001c:	00259713          	slli	a4,a1,0x2
  400020:	ffff85b7          	lui	a1,0xffff8
  400024:	00e585b3          	add	a1,a1,a4
  400028:	0005a703          	lw	a4,0(a1) # ffff8000 <__stack_init+0xeffe8004>
  40002c:	00100793          	li	a5,1
  400030:	00a797b3          	sll	a5,a5,a0
  400034:	00e7e7b3          	or	a5,a5,a4
  400038:	00f5a023          	sw	a5,0(a1)
}
  40003c:	00008067          	ret

00400040 <resetpixel>:
    
void resetpixel(int x, int y)
{
    volatile unsigned int *display = (volatile unsigned int *)0xffff8000;
    
    display[y] = display[y] & ( (0x1 << x) ^ 0xffffffff );
  400040:	00259713          	slli	a4,a1,0x2
  400044:	ffff85b7          	lui	a1,0xffff8
  400048:	00e585b3          	add	a1,a1,a4
  40004c:	0005a703          	lw	a4,0(a1) # ffff8000 <__stack_init+0xeffe8004>
  400050:	00100793          	li	a5,1
  400054:	00a797b3          	sll	a5,a5,a0
  400058:	fff7c793          	not	a5,a5
  40005c:	00e7f7b3          	and	a5,a5,a4
  400060:	00f5a023          	sw	a5,0(a1)
}
  400064:	00008067          	ret

00400068 <main>:
    display[y] = display[y] | (0x1 << x);
  400068:	ffff87b7          	lui	a5,0xffff8
  40006c:	0207a703          	lw	a4,32(a5) # ffff8020 <__stack_init+0xeffe8024>
  400070:	02076713          	ori	a4,a4,32
  400074:	02e7a023          	sw	a4,32(a5)
    display[y] = display[y] & ( (0x1 << x) ^ 0xffffffff );
  400078:	0207a703          	lw	a4,32(a5)
  40007c:	fdf77713          	andi	a4,a4,-33
  400080:	02e7a023          	sw	a4,32(a5)
    
int main()
{
    setpixel(5,8);
    resetpixel(5,8);
}
  400084:	00000513          	li	a0,0
  400088:	00008067          	ret
