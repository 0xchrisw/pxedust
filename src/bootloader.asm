; =--------------------=[ PXE Dust ]=--------------------=
; =-------------=[ Christopher Woodall 2022 ]=-----------=
; =------------------------------------------------------=

; ------[ Compiller Info ]
[BITS 16]     ; 16 Bit Real Mode
[ORG 0x7C00]  ; BIOS Entry Point



; =------------------------------------------------------=
; Fix Real Hardware USB Emulation
;   https://stackoverflow.com/a/47320115
boot:
  jmp main
  nop

  ; This is not machine code, and should be skipped
  ; FAT12 DOS 4.0 EBPB (1.44MB Floppy)
  OEMname:           db    "mkfs.fat"     ; mkfs.fat is what OEMname mkdosfs uses
  bytesPerSector:    dw    512            ; Bytes per sector
  sectPerCluster:    db    1              ; Sectors in one cluster
  reservedSectors:   dw    1              ; Sectors per boot section
  numFAT:            db    2              ; Number of FAT tables
  numRootDirEntries: dw    224            ; Max # of files/directories in root directory
  numSectors:        dw    2880           ; Total number of sectors
  mediaType:         db    0xf0           ; Media descriptor
  numFATsectors:     dw    9              ; Sectors in FAT table
  sectorsPerTrack:   dw    18             ; Sectors per lane
  numHeads:          dw    2              ; Number of heads
  numHiddenSectors:  dd    0              ; Hidden sectors?
  numSectorsHuge:    dd    0              ; FAT32 information, unnecessary for FAT12
  driveNum:          db    0              ; Drive number
  reserved:          db    0              ; Reserved
  signature:         db    0x29           ; Media Signature: 41 = floppy, 29 = hard disk
  volumeID:          dd    0x2d7e5a1a     ; Volume ID: any *unique* number
  volumeLabel:       db    "PXEDUST    "  ; Volume Label: strict 11 characters
  fileSysType:       db    "FAT12   "     ; Filesystem type: FAT12


; =------------------------------------------------------=--
main:
  ;; Stack Setup
	xor ax, ax	 ; Clear AX
	mov ds, ax   ; Set DS to 0
	mov es, ax   ; Set ES to 0
	mov sp, ax	 ; Set Stack Pointer to 0
	mov ss, ax   ; Set Stack Segment to 0
	mov bp, sp   ; Set Base Pointer to 0
	; mov sp, 0xFFFF

  ; In real hardware the BIOS puts the address
  ; of the booting drive in the dl register
  ; mov [bootdev], dl

  call shell_init
	call loop_disks

	jmp	$

; ------[ Dependencies ]
%include "inc/shell.asm"
%include "inc/disks.asm"


; TODO - Should this be hardcoded or will BIOS set this for you?
bootdev db 0x80	; Boot device number

DUST  db  "ALL YOUR INODES ARE BELONG TO US...",0xD,0xA,0

TEST_STR db 'Hell0 World!', 0

times	510-($-$$)	db	0
dw	0xAA55


; =------------------------------------------------------=
