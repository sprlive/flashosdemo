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

	set_trap_gate(0x21, &keyboard_interrupt);			// ���ü����ж������š�
	outb_p((unsigned char)(inb_p(0x21) & 0xfd), 0x21);	// ȡ��8259A �жԼ����жϵ����Σ�����IRQ1��
	a = inb_p(0x61);									// �ӳٶ�ȡ���̶˿�0x61(8255A �˿�PB)��
	outb_p((unsigned char)(a | 0x80), 0x61);			// ���ý�ֹ���̹���(λ7 ��λ)��
	outb(a, 0x61);										// ��������̹��������Ը�λ���̲�����

}

