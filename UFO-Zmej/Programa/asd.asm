.Include "2313def.inc"

;������� ������������� ���� ���������
.def temp=r16
.def merc=r17
.def time=r18
.def razr=r19
.def temp2=r20

.org 0	
	rjmp Main			;
.org 5	
	rjmp OVF1			;
.org 6	
	rjmp OVF0			;

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
		clr razr
		ldi merc, $ff
		clr time
					
cycle:	rjmp cycle		;

	;������ ���������� ��������
OVF0:	cpi razr, $ff		;
		brne ret_i		;
	
		inc temp2
		sbrc temp2, 3
			rjmp ovf0a
		sbrc temp2, 5
			rjmp ovf0a
		sbrc temp2, 6
			clr temp2
		clr merc
		out portb, merc		;
		out portd, merc
		reti

ovf0a:	ser merc
		out portb, merc		;
		out portd, merc
	reti


;OVF0:	inc temp2		;��������
;		cpi temp2, $04	;� 16 ���
;			brne ret_i		;
;		clr temp2
;		cpi razr, $ff	;
;			brne ret_i		;
;		com merc
;		out portb, merc	;
;		out portd, merc
;	reti

OVF1:	inc temp		;��������
		cpi temp, $20	;=$20 =4���
		brne ret_i		;
	inc time		;������ ���� 0+15=16 �����
		cpi time, $01	;
		breq zapr_m		
		cpi time, $02	;
		breq zapr_m		
		cpi time, $03	;
		breq razr_m		
		cpi time, $04	;
		breq razr_m
		cpi time, $05	;
		breq razr_m
		cpi time, $06	;
		breq razr_m
		cpi time, $07	;
		breq razr_m
		cpi time, $08	;
		breq razr_m
		cpi time, $09	;
		breq razr_m
		cpi time, $0a	;
		breq razr_m
		cpi time, $0b	;
		breq razr_m
		cpi time, $0c	;
		breq zapr_m
		cpi time, $0d	;
		breq zapr_m
		cpi time, $0e	;
		breq zapr_m
		cpi time, $0f	;
		breq zapr_m		;����� 4x15=60���
		clr time		;
	rjmp OVF1			;

razr_m: ser razr
		ser merc
	 	ldi temp, $ff	;�������� �� portd
		out portb, temp
		out portd, temp	;
	reti

zapr_m: clr razr
		clr merc		;
		ldi temp, $00	;�������� �� portd
		out portd, temp	;
		out portb, temp
ret_i:	reti
