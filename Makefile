CC=arm-none-eabi-gcc
MACH=cortex-m4
CFLAGS= -c -mcpu=$(MACH) -mthumb -std=gnu11 -O0 -Wall
LDFLAGS= -T stm32_ls.ld -nostdlib -Wl,-Map=final.map

all: final.elf

%.o: %.c
	$(CC) $(CFLAGS) $^ -o $@

final.elf: main.o stm32_startup.o
	$(CC) $(LDFLAGS) $^ -o $@

final.bin: final.elf
	arm-none-eabi-objcopy -O binary $^ $@

st-flash: final.bin
	st-flash --reset write final.bin 0x08000000

clean:
	rm -rf *.o *.elf *.bin *.map
load:
	openocd -f interface/stlink-v2.cfg -f board/st_nucleo_f4.cfg
