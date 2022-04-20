; =--------------------=[ PXE Dust ]=--------------------=
; =----------------------=[ Shell ]=---------------------=

%include "intel.asm"

shell_init:
  ; call A20
  call move_to_orig
  call clear_screen
  ret

; =------------------------------------------------------=
