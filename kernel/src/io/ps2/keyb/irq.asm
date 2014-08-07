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
	push eax
	push bx
	push cx
	xor eax, eax

	in al, 0x60

	mov cl, [ps2_keyb_shift]
	mov bx, 1
	cmp ax, 0x2A
	cmove cx, bx
	cmp ax, 0x36
	cmove cx, bx
	mov bx, 0
	cmp ax, 0xAA
	cmove cx, bx
	cmp ax, 0xB6
	cmove cx, bx
	mov [ps2_keyb_shift], cl

	mov cl, [ps2_keyb_ctrl]
	mov bx, 1
	cmp ax, 0x1D
	cmove cx, bx
	mov bx, 0
	cmp ax, 0x9D
	cmove cx, bx
	mov [ps2_keyb_ctrl], cl

	mov cl, [ps2_keyb_alt]
	mov bx, 1
	cmp al, 0x38
	cmove cx, bx
	mov bx, 0
	cmp al, 0xB8
	cmove cx, bx
	mov [ps2_keyb_alt], cl

	xor cx, cx
	mov bl, [ps2_keyb_shift]
	cmp bl, 1
	mov bx, 256
	cmove cx, bx
	add ax, cx

	mov al, [ps2_keyb_codes_1 + eax]
	cmp al, 0
	je .done

	mov ah, 0x07
	call vga_put

	

  .done:
	mov	al, 0x20
	out	0x20, al

	pop cx
	pop bx
	pop eax
	iret

; Data:
ps2_keyb_irq_test_msg:	db "PS/2 INT ", 0

; Flags:
ps2_keyb_shift:	db 0
ps2_keyb_ctrl:	db 0
ps2_keyb_alt:	db 0

; Keycode translation table
ps2_keyb_codes_1:
   ;    0     1   2    3    4    5    6    7    8    9    A    B    C    D     E     F
	db  0 ,  0 , '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=',   8 ,   9  ;0
	db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']',  10 , 0,   'a',  's' ;1
	db 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',  47, '`',  0 ,  92, 'z', 'x',  'c',  'v' ;2
	db 'b', 'n', 'm', ',', '.', '/',  0 ,  0 ,  0 , ' ',  0 ,  0 ,  0 ,  0 ,   0 ,   0  ;3
	times (256 - 64) db 0
   ;    0     1   2    3    4    5    6    7    8    9    A    B    C    D     E     F
	db  0 ,  0 , '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+',   8 ,   9  ;0
	db 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}',  10,  0 ,  'A',  'S' ;1
	db 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',  34, '~',  0 , '|', 'Z', 'X',  'C',  'V' ;2
	db 'B', 'N', 'M', '<', '>', '?',  0 ,  0 ,  0 , ' ',  0 ,  0 ,  0 ,  0 ,   0 ,   0  ;3
	times (256 - 64) db 0