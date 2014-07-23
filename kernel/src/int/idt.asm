; Set an interrupt descriptor in the idt
;  Arguments:
;   AL:  IDT index (0 - 255)
;	EBX: Interrupt handler location
idt_set_int:
	push ax								; Store AX
	xor ah, ah							; Clear AH
	mul ax, 8							; ... and multiply AX by 8 to the the IDT offset
	mov WORD [idt + ax], bx				; Store low word of pointer
	shr ebx, 16							; ... shift it right by 16
	mov WORD [idt + ax + 6]				; ... and store the high word
	
	mov BYTE [idt + ax + 2], 8			; Store the segment selector
	mov BYTE [idt + ax + 4], 0			; Clear this part of the ID
	mov BYTE [idt + ax + 5], 0b10001110	; Set the flags of the ID
	pop ax								; Restore AX
	ret									; Return


; Data
idt:
	resb 8 * 256	; 256 interrupt descriptors, 8 bytes each