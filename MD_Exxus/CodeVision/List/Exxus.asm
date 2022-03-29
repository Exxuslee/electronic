
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8535
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _code_symbol=R4
	.DEF _amplituda_1=R6
	.DEF _faza_1=R8
	.DEF _amplituda_2=R10
	.DEF _faza_2=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _ana_comp_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x3E,0x3E,0x3E,0x20,0x56,0x6F,0x6C,0x75
	.DB  0x6D,0x65,0x20,0x2B,0x20,0x3C,0x3C,0x3C
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x3E,0x3E,0x3E,0x20,0x56,0x6F,0x6C
	.DB  0x75,0x6D,0x65,0x20,0x2D,0x20,0x3C,0x3C
	.DB  0x3C,0x0,0x3E,0x3E,0x20,0x42,0x61,0x72
	.DB  0x72,0x69,0x65,0x72,0x20,0x2B,0x20,0x20
	.DB  0x3C,0x3C,0x0,0x3E,0x3E,0x20,0x42,0x61
	.DB  0x72,0x72,0x69,0x65,0x72,0x20,0x2D,0x20
	.DB  0x20,0x3C,0x3C,0x0,0x3E,0x3E,0x3E,0x3E
	.DB  0x20,0x47,0x72,0x6F,0x75,0x6E,0x64,0x20
	.DB  0x3C,0x3C,0x3C,0x3C,0x0,0x20,0x20,0x25
	.DB  0x78,0x20,0x20,0x20,0x20,0x25,0x78,0x20
	.DB  0x20,0x0,0x3E,0x3E,0x3E,0x3E,0x3E,0x20
	.DB  0x5A,0x65,0x72,0x6F,0x20,0x3C,0x3C,0x3C
	.DB  0x3C,0x3C,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x25,0x64
	.DB  0x2E,0x25,0x64,0x56,0x0,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x0,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x25,0x64,0x2E,0x25,0x64,0x56
	.DB  0x0,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x25,0x64,0x2E,0x25
	.DB  0x64,0x56,0x0,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x25,0x64
	.DB  0x2E,0x25,0x64,0x56,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x25,0x64,0x2E,0x25,0x64,0x56
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x25,0x64,0x2E,0x25
	.DB  0x64,0x56,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x25,0x64
	.DB  0x2E,0x25,0x64,0x56,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x25,0x64,0x2E,0x25,0x64,0x56
	.DB  0x0,0x7C,0x2D,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x7C,0x20,0x20
	.DB  0x20,0x0,0x7C,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x7C,0x2D,0x2D,0x2D,0x2D,0x2D,0x7C,0x20
	.DB  0x20,0x20,0x0,0x7C,0x2D,0x2D,0x2D,0x23
	.DB  0x2D,0x7C,0x2D,0x2D,0x2D,0x2D,0x2D,0x7C
	.DB  0x20,0x20,0x20,0x0,0x7C,0x2D,0x2D,0x23
	.DB  0x2D,0x2D,0x7C,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x7C,0x20,0x20,0x20,0x0,0x7C,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x7C,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x7C,0x20,0x20,0x20,0x0,0x7C,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0x7C,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x7C,0x20,0x20,0x20,0x0,0x7C
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x7C,0x23,0x2D
	.DB  0x2D,0x2D,0x2D,0x7C,0x20,0x20,0x20,0x0
	.DB  0x7C,0x2D,0x2D,0x2D,0x2D,0x2D,0x7C,0x2D
	.DB  0x23,0x2D,0x2D,0x2D,0x7C,0x20,0x20,0x20
	.DB  0x0,0x7C,0x2D,0x2D,0x2D,0x2D,0x2D,0x7C
	.DB  0x2D,0x2D,0x23,0x2D,0x2D,0x7C,0x20,0x20
	.DB  0x20,0x0,0x7C,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x7C,0x2D,0x2D,0x2D,0x23,0x2D,0x7C,0x20
	.DB  0x20,0x20,0x0,0x7C,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x7C,0x2D,0x2D,0x2D,0x2D,0x23,0x7C
	.DB  0x20,0x20,0x20,0x0,0x24,0x24,0x24,0x20
	.DB  0x4D,0x44,0x5F,0x45,0x78,0x78,0x75,0x73
	.DB  0x20,0x24,0x24,0x24,0x0,0x20,0x20,0x20
	.DB  0x76,0x30,0x2E,0x31,0x20,0x20,0x20,0x5E
	.DB  0x5F,0x5E,0x20,0x20,0x20,0x0
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
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
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
	LDI  R30,LOW(0x25F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x25F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

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
;Date    : 24.04.2009
;Author  :
;Company :
;Comments:
;
;
;Chip type           : ATmega8535
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 128
;*****************************************************/
;
;#include <mega8535.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x1B ;PORTA
; 0000 001D #endasm
;#include <lcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;
;#define ADC_VREF_TYPE 0x60
;
;unsigned int code_symbol;
;unsigned int amplituda_1, faza_1, amplituda_2, faza_2;
;bit cycle;
;
;
;// Analog Comparator interrupt service routine
;interrupt [ANA_COMP] void ana_comp_isr(void)
; 0000 002C {

	.CSEG
_ana_comp_isr:
; 0000 002D // Place your code here
; 0000 002E amplituda_1=TCNT1;
	__INWR 6,7,44
; 0000 002F }
	RETI
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0033 {
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0034 // Reinitialize Timer 0 value
; 0000 0035 TCNT0=0xF9;         //TCNT0=0xE1;
	LDI  R30,LOW(249)
	OUT  0x32,R30
; 0000 0036 // Place your code here
; 0000 0037 faza_1=TCNT1;
	__INWR 8,9,44
; 0000 0038 cycle=1;
	SET
	BLD  R2,0
; 0000 0039 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 003E {
_read_adc:
; 0000 003F ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	RCALL SUBOPT_0x0
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0040 // Delay needed for the stabilization of the ADC input voltage
; 0000 0041 delay_us(10);
	__DELAY_USB 27
; 0000 0042 // Start the AD conversion
; 0000 0043 ADCSRA|=0x40;
	RCALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 0044 // Wait for the AD conversion to complete
; 0000 0045 while ((ADCSRA & 0x10)==0);
_0x3:
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 0046 ADCSRA|=0x10;
	RCALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 0047 return ADCH;
	IN   R30,0x5
	RJMP _0x20C0001
; 0000 0048 }
;
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
; 0000 0054     {
_batt_zarqd:
; 0000 0055     unsigned char temp;
; 0000 0056     temp=read_adc(3);
	ST   -Y,R17
;	temp -> R17
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R17,R30
; 0000 0057     batt_celoe=temp/10;
	MOV  R26,R17
	RCALL SUBOPT_0x2
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STS  _batt_celoe,R30
; 0000 0058     batt_drob=temp%10;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	STS  _batt_drob,R30
; 0000 0059     }
	LD   R17,Y+
	RET
;
;void kn_klava(void)
; 0000 005C     {
_kn_klava:
; 0000 005D     kn1=0;
	CLT
	BLD  R2,1
; 0000 005E     kn2=0;
	BLD  R2,2
; 0000 005F     kn3=0;
	BLD  R2,3
; 0000 0060     kn4=0;
	BLD  R2,4
; 0000 0061     kn5=0;
	BLD  R2,5
; 0000 0062     kn6=0;
	BLD  R2,6
; 0000 0063     DDRD.0=1;
	SBI  0x11,0
; 0000 0064     PORTD.0=0;
	CBI  0x12,0
; 0000 0065     if (PIND.1==0 && PIND.2==0) kn1=1;
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x0)
	BRNE _0xB
	RCALL SUBOPT_0x4
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
	SET
	BLD  R2,1
; 0000 0066     if (PIND.1==1 && PIND.2==0) kn2=1;
_0xA:
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x1)
	BRNE _0xE
	RCALL SUBOPT_0x4
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
	SET
	BLD  R2,2
; 0000 0067     DDRD.0=0;
_0xD:
	CBI  0x11,0
; 0000 0068     DDRD.1=1;
	SBI  0x11,1
; 0000 0069     PORTD.0=1;
	SBI  0x12,0
; 0000 006A     PORTD.1=0;
	CBI  0x12,1
; 0000 006B     if (PIND.0==1 && PIND.2==0) kn3=1;
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x1)
	BRNE _0x19
	RCALL SUBOPT_0x4
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	SET
	BLD  R2,3
