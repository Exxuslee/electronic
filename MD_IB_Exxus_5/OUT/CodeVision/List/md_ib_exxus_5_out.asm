
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16,384000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
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
	.DEF _x_1=R4
	.DEF _x_2=R6
	.DEF _faza=R8
	.DEF _ampl=R10
	.DEF _zero_ampl=R12

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x20,0x56
	.DB  0x3D,0x25,0x64,0x20,0x42,0x3D,0x25,0x64
	.DB  0x20,0x20,0x20,0x0,0x25,0x78,0x20,0x25
	.DB  0x78,0x20,0x20,0x20,0x5A,0x20,0x20,0x20
	.DB  0x25,0x0,0x25,0x78,0x20,0x25,0x78,0x20
	.DB  0x20,0x20,0x5A,0x47,0x20,0x20,0x24,0x0
	.DB  0x25,0x78,0x20,0x25,0x78,0x20,0x20,0x20
	.DB  0x5A,0x47,0x52,0x20,0x25,0x0,0x25,0x78
	.DB  0x20,0x25,0x78,0x20,0x20,0x20,0x5A,0x20
	.DB  0x20,0x20,0x24,0x0,0x25,0x78,0x20,0x25
	.DB  0x78,0x20,0x20,0x20,0x5A,0x47,0x20,0x20
	.DB  0x25,0x0,0x25,0x78,0x20,0x25,0x78,0x20
	.DB  0x20,0x20,0x5A,0x47,0x52,0x20,0x24,0x0
	.DB  0x3E,0x20,0x47,0x72,0x6F,0x75,0x6E,0x64
	.DB  0x20,0x72,0x61,0x67,0x65,0x20,0x20,0x3C
	.DB  0x0,0x20,0x25,0x64,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x56,0x6F,0x6C,0x75,0x6D
	.DB  0x65,0x20,0x25,0x64,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x42,0x61,0x72,0x72
	.DB  0x69,0x65,0x72,0x20,0x25,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x3E,0x3E,0x3E
	.DB  0x3E,0x3E,0x20,0x52,0x6F,0x63,0x6B,0x20
	.DB  0x3C,0x3C,0x3C,0x3C,0x3C,0x0,0x25,0x66
	.DB  0x20,0x25,0x66,0x0,0x3E,0x3E,0x3E,0x3E
	.DB  0x20,0x47,0x72,0x6F,0x75,0x6E,0x64,0x20
	.DB  0x3C,0x3C,0x3C,0x3C,0x0,0x25,0x66,0x20
	.DB  0x25,0x66,0x20,0x0,0x3E,0x3E,0x3E,0x3E
	.DB  0x3E,0x20,0x5A,0x65,0x72,0x6F,0x20,0x3C
	.DB  0x3C,0x3C,0x3C,0x3C,0x0,0x25,0x78,0x20
	.DB  0x25,0x78,0x20,0x25,0x78,0x20,0x25,0x78
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x23,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x23,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x23,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x23,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x23,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x23,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x23,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x23,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x23,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x23,0x2D,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x23,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x23,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0xDC,0x0,0x24,0x24,0x24,0x20,0x4D,0x44
	.DB  0x5F,0x45,0x78,0x78,0x75,0x73,0x20,0x24
	.DB  0x24,0x24,0x0,0x20,0x20,0x20,0x76,0x30
	.DB  0x2E,0x34,0x20,0x20,0x20,0x5E,0x5F,0x5E
	.DB  0x20,0x20,0x20,0x0
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
;int faza, ampl;
;unsigned int zero_ampl, zero_faza, y_gnd, x_gnd;
;float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, now_ampl, now_faza;
;unsigned int period;
;unsigned char vol, bar, menu, rezhym, gnd_rage;
;unsigned char viz_ampl, viz_faza;
;unsigned int batt_celoe, batt_drob;
;bit kn1, kn2, kn3, kn4, kn5, kn6, all_met;
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
	__DELAY_USB 55
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
	BREQ PC+3
	JMP _0x30
; 0000 006D         {
; 0000 006E         light=1;
	CALL SUBOPT_0x4
; 0000 006F 
; 0000 0070         lcd_gotoxy (0,0);
; 0000 0071         sprintf (string_LCD_1, "%d.%dV V=%d B=%d   ", batt_celoe, batt_drob, vol, bar);
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
; 0000 0072         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x8
; 0000 0073 
; 0000 0074         lcd_gotoxy (0,1);
; 0000 0075              if (rezhym == 0 && all_met == 0) sprintf (string_LCD_2, "%x %x   Z   %", faza, ampl);
	LDS  R26,_rezhym
	CPI  R26,LOW(0x0)
	BRNE _0x34
	CALL SUBOPT_0x9
	BREQ _0x35
_0x34:
	RJMP _0x33
_0x35:
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,20
	RJMP _0x130
; 0000 0076         else if (rezhym == 0 && all_met == 1) sprintf (string_LCD_2, "%x %x   ZG  $", faza, ampl);
_0x33:
	LDS  R26,_rezhym
	CPI  R26,LOW(0x0)
	BRNE _0x38
	CALL SUBOPT_0xB
	BREQ _0x39
_0x38:
	RJMP _0x37
_0x39:
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,34
	RJMP _0x130
; 0000 0077         else if (rezhym == 1 && all_met == 0) sprintf (string_LCD_2, "%x %x   ZGR %", faza, ampl);
_0x37:
	LDS  R26,_rezhym
	CPI  R26,LOW(0x1)
	BRNE _0x3C
	CALL SUBOPT_0x9
	BREQ _0x3D
_0x3C:
	RJMP _0x3B
_0x3D:
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,48
	RJMP _0x130
; 0000 0078         else if (rezhym == 1 && all_met == 1) sprintf (string_LCD_2, "%x %x   Z   $", faza, ampl);
_0x3B:
	LDS  R26,_rezhym
	CPI  R26,LOW(0x1)
	BRNE _0x40
	CALL SUBOPT_0xB
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,62
	RJMP _0x130
; 0000 0079         else if (rezhym == 2 && all_met == 0) sprintf (string_LCD_2, "%x %x   ZG  %", faza, ampl);
_0x3F:
	LDS  R26,_rezhym
	CPI  R26,LOW(0x2)
	BRNE _0x44
	CALL SUBOPT_0x9
	BREQ _0x45
_0x44:
	RJMP _0x43
_0x45:
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,76
	RJMP _0x130
; 0000 007A         else if (rezhym == 2 && all_met == 1) sprintf (string_LCD_2, "%x %x   ZGR $", faza, ampl);
_0x43:
	LDS  R26,_rezhym
	CPI  R26,LOW(0x2)
	BRNE _0x48
	CALL SUBOPT_0xB
	BREQ _0x49
_0x48:
	RJMP _0x47
_0x49:
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,90
_0x130:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0xC
	MOVW R30,R10
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 007B         lcd_puts (string_LCD_2);
_0x47:
	RJMP _0x20C0005
; 0000 007C 
; 0000 007D         return;
; 0000 007E         };
_0x30:
; 0000 007F 
; 0000 0080     if (menu==2)
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x4A
; 0000 0081         {
; 0000 0082         light=1;
	CALL SUBOPT_0x4
; 0000 0083         lcd_gotoxy (0,0);
; 0000 0084         sprintf (string_LCD_1, "> Ground rage  <");
	__POINTW1FN _0x0,104
	CALL SUBOPT_0xE
; 0000 0085         lcd_puts (string_LCD_1);
; 0000 0086         lcd_gotoxy (0,1);
; 0000 0087         sprintf (string_LCD_2, " %d              ", gnd_rage);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,121
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_rage
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	CALL SUBOPT_0xF
; 0000 0088         lcd_puts (string_LCD_2);
	RJMP _0x20C0005
; 0000 0089         return;
; 0000 008A         };
_0x4A:
; 0000 008B 
; 0000 008C     if (kn2==1)
	CALL SUBOPT_0x10
	BRNE _0x4D
