; Set the interrupt handlers required for a successful boot
set_base_handlers:
	mov al, 32			; Interrupt 32
	mov ebx, test_int	; Test interrupt pointer
	call idt_set_int	; Set the interrupt


test_int:
	push esi			; Store ESI
	mov esi, test_msg	; Move test_msg into ESI
	call vga_print		; Print the string in ESI
	pop esi 			; Restore ESI
	iret				; Return from interrupt

; Data
test_msg: db "Hello from INT #32!", 13, 0