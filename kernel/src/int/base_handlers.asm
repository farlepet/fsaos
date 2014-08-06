; Set the interrupt handlers required for a successful boot
set_base_handlers:
	set_interrupt 0x01, int_div_0
	set_interrupt 0x02, int_nmi
	set_interrupt 0x03, int_breakpoint
	set_interrupt 0x04, int_overflow
	set_interrupt 0x05, int_bound
	set_interrupt 0x06, int_invop
	set_interrupt 0x07, int_devnavail
	set_interrupt 0x08, int_doublefault
	set_interrupt 0x09, int_coprocseg
	set_interrupt 0x0A, int_invalidtss
	set_interrupt 0x0B, int_segnpres
	set_interrupt 0x0C, int_stacksegfault
	set_interrupt 0x0D, int_gpf
	set_interrupt 0x0E, int_pagefault
	set_interrupt 0x10, int_floatingpt

	ret 				; Return


int_div_0:								; Division by 0 exception
	push esi							; Store ESI
	mov esi, div_0_msg					; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_nmi:								; Non-Maskable Interrupt
	push esi							; Store ESI
	mov esi, nmi_msg					; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_breakpoint:							; Breakpoint
	push esi							; Store ESI
	mov esi, breakpoint_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_overflow:							; Overflow exception
	push esi							; Store ESI
	mov esi, overflow_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_bound:								; Bound Range Exceeded exception
	push esi							; Store ESI
	mov esi, bound_msg					; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_invop:								; Invalid Opcode exception
	push esi							; Store ESI
	mov esi, invop_msg					; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_devnavail:							; Device not available exception
	push esi							; Store ESI
	mov esi, devnavail_msg				; Move string pointer to ESI
	call vga_print							; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_doublefault:						; Double fault
	pop DWORD [doublefault_errcode]		; Pop error code off stack
	push esi							; Store ESI
	mov esi, doublefault_msg			; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_coprocseg:							; Coprocessor Segment Overrun
	push esi							; Store ESI
	mov esi, coprocseg_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_invalidtss:							; Invalid TSS
	pop DWORD [invalidtss_errcode]		; Pop error code off stack
	push esi							; Store ESI
	mov esi, invalidtss_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_segnpres:							; Segment Not Present exception
	pop DWORD [segnpres_errcode]		; Pop error code off stack
	push esi							; Store ESI
	mov esi, segnpres_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_stacksegfault:						; Stack segment fault
	pop DWORD [stacksegfault_errcode]	; Pop error code off stack
	push esi							; Store ESI
	mov esi, stacksegfault_msg			; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_gpf:								; General Protection Fault
	pop DWORD [gpf_errcode]				; Pop error code off stack
	push esi							; Store ESI
	mov esi, gpf_msg					; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_pagefault:							; Page Fault
	pop DWORD [pagefault_errcode]		; Pop error code off stack
	push esi							; Store ESI
	mov esi, pagefault_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt

int_floatingpt:							; Floating Point Exception
	push esi							; Store ESI
	mov esi, floatingpt_msg				; Move string pointer to ESI
	call vga_print						; Print the string
	pop esi 							; Restore ESI
	iret								; Return from interrupt


; Data
doublefault_errcode:	dd 0 	; Storage for double fault error code
invalidtss_errcode:		dd 0 	; Storage for Invalid TSS error code
segnpres_errcode:		dd 0 	; Storage for Segment Not Present error code
stacksegfault_errcode:	dd 0 	; Storage for Stack Segment Fault error code
gpf_errcode:			dd 0 	; Storage for General Protection Fault error code
pagefault_errcode:		dd 0 	; Storage for Page Fault error code

; Exception messages
div_0_msg:			db "A division by 0 exception has occured!", 10, 0
nmi_msg:			db "A Non-Maskable Interrupt has occured!", 10, 0
breakpoint_msg:		db "A breakpoint was encountered!", 10, 0
overflow_msg:		db "An overflow exception has occured!", 10, 0
bound_msg:			db "A bound range exceeded exception has occured!", 10, 0
invop_msg:			db "An invalid opcode exception has occured!", 10, 0
devnavail_msg:		db "A device not available exception has occured!", 10, 0
doublefault_msg:	db "A double fault has occured!", 10, 0
coprocseg_msg:		db "A Coprocessor Segment Overrun exception has occured!", 10, 0
invalidtss_msg:		db "It appears you have an invalid TSS"
segnpres_msg:		db "A segment not present exception has occured!", 10, 0
stacksegfault_msg:	db "A stack segment fault has occured!", 10, 0
gpf_msg:			db "A General Protection Fault has occured!", 10, 0
pagefault_msg:		db "A Page Fault has occured!", 10, 0
floatingpt_msg:		db "A floating point exception has occured!", 10, 0