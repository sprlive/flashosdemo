include Rules.make

MAIN_O =			\
	boot/head.o		\
	init/main.o		\

DEBUG_O =			\
	debug/dprintk.o	\

KERNEL_O =				\
	kernel/trap.o		\
	kernel/keyboard.o	\
	kernel/intr.o		\

OBJECTS = $(MAIN_O) $(DEBUG_O) $(KERNEL_O)

all: Image

Image: boot/bootsect.bin boot/setup.bin init/main.bin
	@del /q others\bochs\os.raw*
	@echo [正在生成最终的无格式的虚拟硬盘文件！！！] 第一步：创建空文件 os.raw，请按下回车键确认
	@bximage -mode=create -hd=60 -q $(BOCHS_HOME)/os.raw
	@echo [正在生成最终的无格式的虚拟硬盘文件！！！] 第二步：第1扇区（启动区）写入 bootsect.bin
	@dd if=boot/bootsect.bin of=$(BOCHS_HOME)/os.raw bs=512 count=1
	@echo [正在生成最终的无格式的虚拟硬盘文件！！！] 第三步：第2扇区写入连续4扇区内容 setup.bin
	@dd if=boot/setup.bin of=$(BOCHS_HOME)/os.raw bs=512 count=4 seek=1
	@echo [正在生成最终的无格式的虚拟硬盘文件！！！] 第四步：第5扇区开始写入庞大的内核文件 main.bin
	@dd if=init/main.bin of=$(BOCHS_HOME)/os.raw bs=512 count=100 seek=5
	@echo [正在生成最终的无格式的虚拟硬盘文件！！！] 第五步：os.raw 生成完毕，准备放入虚拟机启动

######### 三个主文件，启动区(bootsect)、加载器(setup)、内核(main) #########
	
boot/bootsect.bin: boot/bootsect.s
	@echo [正在生成启动区] bootsect.bin
	@nasm -I include/ -o boot/bootsect.bin boot/bootsect.s -l boot/bootsect.lst
	
boot/setup.bin: boot/setup.s
	@echo [正在生成加载器] setup.bin
	@nasm -I include/ -o boot/setup.bin boot/setup.s -l boot/setup.lst

init/main.bin: $(OBJECTS)
	@echo [正在生成最终的内核！激动！] main.bin
	@$(LD) $(OBJECTS) -Ttext 0x0 -e startup_32 -o init/main.bin.large
	@objcopy -O binary init/main.bin.large init/main.bin


######### 内核部分的各种目标文件 #########

%.o:%.c
	@echo ...[正在生成目标文件 c写的] $@
	@gcc $(LIB) $(GCCPARAM) -o $@ $<

%.o:%.s
	@echo ...[正在生成目标文件 nasm写的] $@
	@nasm -f elf -I include/ -o $@ $<

######### 各种命令 #########

run: Image
	@echo [用bochs启动内核] 运行模式启动
	@bochs -f $(BOCHS_HOME)/bochsrc.disk -q
	
brun: Image
	@echo [用bochs启动内核] 调试模式启动
	@bochsdbg -f $(BOCHS_HOME)/bochsrc.disk -q
	
clean:
	@echo 清理工作.....
	@del /q others\bochs\os.raw*
	@cd boot && make clean
	@cd debug && make clean
	@cd init && make clean
	@cd kernel && make clean