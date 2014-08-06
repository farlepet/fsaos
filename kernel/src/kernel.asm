[BITS 32]

%include "boot/grub_boot.asm"

kernel:
	cli						; Clear the interrupt flag

	mov esp, kernel_stack 	; Set the kernel stack

	call set_gdt			; Set the GDT

	call set_base_handlers	; Install base interrupt handlers
	call set_idt			; Set the IDT
	call remap_pic			; Remap the IRQ's

	call vga_clear			; Clear the screen

	sti 					; Set the interrupt flag

	call ps2_keyb_init		; Initialize the PS/2 keyboard

  .halt:					; Kernel is done executing, so just halt
	hlt
	jmp .halt


;;;;;;;;;;;;
; Includes ;
;;;;;;;;;;;;

; I/O
%include "io/io.asm"

; MM includes
%include "mm/gdt.asm"

; Interrupt includes
%include "int/idt.asm"
%include "int/pic.asm"
%include "int/base_handlers.asm"

; Misc.
%include "helpers.asm"

; Data
welcomeMsg: db "Welcome to FSAOS!", 10, 0

kernel_stack_top:
	times 4096 db 0	; Reserve 4096 bytes for the kernel stack
kernel_stack: