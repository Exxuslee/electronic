
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16,384000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;global const stored in FLASH  : Yes
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
	.DEF _st_zero_Y=R4
	.DEF _st_zero_X=R6
	.DEF _din_zero_Y=R8
	.DEF _din_zero_X=R10
	.DEF _bar=R13
	.DEF _rezym=R12

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
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x25,0x32,0x2E,0x31,0x66,0x56,0x20,0x42
	.DB  0x3D,0x25,0x64,0x20,0x0,0x53,0x74,0x5F
	.DB  0x56,0x65,0x63,0x0,0x53,0x74,0x5F,0x52
	.DB  0x61,0x73,0x0,0x20,0x44,0x69,0x6E,0x61
	.DB  0x6D,0x0,0x53,0x74,0x6F,0x70,0x54,0x58
	.DB  0x0,0x5B,0x25,0x32,0x78,0x3B,0x25,0x32
	.DB  0x78,0x5D,0x3D,0x5A,0x0,0x2B,0x52,0x0
	.DB  0x20,0x20,0x0,0x2B,0x47,0x0,0x2D,0x46
	.DB  0x65,0x0,0x2B,0x41,0x6C,0x0,0x20,0x5F
	.DB  0x53,0x74,0x61,0x74,0x69,0x63,0x5F,0x56
	.DB  0x65,0x63,0x6B,0x74,0x5F,0x20,0x0,0x20
	.DB  0x5F,0x53,0x74,0x61,0x74,0x69,0x63,0x5F
	.DB  0x52,0x61,0x73,0x74,0x72,0x5F,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x5F,0x44,0x69,0x6E
	.DB  0x61,0x6D,0x69,0x63,0x5F,0x20,0x20,0x20
	.DB  0x0,0x42,0x61,0x72,0x72,0x69,0x65,0x72
	.DB  0x20,0x25,0x64,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x3E,0x3E,0x20,0x52,0x6F
	.DB  0x63,0x6B,0x20,0x28,0x41,0x3A,0x66,0x29
	.DB  0x20,0x3C,0x3C,0x0,0x20,0x20,0x28,0x25
	.DB  0x30,0x33,0x2E,0x30,0x66,0x3A,0x25,0x2B
	.DB  0x2E,0x32,0x66,0x29,0x20,0x20,0x20,0x0
	.DB  0x3E,0x3E,0x3E,0x3E,0x20,0x47,0x2E,0x45
	.DB  0x2E,0x42,0x2E,0x20,0x3C,0x3C,0x3C,0x3C
	.DB  0x0,0x20,0x20,0x25,0x2B,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x3E,0x20,0x47,0x72,0x6F,0x75
	.DB  0x6E,0x64,0x20,0x5B,0x58,0x3B,0x59,0x5D
	.DB  0x20,0x3C,0x0,0x20,0x20,0x5B,0x25,0x32
	.DB  0x78,0x3B,0x25,0x32,0x78,0x5D,0x20,0x20
	.DB  0x20,0x0,0x53,0x3E,0x20,0x5A,0x65,0x72
	.DB  0x6F,0x20,0x5B,0x58,0x3B,0x59,0x5D,0x20
	.DB  0x3C,0x44,0x0,0x5B,0x25,0x32,0x78,0x3B
	.DB  0x25,0x32,0x78,0x5D,0x20,0x20,0x5B,0x25
	.DB  0x32,0x78,0x3B,0x25,0x32,0x78,0x5D,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x53,0x74,0x6F,0x70,0x5F
	.DB  0x5F,0x54,0x78,0x20,0x20,0x20,0x20,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x6F,0x5F
	.DB  0x4F,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x23,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x23,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x23,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x23,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x23,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x23,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x23,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x23,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x23,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x23,0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x23,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x23,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x23,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x23,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0x3E,0x5F,0x3C,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0x3E,0x0,0x46,0x49,0x4E,0x44,0x45
	.DB  0x52,0x20,0x5E,0x5F,0x5E,0x20,0x45,0x78
	.DB  0x78,0x75,0x73,0x0,0x76,0x31,0x2E,0x37
	.DB  0x2E,0x30,0x20,0x20,0x20,0x6D,0x64,0x34
	.DB  0x75,0x2E,0x72,0x75,0x0,0x53,0x61,0x76
	.DB  0x65,0x0,0x4F,0x2E,0x6B,0x2E,0x0,0x46
	.DB  0x72,0x65,0x71,0x2D,0x54,0x58,0x20,0x25
	.DB  0x33,0x78,0x20,0x5B,0x25,0x32,0x78,0x5D
	.DB  0x0,0x46,0x61,0x7A,0x61,0x2D,0x58,0x20
	.DB  0x20,0x25,0x33,0x78,0x20,0x5B,0x25,0x32
	.DB  0x78,0x5D,0x0
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
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : MD_IB_Exxus
;Version : 1.7
;Date    : 14.06.2010
;Author  : Exxus
;Company : Haos
;Chip type           : ATmega32
;Program type        : Application
;Clock frequency     : 16,384000 MHz
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
; 0000 0014 #endasm
;#include <lcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;
;#define ADC_VREF_TYPE 0x20
;#define Ftx OCR1A
;#define Frx OCR1B
;
;// Declare your global variables here
;char string_LCD_1[20], string_LCD_2[20];
;unsigned int st_zero_Y, st_zero_X, din_zero_Y, din_zero_X;
;float  gnd_faza, rock_faza;
;float ampl, faza, bar_rad;
;unsigned char bar, rezym;
;unsigned char st_X, st_Y, din_X, din_Y, viz_ampl, viz_faza, viz_din, din_max, din_min, gnd_X, gnd_Y, rock_X, rock_Y;
;unsigned char adc_data;
;float batt;
;bit kn1, kn2, kn3, kn4, kn5, kn6, mod_gnd, mod_rock, mod_all_met, zemlq, kamen, menu;
;unsigned char rastr_st[0x20][0x20], gnd_pos_X, gnd_pos_Y, rock_pos_X, rock_pos_Y, gnd_sekt_X, gnd_sekt_Y, rock_sekt_X, rock_sekt_Y;
;signed char geb;
;eeprom unsigned int Ftx_ee, Frx_ee;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 002E {

	.CSEG
_adc_isr:
	ST   -Y,R30
; 0000 002F // Read the 8 most significant bits
; 0000 0030 // of the AD conversion result
; 0000 0031 adc_data=ADCH;
	IN   R30,0x5
	STS  _adc_data,R30
; 0000 0032 }
	LD   R30,Y+
	RETI
;
;// Read the 8 most significant bits
;// of the AD conversion result
;// with noise canceling
;unsigned char read_adc(unsigned char adc_input)
; 0000 0038 {
_read_adc:
; 0000 0039 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 003A // Delay needed for the stabilization of the ADC input voltage
; 0000 003B delay_us(10);
	__DELAY_USB 55
; 0000 003C #asm
; 0000 003D     in   r30,mcucr
    in   r30,mcucr
; 0000 003E     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0000 003F     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0040     out  mcucr,r30
    out  mcucr,r30
; 0000 0041     sleep
    sleep
; 0000 0042     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0000 0043     out  mcucr,r30
    out  mcucr,r30
; 0000 0044 #endasm
; 0000 0045 return adc_data;
	LDS  R30,_adc_data
	ADIW R28,1
	RET
; 0000 0046 }
;
;void batt_zarqd(void)
; 0000 0049     {
_batt_zarqd:
; 0000 004A     #asm("wdr")
	wdr
; 0000 004B     batt = read_adc(4)/14.0;
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x0
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41600000
	CALL __DIVF21
	STS  _batt,R30
	STS  _batt+1,R31
	STS  _batt+2,R22
	STS  _batt+3,R23
; 0000 004C     return;
	RET
; 0000 004D     }
;
;void kn_klava(void)
; 0000 0050     {
_kn_klava:
; 0000 0051     #asm("wdr")
	wdr
; 0000 0052     kn1=0;
	CLT
	BLD  R2,0
; 0000 0053     kn2=0;
	BLD  R2,1
; 0000 0054     kn3=0;
	BLD  R2,2
; 0000 0055     kn4=0;
	BLD  R2,3
; 0000 0056     kn5=0;
	BLD  R2,4
; 0000 0057     kn6=0;
	BLD  R2,5
; 0000 0058     DDRA.5=1;
	SBI  0x1A,5
; 0000 0059     PORTA.5=0;
	CBI  0x1B,5
; 0000 005A     delay_ms (2);
	CALL SUBOPT_0x1
; 0000 005B     if (PINA.6==0 && PINA.7==0) kn1=1;
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x8
	CALL SUBOPT_0x2
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
	SET
	BLD  R2,0
; 0000 005C     if (PINA.6==1 && PINA.7==0) kn2=1;
_0x7:
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xB
	CALL SUBOPT_0x2
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
	SET
	BLD  R2,1
; 0000 005D     DDRA.5=0;
_0xA:
	CBI  0x1A,5
; 0000 005E     DDRA.6=1;
	SBI  0x1A,6
; 0000 005F     PORTA.5=1;
	SBI  0x1B,5
; 0000 0060     PORTA.6=0;
	CBI  0x1B,6
; 0000 0061     delay_ms (2);
	CALL SUBOPT_0x1
; 0000 0062     if (PINA.5==1 && PINA.7==0) kn3=1;
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x16
	CALL SUBOPT_0x2
	BREQ _0x17
_0x16:
	RJMP _0x15
_0x17:
	SET
	BLD  R2,2
; 0000 0063     if (PINA.5==0 && PINA.7==0) kn4=1;
_0x15:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x19
	CALL SUBOPT_0x2
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	SET
	BLD  R2,3
; 0000 0064     DDRA.6=0;
_0x18:
	CBI  0x1A,6
; 0000 0065     DDRA.7=1;
	SBI  0x1A,7
; 0000 0066     PORTA.6=1;
	SBI  0x1B,6
; 0000 0067     PORTA.7=0;
	CBI  0x1B,7
; 0000 0068     delay_ms (2);
	CALL SUBOPT_0x1
; 0000 0069     if (PINA.5==1 && PINA.6==0) kn5=1;
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x24
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
	SET
	BLD  R2,4
; 0000 006A     if (PINA.5==0 && PINA.6==1) kn6=1;
_0x23:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x27
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,5
; 0000 006B     DDRA.7=0;
_0x26:
	CBI  0x1A,7
; 0000 006C     PORTA.7=1;
	SBI  0x1B,7
; 0000 006D     return;
	RET
; 0000 006E     }
;
;void lcd_disp(void)
; 0000 0071     {
_lcd_disp:
; 0000 0072     #asm("wdr")
	wdr
; 0000 0073     if (menu==1)
	CALL SUBOPT_0x3
	BREQ PC+3
	JMP _0x2D
; 0000 0074         {
; 0000 0075         lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 0076         sprintf (string_LCD_1, "%2.1fV B=%d ", batt, bar);
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_batt
	LDS  R31,_batt+1
	LDS  R22,_batt+2
	LDS  R23,_batt+3
	CALL __PUTPARD1
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0000 0077         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL _lcd_puts
; 0000 0078 
; 0000 0079         lcd_gotoxy (10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x8
; 0000 007A              if (rezym == 0)    sprintf (string_LCD_1, "St_Vec");
	TST  R12
	BRNE _0x2E
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,13
	RJMP _0x26D
; 0000 007B         else if (rezym == 1)    sprintf (string_LCD_1, "St_Ras");
_0x2E:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x30
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,20
	RJMP _0x26D
; 0000 007C         else if (rezym == 2)    sprintf (string_LCD_1, " Dinam");
_0x30:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x32
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,27
	RJMP _0x26D
; 0000 007D         else                    sprintf (string_LCD_1, "StopTX");
_0x32:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,34
_0x26D:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 007E         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 007F 
; 0000 0080         lcd_gotoxy (0,1);
; 0000 0081         sprintf (string_LCD_2, "[%2x;%2x]=Z", st_X, st_Y);
	__POINTW1FN _0x0,41
	CALL SUBOPT_0xB
; 0000 0082         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 0083 
; 0000 0084         lcd_gotoxy (9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0xD
; 0000 0085         if (mod_rock == 1)   sprintf (string_LCD_2, "+R");
	CALL SUBOPT_0xE
	BRNE _0x34
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,53
	RJMP _0x26E
; 0000 0086         else                    sprintf (string_LCD_2, "  ");
_0x34:
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,56
_0x26E:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0087         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 0088 
; 0000 0089         lcd_gotoxy (11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0xD
; 0000 008A         if (mod_gnd == 1)   sprintf (string_LCD_2, "+G");
	CALL SUBOPT_0xF
	BRNE _0x36
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,59
	RJMP _0x26F
; 0000 008B         else                    sprintf (string_LCD_2, "  ");
_0x36:
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,56
_0x26F:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 008C         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 008D 
; 0000 008E         lcd_gotoxy (13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0xD
; 0000 008F         if (mod_all_met == 1)   sprintf (string_LCD_2, "-Fe");
	LDI  R26,0
	SBRC R3,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x38
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,62
	RJMP _0x270
; 0000 0090         else                    sprintf (string_LCD_2, "+Al");
_0x38:
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,66
_0x270:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0091         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 0092 
; 0000 0093         return;
; 0000 0094         };
_0x2D:
; 0000 0095 
; 0000 0096     if (kn2==1)
	CALL SUBOPT_0x10
	BRNE _0x3A
; 0000 0097         {
; 0000 0098         lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 0099              if (rezym == 0)         sprintf (string_LCD_1, " _Static_Veckt_ ");
	TST  R12
	BRNE _0x3B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,70
	RJMP _0x271
; 0000 009A         else if (rezym == 1)         sprintf (string_LCD_1, " _Static_Rastr_ ");
_0x3B:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x3D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,87
	RJMP _0x271
; 0000 009B         else if (rezym == 2)         sprintf (string_LCD_1, "    _Dinamic_   ");
_0x3D:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x3F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,104
_0x271:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 009C         lcd_puts (string_LCD_1);
_0x3F:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	RJMP _0x20C0008
; 0000 009D         return;
; 0000 009E         };
_0x3A:
; 0000 009F 
; 0000 00A0     if (kn3==1)
	CALL SUBOPT_0x11
	BRNE _0x40
; 0000 00A1         {
; 0000 00A2         lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xD
; 0000 00A3         sprintf (string_LCD_2, "Barrier %d       ", bar);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,121
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL SUBOPT_0x12
; 0000 00A4         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00A5         return;
; 0000 00A6         };
_0x40:
; 0000 00A7 
; 0000 00A8     if (kn4==1)
	CALL SUBOPT_0x13
	BRNE _0x41
; 0000 00A9         {
; 0000 00AA         lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 00AB         if (rezym <2)
	LDI  R30,LOW(2)
	CP   R12,R30
	BRSH _0x42
; 0000 00AC                 {
; 0000 00AD                 sprintf (string_LCD_1, ">> Rock (A:f) <<");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x14
; 0000 00AE                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00AF                 lcd_gotoxy (0,1);
; 0000 00B0                 sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_ampl
	LDS  R31,_ampl+1
	LDS  R22,_ampl+2
	LDS  R23,_ampl+3
	CALL __PUTPARD1
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	CALL SUBOPT_0x15
; 0000 00B1                 }
; 0000 00B2         else
	RJMP _0x43
_0x42:
; 0000 00B3                 {
; 0000 00B4                 sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,176
	CALL SUBOPT_0x14
; 0000 00B5                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00B6                 lcd_gotoxy (0,1);
; 0000 00B7                 sprintf (string_LCD_2, "  %+d           ", geb);
	CALL SUBOPT_0x16
; 0000 00B8                 };
_0x43:
; 0000 00B9         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00BA         return;
; 0000 00BB         };
_0x41:
; 0000 00BC 
; 0000 00BD     if (kn5==1)
	CALL SUBOPT_0x17
	BRNE _0x44
; 0000 00BE         {
; 0000 00BF         lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 00C0         if (rezym <2)
	LDI  R30,LOW(2)
	CP   R12,R30
	BRSH _0x45
; 0000 00C1                 {
; 0000 00C2                 sprintf (string_LCD_1, "> Ground [X;Y] <");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x14
; 0000 00C3                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00C4                 lcd_gotoxy (0,1);
; 0000 00C5                 sprintf (string_LCD_2, "  [%2x;%2x]   ", st_X, st_Y);
	__POINTW1FN _0x0,227
	CALL SUBOPT_0xB
; 0000 00C6                 }
; 0000 00C7         else
	RJMP _0x46
_0x45:
; 0000 00C8                 {
; 0000 00C9                 sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,176
	CALL SUBOPT_0x14
; 0000 00CA                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00CB                 lcd_gotoxy (0,1);
; 0000 00CC                 sprintf (string_LCD_2, "  %+d           ", geb);
	CALL SUBOPT_0x16
; 0000 00CD                 };
_0x46:
; 0000 00CE         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00CF         return;
; 0000 00D0         };
_0x44:
; 0000 00D1 
; 0000 00D2     if (kn6==1)
	CALL SUBOPT_0x18
	BRNE _0x47
; 0000 00D3         {
; 0000 00D4         lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 00D5         sprintf (string_LCD_1, "S> Zero [X;Y] <D");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,242
	CALL SUBOPT_0x14
; 0000 00D6         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00D7         lcd_gotoxy (0,1);
; 0000 00D8         sprintf (string_LCD_2, "[%2x;%2x]  [%2x;%2x]", st_zero_X, st_zero_Y, din_zero_X, din_zero_Y);
	__POINTW1FN _0x0,259
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CALL SUBOPT_0x19
	MOVW R30,R4
	CALL SUBOPT_0x19
	MOVW R30,R10
	CALL SUBOPT_0x19
	MOVW R30,R8
	CALL SUBOPT_0x19
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00D9         lcd_puts (string_LCD_2);
_0x20C0007:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
_0x20C0008:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00DA         return;
	RET
; 0000 00DB         };
_0x47:
; 0000 00DC 
; 0000 00DD     lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 00DE     if (rezym < 2)
	LDI  R30,LOW(2)
	CP   R12,R30
	BRLO PC+3
	JMP _0x48
; 0000 00DF         {
; 0000 00E0         if      (viz_ampl==0)    sprintf (string_LCD_1, "                ");
	LDS  R30,_viz_ampl
	CPI  R30,0
	BRNE _0x49
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,280
	RJMP _0x272
; 0000 00E1         else if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");
_0x49:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1)
	BRNE _0x4B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,297
	RJMP _0x272
; 0000 00E2         else if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
_0x4B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x2)
	BRNE _0x4D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,314
	RJMP _0x272
; 0000 00E3         else if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x4D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x3)
	BRNE _0x4F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,331
	RJMP _0x272
; 0000 00E4         else if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x4F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x4)
	BRNE _0x51
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,348
	RJMP _0x272
; 0000 00E5         else if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x51:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x5)
	BRNE _0x53
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,365
	RJMP _0x272
; 0000 00E6         else if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x53:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x6)
	BRNE _0x55
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,382
	RJMP _0x272
