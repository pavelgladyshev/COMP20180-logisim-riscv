# Example software running in Logisim RISC-V Computer System model by Pavel Gladyshev
# licensed under Creative Commons Attribution International license 4.0
#
# This is a rudimentary C run-time initialisation file (crt0.S) required for C programs to work 

	.section .init            # linker configuration file places .init section at the very start of ROM area before .text

    .extern __stack_init      # address of the initial top of C call stack (calculated externally by linker)

	.globl _start
_start:                       # this is where CPU starts executing instructions after reset / power-on
	la sp,__stack_init        # initialise stack pointer (with the value that points to the last word of RAM)
	li a0,0                   # populate optional main() parameters with dummy values (just in case)
	li a1,0
	li a2,0
	jal main                  # call C main() function
exit:
	j exit                    # keep looping forever after main() returns
