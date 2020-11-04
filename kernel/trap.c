#include "trap.h"
#include "debug.h"
#include "asm/io.h"
#include "asm/system.h"

extern void reserved_interrupt_entry(void);

/* �����жϣ���ʱȫд�ɱ����жϣ����� */
void reserved_interrupt() {
	dprintk("reserved_interrupt occur");
}

void trap_init() {

	for (int i = 0; i < 32; i++) {
		set_trap_gate(i, &reserved_interrupt);
	}

}

