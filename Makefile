# Compiler and tools
CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
FASTBOOT = fastboot

# Flags
CFLAGS = -march=rv64gc -mabi=lp64d -mcmodel=medany -static -nostdlib -ffreestanding -O2 -Wall
LDFLAGS = -T link.ld

# Source files
SRCS = main.c
OBJS = $(SRCS:.c=.o)

# Output files
ELF = main.elf
BIN = main.bin

all: $(BIN)

$(ELF): $(OBJS) link.ld
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@
	$(OBJDUMP) -d $(ELF) > main.lst

run: 	$(BIN)
	$(FASTBOOT) flash ram $(BIN)
	$(FASTBOOT) reboot

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(ELF) $(BIN) main.lst

.PHONY: all clean