; 0000 008D         {
; 0000 008E         light=1;
	CALL SUBOPT_0x11
; 0000 008F         lcd_gotoxy (0,1);
; 0000 0090         sprintf (string_LCD_2, "Volume %d       ", vol);
	__POINTW1FN _0x0,139
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL SUBOPT_0xF
; 0000 0091         lcd_puts (string_LCD_2);
	RJMP _0x20C0005
; 0000 0092         return;
; 0000 0093         };
_0x4D:
; 0000 0094 
; 0000 0095     if (kn3==1)
	CALL SUBOPT_0x12
	BRNE _0x50
; 0000 0096         {
; 0000 0097         light=1;
	CALL SUBOPT_0x11
; 0000 0098         lcd_gotoxy (0,1);
; 0000 0099         sprintf (string_LCD_2, "Barrier %d      ", bar);
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0xF
; 0000 009A         lcd_puts (string_LCD_2);
	RJMP _0x20C0005
; 0000 009B         return;
; 0000 009C         };
_0x50:
; 0000 009D 
; 0000 009E     if (kn4==1)
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x53
; 0000 009F         {
; 0000 00A0         light=1;
	CALL SUBOPT_0x4
; 0000 00A1         lcd_gotoxy (0,0);
; 0000 00A2         sprintf (string_LCD_1, ">>>>> Rock <<<<<", bar);
	__POINTW1FN _0x0,173
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0xF
; 0000 00A3         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x8
; 0000 00A4         lcd_gotoxy (0,1);
; 0000 00A5         sprintf (string_LCD_2, "%f %f", rock_ampl, rock_faza);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,190
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	CALL __PUTPARD1
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	CALL __PUTPARD1
	CALL SUBOPT_0xD
; 0000 00A6         lcd_puts (string_LCD_2);
	RJMP _0x20C0005
; 0000 00A7         return;
; 0000 00A8         };
_0x53:
; 0000 00A9 
; 0000 00AA     if (kn5==1)
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x56
; 0000 00AB         {
; 0000 00AC         light=1;
	CALL SUBOPT_0x4
; 0000 00AD         lcd_gotoxy (0,0);
; 0000 00AE         sprintf (string_LCD_1, ">>>> Ground <<<<");
	__POINTW1FN _0x0,196
	CALL SUBOPT_0xE
; 0000 00AF         lcd_puts (string_LCD_1);
; 0000 00B0         lcd_gotoxy (0,1);
; 0000 00B1         sprintf (string_LCD_2, "%f %f ", gnd_ampl, gnd_faza);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,213
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	CALL __PUTPARD1
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	CALL __PUTPARD1
	CALL SUBOPT_0xD
; 0000 00B2         lcd_puts (string_LCD_2);
	RJMP _0x20C0005
; 0000 00B3         return;
; 0000 00B4         };
_0x56:
; 0000 00B5     if (kn6==1)
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x59
; 0000 00B6         {
; 0000 00B7         light=1;
	CALL SUBOPT_0x4
; 0000 00B8         lcd_gotoxy (0,0);
; 0000 00B9         sprintf (string_LCD_1, ">>>>> Zero <<<<<");
	__POINTW1FN _0x0,220
	CALL SUBOPT_0xE
; 0000 00BA         lcd_puts (string_LCD_1);
; 0000 00BB         lcd_gotoxy (0,1);
; 0000 00BC         sprintf (string_LCD_2, "%x %x %x %x ", zero_ampl, zero_faza, ampl, faza);
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,237
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL SUBOPT_0x5
	CALL SUBOPT_0x13
	CALL SUBOPT_0x5
	MOVW R30,R10
	CALL SUBOPT_0xC
	MOVW R30,R8
	CALL SUBOPT_0xC
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00BD         lcd_puts (string_LCD_2);
_0x20C0005:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00BE         return;
	RET
; 0000 00BF         };
_0x59:
; 0000 00C0     lcd_gotoxy (0,0);
	CALL SUBOPT_0x14
; 0000 00C1     if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
	LDS  R30,_viz_ampl
	CPI  R30,0
	BRNE _0x5C
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,250
	CALL SUBOPT_0x16
; 0000 00C2     if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");
_0x5C:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1)
	BRNE _0x5D
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,267
	CALL SUBOPT_0x16
; 0000 00C3     if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
_0x5D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x2)
	BRNE _0x5E
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,284
	CALL SUBOPT_0x16
; 0000 00C4     if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x5E:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x3)
	BRNE _0x5F
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,301
	CALL SUBOPT_0x16
; 0000 00C5     if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x5F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x4)
	BRNE _0x60
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,318
	CALL SUBOPT_0x16
; 0000 00C6     if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x60:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x5)
	BRNE _0x61
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,335
	CALL SUBOPT_0x16
; 0000 00C7     if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x61:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x6)
	BRNE _0x62
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,352
	CALL SUBOPT_0x16
; 0000 00C8     if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x62:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x7)
	BRNE _0x63
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,369
	CALL SUBOPT_0x16
; 0000 00C9     if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x63:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x8)
	BRNE _0x64
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,386
	CALL SUBOPT_0x16
; 0000 00CA     if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x64:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x9)
	BRNE _0x65
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,403
	CALL SUBOPT_0x16
; 0000 00CB     if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x65:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xA)
	BRNE _0x66
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,420
	CALL SUBOPT_0x16
; 0000 00CC     if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x66:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xB)
	BRNE _0x67
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,437
	CALL SUBOPT_0x16
; 0000 00CD     if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x67:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xC)
	BRNE _0x68
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,454
	CALL SUBOPT_0x16
; 0000 00CE     if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x68:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xD)
	BRNE _0x69
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,471
	CALL SUBOPT_0x16
; 0000 00CF     if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x69:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xE)
	BRNE _0x6A
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,488
	CALL SUBOPT_0x16
; 0000 00D0     if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x6A:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0xF)
	BRNE _0x6B
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,505
	CALL SUBOPT_0x16
; 0000 00D1     if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x6B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x10)
	BRNE _0x6C
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x16
; 0000 00D2     if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x6C:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x11)
	BRNE _0x6D
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,539
	CALL SUBOPT_0x16
; 0000 00D3     if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x6D:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x12)
	BRNE _0x6E
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,556
	CALL SUBOPT_0x16
; 0000 00D4     if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x6E:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x13)
	BRNE _0x6F
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,573
	CALL SUBOPT_0x16
; 0000 00D5     if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x6F:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x14)
	BRNE _0x70
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,590
	CALL SUBOPT_0x16
; 0000 00D6     if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x70:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x15)
	BRNE _0x71
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,607
	CALL SUBOPT_0x16
; 0000 00D7     if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x71:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x16)
	BRNE _0x72
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,624
	CALL SUBOPT_0x16
