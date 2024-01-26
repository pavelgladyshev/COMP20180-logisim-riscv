# COMP20180-logisim-riscv

RISC-V CPU Hardware models in Logisim-Evolution along with sample code projects. Originally designed as teaching aids for UCD's COMP 20180 module "Intro to Operating Systems"

- circuits folder contains Logisim-Evolution circuit files for different RISC-V models
- demo-projects folder contains sample programs written in C and Assembly that can be compiled and loaded into ROM chip of the models

## Logisim-Evolution circuits

To achieve the best speed of execution, it is advisable to use Logisim-Evolution version 3.9.4 with the optimisations made by Lorenzo Notaro:

https://github.com/lorenzonotaro/logisim-evolution/releases/tag/release

Circuit *risc_v_rv32im.circ* implements a 32-bit RISC-V core supporting the core integer instruction set with the multiplication and division extension. It uses exactly two clock cycles per instruction (one fetches the instruction, the other executes it).

Circuit *risc_v_rv32im_adv.circ* implements additional pipelining and caching to reduce the total number of cycles required to run the program:

- Pipelining combines execution of arithmetic and branching instructions with fetching the next instruction. As a result, many instructions are executed using just one clock cycle, because their fetching was performed alongside executing the previous instruction. 

- Memory access instructions cannot fetch the following instruction while executing, because there is only one memory bus. Instruction *cache* is a small memory that keeps instruction codes fetched *after* load/store instructions.  Caching helps avoid repetitive fetch cycles when the same load/store is performed again. (N.B. For the sake of simplicity, the cache in risc_v_rv32im_adv.circ is not invalidated by memory writes. This design works as long as the program is not modifying itself. A *proper* cache design should check for situations when memory write updates a cached memory location and then either invalidates or updates the affected cache entry).

Although Logisim simulation of the more complex risc_v_rv32im_adv.circ is slower than the simulation of risc_v_rv32im.circ, the pipelined design requires considerably fewer clock cycles to run the same code. The demo program included in the ROM of both circuits uses 2 clock cycles per instruction in risc_v_rv32im.circ, but only 1.18 clock cycles per instrcution on average in risc_v_rv32im_adv.circ.  Modern CPUs designs use multiple data paths and wide memory busses to fetch and start executing more than one instruction in a single clock cycle.

# Compiling software

To compile demo software projects in *demo-projects* folder use a recent Ubuntu Linux (22.04 at the time of writing) running in a virtual machine or on a stand-alone computer, having installed build-essential, binutils-riscv64-unknown-elf, and gcc-riscv64-unknown-elf packages:

$ sudo apt install build-essential 

$ sudo apt install binutils-riscv64-unknown-elf gcc-riscv64-unknown-elf

To build a project cd into the directory with the project code and run make.

$ cd simple-c

$ make clean

$ make

This should produce a .TXT file with raw binary code in hexadecimal, which can be loaded directly into Logisim-Evolution ROM components in the RISC-V models. An .ASM file is produced alongside the .TXT and shows the CPU instructions and their absolute memory addresses in human-readable mnemonic form.

# Compiling software for RISC-V simulated in qemu

Demo projects can also be compliled for a modified version of QEMU that has some of the RARS/Logisim peripherals added to it. This version of QEMU can be downloaded and build from github repository 

https://github.com/pavelgladyshev/COMP20180-qemu.git

Due to hardware differences, the address of MMIO Display's Transmitter Data Register (TDR) in QEMU is 0x10000000 instead of 0xffff000C in Logisim risc_v_rv32im.circ and RARS simulators. The address of MMIO Keyboard's Receiver Data Register (RDR) in QEMU is the same as TDR (0x10000000) instead of 0xffff0004 in Logisim risc_v_rv32im.circ and RARS simulators. Memory write to 0x10000000 writes to TDR, but memory read from 0x10000000 reads from RDR. Unlike Logisim/RARS models, the ready bits of MMIO Display and Keyboard in QEMU are in the same status register (0x10000005): bit 0 =1 indicates that the user pressed a key on the keyboard and the code can be read from RDR; bit 5 =1 indicates that MMIO Display is ready to receive the next ASCII code to print via TDR. 

To make source code work for both QEMU and Logisim/RARS models, portions of the C code that need to change are put inside #ifdef #else #endif macro definitions. Please see simple-c/main.c file for an example of how it is done (the block of code defining the address of TDR). For a more complete example study c-input-output/lib.c and c-input-output/lib.h files.

To build a project for QEMU, cd into the directory with the project code and run make as follows:

$ make clean

$ make qemu

The second command will compile the executable and automatically start qemu giving it the compiled executable to run.

To start debugging your code using gdb-multiarch and QEMU, run make with qemu-gdb target:

$ make qemu-gdb

This will launch QEMU and freeze it until you connect to localhost:1234 trom a different terminal window using gdb-multiarch.

Read Makefile for further detail on configuration and build process.

(C) Pavel Gladyshev, 2022-2024.
