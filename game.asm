  .inesprg 1   ; 1x 16KB PRG code
  .ineschr 1   ; 1x  8KB CHR data
  .inesmap 0   ; mapper 0 = NROM, no bank swapping
  .inesmir 1   ; background mirroring

;;;;;;;;;;;;;;;

  .bank 0
  .org $C000 
  .include "ppu.asm" 
  .include "apu.asm"
  .include "ram.asm"
  .include "joystick.asm"

Joy1 = GLOBALS     ; Controller 1 Data
Joy2 = GLOBALS + 1 ; Controller 2 Data

P1YPos = $0200 ; Player 1 Y Pos
P1Tile = $0201 ; Player 1 Tile Number
P1Attr = $0202 ; Player 1 Attributes
P1XPos = $0203 ; Player 1 X Pos

RESET:
  SEI              ; disable IRQs
  CLD              ; disable decimal mode
  LDX #APUFRCTRL_I
  STX APUFRCTRL    ; disable APU frame IRQ
  LDX #$FF
  TXS              ; Set up stack
  INX              ; now X = 0
  STX PPUCTRL      ; disable NMI
  STX PPUMASK      ; disable rendering
  STX DMCA         ; disable DMC IRQs

vblankwait1:       ; First wait for vblank to make sure PPU is ready
 BIT PPUSTATUS
 BPL vblankwait1

clrmem:
  LDA #$00
  STA ZEROPAGE, x
  STA STACKPAGE, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA SPRITEPAGE, x ; move all sprites off screen
  INX
  BNE clrmem

vblankwait2:      ; Second wait for vblank, PPU is ready after this
  BIT PPUSTATUS
  BPL vblankwait2


LoadPalettes:
  LDA PPUSTATUS    ; read PPU status to reset the high/low latch
  LDA #$3F
  STA PPUADDR      ; write the high byte of $3F00 address
  LDA #$00
  STA PPUADDR      ; write the low byte of $3F00 address
  LDX #$00

LoadPalettesLoop:
  LDA palette, X        ;load palette byte
  STA PPUDATA           ;write to PPU
  INX                   ;set index to next byte
  CPX #$20
  BNE LoadPalettesLoop  ;if x = $20, 32 bytes copied, all done

  LDA #$80
  STA P1YPos        ; put sprite 0 in center ($80) of screen vert
  STA P1XPos        ; put sprite 0 in center ($80) of screen horiz
  LDA #$00
  STA P1Tile        ; tile number = 0
  STA P1Attr        ; color = 0, no flipping

  LDA #$80
  STA P1YPos+4        ; put sprite 0 in center ($80) of screen vert
  LDA #$88
  STA P1XPos+4        ; put sprite 0 in center ($80) of screen horiz
  LDA #$02
  STA P1Tile+4        ; tile number = 0
  LDA #$00
  STA P1Attr+4        ; color = 0, no flipping

  LDA #$80
  STA P1YPos+8        ; put sprite 0 in center ($80) of screen vert
  LDA #$90
  STA P1XPos+8        ; put sprite 0 in center ($80) of screen horiz
  LDA #$04
  STA P1Tile+8        ; tile number = 0
  LDA #$00
  STA P1Attr+8        ; color = 0, no flipping

  LDA #$90
  STA P1YPos+12      ; put sprite 0 in center ($80) of screen vert
  LDA #$80
  STA P1XPos+12       ; put sprite 0 in center ($80) of screen horiz
  LDA #$06
  STA P1Tile+12       ; tile number = 0
  LDA #$00
  STA P1Attr+12       ; color = 0, no flipping

  LDA #$90
  STA P1YPos+16      ; put sprite 0 in center ($80) of screen vert
  LDA #$88
  STA P1XPos+16       ; put sprite 0 in center ($80) of screen horiz
  LDA #$08
  STA P1Tile+16       ; tile number = 0
  LDA #$00
  STA P1Attr+16       ; color = 0, no flipping

  LDA #$90
  STA P1YPos+20      ; put sprite 0 in center ($80) of screen vert
  LDA #$90
  STA P1XPos+20       ; put sprite 0 in center ($80) of screen horiz
  LDA #$0A
  STA P1Tile+20       ; tile number = 0
  LDA #$00
  STA P1Attr+20       ; color = 0, no flipping

  LDA #$A0
  STA P1YPos+24      ; put sprite 0 in center ($80) of screen vert
  LDA #$80
  STA P1XPos+24       ; put sprite 0 in center ($80) of screen horiz
  LDA #$0C
  STA P1Tile+24       ; tile number = 0
  LDA #$00
  STA P1Attr+24       ; color = 0, no flipping

  LDA #$A0
  STA P1YPos+28      ; put sprite 0 in center ($80) of screen vert
  LDA #$88
  STA P1XPos+28       ; put sprite 0 in center ($80) of screen horiz
  LDA #$0E
  STA P1Tile+28       ; tile number = 0
  LDA #$00
  STA P1Attr+28       ; color = 0, no flipping

  LDA #$A0
  STA P1YPos+32      ; put sprite 0 in center ($80) of screen vert
  LDA #$90
  STA P1XPos+32       ; put sprite 0 in center ($80) of screen horiz
  LDA #$10
  STA P1Tile+32       ; tile number = 0
  LDA #$00
  STA P1Attr+32       ; color = 0, no flipping

  LDA #(PPUCTRL_V | PPUCTRL_H)    ; enable NMI
  STA PPUCTRL

  LDX #PPUMASK_s    ; enable sprites
  STX PPUMASK


