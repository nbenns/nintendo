

  .rsset $0000

ZEROPAGE   = $0000 ; $0000-00FF	256 bytes	Zeropage
STACKPAGE  = $0100 ; $0100-$01FF	160 bytes	Stack
SPRITEPAGE = $0200 ; $0200-$02FF	256 bytes	Sprite Data
; $0300-$03FF	256 bytes	Variables used by sound player, and possibly other variables
; $0400-$07FF	1024 bytes	Arrays and less-often-accessed global variables

; Split high and low bytes for pages

ZEROPAGE_LOW  = $00
ZEROPAGE_HIGH = $00

STACKPAGE_LOW  = $00
STACKPAGE_HIGH = $01

SPRITEPAGE_LOW  = $00
SPRITEPAGE_HIGH = $02

; Splitting up ZEROPAGE
LOCALS  = $0000 ; $0000-$000F   16 bytes        Local variables
GLOBALS = $0010 ; $0010-$00FF   240 bytes       Global variables
