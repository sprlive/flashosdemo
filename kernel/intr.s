section .data
extern _keyboard_interrupt
global _keyboard_interrupt_entry

section .text
_keyboard_interrupt_entry:

	push _keyboard_interrupt

	;�жϽ�������
	mov al,0x20
	out 0xa0,al
	out 0x20,al

no_error_code:

	xchg [esp],eax

	;����������
	push ds
	push es
	push fs
	push gs
	pushad

	;�ں˴������ݶ�ѡ���
	mov edx,10h
	mov ds,dx
	mov es,dx
	mov fs,dx

	;���������жϴ�����
	call eax

	;�ж��˳�
	popad
	pop gs
	pop fs
	pop es
	pop ds
	pop eax

	iretd



error_code:

	xchg [esp+4],eax

	;����������
	push ds
	push es
	push fs
	push gs
	pushad

	;�ں˴������ݶ�ѡ���
	mov edx,10h
	mov ds,dx
	mov es,dx
	mov fs,dx

	;���������жϴ�����
	call eax

	;�ж��˳�
	popad
	pop gs
	pop fs
	pop es
	pop ds
	pop eax

	iretd