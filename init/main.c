#include <debug.h>

// 为了证明确实执行到此处特意设置的无效值
static long count = 0;

static char buf[10];

int kernel_start() {

	debug_init();

	// 这就不行
	dprintk("ccccccccc");

	// 这就行
	for (int i = 0; i < 10; i++) {
		buf[i] = 'f';
	}
	buf[10] = 0;
	//dprintk(buf);

	// 系统怠速
	for (;;) {
		count++;
	}
}

