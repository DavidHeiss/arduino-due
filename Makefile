includes = sam/system/CMSIS/CMSIS/Include \
sam/system/CMSIS/Device/ATMEL \
sam/system/CMSIS/Device/ATMEL/sam3xa/include \
sam/system/libsam \
sam/system/libsam/include \
sam/cores/arduino \
sam/variants/arduino_due_x \
sam/cores/arduino/USB

defines = __PROG_TYPES_COMPAT__ \
MD \
USBCON \
'USB_PRODUCT="Arduino Due"' \
'USB_MANUFACTURER="Arduino LLC"' \
__SAM3X8E__ \
USB_VID=0x2341 \
USB_PID=0x003e \
printf=iprintf \
ARDUINO_SAM_DUE \
F_CPU=84000000L \
ARDUINO=105 \
ARDUINO_ARCH_SAM

options = function-sections \
data-sections \
no-exceptions

options++ = no-rtti \
no-threadsafe-statics \
permissive

machine-options = thumb \
cpu=cortex-m3

args = MMD \
c \
ggdb \
nostdlib \
Wall

symbols = _sbrk \
link \
_close \
_fstat \
_isatty \
_lseek \
_read \
_write \
_exit \
kill \
_getpid

stdc = gnu99
stdc++ = gnu++11

opti = s

libcorec = sam/system/libsam/source/tc.c \
sam/system/libsam/source/interrupt_sam_nvic.c \
sam/system/libsam/source/uotghs_device.c \
sam/system/libsam/source/adc12_sam3u.c \
sam/system/libsam/source/twi.c \
sam/system/libsam/source/udphs.c \
sam/system/libsam/source/spi.c \
sam/system/libsam/source/efc.c \
sam/system/libsam/source/dacc.c \
sam/system/libsam/source/pio.c \
sam/system/libsam/source/pmc.c \
sam/system/libsam/source/emac.c \
sam/system/libsam/source/rtt.c \
sam/system/libsam/source/uotghs_host.c \
sam/system/libsam/source/rstc.c \
sam/system/libsam/source/trng.c \
sam/system/libsam/source/can.c \
sam/system/libsam/source/pwmc.c \
sam/system/libsam/source/rtc.c \
sam/system/libsam/source/timetick.c \
sam/system/libsam/source/adc.c \
sam/system/libsam/source/udp.c \
sam/system/libsam/source/wdt.c \
sam/system/libsam/source/usart.c \
sam/system/libsam/source/uotghs.c \
sam/system/libsam/source/ssc.c \
sam/system/libsam/source/gpbr.c \
sam/system/CMSIS/Device/ATMEL/sam3xa/source/system_sam3xa.c \
sam/cores/arduino/wiring.c \
sam/cores/arduino/WInterrupts.c \
sam/cores/arduino/wiring_digital.c \
sam/cores/arduino/itoa.c \
sam/cores/arduino/hooks.c \
sam/cores/arduino/syscalls_sam3.c \
sam/cores/arduino/wiring_analog.c \
sam/cores/arduino/wiring_shift.c \
sam/cores/arduino/iar_calls_sam3.c \
sam/cores/arduino/cortex_handlers.c \
sam/cores/arduino/avr/dtostrf.c

libcorec++ = sam/cores/arduino/IPAddress.cpp \
sam/cores/arduino/wiring_pulse.cpp \
sam/cores/arduino/new.cpp \
sam/cores/arduino/WString.cpp \
sam/cores/arduino/WMath.cpp \
sam/cores/arduino/Stream.cpp \
sam/cores/arduino/Print.cpp \
sam/cores/arduino/watchdog.cpp \
sam/cores/arduino/Reset.cpp \
sam/cores/arduino/USARTClass.cpp \
sam/cores/arduino/main.cpp \
sam/cores/arduino/abi.cpp \
sam/cores/arduino/RingBuffer.cpp \
sam/cores/arduino/UARTClass.cpp \
sam/cores/arduino/USB/USBCore.cpp \
sam/cores/arduino/USB/PluggableUSB.cpp \
sam/cores/arduino/USB/CDC.cpp \
sam/variants/arduino_due_x/variant.cpp

files = src/main.cpp

build: $(libcorec:%.c=%.o) $(libcorec++:%.cpp=%.o) sam/cores/arduino/wiring_pulse_asm.o $(patsubst %.cpp,%.o,$(filter %.cpp,$(files)))
	@echo build/firmware.elf
	@arm-none-eabi-gcc -O$(opti) -Wl,-Map=/firmware.map -lm -Tsam/variants/arduino_due_x/linker_scripts/gcc/flash.ld $(addprefix -m,$(machine-options)) $(addprefix -u,$(symbols)) -Wl,-Map=build/firmware.map -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--start-group -Wl,--gc-sections -Wl,--end-group -Lsam/system/CMSIS/CMSIS/Lib/GCC $(patsubst %.cpp,build/%.o,$(filter %.cpp,$(files))) $(addprefix ./build/,$(libcorec++:%.cpp=%.o) $(libcorec:%.c=%.o) sam/cores/arduino/wiring_pulse_asm.o) sam/variants/arduino_due_x/libsam_sam3x8e_gcc_rel.a -o build/firmware.elf

clean:
	@if test -d build; then \
		rm -r build; \
	fi

%.o: %.c
	@if [ ! -e build/$@ ] || [ $^ -nt build/$@ ]; then \
		echo $^; \
		mkdir -p build/$$(dirname $@); \
		arm-none-eabi-gcc -O$(opti) -std=$(stdc) -Wl,-Map=/firmware.map $(addprefix -,$(args)) $(addprefix -I,$(includes)) $(addprefix -D,$(defines)) $(addprefix -f,$(options)) $(addprefix -m,$(machine-options)) $^ -o build/$@; \
	fi


%.o: %.cpp
	@if [ ! -e build/$@ ] || [ $^ -nt build/$@ ]; then \
		echo $^; \
		mkdir -p build/$$(dirname $@); \
		arm-none-eabi-g++ -O$(opti) -std=$(stdc++) -Wl,-Map=/firmware.map $(addprefix -,$(args)) $(addprefix -I,$(includes)) $(addprefix -D,$(defines)) $(addprefix -f,$(options) $(options++)) $(addprefix -m,$(machine-options)) $^ -o build/$@; \
	fi

%.o: %.S
	@if [ ! -e build/$@ ] || [ $^ -nt build/$@ ]; then \
		echo $^; \
		mkdir -p build/$$(dirname $@); \
		arm-none-eabi-gcc -O$(opti) -Wl,-Map=/firmware.map $(addprefix -,$(args)) $(addprefix -I,$(includes)) $(addprefix -D,$(defines)) $(addprefix -f,$(options)) $(addprefix -m,$(machine-options)) -x assembler-with-cpp $^ -o build/$@; \
	fi

upload:
	openocd -s /usr/share/openocd/scripts \
        -f interface/cmsis-dap.cfg -f board/atmel_sam3x_ek.cfg \
        -c "init"  \
        -c "halt"  \
        -c "flash write_image erase build/firmware.elf" \
        -c "at91sam3 gpnvm set 1" \
        -c "reset run" \
        -c "exit"