; 0000 006C     if (PIND.0==0 && PIND.2==0) kn4=1;
_0x18:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x0)
	BRNE _0x1C
	RCALL SUBOPT_0x4
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
	SET
	BLD  R2,4
; 0000 006D     DDRD.1=0;
_0x1B:
	CBI  0x11,1
; 0000 006E     DDRD.2=1;
	SBI  0x11,2
; 0000 006F     PORTD.1=1;
	SBI  0x12,1
; 0000 0070     PORTD.2=0;
	CBI  0x12,2
; 0000 0071     if (PIND.0==1 && PIND.1==0) kn5=1;
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x1)
	BRNE _0x27
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x0)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,5
; 0000 0072     if (PIND.0==0 && PIND.1==1) kn6=1;
_0x26:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x0)
	BRNE _0x2A
	RCALL SUBOPT_0x3
	CPI  R26,LOW(0x1)
	BREQ _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	SET
	BLD  R2,6
; 0000 0073     DDRD.2=0;
_0x29:
	CBI  0x11,2
; 0000 0074     PORTD.2=1;
	SBI  0x12,2
; 0000 0075     }
	RET
;
;void lcd_disp(void)
; 0000 0078     {
_lcd_disp:
; 0000 0079     if (kn1==1)
	RCALL SUBOPT_0x6
	BRNE _0x30
; 0000 007A         {
; 0000 007B         lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 007C         sprintf (string_LCD_1, ">>> Volume + <<<");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xA
; 0000 007D         lcd_puts (string_LCD_1);
; 0000 007E         lcd_gotoxy (0,1);
	RCALL SUBOPT_0xB
; 0000 007F         sprintf (string_LCD_2, "       %d      ", vol);
; 0000 0080         lcd_puts (string_LCD_2);
	RJMP _0x20C0003
; 0000 0081         return;
; 0000 0082         };
_0x30:
; 0000 0083     if (kn2==1)
	RCALL SUBOPT_0xC
	BRNE _0x31
; 0000 0084         {
; 0000 0085         lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 0086         sprintf (string_LCD_1, ">>> Volume - <<<");
	__POINTW1FN _0x0,33
	RCALL SUBOPT_0xD
; 0000 0087         lcd_puts (string_LCD_1);
; 0000 0088         lcd_gotoxy (0,1);
	RCALL SUBOPT_0xB
; 0000 0089         sprintf (string_LCD_2, "       %d      ", vol);
; 0000 008A         lcd_puts (string_LCD_2);
	RJMP _0x20C0003
; 0000 008B         return;
; 0000 008C         };
_0x31:
; 0000 008D     if (kn3==1)
	RCALL SUBOPT_0xE
	BRNE _0x32
; 0000 008E         {
; 0000 008F         lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 0090         sprintf (string_LCD_1, ">> Barrier +  <<");
	__POINTW1FN _0x0,50
	RCALL SUBOPT_0xD
; 0000 0091         lcd_puts (string_LCD_1);
; 0000 0092         lcd_gotoxy (0,1);
	RCALL SUBOPT_0xF
; 0000 0093         sprintf (string_LCD_2, "       %d      ", bar);
; 0000 0094         lcd_puts (string_LCD_2);
	RJMP _0x20C0003
; 0000 0095         return;
; 0000 0096         };
_0x32:
; 0000 0097     if (kn4==1)
	RCALL SUBOPT_0x10
	BRNE _0x33
; 0000 0098         {
; 0000 0099         lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 009A         sprintf (string_LCD_1, ">> Barrier -  <<");
	__POINTW1FN _0x0,67
	RCALL SUBOPT_0xD
; 0000 009B         lcd_puts (string_LCD_1);
; 0000 009C         lcd_gotoxy (0,1);
	RCALL SUBOPT_0xF
; 0000 009D         sprintf (string_LCD_2, "       %d      ", bar);
; 0000 009E         lcd_puts (string_LCD_2);
	RJMP _0x20C0003
; 0000 009F         return;
; 0000 00A0         };
_0x33:
; 0000 00A1     if (kn5==1)
	RCALL SUBOPT_0x11
	BRNE _0x34
; 0000 00A2         {
; 0000 00A3         lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 00A4         sprintf (string_LCD_1, ">>>> Ground <<<<");
	__POINTW1FN _0x0,84
	RCALL SUBOPT_0xD
; 0000 00A5         lcd_puts (string_LCD_1);
; 0000 00A6         lcd_gotoxy (0,1);
	RCALL SUBOPT_0x12
; 0000 00A7         sprintf (string_LCD_2, "  %x    %x  ", gnd_amplituda, gnd_faza);
	LDS  R30,_gnd_amplituda
	LDS  R31,_gnd_amplituda+1
	RCALL SUBOPT_0x13
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 00A8         lcd_puts (string_LCD_2);
	RJMP _0x20C0003
; 0000 00A9         return;
; 0000 00AA         };
_0x34:
; 0000 00AB     if (kn6==1)
	RCALL SUBOPT_0x15
	BRNE _0x35
; 0000 00AC         {
; 0000 00AD         lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 00AE         sprintf (string_LCD_1, ">>>>> Zero <<<<<");
	__POINTW1FN _0x0,114
	RCALL SUBOPT_0xD
; 0000 00AF         lcd_puts (string_LCD_1);
; 0000 00B0         lcd_gotoxy (0,1);
	RCALL SUBOPT_0x12
; 0000 00B1         sprintf (string_LCD_2, "  %x    %x  ", zero_amplituda, zero_faza);
	LDS  R30,_zero_amplituda
	LDS  R31,_zero_amplituda+1
	RCALL SUBOPT_0x13
	LDS  R30,_zero_faza
	LDS  R31,_zero_faza+1
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 00B2         lcd_puts (string_LCD_2);
	RJMP _0x20C0003
; 0000 00B3         return;
; 0000 00B4         };
_0x35:
; 0000 00B5     lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL _lcd_gotoxy
; 0000 00B6     if (viz_amplituda==0)  sprintf (string_LCD_1, "           %d.%dV", batt_celoe, batt_drob);
	LDS  R30,_viz_amplituda
	CPI  R30,0
	BRNE _0x36
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,131
	RCALL SUBOPT_0x17
; 0000 00B7     if (viz_amplituda==1)  sprintf (string_LCD_1, "ÿ          %d.%dV", batt_celoe, batt_drob);
_0x36:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x1)
	BRNE _0x37
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,149
	RCALL SUBOPT_0x17
