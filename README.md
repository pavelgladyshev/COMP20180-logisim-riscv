# COMP-logisim-riscv

RISC-V CPU Hardware models in Logisim-Evolution along with sample code projects. Originally designed as teaching aids for UCD's COMP 20180 module "Intro to Operating Systems"

* circuits folder contains Logisim-Evolution circuit files for different RISC-V models
* demo-projects folder contains sample programs written in C and Assembly that can be compiled and loaded into ROM chip of the models

Circuit risc_v_rv32im.circ implements 32-bit RISC-V core using two clock cycles per instruction (one fetches the instruction, the other executes it)

Circuit risc_v_rv32im_adv.circ uses pipelining to combine execution of an arithmetic instruction with fetching the next instruction, it also uses caching of instructions fetched after branching or load/store to avoid additional fetch cycle when the same instruction is encountered again. As a result, some instructions are executed using just one clock cycle and a speedup of about 25% is achieved.

To compile demo software projects use a recent Ubuntu Linux (22.04 at the time of writing),
having installed build-essential, binutils-riscv64-unknown-elf, and gcc-riscv64-unknown-elf 
packages:

$ sudo apt install build-essential 
$ sudo apt install binutils-riscv64-unknown-elf gcc-riscv64-unknown-elf

To build a project cd into the directory and run make.

$ cd simple-c
$ make

This should produce a .TXT file with raw binary code in hexadecimal to be loaded into the RISC-V model ROM.

Read Makefile for further detail on configuration and build process.

(C) Pavel Gladyshev, 2022-2024.