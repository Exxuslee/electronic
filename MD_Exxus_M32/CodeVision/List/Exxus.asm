
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _amplituda_new=R4
	.DEF _faza_new=R6
	.DEF _amplituda_old=R8
	.DEF _faza_old=R10
	.DEF _zero_amplituda=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ana_comp_isr
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x56,0x25,0x64,0x0,0x42,0x25,0x64,0x0
	.DB  0x3E,0x3E,0x3E,0x3E,0x20,0x47,0x72,0x6F
	.DB  0x75,0x6E,0x64,0x20,0x3C,0x3C,0x3C,0x3C
	.DB  0x0,0x20,0x20,0x25,0x78,0x20,0x20,0x20
	.DB  0x20,0x25,0x78,0x20,0x20,0x0,0x3E,0x3E
	.DB  0x3E,0x3E,0x3E,0x20,0x5A,0x65,0x72,0x6F
	.DB  0x20,0x3C,0x3C,0x3C,0x3C,0x3C,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x25,0x64,0x2E,0x25,0x64,0x56
	.DB  0x20,0x0,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x25,0x64,0x2E
	.DB  0x25,0x64,0x56,0x20,0x0,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x25,0x64,0x2E,0x25,0x64
	.DB  0x56,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x25,0x64
	.DB  0x2E,0x25,0x64,0x56,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x25,0x64,0x2E,0x25,0x64,0x56,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x25,0x64,0x2E,0x25
	.DB  0x64,0x56,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x25
	.DB  0x64,0x2E,0x25,0x64,0x56,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x25,0x64,0x2E,0x25,0x64,0x56
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x25,0x64,0x2E
	.DB  0x25,0x64,0x56,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x20,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x23,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x20,0x20,0x20
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x23,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x20,0x20
	.DB  0x20,0x0,0xDB,0x2D,0x2D,0x2D,0x23,0x2D
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x20
	.DB  0x20,0x20,0x0,0xDB,0x2D,0x2D,0x23,0x2D
	.DB  0x2D,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x20,0x20,0x20,0x0,0xDB,0x2D,0x23,0x2D
	.DB  0x2D,0x2D,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x20,0x20,0x20,0x0,0xDB,0x23,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x20,0x20,0x20,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x23,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x20,0x20,0x20,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0xDC,0x20,0x20,0x20,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x2D
	.DB  0x2D,0x23,0x2D,0x2D,0xDC,0x20,0x20,0x20
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x2D,0x2D,0x2D,0x23,0x2D,0xDC,0x20,0x20
	.DB  0x20,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x23,0xDC,0x20
	.DB  0x20,0x20,0x0,0x24,0x24,0x24,0x20,0x4D
	.DB  0x44,0x5F,0x45,0x78,0x78,0x75,0x73,0x20
	.DB  0x24,0x24,0x24,0x0,0x20,0x20,0x20,0x76
	.DB  0x30,0x2E,0x32,0x20,0x20,0x20,0x5E,0x5F
	.DB  0x5E,0x20,0x20,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x20A005F:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A005F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
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
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x460)
	LDI  R29,HIGH(0x460)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x460

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : MD_Exxus_32
;Version : 0.2
;Date    : 14.05.2009
;Author  : Exxus
;Company : Haos
;Comments:
;
;
;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <lcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x1B ;PORTA
; 0000 0022 #endasm
;
;#define ADC_VREF_TYPE 0x20
;#define light PORTC.5
;
;unsigned int amplituda_new, faza_new, amplituda_old, faza_old;
;bit cycle;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002C {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 002D // Reinitialize Timer 0 value
; 0000 002E TCNT0=0xE0;                                                       //koli4estvo periodov
	LDI  R30,LOW(224)
	OUT  0x32,R30
; 0000 002F // Place your code here
; 0000 0030 faza_new=TCNT1;
	__INWR 6,7,44
; 0000 0031 cycle=1;
	SET
	BLD  R2,0
; 0000 0032 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Timer 2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0036 {
_timer2_ovf_isr:
	ST   -Y,R30
; 0000 0037 // Place your code here
; 0000 0038 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0039 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 003A }
	LD   R30,Y+
	RETI
;
;// Analog Comparator interrupt service routine
;interrupt [ANA_COMP] void ana_comp_isr(void)
; 0000 003E {
_ana_comp_isr:
; 0000 003F // Place your code here
; 0000 0040 amplituda_new=TCNT1;
	__INWR 4,5,44
; 0000 0041 }
	RETI
;
;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0048 {
_read_adc:
; 0000 0049 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 004A // Delay needed for the stabilization of the ADC input voltage
; 0000 004B delay_us(10);
	__DELAY_USB 27
; 0000 004C // Start the AD conversion
; 0000 004D ADCSRA|=0x40;
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 004E // Wait for the AD conversion to complete
; 0000 004F while ((ADCSRA & 0x10)==0);
_0x3:
	CALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 0050 ADCSRA|=0x10;
	CALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 0051 return ADCH;
	IN   R30,0x5
	JMP  _0x20C0001
; 0000 0052 }
;
;// Declare your global variables here
;char string_LCD_1[20], string_LCD_2[20];
;unsigned int zero_amplituda, zero_faza, gnd_amplituda, gnd_faza;
;unsigned char vol, bar;
;unsigned char viz_amplituda, viz_faza;
;unsigned char batt_celoe, batt_drob;
;bit kn1, kn2, kn3, kn4, kn5, kn6;
;
;void batt_zarqd(void)
; 0000 005D     {
_batt_zarqd:
; 0000 005E     unsigned char temp;
; 0000 005F     temp=read_adc(3);
	ST   -Y,R17
;	temp -> R17
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R17,R30
; 0000 0060     batt_celoe=temp/10;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STS  _batt_celoe,R30
; 0000 0061     batt_drob=temp%10;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _batt_drob,R30
; 0000 0062     }
	LD   R17,Y+
	RET
;
;void kn_klava(void)
; 0000 0065     {
_kn_klava:
; 0000 0066     kn1=0;
	CLT
	BLD  R2,1
; 0000 0067     kn2=0;
	BLD  R2,2
; 0000 0068     kn3=0;
	BLD  R2,3
; 0000 0069     kn4=0;
	BLD  R2,4
; 0000 006A     kn5=0;
	BLD  R2,5
; 0000 006B     kn6=0;
	BLD  R2,6
; 0000 006C     DDRD.3=1;
	SBI  0x11,3
; 0000 006D     PORTD.3=0;
	CBI  0x12,3
; 0000 006E     if (PIND.4==0 && PIND.5==0) kn1=1;
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB
	CALL SUBOPT_0x2
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
	SET
	BLD  R2,1
; 0000 006F     if (PIND.4==1 && PIND.5==0) kn2=1;
_0xA:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xE
	CALL SUBOPT_0x2
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
	SET
	BLD  R2,2
; 0000 0070     DDRD.3=0;
_0xD:
	CBI  0x11,3
; 0000 0071     DDRD.4=1;
	SBI  0x11,4
; 0000 0072     PORTD.3=1;
	SBI  0x12,3
; 0000 0073     PORTD.4=0;
	CBI  0x12,4
; 0000 0074     if (PIND.3==1 && PIND.5==0) kn3=1;
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x19
	CALL SUBOPT_0x2
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	SET
	BLD  R2,3
; 0000 0075     if (PIND.3==0 && PIND.5==0) kn4=1;
_0x18:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x1C
	CALL SUBOPT_0x2
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
	SET
	BLD  R2,4
; 0000 0076     DDRD.4=0;
_0x1B:
	CBI  0x11,4
; 0000 0077     DDRD.5=1;
	SBI  0x11,5
; 0000 0078     PORTD.4=1;
	SBI  0x12,4
; 0000 0079     PORTD.5=0;
	CBI  0x12,5
; 0000 007A     if (PIND.3==1 && PIND.4==0) kn5=1;
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x27
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,5
; 0000 007B     if (PIND.3==0 && PIND.4==1) kn6=1;
_0x26:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2A
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	SET
	BLD  R2,6
; 0000 007C     DDRD.5=0;
_0x29:
	CBI  0x11,5
; 0000 007D     PORTD.5=1;
	SBI  0x12,5
; 0000 007E     }
	RET
;
;void lcd_disp(void)
; 0000 0081     {
_lcd_disp:
; 0000 0082     if (kn1==1 || kn2==1)
	CALL SUBOPT_0x3
	BREQ _0x31
	CALL SUBOPT_0x4
	BRNE _0x30
_0x31:
; 0000 0083         {
; 0000 0084         light=1;
	CALL SUBOPT_0x5
; 0000 0085         lcd_gotoxy (14,1);
; 0000 0086         sprintf (string_LCD_2, "V%d", vol);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_vol
	CALL SUBOPT_0x6
; 0000 0087         lcd_puts (string_LCD_2);
	RJMP _0x20C0004
; 0000 0088         return;
; 0000 0089         };
_0x30:
; 0000 008A     if (kn3==1 || kn4==1)
	CALL SUBOPT_0x7
	BREQ _0x36
	CALL SUBOPT_0x8
	BRNE _0x35
_0x36:
; 0000 008B         {
; 0000 008C         light=1;
	CALL SUBOPT_0x5
; 0000 008D         lcd_gotoxy (14,1);
; 0000 008E         sprintf (string_LCD_2, "B%d", bar);
	__POINTW1FN _0x0,4
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_bar
	CALL SUBOPT_0x6
; 0000 008F         lcd_puts (string_LCD_2);
	RJMP _0x20C0004
; 0000 0090         return;
; 0000 0091         };
_0x35:
; 0000 0092     if (kn5==1)
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x3A
; 0000 0093         {
; 0000 0094         light=1;
	CALL SUBOPT_0x9
; 0000 0095         lcd_gotoxy (0,0);
; 0000 0096         sprintf (string_LCD_1, ">>>> Ground <<<<");
	__POINTW1FN _0x0,8
	CALL SUBOPT_0xA
; 0000 0097         lcd_puts (string_LCD_1);
; 0000 0098         lcd_gotoxy (0,1);
; 0000 0099         sprintf (string_LCD_2, "  %x    %x  ", gnd_amplituda, gnd_faza);
	LDS  R30,_gnd_amplituda
	LDS  R31,_gnd_amplituda+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	RJMP _0x20C0003
; 0000 009A         lcd_puts (string_LCD_2);
; 0000 009B         return;
; 0000 009C         };
_0x3A:
; 0000 009D     if (kn6==1)
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x3D
; 0000 009E         {
; 0000 009F         light=1;
	CALL SUBOPT_0x9
; 0000 00A0         lcd_gotoxy (0,0);
; 0000 00A1         sprintf (string_LCD_1, ">>>>> Zero <<<<<");
	__POINTW1FN _0x0,38
	CALL SUBOPT_0xA
; 0000 00A2         lcd_puts (string_LCD_1);
; 0000 00A3         lcd_gotoxy (0,1);
; 0000 00A4         sprintf (string_LCD_2, "  %x    %x  ", zero_amplituda, zero_faza);
	MOVW R30,R12
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_zero_faza
	LDS  R31,_zero_faza+1
_0x20C0003:
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xB
; 0000 00A5         lcd_puts (string_LCD_2);
_0x20C0004:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	CALL SUBOPT_0xC
; 0000 00A6         return;
	RET
; 0000 00A7         };
_0x3D:
; 0000 00A8     lcd_gotoxy (0,0);
	CALL SUBOPT_0xD
; 0000 00A9     if (viz_amplituda==0)  sprintf (string_LCD_1, "           %d.%dV ", batt_celoe, batt_drob);
	LDS  R30,_viz_amplituda
	CPI  R30,0
	BRNE _0x40
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,55
	CALL SUBOPT_0xF
; 0000 00AA     if (viz_amplituda==1)  sprintf (string_LCD_1, "ÿ          %d.%dV ", batt_celoe, batt_drob);
_0x40:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1)
	BRNE _0x41
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,74
	CALL SUBOPT_0xF
; 0000 00AB     if (viz_amplituda==2)  sprintf (string_LCD_1, "ÿÿ         %d.%dV ", batt_celoe, batt_drob);
_0x41:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x2)
	BRNE _0x42
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,93
	CALL SUBOPT_0xF
