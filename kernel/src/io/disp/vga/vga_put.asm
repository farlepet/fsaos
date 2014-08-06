; Place a character on the screen
;   Arguments:
;      AL - Character
;	   AH - Color
vga_put:
	push ebx				; Store EBX

    cmp al, 0x08            ; Backspace
    je .backspace           ; Handle it

    ;cmp al, 0x09            ; Tab -- TODO

    cmp al, 0x0A            ; Newline/Line Feed
    je .newline

	push edi				; Store ESI
	push eax				; Store EAX

	mov eax, DWORD[vga_row]	; Get ready to multiply vga_row by vga_stride
	mul DWORD[vga_stride]	; Multiply
	add eax, DWORD[vga_col]	; Add the column
	add eax, DWORD[vga_col] ; Add it again (2 bytes)
	add eax, DWORD[vga_ptr] ; Add to VGA memory location
	mov edi, eax			; Move pointer in EAX into EDI

	pop eax					; Restore EAX

	stosw					; Write character and color to memory

	pop edi					; Restore ESI

	inc DWORD[vga_col]			; Increment position
	mov ebx, DWORD[vga_col]		; Move vga_col to ebx
	cmp ebx, DWORD[vga_width]	; Check if it is greater than the width of the display
	jl .done					; vga_col is not over-flowing
	
  .newline:
	mov DWORD[vga_col], 0		; Move char position back to right
	inc DWORD[vga_row]			; And increment the row by one
	mov ebx, DWORD[vga_row]		; Move vga_row to ebx
	cmp ebx, DWORD[vga_height]	; Check that it is not over-flowing
	jl .done					; It is not

	call vga_scroll
	dec DWORD[vga_row]			; Decrement it by one
    jmp .done                   ; Were done now

  .backspace:
    cmp DWORD[vga_col], 0       ; Check if it will underflow
    je .backspace_row           ; If so, jump
    dec DWORD[vga_col]          ; else just decrement
  .backspace_row:
    cmp DWORD[vga_row], 0       ; Are we at home position?
    je .done                    ; Yes, nothing to do here

    mov ebx, DWORD[vga_width]   ; Get the display width
    sub ebx, 1                  ; Subtract one from it
    mov DWORD[vga_row], ebx     ; Move to row variable
    je .done                    ; Skip the comming code

  .done:
	pop ebx
	ret						; We're done here, return


; Advances to the next line
vga_newline:
	push ebx 					; Store EBX
	mov DWORD[vga_col], 0		; Move char position back to right
	inc DWORD[vga_row]			; And increment the row by one
	mov ebx, DWORD[vga_row]		; Move vga_row to ebx
	cmp ebx, DWORD[vga_height]	; Check that it is not over-flowing
	jl .done					; It is not

	call vga_scroll
	dec DWORD[vga_row]			; Decrement it by one

  .done:
	pop ebx 					; Restore EAX
	ret 						; Return


; Scrolls the console one line up and clears the last line
vga_scroll:
	push esi 					; Store ESI
	push edi 					; Store EDI
	push ecx					; Store ECX
	push eax 					; Store EAX

	mov esi, DWORD [vga_ptr]	; Source = VGA_PTR...
	add esi, DWORD [vga_stride]	; ... + VGA_STRIDE
	mov edi, DWORD [vga_ptr] 	; Dest = VGA_PTR
	mov ecx, DWORD [vga_bytes]	; N_DWORDS = (VGA_SIZE...
	add ecx, DWORD [vga_stride]	; ... - VGA_STRIDE)...
	shr ecx, 2					; ... / 4
	cld							; Clear direction flag so values increment
rep movsd						; Copy the video memory

	mov esi, DWORD [vga_end] 	; Dest = VGA_END...
	sub esi, DWORD [vga_stride]	; ... - VGA_STRIDE
	xor eax, eax 				; Value = 0
	mov ecx, DWORD [vga_stride]	; N_DWORDS = VGA_STRIDE...
	shr ecx, 2 					; ... / 4
rep stosd						; Clear last line of VGA memory

	pop eax 					; Restore EAX
	pop ecx 					; Restore ECX
	pop edi 					; Restore EDI
	pop esi 					; Restore ESI
	ret 						; Return

; Data
vga_row: dd 0			; Current row
vga_col: dd 0			; Current collumn
