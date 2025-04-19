MEMORY
{
    /* Start execution from DDR memory */
    RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 16M
}

SECTIONS
{
    .text : {
        *(.text.start)
        *(.text)
    } > RAM
    
    .rodata : {
        *(.rodata)
    } > RAM
    
    .data : {
        *(.data)
    } > RAM
    
    .bss : {
        *(.bss)
    } > RAM
}