; 0000 00AC     if (viz_amplituda==3)  sprintf (string_LCD_1, "ÿÿÿ        %d.%dV ", batt_celoe, batt_drob);
_0x42:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x3)
	BRNE _0x43
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,112
	CALL SUBOPT_0xF
; 0000 00AD     if (viz_amplituda==4)  sprintf (string_LCD_1, "ÿÿÿÿ       %d.%dV ", batt_celoe, batt_drob);
_0x43:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x4)
	BRNE _0x44
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,131
	CALL SUBOPT_0xF
; 0000 00AE     if (viz_amplituda==5)  sprintf (string_LCD_1, "ÿÿÿÿÿ      %d.%dV ", batt_celoe, batt_drob);
_0x44:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x5)
	BRNE _0x45
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,150
	CALL SUBOPT_0xF
; 0000 00AF     if (viz_amplituda==6)  sprintf (string_LCD_1, "ÿÿÿÿÿÿ     %d.%dV ", batt_celoe, batt_drob);
_0x45:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x6)
	BRNE _0x46
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,169
	CALL SUBOPT_0xF
; 0000 00B0     if (viz_amplituda==7)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ    %d.%dV ", batt_celoe, batt_drob);
_0x46:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x7)
	BRNE _0x47
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,188
	CALL SUBOPT_0xF
