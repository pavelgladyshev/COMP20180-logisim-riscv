# COMP-logisim-riscv

RISC-V CPU Hardware models in Logisim-Evolution along with sample code projects. Originally designed as teaching aids for UCD's COMP 20180 module "Intro to Operating Systems"

* circuits folder contains Logisim-Evolution circuit files for different RISC-V models
* demo-projects folder contains sample programs written in C and Assembly that can be compiled and loaded into ROM chip of the models

To compile sample projects use a recent Ubuntu Linux (22.04 at the time of writing),
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