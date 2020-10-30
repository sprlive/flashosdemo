// 为了证明确实执行到此处特意设置的无效值
static long count = 0;

int kernel_start() {

	// 系统怠速
	for (;;) {
		count++;
	}
}