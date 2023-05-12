.dseg                ; prepnuti do pameti dat 1
.org 0x100           ; od adresy 0x100 (adresy 0 - 0x100 nepouzivejte)

flag: .byte 1 

.cseg                ; prepnuti do pameti programu
; podprogramy pro praci s displejem
.org 0x1000
.include "printlib.inc"
 
; Zacatek programu - po resetu
.org 0
    jmp	start
.org 0x16            ; 2
    jmp interrupt

.org 0x100
retez: .db "NEBUDE-LI PRSET, NEZMOKNEM",0
 
start:
    call init_disp
    call init_int
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)
    ldi r17, 79
    ldi r19, 0
    
print_row:
    lds r23, flag
    cpi r23, 0
    breq print_row
    ldi r23, 0  
    sts flag, r23
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
    
 init_int:            ; 5
    push r16
    cli ; globalni zakazani preruseni

    ; vycisteni aktualni hodnoty citace TCNT1 (aby prvni sekunda nezacala nekde "od pulky")
    clr r16
    ; Neprehazujte poradi nahravani TCNT1H a TCNT1L - hodnota by se nemusela spravne ulozit!
    sts TCNT1H, r16
    sts TCNT1L, r16

    ; povoleni preruseni ve chvili, kdy citac TCNT1 dosahne hodnoty OCR1A
    ldi r16, (1<<OCIE1A)
    sts TIMSK1, r16

    ; nastaveni cisteni citace TCNT1 ve chvili, kdy dosahne hodnoty OCR1A (1<<WGM12)
    ; nastaveni preddelicky na 1024 (0b101<<CS10 - bity CS12, CS11 a CS10 jsou za sebou)
    ldi r16, (1<<WGM12) | (0b100<<CS10)
    sts TCCR1B, r16

    ; nastaveni OCR1A, tj. vysledne frekvence preruseni
    ; frekvence preruseni = frekvence cipu 328P / preddelicka / (OCR1A+1)
    ; frekvence cipu 328P je 16 MHz, tj. 16000000
    ; preddelicka je nastavena na 1024
    ; frekvenci preruseni chceme na 1 Hz
    ; OCR1A = (frekvence cipu 328P / preddelicka / frekvence preruseni) - 1
    ; OCR1A = (16000000 / 1024 / 1) - 1
    ; OCR1A = 15624
    ; 16bitovou hodnotu je treba nastavit do dvou registru OCR1AH:OCR1AL
    ; 15624 = 61 * 256 + 8
    ; Neprehazujte poradi nahravani OCR1AH a OCR1AL - hodnota by se nemusela spravne ulozit!
    ldi r16, 61
    sts OCR1AH, r16
    ldi r16, 8
    sts OCR1AL, r16

    ; zakazani preruseni od tlacitek
    clr r16
    out EIMSK, r16

    sei ; globalni povoleni preruseni
    pop r16
    ret
    
init_button:
    push r16
    ; povoleni AD prevodniku (nastaveni bitu ADEN v pameti na adrese ADCSRA bez ovlivneni ostatnich bitu) 1
    lds r16, ADCSRA
    ori r16, (1<<ADEN); 2
    sts ADCSRA, r16

    ; nastaveni referencniho napeti (0b01<<REFS0)
    ; nastaveni zarovnani vystupu vlevo (1<<ADLAR); 3
    ldi r16, (0b01<<REFS0) | (1<<ADLAR); 4
    sts ADMUX, r16

    pop r16
    ret

interrupt:           ; 6
    ; uklid registru a SREG
    push r16
    in r16, SREG
    push r16

    ; nastav flag
    ldi r16, 1
    sts flag, r16

    ; obnoveni SREG a registru
    pop r16
    out SREG, r16
    pop r16
    reti             ; 7

end: jmp end