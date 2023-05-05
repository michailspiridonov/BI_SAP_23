; podprogramy pro praci s displejem
.org 0x1000 ; <1>
.include "./printlib.inc"

; Zacatek programu - po resetu
.org 0
    jmp start

; Zacatek programu - hlavni program
.org 0x100
start:
    ; Inicializace displeje
    call init_disp
    ; 0x
    ldi r16, '0'
    ldi r17, 0
    call show_char
    ldi r16, 'x'
    ldi r17, 1
    call show_char
    ; *** ZDE DEFIMICE ZOBRAZOVANEHO CISLA
    ldi r22, 0x99
    ldi r23, 10
    mov r21, r22
    lsr r21
    lsr r21
    lsr r21
    lsr r21
    cp r21, r23
    brlt lt
    cp r21, r23
    brge mt
lt:
    ldi r16, 48
    rjmp pf
mt:
    ldi r16, 55
    rjmp pf
pf:
    add r16, r21
    ldi r17, 2
    call show_char
    mov r21, r22
    ldi r20, 0b00001111
    and r21, r20
    cp r21, r23
    brlt lt2
    cp r21, r23
    brge mt2
lt2:
    ldi r16, 48
    rjmp ps
mt2:
    ldi r16, 55
    rjmp ps
ps:
    add r16, r21
    ldi r17, 3
    call show_char
    

end: jmp end        ; Zastavime program - nekonecna smycka
