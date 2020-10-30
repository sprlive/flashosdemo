include Rules.make

all: Image

Image: boot/bootsect.bin boot/setup.bin init/main.bin
	bximage -mode=create -hd=60 -q $(BOCHS_HOME)/os.raw
	dd if=boot/bootsect.bin of=$(BOCHS_HOME)/os.raw bs=512 count=1
	dd if=boot/setup.bin of=$(BOCHS_HOME)/os.raw bs=512 count=4 seek=1
	dd if=init/main.bin of=$(BOCHS_HOME)/os.raw bs=512 count=100 seek=5
	
boot/bootsect.bin: boot/bootsect.s
	nasm -I include/ -o boot/bootsect.bin boot/bootsect.s -l boot/bootsect.lst
	
boot/setup.bin: boot/setup.s
	nasm -I include/ -o boot/setup.bin boot/setup.s -l boot/setup.lst
	
boot/head.o: boot/head.s
	nasm -f elf -I include/ -o boot/head.o boot/head.s -l boot/head.lst
	
init/main.bin: init/main.c debug/dprintk.o boot/head.o
	gcc -c -fno-builtin -I include -o init/main.o init/main.c
	$(LD) boot/head.o init/main.o debug/dprintk.o -Ttext 0x0 -e startup_32 -o init/main.large
	objcopy -O binary init/main.large init/main.bin
	
debug/dprintk.o: debug/dprintk.c
	gcc -c -fno-builtin -I include -o debug/dprintk.o debug/dprintk.c
	
tools/build:

run: Image
	bochs -f $(BOCHS_HOME)/bochsrc.disk -q
	
brun: Image
	bochsdbg -f $(BOCHS_HOME)/bochsrc.disk -q
	
clean:
	del /q others\bochs\os.raw
	del /q boot\*.lst
	del /q boot\*.bin
	del /q boot\*.o
	del /q init\*.bin
	del /q init\*.bin.large
	del /q init\*.o
	del /q mm\*.o