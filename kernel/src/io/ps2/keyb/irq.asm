; IRQ handler for PS/2 keyboard

enable_ps2_keyb_irq:
	push ax
	push ebx

	mov al, 0xF1
	mov ebx, ps2_keyb_irq
	call idt_set_int

	mov al, 1
	call pic_enable_irq

	pop ebx
	pop ax
	ret

; Handler for PS/2 keyboard IRQ
ps2_keyb_irq:
	push ax
	in al, 0x60

	

	mov	al, 0x20
	out	0x20, al

	pop ax
	iret

; Data:
ps2_keyb_irq_test_msg:	db "PS/2 INT ", 0