; 0000 00B1     if (viz_amplituda==8)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ   %d.%dV ", batt_celoe, batt_drob);
_0x47:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x8)
	BRNE _0x48
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,207
	CALL SUBOPT_0xF
; 0000 00B2     if (viz_amplituda==9)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ  %d.%dV ", batt_celoe, batt_drob);
_0x48:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x9)
	BRNE _0x49
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,226
	CALL SUBOPT_0xF
; 0000 00B3     if (viz_amplituda==10) sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ %d.%dV ", batt_celoe, batt_drob);
_0x49:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xA)
	BRNE _0x4A
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,245
	CALL SUBOPT_0xF
; 0000 00B4     lcd_puts (string_LCD_1);
_0x4A:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	CALL SUBOPT_0xC
; 0000 00B5     lcd_gotoxy (0,1);
	CALL SUBOPT_0x10
; 0000 00B6     if (viz_faza==0)  sprintf (string_LCD_2, "Û-----#-----Ü   ");
	LDS  R30,_viz_faza
	CPI  R30,0
	BRNE _0x4B
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,264
	CALL SUBOPT_0x12
; 0000 00B7     if (viz_faza==1)  sprintf (string_LCD_2, "Û----#I-----Ü   ");
_0x4B:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x1)
	BRNE _0x4C
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,281
	CALL SUBOPT_0x12
; 0000 00B8     if (viz_faza==2)  sprintf (string_LCD_2, "Û---#-I-----Ü   ");
_0x4C:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x2)
	BRNE _0x4D
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x12
; 0000 00B9     if (viz_faza==3)  sprintf (string_LCD_2, "Û--#--I-----Ü   ");
_0x4D:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x3)
	BRNE _0x4E
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,315
	CALL SUBOPT_0x12
