# Makefile for software running in Logisim RISC-V Computer System model by Pavel Gladyshev
# licensed under Creative Commons Attribution International license 4.0
#
# This Makefile is designed to be used in Ubuntu Linux. Make sure that all required 
# software packages are installed before running this file. To install necessary packages 
# in Ubuntu Linux, simply run the following command:
#
# sudo apt install build-essential binutils-riscv64-unknown-elf gcc-riscv64-unknown-elf
#
# To build the application, cd into the folder with this file and run make
#
# If you want to change the name of the executable or add/remove source files in this project,
# edit the Application-specific detail section below. 

# --- Application-specific detail ----

# name of the executable file
EXECUTABLE = simple-c

# list of all *object* files that must be produced and linked together into the executable.
# for *each* object file in this list there must be a corresponding C (.c) or Assembly (.S or .s) source file
OBJECT_FILES = crt0.o main.o

# list of all header files (.h) and, possibly, other data files *included* into the source code files
# via .include or #include directives
# HEADER_FILES = 

# ------------------------------------

# name of the binary file to hold .text and other executable sections that will be placed in ROM
ROM_IMAGE = $(EXECUTABLE)-rom

# name of the Logisim ROM image file that will be produced from the binary file
ROM_IMAGE_TXT = $(ROM_IMAGE).txt

# what will be built, if make command is run without parameters
.DEFAULT_GOAL = $(ROM_IMAGE_TXT)

# Tool name prfix
RISCV_TOOL_PREFIX=riscv64-unknown-elf-

# RISC-V instruction set architecture to use when compiling the program (RV32IM by default)
RISCV_ISA=rv32im

# RISC-V function calling convention to use when compiling the program (ILP32 by default)
RISCV_ABI=ilp32

# Additional command line options for GCC
CFLAGS=

# Linker script file to use when producting the executable
LINKER_SCRIPT_FILE=logisim.lds

# QEMU executable to use
QEMU_APP=qemu-system-riscv64

# rule and command to compile C files
%.o : %.c
	${RISCV_TOOL_PREFIX}gcc -O -march=$(RISCV_ISA) -mabi=$(RISCV_ABI) -mcmodel=medany -g -c $(CFLAGS) $< -o $@

# rule and command to process .S assembly files using GNU C compiler (.S files may contain C-style #include and #define statements)
%.o : %.S
	${RISCV_TOOL_PREFIX}gcc -O -march=$(RISCV_ISA) -mabi=$(RISCV_ABI) -mcmodel=medany -g -c $(CFLAGS) $< -o $@
	
# rule and command to process .s assembly files using GNU Assembler (.s files must use pure assembly language syntax)
%.o : %.s
	${RISCV_TOOL_PREFIX}as -march=$(RISCV_ISA) -mabi=$(RISCV_ABI) -g -c $< -o $@
	
# rule that says that all object files need to be recompiled if any of the header files change
# $(OBJECT_FILES) : $(HEADER_FILES)

# rule and commands to generate executable file (ELF), disassemble it into .asm file, create linker MAP, and symbol table
$(EXECUTABLE) : $(OBJECT_FILES) 
	${RISCV_TOOL_PREFIX}ld -nostdlib -o $(EXECUTABLE) -Map $(EXECUTABLE).map -T $(LINKER_SCRIPT_FILE) $^
	${RISCV_TOOL_PREFIX}objdump -S $(EXECUTABLE) > $(EXECUTABLE).asm
	${RISCV_TOOL_PREFIX}nm $(EXECUTABLE) > $(EXECUTABLE).sym

# rule and command to extract all code and constant data sections from the ELF executable and place them into a plain binary file (ROM_IMAGE)
$(ROM_IMAGE) : $(EXECUTABLE)
	${RISCV_TOOL_PREFIX}objcopy --only-section .init --only-section .text --only-section .rodata --only-section .srodata --only-section .data --only-section .sdata --only-section .text.* --only-section .rodata.* --only-section .srodata.* --only-section .data.* --only-section .sdata.*  --output-target binary $(EXECUTABLE) $(ROM_IMAGE)

# rule and commands to convert the binary ROM image into .txt file that can be loaded into Logisim ROM component 
$(ROM_IMAGE_TXT) : clean $(ROM_IMAGE)
	echo "v2.0 raw" >$(ROM_IMAGE_TXT)
	hexdump -v -e '/4 "%08x""\n"""' $(ROM_IMAGE) >>$(ROM_IMAGE_TXT)

# command to delete all executable and object files and their derivatives as a way of forcing complete rebuild of the project
clean: 
	rm -f $(OBJECT_FILES) $(ROM_IMAGE_TXT) $(ROM_IMAGE) $(EXECUTABLE) $(EXECUTABLE).map $(EXECUTABLE).sym $(EXECUTABLE).asm 

# compiling code for COMP20180-qemu requires changing target architecture type to RV64, calling convention to lp64,
# using different linker script file (qemu.lds), and defining C macro QEMU20180, so that C code can change
# definitions for MMIO Keyboard and Console peripheral to match memory map of QEMU20180's comp20180 machine.
compile-for-qemu: RISCV_ISA=rv64g
compile-for-qemu: RISCV_ABI=lp64
compile-for-qemu: CFLAGS+=-DQEMU20180
compile-for-qemu: LINKER_SCRIPT_FILE=qemu.lds
compile-for-qemu: clean $(EXECUTABLE)

# run compiled program in qemu, redirect MMIO Keybard and Console to use command line.
qemu: compile-for-qemu
	$(QEMU_APP) -machine comp20180 -kernel $(EXECUTABLE) -bios none -serial stdio

# start compiled program in qemu and freeze it until GDB connects at localhost:1234
qemu-gdb: compile-for-qemu
	$(QEMU_APP) -s -S -machine comp20180 -kernel $(EXECUTABLE) -bios none -serial stdio