ENTRY(_start)
SECTIONS {
    . = 0x80000000;
    .init : { *(.init) }
    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss COMMON) }
    . = ALIGN(8);
    . += 0x1000;
    __stack_init = .;
}