; 0000 00BA     if (viz_faza==4)  sprintf (string_LCD_2, "Û-#---I-----Ü   ");
_0x4E:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x4)
	BRNE _0x4F
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,332
	CALL SUBOPT_0x12
; 0000 00BB     if (viz_faza==5)  sprintf (string_LCD_2, "Û#----I-----Ü   ");
_0x4F:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x5)
	BRNE _0x50
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,349
	CALL SUBOPT_0x12
; 0000 00BC     if (viz_faza==6)  sprintf (string_LCD_2, "Û-----I#----Ü   ");
_0x50:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x6)
	BRNE _0x51
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,366
	CALL SUBOPT_0x12
; 0000 00BD     if (viz_faza==7)  sprintf (string_LCD_2, "Û-----I-#---Ü   ");
_0x51:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x7)
	BRNE _0x52
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,383
	CALL SUBOPT_0x12
; 0000 00BE     if (viz_faza==8)  sprintf (string_LCD_2, "Û-----I--#--Ü   ");
_0x52:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x8)
	BRNE _0x53
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,400
	CALL SUBOPT_0x12
; 0000 00BF     if (viz_faza==9)  sprintf (string_LCD_2, "Û-----I---#-Ü   ");
_0x53:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x9)
	BRNE _0x54
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,417
	CALL SUBOPT_0x12
; 0000 00C0     if (viz_faza==10) sprintf (string_LCD_2, "Û-----I----#Ü   ");
_0x54:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xA)
	BRNE _0x55
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,434
	CALL SUBOPT_0x12
; 0000 00C1     lcd_puts (string_LCD_2);
_0x55:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	CALL SUBOPT_0xC
; 0000 00C2     light=0;
	CBI  0x15,5
; 0000 00C3     }
	RET
;
;void volume(void)
; 0000 00C6     {
_volume:
; 0000 00C7     if (kn1==1) vol++;
	CALL SUBOPT_0x3
	BRNE _0x58
	LDS  R30,_vol
	SUBI R30,-LOW(1)
	STS  _vol,R30
; 0000 00C8     if (kn2==1) vol--;
_0x58:
	CALL SUBOPT_0x4
	BRNE _0x59
	LDS  R30,_vol
	SUBI R30,LOW(1)
	STS  _vol,R30
; 0000 00C9     if (vol==255) vol=9;
_0x59:
	LDS  R26,_vol
	CPI  R26,LOW(0xFF)
	BRNE _0x5A
	LDI  R30,LOW(9)
	STS  _vol,R30
; 0000 00CA     if (vol==10) vol=0;
_0x5A:
	LDS  R26,_vol
	CPI  R26,LOW(0xA)
	BRNE _0x5B
	LDI  R30,LOW(0)
	STS  _vol,R30
; 0000 00CB     while (kn1==1 || kn2==1)
_0x5B:
_0x5C:
	CALL SUBOPT_0x3
	BREQ _0x5F
	CALL SUBOPT_0x4
	BRNE _0x5E
_0x5F:
; 0000 00CC         {
; 0000 00CD         kn_klava();
	RCALL _kn_klava
; 0000 00CE         lcd_disp();
	RCALL _lcd_disp
; 0000 00CF         };
	RJMP _0x5C
_0x5E:
; 0000 00D0     }
	RET
;
;void barrier(void)
; 0000 00D3     {
_barrier:
; 0000 00D4     if (kn3==1) bar++;
	CALL SUBOPT_0x7
	BRNE _0x61
	LDS  R30,_bar
	SUBI R30,-LOW(1)
	STS  _bar,R30
; 0000 00D5     if (kn4==1) bar--;
_0x61:
	CALL SUBOPT_0x8
	BRNE _0x62
	LDS  R30,_bar
	SUBI R30,LOW(1)
	STS  _bar,R30
; 0000 00D6     if (bar==255) bar=9;
_0x62:
	LDS  R26,_bar
	CPI  R26,LOW(0xFF)
	BRNE _0x63
	LDI  R30,LOW(9)
	STS  _bar,R30
; 0000 00D7     if (bar==10) bar=0;
_0x63:
	LDS  R26,_bar
	CPI  R26,LOW(0xA)
	BRNE _0x64
	LDI  R30,LOW(0)
	STS  _bar,R30
; 0000 00D8     while (kn3==1 || kn4==1)
_0x64:
_0x65:
	CALL SUBOPT_0x7
	BREQ _0x68
	CALL SUBOPT_0x8
	BRNE _0x67
_0x68:
; 0000 00D9         {
; 0000 00DA         kn_klava();
	RCALL _kn_klava
; 0000 00DB         lcd_disp();
	RCALL _lcd_disp
; 0000 00DC         };
	RJMP _0x65
_0x67:
; 0000 00DD     }
	RET
;
;void ground(void)
; 0000 00E0     {
_ground:
; 0000 00E1     gnd_amplituda=amplituda_new;
	__PUTWMRN _gnd_amplituda,0,4,5
; 0000 00E2     gnd_faza=faza_new;
	__PUTWMRN _gnd_faza,0,6,7
; 0000 00E3     }
	RET
