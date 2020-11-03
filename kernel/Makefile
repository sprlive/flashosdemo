include ../Rules.make

all: trap.o keyboard.o intr.o

OBJECTS = trap.o keyboard.o

trap.o: trap.c
	@echo [kernel的子模块] 正在陷阱模块 trap.o
	@gcc -c -fno-builtin -I ../include -o trap.o trap.c

keyboard.o: keyboard.c
	@echo [kernel的子模块] 正在键盘模块 keyboard.o
	@gcc -c -fno-builtin -I ../include -o keyboard.o keyboard.c

intr.o: intr.s
	@echo [kernel的子模块] 正在中断模块 intr.o
	@nasm -f elf -o intr.o intr.s -l intr.lst

clean:
	del /q *.lst
	del /q *.bin
	del /q *.o
	del /q *.bin.large