; 0000 00E7         else if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x55:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x7)
	BRNE _0x57
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,399
	RJMP _0x272
; 0000 00E8         else if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x57:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x8)
	BRNE _0x59
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,416
	RJMP _0x272
; 0000 00E9         else if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x59:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x9)
	BRNE _0x5B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,433
	RJMP _0x272
; 0000 00EA         else if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x5B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xA)
	BRNE _0x5D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,450
	RJMP _0x272
; 0000 00EB         else if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x5D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xB)
	BRNE _0x5F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,467
	RJMP _0x272
; 0000 00EC         else if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x5F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xC)
	BRNE _0x61
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,484
	RJMP _0x272
; 0000 00ED         else if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x61:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xD)
	BRNE _0x63
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,501
	RJMP _0x272
; 0000 00EE         else if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x63:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xE)
	BRNE _0x65
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,518
	RJMP _0x272
; 0000 00EF         else if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x65:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xF)
	BRNE _0x67
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,535
	RJMP _0x272
; 0000 00F0         else if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x67:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x10)
	BRNE _0x69
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,552
	RJMP _0x272
; 0000 00F1         else if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x69:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x11)
	BRNE _0x6B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,569
	RJMP _0x272
; 0000 00F2         else if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x6B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x12)
	BRNE _0x6D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,586
	RJMP _0x272
; 0000 00F3         else if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x6D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x13)
	BRNE _0x6F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,603
	RJMP _0x272
; 0000 00F4         else if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x6F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x14)
	BRNE _0x71
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,620
	RJMP _0x272
; 0000 00F5         else if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x71:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x15)
	BRNE _0x73
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,637
	RJMP _0x272
; 0000 00F6         else if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x73:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x16)
	BRNE _0x75
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,654
	RJMP _0x272
; 0000 00F7         else if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x75:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x17)
	BRNE _0x77
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,671
	RJMP _0x272
; 0000 00F8         else if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x77:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x18)
	BRNE _0x79
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,688
	RJMP _0x272
; 0000 00F9         else if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x79:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x19)
	BRNE _0x7B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,705
	RJMP _0x272
; 0000 00FA         else if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x7B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1A)
	BRNE _0x7D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,722
	RJMP _0x272
; 0000 00FB         else if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x7D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1B)
	BRNE _0x7F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,739
	RJMP _0x272
; 0000 00FC         else if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x7F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1C)
	BRNE _0x81
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,756
	RJMP _0x272
; 0000 00FD         else if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x81:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1D)
	BRNE _0x83
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,773
	RJMP _0x272
; 0000 00FE         else if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x83:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1E)
	BRNE _0x85
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,790
	RJMP _0x272
; 0000 00FF         else if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x85:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1F)
	BRNE _0x87
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,807
	RJMP _0x272
; 0000 0100         else                     sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x87:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,824
_0x272:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0101         }
; 0000 0102 
; 0000 0103     else if (rezym == 2)
	RJMP _0x89
_0x48:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x8A
; 0000 0104         {
; 0000 0105              if (viz_ampl==1)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ ");
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1)
	BRNE _0x8B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,841
	RJMP _0x273
; 0000 0106         else if (viz_ampl==2)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ  ");
_0x8B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x2)
	BRNE _0x8D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,858
	RJMP _0x273
; 0000 0107         else if (viz_ampl==3)    sprintf (string_LCD_1, "        ÿÿÿÿÿ   ");
_0x8D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x3)
	BRNE _0x8F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,875
	RJMP _0x273
; 0000 0108         else if (viz_ampl==4)    sprintf (string_LCD_1, "        ÿÿÿÿ    ");
_0x8F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x4)
	BRNE _0x91
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,892
	RJMP _0x273
; 0000 0109         else if (viz_ampl==5)    sprintf (string_LCD_1, "        ÿÿÿ     ");
_0x91:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x5)
	BRNE _0x93
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,909
	RJMP _0x273
; 0000 010A         else if (viz_ampl==6)    sprintf (string_LCD_1, "        ÿÿ      ");
_0x93:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x6)
	BRNE _0x95
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,926
	RJMP _0x273
; 0000 010B         else if (viz_ampl==7)    sprintf (string_LCD_1, "        ÿ       ");
_0x95:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x7)
	BRNE _0x97
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,943
	RJMP _0x273
; 0000 010C         else if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
_0x97:
	LDS  R30,_viz_ampl
	CPI  R30,0
	BRNE _0x99
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,280
	RJMP _0x273
; 0000 010D         else if (viz_ampl==8)    sprintf (string_LCD_1, "       ÿ        ");
_0x99:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x8)
	BRNE _0x9B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,960
	RJMP _0x273
; 0000 010E         else if (viz_ampl==9)    sprintf (string_LCD_1, "      ÿÿ        ");
_0x9B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x9)
	BRNE _0x9D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,977
	RJMP _0x273
; 0000 010F         else if (viz_ampl==10)   sprintf (string_LCD_1, "     ÿÿÿ        ");
_0x9D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xA)
	BRNE _0x9F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,994
	RJMP _0x273
; 0000 0110         else if (viz_ampl==11)   sprintf (string_LCD_1, "    ÿÿÿÿ        ");
_0x9F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xB)
	BRNE _0xA1
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1011
	RJMP _0x273
; 0000 0111         else if (viz_ampl==12)   sprintf (string_LCD_1, "   ÿÿÿÿÿ        ");
_0xA1:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xC)
	BRNE _0xA3
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1028
	RJMP _0x273
; 0000 0112         else if (viz_ampl==13)   sprintf (string_LCD_1, "  ÿÿÿÿÿÿ        ");
_0xA3:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xD)
	BRNE _0xA5
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1045
	RJMP _0x273
; 0000 0113         else                     sprintf (string_LCD_1, " ÿÿÿÿÿÿÿ        ");
_0xA5:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1062
_0x273:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0114         }
; 0000 0115 
; 0000 0116     else                         sprintf (string_LCD_1, "    Stop__Tx    ");
	RJMP _0xA7
_0x8A:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1079
	CALL SUBOPT_0x14
; 0000 0117 
; 0000 0118     lcd_puts (string_LCD_1);
_0xA7:
_0x89:
	CALL SUBOPT_0x5
	CALL _lcd_puts
; 0000 0119 
; 0000 011A     lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xD
; 0000 011B          if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
	LDS  R30,_viz_faza
	CPI  R30,0
	BRNE _0xA8
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1096
	RJMP _0x274
; 0000 011C     else if (viz_faza==1)  sprintf (string_LCD_2, "Û------II----o_O");
_0xA8:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x1)
	BRNE _0xAA
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1113
	RJMP _0x274
; 0000 011D     else if (viz_faza==2)  sprintf (string_LCD_2, "Û------II-----#Ü");
_0xAA:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x2)
	BRNE _0xAC
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1130
	RJMP _0x274
; 0000 011E     else if (viz_faza==3)  sprintf (string_LCD_2, "Û------II----#-Ü");
_0xAC:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x3)
	BRNE _0xAE
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1147
	RJMP _0x274
; 0000 011F     else if (viz_faza==4)  sprintf (string_LCD_2, "Û------II---#--Ü");
_0xAE:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x4)
	BRNE _0xB0
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1164
	RJMP _0x274
; 0000 0120     else if (viz_faza==5)  sprintf (string_LCD_2, "Û------II--#---Ü");
_0xB0:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x5)
	BRNE _0xB2
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1181
	RJMP _0x274
; 0000 0121     else if (viz_faza==6)  sprintf (string_LCD_2, "Û------II-#----Ü");
_0xB2:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x6)
	BRNE _0xB4
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1198
	RJMP _0x274
; 0000 0122     else if (viz_faza==7)  sprintf (string_LCD_2, "Û------II#-----Ü");
_0xB4:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x7)
	BRNE _0xB6
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1215
	RJMP _0x274
; 0000 0123     else if (viz_faza==8)  sprintf (string_LCD_2, "Û------I#------Ü");
_0xB6:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x8)
	BRNE _0xB8
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1232
	RJMP _0x274
; 0000 0124     else if (viz_faza==9)  sprintf (string_LCD_2, "Û------#I------Ü");
_0xB8:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x9)
	BRNE _0xBA
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1249
	RJMP _0x274
; 0000 0125     else if (viz_faza==10) sprintf (string_LCD_2, "Û-----#II------Ü");
_0xBA:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xA)
	BRNE _0xBC
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1266
	RJMP _0x274
; 0000 0126     else if (viz_faza==11) sprintf (string_LCD_2, "Û----#-II------Ü");
_0xBC:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xB)
	BRNE _0xBE
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1283
	RJMP _0x274
; 0000 0127     else if (viz_faza==12) sprintf (string_LCD_2, "Û---#--II------Ü");
_0xBE:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xC)
	BRNE _0xC0
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1300
	RJMP _0x274
; 0000 0128     else if (viz_faza==13) sprintf (string_LCD_2, "Û--#---II------Ü");
_0xC0:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xD)
	BRNE _0xC2
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1317
	RJMP _0x274
; 0000 0129     else if (viz_faza==14) sprintf (string_LCD_2, "Û-#----II------Ü");
_0xC2:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xE)
	BRNE _0xC4
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1334
	RJMP _0x274
; 0000 012A     else if (viz_faza==15) sprintf (string_LCD_2, "Û#-----II------Ü");
_0xC4:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xF)
	BRNE _0xC6
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1351
	RJMP _0x274
; 0000 012B     else                   sprintf (string_LCD_2, ">_<----II------Ü");
_0xC6:
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1368
_0x274:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 012C 
; 0000 012D     lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 012E 
; 0000 012F     if (rezym == 2)
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0xC8
; 0000 0130         {
; 0000 0131         if (viz_din==0)     return;
	LDS  R30,_viz_din
	CPI  R30,0
	BRNE _0xC9
	RET
; 0000 0132 
; 0000 0133         sprintf (string_LCD_1, "<");
_0xC9:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,154
	CALL SUBOPT_0x14
; 0000 0134              if (viz_din==1)    lcd_gotoxy (7,0);
	LDS  R26,_viz_din
	CPI  R26,LOW(0x1)
	BRNE _0xCA
	LDI  R30,LOW(7)
	RJMP _0x275
; 0000 0135         else if (viz_din==2)    lcd_gotoxy (6,0);
_0xCA:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x2)
	BRNE _0xCC
	LDI  R30,LOW(6)
	RJMP _0x275
; 0000 0136         else if (viz_din==3)    lcd_gotoxy (5,0);
_0xCC:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x3)
	BRNE _0xCE
	LDI  R30,LOW(5)
	RJMP _0x275
; 0000 0137         else if (viz_din==4)    lcd_gotoxy (4,0);
_0xCE:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x4)
	BRNE _0xD0
	LDI  R30,LOW(4)
	RJMP _0x275
; 0000 0138         else if (viz_din==5)    lcd_gotoxy (3,0);
_0xD0:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x5)
	BRNE _0xD2
	LDI  R30,LOW(3)
	RJMP _0x275
; 0000 0139         else if (viz_din==6)    lcd_gotoxy (2,0);
_0xD2:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x6)
	BRNE _0xD4
	LDI  R30,LOW(2)
	RJMP _0x275
; 0000 013A         else if (viz_din==7)    lcd_gotoxy (1,0);
_0xD4:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x7)
	BRNE _0xD6
	LDI  R30,LOW(1)
	RJMP _0x275
; 0000 013B         else                    lcd_gotoxy (0,0);
_0xD6:
	LDI  R30,LOW(0)
