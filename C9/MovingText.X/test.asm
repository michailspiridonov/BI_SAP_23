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
    ldi r17, 79
    ldi r19, 0
    
print_row:
    call cekp
    cpi r17, 48
    brlo start
    ldi r17, 79
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)
    sub r17, r19
    inc r19
    jmp print

p: 
    inc r17
    cpi r16, 0
    breq print_row
    cpi r17, 80
    breq print_row
    cpi r17, 80
    brsh p
    
print:
    lpm r16, Z+
    cpi r17, 64
    brlo print_up
    
print_down:
    cpi r16, 0
    breq print_space
    call show_char
    jmp p
    
print_up:
    cpi r16, 0
    breq print_space_u
    subi r17, 48
    cpi r17, 80
    brsh break_print
    call show_char
    subi r17, -48
    jmp p

break_print:
    subi r17, -48
    jmp p
    
print_space_u:
    ldi r16, ' '
    subi r17, 48
    call show_char
    subi r17, -48
    ldi r16, 0
    jmp p
    
print_space:
    ldi r16, ' '
    call show_char
    ldi r16, 0
    jmp p

cekp:
    push r20
    push r21
    push r22
    ldi r22, 50
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
    pop r22
    pop r21
    pop r20
    ret
end: jmp end