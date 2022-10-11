includes = ArduinoCore-sam/system/CMSIS/CMSIS/Include \
ArduinoCore-sam/system/CMSIS/Device/ATMEL \
ArduinoCore-sam/system/CMSIS/Device/ATMEL/sam3xa/include \
ArduinoCore-sam/system/libsam \
ArduinoCore-sam/system/libsam/include \
ArduinoCore-sam/cores/arduino \
ArduinoCore-sam/variants/arduino_due_x \
ArduinoCore-sam/cores/arduino/USB

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

opti = g

libcorec = ArduinoCore-sam/system/libsam/source/tc.c \
ArduinoCore-sam/system/libsam/source/interrupt_sam_nvic.c \
ArduinoCore-sam/system/libsam/source/uotghs_device.c \
ArduinoCore-sam/system/libsam/source/adc12_sam3u.c \
ArduinoCore-sam/system/libsam/source/twi.c \
ArduinoCore-sam/system/libsam/source/udphs.c \
ArduinoCore-sam/system/libsam/source/spi.c \
ArduinoCore-sam/system/libsam/source/efc.c \
ArduinoCore-sam/system/libsam/source/dacc.c \
ArduinoCore-sam/system/libsam/source/pio.c \
ArduinoCore-sam/system/libsam/source/pmc.c \
ArduinoCore-sam/system/libsam/source/emac.c \
ArduinoCore-sam/system/libsam/source/rtt.c \
ArduinoCore-sam/system/libsam/source/uotghs_host.c \
ArduinoCore-sam/system/libsam/source/rstc.c \
ArduinoCore-sam/system/libsam/source/trng.c \
ArduinoCore-sam/system/libsam/source/can.c \
ArduinoCore-sam/system/libsam/source/pwmc.c \
ArduinoCore-sam/system/libsam/source/rtc.c \
ArduinoCore-sam/system/libsam/source/timetick.c \
ArduinoCore-sam/system/libsam/source/adc.c \
ArduinoCore-sam/system/libsam/source/udp.c \
ArduinoCore-sam/system/libsam/source/wdt.c \
ArduinoCore-sam/system/libsam/source/usart.c \
ArduinoCore-sam/system/libsam/source/uotghs.c \
ArduinoCore-sam/system/libsam/source/ssc.c \
ArduinoCore-sam/system/libsam/source/gpbr.c \
ArduinoCore-sam/system/CMSIS/Device/ATMEL/sam3xa/source/system_sam3xa.c \
ArduinoCore-sam/cores/arduino/wiring.c \
ArduinoCore-sam/cores/arduino/WInterrupts.c \
ArduinoCore-sam/cores/arduino/wiring_digital.c \
ArduinoCore-sam/cores/arduino/itoa.c \
ArduinoCore-sam/cores/arduino/hooks.c \
ArduinoCore-sam/cores/arduino/syscalls_sam3.c \
ArduinoCore-sam/cores/arduino/wiring_analog.c \
ArduinoCore-sam/cores/arduino/wiring_shift.c \
ArduinoCore-sam/cores/arduino/iar_calls_sam3.c \
ArduinoCore-sam/cores/arduino/cortex_handlers.c \
ArduinoCore-sam/cores/arduino/avr/dtostrf.c

libcorec++ = ArduinoCore-sam/cores/arduino/IPAddress.cpp \
ArduinoCore-sam/cores/arduino/wiring_pulse.cpp \
ArduinoCore-sam/cores/arduino/new.cpp \
ArduinoCore-sam/cores/arduino/WString.cpp \
ArduinoCore-sam/cores/arduino/WMath.cpp \
ArduinoCore-sam/cores/arduino/Stream.cpp \
ArduinoCore-sam/cores/arduino/Print.cpp \
ArduinoCore-sam/cores/arduino/watchdog.cpp \
ArduinoCore-sam/cores/arduino/Reset.cpp \
ArduinoCore-sam/cores/arduino/USARTClass.cpp \
ArduinoCore-sam/cores/arduino/main.cpp \
ArduinoCore-sam/cores/arduino/abi.cpp \
ArduinoCore-sam/cores/arduino/RingBuffer.cpp \
ArduinoCore-sam/cores/arduino/UARTClass.cpp \
ArduinoCore-sam/cores/arduino/USB/USBCore.cpp \
ArduinoCore-sam/cores/arduino/USB/PluggableUSB.cpp \
ArduinoCore-sam/cores/arduino/USB/CDC.cpp \
ArduinoCore-sam/variants/arduino_due_x/variant.cpp

files = src/main.c

build: libcore $(patsubst %.cpp,%.o,$(filter %.cpp,$(files))) $(patsubst %.c,%.o,$(filter %.c,$(files)))
	arm-none-eabi-gcc -O$(opti) -Wl,-Map=/firmware.map -lm -TArduinoCore-sam/variants/arduino_due_x/linker_scripts/gcc/flash.ld $(addprefix -m,$(machine-options)) $(addprefix -u,$(symbols)) -Wl,-Map=build/firmware.map -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--start-group -Wl,--gc-sections -Wl,--end-group -LArduinoCore-sam/system/CMSIS/CMSIS/Lib/GCC $(patsubst %.cpp,build/%.o,$(filter %.cpp,$(files))) $(patsubst %.c,build/%.o,$(filter %.c,$(files))) ArduinoCore-sam/variants/arduino_due_x/libsam_sam3x8e_gcc_rel.a build/libcore.a -o build/firmware.elf

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

libcore: $(libcorec:%.c=%.o) $(libcorec++:%.cpp=%.o) ArduinoCore-sam/cores/arduino/wiring_pulse_asm.o
	@if [ ! -e build/libcore.a ] || $(subst ] [,] || [,$(foreach var, $(libcorec) $(libcorec++) ArduinoCore-sam/cores/arduino/wiring_pulse_asm.S,[ $(var) -nt build/libcore.a ])); then \
		echo libcore.a; \
		mkdir -p build; \
		arm-none-eabi-ar rcs build/libcore.a $(addprefix build/,$(libcorec:%.c=%.o) $(libcorec++:%.cpp=%.o) ArduinoCore-sam/cores/arduino/wiring_pulse_asm.o); \
	fi