; 0000 00D8     if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x72:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x17)
	BRNE _0x73
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,641
	CALL SUBOPT_0x16
; 0000 00D9     if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x73:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x18)
	BRNE _0x74
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,658
	CALL SUBOPT_0x16
; 0000 00DA     if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x74:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x19)
	BRNE _0x75
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,675
	CALL SUBOPT_0x16
; 0000 00DB     if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x75:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1A)
	BRNE _0x76
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,692
	CALL SUBOPT_0x16
; 0000 00DC     if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x76:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1B)
	BRNE _0x77
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,709
	CALL SUBOPT_0x16
; 0000 00DD     if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x77:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1C)
	BRNE _0x78
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,726
	CALL SUBOPT_0x16
; 0000 00DE     if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x78:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1D)
	BRNE _0x79
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,743
	CALL SUBOPT_0x16
; 0000 00DF     if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x79:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1E)
	BRNE _0x7A
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,760
	CALL SUBOPT_0x16
; 0000 00E0     if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x7A:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x1F)
	BRNE _0x7B
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,777
	CALL SUBOPT_0x16
; 0000 00E1     if (viz_ampl==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x7B:
	LDS  R26,_viz_ampl
	CPI  R26,LOW(0x20)
	BRNE _0x7C
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,794
	CALL SUBOPT_0x16
; 0000 00E2     lcd_puts (string_LCD_1);
_0x7C:
	CALL SUBOPT_0x8
; 0000 00E3     lcd_gotoxy (0,1);
; 0000 00E4     if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
	LDS  R30,_viz_faza
	CPI  R30,0
	BRNE _0x7D
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,811
	CALL SUBOPT_0x16
; 0000 00E5     if (viz_faza==1)  sprintf (string_LCD_2, "Û------#I------Ü");
_0x7D:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x1)
	BRNE _0x7E
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,828
	CALL SUBOPT_0x16
; 0000 00E6     if (viz_faza==2)  sprintf (string_LCD_2, "Û-----#II------Ü");
_0x7E:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x2)
	BRNE _0x7F
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,845
	CALL SUBOPT_0x16
; 0000 00E7     if (viz_faza==3)  sprintf (string_LCD_2, "Û----#-II------Ü");
_0x7F:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x3)
	BRNE _0x80
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,862
	CALL SUBOPT_0x16
; 0000 00E8     if (viz_faza==4)  sprintf (string_LCD_2, "Û---#--II------Ü");
_0x80:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x4)
	BRNE _0x81
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,879
	CALL SUBOPT_0x16
; 0000 00E9     if (viz_faza==5)  sprintf (string_LCD_2, "Û--#---II------Ü");
_0x81:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x5)
	BRNE _0x82
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,896
	CALL SUBOPT_0x16
; 0000 00EA     if (viz_faza==6)  sprintf (string_LCD_2, "Û-#----II------Ü");
_0x82:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x6)
	BRNE _0x83
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,913
	CALL SUBOPT_0x16
; 0000 00EB     if (viz_faza==7)  sprintf (string_LCD_2, "Û#-----II------Ü");
_0x83:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x7)
	BRNE _0x84
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,930
	CALL SUBOPT_0x16
; 0000 00EC     if (viz_faza==8)  sprintf (string_LCD_2, "Û------I#------Ü");
_0x84:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x8)
	BRNE _0x85
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,947
	CALL SUBOPT_0x16
; 0000 00ED     if (viz_faza==9)  sprintf (string_LCD_2, "Û------II#-----Ü");
_0x85:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x9)
	BRNE _0x86
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,964
	CALL SUBOPT_0x16
; 0000 00EE     if (viz_faza==10) sprintf (string_LCD_2, "Û------II-#----Ü");
_0x86:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xA)
	BRNE _0x87
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,981
	CALL SUBOPT_0x16
; 0000 00EF     if (viz_faza==11) sprintf (string_LCD_2, "Û------II--#---Ü");
_0x87:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xB)
	BRNE _0x88
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,998
	CALL SUBOPT_0x16
; 0000 00F0     if (viz_faza==12) sprintf (string_LCD_2, "Û------II---#--Ü");
_0x88:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xC)
	BRNE _0x89
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,1015
	CALL SUBOPT_0x16
; 0000 00F1     if (viz_faza==13) sprintf (string_LCD_2, "Û------II----#-Ü");
_0x89:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xD)
	BRNE _0x8A
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,1032
	CALL SUBOPT_0x16
; 0000 00F2     if (viz_faza==14) sprintf (string_LCD_2, "Û------II-----#Ü");
_0x8A:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xE)
	BRNE _0x8B
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,1049
	CALL SUBOPT_0x16
; 0000 00F3 
; 0000 00F4     lcd_puts (string_LCD_2);
_0x8B:
	CALL SUBOPT_0xA
	CALL _lcd_puts
; 0000 00F5     light=0;
	CBI  0x12,6
; 0000 00F6     }
	RET
;
;void new_X_Y (void)
; 0000 00F9     {
_new_X_Y:
; 0000 00FA     #asm("wdr");
	wdr
; 0000 00FB     while (ACSR.5==0);
_0x8E:
	SBIS 0x8,5
	RJMP _0x8E
; 0000 00FC     while (ACSR.5==1);
_0x91:
	LDI  R26,0
	SBIC 0x8,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x91
; 0000 00FD     while (ACSR.5==0);
_0x94:
	SBIS 0x8,5
	RJMP _0x94
; 0000 00FE     while (ACSR.5==1)
_0x97:
	LDI  R26,0
	SBIC 0x8,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x99
; 0000 00FF         {
; 0000 0100         x_1=TCNT1;
	__INWR 4,5,44
; 0000 0101         PORTA.7=1;
	SBI  0x1B,7
; 0000 0102         };
	RJMP _0x97
_0x99:
; 0000 0103     while (ACSR.5==0)
_0x9C:
	SBIC 0x8,5
	RJMP _0x9E
; 0000 0104         {
; 0000 0105         x_2=TCNT1;
	__INWR 6,7,44
; 0000 0106         PORTA.7=0;
	CBI  0x1B,7
; 0000 0107         };
	RJMP _0x9C
_0x9E:
; 0000 0108     if (x_2 > x_1) faza= (x_2 + x_1) / 2;
	__CPWRR 4,5,6,7
	BRGE _0xA1
	MOVW R26,R4
	ADD  R26,R6
	ADC  R27,R7
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R8,R30
; 0000 0109     if (x_2 < x_1)
_0xA1:
	__CPWRR 6,7,4,5
	BRGE _0xA2
; 0000 010A         {
; 0000 010B         faza= (x_1 - x_2) + (x_1 + x_2) / 2;
	MOVW R30,R4
	SUB  R30,R6
	SBC  R31,R7
	MOVW R22,R30
	MOVW R26,R6
	ADD  R26,R4
	ADC  R27,R5
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	ADD  R30,R22
	ADC  R31,R23
	MOVW R8,R30
; 0000 010C         if (faza > period) faza = faza - period;   // ICR1
	CALL SUBOPT_0x17
	CP   R30,R8
	CPC  R31,R9
	BRSH _0xA3
	LDS  R26,_period
	LDS  R27,_period+1
	__SUBWRR 8,9,26,27
; 0000 010D         };
_0xA3:
_0xA2:
; 0000 010E     while (TCNT1 != faza);
_0xA4:
	IN   R30,0x2C
	IN   R31,0x2C+1
	CP   R8,R30
	CPC  R9,R31
	BRNE _0xA4
; 0000 010F     PORTA.6=1;
	SBI  0x1B,6
; 0000 0110     ampl = read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R10,R30
; 0000 0111     PORTA.6=0;
	CBI  0x1B,6
; 0000 0112     }
	RET