;
;void zero(void)
; 0000 00E6     {
_zero:
; 0000 00E7     zero_amplituda=amplituda_new;
	MOVW R12,R4
; 0000 00E8     zero_faza=faza_new;
	__PUTWMRN _zero_faza,0,6,7
; 0000 00E9     }
	RET
;
;void main(void)
; 0000 00EC {
_main:
; 0000 00ED // Declare your local variables here
; 0000 00EE 
; 0000 00EF // Input/Output Ports initialization
; 0000 00F0 // Port A initialization
; 0000 00F1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00F2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00F3 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00F4 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00F5 
; 0000 00F6 // Port B initialization
; 0000 00F7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00F8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00F9 PORTB=0x00;
	OUT  0x18,R30
; 0000 00FA DDRB=0x00;
	OUT  0x17,R30
; 0000 00FB 
; 0000 00FC // Port C initialization
; 0000 00FD // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00FE // State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T
; 0000 00FF PORTC=0x00;
	OUT  0x15,R30
; 0000 0100 DDRC=0x20;
	LDI  R30,LOW(32)
	OUT  0x14,R30
; 0000 0101 
; 0000 0102 // Port D initialization
; 0000 0103 // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0104 // State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0105 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0106 DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 0107 
; 0000 0108 // Timer/Counter 0 initialization
; 0000 0109 // Clock source: T0 pin Falling Edge
; 0000 010A // Mode: Normal top=FFh
; 0000 010B // OC0 output: Disconnected
; 0000 010C TCCR0=0x06;
	LDI  R30,LOW(6)
	OUT  0x33,R30
; 0000 010D TCNT0=0xE0;                                              //koli4estvo periodov
	LDI  R30,LOW(224)
	OUT  0x32,R30
; 0000 010E OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 010F 
; 0000 0110 // Timer/Counter 1 initialization
; 0000 0111 // Clock source: System Clock
; 0000 0112 // Clock value: 8000,000 kHz
; 0000 0113 // Mode: Normal top=FFFFh
; 0000 0114 // OC1A output: Discon.
; 0000 0115 // OC1B output: Discon.
; 0000 0116 // Noise Canceler: Off
; 0000 0117 // Input Capture on Falling Edge
; 0000 0118 // Timer 1 Overflow Interrupt: Off
; 0000 0119 // Input Capture Interrupt: Off
; 0000 011A // Compare A Match Interrupt: Off
; 0000 011B // Compare B Match Interrupt: Off
; 0000 011C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 011D TCCR1B=0x01;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 011E TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 011F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0120 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0121 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0122 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0123 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0124 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0125 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0126 
; 0000 0127 // Timer/Counter 2 initialization
; 0000 0128 // Clock source: System Clock
; 0000 0129 // Clock value: 31,250 kHz
; 0000 012A // Mode: Fast PWM top=FFh
; 0000 012B // OC2 output: Inverted PWM
; 0000 012C ASSR=0x00;
	OUT  0x22,R30
; 0000 012D TCCR2=0x7E;
	LDI  R30,LOW(126)
	OUT  0x25,R30
; 0000 012E TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 012F OCR2=0x0C;                                               // Impuls naka4ki
	LDI  R30,LOW(12)
	OUT  0x23,R30
; 0000 0130 
; 0000 0131 // External Interrupt(s) initialization
; 0000 0132 // INT0: Off
; 0000 0133 // INT1: Off
; 0000 0134 // INT2: Off
; 0000 0135 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0136 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0137 
; 0000 0138 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0139 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 013A 
; 0000 013B // Analog Comparator initialization
; 0000 013C // Analog Comparator: On
; 0000 013D // Interrupt on Falling Output Edge
; 0000 013E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 013F ACSR=0x0A;
	LDI  R30,LOW(10)
	OUT  0x8,R30
; 0000 0140 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0141 
; 0000 0142 // ADC initialization
; 0000 0143 // ADC Clock frequency: 1000,000 kHz
; 0000 0144 // ADC Voltage Reference: AREF pin
; 0000 0145 // Only the 8 most significant bits of
; 0000 0146 // the AD conversion result are used
; 0000 0147 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0148 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0149 
; 0000 014A // LCD module initialization
; 0000 014B lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 014C 
; 0000 014D // Global enable interrupts
; 0000 014E #asm("sei")
	sei
; 0000 014F 
; 0000 0150 lcd_gotoxy (0,0);
	CALL SUBOPT_0xD
; 0000 0151 sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,451
	CALL SUBOPT_0x12
; 0000 0152 lcd_puts (string_LCD_1);
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	CALL SUBOPT_0xC
; 0000 0153 lcd_gotoxy (0,1);
	CALL SUBOPT_0x10
; 0000 0154 sprintf (string_LCD_2, "   v0.2   ^_^   ");
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,468
	CALL SUBOPT_0x12
; 0000 0155 lcd_puts (string_LCD_2);
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	CALL SUBOPT_0xC
; 0000 0156 delay_ms (500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0157 
; 0000 0158 while (1)
_0x6A:
; 0000 0159     {
; 0000 015A     unsigned int temp_amplituda;
; 0000 015B     unsigned int temp_faza;
; 0000 015C     while (cycle==0);
	SBIW R28,4
;	temp_amplituda -> Y+2
;	temp_faza -> Y+0
_0x6D:
	SBRS R2,0
	RJMP _0x6D
; 0000 015D     kn_klava();
	RCALL _kn_klava
; 0000 015E     if (kn1==1 || kn2 ==1) volume();
	CALL SUBOPT_0x3
	BREQ _0x71
	CALL SUBOPT_0x4
	BRNE _0x70
_0x71:
	RCALL _volume
; 0000 015F     if (kn3==1 || kn4 ==1) barrier();
_0x70:
	CALL SUBOPT_0x7
	BREQ _0x74
	CALL SUBOPT_0x8
	BRNE _0x73
_0x74:
	RCALL _barrier
; 0000 0160     if (kn5==1) ground();
_0x73:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x76
	RCALL _ground
; 0000 0161     if (kn6==1) zero();
_0x76:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x77
	RCALL _zero
; 0000 0162 
; 0000 0163     temp_amplituda= zero_amplituda - amplituda_new;
_0x77:
	MOVW R30,R12
	SUB  R30,R4
	SBC  R31,R5
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 0164     temp_faza=zero_faza - faza_new;
	LDS  R30,_zero_faza
	LDS  R31,_zero_faza+1
	SUB  R30,R6
	SBC  R31,R7
	ST   Y,R30
	STD  Y+1,R31
; 0000 0165     if (temp_amplituda>0x0000) viz_amplituda=0;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __CPW02
	BRSH _0x78
	LDI  R30,LOW(0)
	STS  _viz_amplituda,R30
; 0000 0166     if (temp_amplituda>0x0080) viz_amplituda=1;
_0x78:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x79
	LDI  R30,LOW(1)
	STS  _viz_amplituda,R30
; 0000 0167     if (temp_amplituda>0x0100) viz_amplituda=2;
_0x79:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x101)
	LDI  R30,HIGH(0x101)
	CPC  R27,R30
	BRLO _0x7A
	LDI  R30,LOW(2)
	STS  _viz_amplituda,R30
; 0000 0168     if (temp_amplituda>0x0180) viz_amplituda=3;
_0x7A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x181)
	LDI  R30,HIGH(0x181)
	CPC  R27,R30
	BRLO _0x7B
	LDI  R30,LOW(3)
	STS  _viz_amplituda,R30
; 0000 0169     if (temp_amplituda>0x0200) viz_amplituda=4;
_0x7B:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x201)
	LDI  R30,HIGH(0x201)
	CPC  R27,R30
	BRLO _0x7C
	LDI  R30,LOW(4)
	STS  _viz_amplituda,R30
