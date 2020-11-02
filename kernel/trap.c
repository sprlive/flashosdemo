#include <trap.h>
#include <debug.h>
#include <asm/io.h>
#include <asm/system.h>

void keyboard_interrupt() {
	char a = inb_p(0x61);
	dprintk("key:");
	dprintk(a);
}

void trap_init() {
	register unsigned char a;

	set_trap_gate(0x21, &keyboard_interrupt);			// 设置键盘中断陷阱门。
	outb_p((unsigned char)(inb_p(0x21) & 0xfd), 0x21);	// 取消8259A 中对键盘中断的屏蔽，允许IRQ1。
	a = inb_p(0x61);									// 延迟读取键盘端口0x61(8255A 端口PB)。
	outb_p((unsigned char)(a | 0x80), 0x61);			// 设置禁止键盘工作(位7 置位)，
	outb(a, 0x61);										// 再允许键盘工作，用以复位键盘操作。

}

