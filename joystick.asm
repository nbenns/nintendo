JOYPAD1      = $4016
JOYPAD1_LOW  = $16
JOYPAD1_HIGH = $40

JOYPAD2      = $4017
JOYPAD2_LOW  = $17
JOYPAD2_HIGH = $40

BUTTON_A      = %10000000
BUTTON_B      = %01000000
BUTTON_SELECT = %00100000
BUTTON_START  = %00010000
BUTTON_UP     = %00001000
BUTTON_DOWN   = %00000100
BUTTON_LEFT   = %00000010
BUTTON_RIGHT  = %00000001

; At the same time that we strobe bit 0, we initialize the ring counter
; so we're hitting two birds with one stone here

; Params:
;  \1 - High Joystick Byte
;  \2 - Low Joystick Byte
;  \3 - ZeroPage Offset to Store Struct
JoyStick .macro
  LDX \3
  LDA \2
  STA $00, X
  LDA \1
  STA $01, X
  .endm
  

readJoy .macro
  LDA \1
  TSX
  PHA
  JSR readjoy
  PLA
  .endm

readjoy:
  LDY $0100, X

  ; While the strobe bit is set, buttons will be continuously reloaded.
  ; This means that reading from the JOYPAD will only return the state of the
  ; first button: button A.
  LDA #$01
  LDY #$00
  STA [$00], Y
  STA $0100, X

  ; By storing 0 into JOYPAD1, the strobe bit is cleared and the reloading stops.
  ; This allows all 8 buttons (newly reloaded) to be read from the JOYPAD.
  LSR A        ; now A is 0
  STA [$00], Y

loop:
  LDA [$00], Y
  LSR A	          ; bit 0 -> Carry
  ROL $0100, X    ; Carry -> bit 0; bit 7 -> Carry
  BCC loop
  RTS
