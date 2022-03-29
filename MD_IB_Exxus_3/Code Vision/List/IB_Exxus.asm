
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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
	.DEF _x_1=R6
	.DEF _x_2=R8
	.DEF _faza=R10
	.DEF _amplituda=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x20,0x56
	.DB  0x3D,0x25,0x64,0x20,0x42,0x3D,0x25,0x64
	.DB  0x20,0x20,0x20,0x0,0x25,0x78,0x20,0x25
	.DB  0x78,0x20,0x20,0x20,0x0,0x20,0x54,0x58
	.DB  0x20,0x63,0x61,0x6C,0x69,0x62,0x72,0x61
	.DB  0x74,0x69,0x6F,0x6E,0x20,0x0,0x74,0x69
	.DB  0x6B,0x20,0x25,0x64,0x20,0x3D,0x3E,0x20
	.DB  0x25,0x64,0x48,0x7A,0x0,0x3E,0x20,0x47
	.DB  0x72,0x6F,0x75,0x6E,0x64,0x20,0x72,0x61
	.DB  0x67,0x65,0x20,0x20,0x3C,0x0,0x20,0x25
	.DB  0x64,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x56,0x25,0x64,0x0,0x42,0x25,0x64,0x0
	.DB  0x3E,0x3E,0x3E,0x3E,0x3E,0x20,0x52,0x6F
	.DB  0x63,0x6B,0x20,0x3C,0x3C,0x3C,0x3C,0x3C
	.DB  0x0,0x25,0x66,0x20,0x25,0x66,0x0,0x3E
	.DB  0x3E,0x3E,0x3E,0x20,0x47,0x72,0x6F,0x75
	.DB  0x6E,0x64,0x20,0x3C,0x3C,0x3C,0x3C,0x0
	.DB  0x25,0x66,0x20,0x25,0x66,0x20,0x0,0x3E
	.DB  0x3E,0x3E,0x3E,0x3E,0x20,0x5A,0x65,0x72
	.DB  0x6F,0x20,0x3C,0x3C,0x3C,0x3C,0x3C,0x0
	.DB  0x25,0x78,0x20,0x25,0x78,0x20,0x25,0x78
	.DB  0x20,0x25,0x78,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x0,0x20,0x20
	.DB  0x20,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0x20
	.DB  0x20,0x20,0xDB,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0x20,0x20,0x20,0xDB,0x2D,0x2D,0x2D,0x23
	.DB  0x2D,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0x20,0x20,0x20,0xDB,0x2D,0x2D,0x23
	.DB  0x2D,0x2D,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0x20,0x20,0x20,0xDB,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0x20,0x20,0x20,0xDB,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0x20,0x20,0x20,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x23,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0x20,0x20,0x20
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x2D
	.DB  0x23,0x2D,0x2D,0x2D,0xDC,0x0,0x20,0x20
	.DB  0x20,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x2D,0x2D,0x23,0x2D,0x2D,0xDC,0x0,0x20
	.DB  0x20,0x20,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x2D,0x2D,0x2D,0x23,0x2D,0xDC,0x0
	.DB  0x20,0x20,0x20,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x2D,0x2D,0x2D,0x2D,0x23,0xDC
	.DB  0x0,0x24,0x24,0x24,0x20,0x4D,0x44,0x5F
	.DB  0x45,0x78,0x78,0x75,0x73,0x20,0x24,0x24
	.DB  0x24,0x0,0x20,0x20,0x20,0x76,0x30,0x2E
	.DB  0x34,0x20,0x20,0x20,0x5E,0x5F,0x5E,0x20
	.DB  0x20,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
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
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

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
;Date    : 02.06.2009
;Author  :
;Company :
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
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 001D #endasm
;#include <lcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;
;#define ADC_VREF_TYPE 0x00
;#define light PORTD.6
;
;// Declare your global variables here
;char string_LCD_1[20], string_LCD_2[20];
;int x_1, x_2;
;int faza, amplituda;
;unsigned int zero_amplituda, zero_faza, viz_period, y_gnd, x_gnd;
;float  gnd_amplituda, gnd_faza, rock_amplituda, rock_faza, now_amplituda, now_faza;
;unsigned int period;
;unsigned char vol, bar, menu, tik_old, tik_new, gnd_rage;
;unsigned char viz_amplituda, viz_faza;
;unsigned int batt_celoe, batt_drob;
;bit kn1, kn2, kn3, kn4, kn5, kn6;
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0034 {

	.CSEG
_read_adc:
; 0000 0035 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	OUT  0x7,R30
; 0000 0036 // Delay needed for the stabilization of the ADC input voltage
; 0000 0037 delay_us(10);
	__DELAY_USB 27
; 0000 0038 // Start the AD conversion
; 0000 0039 ADCSRA|=0x40;
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 003A // Wait for the AD conversion to complete
; 0000 003B while ((ADCSRA & 0x10)==0);
_0x3:
	CALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 003C ADCSRA|=0x10;
	CALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 003D return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 003E }
;
;void batt_zarqd(void)
; 0000 0041     {
_batt_zarqd:
; 0000 0042     unsigned int temp;
; 0000 0043     #asm("wdr");
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	wdr
; 0000 0044     temp=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R16,R30
; 0000 0045     batt_celoe=temp/10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STS  _batt_celoe,R30
	STS  _batt_celoe+1,R31
; 0000 0046     batt_drob=temp%10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	STS  _batt_drob,R30
	STS  _batt_drob+1,R31
; 0000 0047     }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void kn_klava(void)
; 0000 004A     {
_kn_klava:
; 0000 004B     #asm("wdr");
	wdr
; 0000 004C     kn1=0;
	CLT
	BLD  R2,0
; 0000 004D     kn2=0;
	BLD  R2,1
; 0000 004E     kn3=0;
	BLD  R2,2
; 0000 004F     kn4=0;
	BLD  R2,3
; 0000 0050     kn5=0;
	BLD  R2,4
; 0000 0051     kn6=0;
	BLD  R2,5
; 0000 0052     DDRD.2=1;
	SBI  0x11,2
; 0000 0053     PORTD.2=0;
	CBI  0x12,2
; 0000 0054     delay_ms (1);
	CALL SUBOPT_0x2
; 0000 0055     if (PIND.3==0 && PIND.4==0) kn1=1;
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB
	CALL SUBOPT_0x3
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
	SET
	BLD  R2,0
; 0000 0056     if (PIND.3==1 && PIND.4==0) kn2=1;
_0xA:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xE
	CALL SUBOPT_0x3
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
	SET
	BLD  R2,1
; 0000 0057     DDRD.2=0;
_0xD:
	CBI  0x11,2
; 0000 0058     DDRD.3=1;
	SBI  0x11,3
; 0000 0059     PORTD.2=1;
	SBI  0x12,2
; 0000 005A     PORTD.3=0;
	CBI  0x12,3
; 0000 005B     delay_ms (1);
	CALL SUBOPT_0x2
; 0000 005C     if (PIND.2==1 && PIND.4==0) kn3=1;
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x19
	CALL SUBOPT_0x3
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	SET
	BLD  R2,2
; 0000 005D     if (PIND.2==0 && PIND.4==0) kn4=1;
_0x18:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x1C
	CALL SUBOPT_0x3
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
	SET
	BLD  R2,3
; 0000 005E     DDRD.3=0;
_0x1B:
	CBI  0x11,3
; 0000 005F     DDRD.4=1;
	SBI  0x11,4
; 0000 0060     PORTD.3=1;
	SBI  0x12,3
; 0000 0061     PORTD.4=0;
	CBI  0x12,4
; 0000 0062     delay_ms (1);
	CALL SUBOPT_0x2
; 0000 0063     if (PIND.2==1 && PIND.3==0) kn5=1;
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x27
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,4
; 0000 0064     if (PIND.2==0 && PIND.3==1) kn6=1;
_0x26:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2A
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	SET
	BLD  R2,5
; 0000 0065     DDRD.4=0;
_0x29:
	CBI  0x11,4
; 0000 0066     PORTD.4=1;
	SBI  0x12,4
; 0000 0067     }
	RET
