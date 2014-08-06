%define PIC1_CMD	0x20
%define PIC1_DATA	0x21
%define PIC2_CMD	0xa0
%define PIC2_DATA	0xa1

%define PIC_MASTER_OFFSET	0xF0
%define PIC_SLAVE_OFFSET	0xF8

%macro pic_write 2
	mov al, %2		; Load value to be written
	out %1, al		; Write value to specified port
	call io_wait	; Make sure the PIC has time to process the information
%endmacro

; Remaps the PIC
remap_pic:
	push ax									; Save AX

	pic_write PIC1_CMD, 0x11				; Start master initialization
	pic_write PIC2_CMD, 0x11				; Start slave initialization
	pic_write PIC1_DATA, PIC_MASTER_OFFSET	; Set Master PIC offset
	pic_write PIC2_DATA, PIC_SLAVE_OFFSET	; Set Slave PIC offset
	pic_write PIC1_DATA, 0x04				; Slave is at IRQ 2
	pic_write PIC2_DATA, 0x02 				; Set slave's cascade identity
	pic_write PIC1_DATA, 0x01				; 8086 mode
	pic_write PIC2_DATA, 0x01				; 8086 mode

	pic_write PIC1_DATA, 0xFF				; Disable IRQ's 0-7
	pic_write PIC2_DATA, 0xFF				; Disable IRQ's 8-15

	pop ax 									; Restore AX
	ret 									; Return
