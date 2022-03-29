
;CodeVisionAVR C Compiler V1.25.9 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 32768
;Ext. SRAM wait state   : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 32768
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
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
	MOVW R26,R28
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
	MOVW R26,R28
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "ib_exxus_4.vec"
	.INCLUDE "ib_exxus_4.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	LDI  R31,0x80
	OUT  MCUCR,R31
	STS  XMCRA,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x7F00)
	LDI  R25,HIGH(0x7F00)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x7FFF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x7FFF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V2.03.4 Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project :
;       9 Version :
;      10 Date    : 29.01.2010
;      11 Author  :
;      12 Company :
;      13 Comments:
;      14 
;      15 
;      16 Chip type           : ATmega64
;      17 Program type        : Application
;      18 Clock frequency     : 8,000000 MHz
;      19 Memory model        : Small
;      20 External RAM size   : 65536
;      21 Ext. SRAM wait state: 0
;      22 Data Stack size     : 1024
;      23 *****************************************************/
;      24 
;      25 #include <mega64.h>
;      26 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      27 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      28 	.EQU __se_bit=0x20
	.EQU __se_bit=0x20
;      29 	.EQU __sm_mask=0x1C
	.EQU __sm_mask=0x1C
;      30 	.EQU __sm_powerdown=0x10
	.EQU __sm_powerdown=0x10
;      31 	.EQU __sm_powersave=0x18
	.EQU __sm_powersave=0x18
;      32 	.EQU __sm_standby=0x14
	.EQU __sm_standby=0x14
;      33 	.EQU __sm_ext_standby=0x1C
	.EQU __sm_ext_standby=0x1C
;      34 	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_adc_noise_red=0x08
;      35 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      36 	#endif
	#endif
;      37 
;      38 // Alphanumeric LCD Module functions
;      39 #asm
;      40    .equ __lcd_port=0x03 ;PORTE
   .equ __lcd_port=0x03 ;PORTE
;      41 #endasm
;      42 #include <lcd.h>
;      43 #include <stdio.h>
;      44 #include <spi.h>
;      45 #include <delay.h>
;      46 #include <mem.h>
;      47 #include <math.h>
;      48 
;      49 #define VREF 4600
;      50 #define SS PORTB.0
;      51 #define SCK PORTB.1
;      52 #define MISO PINB.3
;      53 #define M_PI (3.1415926535897932384626433832795)
;      54 
;      55 
;      56 // Declare your global variables here
;      57 
;      58 unsigned int array1 [0x100];      //[0x07CF][OCR1A];
_array1:
	.BYTE 0x200
;      59 unsigned int array_t [0x100];
_array_t:
	.BYTE 0x200
;      60 unsigned int array2 [0x100];
_array2:
	.BYTE 0x200
;      61 unsigned int a;
;      62 
;      63 unsigned int T = 8;
;      64 
;      65 struct Complex
;      66     {
;      67     float re, im;
;      68     } array3[0x100];
_array3:
	.BYTE 0x800
;      69 
;      70 
;      71 //This is array exp(-2*pi*j/2^n) for n= 1,...,32
;      72 //exp(-2*pi*j/2^n) = Complex( cos(2*pi/2^n), -sin(2*pi/2^n) )
;      73 
;      74 unsigned  read_adc(void)
;      75 {

	.CSEG
_read_adc:
;      76 unsigned result;
;      77 
;      78 SS=0;
	ST   -Y,R17
	ST   -Y,R16
;	result -> R16,R17
	CBI  0x18,0
;      79 result=(unsigned) spi(0)<<8;
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R31,R30
	LDI  R30,0
	MOVW R16,R30
;      80 result|=spi(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	LDI  R31,0
	__ORWRR 16,17,30,31
;      81 SS=1;
	SBI  0x18,0
;      82 result=result>>3;
	LSR  R17
	ROR  R16
	LSR  R17
	ROR  R16
	LSR  R17
	ROR  R16
;      83 result=result&0x03FF;
	ANDI R17,HIGH(1023)
;      84 result=(unsigned) (((unsigned long) result*VREF)/1024L);
	MOVW R30,R16
	CLR  R22
	CLR  R23
	__GETD2N 0x11F8
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x400
	CALL __DIVD21U
	MOVW R16,R30
;      85 
;      86 return result;
	MOVW R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
;      87 }
;      88 
;      89 unsigned int reverse(unsigned int I, int T)
;      90 {
_reverse:
;      91     int Shift = T - 1;
;      92     unsigned int LowMask = 1;
;      93     unsigned int HighMask = 1 << Shift;
;      94     unsigned int R;
;      95     for(R = 0; Shift >= 0; LowMask <<= 1, HighMask >>= 1, Shift -= 2)
	SBIW R28,2
	CALL __SAVELOCR6
;	I -> Y+10
;	T -> Y+8
;	Shift -> R16,R17
;	LowMask -> R18,R19
;	HighMask -> R20,R21
;	R -> Y+6
	LDI  R18,1
	LDI  R19,0
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,1
	MOVW R16,R30
	MOVW R30,R16
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOVW R20,R30
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x9:
	SUBI R16,0
	SBCI R17,0
	BRLT _0xA
;      96         R |= ((I & LowMask) << Shift) | ((I & HighMask) >> Shift);
	MOVW R30,R18
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	AND  R30,R26
	AND  R31,R27
	MOVW R26,R30
	MOVW R30,R16
	CALL __LSLW12
	MOVW R22,R30
	MOVW R30,R20
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	AND  R30,R26
	AND  R31,R27
	MOVW R26,R30
	MOVW R30,R16
	CALL __LSRW12
	OR   R30,R22
	OR   R31,R23
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
;      97     return R;
	LSL  R18
	ROL  R19
	LSR  R21
	ROR  R20
	__SUBWRN 16,17,2
	RJMP _0x9
_0xA:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LOADLOCR6
	ADIW R28,12
	RET
;      98 }
;      99 
;     100 
;     101 void main(void)
;     102 {
_main:
;     103 // Declare your local variables here
;     104 #asm("wdr");
	wdr
;     105 
;     106 // Input/Output Ports initialization
;     107 // Port A initialization
;     108 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     109 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     110 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     111 DDRA=0x00;
	OUT  0x1A,R30
;     112 
;     113 // Port B initialization
;     114 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
;     115 // State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
;     116 PORTB=0x00;
	OUT  0x18,R30
;     117 DDRB=0x27;
	LDI  R30,LOW(39)
	OUT  0x17,R30
;     118 
;     119 // Port C initialization
;     120 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     121 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     122 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
;     123 DDRC=0x00;
	OUT  0x14,R30
;     124 
;     125 // Port D initialization
;     126 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     127 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     128 PORTD=0x00;
	OUT  0x12,R30
;     129 DDRD=0x00;
	OUT  0x11,R30
;     130 
;     131 // Port E initialization
;     132 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     133 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     134 PORTE=0x00;
	OUT  0x3,R30
;     135 DDRE=0x00;
	OUT  0x2,R30
;     136 
;     137 // Port F initialization
;     138 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
;     139 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
;     140 PORTF=0x00;
	STS  98,R30
;     141 DDRF=0x00;
	STS  97,R30
;     142 
;     143 // Port G initialization
;     144 // Func4=In Func3=In Func2=In Func1=In Func0=In
;     145 // State4=T State3=T State2=T State1=T State0=T
;     146 PORTG=0x00;
	STS  101,R30
;     147 DDRG=0x00;
	STS  100,R30
;     148 
;     149 // Timer/Counter 0 initialization
;     150 // Clock source: System Clock
;     151 // Clock value: Timer 0 Stopped
;     152 // Mode: Normal top=FFh
;     153 // OC0 output: Disconnected
;     154 ASSR=0x00;
	OUT  0x30,R30
;     155 TCCR0=0x00;
	OUT  0x33,R30
;     156 TCNT0=0x00;
	OUT  0x32,R30
;     157 OCR0=0x00;
	OUT  0x31,R30
;     158 
;     159 // Timer/Counter 1 initialization
;     160 // Clock source: System Clock
;     161 // Clock value: 1000,000 kHz
;     162 // Mode: CTC top=OCR1A
;     163 // OC1A output: Toggle
;     164 // OC1B output: Discon.
;     165 // OC1C output: Discon.
;     166 // Noise Canceler: Off
;     167 // Input Capture on Falling Edge
;     168 // Timer 1 Overflow Interrupt: Off
;     169 // Input Capture Interrupt: Off
;     170 // Compare A Match Interrupt: Off
;     171 // Compare B Match Interrupt: Off
;     172 // Compare C Match Interrupt: Off
;     173 TCCR1A=0x40;
	LDI  R30,LOW(64)
	OUT  0x2F,R30
;     174 TCCR1B=0x0A;
	LDI  R30,LOW(10)
	OUT  0x2E,R30
;     175 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
;     176 TCNT1L=0x00;
	OUT  0x2C,R30
;     177 ICR1H=0x00;
	OUT  0x27,R30
;     178 ICR1L=0x00;
	OUT  0x26,R30
;     179 OCR1AH=0x01;
	LDI  R30,LOW(1)
	OUT  0x2B,R30
;     180 OCR1AL=0x00;
	LDI  R30,LOW(0)
	OUT  0x2A,R30
;     181 OCR1BH=0x00;
	OUT  0x29,R30
;     182 OCR1BL=0x00;
	OUT  0x28,R30
;     183 OCR1CH=0x00;
	STS  121,R30
;     184 OCR1CL=0x00;
	STS  120,R30
;     185 
;     186 // Timer/Counter 2 initialization
;     187 // Clock source: System Clock
;     188 // Clock value: Timer 2 Stopped
;     189 // Mode: Normal top=FFh
;     190 // OC2 output: Disconnected
;     191 TCCR2=0x00;
	OUT  0x25,R30
;     192 TCNT2=0x00;
	OUT  0x24,R30
;     193 OCR2=0x00;
	OUT  0x23,R30
;     194 
;     195 // Timer/Counter 3 initialization
;     196 // Clock source: System Clock
;     197 // Clock value: Timer 3 Stopped
;     198 // Mode: Normal top=FFFFh
;     199 // Noise Canceler: Off
;     200 // Input Capture on Falling Edge
;     201 // OC3A output: Discon.
;     202 // OC3B output: Discon.
;     203 // OC3C output: Discon.
;     204 // Timer 3 Overflow Interrupt: Off
;     205 // Input Capture Interrupt: Off
;     206 // Compare A Match Interrupt: Off
;     207 // Compare B Match Interrupt: Off
;     208 // Compare C Match Interrupt: Off
;     209 TCCR3A=0x00;
	STS  139,R30
;     210 TCCR3B=0x00;
	STS  138,R30
;     211 TCNT3H=0x00;
	STS  137,R30
;     212 TCNT3L=0x00;
	STS  136,R30
;     213 ICR3H=0x00;
	STS  129,R30
;     214 ICR3L=0x00;
	STS  128,R30
;     215 OCR3AH=0x00;
	STS  135,R30
;     216 OCR3AL=0x00;
	STS  134,R30
;     217 OCR3BH=0x00;
	STS  133,R30
;     218 OCR3BL=0x00;
	STS  132,R30
;     219 OCR3CH=0x00;
	STS  131,R30
;     220 OCR3CL=0x00;
	STS  130,R30
;     221 
;     222 // External Interrupt(s) initialization
;     223 // INT0: Off
;     224 // INT1: Off
;     225 // INT2: Off
;     226 // INT3: Off
;     227 // INT4: Off
;     228 // INT5: Off
;     229 // INT6: Off
;     230 // INT7: Off
;     231 EICRA=0x00;
	STS  106,R30
;     232 EICRB=0x00;
	OUT  0x3A,R30
;     233 EIMSK=0x00;
	OUT  0x39,R30
;     234 
;     235 // External SRAM page configuration:
;     236 //              -              / 0000h - 7FFFh
;     237 // Lower page wait state(s): None
;     238 // Upper page wait state(s): None
;     239 MCUCR=0x80;
	LDI  R30,LOW(128)
	OUT  0x35,R30
;     240 XMCRA=0x00;
	LDI  R30,LOW(0)
	STS  109,R30
;     241 
;     242 // Timer(s)/Counter(s) Interrupt(s) initialization
;     243 TIMSK=0x00;
	OUT  0x37,R30
;     244 ETIMSK=0x00;
	STS  125,R30
;     245 
;     246 // Analog Comparator initialization
;     247 // Analog Comparator: Off
;     248 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     249 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     250 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     251 
;     252 // SPI initialization
;     253 // SPI Type: Master
;     254 // SPI Clock Rate: 2*2000,000 kHz
;     255 // SPI Clock Phase: Cycle Start
;     256 // SPI Clock Polarity: Low
;     257 // SPI Data Order: MSB First
;     258 SPCR=0x54;
	LDI  R30,LOW(84)
	OUT  0xD,R30
;     259 SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0xE,R30
;     260 
;     261 while (1)
_0xB:
;     262       {
;     263       // Place your code here
;     264       unsigned int I;
;     265       unsigned int J;
;     266       unsigned int N;
;     267      // unsigned int Wre, Wim;
;     268       float Wre, Wim;
;     269       unsigned int Nd2, k, m, mpNd2;
;     270       float Temp;
;     271 
;     272       unsigned int Nmax = 0x100;
;     273 
;     274       for (a=0; a<=255; a++)   array1[TCNT1] = read_adc();
	SBIW R28,28
	LDI  R24,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xE*2)
	LDI  R31,HIGH(_0xE*2)
	CALL __INITLOCB
;	I -> Y+26
;	J -> Y+24
;	N -> Y+22
;	Wre -> Y+18
;	Wim -> Y+14
;	Nd2 -> Y+12
;	k -> Y+10
;	m -> Y+8
;	mpNd2 -> Y+6
;	Temp -> Y+2
;	Nmax -> Y+0
	CLR  R6
	CLR  R7
_0x10:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R6
	CPC  R31,R7
	BRLO _0x11
	IN   R30,0x2C
	IN   R31,0x2C+1
	LDI  R26,LOW(_array1)
	LDI  R27,HIGH(_array1)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;     275 
;     276       for (a=0; a<=255; a++) array_t[a] = a ;     //sin(2 * M_PI / a);
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x10
_0x11:
	CLR  R6
	CLR  R7
_0x13:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R6
	CPC  R31,R7
	BRLO _0x14
	MOVW R30,R6
	LDI  R26,LOW(_array_t)
	LDI  R27,HIGH(_array_t)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R6
	STD  Z+1,R7
;     277 
;     278       for(I = 0; I < Nmax; I++)
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x13
_0x14:
	LDI  R30,0
	STD  Y+26,R30
	STD  Y+26+1,R30
_0x16:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+26
	LDD  R27,Y+26+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x17
;     279         {
;     280         J = reverse(I,T);           // reverse переставляет биты в I в обратном порядке
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R9
	ST   -Y,R8
	CALL _reverse
	STD  Y+24,R30
	STD  Y+24+1,R31
;     281         array2[I] = array_t[J];
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDI  R26,LOW(_array2)
	LDI  R27,HIGH(_array2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	LDI  R26,LOW(_array_t)
	LDI  R27,HIGH(_array_t)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
;     282         array2[J] = array_t[I];
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	LDI  R26,LOW(_array2)
	LDI  R27,HIGH(_array2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDI  R26,LOW(_array_t)
	LDI  R27,HIGH(_array_t)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
;     283         };
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	ADIW R30,1
	STD  Y+26,R30
	STD  Y+26+1,R31
	RJMP _0x16
_0x17:
;     284 
;     285       for (a=0; a<=255; a++) array3[a].re = array_t[a];
	CLR  R6
	CLR  R7
_0x19:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R6
	CPC  R31,R7
	BRLO _0x1A
	MOVW R30,R6
	CALL __LSLW3
	SUBI R30,LOW(-_array3)
	SBCI R31,HIGH(-_array3)
	MOVW R0,R30
	MOVW R30,R6
	LDI  R26,LOW(_array_t)
	LDI  R27,HIGH(_array_t)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTDP1
;     286 
;     287       for(N = 2, Nd2 = 1; N <= Nmax-1; Nd2 = N, N+=N)
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x19
_0x1A:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+12,R30
	STD  Y+12+1,R31
_0x1C:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CP   R30,R26
	CPC  R31,R27
	BRSH PC+3
	JMP _0x1D
;     288         {
;     289         for(k = 0; k < Nd2; k++)
	LDI  R30,0
	STD  Y+10,R30
	STD  Y+10+1,R30
_0x1F:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x20
;     290             {
;     291        	    Wre = cos(2*M_PI*k/N);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40C90FDB
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __DIVF21
	CALL __PUTPARD1
	CALL _cos
	__PUTD1S 18
;     292             Wim = - sin(2*M_PI*k/N);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40C90FDB
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __DIVF21
	CALL __PUTPARD1
	CALL _sin
	CALL __ANEGF1
	__PUTD1S 14
;     293             for(m = k; m < Nmax-1; m += N)
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x22:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x23
;     294                 {
;     295                 mpNd2 = m + Nd2;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
;     296                 Temp = Wre * array3[mpNd2].re;
	CALL __LSLW3
	SUBI R30,LOW(-_array3)
	SBCI R31,HIGH(-_array3)
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 18
	CALL __MULF12
	__PUTD1S 2
;     297                 array3[mpNd2].re = array3[m].re - Temp;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSLW3
	SUBI R30,LOW(-_array3)
	SBCI R31,HIGH(-_array3)
	PUSH R31
	PUSH R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LSLW3
	SUBI R30,LOW(-_array3)
	SBCI R31,HIGH(-_array3)
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __SUBF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;     298                 array3[m].re += Temp;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LSLW3
	SUBI R30,LOW(-_array3)
	SBCI R31,HIGH(-_array3)
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;     299                 Temp = Wim * array3[mpNd2].im;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSLW3
	__ADDW1MN _array3,4
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 14
	CALL __MULF12
	__PUTD1S 2
;     300                 array3[mpNd2].im = array3[m].im - Temp;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSLW3
	__ADDW1MN _array3,4
	PUSH R31
	PUSH R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LSLW3
	__ADDW1MN _array3,4
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __SUBF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;     301                 array3[m].im += Temp;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LSLW3
	__ADDW1MN _array3,4
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	__GETD2S 2
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;     302                 };
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x22
_0x23:
;     303             };
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x1F
_0x20:
;     304         };
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	STD  Y+12,R30
	STD  Y+12+1,R31
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+22,R30
	STD  Y+22+1,R31
	RJMP _0x1C
_0x1D:
;     305 
;     306       #asm("wdr");
	wdr
;     307 
;     308       };
	ADIW R28,28
	JMP  _0xB
;     309 }
_0x24:
	RJMP _0x24

    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G2:
	.BYTE 0x4

	.CSEG
__lcd_delay_G2:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	CALL __lcd_delay_G2
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G2
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G2
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G2
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G2:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G2
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G2
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G2
    ld    r26,y
    swap  r26
	CALL __lcd_write_nibble_G2
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0xE7:
	SBIS 0xE,7
	RJMP _0xE7
	IN   R30,0xF
	ADIW R28,1
	RET
_sin:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	__GETD1N 0x3E22F983
	CALL __MULF12
	__PUTD1S 5
	CALL __PUTPARD1
	CALL _floor
	__GETD2S 5
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 5
	__GETD2S 5
	__GETD1N 0x3F000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEA
	CALL __SWAPD12
	CALL __SUBF12
	__PUTD1S 5
	LDI  R17,LOW(1)
_0xEA:
	__GETD2S 5
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEB
	__GETD1N 0x3F000000
	CALL __SUBF12
	__PUTD1S 5
_0xEB:
	CPI  R17,0
	BREQ _0xEC
	__GETD1S 5
	CALL __ANEGF1
	__PUTD1S 5
_0xEC:
	__GETD1S 5
	__GETD2S 5
	CALL __MULF12
	__PUTD1S 1
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL __SWAPD12
	CALL __SUBF12
	__GETD2S 1
	CALL __MULF12
	__GETD2N 0x4104534C
	CALL __ADDF12
	__GETD2S 5
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 1
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	__GETD2S 1
	CALL __MULF12
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	LDD  R17,Y+0
	ADIW R28,9
	RET
_cos:
	__GETD2S 0
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	CALL _sin
	ADIW R28,4
	RET

	.DSEG
_p_S67:
	.BYTE 0x2

	.CSEG

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