; 0000 00B8     if (viz_amplituda==2)  sprintf (string_LCD_1, "ÿÿ         %d.%dV", batt_celoe, batt_drob);
_0x37:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x2)
	BRNE _0x38
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,167
	RCALL SUBOPT_0x17
; 0000 00B9     if (viz_amplituda==3)  sprintf (string_LCD_1, "ÿÿÿ        %d.%dV", batt_celoe, batt_drob);
_0x38:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x3)
	BRNE _0x39
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,185
	RCALL SUBOPT_0x17
; 0000 00BA     if (viz_amplituda==4)  sprintf (string_LCD_1, "ÿÿÿÿ       %d.%dV", batt_celoe, batt_drob);
_0x39:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x4)
	BRNE _0x3A
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,203
	RCALL SUBOPT_0x17
; 0000 00BB     if (viz_amplituda==5)  sprintf (string_LCD_1, "ÿÿÿÿÿ      %d.%dV", batt_celoe, batt_drob);
_0x3A:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x5)
	BRNE _0x3B
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,221
	RCALL SUBOPT_0x17
; 0000 00BC     if (viz_amplituda==6)  sprintf (string_LCD_1, "ÿÿÿÿÿÿ     %d.%dV", batt_celoe, batt_drob);
_0x3B:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x6)
	BRNE _0x3C
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,239
	RCALL SUBOPT_0x17
