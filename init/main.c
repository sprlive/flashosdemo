#include <debug.h>

// 为了证明确实执行到此处特意设置的无效值
static long count = 0;

static char buf[40*80];

int kernel_start() {

	debug_init();

	for (int row = 0; row < 30; row++) {
		for (int i = 0; i < 80; i++) {
			buf[row * 80 + i] = 'a' + row;
		}
	}
	buf[30 * 80] = 0;

	// 这就不行
	dprintk(buf);
	dprintk("m");
	dprintk("m");

	// 系统怠速
	for (;;) {
		count++;
	}
}

