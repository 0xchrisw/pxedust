

; Activate A20
A20:
	mov ax, 0x2401
	int 0x15


; Move cursor to top left position
move_to_orig:
	mov ah, 0x02
	xor bx, bx
	xor dx, dx
	int 0x10


; Clear screen
clear_screen:
	mov ah, 0x06
	xor al, al
	xor bx, bx
	mov bh, 0x07
	xor cx, cx
	mov dh, 24
	mov dl, 79
	int 0x10

