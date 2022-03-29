.Include "m8def2.inc"

;Задание символических имен регистрам
.def temp=r16
.def merc=r17
.def time=r18
.def razr=r19
.def knopka=r20


.org 0
	rjmp Main			;
.org 2
	rjmp Ext_INT1		;
.org 3	
	rjmp TIMER2_COMP	;


Main:	ldi temp, $5f
		out spl, temp	;Иницмализация стека
		ldi temp, $04
		out sph, temp

// Port initialization
		ldi temp, $05	;
		out ddrb, temp	;
		ldi temp, $10	;
		out ddrc, temp	;
		ldi temp, $C3	;
		out ddrd, temp	;
		
// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Low level
		ldi temp, $80	;
		out gicr, temp	;
		out gifr, temp	;
		ldi temp, $00	;
		out mcucr, temp	;

// ADC initialization
// ADC Clock frequency: 62,500 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
		ldi temp, $ff	;
		out admux, temp	;
		ldi temp, $e7	;
		out	adcsra, temp;


// Timer/Counter initialization
		ldi temp, $45	;=$41 =$45 1/1024 Phase correct PWM
		out tccr2, temp	;
		ldi temp, $82	;
		out timsk, temp	;


		sei				;разрешение прерываний


Start:	in temp, ADCH	;
		out ocr2, temp	;

		rjmp Start		;
				


TIMER2_COMP:			;
		sbic portb, 2	;
		rjmp timer2_comp_1;
		sbi portb, 2	;
		cbi portd, 6	;
		reti;
timer2_comp_1:
		sbi portd, 6	;
		cbi portb, 2	;
		reti


Ext_INT1:	inc knopka		;
			cpi knopka, 3	;
			brne	int1_1	;
			clr knopka		;
int1_1:		cpi knopka, 0	;
			breq	int1_1_0;
			cpi knopka, 1	;
			breq	int1_1_1;
			cpi knopka, 2	;
			breq	int1_1_2;
int1_1_0:	sbi portc, 4	;
			cbi portd, 1	;
			cbi portd, 0	;
			rjmp int1_2		;
int1_1_1:	sbi portd, 1	;
			cbi portd, 0	;
			cbi portc, 4	;
			rjmp int1_2		;
int1_1_2:	sbi portd, 0	;
			cbi portd, 1	;
			cbi portc, 4	;
			nop				;			
int1_2:		sbis pind, 3	; ждем пока кнопка нажата
			rjmp int1_2		;
			reti			;
