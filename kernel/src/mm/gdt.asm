; Sets the GDT
set_gdt:
	mov eax, gdt		; Move location of GDT into eax
	mov [gdtr + 2], eax	; ... then into gdtr.base
	mov eax, gdt_end	; Move the end of the GDT into eax
	sub eax, gdt		; ... subtract the location of GDT to get the length
	mov [gdtr], ax		; ... and move it into gdtr.limit
	lgdt [gdtr]			; Load the GDT
	ret					; Return

; Data

gdtr:
	DW 0 ; Limit
	DD 0 ; Base


gdt:
	dq 0x0000000000000000	; Null
    dq 0x00cf9a000000ffff	; Code
    dq 0x00cf92000000ffff	; Data
gdt_end:
