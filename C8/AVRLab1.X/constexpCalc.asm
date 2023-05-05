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
    
    ; *** ZDE muzeme psat nase instrukce
    ldi r16, 40    ; znak
    ldi r17, 80
    ldi r18, 58
    ldi r19, 3
    mul r17, r19
    brvs ov
    lsl r16
    brvs ov
    lsl r16
    brvs ov
    add r16, r0
    brvs ov
    sub r16, r18
    brvs ov
    asr r16
    brcs ca
    asr r16
    brcs ca
    asr r16
    brcs ca
    jmp end;
ov:
    jmp ov;
ca:
    jmp ca;

end: jmp end        ; Zastavime program - nekonecna smycka