;
;void lcd_disp(void)
; 0000 006A     {
_lcd_disp:
; 0000 006B     #asm("wdr");
	wdr
; 0000 006C     if (menu==1)
	LDS  R26,_menu
	CPI  R26,LOW(0x1)
	BRNE _0x30
; 0000 006D         {
; 0000 006E         light=1;
	CALL SUBOPT_0x4
; 0000 006F         lcd_gotoxy (0,0);
; 0000 0070         sprintf (string_LCD_1, "%d.%dV V=%d B=%d   ", batt_celoe, batt_drob, vol, bar);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_batt_celoe
	LDS  R31,_batt_celoe+1
	CALL SUBOPT_0x5
	LDS  R30,_batt_drob
	LDS  R31,_batt_drob+1
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 0071         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x8
; 0000 0072         lcd_gotoxy (0,1);
; 0000 0073         sprintf (string_LCD_2, "%x %x   ", faza, amplituda);
	__POINTW1FN _0x0,20
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R10
	CALL SUBOPT_0x9
	MOVW R30,R12
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0074         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 0075         return;
; 0000 0076         };
_0x30:
; 0000 0077     if (menu==2)
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x33
; 0000 0078         {
; 0000 0079         light=1;
	CALL SUBOPT_0x4
; 0000 007A         lcd_gotoxy (0,0);
; 0000 007B         sprintf (string_LCD_1, " TX calibration ");
	__POINTW1FN _0x0,29
	CALL SUBOPT_0xB
; 0000 007C         lcd_puts (string_LCD_1);
; 0000 007D         lcd_gotoxy (0,1);
; 0000 007E         sprintf (string_LCD_2, "tik %d => %dHz", tik_old, viz_period);
	__POINTW1FN _0x0,46
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_tik_old
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_viz_period
	LDS  R31,_viz_period+1
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 007F         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 0080         return;
; 0000 0081         };
_0x33:
; 0000 0082     if (menu==3)
	LDS  R26,_menu
	CPI  R26,LOW(0x3)
	BRNE _0x36
; 0000 0083         {
; 0000 0084         light=1;
	CALL SUBOPT_0x4
; 0000 0085         lcd_gotoxy (0,0);
; 0000 0086         sprintf (string_LCD_1, "> Ground rage  <");
	__POINTW1FN _0x0,61
	CALL SUBOPT_0xB
; 0000 0087         lcd_puts (string_LCD_1);
; 0000 0088         lcd_gotoxy (0,1);
; 0000 0089         sprintf (string_LCD_2, " %d              ", gnd_rage);
	__POINTW1FN _0x0,78
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_rage
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	CALL SUBOPT_0xC
; 0000 008A         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 008B         return;
; 0000 008C         };
_0x36:
; 0000 008D     if (kn2==1)
	CALL SUBOPT_0xD
	BRNE _0x39
; 0000 008E         {
; 0000 008F         light=1;
	CALL SUBOPT_0xE
; 0000 0090         lcd_gotoxy (0,1);
; 0000 0091         sprintf (string_LCD_2, "V%d", vol);
	__POINTW1FN _0x0,96
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL SUBOPT_0xC
; 0000 0092         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 0093         return;
; 0000 0094         };
_0x39:
; 0000 0095     if (kn3==1)
	CALL SUBOPT_0xF
	BRNE _0x3C
; 0000 0096         {
; 0000 0097         light=1;
	CALL SUBOPT_0xE
; 0000 0098         lcd_gotoxy (0,1);
; 0000 0099         sprintf (string_LCD_2, "B%d", bar);
	__POINTW1FN _0x0,100
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
; 0000 009A         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 009B         return;
; 0000 009C         };
_0x3C:
; 0000 009D 
; 0000 009E     if (kn4==1)
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x3F
; 0000 009F         {
; 0000 00A0         light=1;
	CALL SUBOPT_0x4
; 0000 00A1         lcd_gotoxy (0,0);
; 0000 00A2         sprintf (string_LCD_1, ">>>>> Rock <<<<<", bar);
	__POINTW1FN _0x0,104
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0xC
; 0000 00A3         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x8
; 0000 00A4         lcd_gotoxy (0,1);
; 0000 00A5         sprintf (string_LCD_2, "%f %f", rock_amplituda, rock_faza);
	__POINTW1FN _0x0,121
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rock_amplituda
	LDS  R31,_rock_amplituda+1
	LDS  R22,_rock_amplituda+2
	LDS  R23,_rock_amplituda+3
	CALL __PUTPARD1
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	CALL __PUTPARD1
	CALL SUBOPT_0xA
; 0000 00A6         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 00A7         return;
; 0000 00A8         };
_0x3F:
; 0000 00A9 
; 0000 00AA     if (kn5==1)
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x42
; 0000 00AB         {
; 0000 00AC         light=1;
	CALL SUBOPT_0x4
; 0000 00AD         lcd_gotoxy (0,0);
; 0000 00AE         sprintf (string_LCD_1, ">>>> Ground <<<<");
	__POINTW1FN _0x0,127
	CALL SUBOPT_0xB
; 0000 00AF         lcd_puts (string_LCD_1);
; 0000 00B0         lcd_gotoxy (0,1);
; 0000 00B1         sprintf (string_LCD_2, "%f %f ", gnd_amplituda, gnd_faza);
	__POINTW1FN _0x0,144
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	CALL SUBOPT_0xA
; 0000 00B2         lcd_puts (string_LCD_2);
	RJMP _0x20C000A
; 0000 00B3         return;
; 0000 00B4         };
_0x42:
; 0000 00B5     if (kn6==1)
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x45
; 0000 00B6         {
; 0000 00B7         light=1;
	CALL SUBOPT_0x4
; 0000 00B8         lcd_gotoxy (0,0);
; 0000 00B9         sprintf (string_LCD_1, ">>>>> Zero <<<<<");
	__POINTW1FN _0x0,151
	CALL SUBOPT_0xB
; 0000 00BA         lcd_puts (string_LCD_1);
; 0000 00BB         lcd_gotoxy (0,1);
; 0000 00BC         sprintf (string_LCD_2, "%x %x %x %x ", zero_amplituda, zero_faza, amplituda, faza);
	__POINTW1FN _0x0,168
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x5
	CALL SUBOPT_0x12
	CALL SUBOPT_0x5
	MOVW R30,R12
	CALL SUBOPT_0x9
	MOVW R30,R10
	CALL SUBOPT_0x9
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00BD         lcd_puts (string_LCD_2);
_0x20C000A:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	CALL SUBOPT_0x13
; 0000 00BE         return;
	RET
; 0000 00BF         };
_0x45:
; 0000 00C0     lcd_gotoxy (0,0);
	CALL SUBOPT_0x14
; 0000 00C1     if (viz_amplituda==0)    sprintf (string_LCD_1, "                ");
	LDS  R30,_viz_amplituda
	CPI  R30,0
	BRNE _0x48
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,181
	CALL SUBOPT_0x16
; 0000 00C2     if (viz_amplituda==1)    sprintf (string_LCD_1, "_               ");
_0x48:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1)
	BRNE _0x49
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,198
	CALL SUBOPT_0x16
; 0000 00C3     if (viz_amplituda==2)    sprintf (string_LCD_1, "ÿ               ");
_0x49:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x2)
	BRNE _0x4A
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,215
	CALL SUBOPT_0x16
; 0000 00C4     if (viz_amplituda==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x4A:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x3)
	BRNE _0x4B
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,232
	CALL SUBOPT_0x16
; 0000 00C5     if (viz_amplituda==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x4B:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x4)
	BRNE _0x4C
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,249
	CALL SUBOPT_0x16
; 0000 00C6     if (viz_amplituda==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x4C:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x5)
	BRNE _0x4D
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,266
	CALL SUBOPT_0x16
; 0000 00C7     if (viz_amplituda==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x4D:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x6)
	BRNE _0x4E
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,283
	CALL SUBOPT_0x16
; 0000 00C8     if (viz_amplituda==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x4E:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x7)
	BRNE _0x4F
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,300
	CALL SUBOPT_0x16
; 0000 00C9     if (viz_amplituda==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x4F:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x8)
	BRNE _0x50
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,317
	CALL SUBOPT_0x16
; 0000 00CA     if (viz_amplituda==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x50:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x9)
	BRNE _0x51
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,334
	CALL SUBOPT_0x16
; 0000 00CB     if (viz_amplituda==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x51:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xA)
	BRNE _0x52
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,351
	CALL SUBOPT_0x16
; 0000 00CC     if (viz_amplituda==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x52:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xB)
	BRNE _0x53
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,368
	CALL SUBOPT_0x16
; 0000 00CD     if (viz_amplituda==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x53:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xC)
	BRNE _0x54
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,385
	CALL SUBOPT_0x16
; 0000 00CE     if (viz_amplituda==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x54:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xD)
	BRNE _0x55
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x16
; 0000 00CF     if (viz_amplituda==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x55:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xE)
	BRNE _0x56
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,419
	CALL SUBOPT_0x16
; 0000 00D0     if (viz_amplituda==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x56:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0xF)
	BRNE _0x57
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,436
	CALL SUBOPT_0x16
; 0000 00D1     if (viz_amplituda==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x57:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x10)
	BRNE _0x58
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,453
	CALL SUBOPT_0x16
; 0000 00D2     if (viz_amplituda==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x58:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x11)
	BRNE _0x59
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,470
	CALL SUBOPT_0x16
; 0000 00D3     if (viz_amplituda==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x59:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x12)
	BRNE _0x5A
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,487
	CALL SUBOPT_0x16
; 0000 00D4     if (viz_amplituda==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x5A:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x13)
	BRNE _0x5B
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,504
	CALL SUBOPT_0x16
; 0000 00D5     if (viz_amplituda==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x5B:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x14)
	BRNE _0x5C
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,521
	CALL SUBOPT_0x16
; 0000 00D6     if (viz_amplituda==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x5C:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x15)
	BRNE _0x5D
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,538
	CALL SUBOPT_0x16
; 0000 00D7     if (viz_amplituda==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x5D:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x16)
	BRNE _0x5E
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,555
	CALL SUBOPT_0x16
; 0000 00D8     if (viz_amplituda==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x5E:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x17)
	BRNE _0x5F
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,572
	CALL SUBOPT_0x16
; 0000 00D9     if (viz_amplituda==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x5F:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x18)
	BRNE _0x60
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,589
	CALL SUBOPT_0x16
; 0000 00DA     if (viz_amplituda==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x60:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x19)
	BRNE _0x61
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,606
	CALL SUBOPT_0x16
; 0000 00DB     if (viz_amplituda==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x61:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1A)
	BRNE _0x62
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,623
	CALL SUBOPT_0x16
; 0000 00DC     if (viz_amplituda==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x62:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1B)
	BRNE _0x63
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,640
	CALL SUBOPT_0x16
; 0000 00DD     if (viz_amplituda==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x63:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1C)
	BRNE _0x64
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,657
	CALL SUBOPT_0x16
; 0000 00DE     if (viz_amplituda==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x64:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1D)
	BRNE _0x65
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,674
	CALL SUBOPT_0x16
; 0000 00DF     if (viz_amplituda==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x65:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1E)
	BRNE _0x66
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,691
	CALL SUBOPT_0x16
; 0000 00E0     if (viz_amplituda==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x66:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x1F)
	BRNE _0x67
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,708
	CALL SUBOPT_0x16
; 0000 00E1     if (viz_amplituda==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x67:
	LDS  R26,_viz_amplituda
	CPI  R26,LOW(0x20)
	BRNE _0x68
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,725
	CALL SUBOPT_0x16
; 0000 00E2     lcd_puts (string_LCD_1);
_0x68:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	CALL SUBOPT_0x13
; 0000 00E3     lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 00E4     if (viz_faza==0)  sprintf (string_LCD_2, "   Û-----#-----Ü");
	LDS  R30,_viz_faza
	CPI  R30,0
	BRNE _0x69
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,742
	CALL SUBOPT_0x16
; 0000 00E5     if (viz_faza==1)  sprintf (string_LCD_2, "   Û----#I-----Ü");
_0x69:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x1)
	BRNE _0x6A
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,759
	CALL SUBOPT_0x16
