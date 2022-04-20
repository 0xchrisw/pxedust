; =--------------------=[ PXE Dust ]=--------------------=
; =----------------------=[ Disks ]=---------------------=

; =------------------------------------------------------=
loop_disks:
  .loop:
    call write_disk
    jc .done
		mov ax, [bootdev]
    add ax, 0x01
    mov [bootdev], ax
    jmp .loop
  .done:
    ret


; =------------------------------------------------------=
write_disk:
  push dx
    mov ah, 0x03
    mov bx, DUST
    mov	al, 1	; Write one sector
    mov	ch, 0	; First track
    mov	cl, 1	; First sector
    mov	dh, 0	; First head - assume only one
    mov dl, [bootdev]
    stc       ; Adjust Carry -INT 0x13 will clean it if there is no error
    pusha
      int 0x13
    popa
    jnc .done
  pop dx
  cmp dh,al
  jne .done
  ret

  .done:
    pop dx
    ret
