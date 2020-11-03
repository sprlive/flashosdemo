section .data
extern _keyboard_interrupt
global _keyboard_interrupt_entry

section .text
_keyboard_interrupt_entry:

	push _keyboard_interrupt

	;中断结束命令
	mov al,0x20
	out 0xa0,al
	out 0x20,al

no_error_code:

	xchg [esp],eax

	;保存上下文
	push ds
	push es
	push fs
	push gs
	pushad

	;内核代码数据段选择符
	mov edx,10h
	mov ds,dx
	mov es,dx
	mov fs,dx

	;真正调用中断处理函数
	call eax

	;中断退出
	popad
	pop gs
	pop fs
	pop es
	pop ds
	pop eax

	iretd



error_code:

	xchg [esp+4],eax

	;保存上下文
	push ds
	push es
	push fs
	push gs
	pushad

	;内核代码数据段选择符
	mov edx,10h
	mov ds,dx
	mov es,dx
	mov fs,dx

	;真正调用中断处理函数
	call eax

	;中断退出
	popad
	pop gs
	pop fs
	pop es
	pop ds
	pop eax

	iretd