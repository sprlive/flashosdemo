include Rules.make

MAIN_O = boot/head.o init/main.o
DEBUG_O = debug/dprintk.o
KERNEL_O = kernel/trap.o kernel/keyboard.o kernel/intr.o

OBJECTS = $(MAIN_O) $(DEBUG_O) $(KERNEL_O)

all: Image

Image: boot/bootsect.bin boot/setup.bin init/main.bin
	@del /q others\bochs\os.raw*
	@bximage -mode=create -hd=60 -q $(BOCHS_HOME)/os.raw
	@dd if=boot/bootsect.bin of=$(BOCHS_HOME)/os.raw bs=512 count=1
	@dd if=boot/setup.bin of=$(BOCHS_HOME)/os.raw bs=512 count=4 seek=1
	@dd if=init/main.bin of=$(BOCHS_HOME)/os.raw bs=512 count=100 seek=5

######### �������ļ���������(bootsect)��������(setup)���ں�(main) #########
	
boot/bootsect.bin: boot/bootsect.s
	@echo �������������� bootsect.bin
	@nasm -I include/ -o boot/bootsect.bin boot/bootsect.s -l boot/bootsect.lst
	
boot/setup.bin: boot/setup.s
	@echo �������ɼ����� setup.bin
	@nasm -I include/ -o boot/setup.bin boot/setup.s -l boot/setup.lst

init/main.bin: $(OBJECTS)
	@echo ��ɹ��ˣ������������յ��ںˣ� main.bin
	@$(LD) $(OBJECTS) -Ttext 0x0 -e startup_32 -o init/main.bin.large
	@objcopy -O binary init/main.bin.large init/main.bin


######### �ں˲��ֵĸ���Ŀ���ļ� #########
	
boot/head.o: boot/head.s
	@echo ��������Ŀ���ļ� boot/head.o
	@nasm -f elf -I include/ -o boot/head.o boot/head.s -l boot/head.lst

init/main.o: init/main.c
	@echo ��������Ŀ���ļ� init/main.o
	@gcc $(LIB) $(GCCPARAM) -o init/main.o init/main.c


debug/dprintk.o: debug/dprintk.c
	@echo ��������Ŀ���ļ� debug/dprintk.o
	@gcc $(LIB) $(GCCPARAM) -o debug/dprintk.o debug/dprintk.c


kernel/trap.o: kernel/trap.c
	@echo ��������Ŀ���ļ� kernel/trap.o
	@gcc $(LIB) $(GCCPARAM) -o kernel/trap.o kernel/trap.c

kernel/keyboard.o: kernel/keyboard.c
	@echo ��������Ŀ���ļ� kernel/keyboard.o
	@gcc $(LIB) $(GCCPARAM) -o kernel/keyboard.o kernel/keyboard.c

kernel/intr.o: kernel/intr.s
	@echo ��������Ŀ���ļ� kernel/intr.o
	@nasm -f elf -I include/ -o kernel/intr.o kernel/intr.s

######### �������� #########

run: Image
	@bochs -f $(BOCHS_HOME)/bochsrc.disk -q
	
brun: Image
	@bochsdbg -f $(BOCHS_HOME)/bochsrc.disk -q
	
clean:
	@echo ������.....
	@del /q others\bochs\os.raw*
	@cd boot && make clean
	@cd debug && make clean
	@cd init && make clean
	@cd kernel && make clean