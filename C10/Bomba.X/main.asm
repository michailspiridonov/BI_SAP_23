.dseg                ; prepnuti do pameti dat 1
.org 0x100           ; od adresy 0x100 (adresy 0 - 0x100 nepouzivejte)

flag: .byte 1        ; rezervovani mista pro 1 bajt

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
retez: .db "VAJICKA UVARENA",0
start:
    ; Inicializace displeje
    call init_disp
    ; Inicializace preruseni od casovace
    call init_int
    ; Inicializace AD prevodniku
    call init_button
re_start:
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)
    ldi r20, 0	    ; minutes
    ldi r21, 0	    ; seconds
    ldi r18, 0	    ; blink counter
    ldi r19, 0

    ldi r16, 0       ; 3
    sts flag, r16
    
    call print_minutes
    ldi r17, 2
    ldi r16, ':'
    call show_char
    call print_seconds
    jmp set_minutes
print_empty:
    call show_char
    inc r17
    cpi r17, 16
    breq re_start
    jmp print_empty

print_minutes:
    push r16
    push r22
    ldi r16, 0
    mov r22, r20
min_loop:
    cpi r22, 10
    brlo show_min
    subi r22, 10
    inc r16
    jmp min_loop

show_min:
    ldi r17, 0
    subi r16, -48
    call show_char
    inc r17
    mov r16, r22
    subi r16, -48
    call show_char
    pop r22
    pop r16
    ret
    
print_seconds:
    push r16
    push r22
    ldi r16, 0
    mov r22, r21
sec_loop:
    cpi r22, 10
    brlo show_sec
    subi r22, 10
    inc r16
    jmp sec_loop

show_sec:
    ldi r17, 3
    subi r16, -48
    call show_char
    inc r17
    mov r16, r22
    subi r16, -48
    call show_char
    pop r22
    pop r16
    ret
    
is_down:
    push r16
    ldi r22, 0
    call convert
    lds r16, ADCH
    swap r16
    andi r16, 0b00001111
    cpi r16, 3
    breq is_succ
    pop r16
    ret
    
is_up:
    push r16
    ldi r22, 0
    call convert
    lds r16, ADCH
    swap r16
    andi r16, 0b00001111
    cpi r16, 1
    breq is_succ
    pop r16
    ret
    
is_select:
    push r16
    ldi r22, 0
    call convert
    lds r16, ADCH
    swap r16
    andi r16, 0b00001111
    cpi r16, 9
    breq is_succ
    pop r16
    ret
is_succ:
    ldi r22, 1
    pop r16
    ret
convert:
    push r16
    push r17
    lds r17, (1<<ADSC)
    lds r16, ADCSRA
    ori r16, (1<<ADSC)
    sts ADCSRA, r16
conv_wait:
    lds r16, ADCSRA
    and r17, r16
    cpi r17, 0
    brne conv_wait
    pop r17
    pop r16
    ret
    
min_print:
    push r19
    mov r19, r18
    andi r19, 0b00000001
    cpi r19, 0
    breq min_print_0
    call print_minutes
    pop r19
    ret
min_print_0:
    call print_empty_min
    pop r19
    ret

set_minutes:
    lds r23, flag
    cpi r23, 0
    breq set_minutes
    ldi r23, 0  
    sts flag, r23
    inc r18
    call min_print
    call is_select
    cpi r22, 1
    breq ssp
    call is_down
    cpi r22, 1
    breq dec_min
    call is_up
    cpi r22, 1
    breq inc_min
    call cekp
    jmp set_minutes
    
sub_min:
    cpi r20, 60
    brlo set_minutes
    subi r20, 60
    jmp sub_min

dec_min:
    dec r20
    jmp sub_min
    
inc_min:
    inc r20
    jmp sub_min

sec_print:
    push r19
    mov r19, r18
    andi r19, 0b00000001
    cpi r19, 0
    breq sec_print_0
    call print_seconds
    pop r19
    ret
sec_print_0:
    call print_empty_sec
    pop r19
    ret
    
ssp:
    call print_minutes
set_seconds:
    lds r23, flag
    cpi r23, 0
    breq set_seconds
    ldi r23, 0  
    sts flag, r23
    inc r18
    call sec_print
    call is_select
    cpi r22, 1
    breq main_loop
    call is_up
    cpi r22, 1
    breq inc_sec
    call is_down
    cpi r22, 1
    breq dec_sec
    jmp set_seconds
    
inc_sec:
    inc r21
    jmp sub_sec

dec_sec:
    dec r21
    jmp sub_sec

sub_sec:
    cpi r21, 60
    brlo set_seconds
    subi r21, 60
    jmp sub_sec

dec_sec_r:
    dec r21
    cpi r21, 255
    breq dec_min_r
    ret

dec_min_r:
    cpi r20, 0
    breq three_zero_blink
    dec r20
    ldi r21, 59
    ret

print_empty_min:
    push r16
    push r17
    ldi r16, 0
    ldi r17, 0
    call show_char
    inc r17
    call show_char
    pop r17
    pop r16
    ret

print_empty_sec:
    push r16
    push r17
    ldi r16, 0
    ldi r17, 3
    call show_char
    inc r17
    call show_char
    pop r17
    pop r16
    ret

s:
    ldi r16, 0
    ldi r17, 0
    jmp print_empty
    
main_loop:
    lds r23, flag
    cpi r23, 0       ; nacteni a otestovani hodnoty flag-u
    breq main_loop   ; pokud neni flag -> navrat na zacatek
                     ; je flag
    ldi r23, 0       ; vycisteni flag-u
    sts flag, r23

    ; akce provedena 1x za sekundu 4
    call print_minutes
    call print_seconds
    call dec_sec_r
    

    jmp main_loop

three_zero_blink:
    ldi r17, 0
    ldi r20, 0
    ldi r21, 0
    lds r23, flag
    cpi r23, 0
    breq three_zero_blink
    ldi r23, 0  
    sts flag, r23
    inc r18
    call sec_print
    call min_print
    inc r19
    cpi r19, 9
    breq print_string
    jmp three_zero_blink
    
print_string:
    ldi r22, 0
    lpm r16, Z+
    call show_char
    inc r17
    cpi r16, 0
    breq end
    jmp print_string

end: 
    call is_select
    cpi r22, 1
    breq s
    jmp end
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
    ldi r16, (1<<WGM12) | (0b010<<CS10)
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
    
cekp:
    push r20
    push r21
    push r22
    ldi r22, 10
cek3:
    ldi r21, 10
cek2: 
    ldi r20, 10
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