_0x275:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 013C         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL _lcd_puts
; 0000 013D 
; 0000 013E         sprintf (string_LCD_2, ">");
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1385
	CALL SUBOPT_0x14
; 0000 013F              if (viz_din==1)    lcd_gotoxy (8,0);
	LDS  R26,_viz_din
	CPI  R26,LOW(0x1)
	BRNE _0xD8
	LDI  R30,LOW(8)
	RJMP _0x276
; 0000 0140         else if (viz_din==2)    lcd_gotoxy (9,0);
_0xD8:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x2)
	BRNE _0xDA
	LDI  R30,LOW(9)
	RJMP _0x276
; 0000 0141         else if (viz_din==3)    lcd_gotoxy (10,0);
_0xDA:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x3)
	BRNE _0xDC
	LDI  R30,LOW(10)
	RJMP _0x276
; 0000 0142         else if (viz_din==4)    lcd_gotoxy (11,0);
_0xDC:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x4)
	BRNE _0xDE
	LDI  R30,LOW(11)
	RJMP _0x276
; 0000 0143         else if (viz_din==5)    lcd_gotoxy (12,0);
_0xDE:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x5)
	BRNE _0xE0
	LDI  R30,LOW(12)
	RJMP _0x276
; 0000 0144         else if (viz_din==6)    lcd_gotoxy (13,0);
_0xE0:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x6)
	BRNE _0xE2
	LDI  R30,LOW(13)
	RJMP _0x276
; 0000 0145         else if (viz_din==7)    lcd_gotoxy (14,0);
_0xE2:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x7)
	BRNE _0xE4
	LDI  R30,LOW(14)
	RJMP _0x276
; 0000 0146         else                    lcd_gotoxy (15,0);
_0xE4:
	LDI  R30,LOW(15)
_0x276:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0147         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 0148         };
_0xC8:
; 0000 0149     return;
	RET
; 0000 014A     }
;
;void zvuk ()
; 0000 014D     {
_zvuk:
; 0000 014E     #asm("wdr")
	wdr
; 0000 014F     if ((mod_all_met == 1) && (viz_faza > 11))
	LDI  R26,0
	SBRC R3,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xE7
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xC)
	BRSH _0xE8
_0xE7:
	RJMP _0xE6
_0xE8:
; 0000 0150         {
; 0000 0151         OCR0 = 0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0152         return;
	RET
; 0000 0153         };
_0xE6:
; 0000 0154 
; 0000 0155     if (rezym <2)
	LDI  R30,LOW(2)
	CP   R12,R30
	BRLO PC+3
	JMP _0xE9
; 0000 0156         {
; 0000 0157         if      (viz_ampl == 0)  OCR0 = 0x00;
	LDS  R30,_viz_ampl
	CPI  R30,0
	BRNE _0xEA
	LDI  R30,LOW(0)
	RJMP _0x277
; 0000 0158         else if (viz_ampl <  2)  OCR0 = 0x10;
_0xEA:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x2)
	BRSH _0xEC
	LDI  R30,LOW(16)
	RJMP _0x277
; 0000 0159         else if (viz_ampl <  4)  OCR0 = 0x20;
_0xEC:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x4)
	BRSH _0xEE
	LDI  R30,LOW(32)
	RJMP _0x277
; 0000 015A         else if (viz_ampl <  6)  OCR0 = 0x30;
_0xEE:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x6)
	BRSH _0xF0
	LDI  R30,LOW(48)
	RJMP _0x277
; 0000 015B         else if (viz_ampl <  8)  OCR0 = 0x40;
_0xF0:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x8)
	BRSH _0xF2
	LDI  R30,LOW(64)
	RJMP _0x277
; 0000 015C         else if (viz_ampl < 10)  OCR0 = 0x50;
_0xF2:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xA)
	BRSH _0xF4
	LDI  R30,LOW(80)
	RJMP _0x277
; 0000 015D         else if (viz_ampl < 12)  OCR0 = 0x60;
_0xF4:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xC)
	BRSH _0xF6
	LDI  R30,LOW(96)
	RJMP _0x277
; 0000 015E         else if (viz_ampl < 14)  OCR0 = 0x70;
_0xF6:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xE)
	BRSH _0xF8
	LDI  R30,LOW(112)
	RJMP _0x277
; 0000 015F         else if (viz_ampl < 16)  OCR0 = 0x80;
_0xF8:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x10)
	BRSH _0xFA
	LDI  R30,LOW(128)
	RJMP _0x277
; 0000 0160         else if (viz_ampl < 18)  OCR0 = 0x90;
_0xFA:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x12)
	BRSH _0xFC
	LDI  R30,LOW(144)
	RJMP _0x277
; 0000 0161         else if (viz_ampl < 20)  OCR0 = 0xA0;
_0xFC:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x14)
	BRSH _0xFE
	LDI  R30,LOW(160)
	RJMP _0x277
; 0000 0162         else if (viz_ampl < 22)  OCR0 = 0xB0;
_0xFE:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x16)
	BRSH _0x100
	LDI  R30,LOW(176)
	RJMP _0x277
; 0000 0163         else if (viz_ampl < 24)  OCR0 = 0xC0;
_0x100:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x18)
	BRSH _0x102
	LDI  R30,LOW(192)
	RJMP _0x277
; 0000 0164         else if (viz_ampl < 26)  OCR0 = 0xD0;
_0x102:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1A)
	BRSH _0x104
	LDI  R30,LOW(208)
	RJMP _0x277
; 0000 0165         else if (viz_ampl < 28)  OCR0 = 0xE0;
_0x104:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1C)
	BRSH _0x106
	LDI  R30,LOW(224)
	RJMP _0x277
; 0000 0166         else if (viz_ampl < 30)  OCR0 = 0xF0;
_0x106:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1E)
	BRSH _0x108
	LDI  R30,LOW(240)
	RJMP _0x277
; 0000 0167         else                     OCR0 = 0xFF;
_0x108:
	LDI  R30,LOW(255)
_0x277:
	OUT  0x3C,R30
; 0000 0168         }
; 0000 0169     else if (rezym == 2)
	RJMP _0x10A
_0xE9:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x10B
; 0000 016A         {
; 0000 016B              if (viz_din ==1 )   OCR0 = 0x00;
	LDS  R26,_viz_din
	CPI  R26,LOW(0x1)
	BRNE _0x10C
	LDI  R30,LOW(0)
	RJMP _0x278
; 0000 016C         else if (viz_din == 2)   OCR0 = 0x20;
_0x10C:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x2)
	BRNE _0x10E
	LDI  R30,LOW(32)
	RJMP _0x278
; 0000 016D         else if (viz_din == 3)   OCR0 = 0x40;
_0x10E:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x3)
	BRNE _0x110
	LDI  R30,LOW(64)
	RJMP _0x278
; 0000 016E         else if (viz_din == 4)   OCR0 = 0x60;
_0x110:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x4)
	BRNE _0x112
	LDI  R30,LOW(96)
	RJMP _0x278
; 0000 016F         else if (viz_din == 5)   OCR0 = 0x80;
_0x112:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x5)
	BRNE _0x114
	LDI  R30,LOW(128)
	RJMP _0x278
; 0000 0170         else if (viz_din == 6)   OCR0 = 0xA0;
_0x114:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x6)
	BRNE _0x116
	LDI  R30,LOW(160)
	RJMP _0x278
; 0000 0171         else if (viz_din == 7)   OCR0 = 0xC0;
_0x116:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x7)
	BRNE _0x118
	LDI  R30,LOW(192)
	RJMP _0x278
; 0000 0172         else if (viz_din == 8)   OCR0 = 0xE0;
_0x118:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x8)
	BRNE _0x11A
	LDI  R30,LOW(224)
	RJMP _0x278
; 0000 0173         else                     OCR0 = 0xFF;
_0x11A:
	LDI  R30,LOW(255)
_0x278:
	OUT  0x3C,R30
; 0000 0174         };
_0x10B:
_0x10A:
; 0000 0175     return;
	RET
