.Include "tn2313def.inc"

;Задание символических имен регистрам
.def temp = r30
.def tik  = r31

.org 0
		rjmp Main			;
.org 1	
		rjmp EXT_INT_0	;
.org 2	
		rjmp EXT_INT_1	;


Main:	ldi temp, $df
		out spl, temp	;Иницмализация стека

// Port initialization
		ldi temp, $ff	;
		out ddrb, temp	;


		ldi temp, $0f	; $0f
		out mcucr, temp	;
		ldi temp, $c0	;
		out gimsk, temp	;
		

		ldi r16, 0
		ldi r17, 1
		ldi r18, 3
		ldi r19, 6
		ldi r20, 11
		ldi r21, 17
		ldi r22, 24
		ldi r23, 33
		ldi r24, 42
		ldi r25, 53
		ldi r26, 64
		ldi r27, 76
		ldi r28, 88
		ldi r29, 101
		ldi r30, 115
		ldi r31, 128
		mov r0, r16
		mov r1, r17
		mov r2, r18
		mov r3, r19
		mov r4, r20
		mov r5, r21
		mov r6, r22
		mov r7, r23
		mov r8, r24
		mov r9, r25
		mov r10, r26
		mov r11, r27
		mov r12, r28
		mov r13, r29
		mov r14, r30
		mov r15, r31
		ldi r16, 141
		ldi r17, 155
		ldi r18, 168
		ldi r19, 180
		ldi r20, 192
		ldi r21, 203
		ldi r22, 214
		ldi r23, 223
		ldi r24, 232
		ldi r25, 239
		ldi r26, 245
		ldi r27, 250
		ldi r28, 253
		ldi r29, 255
		clr r30
		clr r31

		ldi tik, 33

		sei				;разрешение прерываний

Start:	
			OUT PORTB,R0
			nop
			nop
			OUT PORTB,R1
			nop
			nop
			OUT PORTB,R2
			nop
			nop
			OUT PORTB,R3
			nop
			nop
			OUT PORTB,R4
			nop
			nop
			OUT PORTB,R5
			nop
			nop
			OUT PORTB,R6
			nop
			nop
			OUT PORTB,R7
			nop
			nop
			OUT PORTB,R8
			nop
			nop
			OUT PORTB,R9
			nop
			nop
			OUT PORTB,R10
			nop
			nop
			OUT PORTB,R11
			nop
			nop
			OUT PORTB,R12
			nop
			nop
			OUT PORTB,R13
			nop
			nop
			OUT PORTB,R14
			nop
			nop
			OUT PORTB,R15
			nop
			nop
			OUT PORTB,R16
			nop
			nop
			OUT PORTB,R17
			nop
			nop
			OUT PORTB,R18
			nop
			nop
			OUT PORTB,R19			
			nop
			nop
			OUT PORTB,R20
			nop
			nop
			OUT PORTB,R21
			nop
			nop
			OUT PORTB,R22
			nop
			nop
			OUT PORTB,R23
			nop
			nop
			OUT PORTB,R24
			nop
			nop
			OUT PORTB,R25
			nop
			nop
			OUT PORTB,R26
			nop
			nop
			OUT PORTB,R27
			nop
			nop
			OUT PORTB,R28
			nop
			nop
			OUT PORTB,R29
			nop
			nop
			OUT PORTB,R29
			nop
			nop
			OUT PORTB,R29
			nop
			nop
			OUT PORTB,R28
			nop
			nop
			OUT PORTB,R27
			nop
			nop
			OUT PORTB,R26
			nop
			nop
			OUT PORTB,R25
			nop
			nop
			OUT PORTB,R24
			nop
			nop
			OUT PORTB,R23
			nop
			nop
			OUT PORTB,R22
			nop
			nop
			OUT PORTB,R21
			nop
			nop
			OUT PORTB,R20
			nop
			nop
			OUT PORTB,R19
			nop
			nop
			OUT PORTB,R18
			nop
			nop
			OUT PORTB,R17
			nop
			nop
			OUT PORTB,R16
			nop
			nop
			OUT PORTB,R15
			nop
			nop
			OUT PORTB,R14
			nop
			nop
			OUT PORTB,R13
			nop
			nop
			OUT PORTB,R12
			nop
			nop
			OUT PORTB,R11
			nop
			nop
			OUT PORTB,R10
			nop
			nop
			OUT PORTB,R9
			nop
			nop
			OUT PORTB,R8
			nop
			nop
			OUT PORTB,R7
			nop
			nop
			OUT PORTB,R6
			nop
			nop
			OUT PORTB,R5
			nop
			nop
			OUT PORTB,R4
			nop
			nop
			OUT PORTB,R3
			nop
			nop
			OUT PORTB,R2
			nop
			nop
			OUT PORTB,R1
	rjmp Start		;

EXT_INT_0:
	inc tik		;
	reti

EXT_INT_1:
	dec tik ;
	reti

		
		
		
		
		
				

