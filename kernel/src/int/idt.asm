; Set the IDT in use using `lidt`
set_idt:
	lidt [idtr]	; Set the current IDT
	ret 		; Return

; Set an interrupt descriptor in the idt
;  Arguments:
;   AL:  IDT index (0 - 255)
;	EBX: Interrupt handler location
idt_set_int:
	push eax								; Store EAX
	push cx									; Store CX

	and eax, 0xFF							; Clear higher part of EAX
	mov cx, 8								; Prepare to multiply EAX by 8
	mul cx									; ... and multiply
	mov WORD [idt + eax], bx				; Store low word of pointer
	shr ebx, 16								; ... shift it right by 16
	mov WORD [idt + eax + 6], bx			; ... and store the high word

	mov BYTE [idt + eax + 2], 8				; Store the segment selector
	mov BYTE [idt + eax + 4], 0				; Clear this part of the ID
	mov BYTE [idt + eax + 5], 0b10001110	; Set the flags of the ID

	pop cx 									; Restore CX
	pop eax									; Restore EAX
	ret										; Return


; Data
idtr:
	dw idt_end - idt 	; Limit
	dd idt 				; Base

idt:
	resb 8 * 256		; 256 interrupt descriptors, 8 bytes each
idt_end: