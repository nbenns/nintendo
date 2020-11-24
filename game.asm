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

PLAYER_IX = $80  ; Player Initial X Position
PLAYER_IY = $80  ; Player Initial Y Position

PLAYER_SX = $10  ; Player Pixel Size in X
PLAYER_SY = $20  ; Player Pixel Size in Y

  LDY #$00
  LDA #PLAYER_IY
  PHA 
  LDA #PLAYER_IX
  PHA

PlayerInit:

  TYA                 ; Transfer Counter to A
  CLC
  ROR A               ; Divide by 2 as tiles are 2 apart
  STA P1Tile, Y       ; Set Tile number
  LDA #$00
  STA P1Attr, Y       ; color = 0, no flipping

  PLA
  STA P1XPos, Y       ; put sprite 0 in center ($80) of screen vert
  TAX
  PLA
  STA P1YPos, Y       ; put sprite 0 in center ($80) of screen horiz
  PHA
  TXA
  CLC
  ADC #$08
  PHA

  CPY #$20            ; if we have completed all player tiles skip to Draw
  BEQ Draw

  TYA                 ; Increase the counter by 4 (size of sprite data)
  CLC
  ADC #$04
  TAY

  CPX #(PLAYER_IX + PLAYER_SX) ; Have we hit max P1XPos value?
  BNE PlayerInit        ; If not loop

  PLA
  PLA
  CLC
  ADC #$10            ; Add 16 to Y Value
  PHA
  LDA #$80            ; Reset X to $80
  PHA

  JMP PlayerInit      ; Loop

Draw:
  PLA

  LDA #(PPUCTRL_V | PPUCTRL_H)    ; enable NMI
  STA PPUCTRL

  LDX #PPUMASK_s     ; enable sprites
  STX PPUMASK


Forever:
  JMP Forever ; jump back to Forever, infinite loop
  
NMI:
  JoyStick #JOYPAD1_HIGH, #JOYPAD1_LOW, $00
  readJoy #$00
  STA Joy1
  
  LDX #$00
MoveUp:
  LDA Joy1
  AND #BUTTON_UP
  BEQ MoveDown
  DEC P1YPos, X

MoveDown:
  LDA Joy1
  AND #BUTTON_DOWN
  BEQ MoveLeft
  INC P1YPos, X

MoveLeft:
  LDA Joy1
  AND #BUTTON_LEFT
  BEQ MoveRight
  DEC P1XPos, X

MoveRight:
  LDA Joy1
  AND #BUTTON_RIGHT
  BEQ MoveDone
  INC P1XPos, X

MoveDone:
  CPX #$20
  BEQ TXSprites
  TXA
  CLC
  ADC #$04
  TAX
  JMP MoveUp

TXSprites:
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
  .incbin "chrrom.chr"
