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


; Print a number as a hexadecimal string
;  Arguments:
;   EAX: Number to print
vga_printnum_hex:
	push eax 				; Store EAX - Number
	push ecx 				; Store ECX - Loop counter
	push edx 				; Store EDX - Calculation space

	push esi 				; Store ESI
	mov esi, vga_hexprefix	; Point ESI to string containing hex prefix
	call vga_print 			; Print the string
	pop esi 				; Restore ESI

	mov ecx, 8 				; 8 nibbles in a DWORD
  .loop:
	rol eax, 4				; Get the required nibble in place
	mov edx, eax 			; Move to EDX
	and edx, 0x0F			; Get that nibble to be alone
	or  edx, 0x30
	cmp edx, 0x3A
	jb .rest
	add edx, 0x07
  .rest:
	push eax 				; Store EAX
	mov al, dl 				; Move DL into AL
	mov ah, 0x07 			; Set VGA character color
	call vga_put 			; Place EAX onto the screen as a character
	pop eax 				; Restore EAX
	loop .loop 				; If ECX != 0 loop again

	pop edx 				; Restore EDX
	pop ecx 				; Restore ECX
	pop eax 				; Restore EAX
	ret 					; Return

; Data
vga_height: 	dd 25					; Current height
vga_width:		dd 80					; Current width

vga_size:		dd 80*25				; Size of VGA screen
vga_bytes:		dd 80*25*2 			; Number of bytes the VGA screen takes up
vga_ptr:		dd 0xB8000				; Pointer to VGA memory
vga_stride:		dd 80*2					; Stride of VGA screen in bytes
vga_end:		dd 0xB8000 + 80*25*2 	; End of VGA memory

vga_hexprefix: db "0x", 0 				; Prefix to add when printing a hexadecimal number