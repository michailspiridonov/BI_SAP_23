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
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)
    ldi r17, 80
    ldi r23, 64
    ldi r24, 48
    jmp print
init:
    ldi r18, 0
    ldi r19, 1
    ldi r17, 80
print_row:
    cp r17, r24
    brlo init
    ldi r17, 80
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)
    sub r17, r19
    inc r19
    jmp print

p:
    inc r17
    cp r16, r18
    breq print_row
    call cekp              ; r20-22
    
print:
    lpm r16, Z+
    cp r17, r23
    brlo print_up
    
print_down:

    call show_char

    jmp p
    
print_up:
    sub r17, r24
    call show_char
    add r17, r24
    jmp p

cekp:
    ldi r22, 1
cek3:
    ldi r21, 1
cek2: 
    ldi r20, 10
cek: 
    dec r20
    brne cek
    dec r21
    brne cek2
    dec r22
    brne cek3
    ret
end: jmp end