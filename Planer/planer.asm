.Include "2313def.inc"

;Задание символических имен регистрам
.def temp=r16
.def merc=r17
.def time=r18
.def razr=r19

.org 0	
	rjmp Main		;
.org 5	
	rjmp OVF1		;
.org 6	
	rjmp OVF0		;

Main:	ldi temp, LOW(RAMEND)	
		out spl, temp	;Иницмализация стека
		ldi temp, $ff	;port_init
		out ddrb, temp	;
		out ddrd, temp	;
		out portd, temp	;
	;вкл Таймер
		ldi temp, $04	;=$05
		out tccr0, temp	;Таймер0 =1/4сек	
		out tccr1b, temp;Таймер1 =10сек
		ldi temp, $82	;
		out timsk, temp	;
		sei				;разрешение прерываний
	;Reset
		clr temp
		ldi merc, $49
		clr time
		out portb, merc
				
cycle:	rjmp cycle		;

	;Вектор прерываний мерцания
OVF0:	lsl merc		;сдвиг влево
	 	sbrc merc, 3	;
		ori merc, $01	;установить 0-й бит
		out portb, merc	;
	reti				;

;s_m_0:	ori merc, $01	;установить 0-й бит
;		out portb, merc	;
;	reti
;
;brcs s_m_0		;переход если установлен бит переполнения

	;Вектор прерываний времени
OVF1:	inc temp		;зажержка
		cpi temp, $12	;=$12 =5мин
		brne ret_i		;
		inc time		;полный цикл 0+15=16 долей
		cpi time, $01	;
		breq razr_m		;
		cpi time, $02	;
		breq razr_m		;
		cpi time, $03	;
		breq on			;
		cpi time, $04	;
		breq on	;
		cpi time, $05	;
		breq on			;
		cpi time, $06	;
		breq on			;
		cpi time, $07	;
		breq on			;
		cpi time, $08	;
		breq on			;
		cpi time, $09	;
		breq on			;
		cpi time, $0a	;
		breq on			;
		cpi time, $0b	;
		breq zapr_m		;
		cpi time, $0c	;
		breq off		;
		cpi time, $0d	;
		breq off		;
		cpi time, $0e	;
		breq off		;
		cpi time, $0f	;
		breq off		;итого 4x15=60мин
		clr time		;
	rjmp OVF1			;

razr_m: ldi merc, $ee	;
on: 	ldi temp, $ff	;включить на portd
		out portd, temp	;
	reti

zapr_m: clr merc		;
off:	ldi temp, $00	;выключиь на portd
		out portd, temp	;
ret_i:	reti



;Main:	ldi temp, LOW(RAMEND)	
;		out spl, temp	;Иницмализация стека
;		ldi temp, $ff	;port_init
;		out ddrb, temp	;
;		out ddrd, temp	;
;		out portd, temp	;
;	;вкл Таймер
;		ldi temp, $05	;=$05
;		out tccr0, temp	;Таймер0 =1/4сек	
;		out tccr1b, temp;Таймер1 =10сек
;		ldi temp, $82	;
;		out timsk, temp	;
;		sei				;разрешение прерываний
;	;Reset
;		clr temp
;		clr merc
;		clr time
;				
;cycle:	rjmp cycle		;
;
;	;Вектор прерываний мерцания
;OVF0: 	lsl merc		;сдвиг влево
;		brcc s_m_0		;переход если не установлен бит переполнения
;		ori merc, $01	;установить 0-й бит
;		out portb, merc	;
;	reti				;
;
;s_m_0:	out portb, merc	;
;	reti
;
;	;Вектор прерываний времени
;OVF1:	inc temp		;зажержка
;		cpi temp, $12	;=$12 =5мин
;		brne ret_i		;
;		inc time		;полный цикл 0+15=16 долей
;		cpi time, $01	;
;		breq zapr_m		;
;		cpi time, $02	;
;		breq razr_m		;
;		cpi time, $03	;
;		breq on			;
;		cpi time, $04	;
;		breq on	;
;		cpi time, $05	;
;		breq on			;
;		cpi time, $06	;
;		breq on			;
;		cpi time, $07	;
;		breq on			;
;		cpi time, $08	;
;		breq on			;
;		cpi time, $09	;
;		breq on			;
;		cpi time, $0a	;
;		breq on			;
;		cpi time, $0b	;
;		breq zapr_m		;
;		cpi time, $0c	;
;		breq off		;
;		cpi time, $0d	;
;		breq off		;
;		cpi time, $0e	;
;		breq off		;
;		cpi time, $0f	;
;		breq off		;итого 4x15=60мин
;		clr time		;
;	rjmp OVF1			;
;
;razr_m: ldi merc, $ee	;
;on: 	ldi temp, $ff	;включить на portd
;		out portd, temp	;
;	reti
;
;zapr_m: clr merc		;
;off:	ldi temp, $00	;выключиь на portd
;		out portd, temp	;
;ret_i:	reti
