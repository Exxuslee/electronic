.Include "2313def.inc"

;������� ������������� ���� ���������
.def temp=r16
.def merc=r17
.def time=r18
.def razr=r19

.org 0	
	rjmp Main		;
.org 1
	rjmp Ext		;
.org 2
	rjmp Ext		;

Main:	ldi temp, LOW(RAMEND)	
		out spl, temp	;������������� �����
		ldi temp, $00	;port_init
		out ddrb, temp	;
		ldi temp, $ff	;
		out ddrd, temp	;

	;��� ���� ����������
		ldi temp, $c0	;
		out gimsk, temp	;
		ldi temp, $0b	;
		out mcucr, temp	;
	;��� ����_����������
		ldi temp, $09	;
		out ucr, temp	;���������� �����������
				
	;Reset
		clr temp
		clr merc
		clr time
		sei				;���������� ����������
		
		ldi temp, $aa
		out udr, temp
				
cycle:	sbi portd, 4	;��-���������
		cbi portd, 4	;
		sbi portd, 4	;2
		cbi portd, 4	;
		sbi portd, 4	;3
		cbi portd, 4	;
		sbi portd, 4	;4
		cbi portd, 4	;
		sbi portd, 4	;5
		cbi portd, 4	;
		sbi portd, 4	;6
		cbi portd, 4	;
		sbi portd, 4	;7
		cbi portd, 4	;
		sbi portd, 4	;8
		cbi portd, 4	;
	rjmp cycle		;

	;������ ���������� ��������
Ext:	in temp, portb	;
		out udr, temp	;
	reti				;

