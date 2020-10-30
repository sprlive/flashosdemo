#include <debug.h>

#define ORIG_X (*(unsigned char *)0x90000)
#define ORIG_Y (*(unsigned char *)0x90001)

/**
 * 硬件端口字节输出(带延迟)
 * 使用两条跳转语句来延迟一会儿
 * @param[in]	value	欲输出字节
 * @param[in]	port	端口
 */
#define outb_p(value, port) 										\
	__asm__ ("outb %%al,%%dx\n"										\
			"\tjmp 1f\n"											\
			"1:\tjmp 1f\n" 											\
			"1:"::"a" (value),"d" (port))

static unsigned long bytes_per_row;
static unsigned long video_port_reg = 0x3b4;
static unsigned long video_port_val = 0x3b5;

unsigned long x;
unsigned long y;
unsigned long pos;
unsigned long origin;

void gotoxy(int new_x, int new_y);
void debug_init();
int dprintk(const char* str);

static inline void set_cursor() {
	outb_p(14, video_port_reg);
	outb_p(0xff & ((pos - origin) >> 9), video_port_val);
	outb_p(15, video_port_reg);
	outb_p(0xff & ((pos - origin) >> 1), video_port_val);
}

void gotoxy(int new_x, int new_y) {
	x = new_x;
	y = new_y;
	pos = origin + y * bytes_per_row + (x << 1);
	set_cursor();
}

void debug_init() {
	origin = 0xb8000;
	bytes_per_row = 160;
	video_port_reg = 0x3d4;
	video_port_val = 0x3d5;
	gotoxy(0, ORIG_Y+3);
}

int dprintk(const char* str) {
	char* vram = (char*)(pos);
	char c;
	while ((c = *str)) {
		*vram++ = *str++;
		*vram++ = 0x07;
	}
	return 1;
}