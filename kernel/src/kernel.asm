[BITS 32]

%include "boot/grub_boot.asm"

kernel:
	cli						; Clear the interrupt flag

	call set_gdt			; Set the GDT
	call set_idt			; Set the IDT

	call set_base_handlers	; Install base interrupt handlers

	; This line causes a boot-loop in QEMU... I guess I have to take a look at that IDT...
	;sti 					; Set the interrupt flag

	call vga_clear			; Clear the screen

	mov	 esi, welcomeMsg	; Load the welcome message
	call vga_print			; Print it
	
	
  .halt:					; Kernel is done executing, so just halt
	hlt
	jmp .halt
;;;;;;;;;;;;
; Includes ;
;;;;;;;;;;;;

; Video includes
%include "io/vga/char.asm"
%include "io/vga/vga_put.asm"

; MM includes
%include "mm/gdt.asm"

; Interrupt includes
%include "int/idt.asm"
%include "int/base_handlers.asm"

; Data
welcomeMsg: db "Welcome to FSAOS!", 10, 0
