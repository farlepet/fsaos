; Clear the VGA display
vga_clear:
	push eax					; Store EAX
	push ecx					; Store ECX
	push edi					; Store EDI

	mov ecx, DWORD[vga_size]	; We are filling VGA memory of SIZE words
	mov ax,  0x0700				; We are filling it with blank characters
	mov edi, DWORD[vga_ptr]		; VGA memory is at PTR
	rep stosw					; Fill it

	pop edi						; Restore EDI
	pop ecx						; Restore ECX
	pop eax						; Restore EAX

	ret							; We're done here, return


; Print a string to the screen
;   Arguments:
;      ESI - Pointer to string
vga_print:
	push eax		; Store EAX
	push ecx		; Store ECX
	push esi		; Store ESI

  .loop:

	lodsb			; Load byte from ESI

	or al, al		; Check if character is NULL
	jz .done		; If it is, jump to .done

	mov ah, 0x07	; Character color
	call vga_put	; Write the character

	jmp .loop		; Loop

  .done:
	pop esi			; Restore ESI
	pop ecx			; Restore ECX
	pop eax			; Restore EAX

	ret				; Return


; Data
vga_height: 	dd 25		; Current height
vga_width:		dd 80		; Current width

vga_size:		dd 80*25	; Size of VGA screen
vga_ptr:		dd 0xB8000	; Pointer to VGA memory
vga_stride:		dd 80*2		; Stride of VGA screen in bytes

vga_hexprefix: db "0x", 0 	; Prefix to add when printing a hexadecimal number