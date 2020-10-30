include Rules.make

all: Image

Image: boot/bootsect.bin boot/setup.bin boot/head.bin init/main.bin
	del /q others\bochs\os.raw
	bximage -mode=create -hd=60 -q $(BOCHS_HOME)/os.raw
	dd if=boot/bootsect.bin of=$(BOCHS_HOME)/os.raw bs=512 count=1
	dd if=boot/setup.bin of=$(BOCHS_HOME)/os.raw bs=512 count=4 seek=1
	dd if=boot/head.bin of=$(BOCHS_HOME)/os.raw bs=512 count=48 seek=5
	dd if=init/main.bin of=$(BOCHS_HOME)/os.raw bs=512 count=100 seek=53
	
boot/bootsect.bin: boot/bootsect.s
	nasm -I include/ -o boot/bootsect.bin boot/bootsect.s -l boot/bootsect.lst
	
boot/setup.bin: boot/setup.s
	nasm -I include/ -o boot/setup.bin boot/setup.s -l boot/setup.lst
	
boot/head.bin: boot/head.s
	nasm -I include/ -o boot/head.bin boot/head.s -l boot/head.lst
	
init/main.bin: init/main.c
	gcc -c -fno-builtin -o init/main.o init/main.c
	$(LD) init/main.o -Ttext 0x5000 -e _kernel_start -o init/main.bin
	
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