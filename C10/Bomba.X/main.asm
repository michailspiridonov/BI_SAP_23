.dseg                ; prepnuti do pameti dat 1
.org 0x100           ; od adresy 0x100 (adresy 0 - 0x100 nepouzivejte)

flag: .byte 1        ; rezervovani mista pro 1 bajt

.cseg                ; prepnuti do pameti programu
; podprogramy pro praci s displejem (Pri refactoru jsem vetsinu podprogramu dal do printlib na konec r. 293+) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
    ; Inicializace AD prevodniku
    call init_button
    call init_disp
    ldi r30, low(2*retez)
    ldi r31, high(2*retez)
    ldi r20, 0 ;mins
    ldi r21, 0 ;sec
    ldi r29, 25
    ldi r24, 0
    call init_int
    ldi r16, 0
    sts flag, r16
    call print_minutes
    ldi r16, ':'
    ldi r17, 7
    call show_char
    ldi r18, 0 ;blinker
    call print_seconds
    
set_minutes:
    call set_sel_btn_flag
    call set_up_btn_flag
    call set_down_btn_flag
    call is_free; Toto blokuje vsechny tlacitka -> nejde drzet "up/down", da se vyresit kotrolou "neselectu" (misto uvolneni [0b1111??????] -> ![0b1001??????])
    cpi r28, 1
    brne set_minutes ;Not free, loop
    ; int check
    lds r23, flag
    cpi r23, 0
    breq set_minutes
    ; flag reset
    ldi r23, 0  
    sts flag, r23
    ; logic
    inc r18
    call min_print
    cpi r24, 1
    breq sec_set
    cpi r24, 2
    breq inc_min
    cpi r24, 3
    breq dec_min
    jmp set_minutes
    
 inc_min:
    ldi r24, 0
    call add_min
    jmp set_minutes

dec_min:
    ldi r24, 0
    call sub_min
    jmp set_minutes
    
sec_set:
    ldi r24, 0
    ldi r18, 0
    call print_minutes
set_seconds:
    call set_sel_btn_flag
    call set_up_btn_flag
    call set_down_btn_flag
    call is_free     ; Toto blokuje vsechny tlacitka -> nejde drzet "up/down", da se vyresit kotrolou "neselectu" (misto uvolneni [0b1111??????] -> ![0b1001??????])
    cpi r28, 1
    brne set_seconds ;Not free, loop
    ; int check
    lds r23, flag
    cpi r23, 0
    breq set_seconds
    ; flag reset
    ldi r23, 0  
    sts flag, r23
    ; logic
    inc r18
    call sec_print
    cpi r24, 1
    breq init_main
    cpi r24, 2
    breq inc_sec
    cpi r24, 3
    breq dec_sec
    jmp set_seconds
    
inc_sec:
    ldi r24, 0
    call add_sec
    jmp set_seconds

dec_sec:
    ldi r24, 0
    call sub_sec
    jmp set_seconds
    
dec_sec_r_p:
    cpi r24, 4
    breq pr_down
    
dec_sec_r:
    dec r21
    cpi r21, 255
    breq dec_min_r
    jmp main_loop

dec_min_r:
    cpi r20, 0
    breq blink
    dec r20
    ldi r21, 59
    jmp main_loop
   
 pr_down:
    call print_down
    jmp dec_sec_r
    
init_main:
    ldi r24, 0
    ldi r29, 61 ; Nastavime presuseni zpatky na jednou/sek
    call init_int
main_loop:
    call set_right_btn_flag
    lds r23, flag
    cpi r23, 0       ; nacteni a otestovani hodnoty flag-u
    breq main_loop   ; pokud neni flag -> navrat na zacatek
                     ; je flag
    ldi r23, 0       ; vycisteni flag-u
    sts flag, r23

    ; akce provedena 1x za sekundu 4
    call print_minutes
    call print_seconds
    jmp dec_sec_r_p
    
restart:
    jmp start
    
blink:
    ldi r29, 25
    ldi r24, 0
    call init_int
    ldi r17, 0
    ldi r18, 0
    ldi r19, 0
    ldi r20, 0
    ldi r21, 0
    call clear_down
blink_loop:
    lds r23, flag
    cpi r23, 0
    breq blink_loop
    ldi r23, 0  
    sts flag, r23
    inc r18
    call sec_print
    call min_print
    inc r19
    cpi r19, 8
    breq print_string
    jmp blink_loop
    
print_string:
    ldi r22, 0
    lpm r16, Z+
    cpi r16, 0
    breq reset_loop
    call show_char
    inc r17
    jmp print_string
    
reset_loop:
    call set_sel_btn_flag
    ; int check
    lds r23, flag
    cpi r23, 0
    breq reset_loop
    ; reset int
    ldi r23, 0  
    sts flag, r23
    ; logic
    cpi r24, 1
    breq restart
    jmp reset_loop
    
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
    ldi r16, (1<<WGM12) | (0b101<<CS10)
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
    mov r16, r29
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