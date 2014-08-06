; Driver for PS/2 keyboards

; Wait for the keyboard controller to process a command
%macro ps2_keyb_wait 0
	%%1:
		in al, 0x64
		test al, 0x02
		jne %%1
%endmacro

; Initialize an attached PS/2 keyboard
ps2_keyb_init:
	mov al, 0xFF					; Command = 0xFF
	out 0x60, al					; Send Command to port 0x60
	ps2_keyb_wait					; Make sure keyboard processes command

  .loop:
	in al, 0x60						; Check return value of command

	cmp al, 0xFC					; 0xFC == FAIL
	je .fail 						; ... Jump to fail code
	cmp al, 0xFD					; 0xFD == FAIL
	je .fail 						; ... Jump to fail code

	cmp al, 0xAA					; 0xAA == PASS
	je .pass 						; Jump to pass code

	cmp al, 0xFE					; 0xFE == Resend Request
	jne .loop						; ... Loop again if this is NOT the message received

	mov al, 0xFF					; Command = 0xFF
	out 0x60, al					; Resend Command to port 0x60
	ps2_keyb_wait					; Make sure the keyboard has processed the command
	jmp .loop 						; Loop again

  .pass:							; We passed!
	mov esi, ps2_keyb_init_pass_msg	; Here is a string saying so
	call vga_print					; Let's print it
	jmp .done						; Now we are done

  .fail:							; We failed!
	mov esi, ps2_keyb_init_fail_msg	; Here is a string saying so
	call vga_print					; Now print it

  .done:							; We are done
	ret 							; ... Return


; Data
ps2_keyb_init_fail_msg:	db "Failed to initialize PS/2 keyboard!", 10, 0
ps2_keyb_init_pass_msg:	db "PS/2 kayboard suscessfully initialized!", 10, 0