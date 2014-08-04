INTERRUPT_FLAGS equ 0b1000111000000000

; Set the IDT in use using `lidt`
set_idt:
	lidt [idtr]	; Set the current IDT
	ret 		; Return


; Set an interrupt descriptor in the idt
;  Arguments:
;   AL:  IDT index (0 - 255)
;	EBX: Interrupt handler location
idt_set_int:
	push eax									; Store EAX
	push ebx 									; Store EBX
	push cx										; Store CX

	and eax, 0xFF								; Clear higher part of EAX
	mov cx, 8									; Prepare to multiply EAX by 8
	mul cx										; ... and multiply

	mov WORD [idt + eax], bx					; Store low word of pointer
	shr ebx, 16									; ... shift it right by 16
	mov WORD [idt + eax + 6], bx				; ... and store the high word

	mov WORD [idt + eax + 2], 0x08				; Store the segment selector
	mov WORD [idt + eax + 4], INTERRUPT_FLAGS	; Store the interrupt's flags

	pop cx 										; Restore CX
	pop ebx 									; Restore EBX
	pop eax										; Restore EAX
	ret											; Return


; Clear an interrupt descriptor in the idt
; Arguments:
;  AL: IDT index (0 - 255)
idt_clear_int:
	push eax 						; Store EAX
	push cx 						; Store CX

	and eax, 0xFF					; Clear high part of EAX
	mov cx, 8						; Prepare to multiply EAX by 8
	mul cx 							; Multiply

	mov DWORD [idt + eax], 0 		; Clear low DWORD of descriptor
	mov DWORD [idt + eax + 4], 0 	; Clear high DWORD of descriptor

	pop cx	 						; Restore CX
	pop eax 						; Restore EAX
	ret 							; Return

; Macro to set an IDT descriptor
;  Arguments:
;   1: IDT index (0 - 255)
;   2: Interrupt handler pointer
%macro set_interrupt 2
	mov ax, %1 			; AX = IDT index
	mov ebx, %2 		; EBX = Interrupt handler pointer
	call idt_set_int	; Set the descriptor
%endmacro

; Data
idtr:
	dw (256 * 8) - 1	; Limit
	dd idt 				; Base

; IDT
idt:
	times (256 * 8) db 0 	; 256 interrupt descriptors, 8 bytes each
idt_end: