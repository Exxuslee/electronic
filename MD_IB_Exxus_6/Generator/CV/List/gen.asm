
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATtiny2313
;Clock frequency        : 16,384000 MHz
;Memory model           : Tiny
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 64 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;global const stored in FLASH  : Yes
;8 bit enums            : No
;Enhanced core instructions    : Off
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _on1=R3
	.DEF _ona=R2
	.DEF _onb=R5
	.DEF _data=R4
	.DEF _amp=R7
	.DEF _faza=R6
	.DEF _a=R9

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compb_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GPIOR0-GPIOR2 INITIALIZATION
	.EQU  __GPIOR0_INIT=0x00
	.EQU  __GPIOR1_INIT=0x00
	.EQU  __GPIOR2_INIT=0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	LDI  R30,__GPIOR1_INIT
	OUT  GPIOR1,R30
	LDI  R30,__GPIOR2_INIT
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xA0)
	LDI  R29,HIGH(0xA0)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xA0

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 18.04.2010
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATtiny2313
;Clock frequency     : 16,384000 MHz
;Memory model        : Tiny
;External RAM size   : 0
;Data Stack size     : 32
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;
;#define XY PORTB.7
;
;bit kn1, kn2, kn3, kn4, kn5, kn6;
;char on1, ona, onb;
;char data;
;unsigned char amp, faza;
;unsigned char a;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0025 {

	.CSEG
_usart_rx_isr:
; 0000 0026 data=UDR;
	IN   R4,12
; 0000 0027 }
	RETI
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 002B {
_timer1_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 002C // Place your code here
; 0000 002D PORTB.7 = on1;
	MOV  R30,R3
	CPI  R30,0
	BRNE _0x3
	CBI  0x18,7
	RJMP _0x4
_0x3:
	SBI  0x18,7
_0x4:
; 0000 002E if (on1 == 0) on1=1;
	TST  R3
	BRNE _0x5
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 002F else on1=0;
	RJMP _0x6
_0x5:
	CLR  R3
; 0000 0030 }
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0034 {
_timer1_compa_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0035 // Place your code here
; 0000 0036 PORTB.3 = ona;
	MOV  R30,R2
	CPI  R30,0
	BRNE _0x7
	CBI  0x18,3
	RJMP _0x8
_0x7:
	SBI  0x18,3
_0x8:
; 0000 0037 if (ona == 0) ona=1;
	TST  R2
	BRNE _0x9
	LDI  R30,LOW(1)
	MOV  R2,R30
; 0000 0038 else ona=0;
	RJMP _0xA
_0x9:
	CLR  R2
; 0000 0039 }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Timer 1 output compare B interrupt service routine
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 003D {
_timer1_compb_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 003E // Place your code here
; 0000 003F PORTB.4 = onb;
	MOV  R30,R5
	CPI  R30,0
	BRNE _0xB
	CBI  0x18,4
	RJMP _0xC
_0xB:
	SBI  0x18,4
_0xC:
; 0000 0040 if (onb == 0) onb=1;
	TST  R5
	BRNE _0xD
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0041 else onb=0;
	RJMP _0xE
_0xD:
	CLR  R5
; 0000 0042 }
_0xE:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;void kn_klava(void)
; 0000 0045 {
_kn_klava:
; 0000 0046       kn1=0;
	CBI  0x13,0
; 0000 0047       kn2=0;
	CBI  0x13,1
; 0000 0048       kn3=0;
	CBI  0x13,2
; 0000 0049       kn4=0;
	CBI  0x13,3
; 0000 004A       kn5=0;
	CBI  0x13,4
; 0000 004B       kn6=0;
	CBI  0x13,5
; 0000 004C       DDRD.2=1;
	SBI  0x11,2
; 0000 004D       PORTD.2=0;
	CBI  0x12,2
; 0000 004E       delay_ms (5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 004F       if (PIND.3==0 && PIND.4==0) kn1=1;
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x20
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x21
_0x20:
	RJMP _0x1F
_0x21:
	SBI  0x13,0
; 0000 0050       if (PIND.3==1 && PIND.4==0) kn2=1;
_0x1F:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x25
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x26
_0x25:
	RJMP _0x24
_0x26:
	SBI  0x13,1
; 0000 0051       DDRD.2=0;
_0x24:
	CBI  0x11,2
; 0000 0052       DDRD.3=1;
	SBI  0x11,3
; 0000 0053       PORTD.2=1;
	SBI  0x12,2
; 0000 0054       PORTD.3=0;
	CBI  0x12,3
; 0000 0055       delay_ms (5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0056       if (PIND.2==1 && PIND.4==0) kn3=1;
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x32
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x33
_0x32:
	RJMP _0x31
_0x33:
	SBI  0x13,2
; 0000 0057       if (PIND.2==0 && PIND.4==0) kn4=1;
_0x31:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x37
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x38
_0x37:
	RJMP _0x36
_0x38:
	SBI  0x13,3
; 0000 0058       DDRD.3=0;
_0x36:
	CBI  0x11,3
; 0000 0059       DDRD.4=1;
	SBI  0x11,4
; 0000 005A       PORTD.3=1;
	SBI  0x12,3
; 0000 005B       PORTD.4=0;
	CBI  0x12,4
; 0000 005C       delay_ms (5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 005D       if (PIND.2==1 && PIND.3==0) kn5=1;
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x44
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
	SBI  0x13,4
; 0000 005E       if (PIND.2==0 && PIND.3==1) kn6=1;
_0x43:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x49
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x4A
_0x49:
	RJMP _0x48
_0x4A:
	SBI  0x13,5
; 0000 005F       DDRD.4=0;
_0x48:
	CBI  0x11,4
; 0000 0060       PORTD.4=1;
	SBI  0x12,4
; 0000 0061 }
	RET
;
;// Declare your global variables here
;
;void main(void)
; 0000 0066 {
_main:
; 0000 0067 // Declare your local variables here
; 0000 0068 
; 0000 0069 // Crystal Oscillator division factor: 1
; 0000 006A #pragma optsize-
; 0000 006B CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 006C CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 006D #ifdef _OPTIMIZE_SIZE_
; 0000 006E #pragma optsize+
; 0000 006F #endif
; 0000 0070 
; 0000 0071 // Input/Output Ports initialization
; 0000 0072 // Port A initialization
; 0000 0073 // Func2=In Func1=In Func0=In
; 0000 0074 // State2=T State1=T State0=T
; 0000 0075 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0076 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0077 
; 0000 0078 // Port B initialization
; 0000 0079 // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 007A // State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=T State0=T
; 0000 007B PORTB=0x00;
	OUT  0x18,R30
; 0000 007C DDRB=0x9C;
	LDI  R30,LOW(156)
	OUT  0x17,R30
; 0000 007D 
; 0000 007E // Port D initialization
; 0000 007F // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0080 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0081 PORTD=0x5E;
	LDI  R30,LOW(94)
	OUT  0x12,R30
; 0000 0082 DDRD=0x60;
	LDI  R30,LOW(96)
	OUT  0x11,R30
; 0000 0083 
; 0000 0084 // Timer/Counter 0 initialization
; 0000 0085 // Clock source: System Clock
; 0000 0086 // Clock value: 16384,000 kHz
; 0000 0087 // Mode: Fast PWM top=FFh
; 0000 0088 // OC0A output: Non-Inverted PWM
; 0000 0089 // OC0B output: Disconnected
; 0000 008A TCCR0A=0x83;
	LDI  R30,LOW(131)
	OUT  0x30,R30
; 0000 008B TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 008C OCR0A=0xE0;
	LDI  R30,LOW(224)
	OUT  0x36,R30
; 0000 008D OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 008E TCNT0=0x00;
	OUT  0x32,R30
; 0000 008F 
; 0000 0090 // Timer/Counter 1 initialization
; 0000 0091 // Clock source: System Clock
; 0000 0092 // Clock value: 16384,000 kHz
; 0000 0093 // Mode: Fast PWM top=ICR1
; 0000 0094 // OC1A output: Discon.
; 0000 0095 // OC1B output: Discon.
; 0000 0096 // Noise Canceler: Off
; 0000 0097 // Input Capture on Falling Edge
; 0000 0098 // Timer 1 Overflow Interrupt: On
; 0000 0099 // Input Capture Interrupt: Off
; 0000 009A // Compare A Match Interrupt: On
; 0000 009B // Compare B Match Interrupt: On
; 0000 009C TCCR1A=0x02;
	LDI  R30,LOW(2)
	OUT  0x2F,R30
; 0000 009D TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 009E TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 009F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A0 ICR1H=0x03;
	LDI  R30,LOW(3)
	OUT  0x25,R30
; 0000 00A1 ICR1L=0xC0;
	LDI  R30,LOW(192)
	OUT  0x24,R30
; 0000 00A2 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 00A3 OCR1AL=0x10;
	LDI  R30,LOW(16)
	OUT  0x2A,R30
; 0000 00A4 OCR1BH=0x01;
	LDI  R30,LOW(1)
	OUT  0x29,R30
; 0000 00A5 OCR1BL=0xF0;
	LDI  R30,LOW(240)
	OUT  0x28,R30
; 0000 00A6 
; 0000 00A7 // External Interrupt(s) initialization
; 0000 00A8 // INT0: Off
; 0000 00A9 // INT1: Off
; 0000 00AA // Interrupt on any change on pins PCINT0-7: Off
; 0000 00AB GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 00AC MCUCR=0x00;
	OUT  0x35,R30
; 0000 00AD 
; 0000 00AE // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00AF TIMSK=0xE0;
	LDI  R30,LOW(224)
	OUT  0x39,R30
; 0000 00B0 
; 0000 00B1 // Universal Serial Interface initialization
; 0000 00B2 // Mode: Disabled
; 0000 00B3 // Clock source: Register & Counter=no clk.
; 0000 00B4 // USI Counter Overflow Interrupt: Off
; 0000 00B5 USICR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 00B6 
; 0000 00B7 // USART initialization
; 0000 00B8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00B9 // USART Receiver: On
; 0000 00BA // USART Transmitter: Off
; 0000 00BB // USART Mode: Asynchronous
; 0000 00BC // USART Baud Rate: 115200
; 0000 00BD UCSRA=0x00;
	OUT  0xB,R30
; 0000 00BE UCSRB=0x90;
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 00BF UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 00C0 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00C1 UBRRL=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 00C2 
; 0000 00C3 // Analog Comparator initialization
; 0000 00C4 // Analog Comparator: On
; 0000 00C5 // Digital input buffers on AIN0: On, AIN1: On
; 0000 00C6 DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00C7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00C8 ACSR=0x00;
	OUT  0x8,R30
; 0000 00C9 
; 0000 00CA // Global enable interrupts
; 0000 00CB #asm("sei")
	sei
; 0000 00CC 
; 0000 00CD ona=1;
	LDI  R30,LOW(1)
	MOV  R2,R30
; 0000 00CE 
; 0000 00CF while (1)
_0x51:
; 0000 00D0       {
; 0000 00D1       // Place your code here
; 0000 00D2       kn_klava();
	RCALL _kn_klava
; 0000 00D3 
; 0000 00D4       if (kn1==1)       ICR1++;
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x54
	IN   R30,0x24
	IN   R31,0x24+1
	ADIW R30,1
	OUT  0x24+1,R31
	OUT  0x24,R30
	SBIW R30,1
; 0000 00D5       if (kn2==1)       ICR1--;
_0x54:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x55
	IN   R30,0x24
	IN   R31,0x24+1
	SBIW R30,1
	OUT  0x24+1,R31
	OUT  0x24,R30
	ADIW R30,1
; 0000 00D6       if (kn3==1)
_0x55:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x56
; 0000 00D7         {
; 0000 00D8         OCR1A++;
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBIW R30,1
; 0000 00D9         if (OCR1A > ICR1) OCR1A = 0;
	IN   R30,0x2A
	IN   R31,0x2A+1
	MOV  R26,R30
	MOV  R27,R31
	IN   R30,0x24
	IN   R31,0x24+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x57
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00DA         };
_0x57:
_0x56:
; 0000 00DB       if (kn4==1)
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x58
; 0000 00DC         {
; 0000 00DD         OCR1A--;
	IN   R30,0x2A
	IN   R31,0x2A+1
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	ADIW R30,1
; 0000 00DE         if (OCR1A > ICR1) OCR1A = ICR1;
	IN   R30,0x2A
	IN   R31,0x2A+1
	MOV  R26,R30
	MOV  R27,R31
	IN   R30,0x24
	IN   R31,0x24+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x59
	IN   R30,0x24
	IN   R31,0x24+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00DF         };
_0x59:
_0x58:
; 0000 00E0       if (kn5==1)
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x5A
; 0000 00E1         {
; 0000 00E2         OCR1B++;
	IN   R30,0x28
	IN   R31,0x28+1
	ADIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
	SBIW R30,1
; 0000 00E3         if (OCR1B > ICR1) OCR1B = 0;
	IN   R30,0x28
	IN   R31,0x28+1
	MOV  R26,R30
	MOV  R27,R31
	IN   R30,0x24
	IN   R31,0x24+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x5B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00E4         };
_0x5B:
_0x5A:
; 0000 00E5       if (kn6==1)
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x5C
; 0000 00E6         {
; 0000 00E7         OCR1B--;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
	ADIW R30,1
; 0000 00E8         if (OCR1B > ICR1) OCR1B = ICR1;
	IN   R30,0x28
	IN   R31,0x28+1
	MOV  R26,R30
	MOV  R27,R31
	IN   R30,0x24
	IN   R31,0x24+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x5D
	IN   R30,0x24
	IN   R31,0x24+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00E9         };
_0x5D:
_0x5C:
; 0000 00EA 
; 0000 00EB       amp = data >> 4;
	MOV  R30,R4
	SWAP R30
	ANDI R30,0xF
	MOV  R7,R30
; 0000 00EC       faza = data & 0x0F;
	MOV  R30,R4
	ANDI R30,LOW(0xF)
	MOV  R6,R30
; 0000 00ED 
; 0000 00EE       for (a=0; a<100; a++)
	CLR  R9
_0x5F:
	LDI  R30,LOW(100)
	CP   R9,R30
	BRSH _0x60
; 0000 00EF         {
; 0000 00F0         if (faza >= 0x07)
	LDI  R30,LOW(7)
	CP   R6,R30
	BRLO _0x61
; 0000 00F1             {
; 0000 00F2             PORTD.5 = 1;
	SBI  0x12,5
; 0000 00F3             delay_us (100);
	__DELAY_USW 410
; 0000 00F4             PORTD.5 = 0;
	CBI  0x12,5
; 0000 00F5             delay_us (100);
	__DELAY_USW 410
; 0000 00F6             }
; 0000 00F7         if (faza < 0x07)
_0x61:
	LDI  R30,LOW(7)
	CP   R6,R30
	BRSH _0x66
; 0000 00F8             {
; 0000 00F9             PORTD.5 = 1;
	SBI  0x12,5
; 0000 00FA             delay_us (150);
	__DELAY_USW 614
; 0000 00FB             PORTD.5 = 0;
	CBI  0x12,5
; 0000 00FC             delay_us (150);
	__DELAY_USW 614
; 0000 00FD             };
_0x66:
; 0000 00FE         };
	INC  R9
	RJMP _0x5F
_0x60:
; 0000 00FF       if      (amp == 0x00)        delay_ms (999);
	TST  R7
	BRNE _0x6B
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	RJMP _0x8B
; 0000 0100       else if (amp == 0x01)        delay_ms (800);
_0x6B:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x6D
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	RJMP _0x8B
; 0000 0101       else if (amp == 0x02)        delay_ms (750);
_0x6D:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x6F
	LDI  R30,LOW(750)
	LDI  R31,HIGH(750)
	RJMP _0x8B
; 0000 0102       else if (amp == 0x03)        delay_ms (700);
_0x6F:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x71
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RJMP _0x8B
; 0000 0103       else if (amp == 0x04)        delay_ms (650);
_0x71:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0x73
	LDI  R30,LOW(650)
	LDI  R31,HIGH(650)
	RJMP _0x8B
; 0000 0104       else if (amp == 0x05)        delay_ms (600);
_0x73:
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0x75
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RJMP _0x8B
; 0000 0105       else if (amp == 0x06)        delay_ms (550);
_0x75:
	LDI  R30,LOW(6)
	CP   R30,R7
	BRNE _0x77
	LDI  R30,LOW(550)
	LDI  R31,HIGH(550)
	RJMP _0x8B
; 0000 0106       else if (amp == 0x07)        delay_ms (500);
_0x77:
	LDI  R30,LOW(7)
	CP   R30,R7
	BRNE _0x79
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP _0x8B
; 0000 0107       else if (amp == 0x08)        delay_ms (450);
_0x79:
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x7B
	LDI  R30,LOW(450)
	LDI  R31,HIGH(450)
	RJMP _0x8B
; 0000 0108       else if (amp == 0x09)        delay_ms (400);
_0x7B:
	LDI  R30,LOW(9)
	CP   R30,R7
	BRNE _0x7D
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RJMP _0x8B
; 0000 0109       else if (amp == 0x0A)        delay_ms (350);
_0x7D:
	LDI  R30,LOW(10)
	CP   R30,R7
	BRNE _0x7F
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	RJMP _0x8B
; 0000 010A       else if (amp == 0x0B)        delay_ms (300);
_0x7F:
	LDI  R30,LOW(11)
	CP   R30,R7
	BRNE _0x81
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP _0x8B
; 0000 010B       else if (amp == 0x0C)        delay_ms (250);
_0x81:
	LDI  R30,LOW(12)
	CP   R30,R7
	BRNE _0x83
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP _0x8B
; 0000 010C       else if (amp == 0x0D)        delay_ms (200);
_0x83:
	LDI  R30,LOW(13)
	CP   R30,R7
	BRNE _0x85
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP _0x8B
; 0000 010D       else if (amp == 0x0E)        delay_ms (150);
_0x85:
	LDI  R30,LOW(14)
	CP   R30,R7
	BRNE _0x87
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP _0x8B
; 0000 010E       else                         delay_ms (100);
_0x87:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
_0x8B:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 010F 
; 0000 0110       if (ACSR & 0x20) OCR0A--;
	SBIS 0x8,5
	RJMP _0x89
	IN   R30,0x36
	SUBI R30,LOW(1)
	OUT  0x36,R30
; 0000 0111       };
_0x89:
	RJMP _0x51
; 0000 0112 }
_0x8A:
	RJMP _0x8A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_p_S1020024:
	.BYTE 0x1

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1000
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
