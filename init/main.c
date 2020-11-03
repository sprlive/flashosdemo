#include "debug.h"
#include "trap.h"
#include "keyboard.h"
#include "asm/system.h"

// 为了证明确实执行到此处特意设置的无效值
static long count = 0;

static char buf[40*80];

int kernel_start() {

	debug_init();
	dprintk("debug init finish\n");
	trap_init();
	dprintk("trap init finish\n");
	keyboard_init();
	dprintk("keyboard init finish\n");

	dprintk("\n");

	dprintk_color("[Try Input]", 0x0e);

	sti();

	// 系统怠速
	for (;;) {
		count++;
	}
}

