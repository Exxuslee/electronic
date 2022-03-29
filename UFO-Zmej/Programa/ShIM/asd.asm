.Include "2313def.inc"

;Задание символических имен регистрам
.def temp=r16
.def delay=r17
.def shim=r18
.def delay2=r19
.def time=r20

.org 0	
	rjmp Main			;
.org 5	
	rjmp OVF1			;
.org 6	
	rjmp OVF0			;

Main:	ldi temp, LOW(RAMEND)	
		out spl, temp	;Иницмализация стека
		ldi temp, $ff	;port_init
		out ddrd, temp	;
		out portd, temp
		ldi temp, $00
		out ddrb, temp
		
	;вкл Таймер
		ldi temp, $05	;=$05
		out tccr0, temp	;Таймер0 =1/4сек
		ldi temp, $01	;=$01
		out tccr1b, temp;Таймер1 =10сек
		ldi temp, $c1	;=$c1 таймер1 в режим ШИМ
		out tccr1a, temp	;

		ldi temp, $82	;=$82
		out timsk, temp	;
		sei				;разрешение прерываний
	;Reset
		clr temp
		clr delay
		clr shim
		clr delay2
		clr time
	
cykle:	cpi time, $30
			brlo cykle
		ldi temp, $00	; хреновый нерабочий цикл
		sbic portb, 3	;
			ldi temp, $ff
		out portd, temp	;
		rjmp cykle		;


OVF0:	inc delay2		;задержка 7 минут цикл
		cpi delay2, $50	;=$80
			brne ret_i	;
		clr delay2		;

		inc time		;
		cpi time, $10	;
			breq zapr_m		
		cpi time, $20	;
			breq zapr_m		
		cpi time, $30	;
			breq razr_m		
		cpi time, $40	;
			breq razr_m
		cpi time, $50	;
			breq razr_m
		cpi time, $60	;
			breq razr_m
		cpi time, $70	;
			breq razr_m
		cpi time, $80	;
			breq razr_m
		cpi time, $90	;
			breq razr_m
		cpi time, $a0	;
			breq razr_m
		cpi time, $b0	;
			breq razr_m
		cpi time, $c0	;
			breq zapr_mm
		cpi time, $d0	;
			breq zapr_m
		cpi time, $e0	;
			breq zapr_m
		cpi time, $f0	;
			breq zapr_m	;
	reti		;		

razr_m:	ldi temp, $ff
		out portd, temp
		out ddrb, temp
		reti

zapr_m:	ldi temp, $00
		out portd, temp
		out ddrb, temp
		reti

zapr_mm:ldi temp, $00
		out portd, temp
		out ddrd, temp
		out ddrb, temp
		reti

OVF1: 	inc delay
		cpi delay, $50	;=$50
			brne ret_i
		clr delay
		inc shim	;
		out OCR1al, shim	;

ret_i:	reti