; 0000 00BD     if (viz_amplituda==7)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ    %d.%dV", batt_celoe, batt_drob);
_0x3C:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x7)
	BRNE _0x3D
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,257
	RCALL SUBOPT_0x17
; 0000 00BE     if (viz_amplituda==8)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ   %d.%dV", batt_celoe, batt_drob);
_0x3D:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x8)
	BRNE _0x3E
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,275
	RCALL SUBOPT_0x17
; 0000 00BF     if (viz_amplituda==9)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ  %d.%dV", batt_celoe, batt_drob);
_0x3E:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0x9)
	BRNE _0x3F
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,293
	RCALL SUBOPT_0x17
; 0000 00C0     if (viz_amplituda==10) sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ %d.%dV", batt_celoe, batt_drob);
_0x3F:
	RCALL SUBOPT_0x18
	CPI  R26,LOW(0xA)
	BRNE _0x40
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,311
	RCALL SUBOPT_0x17
; 0000 00C1     lcd_puts (string_LCD_1);
_0x40:
	RCALL SUBOPT_0x16
	RCALL _lcd_puts
; 0000 00C2     lcd_gotoxy (0,1);
	RCALL SUBOPT_0x7
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 00C3     if (viz_faza==0)  sprintf (string_LCD_2, "|-----#-----|   ");
	LDS  R30,_viz_faza
	CPI  R30,0
	BRNE _0x41
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,329
	RCALL SUBOPT_0x1A
; 0000 00C4     if (viz_faza==1)  sprintf (string_LCD_2, "|----#|-----|   ");
_0x41:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x1)
	BRNE _0x42
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,346
	RCALL SUBOPT_0x1A
; 0000 00C5     if (viz_faza==2)  sprintf (string_LCD_2, "|---#-|-----|   ");
_0x42:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x2)
	BRNE _0x43
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,363
	RCALL SUBOPT_0x1A
; 0000 00C6     if (viz_faza==3)  sprintf (string_LCD_2, "|--#--|-----|   ");
_0x43:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x3)
	BRNE _0x44
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,380
	RCALL SUBOPT_0x1A
; 0000 00C7     if (viz_faza==4)  sprintf (string_LCD_2, "|-#---|-----|   ");
_0x44:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x4)
	BRNE _0x45
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,397
	RCALL SUBOPT_0x1A
; 0000 00C8     if (viz_faza==5)  sprintf (string_LCD_2, "|#----|-----|   ");
_0x45:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x5)
	BRNE _0x46
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,414
	RCALL SUBOPT_0x1A
; 0000 00C9     if (viz_faza==6)  sprintf (string_LCD_2, "|-----|#----|   ");
_0x46:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x6)
	BRNE _0x47
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,431
	RCALL SUBOPT_0x1A