; 0000 0176     }
;
;void new_X_Y_stat (void)
; 0000 0179     {
_new_X_Y_stat:
; 0000 017A     #asm("wdr")
	wdr
; 0000 017B     st_X = 0xFF - read_adc (0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
	STS  _st_X,R26
; 0000 017C     st_Y = 0xFF - read_adc (3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1A
	STS  _st_Y,R26
; 0000 017D     return;
	RET
; 0000 017E     }
;
;void new_X_Y_din (void)
; 0000 0181     {
_new_X_Y_din:
; 0000 0182     #asm("wdr")
	wdr
; 0000 0183     din_X = 0xFF - read_adc (1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
	STS  _din_X,R26
; 0000 0184     din_Y = 0xFF - read_adc (2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1A
	STS  _din_Y,R26
; 0000 0185     return;
	RET
; 0000 0186     }
;
;float vektor_ampl (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
; 0000 0189     {
_vektor_ampl:
; 0000 018A     long int YY, XX;
; 0000 018B     float YX2;
; 0000 018C     float YX3;
; 0000 018D     #asm("wdr")
	SBIW R28,16
;	Y_1 -> Y+22
;	X_1 -> Y+20
;	Y_2 -> Y+18
;	X_2 -> Y+16
;	YY -> Y+12
;	XX -> Y+8
;	YX2 -> Y+4
;	YX3 -> Y+0
	wdr
; 0000 018E     if (Y_1 > Y_2) YY = Y_1 - Y_2;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x11C
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RJMP _0x279
; 0000 018F     else YY = Y_2 - Y_1;
_0x11C:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
_0x279:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x1B
; 0000 0190     if (X_1 > X_2) XX = X_1 - X_2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x11E
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RJMP _0x27A
; 0000 0191     else XX = X_2 - X_1;
_0x11E:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
_0x27A:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 8
; 0000 0192     YX2 = YY*YY + XX*XX;
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 8
	__GETD2S 8
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL __CDF1
	CALL SUBOPT_0x1E
; 0000 0193     YX3 = sqrt (YX2);
	CALL __PUTPARD1
	CALL _sqrt
	CALL SUBOPT_0x1F
; 0000 0194     return YX3;
	CALL SUBOPT_0x20
	ADIW R28,24
	RET
; 0000 0195     }
;
;
;float vektor_faza (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
; 0000 0199     {
_vektor_faza:
; 0000 019A     signed int YY, XX;
; 0000 019B     float YX2;
; 0000 019C     #asm("wdr")
	SBIW R28,4
	CALL __SAVELOCR4
;	Y_1 -> Y+14
;	X_1 -> Y+12
;	Y_2 -> Y+10
;	X_2 -> Y+8
;	YY -> R16,R17
;	XX -> R18,R19
;	YX2 -> Y+4
	wdr
; 0000 019D     YY = Y_1 - Y_2;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 019E     XX = X_1 - X_2;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0000 019F     YX2 = atan ((float)YY/XX);
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x21
	CALL _atan
	CALL SUBOPT_0x1E
; 0000 01A0     return YX2;
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; 0000 01A1     }
;
;void main_menu(void)
; 0000 01A4     {
_main_menu:
; 0000 01A5     #asm("wdr")
	wdr
; 0000 01A6     menu++;
	LDI  R30,LOW(8)
	EOR  R3,R30
; 0000 01A7     batt_zarqd();
	CALL _batt_zarqd
; 0000 01A8     while (kn1==1)
_0x120:
	CALL SUBOPT_0x22
	BRNE _0x122
; 0000 01A9         {
; 0000 01AA         kn_klava();
	CALL SUBOPT_0x23
; 0000 01AB         lcd_disp();
; 0000 01AC         };
	RJMP _0x120
_0x122:
; 0000 01AD     return;
	RET
; 0000 01AE     }
;
;void rezymm(void)
; 0000 01B1     {
_rezymm:
; 0000 01B2     #asm("wdr")
	wdr
; 0000 01B3     rezym++;
	INC  R12
; 0000 01B4     if (rezym == 4)
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x123
; 0000 01B5         {
; 0000 01B6         TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 01B7         TCCR0=0x1D;
	LDI  R30,LOW(29)
	OUT  0x33,R30
; 0000 01B8         rezym =0;
	CLR  R12
; 0000 01B9         };
_0x123:
; 0000 01BA 
; 0000 01BB     while (kn2==1)
_0x124:
	CALL SUBOPT_0x10
	BRNE _0x126
; 0000 01BC         {
; 0000 01BD         kn_klava();
	CALL SUBOPT_0x23
; 0000 01BE         lcd_disp();
; 0000 01BF         };
	RJMP _0x124
_0x126:
; 0000 01C0     return;
	RET
; 0000 01C1     }
;
;void barrier(void)
; 0000 01C4     {
_barrier:
; 0000 01C5     #asm("wdr")
	wdr
; 0000 01C6     bar++;
	INC  R13
; 0000 01C7     if (bar==10) bar=0;
	LDI  R30,LOW(10)
	CP   R30,R13
	BRNE _0x127
	CLR  R13
; 0000 01C8     bar_rad = (float) bar*0.1;
_0x127:
	MOV  R30,R13
	CALL __CBD1
	CALL __CDF1
	__GETD2N 0x3DCCCCCD
	CALL __MULF12
	STS  _bar_rad,R30
	STS  _bar_rad+1,R31
	STS  _bar_rad+2,R22
	STS  _bar_rad+3,R23
; 0000 01C9     while (kn3==1)
_0x128:
	CALL SUBOPT_0x11
	BRNE _0x12A
; 0000 01CA         {
; 0000 01CB         kn_klava();
	CALL SUBOPT_0x23
; 0000 01CC         lcd_disp();
; 0000 01CD         };
	RJMP _0x128
_0x12A:
; 0000 01CE     return;
	RET
; 0000 01CF     }
;
;void rock(void)
; 0000 01D2     {
_rock:
; 0000 01D3     #asm("wdr")
	wdr
; 0000 01D4     if (menu==1) mod_rock++;
	CALL SUBOPT_0x3
	BRNE _0x12B
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 01D5 
; 0000 01D6     else if (rezym == 0)
	RJMP _0x12C
_0x12B:
	TST  R12
	BRNE _0x12D
; 0000 01D7         {
; 0000 01D8         rock_faza = vektor_faza(st_Y, st_X, st_zero_Y, st_zero_X);
	CALL SUBOPT_0x24
	STS  _rock_faza,R30
	STS  _rock_faza+1,R31
	STS  _rock_faza+2,R22
	STS  _rock_faza+3,R23
; 0000 01D9         rock_X = st_X;
	LDS  R30,_st_X
	STS  _rock_X,R30
; 0000 01DA         rock_Y = st_Y;
	LDS  R30,_st_Y
	STS  _rock_Y,R30
; 0000 01DB         }
; 0000 01DC     else if (rezym == 1)
	RJMP _0x12E
_0x12D:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x12F
; 0000 01DD         {
; 0000 01DE         rock_sekt_X = st_X / 8;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 01DF         rock_sekt_Y = st_Y / 8;
; 0000 01E0         rock_pos_X = st_X % 8;
; 0000 01E1         rock_pos_Y = st_Y % 8;
; 0000 01E2 
; 0000 01E3              if ((rock_pos_X > 4) & (rock_pos_Y > 4)) rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x80;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x27
	BREQ _0x130
	CALL SUBOPT_0x28
	ORI  R30,0x80
	RJMP _0x27B
; 0000 01E4         else if ((rock_pos_X > 0) & (rock_pos_Y > 4)) rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x40;
_0x130:
	LDS  R26,_rock_pos_X
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
	BREQ _0x132
	CALL SUBOPT_0x28
	ORI  R30,0x40
	RJMP _0x27B
; 0000 01E5         else if  (rock_pos_X > 4)                     rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x20;
_0x132:
	LDS  R26,_rock_pos_X
	CPI  R26,LOW(0x5)
	BRLO _0x134
	CALL SUBOPT_0x28
	ORI  R30,0x20
	RJMP _0x27B
; 0000 01E6         else                                          rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x10;
_0x134:
	CALL SUBOPT_0x28
	ORI  R30,0x10
_0x27B:
	ST   X,R30
; 0000 01E7         }
; 0000 01E8     else if (rezym == 2)
	RJMP _0x136
_0x12F:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x137
; 0000 01E9     {
; 0000 01EA     geb++;
	LDS  R30,_geb
	SUBI R30,-LOW(1)
	STS  _geb,R30
; 0000 01EB     Frx++;
	IN   R30,0x28
	IN   R31,0x28+1
	ADIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01EC     if (Frx > Ftx) Frx = 0;
	CALL SUBOPT_0x29
	BRSH _0x138
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01ED     };
_0x138:
_0x137:
_0x136:
_0x12E:
_0x12C:
; 0000 01EE     return;
	RET
; 0000 01EF     }
;
;
;void ground(void)
; 0000 01F3     {
_ground:
; 0000 01F4     #asm("wdr")
	wdr
; 0000 01F5     if (menu==1) mod_gnd++;
	CALL SUBOPT_0x3
	BRNE _0x139
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 01F6 
; 0000 01F7     else if (rezym == 0)
	RJMP _0x13A
_0x139:
	TST  R12
	BRNE _0x13B
; 0000 01F8         {
; 0000 01F9         gnd_faza = vektor_faza(st_Y, st_X, st_zero_Y, st_zero_X);
	CALL SUBOPT_0x24
	STS  _gnd_faza,R30
	STS  _gnd_faza+1,R31
	STS  _gnd_faza+2,R22
	STS  _gnd_faza+3,R23
; 0000 01FA         gnd_X = st_X;
	CALL SUBOPT_0x2A
; 0000 01FB         gnd_Y = st_Y;
; 0000 01FC         }
; 0000 01FD     else if (rezym == 1)
	RJMP _0x13C
_0x13B:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x13D
; 0000 01FE         {
; 0000 01FF         gnd_sekt_X = st_X / 8;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2B
; 0000 0200         gnd_sekt_Y = st_Y / 8;
; 0000 0201         gnd_pos_X = st_X % 8;
; 0000 0202         gnd_pos_Y = st_Y % 8;
; 0000 0203 
; 0000 0204              if ((gnd_pos_X > 4) & (gnd_pos_Y > 4)) rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x08;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2C
	BREQ _0x13E
	CALL SUBOPT_0x2D
	ORI  R30,8
	RJMP _0x27C
; 0000 0205         else if ((gnd_pos_X > 0) & (gnd_pos_Y > 4)) rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x04;
_0x13E:
	LDS  R26,_gnd_pos_X
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
	BREQ _0x140
	CALL SUBOPT_0x2D
	ORI  R30,4
	RJMP _0x27C
; 0000 0206         else if  (gnd_pos_X > 4)                    rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x02;
_0x140:
	LDS  R26,_gnd_pos_X
	CPI  R26,LOW(0x5)
	BRLO _0x142
	CALL SUBOPT_0x2D
	ORI  R30,2
	RJMP _0x27C
; 0000 0207         else                                        rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x01;
_0x142:
	CALL SUBOPT_0x2D
	ORI  R30,1
_0x27C:
	ST   X,R30
; 0000 0208         }
; 0000 0209     else if (rezym == 2)
	RJMP _0x144
_0x13D:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x145
; 0000 020A         {
; 0000 020B         geb--;
	LDS  R30,_geb
	SUBI R30,LOW(1)
	STS  _geb,R30
; 0000 020C         Frx--;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 020D         if (Frx == 0) Frx = Ftx;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,0
	BRNE _0x146
	IN   R30,0x2A
	IN   R31,0x2A+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 020E         };
_0x146:
_0x145:
_0x144:
_0x13C:
_0x13A:
; 0000 020F     return;
	RET
; 0000 0210     }
;
;void zero(void)
; 0000 0213     {
_zero:
; 0000 0214     #asm("wdr")
	wdr
; 0000 0215     if (menu == 1) mod_all_met++;
	CALL SUBOPT_0x3
	BRNE _0x147
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 0216 
; 0000 0217     st_zero_X = st_X;
_0x147:
	LDS  R6,_st_X
	CLR  R7
; 0000 0218     st_zero_Y = st_Y;
	LDS  R4,_st_Y
	CLR  R5
; 0000 0219     din_zero_X = din_X;
	LDS  R10,_din_X
	CLR  R11
; 0000 021A     din_zero_Y = din_Y;
	LDS  R8,_din_Y
	CLR  R9
; 0000 021B     return;
	RET
; 0000 021C     }
;
;void vizual (void)
; 0000 021F     {
_vizual:
; 0000 0220     #asm("wdr")
	wdr
; 0000 0221     if (rezym < 2)
	LDI  R30,LOW(2)
	CP   R12,R30
	BRLO PC+3
	JMP _0x148
; 0000 0222         {
; 0000 0223         if      (ampl> 180 )   viz_ampl=32;
	CALL SUBOPT_0x2E
	__GETD1N 0x43340000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x149
	LDI  R30,LOW(32)
	RJMP _0x27D
; 0000 0224         else if (ampl> 175 )   viz_ampl=31;
_0x149:
	CALL SUBOPT_0x2E
	__GETD1N 0x432F0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14B
	LDI  R30,LOW(31)
	RJMP _0x27D
; 0000 0225         else if (ampl> 169 )   viz_ampl=30;
_0x14B:
	CALL SUBOPT_0x2E
	__GETD1N 0x43290000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14D
	LDI  R30,LOW(30)
	RJMP _0x27D
; 0000 0226         else if (ampl> 164 )   viz_ampl=29;
_0x14D:
	CALL SUBOPT_0x2E
	__GETD1N 0x43240000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14F
	LDI  R30,LOW(29)
	RJMP _0x27D
; 0000 0227         else if (ampl> 158 )   viz_ampl=28;
_0x14F:
	CALL SUBOPT_0x2E
	__GETD1N 0x431E0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x151
	LDI  R30,LOW(28)
	RJMP _0x27D
; 0000 0228         else if (ampl> 153 )   viz_ampl=27;
_0x151:
	CALL SUBOPT_0x2E
	__GETD1N 0x43190000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x153
	LDI  R30,LOW(27)
	RJMP _0x27D
; 0000 0229         else if (ampl> 147 )   viz_ampl=26;
_0x153:
	CALL SUBOPT_0x2E
	__GETD1N 0x43130000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x155
	LDI  R30,LOW(26)
	RJMP _0x27D
; 0000 022A         else if (ampl> 142 )   viz_ampl=25;
_0x155:
	CALL SUBOPT_0x2E
	__GETD1N 0x430E0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x157
	LDI  R30,LOW(25)
	RJMP _0x27D
; 0000 022B         else if (ampl> 136 )   viz_ampl=24;
_0x157:
	CALL SUBOPT_0x2E
	__GETD1N 0x43080000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x159
	LDI  R30,LOW(24)
	RJMP _0x27D
; 0000 022C         else if (ampl> 131 )   viz_ampl=23;
_0x159:
	CALL SUBOPT_0x2E
	__GETD1N 0x43030000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x15B
	LDI  R30,LOW(23)
	RJMP _0x27D
; 0000 022D         else if (ampl> 125 )   viz_ampl=22;
_0x15B:
	CALL SUBOPT_0x2E
	__GETD1N 0x42FA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x15D
	LDI  R30,LOW(22)
	RJMP _0x27D
; 0000 022E         else if (ampl> 120 )   viz_ampl=21;
_0x15D:
	CALL SUBOPT_0x2E
	__GETD1N 0x42F00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x15F
	LDI  R30,LOW(21)
	RJMP _0x27D
; 0000 022F         else if (ampl> 114 )   viz_ampl=20;
_0x15F:
	CALL SUBOPT_0x2E
	__GETD1N 0x42E40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x161
	LDI  R30,LOW(20)
	RJMP _0x27D
; 0000 0230         else if (ampl> 109 )   viz_ampl=19;
_0x161:
	CALL SUBOPT_0x2E
	__GETD1N 0x42DA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x163
	LDI  R30,LOW(19)
	RJMP _0x27D
; 0000 0231         else if (ampl> 103 )   viz_ampl=18;
_0x163:
	CALL SUBOPT_0x2E
	__GETD1N 0x42CE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x165
	LDI  R30,LOW(18)
	RJMP _0x27D
; 0000 0232         else if (ampl> 98  )   viz_ampl=17;
_0x165:
	CALL SUBOPT_0x2E
	__GETD1N 0x42C40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x167
	LDI  R30,LOW(17)
	RJMP _0x27D
; 0000 0233         else if (ampl> 92  )   viz_ampl=16;
_0x167:
	CALL SUBOPT_0x2E
	__GETD1N 0x42B80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x169
	LDI  R30,LOW(16)
	RJMP _0x27D
; 0000 0234         else if (ampl> 87  )   viz_ampl=15;
_0x169:
	CALL SUBOPT_0x2E
	__GETD1N 0x42AE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x16B
	LDI  R30,LOW(15)
	RJMP _0x27D
; 0000 0235         else if (ampl> 81  )   viz_ampl=14;
_0x16B:
	CALL SUBOPT_0x2E
	__GETD1N 0x42A20000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x16D
	LDI  R30,LOW(14)
	RJMP _0x27D
; 0000 0236         else if (ampl> 76  )   viz_ampl=13;
_0x16D:
	CALL SUBOPT_0x2E
	__GETD1N 0x42980000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x16F
	LDI  R30,LOW(13)
	RJMP _0x27D
; 0000 0237         else if (ampl> 70  )   viz_ampl=12;
_0x16F:
	CALL SUBOPT_0x2E
	__GETD1N 0x428C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x171
	LDI  R30,LOW(12)
	RJMP _0x27D
; 0000 0238         else if (ampl> 65  )   viz_ampl=11;
_0x171:
	CALL SUBOPT_0x2E
	__GETD1N 0x42820000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x173
	LDI  R30,LOW(11)
	RJMP _0x27D
; 0000 0239         else if (ampl> 59  )   viz_ampl=10;
_0x173:
	CALL SUBOPT_0x2E
	__GETD1N 0x426C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x175
	LDI  R30,LOW(10)
	RJMP _0x27D
; 0000 023A         else if (ampl> 54  )   viz_ampl=9;
_0x175:
	CALL SUBOPT_0x2E
	__GETD1N 0x42580000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x177
	LDI  R30,LOW(9)
	RJMP _0x27D
; 0000 023B         else if (ampl> 48  )   viz_ampl=8;
_0x177:
	CALL SUBOPT_0x2E
	__GETD1N 0x42400000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x179
	LDI  R30,LOW(8)
	RJMP _0x27D
; 0000 023C         else if (ampl> 43  )   viz_ampl=7;
_0x179:
	CALL SUBOPT_0x2E
	__GETD1N 0x422C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17B
	LDI  R30,LOW(7)
	RJMP _0x27D
; 0000 023D         else if (ampl> 37  )   viz_ampl=6;
_0x17B:
	CALL SUBOPT_0x2E
	__GETD1N 0x42140000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17D
	LDI  R30,LOW(6)
	RJMP _0x27D
; 0000 023E         else if (ampl> 32  )   viz_ampl=5;
_0x17D:
	CALL SUBOPT_0x2E
	__GETD1N 0x42000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17F
	LDI  R30,LOW(5)
	RJMP _0x27D
; 0000 023F         else if (ampl> 26  )   viz_ampl=4;
_0x17F:
	CALL SUBOPT_0x2E
	__GETD1N 0x41D00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x181
	LDI  R30,LOW(4)
	RJMP _0x27D
; 0000 0240         else if (ampl> 21  )   viz_ampl=3;
_0x181:
	CALL SUBOPT_0x2E
	__GETD1N 0x41A80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x183
	LDI  R30,LOW(3)
	RJMP _0x27D
; 0000 0241         else if (ampl> 15  )   viz_ampl=2;
_0x183:
	CALL SUBOPT_0x2E
	__GETD1N 0x41700000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x185
	LDI  R30,LOW(2)
	RJMP _0x27D
; 0000 0242         else if (ampl> 10  )   viz_ampl=1;
_0x185:
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x187
	LDI  R30,LOW(1)
	RJMP _0x27D
; 0000 0243         else                   viz_ampl=0;
_0x187:
	LDI  R30,LOW(0)
_0x27D:
	STS  _viz_ampl,R30
; 0000 0244 
; 0000 0245         if      (faza> 1.40)   viz_faza=0;
	CALL SUBOPT_0x30
	__GETD1N 0x3FB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x189
	RJMP _0x27E
; 0000 0246         else if (faza> 1.22)   viz_faza=8;
_0x189:
	CALL SUBOPT_0x30
	__GETD1N 0x3F9C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18B
	LDI  R30,LOW(8)
	RJMP _0x27F
; 0000 0247         else if (faza> 1.05)   viz_faza=7;
_0x18B:
	CALL SUBOPT_0x30
	__GETD1N 0x3F866666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18D
	LDI  R30,LOW(7)
	RJMP _0x27F
; 0000 0248         else if (faza> 0.82)   viz_faza=6;
_0x18D:
	CALL SUBOPT_0x30
	__GETD1N 0x3F51EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18F
	LDI  R30,LOW(6)
	RJMP _0x27F
; 0000 0249         else if (faza> 0.70)   viz_faza=5;
_0x18F:
	CALL SUBOPT_0x30
	__GETD1N 0x3F333333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x191
	LDI  R30,LOW(5)
	RJMP _0x27F
; 0000 024A         else if (faza> 0.52)   viz_faza=4;
_0x191:
	CALL SUBOPT_0x30
	__GETD1N 0x3F051EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x193
	LDI  R30,LOW(4)
	RJMP _0x27F
; 0000 024B         else if (faza> 0.35)   viz_faza=3;
_0x193:
	CALL SUBOPT_0x30
	__GETD1N 0x3EB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x195
	LDI  R30,LOW(3)
	RJMP _0x27F
; 0000 024C         else if (faza> 0.17)   viz_faza=2;
_0x195:
	CALL SUBOPT_0x30
	__GETD1N 0x3E2E147B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x197
	LDI  R30,LOW(2)
	RJMP _0x27F
; 0000 024D         else if (faza> 0   )   viz_faza=1;
_0x197:
	CALL SUBOPT_0x30
	CALL __CPD02
	BRGE _0x199
	LDI  R30,LOW(1)
	RJMP _0x27F
; 0000 024E         else if (faza> -0.17)  viz_faza=16;
_0x199:
	CALL SUBOPT_0x30
	__GETD1N 0xBE2E147B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x19B
	LDI  R30,LOW(16)
	RJMP _0x27F
; 0000 024F         else if (faza> -0.35)  viz_faza=15;
_0x19B:
	CALL SUBOPT_0x30
	__GETD1N 0xBEB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x19D
	LDI  R30,LOW(15)
	RJMP _0x27F
; 0000 0250         else if (faza> -0.52)  viz_faza=14;
_0x19D:
	CALL SUBOPT_0x30
	__GETD1N 0xBF051EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x19F
	LDI  R30,LOW(14)
	RJMP _0x27F
; 0000 0251         else if (faza> -0.70)  viz_faza=13;
_0x19F:
	CALL SUBOPT_0x30
	__GETD1N 0xBF333333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1A1
	LDI  R30,LOW(13)
	RJMP _0x27F
; 0000 0252         else if (faza> -0.82)  viz_faza=12;
_0x1A1:
	CALL SUBOPT_0x30
	__GETD1N 0xBF51EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1A3
	LDI  R30,LOW(12)
	RJMP _0x27F
; 0000 0253         else if (faza> -1.05)  viz_faza=11;
_0x1A3:
	CALL SUBOPT_0x30
	__GETD1N 0xBF866666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1A5
	LDI  R30,LOW(11)
	RJMP _0x27F
; 0000 0254         else if (faza> -1.22)  viz_faza=10;
_0x1A5:
	CALL SUBOPT_0x30
	__GETD1N 0xBF9C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1A7
	LDI  R30,LOW(10)
	RJMP _0x27F
; 0000 0255         else if (faza> -1.30)  viz_faza=9;
_0x1A7:
	CALL SUBOPT_0x30
	__GETD1N 0xBFA66666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1A9
	LDI  R30,LOW(9)
	RJMP _0x27F
; 0000 0256         else if (faza> -1.40)  viz_faza=0;
_0x1A9:
	CALL SUBOPT_0x30
	__GETD1N 0xBFB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1AB
_0x27E:
	LDI  R30,LOW(0)
_0x27F:
	STS  _viz_faza,R30
; 0000 0257         }
_0x1AB:
; 0000 0258 
; 0000 0259     else if (rezym == 2)
	RJMP _0x1AC
_0x148:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x1AD
; 0000 025A         {
; 0000 025B              if (din_Y > din_zero_Y +92 )    viz_ampl=14;
	MOVW R30,R8
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x31
	BRSH _0x1AE
	LDI  R30,LOW(14)
	RJMP _0x280
; 0000 025C         else if (din_Y > din_zero_Y +81 )    viz_ampl=13;
_0x1AE:
	MOVW R30,R8
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x31
	BRSH _0x1B0
	LDI  R30,LOW(13)
	RJMP _0x280
; 0000 025D         else if (din_Y > din_zero_Y +70 )    viz_ampl=12;
_0x1B0:
	MOVW R30,R8
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x31
	BRSH _0x1B2
	LDI  R30,LOW(12)
	RJMP _0x280
; 0000 025E         else if (din_Y > din_zero_Y +59 )    viz_ampl=11;
_0x1B2:
	MOVW R30,R8
	ADIW R30,59
	CALL SUBOPT_0x31
	BRSH _0x1B4
	LDI  R30,LOW(11)
	RJMP _0x280
; 0000 025F         else if (din_Y > din_zero_Y +48 )    viz_ampl=10;
_0x1B4:
	MOVW R30,R8
	ADIW R30,48
	CALL SUBOPT_0x31
	BRSH _0x1B6
	LDI  R30,LOW(10)
	RJMP _0x280
; 0000 0260         else if (din_Y > din_zero_Y +37 )    viz_ampl=9;
_0x1B6:
	MOVW R30,R8
	ADIW R30,37
	CALL SUBOPT_0x31
	BRSH _0x1B8
	LDI  R30,LOW(9)
	RJMP _0x280
; 0000 0261         else if (din_Y > din_zero_Y +26 )    viz_ampl=8; //___
_0x1B8:
	MOVW R30,R8
	ADIW R30,26
	CALL SUBOPT_0x31
	BRSH _0x1BA
	LDI  R30,LOW(8)
	RJMP _0x280
; 0000 0262         else if (din_Y > din_zero_Y     )    viz_ampl=0;
_0x1BA:
	MOVW R30,R8
	CALL SUBOPT_0x31
	BRSH _0x1BC
	LDI  R30,LOW(0)
	RJMP _0x280
; 0000 0263         else if (din_Y > din_zero_Y -26 )    viz_ampl=7; //___
_0x1BC:
	MOVW R30,R8
	SBIW R30,26
	CALL SUBOPT_0x31
	BRSH _0x1BE
	LDI  R30,LOW(7)
	RJMP _0x280
; 0000 0264         else if (din_Y > din_zero_Y -37 )    viz_ampl=6;
_0x1BE:
	MOVW R30,R8
	SBIW R30,37
	CALL SUBOPT_0x31
	BRSH _0x1C0
	LDI  R30,LOW(6)
	RJMP _0x280
; 0000 0265         else if (din_Y > din_zero_Y -48 )    viz_ampl=5;
_0x1C0:
	MOVW R30,R8
	SBIW R30,48
	CALL SUBOPT_0x31
	BRSH _0x1C2
	LDI  R30,LOW(5)
	RJMP _0x280
; 0000 0266         else if (din_Y > din_zero_Y -59 )    viz_ampl=4;
_0x1C2:
	MOVW R30,R8
	SBIW R30,59
	CALL SUBOPT_0x31
	BRSH _0x1C4
	LDI  R30,LOW(4)
	RJMP _0x280
; 0000 0267         else if (din_Y > din_zero_Y -70 )    viz_ampl=3;
_0x1C4:
	MOVW R30,R8
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x31
	BRSH _0x1C6
	LDI  R30,LOW(3)
	RJMP _0x280
; 0000 0268         else if (din_Y > din_zero_Y -81 )    viz_ampl=2;
_0x1C6:
	MOVW R30,R8
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x31
	BRSH _0x1C8
	LDI  R30,LOW(2)
	RJMP _0x280
; 0000 0269         else                                 viz_ampl=1;
_0x1C8:
	LDI  R30,LOW(1)
_0x280:
	STS  _viz_ampl,R30
; 0000 026A 
; 0000 026B              if (din_X > din_zero_X +92 )    viz_faza=16;
	MOVW R30,R10
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x32
	BRSH _0x1CA
	LDI  R30,LOW(16)
	RJMP _0x281
; 0000 026C         else if (din_X > din_zero_X +81 )    viz_faza=15;
_0x1CA:
	MOVW R30,R10
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x32
	BRSH _0x1CC
	LDI  R30,LOW(15)
	RJMP _0x281
; 0000 026D         else if (din_X > din_zero_X +70 )    viz_faza=14;
_0x1CC:
	MOVW R30,R10
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x32
	BRSH _0x1CE
	LDI  R30,LOW(14)
	RJMP _0x281
; 0000 026E         else if (din_X > din_zero_X +59 )    viz_faza=13;
_0x1CE:
	MOVW R30,R10
	ADIW R30,59
	CALL SUBOPT_0x32
	BRSH _0x1D0
	LDI  R30,LOW(13)
	RJMP _0x281
; 0000 026F         else if (din_X > din_zero_X +48 )    viz_faza=12;
_0x1D0:
	MOVW R30,R10
	ADIW R30,48
	CALL SUBOPT_0x32
	BRSH _0x1D2
	LDI  R30,LOW(12)
	RJMP _0x281
; 0000 0270         else if (din_X > din_zero_X +37 )    viz_faza=11;
_0x1D2:
	MOVW R30,R10
	ADIW R30,37
	CALL SUBOPT_0x32
	BRSH _0x1D4
	LDI  R30,LOW(11)
	RJMP _0x281
; 0000 0271         else if (din_X > din_zero_X +26 )    viz_faza=10;
_0x1D4:
	MOVW R30,R10
	ADIW R30,26
	CALL SUBOPT_0x32
	BRSH _0x1D6
	LDI  R30,LOW(10)
	RJMP _0x281
; 0000 0272         else if (din_X > din_zero_X +15 )    viz_faza=9;
_0x1D6:
	MOVW R30,R10
	ADIW R30,15
	CALL SUBOPT_0x32
	BRSH _0x1D8
	LDI  R30,LOW(9)
	RJMP _0x281
; 0000 0273         else if (din_X > din_zero_X     )    viz_faza=0;
_0x1D8:
	MOVW R30,R10
	CALL SUBOPT_0x32
	BRSH _0x1DA
	LDI  R30,LOW(0)
	RJMP _0x281
; 0000 0274         else if (din_X > din_zero_X -15 )    viz_faza=8;
_0x1DA:
	MOVW R30,R10
	SBIW R30,15
	CALL SUBOPT_0x32
	BRSH _0x1DC
	LDI  R30,LOW(8)
	RJMP _0x281
; 0000 0275         else if (din_X > din_zero_X -26 )    viz_faza=7;
_0x1DC:
	MOVW R30,R10
	SBIW R30,26
	CALL SUBOPT_0x32
	BRSH _0x1DE
	LDI  R30,LOW(7)
	RJMP _0x281
; 0000 0276         else if (din_X > din_zero_X -37 )    viz_faza=6;
_0x1DE:
	MOVW R30,R10
	SBIW R30,37
	CALL SUBOPT_0x32
	BRSH _0x1E0
	LDI  R30,LOW(6)
	RJMP _0x281
; 0000 0277         else if (din_X > din_zero_X -48 )    viz_faza=5;
_0x1E0:
	MOVW R30,R10
	SBIW R30,48
	CALL SUBOPT_0x32
	BRSH _0x1E2
	LDI  R30,LOW(5)
	RJMP _0x281
; 0000 0278         else if (din_X > din_zero_X -59 )    viz_faza=4;
_0x1E2:
	MOVW R30,R10
	SBIW R30,59
	CALL SUBOPT_0x32
	BRSH _0x1E4
	LDI  R30,LOW(4)
	RJMP _0x281
; 0000 0279         else if (din_X > din_zero_X -70 )    viz_faza=3;
_0x1E4:
	MOVW R30,R10
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x32
	BRSH _0x1E6
	LDI  R30,LOW(3)
	RJMP _0x281
; 0000 027A         else if (din_X > din_zero_X -81 )    viz_faza=2;
_0x1E6:
	MOVW R30,R10
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x32
	BRSH _0x1E8
	LDI  R30,LOW(2)
	RJMP _0x281
; 0000 027B         else                                 viz_faza=1;
_0x1E8:
	LDI  R30,LOW(1)
_0x281:
	STS  _viz_faza,R30
; 0000 027C         };
_0x1AD:
_0x1AC:
; 0000 027D     return;
	RET
; 0000 027E     }
;
;void start(void)
; 0000 0281 {
_start:
; 0000 0282 // Declare your local variables here
; 0000 0283 
; 0000 0284 // Input/Output Ports initialization
; 0000 0285 // Port A initialization
; 0000 0286 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0287 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0288 PORTA=0x80;
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0289 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 028A 
; 0000 028B // Port B initialization
; 0000 028C // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 028D // State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T
; 0000 028E PORTB=0x00;
	OUT  0x18,R30
; 0000 028F DDRB=0x08;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 0290 
; 0000 0291 // Port C initialization
; 0000 0292 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0293 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0294 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0295 DDRC=0x00;
	OUT  0x14,R30
; 0000 0296 
; 0000 0297 // Port D initialization
; 0000 0298 // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0299 // State7=0 State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 029A PORTD=0x00;
	OUT  0x12,R30
; 0000 029B DDRD=0xB0;
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 029C 
; 0000 029D // Timer/Counter 0 initialization
; 0000 029E // Clock source: System Clock
; 0000 029F // Clock value: 16,000 kHz
; 0000 02A0 // Mode: Fast PWM top=FFh
; 0000 02A1 // OC0 output: Non-Inverted PWM
; 0000 02A2 TCCR0=0x6D;
	LDI  R30,LOW(109)
	OUT  0x33,R30
; 0000 02A3 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 02A4 OCR0=0x00;
	OUT  0x3C,R30
; 0000 02A5 
; 0000 02A6 // Timer/Counter 1 initialization
; 0000 02A7 // Clock source: System Clock
; 0000 02A8 // Clock value: 16384,000 kHz
; 0000 02A9 // Mode: CTC top=ICR1
; 0000 02AA // OC1A output: Toggle
; 0000 02AB // OC1B output: Toggle
; 0000 02AC // Noise Canceler: Off
; 0000 02AD // Input Capture on Falling Edge
; 0000 02AE // Timer 1 Overflow Interrupt: Off
; 0000 02AF // Input Capture Interrupt: Off
; 0000 02B0 // Compare A Match Interrupt: Off
; 0000 02B1 // Compare B Match Interrupt: Off
; 0000 02B2 TCCR1A=0x50;
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 02B3 TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 02B4 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 02B5 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02B6 ICR1H=0x02;
	LDI  R30,LOW(2)
	OUT  0x27,R30
; 0000 02B7 ICR1L=0x85;
	LDI  R30,LOW(133)
	OUT  0x26,R30
; 0000 02B8 OCR1AH=0x02;
	LDI  R30,LOW(2)
	OUT  0x2B,R30
; 0000 02B9 OCR1AL=0x84;
	LDI  R30,LOW(132)
	OUT  0x2A,R30
; 0000 02BA OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 02BB OCR1BL=0x40;
	LDI  R30,LOW(64)
	OUT  0x28,R30
; 0000 02BC 
; 0000 02BD // Timer/Counter 2 initialization
; 0000 02BE // Clock source: System Clock
; 0000 02BF // Clock value: Timer 2 Stopped
; 0000 02C0 // Mode: Normal top=FFh
; 0000 02C1 // OC2 output: Disconnected
; 0000 02C2 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 02C3 TCCR2=0x00;
	OUT  0x25,R30
; 0000 02C4 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02C5 OCR2=0x00;
	OUT  0x23,R30
; 0000 02C6 
; 0000 02C7 // Watchdog Timer initialization
; 0000 02C8 // Watchdog Timer Prescaler: OSC/2048k
; 0000 02C9 WDTCR=0x00;
	OUT  0x21,R30
; 0000 02CA 
; 0000 02CB // External Interrupt(s) initialization
; 0000 02CC // INT0: Off
; 0000 02CD // INT1: Off
; 0000 02CE // INT2: Off
; 0000 02CF MCUCR=0x00;
	OUT  0x35,R30
; 0000 02D0 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 02D1 
; 0000 02D2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02D3 TIMSK=0x00;
	OUT  0x39,R30
; 0000 02D4 
; 0000 02D5 // Analog Comparator initialization
; 0000 02D6 // Analog Comparator: Off
; 0000 02D7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02D8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02D9 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 02DA 
; 0000 02DB // ADC initialization
; 0000 02DC // ADC Clock frequency: 256,000 kHz
; 0000 02DD // ADC Voltage Reference: Int., cap. on AREF
; 0000 02DE // Only the 8 most significant bits of
; 0000 02DF // the AD conversion result are used
; 0000 02E0 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 02E1 ADCSRA=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 02E2 
; 0000 02E3 #asm("wdr")
	wdr
; 0000 02E4 // LCD module initialization
; 0000 02E5 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 02E6 
; 0000 02E7 lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 02E8 sprintf (string_LCD_1, "FINDER ^_^ Exxus");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1387
	CALL SUBOPT_0x14
; 0000 02E9 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 02EA lcd_gotoxy (0,1);
; 0000 02EB sprintf (string_LCD_2, "v1.7.0   md4u.ru");
	__POINTW1FN _0x0,1404
	CALL SUBOPT_0x14
; 0000 02EC lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 02ED delay_ms (2500);
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	CALL SUBOPT_0x33
; 0000 02EE 
; 0000 02EF ampl = 0;
	CALL SUBOPT_0x34
; 0000 02F0 din_max=0x7f;
	LDI  R30,LOW(127)
	STS  _din_max,R30
; 0000 02F1 din_min=0x7f;
	STS  _din_min,R30
; 0000 02F2 st_zero_X=0x7f;
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	MOVW R6,R30
; 0000 02F3 st_zero_Y=0x00;
	CLR  R4
	CLR  R5
; 0000 02F4 din_zero_X=0x7f;
	MOVW R10,R30
; 0000 02F5 din_zero_Y=0x7F;
	MOVW R8,R30
; 0000 02F6 gnd_X=0x7f;
	STS  _gnd_X,R30
; 0000 02F7 gnd_Y=0x00;
	LDI  R30,LOW(0)
	STS  _gnd_Y,R30
; 0000 02F8 
; 0000 02F9 // Global enable interrupts
; 0000 02FA #asm("sei")
	sei
; 0000 02FB 
; 0000 02FC if (Ftx_ee == 0xFFFF)
	CALL SUBOPT_0x35
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x1EA
; 0000 02FD         {
; 0000 02FE         Ftx_ee = 0x0284;
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	LDI  R30,LOW(644)
	LDI  R31,HIGH(644)
	CALL __EEPROMWRW
; 0000 02FF         ICR1H = 0x02;
	LDI  R30,LOW(2)
	OUT  0x27,R30
; 0000 0300         ICR1L = 0x85;
	LDI  R30,LOW(133)
	OUT  0x26,R30
; 0000 0301         };
_0x1EA:
; 0000 0302 if (Frx_ee == 0xFFFF) Frx_ee = 0x0040;
	CALL SUBOPT_0x36
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x1EB
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL __EEPROMWRW
; 0000 0303 Ftx = Ftx_ee;
_0x1EB:
	CALL SUBOPT_0x35
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0304 Frx = Frx_ee;
	CALL SUBOPT_0x36
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0305 
; 0000 0306 kn_klava();
	CALL _kn_klava
; 0000 0307 if (kn1==1) while (1)
	CALL SUBOPT_0x22
	BREQ PC+3
	JMP _0x1EC
_0x1ED:
; 0000 0308                 {
; 0000 0309                 kn_klava();
	CALL _kn_klava
; 0000 030A                 new_X_Y_stat ();
	CALL _new_X_Y_stat
; 0000 030B 
; 0000 030C                 if (kn2==1)
	CALL SUBOPT_0x10
	BRNE _0x1F0
; 0000 030D                         {
; 0000 030E                         Ftx--;
	IN   R30,0x2A
	IN   R31,0x2A+1
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	ADIW R30,1
; 0000 030F                         ICR1L--;
	IN   R30,0x26
	SUBI R30,LOW(1)
	OUT  0x26,R30
	SUBI R30,-LOW(1)
; 0000 0310                         };
_0x1F0:
; 0000 0311                 if (kn3==1)
	CALL SUBOPT_0x11
	BRNE _0x1F1
; 0000 0312                         {
; 0000 0313                         Ftx++;
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBIW R30,1
; 0000 0314                         ICR1L++;
	IN   R30,0x26
	SUBI R30,-LOW(1)
	OUT  0x26,R30
	SUBI R30,LOW(1)
; 0000 0315                         };
_0x1F1:
; 0000 0316                 if (kn4==1)
	CALL SUBOPT_0x13
	BRNE _0x1F2
; 0000 0317                         {
; 0000 0318                         Frx++;
	IN   R30,0x28
	IN   R31,0x28+1
	ADIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
	SBIW R30,1
; 0000 0319                         if (Frx > Ftx) Frx = 0;
	CALL SUBOPT_0x29
	BRSH _0x1F3
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 031A                         };
_0x1F3:
_0x1F2:
; 0000 031B                 if (kn5==1)
	CALL SUBOPT_0x17
	BRNE _0x1F4
; 0000 031C                         {
; 0000 031D                         Frx--;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
	ADIW R30,1
; 0000 031E                         if (Frx == 0) Frx = Ftx;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,0
	BRNE _0x1F5
	IN   R30,0x2A
	IN   R31,0x2A+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 031F                         };
_0x1F5:
_0x1F4:
; 0000 0320                 if (kn6==1)
	CALL SUBOPT_0x18
	BREQ PC+3
	JMP _0x1F6
; 0000 0321                         {
; 0000 0322                         if (Ftx != Ftx_ee)
	__INWR 0,1,42
	CALL SUBOPT_0x35
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x1F7
; 0000 0323                                 {
; 0000 0324                                 Ftx_ee = Ftx;
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	CALL __EEPROMWRW
; 0000 0325                                 lcd_gotoxy (12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x8
; 0000 0326                                 sprintf (string_LCD_1, "Save");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1421
	RJMP _0x282
; 0000 0327                                 lcd_puts (string_LCD_1);
; 0000 0328                                 }
; 0000 0329                         else
_0x1F7:
; 0000 032A                                 {
; 0000 032B                                 lcd_gotoxy (12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x8
; 0000 032C                                 sprintf (string_LCD_1, "O.k.");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1426
_0x282:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 032D                                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL _lcd_puts
; 0000 032E                                 };
; 0000 032F 
; 0000 0330                         if  (Frx != Frx_ee)
	__INWR 0,1,40
	CALL SUBOPT_0x36
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x1F9
; 0000 0331                                 {
; 0000 0332                                 Frx_ee = Frx;
	IN   R30,0x28
	IN   R31,0x28+1
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	CALL __EEPROMWRW
; 0000 0333                                 lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xD
; 0000 0334                                 sprintf (string_LCD_2, "Save");
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1421
	RJMP _0x283
; 0000 0335                                 lcd_puts (string_LCD_2);
; 0000 0336                                 }
; 0000 0337                         else
_0x1F9:
; 0000 0338                                 {
; 0000 0339                                 lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xD
; 0000 033A                                 sprintf (string_LCD_2, "O.k.");
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,1426
_0x283:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 033B                                 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 033C                                 };
; 0000 033D                         while (kn6==1) kn_klava();
_0x1FB:
	CALL SUBOPT_0x18
	BRNE _0x1FD
	CALL _kn_klava
	RJMP _0x1FB
_0x1FD:
; 0000 033E continue;
	RJMP _0x1ED
; 0000 033F                         };
_0x1F6:
; 0000 0340 
; 0000 0341                 lcd_gotoxy (0,0);
	CALL SUBOPT_0x4
; 0000 0342                 sprintf (string_LCD_1, "Freq-TX %3x [%2x]", Ftx, st_Y);
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1431
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CALL SUBOPT_0x19
	LDS  R30,_st_Y
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x15
; 0000 0343                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 0344 
; 0000 0345                 lcd_gotoxy (0,1);
; 0000 0346                 sprintf (string_LCD_2, "Faza-X  %3x [%2x]", Frx, st_X);
	__POINTW1FN _0x0,1449
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x28
	IN   R31,0x28+1
	CALL SUBOPT_0x19
	LDS  R30,_st_X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x15
; 0000 0347                 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xC
	CALL _lcd_puts
; 0000 0348 
; 0000 0349                 delay_ms (200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x33
; 0000 034A                 };
	RJMP _0x1ED
_0x1EC:
; 0000 034B 
; 0000 034C if (kn6==1) PORTD.7 = 1;
	CALL SUBOPT_0x18
	BRNE _0x1FE
	SBI  0x12,7
; 0000 034D }
_0x1FE:
	RET
;
;void main(void)
; 0000 0350 {
_main:
; 0000 0351 start ();
	RCALL _start
; 0000 0352 while (1)
_0x201:
; 0000 0353       {
; 0000 0354       // Place your code here
; 0000 0355       kn_klava();
	CALL _kn_klava
; 0000 0356 
; 0000 0357       #asm("wdr")
	wdr
; 0000 0358       new_X_Y_stat ();
	CALL _new_X_Y_stat
; 0000 0359       new_X_Y_din ();
	CALL _new_X_Y_din
; 0000 035A 
; 0000 035B       if (kn1==1) main_menu();
	CALL SUBOPT_0x22
	BRNE _0x204
	CALL _main_menu
; 0000 035C       if (kn2==1) rezymm ();
_0x204:
	CALL SUBOPT_0x10
	BRNE _0x205
	CALL _rezymm
; 0000 035D       if (kn3==1) barrier();
_0x205:
	CALL SUBOPT_0x11
	BRNE _0x206
	CALL _barrier
; 0000 035E       if (kn4==1) rock();
_0x206:
	CALL SUBOPT_0x13
	BRNE _0x207
	CALL _rock
; 0000 035F       if (kn5==1) ground();
_0x207:
	CALL SUBOPT_0x17
	BRNE _0x208
	RCALL _ground
; 0000 0360       if (kn6==1) zero();
_0x208:
	CALL SUBOPT_0x18
	BRNE _0x209
	RCALL _zero
; 0000 0361 
; 0000 0362       if (rezym == 0)
_0x209:
	TST  R12
	BREQ PC+3
	JMP _0x20A
; 0000 0363         {
; 0000 0364 
; 0000 0365         ampl = vektor_ampl (st_Y, st_X, st_zero_Y, st_zero_X);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0366         faza = vektor_faza (st_Y, st_X, st_zero_Y, st_zero_X);
	CALL SUBOPT_0x39
; 0000 0367 
; 0000 0368         if (mod_gnd == 1)
	CALL SUBOPT_0xF
	BRNE _0x20B
; 0000 0369                 {
; 0000 036A                 if ((faza <= gnd_faza + bar_rad + 0.005 ) && (faza >= gnd_faza - bar_rad - 0.005 ))
	CALL SUBOPT_0x3A
	LDS  R26,_gnd_faza
	LDS  R27,_gnd_faza+1
	LDS  R24,_gnd_faza+2
	LDS  R25,_gnd_faza+3
	CALL SUBOPT_0x3B
	BREQ PC+4
	BRCS PC+3
	JMP  _0x20D
	CALL SUBOPT_0x3C
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	CALL SUBOPT_0x3D
	BRSH _0x20E
_0x20D:
	RJMP _0x20C
_0x20E:
; 0000 036B                     {
; 0000 036C                     gnd_X = st_X;
	CALL SUBOPT_0x2A
; 0000 036D                     gnd_Y = st_Y;
; 0000 036E                     };
_0x20C:
; 0000 036F                 ampl = vektor_ampl (st_Y, st_X, gnd_Y, gnd_X);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3F
; 0000 0370                 faza = vektor_faza (st_Y, st_X, gnd_Y, gnd_X);
	CALL SUBOPT_0x3E
	CALL _vektor_faza
	CALL SUBOPT_0x39
; 0000 0371                 };
_0x20B:
; 0000 0372 
; 0000 0373         if (mod_rock == 1)
	CALL SUBOPT_0xE
	BRNE _0x20F
; 0000 0374                 {
; 0000 0375                 if ((faza <= rock_faza + bar_rad + 0.005 ) && (faza >= rock_faza - bar_rad - 0.005 ))
	CALL SUBOPT_0x3A
	LDS  R26,_rock_faza
	LDS  R27,_rock_faza+1
	LDS  R24,_rock_faza+2
	LDS  R25,_rock_faza+3
	CALL SUBOPT_0x3B
	BREQ PC+4
	BRCS PC+3
	JMP  _0x211
	CALL SUBOPT_0x3C
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	CALL SUBOPT_0x3D
	BRSH _0x212
_0x211:
	RJMP _0x210
_0x212:
; 0000 0376                     {
; 0000 0377                     ampl = 0;
	CALL SUBOPT_0x34
; 0000 0378                     faza = 1.45;
	CALL SUBOPT_0x40
; 0000 0379                     };
_0x210:
; 0000 037A                 };
_0x20F:
; 0000 037B         }
; 0000 037C 
; 0000 037D       else if (rezym == 1)
	RJMP _0x213
_0x20A:
	LDI  R30,LOW(1)
	CP   R30,R12
	BREQ PC+3
	JMP _0x214
; 0000 037E         {
; 0000 037F         ampl = vektor_ampl (st_Y, st_X, st_zero_Y, st_zero_X);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
; 0000 0380         faza = vektor_faza (st_Y, st_X, st_zero_Y, st_zero_X);
	CALL SUBOPT_0x39
; 0000 0381 
; 0000 0382         if (mod_gnd == 1)
	CALL SUBOPT_0xF
	BREQ PC+3
	JMP _0x215
; 0000 0383                 {
; 0000 0384                 gnd_sekt_X = st_X / 8;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2B
; 0000 0385                 gnd_sekt_Y = st_Y / 8;
; 0000 0386                 gnd_pos_X = st_X % 8;
; 0000 0387                 gnd_pos_Y = st_Y % 8;
; 0000 0388 
; 0000 0389                      if ((gnd_pos_X > 4) && (gnd_pos_Y > 4) && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x08)) zemlq = 1;
	CPI  R26,LOW(0x5)
	BRLO _0x217
	LDS  R26,_gnd_pos_Y
	CPI  R26,LOW(0x5)
	BRLO _0x217
	CALL SUBOPT_0x41
	ANDI R30,LOW(0x8)
	BRNE _0x218
_0x217:
	RJMP _0x216
_0x218:
	SET
	RJMP _0x284
; 0000 038A                 else if ((gnd_pos_X > 0) && (gnd_pos_Y > 4) && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x04)) zemlq = 1;
_0x216:
	LDS  R26,_gnd_pos_X
	CPI  R26,LOW(0x1)
	BRLO _0x21B
	LDS  R26,_gnd_pos_Y
	CPI  R26,LOW(0x5)
	BRLO _0x21B
	CALL SUBOPT_0x41
	ANDI R30,LOW(0x4)
	BRNE _0x21C
_0x21B:
	RJMP _0x21A
_0x21C:
	SET
	RJMP _0x284
; 0000 038B                 else if ((gnd_pos_X > 4)                    && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x02)) zemlq = 1;
_0x21A:
	LDS  R26,_gnd_pos_X
	CPI  R26,LOW(0x5)
	BRLO _0x21F
	CALL SUBOPT_0x41
	ANDI R30,LOW(0x2)
	BRNE _0x220
_0x21F:
	RJMP _0x21E
_0x220:
	SET
	RJMP _0x284
; 0000 038C                 else if ((gnd_pos_X > 0)                    && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x01)) zemlq = 1;
_0x21E:
	LDS  R26,_gnd_pos_X
	CPI  R26,LOW(0x1)
	BRLO _0x223
	CALL SUBOPT_0x41
	ANDI R30,LOW(0x1)
	BRNE _0x224
_0x223:
	RJMP _0x222
_0x224:
	SET
	RJMP _0x284
; 0000 038D                 else                                                                                      zemlq = 0;
_0x222:
	CLT
_0x284:
	BLD  R3,1
; 0000 038E 
; 0000 038F                 if (zemlq == 1)
	LDI  R26,0
	SBRC R3,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x226
; 0000 0390                     {
; 0000 0391                     gnd_X = st_X;
	CALL SUBOPT_0x2A
; 0000 0392                     gnd_Y = st_Y;
; 0000 0393                     };
_0x226:
; 0000 0394                 ampl = vektor_ampl (st_Y, st_X, gnd_Y, gnd_X);
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x3F
; 0000 0395                 faza = vektor_faza (st_Y, st_X, gnd_Y, gnd_X);
	CALL SUBOPT_0x3E
	CALL _vektor_faza
	CALL SUBOPT_0x39
; 0000 0396                 };
_0x215:
; 0000 0397 
; 0000 0398         if (mod_rock == 1)
	CALL SUBOPT_0xE
	BREQ PC+3
	JMP _0x227
; 0000 0399                 {
; 0000 039A                 rock_sekt_X = st_X / 8;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
; 0000 039B                 rock_sekt_Y = st_Y / 8;
; 0000 039C                 rock_pos_X = st_X % 8;
; 0000 039D                 rock_pos_Y = st_Y % 8;
; 0000 039E 
; 0000 039F                      if ((rock_pos_X > 4) && (rock_pos_Y > 4) && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x80)) kamen = 1;
	CPI  R26,LOW(0x5)
	BRLO _0x229
	LDS  R26,_rock_pos_Y
	CPI  R26,LOW(0x5)
	BRLO _0x229
	CALL SUBOPT_0x42
	ANDI R30,LOW(0x80)
	BRNE _0x22A
_0x229:
	RJMP _0x228
_0x22A:
	SET
	RJMP _0x285
; 0000 03A0                 else if ((rock_pos_X > 0) && (rock_pos_Y > 4) && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x40)) kamen = 1;
_0x228:
	LDS  R26,_rock_pos_X
	CPI  R26,LOW(0x1)
	BRLO _0x22D
	LDS  R26,_rock_pos_Y
	CPI  R26,LOW(0x5)
	BRLO _0x22D
	CALL SUBOPT_0x42
	ANDI R30,LOW(0x40)
	BRNE _0x22E
_0x22D:
	RJMP _0x22C
_0x22E:
	SET
	RJMP _0x285
; 0000 03A1                 else if ((rock_pos_X > 4)                     && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x20)) kamen = 1;
_0x22C:
	LDS  R26,_rock_pos_X
	CPI  R26,LOW(0x5)
	BRLO _0x231
	CALL SUBOPT_0x42
	ANDI R30,LOW(0x20)
	BRNE _0x232
_0x231:
	RJMP _0x230
_0x232:
	SET
	RJMP _0x285
; 0000 03A2                 else if ((rock_pos_X > 0)                     && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x10)) kamen = 1;
_0x230:
	LDS  R26,_rock_pos_X
	CPI  R26,LOW(0x1)
	BRLO _0x235
	CALL SUBOPT_0x42
	ANDI R30,LOW(0x10)
	BRNE _0x236
_0x235:
	RJMP _0x234
_0x236:
	SET
	RJMP _0x285
; 0000 03A3                 else                                                                                          kamen = 0;
_0x234:
	CLT
_0x285:
	BLD  R3,2
; 0000 03A4 
; 0000 03A5                 if (kamen == 1)
	LDI  R26,0
	SBRC R3,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x238
; 0000 03A6                     {
; 0000 03A7                     ampl = 0;
	CALL SUBOPT_0x34
; 0000 03A8                     faza = 1.45;
	CALL SUBOPT_0x40
; 0000 03A9                     };
_0x238:
; 0000 03AA                 };
_0x227:
; 0000 03AB         ampl = ampl - (ampl * bar_rad / 3);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x2E
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40400000
	CALL __DIVF21
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x43
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
; 0000 03AC         }
; 0000 03AD 
; 0000 03AE       else if (rezym == 2)
	RJMP _0x239
_0x214:
	LDI  R30,LOW(2)
	CP   R30,R12
	BREQ PC+3
	JMP _0x23A
; 0000 03AF         {
; 0000 03B0         if (din_Y >= din_zero_Y)
	MOVW R30,R8
	LDS  R26,_din_Y
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x23B
; 0000 03B1                 {
; 0000 03B2                 if (din_Y >= din_max) din_max=din_Y;
	LDS  R30,_din_max
	LDS  R26,_din_Y
	CP   R26,R30
	BRLO _0x23C
	LDS  R30,_din_Y
	STS  _din_max,R30
; 0000 03B3                 else
	RJMP _0x23D
_0x23C:
; 0000 03B4                         {
; 0000 03B5                         din_max--;
	LDS  R30,_din_max
	SUBI R30,LOW(1)
	STS  _din_max,R30
; 0000 03B6                         din_min++;
	LDS  R30,_din_min
	SUBI R30,-LOW(1)
	STS  _din_min,R30
; 0000 03B7                         };
_0x23D:
; 0000 03B8                 }
; 0000 03B9         else
	RJMP _0x23E
_0x23B:
; 0000 03BA                 {
; 0000 03BB                 if (din_Y < din_min) din_min=din_Y;
	LDS  R30,_din_min
	LDS  R26,_din_Y
	CP   R26,R30
	BRSH _0x23F
	LDS  R30,_din_Y
	STS  _din_min,R30
; 0000 03BC                 else
	RJMP _0x240
_0x23F:
; 0000 03BD                         {
; 0000 03BE                         din_min++;
	LDS  R30,_din_min
	SUBI R30,-LOW(1)
	STS  _din_min,R30
; 0000 03BF                         din_max--;
	LDS  R30,_din_max
	SUBI R30,LOW(1)
	STS  _din_max,R30
; 0000 03C0                         };
_0x240:
; 0000 03C1                 };
_0x23E:
; 0000 03C2 
; 0000 03C3         if (din_max < din_zero_Y) din_max=din_zero_Y;
	CALL SUBOPT_0x44
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x241
	STS  _din_max,R8
; 0000 03C4         if (din_min > din_zero_Y) din_max=din_zero_Y;
_0x241:
	MOVW R30,R8
	CALL SUBOPT_0x45
	BRSH _0x242
	STS  _din_max,R8
; 0000 03C5 
; 0000 03C6         if ((din_zero_Y-din_min) < (din_max-din_zero_Y))
_0x242:
	LDS  R30,_din_min
	MOVW R26,R8
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R22,R26
	CALL SUBOPT_0x44
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CP   R22,R30
	CPC  R23,R31
	BRLO PC+3
	JMP _0x243
; 0000 03C7             {
; 0000 03C8                  if (din_max> din_zero_Y +92)   viz_din=8;
	MOVW R30,R8
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x46
	BRSH _0x244
	LDI  R30,LOW(8)
	RJMP _0x286
; 0000 03C9             else if (din_max> din_zero_Y +81)   viz_din=7;
_0x244:
	MOVW R30,R8
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x46
	BRSH _0x246
	LDI  R30,LOW(7)
	RJMP _0x286
; 0000 03CA             else if (din_max> din_zero_Y +70)   viz_din=6;
_0x246:
	MOVW R30,R8
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x46
	BRSH _0x248
	LDI  R30,LOW(6)
	RJMP _0x286
; 0000 03CB             else if (din_max> din_zero_Y +59)   viz_din=5;
_0x248:
	MOVW R30,R8
	ADIW R30,59
	CALL SUBOPT_0x46
	BRSH _0x24A
	LDI  R30,LOW(5)
	RJMP _0x286
; 0000 03CC             else if (din_max> din_zero_Y +48)   viz_din=4;
_0x24A:
	MOVW R30,R8
	ADIW R30,48
	CALL SUBOPT_0x46
	BRSH _0x24C
	LDI  R30,LOW(4)
	RJMP _0x286
; 0000 03CD             else if (din_max> din_zero_Y +37)   viz_din=3;
_0x24C:
	MOVW R30,R8
	ADIW R30,37
	CALL SUBOPT_0x46
	BRSH _0x24E
	LDI  R30,LOW(3)
	RJMP _0x286
; 0000 03CE             else if (din_max> din_zero_Y +26)   viz_din=2;
_0x24E:
	MOVW R30,R8
	ADIW R30,26
	CALL SUBOPT_0x46
	BRSH _0x250
	LDI  R30,LOW(2)
	RJMP _0x286
; 0000 03CF             else if (din_max> din_zero_Y +15)   viz_din=1;
_0x250:
	MOVW R30,R8
	ADIW R30,15
	CALL SUBOPT_0x46
	BRSH _0x252
	LDI  R30,LOW(1)
	RJMP _0x286
; 0000 03D0             else                                viz_din=0;
_0x252:
	LDI  R30,LOW(0)
_0x286:
	STS  _viz_din,R30
; 0000 03D1             }
; 0000 03D2         else
	RJMP _0x254
_0x243:
; 0000 03D3             {
; 0000 03D4                  if (din_min> din_zero_Y -5 )   viz_din=0;
	MOVW R30,R8
	SBIW R30,5
	CALL SUBOPT_0x45
	BRSH _0x255
	LDI  R30,LOW(0)
	RJMP _0x287
; 0000 03D5             else if (din_min> din_zero_Y -15)   viz_din=1;
_0x255:
	MOVW R30,R8
	SBIW R30,15
	CALL SUBOPT_0x45
	BRSH _0x257
	LDI  R30,LOW(1)
	RJMP _0x287
; 0000 03D6             else if (din_min> din_zero_Y -26)   viz_din=2;
_0x257:
	MOVW R30,R8
	SBIW R30,26
	CALL SUBOPT_0x45
	BRSH _0x259
	LDI  R30,LOW(2)
	RJMP _0x287
; 0000 03D7             else if (din_min> din_zero_Y -37)   viz_din=3;
_0x259:
	MOVW R30,R8
	SBIW R30,37
	CALL SUBOPT_0x45
	BRSH _0x25B
	LDI  R30,LOW(3)
	RJMP _0x287
; 0000 03D8             else if (din_min> din_zero_Y -48)   viz_din=4;
_0x25B:
	MOVW R30,R8
	SBIW R30,48
	CALL SUBOPT_0x45
	BRSH _0x25D
	LDI  R30,LOW(4)
	RJMP _0x287
; 0000 03D9             else if (din_min> din_zero_Y -59)   viz_din=5;
_0x25D:
	MOVW R30,R8
	SBIW R30,59
	CALL SUBOPT_0x45
	BRSH _0x25F
	LDI  R30,LOW(5)
	RJMP _0x287
; 0000 03DA             else if (din_min> din_zero_Y -70)   viz_din=6;
_0x25F:
	MOVW R30,R8
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x45
	BRSH _0x261
	LDI  R30,LOW(6)
	RJMP _0x287
; 0000 03DB             else if (din_min> din_zero_Y -81)   viz_din=7;
_0x261:
	MOVW R30,R8
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x45
	BRSH _0x263
	LDI  R30,LOW(7)
	RJMP _0x287
; 0000 03DC             else                                viz_din=8;
_0x263:
	LDI  R30,LOW(8)
_0x287:
	STS  _viz_din,R30
; 0000 03DD             };
_0x254:
; 0000 03DE         }
; 0000 03DF 
; 0000 03E0       else
	RJMP _0x265
_0x23A:
; 0000 03E1         {
; 0000 03E2         TCCR1B=0x18;
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0000 03E3         TCCR0=0x18;
	OUT  0x33,R30
; 0000 03E4         PORTB.3=0;
	CBI  0x18,3
; 0000 03E5         PORTD.4=0;
	CBI  0x12,4
; 0000 03E6         PORTD.5=0;
	CBI  0x12,5
; 0000 03E7         viz_ampl = 0;
	LDI  R30,LOW(0)
	STS  _viz_ampl,R30
; 0000 03E8         viz_faza = 0;
	STS  _viz_faza,R30
; 0000 03E9         };
_0x265:
_0x239:
_0x213:
; 0000 03EA 
; 0000 03EB       zvuk();
	CALL _zvuk
; 0000 03EC       vizual ();
	CALL _vizual
; 0000 03ED       lcd_disp();
	CALL _lcd_disp
; 0000 03EE 
; 0000 03EF       delay_ms (200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x33
; 0000 03F0       };
	RJMP _0x201
; 0000 03F1 }
_0x26C:
	RJMP _0x26C
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
	JMP  _0x20C0006
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
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
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
	JMP  _0x20C0006
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
	JMP  _0x20C0006
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0x47
	CALL SUBOPT_0x47
	CALL SUBOPT_0x47
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x48
	LDI  R30,LOW(4)
	CALL SUBOPT_0x48
	LDI  R30,LOW(133)
	CALL SUBOPT_0x48
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0005
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0005
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
_0x20C0006:
_0x20C0005:
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
	CALL SUBOPT_0x49
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
	CALL SUBOPT_0x4A
	RJMP _0x20C0004
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
	CALL SUBOPT_0x4A
	RJMP _0x20C0004
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
	CALL SUBOPT_0x4B
	RJMP _0x202001B
_0x202001D:
	CALL SUBOPT_0x1C
	CALL __CPD10
	BRNE _0x202001E
	LDI  R19,LOW(0)
	CALL SUBOPT_0x4B
	RJMP _0x202001F
_0x202001E:
	LDD  R19,Y+11
	CALL SUBOPT_0x4C
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020020
	CALL SUBOPT_0x4B
_0x2020021:
	CALL SUBOPT_0x4C
	BRLO _0x2020023
	CALL SUBOPT_0x4D
	RJMP _0x2020021
_0x2020023:
	RJMP _0x2020024
_0x2020020:
_0x2020025:
	CALL SUBOPT_0x4C
	BRSH _0x2020027
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x1B
	SUBI R19,LOW(1)
	RJMP _0x2020025
_0x2020027:
	CALL SUBOPT_0x4B
_0x2020024:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x4C
	BRLO _0x2020028
	CALL SUBOPT_0x4D
_0x2020028:
_0x202001F:
	LDI  R17,LOW(0)
_0x2020029:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002B
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
	CALL SUBOPT_0x4F
	CALL __PUTPARD1
	CALL _floor
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x52
	CALL SUBOPT_0x53
	CALL __CBD1
	CALL __CDF1
	CALL SUBOPT_0x54
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x43
	CALL SUBOPT_0x1B
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2020029
	CALL SUBOPT_0x52
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2020029
_0x202002B:
	CALL SUBOPT_0x55
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002D
	CALL SUBOPT_0x52
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x202002D:
	CPI  R19,10
	BRLT _0x202002E
	CALL SUBOPT_0x55
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x202002E:
	CALL SUBOPT_0x55
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0004:
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
	CALL SUBOPT_0x49
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020031
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020035
	CPI  R18,37
	BRNE _0x2020036
	LDI  R17,LOW(1)
	RJMP _0x2020037
_0x2020036:
	CALL SUBOPT_0x56
_0x2020037:
	RJMP _0x2020034
_0x2020035:
	CPI  R30,LOW(0x1)
	BRNE _0x2020038
	CPI  R18,37
	BRNE _0x2020039
	CALL SUBOPT_0x56
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
	BRNE _0x202003E
_0x202003D:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x202003F
	ORI  R16,LOW(128)
	RJMP _0x2020034
_0x202003F:
	RJMP _0x2020040
_0x202003E:
	CPI  R30,LOW(0x3)
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
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
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
	BRNE _0x2020048
	CPI  R18,48
	BRLO _0x202004A
	CPI  R18,58
	BRLO _0x202004B
_0x202004A:
	RJMP _0x2020049
_0x202004B:
	ORI  R16,LOW(32)
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020034
_0x2020049:
_0x2020046:
	CPI  R18,108
	BRNE _0x202004C
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020034
_0x202004C:
	RJMP _0x202004D
_0x2020048:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020034
_0x202004D:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020052
	CALL SUBOPT_0x57
	CALL SUBOPT_0x58
	CALL SUBOPT_0x57
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x59
	RJMP _0x2020053
_0x2020052:
	CPI  R30,LOW(0x45)
	BREQ _0x2020056
	CPI  R30,LOW(0x65)
	BRNE _0x2020057
_0x2020056:
	RJMP _0x2020058
_0x2020057:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x2020059
_0x2020058:
	MOVW R30,R28
	ADIW R30,20
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x5A
	CALL __GETD1P
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x5C
	LDD  R26,Y+9
	TST  R26
	BRMI _0x202005A
	LDD  R26,Y+19
	CPI  R26,LOW(0x2B)
	BREQ _0x202005C
	RJMP _0x202005D
_0x202005A:
	CALL SUBOPT_0x5D
	CALL __ANEGF1
	CALL SUBOPT_0x5B
	LDI  R30,LOW(45)
	STD  Y+19,R30
_0x202005C:
	SBRS R16,7
	RJMP _0x202005E
	LDD  R30,Y+19
	ST   -Y,R30
	CALL SUBOPT_0x59
	RJMP _0x202005F
_0x202005E:
	CALL SUBOPT_0x5E
	LDD  R26,Y+19
	STD  Z+0,R26
_0x202005F:
_0x202005D:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020061
	CALL SUBOPT_0x5D
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2020062
_0x2020061:
	CALL SUBOPT_0x5D
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
	CALL SUBOPT_0x5F
	RJMP _0x2020063
_0x2020059:
	CPI  R30,LOW(0x73)
	BRNE _0x2020065
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
	CALL SUBOPT_0x5F
	RJMP _0x2020066
_0x2020065:
	CPI  R30,LOW(0x70)
	BRNE _0x2020068
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020066:
	ANDI R16,LOW(127)
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
	BREQ _0x202006F
	CPI  R30,LOW(0x69)
	BRNE _0x2020070
_0x202006F:
	ORI  R16,LOW(4)
	RJMP _0x2020071
_0x2020070:
	CPI  R30,LOW(0x75)
	BRNE _0x2020072
_0x2020071:
	LDI  R30,LOW(10)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x2020073
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x1B
	LDI  R17,LOW(10)
	RJMP _0x2020074
_0x2020073:
	__GETD1N 0x2710
	CALL SUBOPT_0x1B
	LDI  R17,LOW(5)
	RJMP _0x2020074
_0x2020072:
	CPI  R30,LOW(0x58)
	BRNE _0x2020076
	ORI  R16,LOW(8)
	RJMP _0x2020077
_0x2020076:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200B5
_0x2020077:
	LDI  R30,LOW(16)
	STD  Y+18,R30
	SBRS R16,1
	RJMP _0x2020079
	__GETD1N 0x10000000
	CALL SUBOPT_0x1B
	LDI  R17,LOW(8)
	RJMP _0x2020074
_0x2020079:
	__GETD1N 0x1000
	CALL SUBOPT_0x1B
	LDI  R17,LOW(4)
_0x2020074:
	CPI  R20,0
	BREQ _0x202007A
	ANDI R16,LOW(127)
	RJMP _0x202007B
_0x202007A:
	LDI  R20,LOW(1)
_0x202007B:
	SBRS R16,1
	RJMP _0x202007C
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x5A
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020102
_0x202007C:
	SBRS R16,2
	RJMP _0x202007E
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
	CALL __CWD1
	RJMP _0x2020102
_0x202007E:
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x60
	CLR  R22
	CLR  R23
_0x2020102:
	__PUTD1S 6
	SBRS R16,2
	RJMP _0x2020080
	LDD  R26,Y+9
	TST  R26
	BRPL _0x2020081
	CALL SUBOPT_0x5D
	CALL __ANEGD1
	CALL SUBOPT_0x5B
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
	ANDI R16,LOW(251)
_0x2020083:
_0x2020080:
	MOV  R19,R20
_0x202006C:
	SBRC R16,0
	RJMP _0x2020084
_0x2020085:
	CP   R17,R21
	BRSH _0x2020088
	CP   R19,R21
	BRLO _0x2020089
_0x2020088:
	RJMP _0x2020087
_0x2020089:
	SBRS R16,7
	RJMP _0x202008A
	SBRS R16,2
	RJMP _0x202008B
	ANDI R16,LOW(251)
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
	CALL SUBOPT_0x56
	SUBI R21,LOW(1)
	RJMP _0x2020085
_0x2020087:
_0x2020084:
_0x202008E:
	CP   R17,R20
	BRSH _0x2020090
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020091
	CALL SUBOPT_0x61
	BREQ _0x2020092
	SUBI R21,LOW(1)
_0x2020092:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020091:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x59
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
	SBRS R16,3
	RJMP _0x2020098
	CALL SUBOPT_0x5E
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
	CALL SUBOPT_0x59
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
	CALL SUBOPT_0x62
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x202009F
	SBRS R16,3
	RJMP _0x20200A0
	SUBI R18,-LOW(55)
	RJMP _0x20200A1
_0x20200A0:
	SUBI R18,-LOW(87)
_0x20200A1:
	RJMP _0x20200A2
_0x202009F:
	SUBI R18,-LOW(48)
_0x20200A2:
	SBRC R16,4
	RJMP _0x20200A4
	CPI  R18,49
	BRSH _0x20200A6
	CALL SUBOPT_0x1D
	__CPD2N 0x1
	BRNE _0x20200A5
_0x20200A6:
	RJMP _0x20200A8
_0x20200A5:
	CP   R20,R19
	BRSH _0x2020104
	CP   R21,R19
	BRLO _0x20200AB
	SBRS R16,0
	RJMP _0x20200AC
_0x20200AB:
	RJMP _0x20200AA
_0x20200AC:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200AD
_0x2020104:
	LDI  R18,LOW(48)
_0x20200A8:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AE
	CALL SUBOPT_0x61
	BREQ _0x20200AF
	SUBI R21,LOW(1)
_0x20200AF:
_0x20200AE:
_0x20200AD:
_0x20200A4:
	CALL SUBOPT_0x56
	CPI  R21,0
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AA:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x62
	CALL __MODD21U
	CALL SUBOPT_0x5B
	LDD  R30,Y+18
	CALL SUBOPT_0x1D
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CALL __CPD10
	BREQ _0x202009E
	RJMP _0x202009D
_0x202009E:
_0x202009B:
	SBRS R16,0
	RJMP _0x20200B1
_0x20200B2:
	CPI  R21,0
	BREQ _0x20200B4
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x59
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
	CALL SUBOPT_0x63
	CALL _ftrunc
	CALL SUBOPT_0x1F
    brne __floor1
__floor0:
	CALL SUBOPT_0x20
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
	RJMP _0x20C0003
_xatan:
	SBIW R28,4
	__GETD1S 4
	CALL SUBOPT_0x54
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x66
	CALL SUBOPT_0x54
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x64
	CALL SUBOPT_0x66
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x64
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x63
	RCALL _xatan
	RJMP _0x20C0003
_0x2040020:
	CALL SUBOPT_0x64
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x67
	CALL SUBOPT_0x21
	RCALL _xatan
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x43
	RJMP _0x20C0003
_0x2040021:
	CALL SUBOPT_0x64
	CALL SUBOPT_0x65
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x67
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x21
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
	RJMP _0x20C0003
_atan:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x204002C
	CALL SUBOPT_0x63
	RCALL _yatan
	RJMP _0x20C0003
_0x204002C:
	CALL SUBOPT_0x20
	CALL __ANEGF1
	CALL __PUTPARD1
	RCALL _yatan
	CALL __ANEGF1
_0x20C0003:
	ADIW R28,4
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
	RCALL SUBOPT_0x4A
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
	RCALL SUBOPT_0x4A
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x68
	RCALL SUBOPT_0x69
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
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x6B
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x6C
	CALL __ADDF12
	RCALL SUBOPT_0x68
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x6B
_0x20A0014:
	RCALL SUBOPT_0x6C
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x6B
	SUBI R17,-LOW(1)
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0017
	RCALL SUBOPT_0x69
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0018
_0x20A0017:
_0x20A0019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001B
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x4F
	CALL __PUTPARD1
	CALL _floor
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6C
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x69
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x0
	CALL __MULF12
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x68
	RJMP _0x20A0019
_0x20A001B:
_0x20A0018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x69
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A001F
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x68
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x69
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x68
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
_gnd_faza:
	.BYTE 0x4
_rock_faza:
	.BYTE 0x4
_ampl:
	.BYTE 0x4
_faza:
	.BYTE 0x4
_bar_rad:
	.BYTE 0x4
_st_X:
	.BYTE 0x1
_st_Y:
	.BYTE 0x1
_din_X:
	.BYTE 0x1
_din_Y:
	.BYTE 0x1
_viz_ampl:
	.BYTE 0x1
_viz_faza:
	.BYTE 0x1
_viz_din:
	.BYTE 0x1
_din_max:
	.BYTE 0x1
_din_min:
	.BYTE 0x1
_gnd_X:
	.BYTE 0x1
_gnd_Y:
	.BYTE 0x1
_rock_X:
	.BYTE 0x1
_rock_Y:
	.BYTE 0x1
_adc_data:
	.BYTE 0x1
_batt:
	.BYTE 0x4
_rastr_st:
	.BYTE 0x400
_gnd_pos_X:
	.BYTE 0x1
_gnd_pos_Y:
	.BYTE 0x1
_rock_pos_X:
	.BYTE 0x1
_rock_pos_Y:
	.BYTE 0x1
_gnd_sekt_X:
	.BYTE 0x1
_gnd_sekt_Y:
	.BYTE 0x1
_rock_sekt_X:
	.BYTE 0x1
_rock_sekt_Y:
	.BYTE 0x1
_geb:
	.BYTE 0x1

	.ESEG
_Ftx_ee:
	.BYTE 0x2
_Frx_ee:
	.BYTE 0x2

	.DSEG
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBRC R3,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 79 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOV  R30,R13
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x9:
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0xA:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_st_X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_st_Y
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL __PUTPARD1
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x16:
	__POINTW1FN _0x0,193
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_geb
	CALL __CBD1
	CALL __PUTPARD1
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	CALL _read_adc
	LDI  R26,LOW(255)
	SUB  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1B:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1D:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x20:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x24:
	LDS  R30,_st_Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_st_X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	JMP  _vektor_faza

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LDS  R30,_st_X
	LSR  R30
	LSR  R30
	LSR  R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x26:
	STS  _rock_sekt_X,R30
	LDS  R30,_st_Y
	LSR  R30
	LSR  R30
	LSR  R30
	STS  _rock_sekt_Y,R30
	LDS  R30,_st_X
	ANDI R30,LOW(0x7)
	STS  _rock_pos_X,R30
	LDS  R30,_st_Y
	ANDI R30,LOW(0x7)
	STS  _rock_pos_Y,R30
	LDS  R26,_rock_pos_X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	CALL __GTB12U
	MOV  R0,R30
	LDS  R26,_rock_pos_Y
	LDI  R30,LOW(4)
	CALL __GTB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x28:
	LDS  R30,_rock_sekt_X
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-_rastr_st)
	SBCI R31,HIGH(-_rastr_st)
	MOVW R26,R30
	LDS  R30,_rock_sekt_Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	IN   R30,0x28
	IN   R31,0x28+1
	MOVW R26,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDS  R30,_st_X
	STS  _gnd_X,R30
	LDS  R30,_st_Y
	STS  _gnd_Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2B:
	STS  _gnd_sekt_X,R30
	LDS  R30,_st_Y
	LSR  R30
	LSR  R30
	LSR  R30
	STS  _gnd_sekt_Y,R30
	LDS  R30,_st_X
	ANDI R30,LOW(0x7)
	STS  _gnd_pos_X,R30
	LDS  R30,_st_Y
	ANDI R30,LOW(0x7)
	STS  _gnd_pos_Y,R30
	LDS  R26,_gnd_pos_X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2C:
	CALL __GTB12U
	MOV  R0,R30
	LDS  R26,_gnd_pos_Y
	LDI  R30,LOW(4)
	CALL __GTB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x2D:
	LDS  R30,_gnd_sekt_X
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-_rastr_st)
	SBCI R31,HIGH(-_rastr_st)
	MOVW R26,R30
	LDS  R30,_gnd_sekt_Y
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R30
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x2E:
	LDS  R26,_ampl
	LDS  R27,_ampl+1
	LDS  R24,_ampl+2
	LDS  R25,_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2F:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x30:
	LDS  R26,_faza
	LDS  R27,_faza+1
	LDS  R24,_faza+2
	LDS  R25,_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:62 WORDS