; 0000 00E6     if (viz_faza==2)  sprintf (string_LCD_2, "   Û---#-I-----Ü");
_0x6A:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x2)
	BRNE _0x6B
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,776
	CALL SUBOPT_0x16
; 0000 00E7     if (viz_faza==3)  sprintf (string_LCD_2, "   Û--#--I-----Ü");
_0x6B:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x3)
	BRNE _0x6C
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,793
	CALL SUBOPT_0x16
; 0000 00E8     if (viz_faza==4)  sprintf (string_LCD_2, "   Û-#---I-----Ü");
_0x6C:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x4)
	BRNE _0x6D
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,810
	CALL SUBOPT_0x16
; 0000 00E9     if (viz_faza==5)  sprintf (string_LCD_2, "   Û#----I-----Ü");
_0x6D:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x5)
	BRNE _0x6E
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,827
	CALL SUBOPT_0x16
; 0000 00EA     if (viz_faza==6)  sprintf (string_LCD_2, "   Û-----I#----Ü");
_0x6E:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x6)
	BRNE _0x6F
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,844
	CALL SUBOPT_0x16
; 0000 00EB     if (viz_faza==7)  sprintf (string_LCD_2, "   Û-----I-#---Ü");
_0x6F:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x7)
	BRNE _0x70
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,861
	CALL SUBOPT_0x16
; 0000 00EC     if (viz_faza==8)  sprintf (string_LCD_2, "   Û-----I--#--Ü");
_0x70:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x8)
	BRNE _0x71
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,878
	CALL SUBOPT_0x16
; 0000 00ED     if (viz_faza==9)  sprintf (string_LCD_2, "   Û-----I---#-Ü");
_0x71:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x9)
	BRNE _0x72
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,895
	CALL SUBOPT_0x16
; 0000 00EE     if (viz_faza==10) sprintf (string_LCD_2, "   Û-----I----#Ü");
_0x72:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xA)
	BRNE _0x73
	CALL SUBOPT_0x17
	__POINTW1FN _0x0,912
	CALL SUBOPT_0x16
; 0000 00EF     lcd_puts (string_LCD_2);
_0x73:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	CALL SUBOPT_0x13
; 0000 00F0     light=0;
	CBI  0x12,6
; 0000 00F1     }
	RET
;
;void real_faza_i_amp (void)
; 0000 00F4     {
_real_faza_i_amp:
; 0000 00F5     #asm("wdr");
	wdr
; 0000 00F6     while (ACSR.5==0);
_0x76:
	SBIS 0x8,5
	RJMP _0x76
; 0000 00F7     while (ACSR.5==1);
_0x79:
	LDI  R26,0
	SBIC 0x8,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x79
; 0000 00F8     while (ACSR.5==0);
_0x7C:
	SBIS 0x8,5
	RJMP _0x7C
; 0000 00F9     while (ACSR.5==1)
_0x7F:
	LDI  R26,0
	SBIC 0x8,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x81
; 0000 00FA         {
; 0000 00FB         x_1=TCNT1;
	__INWR 6,7,44
; 0000 00FC         PORTA.7=1;
	SBI  0x1B,7
; 0000 00FD         };
	RJMP _0x7F
_0x81:
; 0000 00FE     while (ACSR.5==0)
_0x84:
	SBIC 0x8,5
	RJMP _0x86
; 0000 00FF         {
; 0000 0100         x_2=TCNT1;
	__INWR 8,9,44
; 0000 0101         PORTA.7=0;
	CBI  0x1B,7
; 0000 0102         };
	RJMP _0x84
_0x86:
; 0000 0103     if (x_2 > x_1) faza= (x_2 + x_1) / 2;
	__CPWRR 6,7,8,9
	BRGE _0x89
	MOVW R26,R6
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R10,R30
; 0000 0104     if (x_2 < x_1)
_0x89:
	__CPWRR 8,9,6,7
	BRGE _0x8A
; 0000 0105         {
; 0000 0106         faza= (x_1 - x_2) + (x_1 + x_2) / 2;
	MOVW R30,R6
	SUB  R30,R8
	SBC  R31,R9
	MOVW R22,R30
	MOVW R26,R8
	ADD  R26,R6
	ADC  R27,R7
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ADD  R30,R22
	ADC  R31,R23
	MOVW R10,R30
; 0000 0107         if (faza > period) faza = faza - period;   // ICR1
	CALL SUBOPT_0x18
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x8B
	LDS  R26,_period
	LDS  R27,_period+1
	__SUBWRR 10,11,26,27
; 0000 0108         };
_0x8B:
_0x8A:
; 0000 0109     while (TCNT1 != faza);
_0x8C:
	IN   R30,0x2C
	IN   R31,0x2C+1
	CP   R10,R30
	CPC  R11,R31
	BRNE _0x8C
; 0000 010A     PORTA.6=1;
	SBI  0x1B,6
; 0000 010B     amplituda=read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R12,R30
; 0000 010C     PORTA.6=0;
	CBI  0x1B,6
; 0000 010D     }
	RET