; 0000 00CA     if (viz_faza==7)  sprintf (string_LCD_2, "|-----|-#---|   ");
_0x47:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x7)
	BRNE _0x48
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,448
	RCALL SUBOPT_0x1A
; 0000 00CB     if (viz_faza==8)  sprintf (string_LCD_2, "|-----|--#--|   ");
_0x48:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x8)
	BRNE _0x49
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,465
	RCALL SUBOPT_0x1A
; 0000 00CC     if (viz_faza==9)  sprintf (string_LCD_2, "|-----|---#-|   ");
_0x49:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0x9)
	BRNE _0x4A
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,482
	RCALL SUBOPT_0x1A
; 0000 00CD     if (viz_faza==10) sprintf (string_LCD_2, "|-----|----#|   ");
_0x4A:
	RCALL SUBOPT_0x1B
	CPI  R26,LOW(0xA)
	BRNE _0x4B
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,499
	RCALL SUBOPT_0x1A
; 0000 00CE     lcd_puts (string_LCD_2);
_0x4B:
_0x20C0003:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	RCALL SUBOPT_0x9
	RCALL _lcd_puts
; 0000 00CF     }
	RET
;
;void volume(void)
; 0000 00D2     {
_volume:
; 0000 00D3     if (kn1==1) vol++;
	RCALL SUBOPT_0x6
	BRNE _0x4C
	LDS  R30,_vol
	SUBI R30,-LOW(1)
	STS  _vol,R30
; 0000 00D4     if (kn2==1) vol--;
_0x4C:
	RCALL SUBOPT_0xC
	BRNE _0x4D
	LDS  R30,_vol
	SUBI R30,LOW(1)
	STS  _vol,R30
; 0000 00D5     while (kn1==1 || kn2==1)
_0x4D:
_0x4E:
	RCALL SUBOPT_0x6
	BREQ _0x51
	RCALL SUBOPT_0xC
	BRNE _0x50
_0x51:
; 0000 00D6         {
; 0000 00D7         kn_klava();
	RCALL _kn_klava
; 0000 00D8         lcd_disp();
	RCALL _lcd_disp
; 0000 00D9         };
	RJMP _0x4E
_0x50:
; 0000 00DA     }
	RET
;
;void barrier(void)
; 0000 00DD     {
_barrier:
; 0000 00DE     if (kn3==1) bar++;
	RCALL SUBOPT_0xE
	BRNE _0x53
	LDS  R30,_bar
	SUBI R30,-LOW(1)
	STS  _bar,R30
; 0000 00DF     if (kn4==1) bar--;
_0x53:
	RCALL SUBOPT_0x10
	BRNE _0x54
	LDS  R30,_bar
	SUBI R30,LOW(1)
	STS  _bar,R30
; 0000 00E0     while (kn3==1 || kn4==1)
_0x54:
_0x55:
	RCALL SUBOPT_0xE
	BREQ _0x58
	RCALL SUBOPT_0x10
	BRNE _0x57
_0x58:
; 0000 00E1         {
; 0000 00E2         kn_klava();
	RCALL _kn_klava
; 0000 00E3         lcd_disp();
	RCALL _lcd_disp
; 0000 00E4         };
	RJMP _0x55
_0x57:
; 0000 00E5     }
	RET
;
;void ground(void)
; 0000 00E8     {
_ground:
; 0000 00E9     gnd_amplituda=amplituda_1/amplituda_2;
	MOVW R30,R10
	MOVW R26,R6
	RCALL __DIVW21U
	STS  _gnd_amplituda,R30
	STS  _gnd_amplituda+1,R31
; 0000 00EA     gnd_faza=faza_1/faza_2;
	MOVW R30,R12
	MOVW R26,R8
	RCALL __DIVW21U
	STS  _gnd_faza,R30
	STS  _gnd_faza+1,R31
; 0000 00EB     }
	RET
;
;void zero(void)
; 0000 00EE     {
_zero:
; 0000 00EF     zero_amplituda=amplituda_1;
	__PUTWMRN _zero_amplituda,0,6,7
; 0000 00F0     zero_faza=faza_1;
	__PUTWMRN _zero_faza,0,8,9
; 0000 00F1     }
	RET
