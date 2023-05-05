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
    ldi r16, 5    ; znak
    ldi r17, 10
    ldi r18, 58
    ldi r19, 3
    mul r17, r19
    lsl r16
    lsl r16
    add r16, r0
    sub r16, r18
    
    
    
    call show_char  ; zobraz znak z R16 na pozici z R17

end: jmp end        ; Zastavime program - nekonecna smycka
