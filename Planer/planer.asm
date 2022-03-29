.Include "2313def.inc"

;������� ������������� ���� ���������
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
		out spl, temp	;������������� �����
		ldi temp, $ff	;port_init
		out ddrb, temp	;
		out ddrd, temp	;
		out portd, temp	;
	;��� ������
		ldi temp, $04	;=$05
		out tccr0, temp	;������0 =1/4���	
		out tccr1b, temp;������1 =10���
		ldi temp, $82	;
		out timsk, temp	;
		sei				;���������� ����������
	;Reset
		clr temp
		ldi merc, $49
		clr time
		out portb, merc
				
cycle:	rjmp cycle		;

	;������ ���������� ��������
OVF0:	lsl merc		;����� �����
	 	sbrc merc, 3	;
		ori merc, $01	;���������� 0-� ���
		out portb, merc	;
	reti				;

;s_m_0:	ori merc, $01	;���������� 0-� ���
;		out portb, merc	;
;	reti
;
;brcs s_m_0		;������� ���� ���������� ��� ������������

	;������ ���������� �������
OVF1:	inc temp		;��������
		cpi temp, $12	;=$12 =5���
		brne ret_i		;
		inc time		;������ ���� 0+15=16 �����
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
		breq off		;����� 4x15=60���
		clr time		;
	rjmp OVF1			;

razr_m: ldi merc, $ee	;
on: 	ldi temp, $ff	;�������� �� portd
		out portd, temp	;
	reti

zapr_m: clr merc		;
off:	ldi temp, $00	;�������� �� portd
		out portd, temp	;
ret_i:	reti



;Main:	ldi temp, LOW(RAMEND)	
;		out spl, temp	;������������� �����
;		ldi temp, $ff	;port_init
;		out ddrb, temp	;
;		out ddrd, temp	;
;		out portd, temp	;
;	;��� ������
;		ldi temp, $05	;=$05
;		out tccr0, temp	;������0 =1/4���	
;		out tccr1b, temp;������1 =10���
;		ldi temp, $82	;
;		out timsk, temp	;
;		sei				;���������� ����������
;	;Reset
;		clr temp
;		clr merc
;		clr time
;				
;cycle:	rjmp cycle		;
;
;	;������ ���������� ��������
;OVF0: 	lsl merc		;����� �����
;		brcc s_m_0		;������� ���� �� ���������� ��� ������������
;		ori merc, $01	;���������� 0-� ���
;		out portb, merc	;
;	reti				;
;
;s_m_0:	out portb, merc	;
;	reti
;
;	;������ ���������� �������
;OVF1:	inc temp		;��������
;		cpi temp, $12	;=$12 =5���
;		brne ret_i		;
;		inc time		;������ ���� 0+15=16 �����
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
;		breq off		;����� 4x15=60���
;		clr time		;
;	rjmp OVF1			;
;
;razr_m: ldi merc, $ee	;
;on: 	ldi temp, $ff	;�������� �� portd
;		out portd, temp	;
;	reti
;
;zapr_m: clr merc		;
;off:	ldi temp, $00	;�������� �� portd
;		out portd, temp	;
;ret_i:	reti