; 0000 016A     if (temp_amplituda>0x0280) viz_amplituda=5;
_0x7C:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x281)
	LDI  R30,HIGH(0x281)
	CPC  R27,R30
	BRLO _0x7D
	LDI  R30,LOW(5)
	STS  _viz_amplituda,R30
; 0000 016B     if (temp_amplituda>0x0300) viz_amplituda=6;
_0x7D:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x301)
	LDI  R30,HIGH(0x301)
	CPC  R27,R30
	BRLO _0x7E
	LDI  R30,LOW(6)
	STS  _viz_amplituda,R30
; 0000 016C     if (temp_amplituda>0x0380) viz_amplituda=7;
_0x7E:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x381)
	LDI  R30,HIGH(0x381)
	CPC  R27,R30
	BRLO _0x7F
	LDI  R30,LOW(7)
	STS  _viz_amplituda,R30
; 0000 016D     if (temp_amplituda>0x0400) viz_amplituda=8;
_0x7F:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x401)
	LDI  R30,HIGH(0x401)
	CPC  R27,R30
	BRLO _0x80
	LDI  R30,LOW(8)
	STS  _viz_amplituda,R30
; 0000 016E     if (temp_amplituda>0x0480) viz_amplituda=9;
_0x80:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x481)
	LDI  R30,HIGH(0x481)
	CPC  R27,R30
	BRLO _0x81
	LDI  R30,LOW(9)
	STS  _viz_amplituda,R30
; 0000 016F     if (temp_amplituda>0x0500) viz_amplituda=10;
_0x81:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x501)
	LDI  R30,HIGH(0x501)
	CPC  R27,R30
	BRLO _0x82
	LDI  R30,LOW(10)
	STS  _viz_amplituda,R30
; 0000 0170     if (temp_amplituda>0x0700) viz_amplituda=0;
_0x82:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x701)
	LDI  R30,HIGH(0x701)
	CPC  R27,R30
	BRLO _0x83
	LDI  R30,LOW(0)
	STS  _viz_amplituda,R30
; 0000 0171     if (temp_faza>0x0000) viz_faza=0;
_0x83:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	BRSH _0x84
	LDI  R30,LOW(0)
	STS  _viz_faza,R30
