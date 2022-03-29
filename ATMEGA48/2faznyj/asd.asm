;******************************
;* ФОРМИРОВАТЕЛЬ ИМП. для устройства TPU, на базе ATMEGA88PA-20AU
;*
;* RC3       - выходная шина управления ключом T4
;* RC4	     - выходная шина управления фазой 1
;* RC5	     - выходная шина управления фазой 2
;* RC1	     - выходная шина управления фазой 3
;* RB0(INT0) - входная шина для подачи импульсов синхронизации
;**********************************************************************************
;* РАЗРЯДЫ КОНФИГУРАЦИИ
;*********************************************************************************
;* Сброс при снижении питания - отключино
;* Защита программы           - отключено
;* Таймер включения питания   - включено
;* Сторожевой таймер          - отключено
;* Режим генератора           - HS (20МГц)
;**********************************************
        .include "m48def.inc"


.DSEG 


bi0:	.BYTE 1
bi1:	.BYTE 1
bi2:	.BYTE 1
bi3:	.BYTE 1




        .CSEG
rjmp reset    ;1234567890
rjmp int00   ; ВНЕШНЕЕ ПРЕРЫВАНИЕ ПО ВХОДУ INT0
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START
rjmp START


reset:
; инициализация стека
ldi r16,high(RAMEND)
; Старший байт
out SPH,r16
; Младший байт
ldi r16,low(RAMEND)
out SPL,r16



           
        ldi r20,$ff
        out DDRC,r20     ;PORTC - выхода, 

		ldi r19,0  ; НОМЕР ФАЗЫ 


end2:
ldi r16,$1    ; 
out EIMSK,r16  ; ПРЕРЫВАНИЕ только INT0
ldi r16,3
sts EICRA,r16; ПРЕРЫВАНИЕ ПО ПЕРЕДНЕМУ ФРОНТУ

sei  


START:
nop

rjmp START


int00:
	cli 	

	cpi r19,0
	breq FAZA_0
	cpi r19,1
	breq FAZA_1
	cpi r19,2
	breq FAZA_2

	ldi r19,$0

		cbi	PORTC, 5
		reti

FAZA_0:
		ldi r19 , 1

		sbi PORTC, 1
		sbi PORTC, 5
		reti

FAZA_1:
		ldi r19 , 2

		cbi PORTC, 5
		reti

FAZA_2:
		ldi r19 , 3

		cbi PORTC, 1
		sbi PORTC, 5
		reti

