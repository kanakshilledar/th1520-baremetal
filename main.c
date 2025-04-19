#define UART_BASE 0xFFE7014000ULL  // UART0 base address on TH1520
#define UART_THR  (UART_BASE + 0x00)  // Transmitter Holding Register
#define UART_LSR  (UART_BASE + 0x14)  // Line Status Register
#define UART_LSR_THRE 0x20  // Transmitter Holding Register Empty bit

static inline void mmio_write(unsigned long long addr, unsigned int value) {
    *(volatile unsigned int*)addr = value;
}

static inline unsigned int mmio_read(unsigned long long addr) {
    return *(volatile unsigned int*)addr;
}

// Send a character to UART
void uart_putc(char c) {
    while ((mmio_read(UART_LSR) & UART_LSR_THRE) == 0);
    
    mmio_write(UART_THR, c);
}

void uart_puts(const char *str) {
    while (*str) {
        uart_putc(*str++);
    }
}

// C entry point
void main(void) {
    uart_puts("Baremetal Hello, World!\r\n");
    while (1) {}
}

// Assembly entry point - this will call our C main function
__attribute__((section(".text.start")))
void _start(void) {
    // Call C entry point
    main();
}
