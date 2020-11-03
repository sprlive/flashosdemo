extern _keyboard_interrupt

section .text
global _keyboard_interrupt_entry
_keyboard_interrupt_entry:

	;保存上下文
	push ds
	push es
	push fs
	push gs
	pushad

	;中断结束命令
	mov al,0x20
	out 0xa0,al
	out 0x20,al

	;真正调用中断处理函数
	call _keyboard_interrupt

	;中断退出
	popad
	pop gs
	pop fs
	pop es
	pop ds
	iretd
