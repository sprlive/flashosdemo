extern _keyboard_interrupt

section .text
global _keyboard_interrupt_entry
_keyboard_interrupt_entry:

	;����������
	push ds
	push es
	push fs
	push gs
	pushad

	;�жϽ�������
	mov al,0x20
	out 0xa0,al
	out 0x20,al

	;���������жϴ�����
	call _keyboard_interrupt

	;�ж��˳�
	popad
	pop gs
	pop fs
	pop es
	pop ds
	iretd