; 0000 0172     if (temp_faza>0x0400) viz_faza=1;
_0x84:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x401)
	LDI  R30,HIGH(0x401)
	CPC  R27,R30
	BRLO _0x85
	LDI  R30,LOW(1)
	STS  _viz_faza,R30
; 0000 0173     if (temp_faza>0x0800) viz_faza=2;
_0x85:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x801)
	LDI  R30,HIGH(0x801)
	CPC  R27,R30
	BRLO _0x86
	LDI  R30,LOW(2)
	STS  _viz_faza,R30
; 0000 0174     if (temp_faza>0x0C00) viz_faza=3;
_0x86:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xC01)
	LDI  R30,HIGH(0xC01)
	CPC  R27,R30
	BRLO _0x87
	LDI  R30,LOW(3)
	STS  _viz_faza,R30
; 0000 0175     if (temp_faza>0x1000) viz_faza=4;
_0x87:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1001)
	LDI  R30,HIGH(0x1001)
	CPC  R27,R30
	BRLO _0x88
	LDI  R30,LOW(4)
	STS  _viz_faza,R30
; 0000 0176     if (temp_faza>0x1400) viz_faza=5;
_0x88:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1401)
	LDI  R30,HIGH(0x1401)
	CPC  R27,R30
	BRLO _0x89
	LDI  R30,LOW(5)
	STS  _viz_faza,R30
; 0000 0177     if (temp_faza>0xE4FF) viz_faza=10;
_0x89:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xE500)
	LDI  R30,HIGH(0xE500)
	CPC  R27,R30
	BRLO _0x8A
	LDI  R30,LOW(10)
	STS  _viz_faza,R30
; 0000 0178     if (temp_faza>0xEBFF) viz_faza=9;
_0x8A:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xEC00)
	LDI  R30,HIGH(0xEC00)
	CPC  R27,R30
	BRLO _0x8B
	LDI  R30,LOW(9)
	STS  _viz_faza,R30
; 0000 0179     if (temp_faza>0xEFFF) viz_faza=8;
_0x8B:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xF000)
	LDI  R30,HIGH(0xF000)
	CPC  R27,R30
	BRLO _0x8C
	LDI  R30,LOW(8)
	STS  _viz_faza,R30
; 0000 017A     if (temp_faza>0xF8FF) viz_faza=7;
_0x8C:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xF900)
	LDI  R30,HIGH(0xF900)
	CPC  R27,R30
	BRLO _0x8D
	LDI  R30,LOW(7)
	STS  _viz_faza,R30
; 0000 017B     if (temp_faza>0xF4FF) viz_faza=6;
_0x8D:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xF500)
	LDI  R30,HIGH(0xF500)
	CPC  R27,R30
	BRLO _0x8E
	LDI  R30,LOW(6)
	STS  _viz_faza,R30
; 0000 017C     if (temp_faza>0xFBFF) viz_faza=0;
_0x8E:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFC00)
	LDI  R30,HIGH(0xFC00)
	CPC  R27,R30
	BRLO _0x8F
	LDI  R30,LOW(0)
	STS  _viz_faza,R30
; 0000 017D 
; 0000 017E     batt_zarqd();
_0x8F:
	RCALL _batt_zarqd
; 0000 017F     lcd_disp();
	RCALL _lcd_disp
; 0000 0180     cycle=0;
	CLT
	BLD  R2,0
; 0000 0181     };
	ADIW R28,4
	RJMP _0x6A
; 0000 0182 }
_0x90:
	RJMP _0x90
;
;
;
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G100:
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
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G100:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G100
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0002
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	CALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x2000004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2000004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0002
_lcd_puts:
	ST   -Y,R17
_0x2000005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000005
_0x2000007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G100:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G100:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0002
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x0
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G100,2
	CALL SUBOPT_0x0
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x14
	LDI  R30,LOW(4)
	CALL SUBOPT_0x14
	LDI  R30,LOW(133)
	CALL SUBOPT_0x14
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0001
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
_0x20C0002:
_0x20C0001:
	ADIW R28,1
	RET
__put_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2020012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2020013:
	RJMP _0x2020014
_0x2020010:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x2020014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G101:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x2020015:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020017
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	BRNE _0x202001B
	CPI  R18,37
	BRNE _0x202001C
	LDI  R17,LOW(1)
	RJMP _0x202001D
_0x202001C:
	CALL SUBOPT_0x15
_0x202001D:
	RJMP _0x202001A
_0x202001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x202001E
	CPI  R18,37
	BRNE _0x202001F
	CALL SUBOPT_0x15
	RJMP _0x20200BC
_0x202001F:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020020
	LDI  R16,LOW(1)
	RJMP _0x202001A
_0x2020020:
	CPI  R18,43
	BRNE _0x2020021
	LDI  R20,LOW(43)
	RJMP _0x202001A
_0x2020021:
	CPI  R18,32
	BRNE _0x2020022
	LDI  R20,LOW(32)
	RJMP _0x202001A
_0x2020022:
	RJMP _0x2020023
_0x202001E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2020024
_0x2020023:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020025
	CALL SUBOPT_0x16
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x202001A
_0x2020025:
	RJMP _0x2020026
