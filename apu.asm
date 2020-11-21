PULSEA_D = %11000000 ; duty (D)
PULSEA_L = %00100000 ; envelope loop / length counter halt (L)
PULSEA_C = %00010000 ; constant volume (C)
PULSEA_V = %00001111 ; volume/envelope (V)

PULSEA_1 = $4000
PULSEA_2 = $4004

PULSEB_E = %10000000 ; Sweep unit: enabled (E)
PULSEB_P = %01110000 ; period (P)
PULSEB_N = %00001000 ; negate (N)
PULSEB_S = %00000111 ; shift (S)
PULSEB_1 = $4001
PULSEB_2 = $4005

PULSEC_T = %11111111 ; Timer low (T)
PULSEC_1 = $4002
PULSEC_2 = $4006

PULSED_L = %11111000 ; Length counter load (L)
PULSED_T = %00000111 ; timer high (T)
PULSED_1 = $4003
PULSED_2 = $4007


TRIANGLEA = $4008
TRIANGLEA_C = %10000000 ; Length counter halt / linear counter control (C)
TRIANGLEA_R = %01111111 ; linear counter load (R)

TRIANGLEB = $4009 ; Unused

TRIANGLEC = $400A
TRIANGLEC_T = %11111111 ; Timer low (T)

TRIANGLED = $400B
TRIANGLED_L = %11111000 ; Length counter load (L)
TRIANGLED_T = %00000111 ; timer high (T)

NOISEA = $400C ; 
NOISEA_L = %00100000 ; Envelope loop / length counter halt (L)
NOISEA_C = %00010000 ; constant volume (C)
NOISEA_V = %00001111 ; volume/envelope (V)

NOISEB = $400D ; Unused

NOISEC = $400E 
NOISEC_L = %10000000 ; Loop noise (L)
NOISEC_P = %00001111 ; noise period (P)

NOISED = $400F
NOISED_L = %11111000 ; Length counter load (L)

DMCA = $4010
DMCA_I = %10000000 ; IRQ enable (I)
DMCA_L = %01000000 ; loop (L)
DMCA_R = %00001111 ; frequency (R)

DMCB = $4011
DMCB_D = %01111111 ; Load counter (D)

DMCC = $4012
DMCC_A = %11111111 ; Sample address (A)

DMCD = $4013
DMCD_L = %11111111 ; Sample length (L)

APUSTATUS = $4015

APUSTATUSW_D = %00010000 ; Enable DMC (D) - Write
APUSTATUSW_N = %00001000 ; noise (N) - Write
APUSTATUSW_T = %00000100 ; triangle (T) - Write
APUSTATUSW_P2 = %00000010 ; Pulse 2 - Write
APUSTATUSW_P1 = %00000001 ; Pulse 1 - Write

APUSTATUSR_I = %10000000 ; DMC interrupt (I) - Read
APUSTATUSR_F = %01000000 ; frame interrupt (F) - Read
APUSTATUSR_D = %00010000 ; DMC active (D) - Read
APUSTATUSR_N = %00001000 ; Noise length counter > 0 (N) - Read
APUSTATUSR_T = %00000100 ; Triangle length counter > 0 (N) - Read
APUSTATUSR_P2 = %00000010 ; Pulse 2 length counter > 0 (N) - Read
APUSTATUSR_P1 = %00000001 ; Pulse 1 length counter > 0 (N) - Read

; still confused about this APU Register
APUFRCTRL = $4017
APUFRCTRL_M = %10000000 ; Mode (M, 0 = 4-step, 1 = 5-step)
APUFRCTRL_I = %01000000 ; IRQ inhibit flag (I)

