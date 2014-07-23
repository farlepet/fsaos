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

	; TODO: Implement scrolling!!!
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


; Data
vga_row: dd 0			; Current row
vga_col: dd 0			; Current collumn