_0x2020024:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x202001A
_0x2020026:
	CPI  R18,48
	BRLO _0x2020029
	CPI  R18,58
	BRLO _0x202002A
_0x2020029:
	RJMP _0x2020028
_0x202002A:
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R22,R21
	CLR  R23
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R30,R26
	MOV  R21,R30
	RJMP _0x202001A
_0x2020028:
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x202002E
	CALL SUBOPT_0x18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x19
	RJMP _0x202002F
_0x202002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2020031
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020032
_0x2020031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2020034
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlenf
	MOV  R17,R30
	CALL SUBOPT_0x16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
_0x2020032:
	CALL SUBOPT_0x16
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x16
	LDI  R30,LOW(65407)
	LDI  R31,HIGH(65407)
	AND  R30,R26
	MOV  R16,R30
	LDI  R19,LOW(0)
	RJMP _0x2020035
_0x2020034:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x2020038
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2020039
_0x2020038:
	CALL SUBOPT_0x16
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x202003A
_0x2020039:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x202003B
_0x202003A:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003C
_0x202003B:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x202003E
	CALL SUBOPT_0x16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x202003F
_0x202003E:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2020070
_0x202003F:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003C:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
	BREQ _0x2020041
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020042
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020042:
	CPI  R20,0
	BREQ _0x2020043
	SUBI R17,-LOW(1)
	RJMP _0x2020044
_0x2020043:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1D
_0x2020044:
	RJMP _0x2020045
_0x2020041:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
_0x2020045:
_0x2020035:
	CALL SUBOPT_0x1E
	BRNE _0x2020046
_0x2020047:
	CP   R17,R21
	BRSH _0x2020049
	CALL SUBOPT_0x16
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004A
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
	BREQ _0x202004B
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1D
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004C
_0x202004B:
	LDI  R18,LOW(48)
_0x202004C:
	RJMP _0x202004D
_0x202004A:
	LDI  R18,LOW(32)
_0x202004D:
	CALL SUBOPT_0x15
	SUBI R21,LOW(1)
	RJMP _0x2020047
_0x2020049:
_0x2020046:
	MOV  R19,R17
	CALL SUBOPT_0x16
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004E
_0x202004F:
	CPI  R19,0
	BREQ _0x2020051
	CALL SUBOPT_0x16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x2020052
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x20200BD
_0x2020052:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20200BD:
	ST   -Y,R30
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2020054
	SUBI R21,LOW(1)
_0x2020054:
	SUBI R19,LOW(1)
	RJMP _0x202004F
_0x2020051:
	RJMP _0x2020055
_0x202004E:
_0x2020057:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2020059:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005B
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2020059
_0x202005B:
	CPI  R18,58
	BRLO _0x202005C
	CALL SUBOPT_0x16
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202005D
	CALL SUBOPT_0x17
	ADIW R30,7
	RJMP _0x20200BE
_0x202005D:
	CALL SUBOPT_0x17
	ADIW R30,39
_0x20200BE:
	MOV  R18,R30
_0x202005C:
	CALL SUBOPT_0x16
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x2020060
	CPI  R18,49
	BRSH _0x2020062
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020061
_0x2020062:
	RJMP _0x20200BF
_0x2020061:
	CP   R21,R19
	BRLO _0x2020066
	CALL SUBOPT_0x1E
	BREQ _0x2020067
_0x2020066:
	RJMP _0x2020065
_0x2020067:
	LDI  R18,LOW(32)
	CALL SUBOPT_0x16
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x2020068
	LDI  R18,LOW(48)
_0x20200BF:
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
	BREQ _0x2020069
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1D
	ST   -Y,R20
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x202006A
	SUBI R21,LOW(1)
_0x202006A:
_0x2020069:
_0x2020068:
_0x2020060:
	CALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x2020065:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020058
	RJMP _0x2020057
_0x2020058:
_0x2020055:
	CALL SUBOPT_0x1E
	BREQ _0x202006C
_0x202006D:
	CPI  R21,0
	BREQ _0x202006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x19
	RJMP _0x202006D
_0x202006F:
_0x202006C:
_0x2020070:
_0x202002F:
_0x20200BC:
	LDI  R17,LOW(0)
_0x202001A:
	RJMP _0x2020015
_0x2020017:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_string_LCD_1:
	.BYTE 0x14
_string_LCD_2:
	.BYTE 0x14
_zero_faza:
	.BYTE 0x2
_gnd_amplituda:
	.BYTE 0x2
_gnd_faza:
	.BYTE 0x2
_vol:
	.BYTE 0x1
_bar:
	.BYTE 0x1
_viz_amplituda:
	.BYTE 0x1
_viz_faza:
	.BYTE 0x1
_batt_celoe:
	.BYTE 0x1
_batt_drob:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1040024:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	IN   R30,0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	SBI  0x15,5
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	SBI  0x15,5
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,25
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xB:
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:137 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_batt_celoe
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_batt_drob
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x15:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x16:
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	MOV  R30,R16
	LDI  R31,0
	ANDI R30,LOW(0x1)
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

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

;END OF CODE MARKER
__END_OF_CODE:
