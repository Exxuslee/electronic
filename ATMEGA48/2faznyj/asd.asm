;******************************
;* ������������� ���. ��� ���������� TPU, �� ���� ATMEGA88PA-20AU
;*
;* RC3       - �������� ���� ���������� ������ T4
;* RC4	     - �������� ���� ���������� ����� 1
;* RC5	     - �������� ���� ���������� ����� 2
;* RC1	     - �������� ���� ���������� ����� 3
;* RB0(INT0) - ������� ���� ��� ������ ��������� �������������
;**********************************************************************************
;* ������� ������������
;*********************************************************************************
;* ����� ��� �������� ������� - ���������
;* ������ ���������           - ���������
;* ������ ��������� �������   - ��������
;* ���������� ������          - ���������
;* ����� ����������           - HS (20���)
;**********************************************
        .include "m48def.inc"


.DSEG 


bi0:	.BYTE 1
bi1:	.BYTE 1
bi2:	.BYTE 1
bi3:	.BYTE 1




        .CSEG
rjmp reset    ;1234567890
rjmp int00   ; ������� ���������� �� ����� INT0
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
; ������������� �����
ldi r16,high(RAMEND)
; ������� ����
out SPH,r16
; ������� ����
ldi r16,low(RAMEND)
out SPL,r16



           
        ldi r20,$ff
        out DDRC,r20     ;PORTC - ������, 

		ldi r19,0  ; ����� ���� 


end2:
ldi r16,$1    ; 
out EIMSK,r16  ; ���������� ������ INT0
ldi r16,3
sts EICRA,r16; ���������� �� ��������� ������

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