Forever:
  JMP Forever ; jump back to Forever, infinite loop
  
NMI:
  JoyStick #JOYPAD1_HIGH, #JOYPAD1_LOW, $00
  readJoy #$00
  STA Joy1
  
MOVEUP:
  LDA Joy1
  AND #BUTTON_UP
  BEQ MOVEDOWN
  DEC P1YPos
  DEC P1YPos+4
  DEC P1YPos+8
  DEC P1YPos+12
  DEC P1YPos+16
  DEC P1YPos+20
  DEC P1YPos+24
  DEC P1YPos+28
  DEC P1YPos+32

MOVEDOWN:
  LDA Joy1
  AND #BUTTON_DOWN
  BEQ MOVELEFT
  INC P1YPos
  INC P1YPos+4
  INC P1YPos+8
  INC P1YPos+12
  INC P1YPos+16
  INC P1YPos+20
  INC P1YPos+24
  INC P1YPos+28
  INC P1YPos+32

MOVELEFT:
  LDA Joy1
  AND #BUTTON_LEFT
  BEQ MOVERIGHT
  DEC P1XPos
  DEC P1XPos+4
  DEC P1XPos+8
  DEC P1XPos+12
  DEC P1XPos+16
  DEC P1XPos+20
  DEC P1XPos+24
  DEC P1XPos+28
  DEC P1XPos+32

MOVERIGHT:
  LDA Joy1
  AND #BUTTON_RIGHT
  BEQ MOVEDONE
  INC P1XPos
  INC P1XPos+4
  INC P1XPos+8
  INC P1XPos+12
  INC P1XPos+16
  INC P1XPos+20
  INC P1XPos+24
  INC P1XPos+28
  INC P1XPos+32

MOVEDONE:
  LDA #SPRITEPAGE_LOW
  STA OAMADDR           ; set the low byte (00) of the RAM address
  LDA #SPRITEPAGE_HIGH
  STA OAMDMA            ; set the high byte (02) of the RAM address, start the transfer
  RTI
 
;;;;;;;;;;;;;;  
  
  .bank 1
  .org $E000
palette:
  .db $0F,$31,$32,$33,$0F,$35,$36,$37,$0F,$39,$3A,$3B,$0F,$3D,$3E,$0F
  .db $0F,$00,$10,$20,$0F,$02,$38,$3C,$0F,$1C,$15,$14,$0F,$02,$38,$3C

  NOP
  .org $FFFA     ;first of the three vectors starts here
  .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
  .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
  .dw 0          ;external interrupt IRQ is not used in this tutorial
  
;;;;;;;;;;;;;;  
  
  .bank 2
  .org $0000
  ; .incbin "mario.chr"   ;includes 8KB graphics file from SMB1
  .incbin "chrrom.chr"
