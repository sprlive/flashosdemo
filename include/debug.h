void debug_init();
void dprintf(const char* fmt, int num);
void dprintk(const char* fmt);
void dprintk_color(const char* str, char color);
void dprintc(char c);
void dprint_info(const char* str);
void print_cursor_info();
void put_char(char c, char color, char* vram);
void dprint_info_hex(int num, int row);