;
;float vektor_ampl (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
; 0000 0115     {
_vektor_ampl:
; 0000 0116     long int Y;
; 0000 0117     long int X;
; 0000 0118     long unsigned int temp3;
; 0000 0119     float temp;
; 0000 011A     #asm("wdr");
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
; 0000 011B     koord_1_1 = koord_1_1 /2;
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	LSR  R31
	ROR  R30
	STD  Y+22,R30
	STD  Y+22+1,R31
; 0000 011C     koord_1_2 = koord_1_2 /2;
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	LSR  R31
	ROR  R30
	STD  Y+20,R30
	STD  Y+20+1,R31
; 0000 011D     koord_2_1 = koord_2_1 /2;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LSR  R31
	ROR  R30
	STD  Y+18,R30
	STD  Y+18+1,R31
; 0000 011E     koord_2_2 = koord_2_2 /2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LSR  R31
	ROR  R30
	STD  Y+16,R30
	STD  Y+16+1,R31
; 0000 011F     if (koord_1_1 > koord_2_1) Y = koord_1_1 - koord_2_1;
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xAB
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RJMP _0x131
; 0000 0120     else Y = koord_2_1 - koord_1_1;
_0xAB:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
_0x131:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 12
; 0000 0121     if (koord_1_2 > koord_2_2) X = koord_1_2 - koord_2_2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xAD
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RJMP _0x132
; 0000 0122     else X = koord_2_2 - koord_1_2;
_0xAD:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
_0x132:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 8
; 0000 0123     temp3  = Y*Y + X*X;
	__GETD1S 12
	__GETD2S 12
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 8
	CALL SUBOPT_0x18
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0x19
; 0000 0124     temp = sqrt (temp3);
	CALL __CDF1U
	CALL __PUTPARD1
	CALL _sqrt
	CALL SUBOPT_0x1A
; 0000 0125     return temp;
	CALL SUBOPT_0x1B
	ADIW R28,24
	RET
; 0000 0126     }
;
;
;float vektor_faza (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
; 0000 012A     {
_vektor_faza:
; 0000 012B     signed int Y;
; 0000 012C     signed int X;
; 0000 012D     float temp;
; 0000 012E     #asm("wdr");
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
; 0000 012F     Y = koord_1_1 - koord_2_1;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0130     X = koord_1_2 - koord_2_2;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0000 0131     temp = atan2 (Y,X);
	MOVW R30,R16
	CALL SUBOPT_0x1C
	MOVW R30,R18
	CALL SUBOPT_0x1C
	CALL _atan2
	CALL SUBOPT_0x19
; 0000 0132     return temp;
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; 0000 0133     }
;
;void main_menu(void)
; 0000 0136     {
_main_menu:
; 0000 0137     #asm("wdr");
	wdr
; 0000 0138     menu++;
	LDS  R30,_menu
	SUBI R30,-LOW(1)
	STS  _menu,R30
; 0000 0139     if (menu==255) menu=2;
	LDS  R26,_menu
	CPI  R26,LOW(0xFF)
	BRNE _0xAF
	LDI  R30,LOW(2)
	STS  _menu,R30
; 0000 013A     if (menu==3) menu=0;
_0xAF:
	LDS  R26,_menu
	CPI  R26,LOW(0x3)
	BRNE _0xB0
	LDI  R30,LOW(0)
	STS  _menu,R30
; 0000 013B     while (kn1==1)
_0xB0:
_0xB1:
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xB3
; 0000 013C         {
; 0000 013D         kn_klava();
	CALL SUBOPT_0x1D
; 0000 013E         lcd_disp();
; 0000 013F         };
	RJMP _0xB1
_0xB3:
; 0000 0140     }
	RET
;
;void volume(void)
; 0000 0143     {
_volume:
; 0000 0144     #asm("wdr");
	wdr
; 0000 0145     if (menu==1) rezhym++;
	LDS  R26,_menu
	CPI  R26,LOW(0x1)
	BRNE _0xB4
	LDS  R30,_rezhym
	SUBI R30,-LOW(1)
	STS  _rezhym,R30
; 0000 0146     else if (menu==2) gnd_rage++;
	RJMP _0xB5
_0xB4:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0xB6
	LDS  R30,_gnd_rage
	SUBI R30,-LOW(1)
	STS  _gnd_rage,R30
; 0000 0147     else vol++;
	RJMP _0xB7
_0xB6:
	LDS  R30,_vol
	SUBI R30,-LOW(1)
	STS  _vol,R30
; 0000 0148     if (vol==10) vol=0;
_0xB7:
_0xB5:
	LDS  R26,_vol
	CPI  R26,LOW(0xA)
	BRNE _0xB8
	LDI  R30,LOW(0)
	STS  _vol,R30
; 0000 0149     if (rezhym==4) rezhym=0;
_0xB8:
	LDS  R26,_rezhym
	CPI  R26,LOW(0x4)
	BRNE _0xB9
	LDI  R30,LOW(0)
	STS  _rezhym,R30
; 0000 014A     while (kn2==1)
_0xB9:
_0xBA:
	CALL SUBOPT_0x10
	BRNE _0xBC
; 0000 014B         {
; 0000 014C         kn_klava();
	CALL SUBOPT_0x1D
; 0000 014D         lcd_disp();
; 0000 014E         };
	RJMP _0xBA
_0xBC:
; 0000 014F     }
	RET
;
;void barrier(void)
; 0000 0152     {
_barrier:
; 0000 0153     #asm("wdr");
	wdr
; 0000 0154     if (menu==1) all_met++;
	LDS  R26,_menu
	CPI  R26,LOW(0x1)
	BRNE _0xBD
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 0155     else if (menu==2) gnd_rage--;
	RJMP _0xBE
_0xBD:
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0xBF
	LDS  R30,_gnd_rage
	SUBI R30,LOW(1)
	STS  _gnd_rage,R30
; 0000 0156     else bar++;
	RJMP _0xC0
_0xBF:
	LDS  R30,_bar
	SUBI R30,-LOW(1)
	STS  _bar,R30
; 0000 0157     if (bar==10) bar=0;
_0xC0:
_0xBE:
	LDS  R26,_bar
	CPI  R26,LOW(0xA)
	BRNE _0xC1
	LDI  R30,LOW(0)
	STS  _bar,R30
; 0000 0158     while (kn3==1)
_0xC1:
_0xC2:
	CALL SUBOPT_0x12
	BRNE _0xC4
; 0000 0159         {
; 0000 015A         kn_klava();
	CALL SUBOPT_0x1D
; 0000 015B         lcd_disp();
; 0000 015C         };
	RJMP _0xC2
_0xC4:
; 0000 015D     }
	RET
;
;void rock(void)
; 0000 0160     {
_rock:
; 0000 0161     #asm("wdr");
	wdr
; 0000 0162     rock_ampl = vektor_ampl(ampl, faza, zero_ampl, zero_faza);
	CALL SUBOPT_0x1E
	RCALL _vektor_ampl
	STS  _rock_ampl,R30
	STS  _rock_ampl+1,R31
	STS  _rock_ampl+2,R22
	STS  _rock_ampl+3,R23
; 0000 0163     rock_faza = vektor_faza(ampl, faza, zero_ampl, zero_faza);
	CALL SUBOPT_0x1E
	RCALL _vektor_faza
	STS  _rock_faza,R30
	STS  _rock_faza+1,R31
	STS  _rock_faza+2,R22
	STS  _rock_faza+3,R23
; 0000 0164     }
	RET
;
;void ground(void)
; 0000 0167     {
_ground:
; 0000 0168     #asm("wdr");
	wdr
; 0000 0169     y_gnd = ampl;
	__PUTWMRN _y_gnd,0,10,11
; 0000 016A     x_gnd = faza;
	__PUTWMRN _x_gnd,0,8,9
; 0000 016B     gnd_ampl = vektor_ampl(ampl, faza, zero_ampl, zero_faza);
	CALL SUBOPT_0x1E
	RCALL _vektor_ampl
	STS  _gnd_ampl,R30
	STS  _gnd_ampl+1,R31
	STS  _gnd_ampl+2,R22
	STS  _gnd_ampl+3,R23
; 0000 016C     gnd_faza = vektor_faza(ampl, faza, zero_ampl, zero_faza);
	CALL SUBOPT_0x1E
	RCALL _vektor_faza
	STS  _gnd_faza,R30
	STS  _gnd_faza+1,R31
	STS  _gnd_faza+2,R22
	STS  _gnd_faza+3,R23
; 0000 016D     }
	RET
;
;void zero(void)
; 0000 0170     {
_zero:
; 0000 0171     #asm("wdr");
	wdr
; 0000 0172     zero_ampl=0;
	CLR  R12
	CLR  R13
; 0000 0173     zero_faza=0x0320;
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	STS  _zero_faza,R30
	STS  _zero_faza+1,R31
; 0000 0174 //    zero_ampl=ampl;
; 0000 0175 //    zero_faza=faza;
; 0000 0176     }
	RET
;
;void main(void)
; 0000 0179 {
_main:
; 0000 017A // Declare your local variables here
; 0000 017B 
; 0000 017C // Input/Output Ports initialization
; 0000 017D // Port A initialization
; 0000 017E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 017F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0180 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0181 DDRA=0xC0;
	LDI  R30,LOW(192)
	OUT  0x1A,R30
; 0000 0182 
; 0000 0183 // Port B initialization
; 0000 0184 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0185 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0186 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0187 DDRB=0x00;
	OUT  0x17,R30
; 0000 0188 
; 0000 0189 // Port C initialization
; 0000 018A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 018B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 018C PORTC=0x00;
	OUT  0x15,R30
; 0000 018D DDRC=0x00;
	OUT  0x14,R30
; 0000 018E 
; 0000 018F // Port D initialization
; 0000 0190 // Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 0191 // State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=0
; 0000 0192 PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 0193 DDRD=0xA3;
	LDI  R30,LOW(163)
	OUT  0x11,R30
; 0000 0194 
; 0000 0195 // Analog Comparator initialization
; 0000 0196 // Analog Comparator: On
; 0000 0197 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0198 ACSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0199 SFIOR=0x00;
	OUT  0x30,R30
; 0000 019A 
; 0000 019B // ADC initialization
; 0000 019C // ADC Clock frequency: 1000,000 kHz
; 0000 019D // ADC Voltage Reference: AREF pin
; 0000 019E ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 019F ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 01A0 
; 0000 01A1 // Timer/Counter 0 initialization
; 0000 01A2 // Clock source: System Clock
; 0000 01A3 // Clock value: Timer 0 Stopped
; 0000 01A4 // Mode: Phase correct PWM top=FFh
; 0000 01A5 // OC0 output: Disconnected
; 0000 01A6 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01A7 TCNT0=0x00;
	OUT  0x32,R30
; 0000 01A8 OCR0=0x00;
	OUT  0x3C,R30
; 0000 01A9 
; 0000 01AA // Timer/Counter 1 initialization
; 0000 01AB // Clock source: System Clock
; 0000 01AC // Clock value: 8000,000 kHz
; 0000 01AD // Mode: Fast PWM top=ICR1
; 0000 01AE // OC1A output: Non-Inv.
; 0000 01AF // OC1B output: Discon.
; 0000 01B0 // Noise Canceler: Off
; 0000 01B1 // Input Capture on Falling Edge
; 0000 01B2 // Timer 1 Overflow Interrupt: Off
; 0000 01B3 // Input Capture Interrupt: Off
; 0000 01B4 // Compare A Match Interrupt: Off
; 0000 01B5 // Compare B Match Interrupt: Off
; 0000 01B6 TCCR1A=0x82;
	LDI  R30,LOW(130)
	OUT  0x2F,R30
; 0000 01B7 TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 01B8 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01B9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01BA ICR1H=0x06;
	LDI  R30,LOW(6)
	OUT  0x27,R30
; 0000 01BB ICR1L=0x3F;
	LDI  R30,LOW(63)
	OUT  0x26,R30
; 0000 01BC OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 01BD OCR1AL=0x0F;
	LDI  R30,LOW(15)
	OUT  0x2A,R30
; 0000 01BE OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 01BF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01C0 
; 0000 01C1 // Timer/Counter 2 initialization
; 0000 01C2 // Clock source: System Clock
; 0000 01C3 // Clock value: 8000,000 kHz
; 0000 01C4 // Mode: Phase correct PWM top=FFh
; 0000 01C5 // OC2 output: Non-Inverted PWM
; 0000 01C6 ASSR=0x00;
	OUT  0x22,R30
; 0000 01C7 TCCR2=0x61;
	LDI  R30,LOW(97)
	OUT  0x25,R30
; 0000 01C8 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01C9 OCR2=0x7F;
	LDI  R30,LOW(127)
	OUT  0x23,R30
; 0000 01CA 
; 0000 01CB // External Interrupt(s) initialization
; 0000 01CC // INT0: Off
; 0000 01CD // INT1: Off
; 0000 01CE // INT2: Off
; 0000 01CF MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 01D0 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01D1 
; 0000 01D2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01D3 TIMSK=0x0C;
	LDI  R30,LOW(12)
	OUT  0x39,R30
; 0000 01D4 
; 0000 01D5 // Watchdog Timer initialization
; 0000 01D6 // Watchdog Timer Prescaler: OSC/2048k
; 0000 01D7 WDTCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x21,R30
; 0000 01D8 
; 0000 01D9 
; 0000 01DA // LCD module initialization
; 0000 01DB lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01DC 
; 0000 01DD 
; 0000 01DE lcd_gotoxy (0,0);
	CALL SUBOPT_0x14
; 0000 01DF sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
	CALL SUBOPT_0x15
	__POINTW1FN _0x0,1066
	CALL SUBOPT_0xE
; 0000 01E0 lcd_puts (string_LCD_1);
; 0000 01E1 lcd_gotoxy (0,1);
; 0000 01E2 sprintf (string_LCD_2, "   v0.4   ^_^   ");
	CALL SUBOPT_0xA
	__POINTW1FN _0x0,1083
	CALL SUBOPT_0x16
; 0000 01E3 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xA
	CALL _lcd_puts
; 0000 01E4 delay_ms (500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01E5 
; 0000 01E6 period=0x063F;              //period
	LDI  R30,LOW(1599)
	LDI  R31,HIGH(1599)
	STS  _period,R30
	STS  _period+1,R31
; 0000 01E7 x_gnd=period/2;
	CALL SUBOPT_0x17
	LSR  R31
	ROR  R30
	STS  _x_gnd,R30
	STS  _x_gnd+1,R31
; 0000 01E8 zero_faza=period/2;
	CALL SUBOPT_0x17
	LSR  R31
	ROR  R30
	STS  _zero_faza,R30
	STS  _zero_faza+1,R31
; 0000 01E9 
; 0000 01EA while (1)
_0xC5:
; 0000 01EB       {
; 0000 01EC       // Place your code here
; 0000 01ED       float temp_ampl, temp_faza;
; 0000 01EE       #asm("wdr");
	SBIW R28,8
;	temp_ampl -> Y+4
;	temp_faza -> Y+0
	wdr
; 0000 01EF       new_X_Y ();
	RCALL _new_X_Y
; 0000 01F0       kn_klava();
	CALL _kn_klava
; 0000 01F1 
; 0000 01F2       if (kn1==1) main_menu();
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xC8
	RCALL _main_menu
; 0000 01F3       if (kn2==1) volume();
_0xC8:
	CALL SUBOPT_0x10
	BRNE _0xC9
	RCALL _volume
; 0000 01F4       if (kn3==1) barrier();
_0xC9:
	CALL SUBOPT_0x12
	BRNE _0xCA
	RCALL _barrier
; 0000 01F5       if (kn4==1) rock();
_0xCA:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xCB
	RCALL _rock
; 0000 01F6       if (kn5==1) ground();
_0xCB:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xCC
	RCALL _ground
; 0000 01F7       if (kn6==1) zero();
_0xCC:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xCD
	RCALL _zero
; 0000 01F8 
; 0000 01F9 
; 0000 01FA 
; 0000 01FB       now_ampl = vektor_ampl (ampl, faza, zero_ampl, zero_faza);
_0xCD:
	CALL SUBOPT_0x1E
	RCALL _vektor_ampl
	STS  _now_ampl,R30
	STS  _now_ampl+1,R31
	STS  _now_ampl+2,R22
	STS  _now_ampl+3,R23
; 0000 01FC       now_faza      = vektor_faza (ampl, faza, zero_ampl, zero_faza);
	CALL SUBOPT_0x1E
	RCALL _vektor_faza
	STS  _now_faza,R30
	STS  _now_faza+1,R31
	STS  _now_faza+2,R22
	STS  _now_faza+3,R23
; 0000 01FD 
; 0000 01FE       if (rezhym == 0)
	LDS  R30,_rezhym
	CPI  R30,0
	BRNE _0xCE
; 0000 01FF         {
; 0000 0200         temp_ampl = now_ampl;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 0201         temp_faza = now_faza;
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1A
; 0000 0202         };
_0xCE:
; 0000 0203       if (rezhym == 1)
	LDS  R26,_rezhym
	CPI  R26,LOW(0x1)
	BRNE _0xCF
; 0000 0204         {
; 0000 0205         temp_ampl = now_ampl - gnd_ampl;
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
; 0000 0206         temp_faza = now_faza - gnd_faza;
	CALL SUBOPT_0x1A
; 0000 0207         };
_0xCF:
; 0000 0208       if (rezhym == 2)
	LDS  R26,_rezhym
	CPI  R26,LOW(0x2)
	BRNE _0xD0
; 0000 0209         {
; 0000 020A         temp_ampl = now_ampl - gnd_ampl - rock_ampl;
	CALL SUBOPT_0x22
	LDS  R26,_rock_ampl
	LDS  R27,_rock_ampl+1
	LDS  R24,_rock_ampl+2
	LDS  R25,_rock_ampl+3
	CALL __SUBF12
	CALL SUBOPT_0x23
; 0000 020B         temp_faza = now_faza - gnd_faza - rock_faza;
	LDS  R26,_rock_faza
	LDS  R27,_rock_faza+1
	LDS  R24,_rock_faza+2
	LDS  R25,_rock_faza+3
	CALL __SUBF12
	CALL SUBOPT_0x1A
; 0000 020C         };
_0xD0:
; 0000 020D 
; 0000 020E       if (temp_ampl> 2079 )        viz_ampl=32;
	CALL SUBOPT_0x24
	__GETD1N 0x4501F000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD1
	LDI  R30,LOW(32)
	RJMP _0x133
; 0000 020F       else if (temp_ampl> 2016 )   viz_ampl=31;
_0xD1:
	CALL SUBOPT_0x24
	__GETD1N 0x44FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD3
	LDI  R30,LOW(31)
	RJMP _0x133
; 0000 0210       else if (temp_ampl> 1953 )   viz_ampl=30;
_0xD3:
	CALL SUBOPT_0x24
	__GETD1N 0x44F42000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD5
	LDI  R30,LOW(30)
	RJMP _0x133
; 0000 0211       else if (temp_ampl> 1890 )   viz_ampl=29;
_0xD5:
	CALL SUBOPT_0x24
	__GETD1N 0x44EC4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD7
	LDI  R30,LOW(29)
	RJMP _0x133
; 0000 0212       else if (temp_ampl> 1827 )   viz_ampl=28;
_0xD7:
	CALL SUBOPT_0x24
	__GETD1N 0x44E46000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD9
	LDI  R30,LOW(28)
	RJMP _0x133
; 0000 0213       else if (temp_ampl> 1764 )   viz_ampl=27;
_0xD9:
	CALL SUBOPT_0x24
	__GETD1N 0x44DC8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDB
	LDI  R30,LOW(27)
	RJMP _0x133
; 0000 0214       else if (temp_ampl> 1701 )   viz_ampl=26;
_0xDB:
	CALL SUBOPT_0x24
	__GETD1N 0x44D4A000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDD
	LDI  R30,LOW(26)
	RJMP _0x133
; 0000 0215       else if (temp_ampl> 1638 )   viz_ampl=25;
_0xDD:
	CALL SUBOPT_0x24
	__GETD1N 0x44CCC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDF
	LDI  R30,LOW(25)
	RJMP _0x133
; 0000 0216       else if (temp_ampl> 1575 )   viz_ampl=24;
_0xDF:
	CALL SUBOPT_0x24
	__GETD1N 0x44C4E000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE1
	LDI  R30,LOW(24)
	RJMP _0x133
; 0000 0217       else if (temp_ampl> 1512 )   viz_ampl=23;
_0xE1:
	CALL SUBOPT_0x24
	__GETD1N 0x44BD0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE3
	LDI  R30,LOW(23)
	RJMP _0x133
; 0000 0218       else if (temp_ampl> 1449 )   viz_ampl=22;
_0xE3:
	CALL SUBOPT_0x24
	__GETD1N 0x44B52000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE5
	LDI  R30,LOW(22)
	RJMP _0x133
; 0000 0219       else if (temp_ampl> 1386 )   viz_ampl=21;
_0xE5:
	CALL SUBOPT_0x24
	__GETD1N 0x44AD4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE7
	LDI  R30,LOW(21)
	RJMP _0x133
; 0000 021A       else if (temp_ampl> 1323 )   viz_ampl=20;
_0xE7:
	CALL SUBOPT_0x24
	__GETD1N 0x44A56000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE9
	LDI  R30,LOW(20)
	RJMP _0x133
; 0000 021B       else if (temp_ampl> 1260 )   viz_ampl=19;
_0xE9:
	CALL SUBOPT_0x24
	__GETD1N 0x449D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEB
	LDI  R30,LOW(19)
	RJMP _0x133
; 0000 021C       else if (temp_ampl> 1197 )   viz_ampl=18;
_0xEB:
	CALL SUBOPT_0x24
	__GETD1N 0x4495A000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xED
	LDI  R30,LOW(18)
	RJMP _0x133
; 0000 021D       else if (temp_ampl> 1134 )   viz_ampl=17;
_0xED:
	CALL SUBOPT_0x24
	__GETD1N 0x448DC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEF
	LDI  R30,LOW(17)
	RJMP _0x133
; 0000 021E       else if (temp_ampl> 1071 )   viz_ampl=16;
_0xEF:
	CALL SUBOPT_0x24
	__GETD1N 0x4485E000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF1
	LDI  R30,LOW(16)
	RJMP _0x133
; 0000 021F       else if (temp_ampl> 1008 )   viz_ampl=15;
_0xF1:
	CALL SUBOPT_0x24
	__GETD1N 0x447C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF3
	LDI  R30,LOW(15)
	RJMP _0x133
; 0000 0220       else if (temp_ampl> 945  )   viz_ampl=14;
_0xF3:
	CALL SUBOPT_0x24
	__GETD1N 0x446C4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF5
	LDI  R30,LOW(14)
	RJMP _0x133
; 0000 0221       else if (temp_ampl> 882  )   viz_ampl=13;
_0xF5:
	CALL SUBOPT_0x24
	__GETD1N 0x445C8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF7
	LDI  R30,LOW(13)
	RJMP _0x133
; 0000 0222       else if (temp_ampl> 819  )   viz_ampl=12;
_0xF7:
	CALL SUBOPT_0x24
	__GETD1N 0x444CC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF9
	LDI  R30,LOW(12)
	RJMP _0x133
; 0000 0223       else if (temp_ampl> 756  )   viz_ampl=11;
_0xF9:
	CALL SUBOPT_0x24
	__GETD1N 0x443D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFB
	LDI  R30,LOW(11)
	RJMP _0x133
; 0000 0224       else if (temp_ampl> 693  )   viz_ampl=10;
_0xFB:
	CALL SUBOPT_0x24
	__GETD1N 0x442D4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFD
	LDI  R30,LOW(10)
	RJMP _0x133
; 0000 0225       else if (temp_ampl> 630  )   viz_ampl=9;
_0xFD:
	CALL SUBOPT_0x24
	__GETD1N 0x441D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFF
	LDI  R30,LOW(9)
	RJMP _0x133
; 0000 0226       else if (temp_ampl> 567  )   viz_ampl=8;
_0xFF:
	CALL SUBOPT_0x24
	__GETD1N 0x440DC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x101
	LDI  R30,LOW(8)
	RJMP _0x133
; 0000 0227       else if (temp_ampl> 504  )   viz_ampl=7;
_0x101:
	CALL SUBOPT_0x24
	__GETD1N 0x43FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x103
	LDI  R30,LOW(7)
	RJMP _0x133
; 0000 0228       else if (temp_ampl> 441  )   viz_ampl=6;
_0x103:
	CALL SUBOPT_0x24
	__GETD1N 0x43DC8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x105
	LDI  R30,LOW(6)
	RJMP _0x133
; 0000 0229       else if (temp_ampl> 378  )   viz_ampl=5;
_0x105:
	CALL SUBOPT_0x24
	__GETD1N 0x43BD0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x107
	LDI  R30,LOW(5)
	RJMP _0x133
; 0000 022A       else if (temp_ampl> 315  )   viz_ampl=4;
_0x107:
	CALL SUBOPT_0x24
	__GETD1N 0x439D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x109
	LDI  R30,LOW(4)
	RJMP _0x133
; 0000 022B       else if (temp_ampl> 252  )   viz_ampl=3;
_0x109:
	CALL SUBOPT_0x24
	__GETD1N 0x437C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10B
	LDI  R30,LOW(3)
	RJMP _0x133
; 0000 022C       else if (temp_ampl> 189  )   viz_ampl=2;
_0x10B:
	CALL SUBOPT_0x24
	__GETD1N 0x433D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10D
	LDI  R30,LOW(2)
	RJMP _0x133
; 0000 022D       else if (temp_ampl> 126  )   viz_ampl=1;
_0x10D:
	CALL SUBOPT_0x24
	__GETD1N 0x42FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10F
	LDI  R30,LOW(1)
	RJMP _0x133
; 0000 022E       else if (temp_ampl> 63   )   viz_ampl=0;
_0x10F:
	CALL SUBOPT_0x24
	__GETD1N 0x427C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x111
_0x133:
	STS  _viz_ampl,R30
; 0000 022F 
; 0000 0230       if (temp_faza> 3.14) viz_faza=0;
_0x111:
	CALL SUBOPT_0x25
	__GETD1N 0x4048F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x112
	LDI  R30,LOW(0)
	RJMP _0x134
; 0000 0231       else if (temp_faza> 2.89) viz_faza=7;
_0x112:
	CALL SUBOPT_0x25
	__GETD1N 0x4038F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x114
	LDI  R30,LOW(7)
	RJMP _0x134
; 0000 0232       else if (temp_faza> 2.67) viz_faza=6;
_0x114:
	CALL SUBOPT_0x25
	__GETD1N 0x402AE148
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x116
	LDI  R30,LOW(6)
	RJMP _0x134
; 0000 0233       else if (temp_faza> 2.45) viz_faza=5;
_0x116:
	CALL SUBOPT_0x25
	__GETD1N 0x401CCCCD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x118
	LDI  R30,LOW(5)
	RJMP _0x134
; 0000 0234       else if (temp_faza> 2.23) viz_faza=4;
_0x118:
	CALL SUBOPT_0x25
	__GETD1N 0x400EB852
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11A
	LDI  R30,LOW(4)
	RJMP _0x134
; 0000 0235       else if (temp_faza> 2.01) viz_faza=3;
_0x11A:
	CALL SUBOPT_0x25
	__GETD1N 0x4000A3D7
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11C
	LDI  R30,LOW(3)
	RJMP _0x134
; 0000 0236       else if (temp_faza> 1.79) viz_faza=2;
_0x11C:
	CALL SUBOPT_0x25
	__GETD1N 0x3FE51EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11E
	LDI  R30,LOW(2)
	RJMP _0x134
; 0000 0237       else if (temp_faza> 1.57) viz_faza=1;
_0x11E:
	CALL SUBOPT_0x25
	__GETD1N 0x3FC8F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x120
	LDI  R30,LOW(1)
	RJMP _0x134
; 0000 0238 
; 0000 0239       else if (temp_faza> 1.35) viz_faza=8;
_0x120:
	CALL SUBOPT_0x25
	__GETD1N 0x3FACCCCD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x122
	LDI  R30,LOW(8)
	RJMP _0x134
; 0000 023A       else if (temp_faza> 1.13) viz_faza=9;
_0x122:
	CALL SUBOPT_0x25
	__GETD1N 0x3F90A3D7
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x124
	LDI  R30,LOW(9)
	RJMP _0x134
; 0000 023B       else if (temp_faza> 0.91) viz_faza=10;
_0x124:
	CALL SUBOPT_0x25
	__GETD1N 0x3F68F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x126
	LDI  R30,LOW(10)
	RJMP _0x134
; 0000 023C       else if (temp_faza> 0.69) viz_faza=11;
_0x126:
	CALL SUBOPT_0x25
	__GETD1N 0x3F30A3D7
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x128
	LDI  R30,LOW(11)
	RJMP _0x134
; 0000 023D       else if (temp_faza> 0.47) viz_faza=12;
_0x128:
	CALL SUBOPT_0x25
	__GETD1N 0x3EF0A3D7
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12A
	LDI  R30,LOW(12)
	RJMP _0x134
; 0000 023E       else if (temp_faza> 0.25) viz_faza=13;
_0x12A:
	CALL SUBOPT_0x25
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12C
	LDI  R30,LOW(13)
	RJMP _0x134
; 0000 023F       else if (temp_faza> 0.00) viz_faza=14;
_0x12C:
	CALL SUBOPT_0x25
	CALL __CPD02
	BRGE _0x12E
	LDI  R30,LOW(14)
_0x134:
	STS  _viz_faza,R30
; 0000 0240 
; 0000 0241       batt_zarqd();
_0x12E:
	CALL _batt_zarqd
; 0000 0242       lcd_disp();
	CALL _lcd_disp
; 0000 0243       #asm("wdr");
	wdr
; 0000 0244       };
	ADIW R28,8
	RJMP _0xC5
; 0000 0245 }
_0x12F:
	RJMP _0x12F
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
	JMP  _0x20C0004
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
	JMP  _0x20C0004
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
	JMP  _0x20C0004
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
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x27
	LDI  R30,LOW(4)
	CALL SUBOPT_0x27
	LDI  R30,LOW(133)
	CALL SUBOPT_0x27
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0003
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0003
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
_0x20C0004:
_0x20C0003:
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
	CALL SUBOPT_0x28
_0x202001D:
	RJMP _0x202001A
_0x202001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x202001E
	CPI  R18,37
	BRNE _0x202001F
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x2A
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x202002E
	CALL SUBOPT_0x2B
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x2C
	RJMP _0x202002F
_0x202002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2020031
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020032
_0x2020031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2020034
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL _strlenf
	MOV  R17,R30
	CALL SUBOPT_0x29
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
_0x2020032:
	CALL SUBOPT_0x29
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2E
	BREQ _0x2020041
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
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
	CALL SUBOPT_0x29
	CALL SUBOPT_0x30
_0x2020044:
	RJMP _0x2020045
_0x2020041:
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2F
_0x2020045:
_0x2020035:
	CALL SUBOPT_0x31
	BRNE _0x2020046
_0x2020047:
	CP   R17,R21
	BRSH _0x2020049
	CALL SUBOPT_0x29
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004A
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2E
	BREQ _0x202004B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x28
	SUBI R21,LOW(1)
	RJMP _0x2020047
_0x2020049:
_0x2020046:
	MOV  R19,R17
	CALL SUBOPT_0x29
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004E
_0x202004F:
	CPI  R19,0
	BREQ _0x2020051
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x29
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202005D
	CALL SUBOPT_0x2A
	ADIW R30,7
	RJMP _0x20200BE
_0x202005D:
	CALL SUBOPT_0x2A
	ADIW R30,39
_0x20200BE:
	MOV  R18,R30
_0x202005C:
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x31
	BREQ _0x2020067
_0x2020066:
	RJMP _0x2020065
_0x2020067:
	LDI  R18,LOW(32)
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2E
	BREQ _0x2020069
	CALL SUBOPT_0x29
	CALL SUBOPT_0x30
	ST   -Y,R20
	CALL SUBOPT_0x2C
	CPI  R21,0
	BREQ _0x202006A
	SUBI R21,LOW(1)
_0x202006A:
_0x2020069:
_0x2020068:
_0x2020060:
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x31
	BREQ _0x202006C
_0x202006D:
	CPI  R21,0
	BREQ _0x202006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x2C
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
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x32
	CALL SUBOPT_0x24
	CALL __MULF12
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x33
	CALL SUBOPT_0x24
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x25
	CALL SUBOPT_0x33
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x25
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x34
	RCALL _xatan
	RJMP _0x20C0002
_0x2040020:
	CALL SUBOPT_0x25
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	__GETD2N 0x3FC90FDB
	CALL SUBOPT_0x37
	RJMP _0x20C0002
_0x2040021:
	CALL SUBOPT_0x25
	__GETD1N 0x3F800000
	CALL SUBOPT_0x37
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x35
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x36
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0002:
	ADIW R28,4
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x32
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0001
_0x204002E:
	CALL SUBOPT_0x18
	CALL __CPD02
	BRGE _0x204002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0001
_0x204002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0001
_0x204002D:
	CALL SUBOPT_0x32
	CALL SUBOPT_0x18
	CALL __DIVF21
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x24
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0x34
	RCALL _yatan
	RJMP _0x20C0001
_0x2040031:
	CALL SUBOPT_0x38
	CALL __ANEGF1
	RJMP _0x20C0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0x38
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x37
	RJMP _0x20C0001
_0x2040032:
	CALL SUBOPT_0x34
	RCALL _yatan
	__GETD2N 0xC0490FDB
	CALL __ADDF12
_0x20C0001:
	ADIW R28,12
	RET

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
_y_gnd:
	.BYTE 0x2
_x_gnd:
	.BYTE 0x2
_gnd_ampl:
	.BYTE 0x4
_gnd_faza:
	.BYTE 0x4
_rock_ampl:
	.BYTE 0x4
_rock_faza:
	.BYTE 0x4
_now_ampl:
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
_rezhym:
	.BYTE 0x1
_gnd_rage:
	.BYTE 0x1
_viz_ampl:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
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
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,0
	SBRC R2,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	SBI  0x12,6
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDS  R30,_zero_faza
	LDS  R31,_zero_faza+1
	RET

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 49 TIMES, CODE SIZE REDUCTION:189 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDS  R30,_period
	LDS  R31,_period+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x1E:
	ST   -Y,R11
	ST   -Y,R10
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R13
	ST   -Y,R12
	RCALL SUBOPT_0x13
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	LDS  R30,_now_ampl
	LDS  R31,_now_ampl+1
	LDS  R22,_now_ampl+2
	LDS  R23,_now_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	LDS  R26,_gnd_ampl
	LDS  R27,_gnd_ampl+1
	LDS  R24,_gnd_ampl+2
	LDS  R25,_gnd_ampl+3
	RCALL SUBOPT_0x1F
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x20
	LDS  R26,_gnd_faza
	LDS  R27,_gnd_faza+1
	LDS  R24,_gnd_faza+2
	LDS  R25,_gnd_faza+3
	RCALL SUBOPT_0x21
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x24:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x25:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x28:
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
SUBOPT_0x29:
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2C:
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
SUBOPT_0x2D:
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
SUBOPT_0x2E:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	MOV  R30,R16
	LDI  R31,0
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	RCALL SUBOPT_0x1B
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x1B
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __DIVF21
	CALL __PUTPARD1
	JMP  _xatan

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x1B
	CALL __ANEGF1
	CALL __PUTPARD1
	JMP  _yatan


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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
