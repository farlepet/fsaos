; Sets the GDT
set_gdt:
	lgdt [gdtr]			; Load the GDT
	ret					; Return

; Data

gdtr:
	dw gdt_end - gdt 	; Limit
	dd gdt 				; Base


gdt:
	dq 0x0000000000000000	; Null
    dq 0x00cf9a000000ffff	; Code
    dq 0x00cf92000000ffff	; Data
gdt_end:
