; =--------------------=[ PXE Dust ]=--------------------=
; =-------------------=[ intel.asm ]=--------------------=

; Activate A20
A20:
	; Fast A20 Gate.
  mov al, 2
  out 0x92, al
	ret

; =------------------------------------------------------=
; Move cursor to top left position
move_to_orig:
	mov ah, 0x02	; Set cursor position function
	xor bx, bx		; Page
	xor dx, dx		; Column
	int 0x10			; BIOS interrupt
	ret

; =------------------------------------------------------=
; Clear screen
clear_screen:
	mov ax, 0x02
	int 0x10
	ret

; =------------------------------------------------------=
print_hex:
	mov bx,dx
	and bx,0x000f
	cmp bl,0x09
	jg print_letter
	add bx,0x30
	mov ah,0x0e
	mov al,bl
	int 0x10
	shr dx,4
	rol dx,8
	and dx,dx
	jnz print_hex
	ret

; =------------------------------------------------------=
print_letter:
	sub bl,0x09
	dec bl
	add bl,0x61
	mov ah,0x0e
	mov al,bl
	int 0x10
	shr dx,4
	rol dx,8
	and dx,dx
	jnz print_hex
	ret

; =------------------------------------------------------=