;
;float vektor_amp (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
; 0000 0110     {
_vektor_amp:
; 0000 0111     long int Y;
; 0000 0112     long int X;
; 0000 0113     long unsigned int temp3;
; 0000 0114     float temp;
; 0000 0115     #asm("wdr");
	SBIW R28,16
;	koord_1_1 -> Y+22
;	koord_1_2 -> Y+20
;	koord_2_1 -> Y+18
;	koord_2_2 -> Y+16
;	Y -> Y+12
;	X -> Y+8
;	temp3 -> Y+4
;	temp -> Y+0
	wdr
; 0000 0116     koord_1_1 = koord_1_1 /2;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LSR  R31
	ROR  R30
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0000 0117     koord_1_2 = koord_1_2 /2;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	LSR  R31
	ROR  R30
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 0118     koord_2_1 = koord_2_1 /2;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LSR  R31
	ROR  R30
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 0119     koord_2_2 = koord_2_2 /2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LSR  R31
	ROR  R30
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 011A     if (koord_1_1 > koord_2_1) Y = koord_1_1 - koord_2_1;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x93
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RJMP _0x11A
; 0000 011B     else Y = koord_2_1 - koord_1_1;
_0x93:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
_0x11A:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x19
; 0000 011C     if (koord_1_2 > koord_2_2) X = koord_1_2 - koord_2_2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x95
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RJMP _0x11B
; 0000 011D     else X = koord_2_2 - koord_1_2;
_0x95:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
_0x11B:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 8
; 0000 011E     temp3  = Y*Y + X*X;
	CALL SUBOPT_0x1A
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 8
	CALL SUBOPT_0x1B
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0x1C
; 0000 011F     temp = sqrt (temp3);
	CALL __CDF1U
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
; 0000 0120     return temp;
	CALL SUBOPT_0x1F
	RJMP _0x20C0009
; 0000 0121     }
;
;
;float vektor_faza (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
; 0000 0125     {
_vektor_faza:
; 0000 0126     signed int Y;
; 0000 0127     signed int X;
; 0000 0128     float temp;
; 0000 0129     #asm("wdr");
	SBIW R28,4
	CALL __SAVELOCR4
;	koord_1_1 -> Y+14
;	koord_1_2 -> Y+12
;	koord_2_1 -> Y+10
;	koord_2_2 -> Y+8
;	Y -> R16,R17
;	X -> R18,R19
;	temp -> Y+4
	wdr
; 0000 012A     Y = koord_1_1 - koord_2_1;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 012B     X = koord_1_2 - koord_2_2;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0000 012C     temp = atan2 (Y,X);
	MOVW R30,R16
	CALL SUBOPT_0x20
	MOVW R30,R18
	CALL SUBOPT_0x20
	CALL _atan2
	CALL SUBOPT_0x1C
; 0000 012D     return temp;
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; 0000 012E     }
;
;float th_cos (float a, float aa_x, float b, float bb_x)
; 0000 0131     {
_th_cos:
; 0000 0132     float c;
; 0000 0133     float aabb;
; 0000 0134     #asm("wdr");
	SBIW R28,8
;	a -> Y+20
;	aa_x -> Y+16
;	b -> Y+12
;	bb_x -> Y+8
;	c -> Y+4
;	aabb -> Y+0
	wdr
; 0000 0135     aabb = aa_x - bb_x;
	CALL SUBOPT_0x1B
	__GETD1S 16
	CALL __SUBF12
	CALL SUBOPT_0x1E
; 0000 0136     c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
	__GETD1S 20
	__GETD2S 20
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1A
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 20
	__GETD2N 0x40000000
	CALL SUBOPT_0x21
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x22
	CALL _cos
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
; 0000 0137     return c;
_0x20C0009:
	ADIW R28,24
	RET
; 0000 0138     }
;
;float th_sin (float c, int b_y, int b_x, int c_y, int c_x)
; 0000 013B     {
_th_sin:
; 0000 013C     int ab;
; 0000 013D     float temp;
; 0000 013E     #asm("wdr");
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	c -> Y+14
;	b_y -> Y+12
;	b_x -> Y+10
;	c_y -> Y+8
;	c_x -> Y+6
;	ab -> R16,R17
;	temp -> Y+2
	wdr
; 0000 013F     if (b_y > c_y) ab = b_y - c_y;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x97
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RJMP _0x11C
; 0000 0140     else ab = c_y - b_y;
_0x97:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x11C:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0141     temp = asin (ab/c);
	__GETD1S 14
	MOVW R26,R16
	CALL __CWD2
	CALL __CDF2
	CALL SUBOPT_0x24
	CALL _asin
	CALL SUBOPT_0x25
; 0000 0142     if (c_x > b_x) temp = 3.141593 - temp;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x99
	CALL SUBOPT_0x26
	__GETD1N 0x40490FDC
	CALL __SUBF12
	CALL SUBOPT_0x25
; 0000 0143     return temp;
_0x99:
	CALL SUBOPT_0x27
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
; 0000 0144     }
;
;void main_menu(void)
; 0000 0147     {
_main_menu:
; 0000 0148     #asm("wdr");
	wdr
; 0000 0149     menu++;
	LDS  R30,_menu
	SUBI R30,-LOW(1)
	STS  _menu,R30
; 0000 014A     if (menu==255) menu=3;
	LDS  R26,_menu
	CPI  R26,LOW(0xFF)
	BRNE _0x9A
	LDI  R30,LOW(3)
	STS  _menu,R30
; 0000 014B     if (menu==4) menu=0;
_0x9A:
	LDS  R26,_menu
	CPI  R26,LOW(0x4)
	BRNE _0x9B
	LDI  R30,LOW(0)
	STS  _menu,R30
; 0000 014C     while (kn1==1)
_0x9B:
_0x9C:
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x9E
; 0000 014D         {
; 0000 014E         kn_klava();
	CALL SUBOPT_0x28
; 0000 014F         lcd_disp();
; 0000 0150         };
	RJMP _0x9C
_0x9E:
; 0000 0151     }
	RET
;
;void volume(void)
; 0000 0154     {
_volume:
; 0000 0155     #asm("wdr");
	wdr
; 0000 0156     if (menu==2) tik_new++;
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x9F
	LDS  R30,_tik_new
	SUBI R30,-LOW(1)
	STS  _tik_new,R30
; 0000 0157     if (menu==3) gnd_rage++;
_0x9F:
	LDS  R26,_menu
	CPI  R26,LOW(0x3)
	BRNE _0xA0
	LDS  R30,_gnd_rage
	SUBI R30,-LOW(1)
	STS  _gnd_rage,R30
; 0000 0158     else vol++;
	RJMP _0xA1
_0xA0:
	LDS  R30,_vol
	SUBI R30,-LOW(1)
	STS  _vol,R30
; 0000 0159     if (vol==10) vol=0;
_0xA1:
	LDS  R26,_vol
	CPI  R26,LOW(0xA)
	BRNE _0xA2
	LDI  R30,LOW(0)
	STS  _vol,R30
; 0000 015A     while (kn2==1)
_0xA2:
_0xA3:
	CALL SUBOPT_0xD
	BRNE _0xA5
; 0000 015B         {
; 0000 015C         kn_klava();
	CALL SUBOPT_0x28
; 0000 015D         lcd_disp();
; 0000 015E         };
	RJMP _0xA3
_0xA5:
; 0000 015F     }
	RET
;
;void barrier(void)
; 0000 0162     {
_barrier:
; 0000 0163     #asm("wdr");
	wdr
; 0000 0164     if (menu==2) tik_new--;
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0xA6
	LDS  R30,_tik_new
	SUBI R30,LOW(1)
	STS  _tik_new,R30
; 0000 0165     if (menu==3) gnd_rage--;
_0xA6:
	LDS  R26,_menu
	CPI  R26,LOW(0x3)
	BRNE _0xA7
	LDS  R30,_gnd_rage
	SUBI R30,LOW(1)
	STS  _gnd_rage,R30
; 0000 0166     else bar++;
	RJMP _0xA8
_0xA7:
	LDS  R30,_bar
	SUBI R30,-LOW(1)
	STS  _bar,R30
; 0000 0167     if (bar==10) bar=0;
_0xA8:
	LDS  R26,_bar
	CPI  R26,LOW(0xA)
	BRNE _0xA9
	LDI  R30,LOW(0)
	STS  _bar,R30
; 0000 0168     while (kn3==1)
_0xA9:
_0xAA:
	CALL SUBOPT_0xF
	BRNE _0xAC
; 0000 0169         {
; 0000 016A         kn_klava();
	CALL SUBOPT_0x28
; 0000 016B         lcd_disp();
; 0000 016C         };
	RJMP _0xAA
_0xAC:
; 0000 016D     }
	RET
;
;void rock(void)
; 0000 0170     {
_rock:
; 0000 0171     #asm("wdr");
	wdr
; 0000 0172     rock_amplituda = vektor_amp(amplituda, faza, zero_amplituda, zero_faza);
	CALL SUBOPT_0x29
	RCALL _vektor_amp
	STS  _rock_amplituda,R30
	STS  _rock_amplituda+1,R31
	STS  _rock_amplituda+2,R22
	STS  _rock_amplituda+3,R23
; 0000 0173     rock_faza = vektor_faza(amplituda, faza, zero_amplituda, zero_faza);
	CALL SUBOPT_0x29
	RCALL _vektor_faza
	STS  _rock_faza,R30
	STS  _rock_faza+1,R31
	STS  _rock_faza+2,R22
	STS  _rock_faza+3,R23
; 0000 0174     }
	RET
;
;void ground(void)
; 0000 0177     {
_ground:
; 0000 0178     #asm("wdr");
	wdr
; 0000 0179     y_gnd = amplituda;
	__PUTWMRN _y_gnd,0,12,13
; 0000 017A     x_gnd = faza;
	__PUTWMRN _x_gnd,0,10,11
; 0000 017B     gnd_amplituda = vektor_amp(amplituda, faza, zero_amplituda, zero_faza);
	CALL SUBOPT_0x29
	RCALL _vektor_amp
	STS  _gnd_amplituda,R30
	STS  _gnd_amplituda+1,R31
	STS  _gnd_amplituda+2,R22
	STS  _gnd_amplituda+3,R23
; 0000 017C     gnd_faza = vektor_faza(amplituda, faza, zero_amplituda, zero_faza);
	CALL SUBOPT_0x29
	RCALL _vektor_faza
	STS  _gnd_faza,R30
	STS  _gnd_faza+1,R31
	STS  _gnd_faza+2,R22
	STS  _gnd_faza+3,R23
; 0000 017D     }
	RET
;
;void zero(void)
; 0000 0180     {
_zero:
; 0000 0181     #asm("wdr");
	wdr
; 0000 0182     zero_amplituda=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _zero_amplituda,R30
	STS  _zero_amplituda+1,R31
; 0000 0183     zero_faza=0x0320;
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	STS  _zero_faza,R30
	STS  _zero_faza+1,R31
; 0000 0184 //    zero_amplituda=amplituda;
; 0000 0185 //    zero_faza=faza;
; 0000 0186     }
	RET
;
;void TX_calibration(void)
; 0000 0189     {
_TX_calibration:
; 0000 018A     if (tik_old < tik_new)
	LDS  R30,_tik_new
	LDS  R26,_tik_old
	CP   R26,R30
	BRSH _0xAD
; 0000 018B         {
; 0000 018C         PORTD.0=0;
	CBI  0x12,0
; 0000 018D         delay_ms(1);
	CALL SUBOPT_0x2
; 0000 018E         PORTD.0=1;
	SBI  0x12,0
; 0000 018F         tik_old = tik_new;
	LDS  R30,_tik_new
	STS  _tik_old,R30
; 0000 0190         };
_0xAD:
; 0000 0191     if  (tik_old > tik_new)
	LDS  R30,_tik_new
	LDS  R26,_tik_old
	CP   R30,R26
	BRSH _0xB2
; 0000 0192         {
; 0000 0193         PORTD.1=0;
	CBI  0x12,1
; 0000 0194         delay_ms(1);
	CALL SUBOPT_0x2
; 0000 0195         PORTD.1=1;
	SBI  0x12,1
; 0000 0196         tik_old = tik_new;
	LDS  R30,_tik_new
	STS  _tik_old,R30
; 0000 0197         };
_0xB2:
; 0000 0198     viz_period = period / 8;
	CALL SUBOPT_0x18
	CALL __LSRW3
	STS  _viz_period,R30
	STS  _viz_period+1,R31
; 0000 0199     }
	RET
;
;void main(void)
; 0000 019C {
_main:
; 0000 019D // Declare your local variables here
; 0000 019E 
; 0000 019F // Input/Output Ports initialization
; 0000 01A0 // Port A initialization
; 0000 01A1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01A2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01A3 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01A4 DDRA=0xC0;
	LDI  R30,LOW(192)
	OUT  0x1A,R30
; 0000 01A5 
; 0000 01A6 // Port B initialization
; 0000 01A7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01A8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01A9 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 01AA DDRB=0x00;
	OUT  0x17,R30
; 0000 01AB 
; 0000 01AC // Port C initialization
; 0000 01AD // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01AE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01AF PORTC=0x00;
	OUT  0x15,R30
; 0000 01B0 DDRC=0x00;
	OUT  0x14,R30
; 0000 01B1 
; 0000 01B2 // Port D initialization
; 0000 01B3 // Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 01B4 // State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=0
; 0000 01B5 PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 01B6 DDRD=0xA3;
	LDI  R30,LOW(163)
	OUT  0x11,R30
; 0000 01B7 
; 0000 01B8 // Analog Comparator initialization
; 0000 01B9 // Analog Comparator: On
; 0000 01BA // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01BB ACSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 01BC SFIOR=0x00;
	OUT  0x30,R30
; 0000 01BD 
; 0000 01BE // ADC initialization
; 0000 01BF // ADC Clock frequency: 1000,000 kHz
; 0000 01C0 // ADC Voltage Reference: AREF pin
; 0000 01C1 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 01C2 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 01C3 
; 0000 01C4 // Timer/Counter 0 initialization
; 0000 01C5 // Clock source: System Clock
; 0000 01C6 // Clock value: Timer 0 Stopped
; 0000 01C7 // Mode: Phase correct PWM top=FFh
; 0000 01C8 // OC0 output: Disconnected
; 0000 01C9 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01CA TCNT0=0x00;
	OUT  0x32,R30
; 0000 01CB OCR0=0x00;
	OUT  0x3C,R30
; 0000 01CC 
; 0000 01CD // Timer/Counter 1 initialization
; 0000 01CE // Clock source: System Clock
; 0000 01CF // Clock value: 8000,000 kHz
; 0000 01D0 // Mode: Fast PWM top=ICR1
; 0000 01D1 // OC1A output: Non-Inv.
; 0000 01D2 // OC1B output: Discon.
; 0000 01D3 // Noise Canceler: Off
; 0000 01D4 // Input Capture on Falling Edge
; 0000 01D5 // Timer 1 Overflow Interrupt: Off
; 0000 01D6 // Input Capture Interrupt: Off
; 0000 01D7 // Compare A Match Interrupt: Off
; 0000 01D8 // Compare B Match Interrupt: Off
; 0000 01D9 TCCR1A=0x82;
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 01DA TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 01DB TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01DC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01DD ICR1H=0x06;
	LDI  R30,LOW(6)
	OUT  0x27,R30
; 0000 01DE ICR1L=0x3F;
	LDI  R30,LOW(63)
	OUT  0x26,R30
; 0000 01DF OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01E0 OCR1AL=0x0F;
	LDI  R30,LOW(15)
	OUT  0x2A,R30
; 0000 01E1 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 01E2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01E3 
; 0000 01E4 // Timer/Counter 2 initialization
; 0000 01E5 // Clock source: System Clock
; 0000 01E6 // Clock value: 8000,000 kHz
; 0000 01E7 // Mode: Phase correct PWM top=FFh
; 0000 01E8 // OC2 output: Non-Inverted PWM
; 0000 01E9 ASSR=0x00;
	OUT  0x22,R30
; 0000 01EA TCCR2=0x61;
	LDI  R30,LOW(97)
	OUT  0x25,R30
; 0000 01EB TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01EC OCR2=0x7F;
	LDI  R30,LOW(127)
	OUT  0x23,R30
; 0000 01ED 
; 0000 01EE // External Interrupt(s) initialization
; 0000 01EF // INT0: Off
; 0000 01F0 // INT1: Off
; 0000 01F1 // INT2: Off
; 0000 01F2 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 01F3 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01F4 
; 0000 01F5 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01F6 TIMSK=0x0C;
	LDI  R30,LOW(12)
	OUT  0x39,R30
; 0000 01F7 
; 0000 01F8 // Watchdog Timer initialization
; 0000 01F9 // Watchdog Timer Prescaler: OSC/2048k
; 0000 01FA WDTCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x21,R30
; 0000 01FB 
; 0000 01FC 
; 0000 01FD // LCD module initialization
; 0000 01FE lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01FF 
; 0000 0200 
; 0000 0201 lcd_gotoxy (0,0);
	CALL SUBOPT_0x14
; 0000 0202 sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,929
	CALL SUBOPT_0xB
; 0000 0203 lcd_puts (string_LCD_1);
; 0000 0204 lcd_gotoxy (0,1);
; 0000 0205 sprintf (string_LCD_2, "   v0.4   ^_^   ");
	__POINTW1FN _0x0,946
	CALL SUBOPT_0x16
; 0000 0206 lcd_puts (string_LCD_2);
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	CALL SUBOPT_0x13
; 0000 0207 delay_ms (2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0208 
; 0000 0209 tik_new=1;
	LDI  R30,LOW(1)
	STS  _tik_new,R30
; 0000 020A period=0x063F;              //period
	LDI  R30,LOW(1599)
	LDI  R31,HIGH(1599)
	STS  _period,R30
	STS  _period+1,R31
; 0000 020B x_gnd=period/2;
	CALL SUBOPT_0x18
	LSR  R31
	ROR  R30
	STS  _x_gnd,R30
	STS  _x_gnd+1,R31
; 0000 020C zero_faza=period/2;
	CALL SUBOPT_0x18
	LSR  R31
	ROR  R30
	STS  _zero_faza,R30
	STS  _zero_faza+1,R31
; 0000 020D 
; 0000 020E while (1)
_0xB7:
; 0000 020F       {
; 0000 0210       // Place your code here
; 0000 0211       float temp_amplituda;
; 0000 0212       float temp_faza;
; 0000 0213       #asm("wdr");
	SBIW R28,8
;	temp_amplituda -> Y+4
;	temp_faza -> Y+0
	wdr
; 0000 0214       real_faza_i_amp ();
	RCALL _real_faza_i_amp
; 0000 0215       kn_klava();
	CALL _kn_klava
; 0000 0216       if (kn1==1) main_menu();
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBA
	RCALL _main_menu
; 0000 0217       if (kn2==1) volume();
_0xBA:
	CALL SUBOPT_0xD
	BRNE _0xBB
	RCALL _volume
; 0000 0218       if (kn3==1) barrier();
_0xBB:
	CALL SUBOPT_0xF
	BRNE _0xBC
	RCALL _barrier
; 0000 0219       if (kn4==1) rock();
_0xBC:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBD
	RCALL _rock
; 0000 021A       if (kn5==1) ground();
_0xBD:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBE
	RCALL _ground
; 0000 021B       if (kn6==1) zero();
_0xBE:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBF
	RCALL _zero
; 0000 021C       if (menu==2) TX_calibration();
_0xBF:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0xC0
	RCALL _TX_calibration
; 0000 021D 
; 0000 021E 
; 0000 021F       now_amplituda= vektor_amp (amplituda, faza, zero_amplituda, zero_faza);
_0xC0:
	CALL SUBOPT_0x29
	RCALL _vektor_amp
	STS  _now_amplituda,R30
	STS  _now_amplituda+1,R31
	STS  _now_amplituda+2,R22
	STS  _now_amplituda+3,R23
; 0000 0220       now_faza= vektor_faza (amplituda, faza, zero_amplituda, zero_faza);
	CALL SUBOPT_0x29
	RCALL _vektor_faza
	STS  _now_faza,R30
	STS  _now_faza+1,R31
	STS  _now_faza+2,R22
	STS  _now_faza+3,R23
; 0000 0221 
; 0000 0222       temp_amplituda = th_cos (now_amplituda, now_faza, gnd_amplituda, gnd_faza);
	LDS  R30,_now_amplituda
	LDS  R31,_now_amplituda+1
	LDS  R22,_now_amplituda+2
	LDS  R23,_now_amplituda+3
	CALL __PUTPARD1
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
	CALL __PUTPARD1
	CALL SUBOPT_0x10
	RCALL _th_cos
	CALL SUBOPT_0x1C
; 0000 0223       temp_faza = th_sin (temp_amplituda, amplituda, faza, y_gnd, x_gnd);
	CALL __PUTPARD1
	ST   -Y,R13
	ST   -Y,R12
	ST   -Y,R11
	ST   -Y,R10
	LDS  R30,_y_gnd
	LDS  R31,_y_gnd+1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_x_gnd
	LDS  R31,_x_gnd+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _th_sin
	CALL SUBOPT_0x2A
; 0000 0224 
; 0000 0225 
; 0000 0226 //      temp_amplituda= temp_amplituda - gnd_amplituda;
; 0000 0227 //      temp_faza= temp_faza - gnd_faza;
; 0000 0228       if (temp_amplituda> 2079 ) viz_amplituda=32;
	__GETD1N 0x4501F000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC1
	LDI  R30,LOW(32)
	RJMP _0x11D
; 0000 0229       else if (temp_amplituda> 2016 ) viz_amplituda=31;
_0xC1:
	CALL SUBOPT_0x2B
	__GETD1N 0x44FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC3
	LDI  R30,LOW(31)
	RJMP _0x11D
; 0000 022A       else if (temp_amplituda> 1953 ) viz_amplituda=30;
_0xC3:
	CALL SUBOPT_0x2B
	__GETD1N 0x44F42000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC5
	LDI  R30,LOW(30)
	RJMP _0x11D
; 0000 022B       else if (temp_amplituda> 1890 ) viz_amplituda=29;
_0xC5:
	CALL SUBOPT_0x2B
	__GETD1N 0x44EC4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC7
	LDI  R30,LOW(29)
	RJMP _0x11D
; 0000 022C       else if (temp_amplituda> 1827 ) viz_amplituda=28;
_0xC7:
	CALL SUBOPT_0x2B
	__GETD1N 0x44E46000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC9
	LDI  R30,LOW(28)
	RJMP _0x11D
; 0000 022D       else if (temp_amplituda> 1764 ) viz_amplituda=27;
_0xC9:
	CALL SUBOPT_0x2B
	__GETD1N 0x44DC8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCB
	LDI  R30,LOW(27)
	RJMP _0x11D
; 0000 022E       else if (temp_amplituda> 1701 ) viz_amplituda=26;
_0xCB:
	CALL SUBOPT_0x2B
	__GETD1N 0x44D4A000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCD
	LDI  R30,LOW(26)
	RJMP _0x11D
; 0000 022F       else if (temp_amplituda> 1638 ) viz_amplituda=25;
_0xCD:
	CALL SUBOPT_0x2B
	__GETD1N 0x44CCC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCF
	LDI  R30,LOW(25)
	RJMP _0x11D
; 0000 0230       else if (temp_amplituda> 1575 ) viz_amplituda=24;
_0xCF:
	CALL SUBOPT_0x2B
	__GETD1N 0x44C4E000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD1
	LDI  R30,LOW(24)
	RJMP _0x11D
; 0000 0231       else if (temp_amplituda> 1512 ) viz_amplituda=23;
_0xD1:
	CALL SUBOPT_0x2B
	__GETD1N 0x44BD0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD3
	LDI  R30,LOW(23)
	RJMP _0x11D
; 0000 0232       else if (temp_amplituda> 1449 ) viz_amplituda=22;
_0xD3:
	CALL SUBOPT_0x2B
	__GETD1N 0x44B52000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD5
	LDI  R30,LOW(22)
	RJMP _0x11D
; 0000 0233       else if (temp_amplituda> 1386 ) viz_amplituda=21;
_0xD5:
	CALL SUBOPT_0x2B
	__GETD1N 0x44AD4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD7
	LDI  R30,LOW(21)
	RJMP _0x11D
; 0000 0234       else if (temp_amplituda> 1323 ) viz_amplituda=20;
_0xD7:
	CALL SUBOPT_0x2B
	__GETD1N 0x44A56000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD9
	LDI  R30,LOW(20)
	RJMP _0x11D
; 0000 0235       else if (temp_amplituda> 1260 ) viz_amplituda=19;
_0xD9:
	CALL SUBOPT_0x2B
	__GETD1N 0x449D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDB
	LDI  R30,LOW(19)
	RJMP _0x11D
; 0000 0236       else if (temp_amplituda> 1197 ) viz_amplituda=18;
_0xDB:
	CALL SUBOPT_0x2B
	__GETD1N 0x4495A000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDD
	LDI  R30,LOW(18)
	RJMP _0x11D
; 0000 0237       else if (temp_amplituda> 1134 ) viz_amplituda=17;
_0xDD:
	CALL SUBOPT_0x2B
	__GETD1N 0x448DC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDF
	LDI  R30,LOW(17)
	RJMP _0x11D
; 0000 0238       else if (temp_amplituda> 1071 ) viz_amplituda=16;
_0xDF:
	CALL SUBOPT_0x2B
	__GETD1N 0x4485E000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE1
	LDI  R30,LOW(16)
	RJMP _0x11D
; 0000 0239       else if (temp_amplituda> 1008 ) viz_amplituda=15;
_0xE1:
	CALL SUBOPT_0x2B
	__GETD1N 0x447C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE3
	LDI  R30,LOW(15)
	RJMP _0x11D
; 0000 023A       else if (temp_amplituda> 945  ) viz_amplituda=14;
_0xE3:
	CALL SUBOPT_0x2B
	__GETD1N 0x446C4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE5
	LDI  R30,LOW(14)
	RJMP _0x11D
; 0000 023B       else if (temp_amplituda> 882  ) viz_amplituda=13;
_0xE5:
	CALL SUBOPT_0x2B
	__GETD1N 0x445C8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE7
	LDI  R30,LOW(13)
	RJMP _0x11D
; 0000 023C       else if (temp_amplituda> 819  ) viz_amplituda=12;
_0xE7:
	CALL SUBOPT_0x2B
	__GETD1N 0x444CC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE9
	LDI  R30,LOW(12)
	RJMP _0x11D
; 0000 023D       else if (temp_amplituda> 756  ) viz_amplituda=11;
_0xE9:
	CALL SUBOPT_0x2B
	__GETD1N 0x443D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEB
	LDI  R30,LOW(11)
	RJMP _0x11D
; 0000 023E       else if (temp_amplituda> 693  ) viz_amplituda=10;
_0xEB:
	CALL SUBOPT_0x2B
	__GETD1N 0x442D4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xED
	LDI  R30,LOW(10)
	RJMP _0x11D
; 0000 023F       else if (temp_amplituda> 630  ) viz_amplituda=9;
_0xED:
	CALL SUBOPT_0x2B
	__GETD1N 0x441D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEF
	LDI  R30,LOW(9)
	RJMP _0x11D
; 0000 0240       else if (temp_amplituda> 567  ) viz_amplituda=8;
_0xEF:
	CALL SUBOPT_0x2B
	__GETD1N 0x440DC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF1
	LDI  R30,LOW(8)
	RJMP _0x11D
; 0000 0241       else if (temp_amplituda> 504  ) viz_amplituda=7;
_0xF1:
	CALL SUBOPT_0x2B
	__GETD1N 0x43FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF3
	LDI  R30,LOW(7)
	RJMP _0x11D
; 0000 0242       else if (temp_amplituda> 441  ) viz_amplituda=6;
_0xF3:
	CALL SUBOPT_0x2B
	__GETD1N 0x43DC8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF5
	LDI  R30,LOW(6)
	RJMP _0x11D
; 0000 0243       else if (temp_amplituda> 378  ) viz_amplituda=5;
_0xF5:
	CALL SUBOPT_0x2B
	__GETD1N 0x43BD0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF7
	LDI  R30,LOW(5)
	RJMP _0x11D
; 0000 0244       else if (temp_amplituda> 315  ) viz_amplituda=4;
_0xF7:
	CALL SUBOPT_0x2B
	__GETD1N 0x439D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF9
	LDI  R30,LOW(4)
	RJMP _0x11D
; 0000 0245       else if (temp_amplituda> 252  ) viz_amplituda=3;
_0xF9:
	CALL SUBOPT_0x2B
	__GETD1N 0x437C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFB
	LDI  R30,LOW(3)
	RJMP _0x11D
; 0000 0246       else if (temp_amplituda> 189  ) viz_amplituda=2;
_0xFB:
	CALL SUBOPT_0x2B
	__GETD1N 0x433D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFD
	LDI  R30,LOW(2)
	RJMP _0x11D
; 0000 0247       else if (temp_amplituda> 126  ) viz_amplituda=1;
_0xFD:
	CALL SUBOPT_0x2B
	__GETD1N 0x42FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFF
	LDI  R30,LOW(1)
	RJMP _0x11D
; 0000 0248       else if (temp_amplituda> 63   ) viz_amplituda=0;
_0xFF:
	CALL SUBOPT_0x2B
	__GETD1N 0x427C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x101
_0x11D:
	STS  _viz_amplituda,R30
; 0000 0249 
; 0000 024A       if (temp_faza> 3.14) viz_faza=0;
_0x101:
	CALL SUBOPT_0x2C
	__GETD1N 0x4048F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x102
	LDI  R30,LOW(0)
	RJMP _0x11E
; 0000 024B       else if (temp_faza> 2.86) viz_faza=5;
_0x102:
	CALL SUBOPT_0x2C
	__GETD1N 0x40370A3D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x104
	LDI  R30,LOW(5)
	RJMP _0x11E
; 0000 024C       else if (temp_faza> 2.57) viz_faza=4;
_0x104:
	CALL SUBOPT_0x2C
	__GETD1N 0x40247AE1
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x106
	LDI  R30,LOW(4)
	RJMP _0x11E
; 0000 024D       else if (temp_faza> 2.28) viz_faza=3;
_0x106:
	CALL SUBOPT_0x2C
	__GETD1N 0x4011EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x108
	LDI  R30,LOW(3)
	RJMP _0x11E
; 0000 024E       else if (temp_faza> 2.00) viz_faza=2;
_0x108:
	CALL SUBOPT_0x2C
	__GETD1N 0x40000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10A
	LDI  R30,LOW(2)
	RJMP _0x11E
; 0000 024F       else if (temp_faza> 1.71) viz_faza=1;
_0x10A:
	CALL SUBOPT_0x2C
	__GETD1N 0x3FDAE148
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10C
	LDI  R30,LOW(1)
	RJMP _0x11E
; 0000 0250       else if (temp_faza> 1.43) viz_faza=0;
_0x10C:
	CALL SUBOPT_0x2C
	__GETD1N 0x3FB70A3D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10E
	LDI  R30,LOW(0)
	RJMP _0x11E
; 0000 0251       else if (temp_faza> 1.14) viz_faza=6;
_0x10E:
	CALL SUBOPT_0x2C
	__GETD1N 0x3F91EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x110
	LDI  R30,LOW(6)
	RJMP _0x11E
; 0000 0252       else if (temp_faza> 0.86) viz_faza=7;
_0x110:
	CALL SUBOPT_0x2C
	__GETD1N 0x3F5C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x112
	LDI  R30,LOW(7)
	RJMP _0x11E
; 0000 0253       else if (temp_faza> 0.57) viz_faza=8;
_0x112:
	CALL SUBOPT_0x2C
	__GETD1N 0x3F11EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x114
	LDI  R30,LOW(8)
	RJMP _0x11E
; 0000 0254       else if (temp_faza> 0.29) viz_faza=9;
_0x114:
	CALL SUBOPT_0x2C
	__GETD1N 0x3E947AE1
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x116
	LDI  R30,LOW(9)
	RJMP _0x11E
; 0000 0255       else if (temp_faza> 0.00) viz_faza=10;
_0x116:
	CALL SUBOPT_0x2C
	CALL __CPD02
	BRGE _0x118
	LDI  R30,LOW(10)
_0x11E:
	STS  _viz_faza,R30
; 0000 0256 
; 0000 0257       batt_zarqd();
_0x118:
	CALL _batt_zarqd
; 0000 0258       lcd_disp();
	CALL _lcd_disp
; 0000 0259       #asm("wdr");
	wdr
; 0000 025A       };
	ADIW R28,8
	RJMP _0xB7
; 0000 025B }
_0x119:
	RJMP _0x119
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
	JMP  _0x20C0008
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
	JMP  _0x20C0008
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
	JMP  _0x20C0008
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
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2D
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x2E
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2E
	LDI  R30,LOW(133)
	CALL SUBOPT_0x2E
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0007
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0007
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
_0x20C0008:
_0x20C0007:
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
	CALL SUBOPT_0x2F
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
__ftoe_G101:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,0
	CALL SUBOPT_0x30
	RJMP _0x20C0006
_0x2020018:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020017
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,1
	CALL SUBOPT_0x30
	RJMP _0x20C0006
_0x2020017:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001A
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001A:
	LDD  R17,Y+11
_0x202001B:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001D
	CALL SUBOPT_0x31
	RJMP _0x202001B
_0x202001D:
	CALL SUBOPT_0x32
	CALL __CPD10
	BRNE _0x202001E
	LDI  R19,LOW(0)
	CALL SUBOPT_0x31
	RJMP _0x202001F
_0x202001E:
	LDD  R19,Y+11
	CALL SUBOPT_0x33
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020020
	CALL SUBOPT_0x31
_0x2020021:
	CALL SUBOPT_0x33
	BRLO _0x2020023
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	RJMP _0x2020021
_0x2020023:
	RJMP _0x2020024
_0x2020020:
_0x2020025:
	CALL SUBOPT_0x33
	BRSH _0x2020027
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL SUBOPT_0x19
	SUBI R19,LOW(1)
	RJMP _0x2020025
_0x2020027:
	CALL SUBOPT_0x31
_0x2020024:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
	CALL SUBOPT_0x19
	CALL SUBOPT_0x33
	BRLO _0x2020028
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
_0x2020028:
_0x202001F:
	LDI  R17,LOW(0)
_0x2020029:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	CALL SUBOPT_0x39
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x34
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	ADIW R30,48
	ST   X,R30
	MOV  R30,R16
	CALL __CBD1
	CALL __CDF1
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x21
	CALL SUBOPT_0x23
	CALL SUBOPT_0x19
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2020029
	CALL SUBOPT_0x3A
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2020029
_0x202002B:
	CALL SUBOPT_0x3C
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002D
	CALL SUBOPT_0x3A
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x202002D:
	CPI  R19,10
	BRLT _0x202002E
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL __DIVW21
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
_0x202002E:
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL __MODW21
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G101:
	SBIW R28,63
	SBIW R28,15
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 84
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x202002F:
	MOVW R26,R28
	SUBI R26,LOW(-(90))
	SBCI R27,HIGH(-(90))
	CALL SUBOPT_0x2F
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020031
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	BRNE _0x2020035
	CPI  R18,37
	BRNE _0x2020036
	LDI  R17,LOW(1)
	RJMP _0x2020037
_0x2020036:
	CALL SUBOPT_0x3E
_0x2020037:
	RJMP _0x2020034
_0x2020035:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2020038
	CPI  R18,37
	BRNE _0x2020039
	CALL SUBOPT_0x3E
	RJMP _0x2020101
_0x2020039:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+19,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003A
	LDI  R16,LOW(1)
	RJMP _0x2020034
_0x202003A:
	CPI  R18,43
	BRNE _0x202003B
	LDI  R30,LOW(43)
	STD  Y+19,R30
	RJMP _0x2020034
_0x202003B:
	CPI  R18,32
	BRNE _0x202003C
	LDI  R30,LOW(32)
	STD  Y+19,R30
	RJMP _0x2020034
_0x202003C:
	RJMP _0x202003D
_0x2020038:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x202003E
_0x202003D:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x202003F
	CALL SUBOPT_0x3F
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x2020034
_0x202003F:
	RJMP _0x2020040
_0x202003E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2020041
_0x2020040:
	CPI  R18,48
	BRLO _0x2020043
	CPI  R18,58
	BRLO _0x2020044
_0x2020043:
	RJMP _0x2020042
_0x2020044:
	MOV  R26,R21
	CALL SUBOPT_0x40
	MOV  R21,R30
	MOV  R22,R21
	CALL SUBOPT_0x41
	MOV  R21,R30
	RJMP _0x2020034
_0x2020042:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020045
	LDI  R17,LOW(4)
	RJMP _0x2020034
_0x2020045:
	RJMP _0x2020046
_0x2020041:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2020048
	CPI  R18,48
	BRLO _0x202004A
	CPI  R18,58
	BRLO _0x202004B
_0x202004A:
	RJMP _0x2020049
_0x202004B:
	CALL SUBOPT_0x3F
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	OR   R30,R26
	MOV  R16,R30
	MOV  R26,R20
	CALL SUBOPT_0x40
	MOV  R20,R30
	MOV  R22,R20
	CALL SUBOPT_0x41
	MOV  R20,R30
	RJMP _0x2020034
_0x2020049:
_0x2020046:
	CPI  R18,108
	BRNE _0x202004C
	CALL SUBOPT_0x3F
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	OR   R30,R26
	MOV  R16,R30
	LDI  R17,LOW(5)
	RJMP _0x2020034
_0x202004C:
	RJMP _0x202004D
_0x2020048:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2020034
_0x202004D:
	CALL SUBOPT_0x42
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x2020052
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	CALL SUBOPT_0x43
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x45
	RJMP _0x2020053
_0x2020052:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BREQ _0x2020056
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x2020057
_0x2020056:
	RJMP _0x2020058
_0x2020057:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2020059
_0x2020058:
	MOVW R30,R28
	ADIW R30,20
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x46
	CALL __GETD1P
	CALL SUBOPT_0x47
	CALL SUBOPT_0x48
	LDD  R26,Y+9
	TST  R26
	BRMI _0x202005A
	LDD  R26,Y+19
	CPI  R26,LOW(0x2B)
	BREQ _0x202005C
	RJMP _0x202005D
_0x202005A:
	CALL SUBOPT_0x49
	CALL __ANEGF1
	CALL SUBOPT_0x47
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x202005C:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4A
	BREQ _0x202005E
	LDD  R30,Y+19
	ST   -Y,R30
	CALL SUBOPT_0x45
	RJMP _0x202005F
_0x202005E:
	CALL SUBOPT_0x4B
	LDD  R26,Y+19
	STD  Z+0,R26
_0x202005F:
_0x202005D:
	CALL SUBOPT_0x3F
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x2020060
	LDI  R20,LOW(6)
_0x2020060:
	CPI  R18,102
	BRNE _0x2020061
	CALL SUBOPT_0x49
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2020062
_0x2020061:
	CALL SUBOPT_0x49
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G101
_0x2020062:
	MOVW R30,R28
	ADIW R30,20
	CALL SUBOPT_0x4C
	RJMP _0x2020063
_0x2020059:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2020065
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4C
	RJMP _0x2020066
_0x2020065:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2020068
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4D
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	CALL SUBOPT_0x3F
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
_0x2020066:
	CALL SUBOPT_0x3F
	LDI  R30,LOW(65407)
	LDI  R31,HIGH(65407)
	AND  R30,R26
	MOV  R16,R30
	CPI  R20,0
	BREQ _0x202006A
	CP   R20,R17
	BRLO _0x202006B
_0x202006A:
	RJMP _0x2020069
_0x202006B:
	MOV  R17,R20
_0x2020069:
_0x2020063:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+18,R30
	LDI  R19,LOW(0)
	RJMP _0x202006C
_0x2020068:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x202006F
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2020070
_0x202006F:
	CALL SUBOPT_0x3F
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x2020071
_0x2020070:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x2020072
_0x2020071:
	LDI  R30,LOW(10)
	STD  Y+18,R30
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4E
	BREQ _0x2020073
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x19
	LDI  R17,LOW(10)
	RJMP _0x2020074
_0x2020073:
	__GETD1N 0x2710
	CALL SUBOPT_0x19
	LDI  R17,LOW(5)
	RJMP _0x2020074
_0x2020072:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x2020076
	CALL SUBOPT_0x3F
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x2020077
_0x2020076:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x20200B5
_0x2020077:
	LDI  R30,LOW(16)
	STD  Y+18,R30
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4E
	BREQ _0x2020079
	__GETD1N 0x10000000
	CALL SUBOPT_0x19
	LDI  R17,LOW(8)
	RJMP _0x2020074
_0x2020079:
	__GETD1N 0x1000
	CALL SUBOPT_0x19
	LDI  R17,LOW(4)
_0x2020074:
	CPI  R20,0
	BREQ _0x202007A
	CALL SUBOPT_0x3F
	LDI  R30,LOW(65407)
	LDI  R31,HIGH(65407)
	AND  R30,R26
	MOV  R16,R30
	RJMP _0x202007B
_0x202007A:
	LDI  R20,LOW(1)
_0x202007B:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4E
	BREQ _0x202007C
	CALL SUBOPT_0x48
	CALL SUBOPT_0x46
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020102
_0x202007C:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4F
	BREQ _0x202007E
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4D
	CALL __CWD1
	RJMP _0x2020102
_0x202007E:
	CALL SUBOPT_0x48
	CALL SUBOPT_0x4D
	CLR  R22
	CLR  R23
_0x2020102:
	__PUTD1S 6
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4F
	BREQ _0x2020080
	LDD  R26,Y+9
	TST  R26
	BRPL _0x2020081
	CALL SUBOPT_0x49
	CALL __ANEGD1
	CALL SUBOPT_0x47
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x2020081:
	LDD  R30,Y+19
	CPI  R30,0
	BREQ _0x2020082
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020083
_0x2020082:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x50
_0x2020083:
_0x2020080:
	MOV  R19,R20
_0x202006C:
	CALL SUBOPT_0x3B
	ANDI R30,LOW(0x1)
	BRNE _0x2020084
_0x2020085:
	CP   R17,R21
	BRSH _0x2020088
	CP   R19,R21
	BRLO _0x2020089
_0x2020088:
	RJMP _0x2020087
_0x2020089:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4A
	BREQ _0x202008A
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4F
	BREQ _0x202008B
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x50
	LDD  R18,Y+19
	SUBI R17,LOW(1)
	RJMP _0x202008C
_0x202008B:
	LDI  R18,LOW(48)
_0x202008C:
	RJMP _0x202008D
_0x202008A:
	LDI  R18,LOW(32)
_0x202008D:
	CALL SUBOPT_0x3E
	SUBI R21,LOW(1)
	RJMP _0x2020085
_0x2020087:
_0x2020084:
_0x202008E:
	CP   R17,R20
	BRSH _0x2020090
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x51
	CALL SUBOPT_0x4F
	BREQ _0x2020091
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x50
	CALL SUBOPT_0x52
	BREQ _0x2020092
	SUBI R21,LOW(1)
_0x2020092:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020091:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x45
	CPI  R21,0
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R20,LOW(1)
	RJMP _0x202008E
_0x2020090:
	MOV  R19,R17
	LDD  R30,Y+18
	CPI  R30,0
	BRNE _0x2020094
_0x2020095:
	CPI  R19,0
	BREQ _0x2020097
	CALL SUBOPT_0x3F
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x2020098
	CALL SUBOPT_0x4B
	LPM  R30,Z
	RJMP _0x2020103
_0x2020098:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x2020103:
	ST   -Y,R30
	CALL SUBOPT_0x45
	CPI  R21,0
	BREQ _0x202009A
	SUBI R21,LOW(1)
_0x202009A:
	SUBI R19,LOW(1)
	RJMP _0x2020095
_0x2020097:
	RJMP _0x202009B
_0x2020094:
_0x202009D:
	CALL SUBOPT_0x53
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x202009F
	CALL SUBOPT_0x3F
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x20200A0
	CALL SUBOPT_0x42
	ADIW R30,55
	RJMP _0x2020104
_0x20200A0:
	CALL SUBOPT_0x42
	SUBI R30,LOW(-87)
	SBCI R31,HIGH(-87)
_0x2020104:
	MOV  R18,R30
	RJMP _0x20200A2
_0x202009F:
	CALL SUBOPT_0x42
	ADIW R30,48
	MOV  R18,R30
_0x20200A2:
	CALL SUBOPT_0x3F
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x20200A4
	CPI  R18,49
	BRSH _0x20200A6
	CALL SUBOPT_0x34
	__CPD2N 0x1
	BRNE _0x20200A5
_0x20200A6:
	RJMP _0x20200A8
_0x20200A5:
	CP   R20,R19
	BRSH _0x2020105
	CP   R21,R19
	BRLO _0x20200AB
	CALL SUBOPT_0x3B
	ANDI R30,LOW(0x1)
	BREQ _0x20200AC
_0x20200AB:
	RJMP _0x20200AA
_0x20200AC:
	LDI  R18,LOW(32)
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x4A
	BREQ _0x20200AD
_0x2020105:
	LDI  R18,LOW(48)
_0x20200A8:
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x51
	CALL SUBOPT_0x4F
	BREQ _0x20200AE
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x50
	CALL SUBOPT_0x52
	BREQ _0x20200AF
	SUBI R21,LOW(1)
_0x20200AF:
_0x20200AE:
_0x20200AD:
_0x20200A4:
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AA:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x53
	CALL __MODD21U
	CALL SUBOPT_0x47
	LDD  R30,Y+18
	LDI  R31,0
	CALL SUBOPT_0x34
	CALL __CWD1
	CALL __DIVD21U
	CALL SUBOPT_0x19
	CALL SUBOPT_0x32
	CALL __CPD10
	BREQ _0x202009E
	RJMP _0x202009D
_0x202009E:
_0x202009B:
	CALL SUBOPT_0x3B
	ANDI R30,LOW(0x1)
	BREQ _0x20200B1
_0x20200B2:
	CPI  R21,0
	BREQ _0x20200B4
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x45
	RJMP _0x20200B2
_0x20200B4:
_0x20200B1:
_0x20200B5:
_0x2020053:
_0x2020101:
	LDI  R17,LOW(0)
_0x2020034:
	RJMP _0x202002F
_0x2020031:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,29
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
_ftrunc:
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
	CALL SUBOPT_0x22
	CALL _ftrunc
	CALL SUBOPT_0x1E
    brne __floor1
__floor0:
	CALL SUBOPT_0x1F
	RJMP _0x20C0005
__floor1:
    brtc __floor0
	CALL SUBOPT_0x54
	RJMP _0x20C0005
_sin:
	CALL SUBOPT_0x55
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	CALL SUBOPT_0x39
	CALL SUBOPT_0x58
	CALL SUBOPT_0x23
	CALL SUBOPT_0x56
	CALL SUBOPT_0x59
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0x59
	CALL SUBOPT_0x23
	CALL SUBOPT_0x56
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0x58
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0x59
	CALL __SUBF12
	CALL SUBOPT_0x56
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0x5A
_0x2040019:
	CALL SUBOPT_0x5B
	__PUTD1S 1
	CALL SUBOPT_0x5C
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x23
	CALL SUBOPT_0x5D
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x58
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5C
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x5D
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20C0004
_cos:
	CALL SUBOPT_0x2C
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0005
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x2B
	CALL __MULF12
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x2B
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1F
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x5F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x2C
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x22
	RCALL _xatan
	RJMP _0x20C0005
_0x2040020:
	CALL SUBOPT_0x2C
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x60
	CALL SUBOPT_0x24
	RCALL _xatan
	CALL SUBOPT_0x61
	RJMP _0x20C0005
_0x2040021:
	CALL SUBOPT_0x54
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x60
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x24
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0005:
	ADIW R28,4
	RET
_asin:
	CALL SUBOPT_0x55
	__GETD1N 0xBF800000
	CALL __CMPF12
	BRLO _0x2040023
	CALL SUBOPT_0x58
	__GETD1N 0x3F800000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2040023
	RJMP _0x2040022
_0x2040023:
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0004
_0x2040022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2040025
	CALL SUBOPT_0x5A
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0x5B
	__GETD2N 0x3F800000
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1D
	__PUTD1S 1
	CALL SUBOPT_0x58
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0x57
	__GETD2S 1
	CALL SUBOPT_0x24
	RCALL _yatan
	CALL SUBOPT_0x61
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x58
	CALL SUBOPT_0x24
	RCALL _yatan
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0x5C
	CALL __ANEGF1
	RJMP _0x20C0004
_0x2040028:
	CALL SUBOPT_0x5C
_0x20C0004:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x5E
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0003
_0x204002E:
	CALL SUBOPT_0x1B
	CALL __CPD02
	BRGE _0x204002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0003
_0x204002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0003
_0x204002D:
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x1B
	CALL __DIVF21
	CALL SUBOPT_0x2A
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0x22
	RCALL _yatan
	RJMP _0x20C0003
_0x2040031:
	CALL SUBOPT_0x62
	CALL __ANEGF1
	RJMP _0x20C0003
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0x62
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x23
	RJMP _0x20C0003
_0x2040032:
	CALL SUBOPT_0x22
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20C0003:
	ADIW R28,12
	RET

	.CSEG

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
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
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x20A000D
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20A0000,0
	RCALL SUBOPT_0x30
	RJMP _0x20C0002
_0x20A000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x20A000C
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x20A0000,1
	RCALL SUBOPT_0x30
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x63
	RCALL SUBOPT_0x64
	LDI  R30,LOW(45)
	ST   X,R30
_0x20A000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x20A0010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x20A0010:
	LDD  R17,Y+8
_0x20A0011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A0013
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x25
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x65
	CALL __ADDF12
	RCALL SUBOPT_0x63
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x25
_0x20A0014:
	RCALL SUBOPT_0x65
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x25
	SUBI R17,-LOW(1)
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0017
	RCALL SUBOPT_0x64
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0018
_0x20A0017:
_0x20A0019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001B
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x65
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x3B
	ADIW R30,48
	ST   X,R30
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x26
	CALL __CWD1
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x63
	RJMP _0x20A0019
_0x20A001B:
_0x20A0018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x64
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A001F
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x63
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x3B
	ADIW R30,48
	ST   X,R30
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x66
	CALL __CWD1
	CALL __CDF1
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x63
	RJMP _0x20A001D
_0x20A001F:
_0x20C0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

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
_viz_period:
	.BYTE 0x2
_y_gnd:
	.BYTE 0x2
_x_gnd:
	.BYTE 0x2
_gnd_amplituda:
	.BYTE 0x4
_gnd_faza:
	.BYTE 0x4
_rock_amplituda:
	.BYTE 0x4
_rock_faza:
	.BYTE 0x4
_now_amplituda:
	.BYTE 0x4
_now_faza:
	.BYTE 0x4
_period:
	.BYTE 0x2
_vol:
	.BYTE 0x1
_bar:
	.BYTE 0x1
_menu:
	.BYTE 0x1
_tik_old:
	.BYTE 0x1
_tik_new:
	.BYTE 0x1
_gnd_rage:
	.BYTE 0x1
_viz_amplituda:
	.BYTE 0x1
_viz_faza:
	.BYTE 0x1
_batt_celoe:
	.BYTE 0x2
_batt_drob:
	.BYTE 0x2
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x4:
	SBI  0x12,6
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDS  R30,_vol
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDS  R30,_bar
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x8:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	SBI  0x12,6
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	LDS  R30,_gnd_amplituda
	LDS  R31,_gnd_amplituda+1
	LDS  R22,_gnd_amplituda+2
	LDS  R23,_gnd_amplituda+3
	CALL __PUTPARD1
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDS  R30,_zero_amplituda
	LDS  R31,_zero_amplituda+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDS  R30,_zero_faza
	LDS  R31,_zero_faza+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:173 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDS  R30,_period
	LDS  R31,_period+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x19:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	__GETD1S 12
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1C:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __PUTPARD1
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __MULF12
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x1F
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x23:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x29:
	ST   -Y,R13
	ST   -Y,R12
	ST   -Y,R11
	ST   -Y,R10
	RCALL SUBOPT_0x11
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x12
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL SUBOPT_0x1E
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x2B:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2C:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x2B
	__GETD1N 0x41200000
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x33:
	__GETD1S 4
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RCALL SUBOPT_0x19
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3B:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	MOVW R22,R30
	MOV  R26,R19
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x3E:
	ST   -Y,R18
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x3F:
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x40:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x41:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x43:
	__GETW1SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x44:
	SBIW R30,4
	__PUTW1SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x45:
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x46:
	__GETW2SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x48:
	RCALL SUBOPT_0x43
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4C:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x46
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	OR   R30,R26
	MOV  R16,R30
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x52:
	LDD  R30,Y+19
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(87))
	SBCI R31,HIGH(-(87))
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G101
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x32
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x2C
	__GETD1N 0x3F800000
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x55:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x56:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x57:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x58:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x59:
	RCALL SUBOPT_0x58
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	RCALL SUBOPT_0x57
	CALL __ANEGF1
	RJMP SUBOPT_0x56

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x58
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5C:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	RCALL SUBOPT_0x1F
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	__GETD2N 0x3FC90FDB
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	RCALL SUBOPT_0x1F
	CALL __ANEGF1
	CALL __PUTPARD1
	JMP  _yatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x63:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x64:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x27
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	__GETD2S 9
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

_sqrt:
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
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

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
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

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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
