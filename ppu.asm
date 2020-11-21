PPUCTRL   = $2000     ; PPU control register, Access - write
PPUCTRL_V = %10000000 ; NMI enable (V)
PPUCTRL_P = %01000000 ; PPU master/slave (P)
PPUCTRL_H = %00100000 ; sprite height (H)
PPUCTRL_B = %00010000 ; background tile select (B)
PPUCTRL_S = %00001000 ; sprite tile select (S)
PPUCTRL_I = %00000100 ; increment mode (I)
PPUCTRL_N = %00000011 ; nametable select (NN)

PPUMASK   = $2001     ; PPU mask register, Access - write
PPUMASK_B = %10000000 ; Intensify Blue (B)
PPUMASK_G = %01000000 ; Intensify Green (G)
PPUMASK_R = %00100000 ; Intensify Red (R)
PPUMASK_s = %00010000 ; Enable Sprites (s)
PPUMASK_b = %00001000 ; Enable Background Rendering (b)
PPUMASK_M = %00000100 ; Disable sprite left-edge clipping (M)
PPUMASK_m = %00000010 ; Disable background left-edge clipping (m)
PPUMASK_g = %00000001 ; Grayscale (g)

PPUSTATUS   = $2002     ; PPU status register, Access - read
PPUSTATUS_V = %10000000 ; Vertical blank has started (V)
PPUSTATUS_S = %01000000 ; Sprite 0 Hit (S)
PPUSTATUS_O = %00100000 ; Sprite Overflow (O)
PPUSTATUS_U = %00011111 ; Unused (U)

OAMADDR = $2003 ; OAM read/write address

OAMDATA = $2004 ; OAM data read/write

PPUSCROLL = $2005 ; fine scroll position (two writes: X scroll, Y scroll)

PPUADDR = $2006 ; PPU read/write address (two writes: most significant byte, least significant byte)

PPUDATA = $2007 ; PPU data read/write

OAMDMA = $4014 ; OAM DMA high address
