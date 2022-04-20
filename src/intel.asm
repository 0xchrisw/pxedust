

; Activate A20
A20:
	; Fast A20 Gate.
  mov al, 2
  out 0x92, al
	ret


; Move cursor to top left position
move_to_orig:
	mov ah, 0x02	; Set cursor position function
	xor bx, bx		; Page
	xor dx, dx		; Column
	int 0x10			; BIOS interrupt
	ret


; Clear screen
clear_screen:
	mov ax, 0x02
	int 0x10
	ret

