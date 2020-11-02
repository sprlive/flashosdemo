include ../Rules.make

all: kernel.o

OBJECTS = trap.o

kernel.o: $(OBJECTS)
	@ld -r -o kernel.o $(OBJECTS)

trap.o: trap.c
	@echo [kernel的子模块] 正在陷阱模块 trap.o
	@gcc -c -fno-builtin -I ../include -o trap.o trap.c

clean:
	del /q *.lst
	del /q *.bin
	del /q *.o
	del /q *.bin.large