SUBOPT_0x31:
	LDS  R26,_din_Y
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:72 WORDS
SUBOPT_0x32:
	LDS  R26,_din_X
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x34:
	__GETD1N 0x0
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x37:
	LDS  R30,_st_Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_st_X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x38:
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	CALL _vektor_ampl
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x39:
	STS  _faza,R30
	STS  _faza+1,R31
	STS  _faza+2,R22
	STS  _faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3A:
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3B:
	CALL __ADDF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	RCALL SUBOPT_0x30
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDS  R26,_bar_rad
	LDS  R27,_bar_rad+1
	LDS  R24,_bar_rad+2
	LDS  R25,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3D:
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3BA3D70A
	CALL __SWAPD12
	CALL __SUBF12
	RCALL SUBOPT_0x30
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3E:
	LDS  R30,_gnd_Y
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_X
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3F:
	CALL _vektor_ampl
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__GETD1N 0x3FB9999A
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x41:
	LDS  R30,_gnd_sekt_X
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-_rastr_st)
	SBCI R31,HIGH(-_rastr_st)
	MOVW R26,R30
	LDS  R30,_gnd_sekt_Y
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x42:
	LDS  R30,_rock_sekt_X
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-_rastr_st)
	SBCI R31,HIGH(-_rastr_st)
	MOVW R26,R30
	LDS  R30,_rock_sekt_Y
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x43:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	MOVW R30,R8
	LDS  R26,_din_max
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x45:
	LDS  R26,_din_min
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x46:
	LDS  R26,_din_max
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4B:
	__GETD2S 4
	RCALL SUBOPT_0x2F
	CALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4C:
	__GETD1S 4
	RCALL SUBOPT_0x1D
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x1D
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RCALL SUBOPT_0x1B
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x2F
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4F:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x50
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x56:
	ST   -Y,R18
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x57:
	__GETW1SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x58:
	SBIW R30,4
	__PUTW1SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x59:
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,19
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x5A:
	__GETW2SX 88
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5C:
	RCALL SUBOPT_0x57
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5F:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x60:
	RCALL SUBOPT_0x5A
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x61:
	ANDI R16,LOW(251)
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
SUBOPT_0x62:
	RCALL SUBOPT_0x1C
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x20
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	__GETD1N 0x3F800000
	RJMP SUBOPT_0x43

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x67:
	RCALL SUBOPT_0x20
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x69:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	__GETD2S 9
	RET


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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
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

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
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
