.cseg ; nasledujici umistit do pameti programu (implicitni)
; Zacatek programu - po resetu
.org 0
    jmp start

.org 0x100
retez: .db "NEBUDE-LI PRSET NEZMOKNEM",0 ; retezec zakonceny nulou (nikoli znakem "0") 1

.include "./printlib.inc"
.org 0x1FF
start:
    call init_disp
    ldi r30, low(2*retez) ; 2
    ldi r31, high(2*retez)
    ldi r17, 0
    ldi r18, 0
    jmp print
print:
    lpm r16, Z+
    cp r16, r17
    breq end
    call show_char
    call cekp              ; vyuziva r20-22
    jmp print
    ;lpm r16, Z+           ; nahraj dalsi bajt (znak) z retezce do r16, posun pozici v retezci
    ; ...
print_row:
    ldi r19, 16
    sub r19, r18           ; tu muze byt overflow
p:
    ldi r17, r19
    
cekp:
    ldi r22, 90
cek3:
    ldi r21, 200
cek2: 
    ldi r20, 200
cek: 
    dec r20
    brne cek
    dec r21
    brne cek2
    dec r22
    brne cek3
    ret
end: jmp end