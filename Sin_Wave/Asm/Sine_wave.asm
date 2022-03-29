.Include "tn2313def.inc"

;Задание символических имен регистрам
.def temp = r30
.def tik  = r31

.org 0
	rjmp Main			;
.org 7	
		rjmp UART_RXC	;


Main:	ldi temp, $df
		out spl, temp	;Иницмализация стека

// Port initialization
		ldi temp, $ff	;
		out ddrb, temp	;
		ldi temp, $02	;
		out ddrd, temp	;
		



// UART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// UART Receiver: On
// UART Transmitter: Off
// UART Baud Rate: 56000
		ldi temp, $90		;	
		out UCR, temp		;
		ldi temp, $08		;
		out UBRR, temp		;


		sei				;разрешение прерываний

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

Start:	
			OUT PORTB,R0
start_1:	inc temp
			cp tik, temp
			brne start_1

			OUT PORTB,R1
start_2:	dec temp
			cpi temp, 0
			brne start_2

			OUT PORTB,R2
start_3:	inc temp
			cp tik, temp
			brne start_3

			OUT PORTB,R3
start_4:	dec temp
			cpi temp, 0
			brne start_4

			OUT PORTB,R4
start_5:	inc temp
			cp tik, temp
			brne start_5

			OUT PORTB,R5
start_6:	dec temp
			cpi temp, 0
			brne start_6

			OUT PORTB,R6
start_7:	inc temp
			cp tik, temp
			brne start_7

			OUT PORTB,R7
start_8:	dec temp
			cpi temp, 0
			brne start_8

			OUT PORTB,R8
start_9:	inc temp
			cp tik, temp
			brne start_9

			OUT PORTB,R9
start_10:	dec temp
			cpi temp, 0
			brne start_10

			OUT PORTB,R10
start_11:	inc temp
			cp tik, temp
			brne start_11

			OUT PORTB,R11
start_12:	dec temp
			cpi temp, 0
			brne start_12

			OUT PORTB,R12
start_13:	inc temp
			cp tik, temp
			brne start_13

			OUT PORTB,R13
start_14:	dec temp
			cpi temp, 0
			brne start_14

			OUT PORTB,R14
start_15:	inc temp
			cp tik, temp
			brne start_15

			OUT PORTB,R15
start_16:	dec temp
			cpi temp, 0
			brne start_16

			OUT PORTB,R16
start_17:	inc temp
			cp tik, temp
			brne start_17

			OUT PORTB,R17
start_18:	dec temp
			cpi temp, 0
			brne start_18

			OUT PORTB,R18
start_19:	inc temp
			cp tik, temp
			brne start_19

			OUT PORTB,R19
start_20:	dec temp
			cpi temp, 0
			brne start_20

			OUT PORTB,R20
start_21:	inc temp
			cp tik, temp
			brne start_21

			OUT PORTB,R21
start_22:	dec temp
			cpi temp, 0
			brne start_22

			OUT PORTB,R22
start_23:	inc temp
			cp tik, temp
			brne start_23

			OUT PORTB,R23
start_24:	dec temp
			cpi temp, 0
			brne start_24

			OUT PORTB,R24
start_25:	inc temp
			cp tik, temp
			brne start_25

			OUT PORTB,R25
start_26:	dec temp
			cpi temp, 0
			brne start_26

			OUT PORTB,R26
start_27:	inc temp
			cp tik, temp
			brne start_27

			OUT PORTB,R27
start_28:	dec temp
			cpi temp, 0
			brne start_28

			OUT PORTB,R28
start_29:	inc temp
			cp tik, temp
			brne start_29

			OUT PORTB,R29
start_30:	dec temp
			cpi temp, 0
			brne start_30

			OUT PORTB,R29
start_31:	inc temp
			cp tik, temp
			brne start_31

			OUT PORTB,R29
start_32:	dec temp
			cpi temp, 0
			brne start_32

			OUT PORTB,R28
start_33:	inc temp
			cp tik, temp
			brne start_33

			OUT PORTB,R27
start_34:	dec temp
			cpi temp, 0
			brne start_34

			OUT PORTB,R26
start_35:	inc temp
			cp tik, temp
			brne start_35

			OUT PORTB,R25
start_36:	dec temp
			cpi temp, 0
			brne start_36

			OUT PORTB,R24
start_37:	inc temp
			cp tik, temp
			brne start_37

			OUT PORTB,R23
start_38:	dec temp
			cpi temp, 0
			brne start_38

			OUT PORTB,R22
start_39:	inc temp
			cp tik, temp
			brne start_39

			OUT PORTB,R21
start_40:	dec temp
			cpi temp, 0
			brne start_40

			OUT PORTB,R20
start_41:	inc temp
			cp tik, temp
			brne start_41

			OUT PORTB,R19
start_42:	dec temp
			cpi temp, 0
			brne start_42

			OUT PORTB,R18
start_43:	inc temp
			cp tik, temp
			brne start_43

			OUT PORTB,R17
start_44:	dec temp
			cpi temp, 0
			brne start_44

			OUT PORTB,R16
start_45:	inc temp
			cp tik, temp
			brne start_45

			OUT PORTB,R15
start_46:	dec temp
			cpi temp, 0
			brne start_46

			OUT PORTB,R14
start_47:	inc temp
			cp tik, temp
			brne start_47

			OUT PORTB,R13
start_48:	dec temp
			cpi temp, 0
			brne start_48

			OUT PORTB,R12
start_49:	inc temp
			cp tik, temp
			brne start_49

			OUT PORTB,R11
start_50:	dec temp
			cpi temp, 0
			brne start_50

			OUT PORTB,R10
start_51:	inc temp
			cp tik, temp
			brne start_51

			OUT PORTB,R9
start_52:	dec temp
			cpi temp, 0
			brne start_52

			OUT PORTB,R8
start_53:	inc temp
			cp tik, temp
			brne start_53

			OUT PORTB,R7
start_54:	dec temp
			cpi temp, 0
			brne start_54

			OUT PORTB,R6
start_55:	inc temp
			cp tik, temp
			brne start_55

			OUT PORTB,R5
start_56:	dec temp
			cpi temp, 0
			brne start_56

			OUT PORTB,R4
start_57:	inc temp
			cp tik, temp
			brne start_57

			OUT PORTB,R3
start_58:	dec temp
			cpi temp, 0
			brne start_58

			OUT PORTB,R2
start_59:	inc temp
			cp tik, temp
			brne start_59

			OUT PORTB,R1
start_60:	dec temp
			cpi temp, 0
			brne start_60

		rjmp Start		;


UART_RXC:
		in tik, UDR
		reti
		
		
		
		
		
				