;
;void main(void)
; 0000 00F4 {
_main:
; 0000 00F5 // Declare your local variables here
; 0000 00F6 
; 0000 00F7 // Input/Output Ports initialization
; 0000 00F8 // Port A initialization
; 0000 00F9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00FA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00FB PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00FC DDRA=0x00;
	OUT  0x1A,R30
; 0000 00FD 
; 0000 00FE // Port B initialization
; 0000 00FF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0100 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0101 PORTB=0x00;
	OUT  0x18,R30
; 0000 0102 DDRB=0x00;
	OUT  0x17,R30
; 0000 0103 
; 0000 0104 // Port C initialization
; 0000 0105 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0106 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0107 PORTC=0x00;
	OUT  0x15,R30
; 0000 0108 DDRC=0x00;
	OUT  0x14,R30
; 0000 0109 
; 0000 010A // Port D initialization
; 0000 010B // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 010C // State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 010D PORTD=0x00;
	OUT  0x12,R30
; 0000 010E DDRD=0x80;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 010F 
; 0000 0110 // Timer/Counter 0 initialization
; 0000 0111 // Clock source: T0 pin Falling Edge
; 0000 0112 // Mode: Normal top=FFh
; 0000 0113 // OC0 output: Disconnected
; 0000 0114 TCCR0=0x06;
	LDI  R30,LOW(6)
	OUT  0x33,R30
; 0000 0115 TCNT0=0xF9;         // =0xE1
	LDI  R30,LOW(249)
	OUT  0x32,R30
; 0000 0116 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0117 
; 0000 0118 // Timer/Counter 1 initialization
; 0000 0119 // Clock source: System Clock
; 0000 011A // Clock value: 8000,000 kHz
; 0000 011B // Mode: Normal top=FFFFh
; 0000 011C // OC1A output: Discon.
; 0000 011D // OC1B output: Discon.
; 0000 011E // Noise Canceler: Off
; 0000 011F // Input Capture on Falling Edge
; 0000 0120 // Timer 1 Overflow Interrupt: Off
; 0000 0121 // Input Capture Interrupt: Off
; 0000 0122 // Compare A Match Interrupt: Off
; 0000 0123 // Compare B Match Interrupt: Off
; 0000 0124 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0125 TCCR1B=0x01;
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 0126 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0127 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0128 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0129 ICR1L=0x00;
	OUT  0x26,R30
; 0000 012A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 012B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 012C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 012D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 012E 
; 0000 012F // Timer/Counter 2 initialization
; 0000 0130 // Clock source: System Clock
; 0000 0131 // Clock value: 62,500 kHz
; 0000 0132 // Mode: Fast PWM top=FFh
; 0000 0133 // OC2 output: Non-Inverted PWM
; 0000 0134 ASSR=0x00;
	OUT  0x22,R30
; 0000 0135 TCCR2=0x6D;
	LDI  R30,LOW(109)
	OUT  0x25,R30
; 0000 0136 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0137 OCR2=0x0A;
	LDI  R30,LOW(10)
	OUT  0x23,R30
; 0000 0138 
; 0000 0139 // External Interrupt(s) initialization
; 0000 013A // INT0: Off
; 0000 013B // INT1: Off
; 0000 013C // INT2: Off
; 0000 013D MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 013E MCUCSR=0x00;
	OUT  0x34,R30
; 0000 013F 
; 0000 0140 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0141 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0142 
; 0000 0143 // Analog Comparator initialization
; 0000 0144 // Analog Comparator: On
; 0000 0145 // Interrupt on Falling Output Edge
; 0000 0146 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0147 ACSR=0x0A;
	LDI  R30,LOW(10)
	OUT  0x8,R30
; 0000 0148 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0149 
; 0000 014A // ADC initialization
; 0000 014B // ADC Clock frequency: 1000,000 kHz
; 0000 014C // ADC Voltage Reference: AVCC pin
; 0000 014D // ADC High Speed Mode: Off
; 0000 014E // ADC Auto Trigger Source: None
; 0000 014F // Only the 8 most significant bits of
; 0000 0150 // the AD conversion result are used
; 0000 0151 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0152 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0153 SFIOR&=0xEF;
	IN   R30,0x30
	RCALL SUBOPT_0x1C
	ANDI R30,LOW(0xEF)
	ANDI R31,HIGH(0xEF)
	OUT  0x30,R30
; 0000 0154 
; 0000 0155 // LCD module initialization
; 0000 0156 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0157 
; 0000 0158 // Global enable interrupts
; 0000 0159 #asm("sei")
	sei
; 0000 015A 
; 0000 015B lcd_gotoxy (0,0);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 015C sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
	__POINTW1FN _0x0,516
	RCALL SUBOPT_0xD
; 0000 015D lcd_puts (string_LCD_1);
; 0000 015E lcd_gotoxy (0,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 015F sprintf (string_LCD_2, "   v0.1   ^_^   ");
	RCALL SUBOPT_0x19
	__POINTW1FN _0x0,533
	RCALL SUBOPT_0x1A
; 0000 0160 lcd_puts (string_LCD_2);
	RCALL SUBOPT_0x19
	RCALL _lcd_puts
; 0000 0161 delay_ms (500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x9
	RCALL _delay_ms
; 0000 0162 
; 0000 0163 while (1)
_0x5A:
; 0000 0164     {
; 0000 0165     while (cycle==0);
_0x5D:
	SBRS R2,0
	RJMP _0x5D
; 0000 0166     code_symbol=TCNT1;
	__INWR 4,5,44
; 0000 0167     kn_klava();
	RCALL _kn_klava
; 0000 0168     if (kn1==1 || kn2 ==1) volume();
	RCALL SUBOPT_0x6
	BREQ _0x61
	RCALL SUBOPT_0xC
	BRNE _0x60
_0x61:
	RCALL _volume
; 0000 0169     if (kn3==1 || kn4 ==1) barrier();
_0x60:
	RCALL SUBOPT_0xE
	BREQ _0x64
	RCALL SUBOPT_0x10
	BRNE _0x63
_0x64:
	RCALL _barrier
; 0000 016A     if (kn5==1) ground();
_0x63:
	RCALL SUBOPT_0x11
	BRNE _0x66
	RCALL _ground
; 0000 016B     if (kn6==1) zero();
_0x66:
	RCALL SUBOPT_0x15
	BRNE _0x67
	RCALL _zero
; 0000 016C     viz_amplituda= (amplituda_1-zero_amplituda) - gnd_amplituda*(amplituda_2-zero_amplituda);
_0x67:
	RCALL SUBOPT_0x1D
	MOVW R30,R6
	RCALL SUBOPT_0x1E
	MOVW R22,R30
	RCALL SUBOPT_0x1D
	MOVW R30,R10
	RCALL SUBOPT_0x1E
	LDS  R26,_gnd_amplituda
	LDS  R27,_gnd_amplituda+1
	RCALL SUBOPT_0x1F
	STS  _viz_amplituda,R30
; 0000 016D     viz_faza= (faza_1-zero_faza) - gnd_faza*(faza_2-zero_faza);
	RCALL SUBOPT_0x20
	MOVW R30,R8
	RCALL SUBOPT_0x1E
	MOVW R22,R30
	RCALL SUBOPT_0x20
	MOVW R30,R12
	RCALL SUBOPT_0x1E
	LDS  R26,_gnd_faza
	LDS  R27,_gnd_faza+1
	RCALL SUBOPT_0x1F
	STS  _viz_faza,R30
; 0000 016E     batt_zarqd();
	RCALL _batt_zarqd
; 0000 016F     lcd_disp();
	RCALL _lcd_disp
; 0000 0170     cycle=0;
	CLT
	BLD  R2,0
; 0000 0171     };
	RJMP _0x5A
; 0000 0172 }
_0x68:
	RJMP _0x68
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
	RCALL __lcd_delay_G100
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
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
	RJMP _0x20C0002
__lcd_read_nibble_G100:
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G100
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G100
    andi  r30,0xf0
	RET
_lcd_read_byte0_G100:
	RCALL __lcd_delay_G100
	RCALL __lcd_read_nibble_G100
    mov   r26,r30
	RCALL __lcd_read_nibble_G100
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	RCALL __lcd_ready
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	RCALL SUBOPT_0x1C
	MOVW R26,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x1C
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x21
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	RCALL __lcd_ready
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x21
	RCALL __lcd_ready
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x21
	RCALL __lcd_ready
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x21
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
	RCALL SUBOPT_0x7
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
	RJMP _0x20C0002
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
	RCALL __lcd_write_nibble_G100
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0002
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G100,2
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x22
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x21
	RCALL __long_delay_G100
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x21
	RCALL __long_delay_G100
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x21
	RCALL __long_delay_G100
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RCALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x200000B:
	RCALL __lcd_ready
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x21
	RCALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0001
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
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
	RCALL __SAVELOCR2
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL __GETW1P
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
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
__print_G101:
	SBIW R28,4
	RCALL __SAVELOCR6
	LDI  R17,0
_0x2020015:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RCALL SUBOPT_0x23
	BRNE PC+2
	RJMP _0x2020017
	MOV  R30,R17
	RCALL SUBOPT_0x1C
	SBIW R30,0
	BRNE _0x202001B
	CPI  R19,37
	BRNE _0x202001C
	LDI  R17,LOW(1)
	RJMP _0x202001D
_0x202001C:
	RCALL SUBOPT_0x24
_0x202001D:
	RJMP _0x202001A
_0x202001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x202001E
	CPI  R19,37
	BRNE _0x202001F
	RCALL SUBOPT_0x24
	RJMP _0x202009D
_0x202001F:
	LDI  R17,LOW(2)
	LDI  R18,LOW(0)
	LDI  R16,LOW(0)
	CPI  R19,43
	BRNE _0x2020020
	LDI  R18,LOW(43)
	RJMP _0x202001A
_0x2020020:
	CPI  R19,32
	BRNE _0x2020021
	LDI  R18,LOW(32)
	RJMP _0x202001A
_0x2020021:
	RJMP _0x2020022
_0x202001E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2020023
_0x2020022:
	CPI  R19,48
	BRNE _0x2020024
	RCALL SUBOPT_0x25
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x26
	LDI  R17,LOW(5)
	RJMP _0x202001A
_0x2020024:
	RJMP _0x2020025
_0x2020023:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x202001A
_0x2020025:
	MOV  R30,R19
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x202002A
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x27
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x29
	RJMP _0x202002B
_0x202002A:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x202002D
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
_0x202002E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2020030
	RCALL SUBOPT_0x24
	RJMP _0x202002E
_0x2020030:
	RJMP _0x202002B
_0x202002D:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2020032
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
_0x2020033:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x23
	BREQ _0x2020035
	RCALL SUBOPT_0x24
	RJMP _0x2020033
_0x2020035:
	RJMP _0x202002B
_0x2020032:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x2020038
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2020039
_0x2020038:
	RCALL SUBOPT_0x25
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x26
	RJMP _0x202003A
_0x2020039:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x202003B
_0x202003A:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	RJMP _0x202009E
_0x202003B:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x202003E
	RCALL SUBOPT_0x25
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x26
	RJMP _0x202003F
_0x202003E:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x2020051
_0x202003F:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
_0x202009E:
	STD  Y+6,R30
	STD  Y+6+1,R31
	MOV  R30,R16
	RCALL SUBOPT_0x1C
	ANDI R30,LOW(0x1)
	BREQ _0x2020041
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2C
	TST  R21
	BRPL _0x2020042
	MOVW R30,R20
	RCALL __ANEGW1
	MOVW R20,R30
	LDI  R18,LOW(45)
_0x2020042:
	CPI  R18,0
	BREQ _0x2020043
	ST   -Y,R18
	RCALL SUBOPT_0x29
_0x2020043:
	RJMP _0x2020044
_0x2020041:
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2C
_0x2020044:
_0x2020046:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2020048:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x202004A
	SUBI R19,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	__SUBWRR 20,21,26,27
	RJMP _0x2020048
_0x202004A:
	RCALL SUBOPT_0x25
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x202004C
	CPI  R19,49
	BRSH _0x202004C
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x202004B
_0x202004C:
	RCALL SUBOPT_0x25
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x26
	CPI  R19,58
	BRLO _0x202004E
	RCALL SUBOPT_0x25
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004F
	MOV  R30,R19
	RCALL SUBOPT_0x1C
	ADIW R30,7
	RJMP _0x202009F
_0x202004F:
	MOV  R30,R19
	RCALL SUBOPT_0x1C
	ADIW R30,39
_0x202009F:
	MOV  R19,R30
_0x202004E:
	RCALL SUBOPT_0x24
_0x202004B:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH _0x2020046
_0x2020051:
_0x202002B:
_0x202009D:
	LDI  R17,LOW(0)
_0x202001A:
	RJMP _0x2020015
_0x2020017:
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	RCALL __SAVELOCR2
	MOVW R26,R28
	RCALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	RCALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x9
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x9
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x9
	RCALL __print_G101
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL __LOADLOCR2
	ADIW R28,4
	POP  R15
	RET

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_string_LCD_1:
	.BYTE 0x14
_string_LCD_2:
	.BYTE 0x14
_zero_amplituda:
	.BYTE 0x2
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	IN   R30,0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x8:
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 93 TIMES, CODE SIZE REDUCTION:90 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0xA:
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	RCALL SUBOPT_0x9
	RCALL _lcd_puts
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	RCALL SUBOPT_0x9
	__POINTW1FN _0x0,17
	RCALL SUBOPT_0x9
	LDS  R30,_vol
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0x9
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	RCALL SUBOPT_0x9
	__POINTW1FN _0x0,17
	RCALL SUBOPT_0x9
	LDS  R30,_bar
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	RCALL SUBOPT_0x9
	__POINTW1FN _0x0,101
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x14:
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:128 WORDS
SUBOPT_0x17:
	RCALL SUBOPT_0x9
	LDS  R30,_batt_celoe
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDS  R30,_batt_drob
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	LDS  R26,_viz_amplituda
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x1A:
	RCALL SUBOPT_0x9
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDS  R26,_viz_faza
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDS  R26,_zero_amplituda
	LDS  R27,_zero_amplituda+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL __MULW12U
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDS  R26,_zero_faza
	LDS  R27,_zero_faza+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	RCALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	RJMP __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x24:
	ST   -Y,R19
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x9
	MOVW R30,R28
	ADIW R30,13
	RCALL SUBOPT_0x9
	RJMP __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	MOV  R26,R16
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	OR   R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x9
	MOVW R30,R28
	ADIW R30,13
	RCALL SUBOPT_0x9
	RJMP __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL SUBOPT_0x27
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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
