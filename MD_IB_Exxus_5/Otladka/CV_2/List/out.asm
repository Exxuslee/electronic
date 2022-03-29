
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
	.DEF _zero_Y=R4
	.DEF _zero_X=R6
	.DEF _vol=R9
	.DEF _bar=R8
	.DEF _X=R11
	.DEF _Y=R10
	.DEF _viz_ampl=R13
	.DEF _viz_faza=R12

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
	.DB  0x78,0x20,0x3D,0x5A,0x0,0x2B,0x47,0x0
	.DB  0x2B,0x52,0x0,0x2B,0x41,0x6C,0x6C,0x0
	.DB  0x2D,0x46,0x65,0x20,0x0,0x56,0x6F,0x6C
	.DB  0x75,0x6D,0x65,0x20,0x25,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x42
	.DB  0x61,0x72,0x72,0x69,0x65,0x72,0x20,0x25
	.DB  0x64,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x3E,0x3E,0x3E,0x3E,0x3E,0x20,0x52
	.DB  0x6F,0x63,0x6B,0x20,0x3C,0x3C,0x3C,0x3C
	.DB  0x3C,0x0,0x25,0x66,0x20,0x25,0x66,0x0
	.DB  0x3E,0x3E,0x3E,0x3E,0x20,0x47,0x72,0x6F
	.DB  0x75,0x6E,0x64,0x20,0x3C,0x3C,0x3C,0x3C
	.DB  0x0,0x25,0x66,0x20,0x25,0x66,0x20,0x0
	.DB  0x3E,0x3E,0x3E,0x3E,0x3E,0x20,0x5A,0x65
	.DB  0x72,0x6F,0x20,0x3C,0x3C,0x3C,0x3C,0x3C
	.DB  0x0,0x25,0x78,0x20,0x25,0x78,0x20,0x25
	.DB  0x78,0x20,0x25,0x78,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x23
	.DB  0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x23
	.DB  0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x23
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0x3E
	.DB  0x5F,0x3C,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x23,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x23,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x23,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x23,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x23,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x23,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x23,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x6F,0x5F,0x4F,0x0
	.DB  0x24,0x24,0x24,0x20,0x4D,0x44,0x5F,0x45
	.DB  0x78,0x78,0x75,0x73,0x20,0x24,0x24,0x24
	.DB  0x0,0x76,0x31,0x2E,0x35,0x20,0x5E,0x5F
	.DB  0x5E,0x20,0x6D,0x64,0x34,0x75,0x2E,0x72
	.DB  0x75,0x0
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
;Date    : 04.08.2009
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
;
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0024 #endasm
;
;#include <lcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;#include <i2c.h>
;
;#define ADC_VREF_TYPE 0x60
;#define light PORTD.6
;
;// Declare your global variables here
;char string_LCD_1[20], string_LCD_2[20];
;unsigned int zero_Y, zero_X;
;float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, gnd_ampl_max, gnd_faza_max, rock_ampl_max, rock_faza_max;
;float now_ampl, now_faza, bar_rad;
;unsigned char vol, bar;
;unsigned char X, Y, viz_ampl, viz_faza;
;unsigned int batt_celoe, batt_drob;
;bit kn1, kn2, kn3, kn4, kn5, kn6, menu, mod_gnd, mod_rock, mod_all_met;
;
;float temp_ampl = 0;
;float temp_faza = 0;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 003F {

	.CSEG
_read_adc:
; 0000 0040 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0041 // Delay needed for the stabilization of the ADC input voltage
; 0000 0042 delay_us(10);
	__DELAY_USB 55
; 0000 0043 // Start the AD conversion
; 0000 0044 ADCSRA|=0x40;
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 0045 // Wait for the AD conversion to complete
; 0000 0046 while ((ADCSRA & 0x10)==0);
_0x3:
	CALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 0047 ADCSRA|=0x10;
	CALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 0048 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0049 }
;
;void batt_zarqd(void)
; 0000 004C     {
_batt_zarqd:
; 0000 004D     unsigned int temp;
; 0000 004E     temp=read_adc(0);
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R16,R30
	CLR  R17
; 0000 004F     batt_celoe=temp/10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STS  _batt_celoe,R30
	STS  _batt_celoe+1,R31
; 0000 0050     batt_drob=temp%10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	STS  _batt_drob,R30
	STS  _batt_drob+1,R31
; 0000 0051     }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void kn_klava(void)
; 0000 0054     {
_kn_klava:
; 0000 0055     kn1=0;
	CLT
	BLD  R2,0
; 0000 0056     kn2=0;
	BLD  R2,1
; 0000 0057     kn3=0;
	BLD  R2,2
; 0000 0058     kn4=0;
	BLD  R2,3
; 0000 0059     kn5=0;
	BLD  R2,4
; 0000 005A     kn6=0;
	BLD  R2,5
; 0000 005B     DDRD.2=1;
	SBI  0x11,2
; 0000 005C     PORTD.2=0;
	CBI  0x12,2
; 0000 005D     delay_ms (1);
	CALL SUBOPT_0x2
; 0000 005E     if (PIND.3==0 && PIND.4==0) kn1=1;
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
; 0000 005F     if (PIND.3==1 && PIND.4==0) kn2=1;
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
; 0000 0060     DDRD.2=0;
_0xD:
	CBI  0x11,2
; 0000 0061     DDRD.3=1;
	SBI  0x11,3
; 0000 0062     PORTD.2=1;
	SBI  0x12,2
; 0000 0063     PORTD.3=0;
	CBI  0x12,3
; 0000 0064     delay_ms (1);
	CALL SUBOPT_0x2
; 0000 0065     if (PIND.2==1 && PIND.4==0) kn3=1;
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
; 0000 0066     if (PIND.2==0 && PIND.4==0) kn4=1;
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
; 0000 0067     DDRD.3=0;
_0x1B:
	CBI  0x11,3
; 0000 0068     DDRD.4=1;
	SBI  0x11,4
; 0000 0069     PORTD.3=1;
	SBI  0x12,3
; 0000 006A     PORTD.4=0;
	CBI  0x12,4
; 0000 006B     delay_ms (1);
	CALL SUBOPT_0x2
; 0000 006C     if (PIND.2==1 && PIND.3==0) kn5=1;
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
; 0000 006D     if (PIND.2==0 && PIND.3==1) kn6=1;
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
; 0000 006E     DDRD.4=0;
_0x29:
	CBI  0x11,4
; 0000 006F     PORTD.4=1;
	SBI  0x12,4
; 0000 0070     }
	RET
;
;void lcd_disp(void)
; 0000 0073     {
_lcd_disp:
; 0000 0074     if (menu==1)
	CALL SUBOPT_0x4
	BREQ PC+3
	JMP _0x30
; 0000 0075         {
; 0000 0076         light=1;
	CALL SUBOPT_0x5
; 0000 0077 
; 0000 0078         lcd_gotoxy (0,0);
; 0000 0079         sprintf (string_LCD_1, "%d.%dV V=%d B=%d   ", batt_celoe, batt_drob, vol, bar);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_batt_celoe
	LDS  R31,_batt_celoe+1
	CALL SUBOPT_0x6
	LDS  R30,_batt_drob
	LDS  R31,_batt_drob+1
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 007A         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x9
; 0000 007B 
; 0000 007C         lcd_gotoxy (0,1);
; 0000 007D         sprintf (string_LCD_2, "%x %x =Z", X, Y);
	__POINTW1FN _0x0,20
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 007E         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 007F 
; 0000 0080         lcd_gotoxy (8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xE
; 0000 0081         if (mod_gnd == 1)   sprintf (string_LCD_2, "+G");
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x33
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,29
	RJMP _0x11D
; 0000 0082         else                    sprintf (string_LCD_2, "  ");
_0x33:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,17
_0x11D:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 0083         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 0084 
; 0000 0085         lcd_gotoxy (10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0xE
; 0000 0086         if (mod_rock == 1)   sprintf (string_LCD_2, "+R");
	CALL SUBOPT_0x10
	BRNE _0x35
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,32
	RJMP _0x11E
; 0000 0087         else                    sprintf (string_LCD_2, "  ");
_0x35:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,17
_0x11E:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 0088         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 0089 
; 0000 008A         lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xE
; 0000 008B         if (mod_all_met == 1)   sprintf (string_LCD_2, "+All");
	LDI  R26,0
	SBRC R3,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x37
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,35
	RJMP _0x11F
; 0000 008C         else                    sprintf (string_LCD_2, "-Fe ");
_0x37:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,40
_0x11F:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xF
; 0000 008D         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 008E 
; 0000 008F         return;
; 0000 0090         };
_0x30:
; 0000 0091 
; 0000 0092     if (kn2==1)
	CALL SUBOPT_0x11
	BRNE _0x39
; 0000 0093         {
; 0000 0094         light=1;
	SBI  0x12,6
; 0000 0095         lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
; 0000 0096         sprintf (string_LCD_2, "Volume %d        ", vol);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,45
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	CALL SUBOPT_0x12
; 0000 0097         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 0098         return;
; 0000 0099         };
_0x39:
; 0000 009A 
; 0000 009B     if (kn3==1)
	CALL SUBOPT_0x13
	BRNE _0x3C
; 0000 009C         {
; 0000 009D         light=1;
	SBI  0x12,6
; 0000 009E         lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
; 0000 009F         sprintf (string_LCD_2, "Barrier %d       ", bar);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,63
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x12
; 0000 00A0         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00A1         return;
; 0000 00A2         };
_0x3C:
; 0000 00A3 
; 0000 00A4     if (kn4==1)
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x3F
; 0000 00A5         {
; 0000 00A6         light=1;
	CALL SUBOPT_0x5
; 0000 00A7         lcd_gotoxy (0,0);
; 0000 00A8         sprintf (string_LCD_1, ">>>>> Rock <<<<<", bar);
	__POINTW1FN _0x0,81
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x12
; 0000 00A9         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x9
; 0000 00AA         lcd_gotoxy (0,1);
; 0000 00AB         sprintf (string_LCD_2, "%f %f", rock_ampl, rock_faza);
	__POINTW1FN _0x0,98
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	CALL SUBOPT_0xC
; 0000 00AC         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00AD         return;
; 0000 00AE         };
_0x3F:
; 0000 00AF 
; 0000 00B0     if (kn5==1)
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x42
; 0000 00B1         {
; 0000 00B2         light=1;
	CALL SUBOPT_0x5
; 0000 00B3         lcd_gotoxy (0,0);
; 0000 00B4         sprintf (string_LCD_1, ">>>> Ground <<<<");
	__POINTW1FN _0x0,104
	CALL SUBOPT_0x16
; 0000 00B5         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x9
; 0000 00B6         lcd_gotoxy (0,1);
; 0000 00B7         sprintf (string_LCD_2, "%f %f ", gnd_ampl, gnd_faza);
	__POINTW1FN _0x0,121
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0xC
; 0000 00B8         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00B9         return;
; 0000 00BA         };
_0x42:
; 0000 00BB     if (kn6==1)
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x45
; 0000 00BC         {
; 0000 00BD         light=1;
	CALL SUBOPT_0x5
; 0000 00BE         lcd_gotoxy (0,0);
; 0000 00BF         sprintf (string_LCD_1, ">>>>> Zero <<<<<");
	__POINTW1FN _0x0,128
	CALL SUBOPT_0x16
; 0000 00C0         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x9
; 0000 00C1         lcd_gotoxy (0,1);
; 0000 00C2         sprintf (string_LCD_2, "%x %x %x %x ", zero_Y, zero_X, Y, X);
	__POINTW1FN _0x0,145
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL SUBOPT_0x6
	MOVW R30,R6
	CALL SUBOPT_0x6
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00C3         lcd_puts (string_LCD_2);
	RJMP _0x20C0007
; 0000 00C4         return;
; 0000 00C5         };
_0x45:
; 0000 00C6     lcd_gotoxy (0,0);
	CALL SUBOPT_0x19
; 0000 00C7     if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
	TST  R13
	BRNE _0x48
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,158
	CALL SUBOPT_0x16
; 0000 00C8     if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");
_0x48:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x49
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,175
	CALL SUBOPT_0x16
; 0000 00C9     if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
_0x49:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x4A
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,192
	CALL SUBOPT_0x16
; 0000 00CA     if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x4A:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x4B
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,209
	CALL SUBOPT_0x16
; 0000 00CB     if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x4B:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x4C
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x16
; 0000 00CC     if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x4C:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x4D
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x16
; 0000 00CD     if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x4D:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x4E
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,260
	CALL SUBOPT_0x16
; 0000 00CE     if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x4E:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x4F
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,277
	CALL SUBOPT_0x16
; 0000 00CF     if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x4F:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x50
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,294
	CALL SUBOPT_0x16
; 0000 00D0     if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x50:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0x51
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,311
	CALL SUBOPT_0x16
; 0000 00D1     if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x51:
	LDI  R30,LOW(10)
	CP   R30,R13
	BRNE _0x52
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,328
	CALL SUBOPT_0x16
; 0000 00D2     if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x52:
	LDI  R30,LOW(11)
	CP   R30,R13
	BRNE _0x53
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,345
	CALL SUBOPT_0x16
; 0000 00D3     if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x53:
	LDI  R30,LOW(12)
	CP   R30,R13
	BRNE _0x54
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,362
	CALL SUBOPT_0x16
; 0000 00D4     if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x54:
	LDI  R30,LOW(13)
	CP   R30,R13
	BRNE _0x55
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,379
	CALL SUBOPT_0x16
; 0000 00D5     if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x55:
	LDI  R30,LOW(14)
	CP   R30,R13
	BRNE _0x56
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,396
	CALL SUBOPT_0x16
; 0000 00D6     if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x56:
	LDI  R30,LOW(15)
	CP   R30,R13
	BRNE _0x57
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,413
	CALL SUBOPT_0x16
; 0000 00D7     if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x57:
	LDI  R30,LOW(16)
	CP   R30,R13
	BRNE _0x58
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,430
	CALL SUBOPT_0x16
; 0000 00D8     if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x58:
	LDI  R30,LOW(17)
	CP   R30,R13
	BRNE _0x59
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,447
	CALL SUBOPT_0x16
; 0000 00D9     if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x59:
	LDI  R30,LOW(18)
	CP   R30,R13
	BRNE _0x5A
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,464
	CALL SUBOPT_0x16
; 0000 00DA     if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x5A:
	LDI  R30,LOW(19)
	CP   R30,R13
	BRNE _0x5B
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,481
	CALL SUBOPT_0x16
; 0000 00DB     if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x5B:
	LDI  R30,LOW(20)
	CP   R30,R13
	BRNE _0x5C
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x16
; 0000 00DC     if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x5C:
	LDI  R30,LOW(21)
	CP   R30,R13
	BRNE _0x5D
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,515
	CALL SUBOPT_0x16
; 0000 00DD     if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x5D:
	LDI  R30,LOW(22)
	CP   R30,R13
	BRNE _0x5E
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,532
	CALL SUBOPT_0x16
; 0000 00DE     if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x5E:
	LDI  R30,LOW(23)
	CP   R30,R13
	BRNE _0x5F
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,549
	CALL SUBOPT_0x16
; 0000 00DF     if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x5F:
	LDI  R30,LOW(24)
	CP   R30,R13
	BRNE _0x60
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,566
	CALL SUBOPT_0x16
; 0000 00E0     if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x60:
	LDI  R30,LOW(25)
	CP   R30,R13
	BRNE _0x61
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,583
	CALL SUBOPT_0x16
; 0000 00E1     if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x61:
	LDI  R30,LOW(26)
	CP   R30,R13
	BRNE _0x62
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,600
	CALL SUBOPT_0x16
; 0000 00E2     if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x62:
	LDI  R30,LOW(27)
	CP   R30,R13
	BRNE _0x63
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,617
	CALL SUBOPT_0x16
; 0000 00E3     if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x63:
	LDI  R30,LOW(28)
	CP   R30,R13
	BRNE _0x64
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,634
	CALL SUBOPT_0x16
; 0000 00E4     if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x64:
	LDI  R30,LOW(29)
	CP   R30,R13
	BRNE _0x65
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,651
	CALL SUBOPT_0x16
; 0000 00E5     if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x65:
	LDI  R30,LOW(30)
	CP   R30,R13
	BRNE _0x66
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,668
	CALL SUBOPT_0x16
; 0000 00E6     if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x66:
	LDI  R30,LOW(31)
	CP   R30,R13
	BRNE _0x67
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,685
	CALL SUBOPT_0x16
; 0000 00E7     if (viz_ampl==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x67:
	LDI  R30,LOW(32)
	CP   R30,R13
	BRNE _0x68
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,702
	CALL SUBOPT_0x16
; 0000 00E8     lcd_puts (string_LCD_1);
_0x68:
	CALL SUBOPT_0x1A
	CALL _lcd_puts
; 0000 00E9     lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
; 0000 00EA     if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
	TST  R12
	BRNE _0x69
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,719
	CALL SUBOPT_0x16
; 0000 00EB     if (viz_faza==1)  sprintf (string_LCD_2, "Û------#I------Ü");
_0x69:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x6A
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,736
	CALL SUBOPT_0x16
; 0000 00EC     if (viz_faza==2)  sprintf (string_LCD_2, "Û-----#II------Ü");
_0x6A:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x6B
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,753
	CALL SUBOPT_0x16
; 0000 00ED     if (viz_faza==3)  sprintf (string_LCD_2, "Û----#-II------Ü");
_0x6B:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x6C
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x16
; 0000 00EE     if (viz_faza==4)  sprintf (string_LCD_2, "Û---#--II------Ü");
_0x6C:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x6D
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,787
	CALL SUBOPT_0x16
; 0000 00EF     if (viz_faza==5)  sprintf (string_LCD_2, "Û--#---II------Ü");
_0x6D:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x6E
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,804
	CALL SUBOPT_0x16
; 0000 00F0     if (viz_faza==6)  sprintf (string_LCD_2, "Û-#----II------Ü");
_0x6E:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x6F
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,821
	CALL SUBOPT_0x16
; 0000 00F1     if (viz_faza==7)  sprintf (string_LCD_2, "Û#-----II------Ü");
_0x6F:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x70
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,838
	CALL SUBOPT_0x16
; 0000 00F2     if (viz_faza==8)  sprintf (string_LCD_2, ">_<----II------Ü");
_0x70:
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x71
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,855
	CALL SUBOPT_0x16
; 0000 00F3     if (viz_faza==9)  sprintf (string_LCD_2, "Û------I#------Ü");
_0x71:
	LDI  R30,LOW(9)
	CP   R30,R12
	BRNE _0x72
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,872
	CALL SUBOPT_0x16
; 0000 00F4     if (viz_faza==10) sprintf (string_LCD_2, "Û------II#-----Ü");
_0x72:
	LDI  R30,LOW(10)
	CP   R30,R12
	BRNE _0x73
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,889
	CALL SUBOPT_0x16
; 0000 00F5     if (viz_faza==11) sprintf (string_LCD_2, "Û------II-#----Ü");
_0x73:
	LDI  R30,LOW(11)
	CP   R30,R12
	BRNE _0x74
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,906
	CALL SUBOPT_0x16
; 0000 00F6     if (viz_faza==12) sprintf (string_LCD_2, "Û------II--#---Ü");
_0x74:
	LDI  R30,LOW(12)
	CP   R30,R12
	BRNE _0x75
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,923
	CALL SUBOPT_0x16
; 0000 00F7     if (viz_faza==13) sprintf (string_LCD_2, "Û------II---#--Ü");
_0x75:
	LDI  R30,LOW(13)
	CP   R30,R12
	BRNE _0x76
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,940
	CALL SUBOPT_0x16
; 0000 00F8     if (viz_faza==14) sprintf (string_LCD_2, "Û------II----#-Ü");
_0x76:
	LDI  R30,LOW(14)
	CP   R30,R12
	BRNE _0x77
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,957
	CALL SUBOPT_0x16
; 0000 00F9     if (viz_faza==15) sprintf (string_LCD_2, "Û------II-----#Ü");
_0x77:
	LDI  R30,LOW(15)
	CP   R30,R12
	BRNE _0x78
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,974
	CALL SUBOPT_0x16
; 0000 00FA     if (viz_faza==16) sprintf (string_LCD_2, "Û------II----o_O");
_0x78:
	LDI  R30,LOW(16)
	CP   R30,R12
	BRNE _0x79
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,991
	CALL SUBOPT_0x16
; 0000 00FB     lcd_puts (string_LCD_2);
_0x79:
_0x20C0007:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00FC     }
	RET
;
;void zvuk ()
; 0000 00FF     {
_zvuk:
; 0000 0100     UDR = X;
	OUT  0xC,R11
; 0000 0101     }
	RET
;
;void new_X_Y (void)
; 0000 0104     {
_new_X_Y:
; 0000 0105       unsigned char adres = 0x89;
; 0000 0106       i2c_start();
	ST   -Y,R17
;	adres -> R17
	LDI  R17,137
	CALL _i2c_start
; 0000 0107       delay_us (20);
	__DELAY_USB 109
; 0000 0108       i2c_write(adres);
	ST   -Y,R17
	CALL _i2c_write
; 0000 0109       delay_us (20);
	__DELAY_USB 109
; 0000 010A       X = i2c_read(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R11,R30
; 0000 010B       delay_us (20);
	__DELAY_USB 109
; 0000 010C       Y = i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R10,R30
; 0000 010D       delay_us (20);
	__DELAY_USB 109
; 0000 010E       i2c_stop();
	CALL _i2c_stop
; 0000 010F     }
	LD   R17,Y+
	RET
;
;float vektor_ampl (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
; 0000 0112     {
_vektor_ampl:
; 0000 0113     long int YY, XX;
; 0000 0114     long unsigned int YX2;
; 0000 0115     float YX3;
; 0000 0116     if (Y_1 > Y_2) YY = Y_1 - Y_2;
	SBIW R28,16
;	Y_1 -> Y+22
;	X_1 -> Y+20
;	Y_2 -> Y+18
;	X_2 -> Y+16
;	YY -> Y+12
;	XX -> Y+8
;	YX2 -> Y+4
;	YX3 -> Y+0
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x7A
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RJMP _0x120
; 0000 0117     else YY = Y_2 - Y_1;
_0x7A:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
_0x120:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 12
; 0000 0118     if (X_1 > X_2) XX = X_1 - X_2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x7C
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RJMP _0x121
; 0000 0119     else XX = X_2 - X_1;
_0x7C:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
_0x121:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 8
; 0000 011A     YX2  = YY*YY + XX*XX;
	CALL SUBOPT_0x1B
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 8
	CALL SUBOPT_0x1C
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0x1D
; 0000 011B     YX3 = sqrt (YX2);
	CALL __CDF1U
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0000 011C     return YX3;
	CALL SUBOPT_0x20
	RJMP _0x20C0006
; 0000 011D     }
;
;
;float vektor_faza (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
; 0000 0121     {
_vektor_faza:
; 0000 0122     signed int YY, XX;
; 0000 0123     float YX2;
; 0000 0124     YY = Y_1 - Y_2;
	SBIW R28,4
	CALL __SAVELOCR4
;	Y_1 -> Y+14
;	X_1 -> Y+12
;	Y_2 -> Y+10
;	X_2 -> Y+8
;	YY -> R16,R17
;	XX -> R18,R19
;	YX2 -> Y+4
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0125     XX = X_1 - X_2;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0000 0126     YX2 = atan2 (YY,XX);
	MOVW R30,R16
	CALL SUBOPT_0x21
	MOVW R30,R18
	CALL SUBOPT_0x21
	CALL _atan2
	CALL SUBOPT_0x1D
; 0000 0127     return YX2;
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; 0000 0128     }
;
;float th_cos (float a, float aa_x, float b, float bb_x)
; 0000 012B     {
_th_cos:
; 0000 012C     float c;
; 0000 012D     float aabb;
; 0000 012E     aabb = aa_x - bb_x;
	SBIW R28,8
;	a -> Y+20
;	aa_x -> Y+16
;	b -> Y+12
;	bb_x -> Y+8
;	c -> Y+4
;	aabb -> Y+0
	CALL SUBOPT_0x1C
	__GETD1S 16
	CALL __SUBF12
	CALL SUBOPT_0x1F
; 0000 012F     c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
	__GETD1S 20
	__GETD2S 20
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1B
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
	CALL __MULF12
	__GETD2S 12
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
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1D
; 0000 0130     return c;
_0x20C0006:
	ADIW R28,24
	RET
; 0000 0131     }
;
;float th_sin (float c, int b_y, int b_x, int c_y, int c_x)
; 0000 0134     {
_th_sin:
; 0000 0135     int ab;
; 0000 0136     float temp;
; 0000 0137     if (b_y > c_y) ab = b_y - c_y;
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
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x7E
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RJMP _0x122
; 0000 0138     else ab = c_y - b_y;
_0x7E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x122:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0139     temp = asin (ab/c);
	__GETD1S 14
	MOVW R26,R16
	CALL __CWD2
	CALL __CDF2
	CALL SUBOPT_0x24
	CALL _asin
	__PUTD1S 2
; 0000 013A     if (c_x > b_x) temp = 3.141593 - temp;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x80
	__GETD2S 2
	__GETD1N 0x40490FDC
	CALL __SUBF12
	__PUTD1S 2
; 0000 013B     return temp;
_0x80:
	__GETD1S 2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
; 0000 013C     }
;
;void main_menu(void)
; 0000 013F     {
_main_menu:
; 0000 0140     menu++;
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 0141     while (kn1==1)
_0x81:
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x83
; 0000 0142         {
; 0000 0143         kn_klava();
	CALL SUBOPT_0x25
; 0000 0144         lcd_disp();
; 0000 0145         };
	RJMP _0x81
_0x83:
; 0000 0146     }
	RET
;
;void volume(void)
; 0000 0149     {
_volume:
; 0000 014A     vol++;
	INC  R9
; 0000 014B     if (vol==10) vol=0;
	LDI  R30,LOW(10)
	CP   R30,R9
	BRNE _0x84
	CLR  R9
; 0000 014C     while (kn2==1)
_0x84:
_0x85:
	CALL SUBOPT_0x11
	BRNE _0x87
; 0000 014D         {
; 0000 014E         kn_klava();
	CALL SUBOPT_0x25
; 0000 014F         lcd_disp();
; 0000 0150         };
	RJMP _0x85
_0x87:
; 0000 0151     }
	RET
;
;void barrier(void)
; 0000 0154     {
_barrier:
; 0000 0155     bar++;
	INC  R8
; 0000 0156     if (bar==10) bar=0;
	LDI  R30,LOW(10)
	CP   R30,R8
	BRNE _0x88
	CLR  R8
; 0000 0157     bar_rad = (float) bar*0.174532925;
_0x88:
	MOV  R30,R8
	CALL __CBD1
	CALL __CDF1
	__GETD2N 0x3E32B8C2
	CALL __MULF12
	STS  _bar_rad,R30
	STS  _bar_rad+1,R31
	STS  _bar_rad+2,R22
	STS  _bar_rad+3,R23
; 0000 0158     while (kn3==1)
_0x89:
	CALL SUBOPT_0x13
	BRNE _0x8B
; 0000 0159         {
; 0000 015A         kn_klava();
	CALL SUBOPT_0x25
; 0000 015B         lcd_disp();
; 0000 015C         };
	RJMP _0x89
_0x8B:
; 0000 015D     }
	RET
;
;void rock(void)
; 0000 0160     {
_rock:
; 0000 0161     if (menu==1) mod_rock++;
	CALL SUBOPT_0x4
	BRNE _0x8C
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 0162     rock_ampl_max = vektor_ampl(Y, X, zero_Y, zero_X);
_0x8C:
	CALL SUBOPT_0x26
	RCALL _vektor_ampl
	STS  _rock_ampl_max,R30
	STS  _rock_ampl_max+1,R31
	STS  _rock_ampl_max+2,R22
	STS  _rock_ampl_max+3,R23
; 0000 0163     rock_faza_max = vektor_faza(Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x26
	RCALL _vektor_faza
	STS  _rock_faza_max,R30
	STS  _rock_faza_max+1,R31
	STS  _rock_faza_max+2,R22
	STS  _rock_faza_max+3,R23
; 0000 0164     }
	RET
;
;void ground(void)
; 0000 0167     {
_ground:
; 0000 0168     if (menu==1) mod_gnd++;
	CALL SUBOPT_0x4
	BRNE _0x8D
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0169     gnd_ampl_max = vektor_ampl(Y, X, zero_Y, zero_X);
_0x8D:
	CALL SUBOPT_0x26
	RCALL _vektor_ampl
	STS  _gnd_ampl_max,R30
	STS  _gnd_ampl_max+1,R31
	STS  _gnd_ampl_max+2,R22
	STS  _gnd_ampl_max+3,R23
; 0000 016A     gnd_faza_max = vektor_faza(Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x26
	RCALL _vektor_faza
	STS  _gnd_faza_max,R30
	STS  _gnd_faza_max+1,R31
	STS  _gnd_faza_max+2,R22
	STS  _gnd_faza_max+3,R23
; 0000 016B     }
	RET
;
;void zero(void)
; 0000 016E     {
_zero:
; 0000 016F     if (menu==1) mod_all_met++;
	CALL SUBOPT_0x4
	BRNE _0x8E
	LDI  R30,LOW(2)
	EOR  R3,R30
; 0000 0170     zero_Y=0;
_0x8E:
	CLR  R4
	CLR  R5
; 0000 0171     zero_X=X;
	MOV  R6,R11
	CLR  R7
; 0000 0172 //    zero_ampl=ampl;
; 0000 0173 //    zero_faza=faza;
; 0000 0174     }
	RET
;
;void main(void)
; 0000 0177 {
_main:
; 0000 0178 // Declare your local variables here
; 0000 0179 
; 0000 017A // Input/Output Ports initialization
; 0000 017B // Port A initialization
; 0000 017C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 017D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 017E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 017F DDRA=0x00;
	OUT  0x1A,R30
; 0000 0180 
; 0000 0181 // Port B initialization
; 0000 0182 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0183 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0184 PORTB=0x00;
	OUT  0x18,R30
; 0000 0185 DDRB=0x00;
	OUT  0x17,R30
; 0000 0186 
; 0000 0187 // Port C initialization
; 0000 0188 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0189 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 018A PORTC=0x00;
	OUT  0x15,R30
; 0000 018B DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 018C 
; 0000 018D // Port D initialization
; 0000 018E // Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 018F // State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=0
; 0000 0190 PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 0191 DDRD=0xA3;
	LDI  R30,LOW(163)
	OUT  0x11,R30
; 0000 0192 
; 0000 0193 // ADC initialization
; 0000 0194 // ADC Clock frequency: 1000,000 kHz
; 0000 0195 // ADC Voltage Reference: AREF pin
; 0000 0196 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0197 ADCSRA=0x83;
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 0198 
; 0000 0199 // Timer/Counter 0 initialization
; 0000 019A // Clock source: System Clock
; 0000 019B // Clock value: Timer 0 Stopped
; 0000 019C // Mode: Normal top=FFh
; 0000 019D // OC0 output: Disconnected
; 0000 019E TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 019F TCNT0=0x00;
	OUT  0x32,R30
; 0000 01A0 OCR0=0x00;
	OUT  0x3C,R30
; 0000 01A1 
; 0000 01A2 // Timer/Counter 1 initialization
; 0000 01A3 // Clock source: System Clock
; 0000 01A4 // Clock value: Timer 1 Stopped
; 0000 01A5 // Mode: Normal top=FFFFh
; 0000 01A6 // OC1A output: Discon.
; 0000 01A7 // OC1B output: Discon.
; 0000 01A8 // Noise Canceler: Off
; 0000 01A9 // Input Capture on Falling Edge
; 0000 01AA // Timer 1 Overflow Interrupt: Off
; 0000 01AB // Input Capture Interrupt: Off
; 0000 01AC // Compare A Match Interrupt: Off
; 0000 01AD // Compare B Match Interrupt: Off
; 0000 01AE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01AF TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01B0 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01B1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01B2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01B3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01B4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01B5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01B6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01B7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01B8 
; 0000 01B9 // Timer/Counter 2 initialization
; 0000 01BA // Clock source: System Clock
; 0000 01BB // Clock value: Timer 2 Stopped
; 0000 01BC // Mode: Normal top=FFh
; 0000 01BD // OC2 output: Disconnected
; 0000 01BE ASSR=0x00;
	OUT  0x22,R30
; 0000 01BF TCCR2=0x00;
	OUT  0x25,R30
; 0000 01C0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 01C1 OCR2=0x00;
	OUT  0x23,R30
; 0000 01C2 
; 0000 01C3 // External Interrupt(s) initialization
; 0000 01C4 // INT0: Off
; 0000 01C5 // INT1: Off
; 0000 01C6 // INT2: Off
; 0000 01C7 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01C8 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01C9 
; 0000 01CA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01CB TIMSK=0x00;
	OUT  0x39,R30
; 0000 01CC 
; 0000 01CD // Analog Comparator initialization
; 0000 01CE // Analog Comparator: Off
; 0000 01CF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01D0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01D1 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01D2 
; 0000 01D3 // USART initialization
; 0000 01D4 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01D5 // USART Receiver: Off
; 0000 01D6 // USART Transmitter: On
; 0000 01D7 // USART Mode: Asynchronous
; 0000 01D8 // USART Baud Rate: 115200
; 0000 01D9 UCSRA=0x00;
	OUT  0xB,R30
; 0000 01DA UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 01DB UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01DC UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01DD UBRRL=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 01DE 
; 0000 01DF // LCD module initialization
; 0000 01E0 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01E1 // I2C Bus initialization
; 0000 01E2 i2c_init();
	CALL _i2c_init
; 0000 01E3 
; 0000 01E4 lcd_gotoxy (0,0);
	CALL SUBOPT_0x19
; 0000 01E5 sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
	CALL SUBOPT_0x1A
	__POINTW1FN _0x0,1008
	CALL SUBOPT_0x16
; 0000 01E6 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x9
; 0000 01E7 lcd_gotoxy (0,1);
; 0000 01E8 sprintf (string_LCD_2, "v1.5 ^_^ md4u.ru");
	__POINTW1FN _0x0,1025
	CALL SUBOPT_0x16
; 0000 01E9 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 01EA delay_ms (4000);
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01EB 
; 0000 01EC while (1)
_0x8F:
; 0000 01ED       {
; 0000 01EE       // Place your code here
; 0000 01EF 
; 0000 01F0       #asm("wdr")
	wdr
; 0000 01F1       new_X_Y ();
	RCALL _new_X_Y
; 0000 01F2       kn_klava();
	RCALL _kn_klava
; 0000 01F3 
; 0000 01F4       if (kn1==1) main_menu();
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x92
	RCALL _main_menu
; 0000 01F5       if (kn2==1) volume();
_0x92:
	CALL SUBOPT_0x11
	BRNE _0x93
	RCALL _volume
; 0000 01F6       if (kn3==1) barrier();
_0x93:
	CALL SUBOPT_0x13
	BRNE _0x94
	RCALL _barrier
; 0000 01F7       if (kn4==1) rock();
_0x94:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x95
	RCALL _rock
; 0000 01F8       if (kn5==1) ground();
_0x95:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x96
	RCALL _ground
; 0000 01F9       if (kn6==1) zero();
_0x96:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x97
	RCALL _zero
; 0000 01FA 
; 0000 01FB       now_ampl = vektor_ampl (Y, X, zero_Y, zero_X);
_0x97:
	CALL SUBOPT_0x26
	RCALL _vektor_ampl
	CALL SUBOPT_0x27
; 0000 01FC       now_faza = vektor_faza (Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x26
	RCALL _vektor_faza
	CALL SUBOPT_0x28
; 0000 01FD 
; 0000 01FE       if (mod_gnd || mod_rock == 1)
	SBRC R2,7
	RJMP _0x99
	CALL SUBOPT_0x10
	BREQ _0x99
	RJMP _0x98
_0x99:
; 0000 01FF         {
; 0000 0200         if ((now_faza <= gnd_faza_max + bar_rad + 0.005 ) && (now_faza >= gnd_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	BREQ PC+4
	BRCS PC+3
	JMP  _0x9C
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BRSH _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 0201             {
; 0000 0202             if ((now_ampl * 0.99 <= gnd_ampl ) && (now_ampl * 1.01 >= gnd_ampl))
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x9F
	CALL SUBOPT_0x2F
	BRSH _0xA0
_0x9F:
	RJMP _0x9E
_0xA0:
; 0000 0203                 {
; 0000 0204                 gnd_ampl = now_ampl;
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 0205                 gnd_faza = now_faza;
; 0000 0206                 };
_0x9E:
; 0000 0207             };
_0x9B:
; 0000 0208         now_ampl = th_cos (now_ampl, now_faza, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	RCALL _th_cos
	CALL SUBOPT_0x27
; 0000 0209         now_faza = th_sin (temp_ampl, Y, X, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x17
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	RCALL _th_sin
	CALL SUBOPT_0x28
; 0000 020A         if ((now_faza <= rock_faza_max + bar_rad + 0.005 ) && (now_faza >= rock_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x37
	BREQ PC+4
	BRCS PC+3
	JMP  _0xA2
	CALL SUBOPT_0x38
	BRSH _0xA3
_0xA2:
	RJMP _0xA1
_0xA3:
; 0000 020B             {
; 0000 020C             if ((now_ampl * 0.95 <= rock_ampl ) && (now_ampl * 1.05 >= rock_ampl))
	CALL SUBOPT_0x39
	BREQ PC+4
	BRCS PC+3
	JMP  _0xA5
	CALL SUBOPT_0x3A
	BRSH _0xA6
_0xA5:
	RJMP _0xA4
_0xA6:
; 0000 020D                 {
; 0000 020E                 rock_ampl = now_ampl;
	CALL SUBOPT_0x3B
; 0000 020F                 rock_faza = now_faza;
; 0000 0210                 };
_0xA4:
; 0000 0211             };
_0xA1:
; 0000 0212         temp_ampl = th_cos (now_ampl, now_faza, rock_ampl, rock_faza);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0000 0213         temp_faza = th_sin (temp_ampl, Y, X, rock_ampl, rock_faza);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3E
	RCALL _th_sin
	RJMP _0x123
; 0000 0214         }
; 0000 0215 
; 0000 0216       else if (mod_gnd == 1)
_0x98:
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xA8
; 0000 0217         {
; 0000 0218         if ((now_faza <= gnd_faza_max + bar_rad + 0.005 ) && (now_faza >= gnd_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	BREQ PC+4
	BRCS PC+3
	JMP  _0xAA
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BRSH _0xAB
_0xAA:
	RJMP _0xA9
_0xAB:
; 0000 0219             {
; 0000 021A             if ((now_ampl * 0.99 <= gnd_ampl ) && (now_ampl * 1.01 >= gnd_ampl))
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	BREQ PC+4
	BRCS PC+3
	JMP  _0xAD
	CALL SUBOPT_0x2F
	BRSH _0xAE
_0xAD:
	RJMP _0xAC
_0xAE:
; 0000 021B                 {
; 0000 021C                 gnd_ampl = now_ampl;
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
; 0000 021D                 gnd_faza = now_faza;
; 0000 021E                 };
_0xAC:
; 0000 021F             };
_0xA9:
; 0000 0220         temp_ampl = th_cos (now_ampl, now_faza, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	CALL SUBOPT_0x3D
; 0000 0221         temp_faza = th_sin (temp_ampl, Y, X, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x17
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	RCALL _th_sin
	RJMP _0x123
; 0000 0222         }
; 0000 0223 
; 0000 0224       else if (mod_rock == 1)
_0xA8:
	CALL SUBOPT_0x10
	BRNE _0xB0
; 0000 0225         {
; 0000 0226         if ((now_faza <= rock_faza_max + bar_rad + 0.005 ) && (now_faza >= rock_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x37
	BREQ PC+4
	BRCS PC+3
	JMP  _0xB2
	CALL SUBOPT_0x38
	BRSH _0xB3
_0xB2:
	RJMP _0xB1
_0xB3:
; 0000 0227             {
; 0000 0228             if ((now_ampl * 0.95 <= rock_ampl ) && (now_ampl * 1.05 >= rock_ampl))
	CALL SUBOPT_0x39
	BREQ PC+4
	BRCS PC+3
	JMP  _0xB5
	CALL SUBOPT_0x3A
	BRSH _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
; 0000 0229                 {
; 0000 022A                 rock_ampl = now_ampl;
	CALL SUBOPT_0x3B
; 0000 022B                 rock_faza = now_faza;
; 0000 022C                 };
_0xB4:
; 0000 022D             };
_0xB1:
; 0000 022E         temp_ampl = th_cos (now_ampl, now_faza, rock_ampl, rock_faza);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
; 0000 022F         temp_faza = th_sin (temp_ampl, Y, X, rock_ampl, rock_faza);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3E
	RCALL _th_sin
	RJMP _0x123
; 0000 0230         }
; 0000 0231 
; 0000 0232       else
_0xB0:
; 0000 0233         {
; 0000 0234         temp_ampl = now_ampl;
	CALL SUBOPT_0x30
	STS  _temp_ampl,R30
	STS  _temp_ampl+1,R31
	STS  _temp_ampl+2,R22
	STS  _temp_ampl+3,R23
; 0000 0235         temp_faza = now_faza;
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
_0x123:
	STS  _temp_faza,R30
	STS  _temp_faza+1,R31
	STS  _temp_faza+2,R22
	STS  _temp_faza+3,R23
; 0000 0236         };
; 0000 0237 
; 0000 0238       if (temp_ampl> 2079 )        viz_ampl=32;
	CALL SUBOPT_0x3F
	__GETD1N 0x4501F000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xB8
	LDI  R30,LOW(32)
	MOV  R13,R30
; 0000 0239       else if (temp_ampl> 2016 )   viz_ampl=31;
	RJMP _0xB9
_0xB8:
	CALL SUBOPT_0x3F
	__GETD1N 0x44FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xBA
	LDI  R30,LOW(31)
	MOV  R13,R30
; 0000 023A       else if (temp_ampl> 1953 )   viz_ampl=30;
	RJMP _0xBB
_0xBA:
	CALL SUBOPT_0x3F
	__GETD1N 0x44F42000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xBC
	LDI  R30,LOW(30)
	MOV  R13,R30
; 0000 023B       else if (temp_ampl> 1890 )   viz_ampl=29;
	RJMP _0xBD
_0xBC:
	CALL SUBOPT_0x3F
	__GETD1N 0x44EC4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xBE
	LDI  R30,LOW(29)
	MOV  R13,R30
; 0000 023C       else if (temp_ampl> 1827 )   viz_ampl=28;
	RJMP _0xBF
_0xBE:
	CALL SUBOPT_0x3F
	__GETD1N 0x44E46000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC0
	LDI  R30,LOW(28)
	MOV  R13,R30
; 0000 023D       else if (temp_ampl> 1764 )   viz_ampl=27;
	RJMP _0xC1
_0xC0:
	CALL SUBOPT_0x3F
	__GETD1N 0x44DC8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC2
	LDI  R30,LOW(27)
	MOV  R13,R30
; 0000 023E       else if (temp_ampl> 1701 )   viz_ampl=26;
	RJMP _0xC3
_0xC2:
	CALL SUBOPT_0x3F
	__GETD1N 0x44D4A000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC4
	LDI  R30,LOW(26)
	MOV  R13,R30
; 0000 023F       else if (temp_ampl> 1638 )   viz_ampl=25;
	RJMP _0xC5
_0xC4:
	CALL SUBOPT_0x3F
	__GETD1N 0x44CCC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC6
	LDI  R30,LOW(25)
	MOV  R13,R30
; 0000 0240       else if (temp_ampl> 1575 )   viz_ampl=24;
	RJMP _0xC7
_0xC6:
	CALL SUBOPT_0x3F
	__GETD1N 0x44C4E000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC8
	LDI  R30,LOW(24)
	MOV  R13,R30
; 0000 0241       else if (temp_ampl> 1512 )   viz_ampl=23;
	RJMP _0xC9
_0xC8:
	CALL SUBOPT_0x3F
	__GETD1N 0x44BD0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCA
	LDI  R30,LOW(23)
	MOV  R13,R30
; 0000 0242       else if (temp_ampl> 1449 )   viz_ampl=22;
	RJMP _0xCB
_0xCA:
	CALL SUBOPT_0x3F
	__GETD1N 0x44B52000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCC
	LDI  R30,LOW(22)
	MOV  R13,R30
; 0000 0243       else if (temp_ampl> 1386 )   viz_ampl=21;
	RJMP _0xCD
_0xCC:
	CALL SUBOPT_0x3F
	__GETD1N 0x44AD4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xCE
	LDI  R30,LOW(21)
	MOV  R13,R30
; 0000 0244       else if (temp_ampl> 1323 )   viz_ampl=20;
	RJMP _0xCF
_0xCE:
	CALL SUBOPT_0x3F
	__GETD1N 0x44A56000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD0
	LDI  R30,LOW(20)
	MOV  R13,R30
; 0000 0245       else if (temp_ampl> 1260 )   viz_ampl=19;
	RJMP _0xD1
_0xD0:
	CALL SUBOPT_0x3F
	__GETD1N 0x449D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD2
	LDI  R30,LOW(19)
	MOV  R13,R30
; 0000 0246       else if (temp_ampl> 1197 )   viz_ampl=18;
	RJMP _0xD3
_0xD2:
	CALL SUBOPT_0x3F
	__GETD1N 0x4495A000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD4
	LDI  R30,LOW(18)
	MOV  R13,R30
; 0000 0247       else if (temp_ampl> 1134 )   viz_ampl=17;
	RJMP _0xD5
_0xD4:
	CALL SUBOPT_0x3F
	__GETD1N 0x448DC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD6
	LDI  R30,LOW(17)
	MOV  R13,R30
; 0000 0248       else if (temp_ampl> 1071 )   viz_ampl=16;
	RJMP _0xD7
_0xD6:
	CALL SUBOPT_0x3F
	__GETD1N 0x4485E000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xD8
	LDI  R30,LOW(16)
	MOV  R13,R30
; 0000 0249       else if (temp_ampl> 1008 )   viz_ampl=15;
	RJMP _0xD9
_0xD8:
	CALL SUBOPT_0x3F
	__GETD1N 0x447C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDA
	LDI  R30,LOW(15)
	MOV  R13,R30
; 0000 024A       else if (temp_ampl> 945  )   viz_ampl=14;
	RJMP _0xDB
_0xDA:
	CALL SUBOPT_0x3F
	__GETD1N 0x446C4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDC
	LDI  R30,LOW(14)
	MOV  R13,R30
; 0000 024B       else if (temp_ampl> 882  )   viz_ampl=13;
	RJMP _0xDD
_0xDC:
	CALL SUBOPT_0x3F
	__GETD1N 0x445C8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDE
	LDI  R30,LOW(13)
	MOV  R13,R30
; 0000 024C       else if (temp_ampl> 819  )   viz_ampl=12;
	RJMP _0xDF
_0xDE:
	CALL SUBOPT_0x3F
	__GETD1N 0x444CC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE0
	LDI  R30,LOW(12)
	MOV  R13,R30
; 0000 024D       else if (temp_ampl> 756  )   viz_ampl=11;
	RJMP _0xE1
_0xE0:
	CALL SUBOPT_0x3F
	__GETD1N 0x443D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE2
	LDI  R30,LOW(11)
	MOV  R13,R30
; 0000 024E       else if (temp_ampl> 693  )   viz_ampl=10;
	RJMP _0xE3
_0xE2:
	CALL SUBOPT_0x3F
	__GETD1N 0x442D4000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE4
	LDI  R30,LOW(10)
	MOV  R13,R30
; 0000 024F       else if (temp_ampl> 630  )   viz_ampl=9;
	RJMP _0xE5
_0xE4:
	CALL SUBOPT_0x3F
	__GETD1N 0x441D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE6
	LDI  R30,LOW(9)
	MOV  R13,R30
; 0000 0250       else if (temp_ampl> 567  )   viz_ampl=8;
	RJMP _0xE7
_0xE6:
	CALL SUBOPT_0x3F
	__GETD1N 0x440DC000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE8
	LDI  R30,LOW(8)
	MOV  R13,R30
; 0000 0251       else if (temp_ampl> 504  )   viz_ampl=7;
	RJMP _0xE9
_0xE8:
	CALL SUBOPT_0x3F
	__GETD1N 0x43FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEA
	LDI  R30,LOW(7)
	MOV  R13,R30
; 0000 0252       else if (temp_ampl> 441  )   viz_ampl=6;
	RJMP _0xEB
_0xEA:
	CALL SUBOPT_0x3F
	__GETD1N 0x43DC8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEC
	LDI  R30,LOW(6)
	MOV  R13,R30
; 0000 0253       else if (temp_ampl> 378  )   viz_ampl=5;
	RJMP _0xED
_0xEC:
	CALL SUBOPT_0x3F
	__GETD1N 0x43BD0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEE
	LDI  R30,LOW(5)
	MOV  R13,R30
; 0000 0254       else if (temp_ampl> 315  )   viz_ampl=4;
	RJMP _0xEF
_0xEE:
	CALL SUBOPT_0x3F
	__GETD1N 0x439D8000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF0
	LDI  R30,LOW(4)
	MOV  R13,R30
; 0000 0255       else if (temp_ampl> 252  )   viz_ampl=3;
	RJMP _0xF1
_0xF0:
	CALL SUBOPT_0x3F
	__GETD1N 0x437C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF2
	LDI  R30,LOW(3)
	MOV  R13,R30
; 0000 0256       else if (temp_ampl> 189  )   viz_ampl=2;
	RJMP _0xF3
_0xF2:
	CALL SUBOPT_0x3F
	__GETD1N 0x433D0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF4
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 0257       else if (temp_ampl> 126  )   viz_ampl=1;
	RJMP _0xF5
_0xF4:
	CALL SUBOPT_0x3F
	__GETD1N 0x42FC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF6
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0258       else if (temp_ampl> 63   )   viz_ampl=0;
	RJMP _0xF7
_0xF6:
	CALL SUBOPT_0x3F
	__GETD1N 0x427C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF8
	CLR  R13
; 0000 0259 
; 0000 025A       if (temp_faza> 3.14) viz_faza=0;
_0xF8:
_0xF7:
_0xF5:
_0xF3:
_0xF1:
_0xEF:
_0xED:
_0xEB:
_0xE9:
_0xE7:
_0xE5:
_0xE3:
_0xE1:
_0xDF:
_0xDD:
_0xDB:
_0xD9:
_0xD7:
_0xD5:
_0xD3:
_0xD1:
_0xCF:
_0xCD:
_0xCB:
_0xC9:
_0xC7:
_0xC5:
_0xC3:
_0xC1:
_0xBF:
_0xBD:
_0xBB:
_0xB9:
	CALL SUBOPT_0x40
	__GETD1N 0x4048F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF9
	CLR  R12
; 0000 025B       else if (temp_faza> 2.944) viz_faza=8;
	RJMP _0xFA
_0xF9:
	CALL SUBOPT_0x40
	__GETD1N 0x403C6A7F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFB
	LDI  R30,LOW(8)
	RJMP _0x124
; 0000 025C       else if (temp_faza> 2.748) viz_faza=7;
_0xFB:
	CALL SUBOPT_0x40
	__GETD1N 0x402FDF3B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFD
	LDI  R30,LOW(7)
	RJMP _0x124
; 0000 025D       else if (temp_faza> 2.552) viz_faza=6;
_0xFD:
	CALL SUBOPT_0x40
	__GETD1N 0x402353F8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFF
	LDI  R30,LOW(6)
	RJMP _0x124
; 0000 025E       else if (temp_faza> 2.356) viz_faza=5;
_0xFF:
	CALL SUBOPT_0x40
	__GETD1N 0x4016C8B4
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x101
	LDI  R30,LOW(5)
	RJMP _0x124
; 0000 025F       else if (temp_faza> 2.160) viz_faza=4;
_0x101:
	CALL SUBOPT_0x40
	__GETD1N 0x400A3D71
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x103
	LDI  R30,LOW(4)
	RJMP _0x124
; 0000 0260       else if (temp_faza> 1.964) viz_faza=3;
_0x103:
	CALL SUBOPT_0x40
	__GETD1N 0x3FFB645A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x105
	LDI  R30,LOW(3)
	RJMP _0x124
; 0000 0261       else if (temp_faza> 1.768) viz_faza=2;
_0x105:
	CALL SUBOPT_0x40
	__GETD1N 0x3FE24DD3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x107
	LDI  R30,LOW(2)
	RJMP _0x124
; 0000 0262       else if (temp_faza> 1.572) viz_faza=1;
_0x107:
	CALL SUBOPT_0x40
	__GETD1N 0x3FC9374C
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x109
	LDI  R30,LOW(1)
	RJMP _0x124
; 0000 0263 
; 0000 0264       else if (temp_faza> 1.376) viz_faza=9;
_0x109:
	CALL SUBOPT_0x40
	__GETD1N 0x3FB020C5
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10B
	LDI  R30,LOW(9)
	RJMP _0x124
; 0000 0265       else if (temp_faza> 1.180) viz_faza=10;
_0x10B:
	CALL SUBOPT_0x40
	__GETD1N 0x3F970A3D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10D
	LDI  R30,LOW(10)
	RJMP _0x124
; 0000 0266       else if (temp_faza> 0.984) viz_faza=11;
_0x10D:
	CALL SUBOPT_0x40
	__GETD1N 0x3F7BE76D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10F
	LDI  R30,LOW(11)
	RJMP _0x124
; 0000 0267       else if (temp_faza> 0.788) viz_faza=12;
_0x10F:
	CALL SUBOPT_0x40
	__GETD1N 0x3F49BA5E
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x111
	LDI  R30,LOW(12)
	RJMP _0x124
; 0000 0268       else if (temp_faza> 0.592) viz_faza=13;
_0x111:
	CALL SUBOPT_0x40
	__GETD1N 0x3F178D50
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x113
	LDI  R30,LOW(13)
	RJMP _0x124
; 0000 0269       else if (temp_faza> 0.396) viz_faza=14;
_0x113:
	CALL SUBOPT_0x40
	__GETD1N 0x3ECAC083
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x115
	LDI  R30,LOW(14)
	RJMP _0x124
; 0000 026A       else if (temp_faza> 0.200) viz_faza=15;
_0x115:
	CALL SUBOPT_0x40
	__GETD1N 0x3E4CCCCD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x117
	LDI  R30,LOW(15)
	RJMP _0x124
; 0000 026B       else if (temp_faza> 0.000) viz_faza=16;
_0x117:
	CALL SUBOPT_0x40
	CALL __CPD02
	BRGE _0x119
	LDI  R30,LOW(16)
_0x124:
	MOV  R12,R30
; 0000 026C 
; 0000 026D       batt_zarqd();
_0x119:
_0xFA:
	CALL _batt_zarqd
; 0000 026E       lcd_disp();
	CALL _lcd_disp
; 0000 026F       zvuk();
	RCALL _zvuk
; 0000 0270 
; 0000 0271       delay_ms (100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0272       light=0;
	CBI  0x12,6
; 0000 0273       };
	RJMP _0x8F
; 0000 0274 }
_0x11C:
	RJMP _0x11C
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
	JMP  _0x20C0005
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
	JMP  _0x20C0005
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
	JMP  _0x20C0005
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
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
	CALL SUBOPT_0x41
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x42
	LDI  R30,LOW(4)
	CALL SUBOPT_0x42
	LDI  R30,LOW(133)
	CALL SUBOPT_0x42
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G100
	CPI  R30,LOW(0x5)
	BREQ _0x200000B
	LDI  R30,LOW(0)
	RJMP _0x20C0004
_0x200000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP _0x20C0004
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
_0x20C0005:
_0x20C0004:
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
	CALL SUBOPT_0x43
_0x202001D:
	RJMP _0x202001A
_0x202001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x202001E
	CPI  R18,37
	BRNE _0x202001F
	CALL SUBOPT_0x43
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
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x45
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x202002E
	CALL SUBOPT_0x46
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x47
	RJMP _0x202002F
_0x202002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2020031
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020032
_0x2020031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2020034
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlenf
	MOV  R17,R30
	CALL SUBOPT_0x44
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
_0x2020032:
	CALL SUBOPT_0x44
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x44
	CALL SUBOPT_0x49
	BREQ _0x2020041
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4A
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
	CALL SUBOPT_0x44
	CALL SUBOPT_0x4B
_0x2020044:
	RJMP _0x2020045
_0x2020041:
	CALL SUBOPT_0x46
	CALL SUBOPT_0x4A
_0x2020045:
_0x2020035:
	CALL SUBOPT_0x4C
	BRNE _0x2020046
_0x2020047:
	CP   R17,R21
	BRSH _0x2020049
	CALL SUBOPT_0x44
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004A
	CALL SUBOPT_0x44
	CALL SUBOPT_0x49
	BREQ _0x202004B
	CALL SUBOPT_0x44
	CALL SUBOPT_0x4B
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
	CALL SUBOPT_0x43
	SUBI R21,LOW(1)
	RJMP _0x2020047
_0x2020049:
_0x2020046:
	MOV  R19,R17
	CALL SUBOPT_0x44
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004E
_0x202004F:
	CPI  R19,0
	BREQ _0x2020051
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x47
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
	CALL SUBOPT_0x44
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202005D
	CALL SUBOPT_0x45
	ADIW R30,7
	RJMP _0x20200BE
_0x202005D:
	CALL SUBOPT_0x45
	ADIW R30,39
_0x20200BE:
	MOV  R18,R30
_0x202005C:
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x4C
	BREQ _0x2020067
_0x2020066:
	RJMP _0x2020065
_0x2020067:
	LDI  R18,LOW(32)
	CALL SUBOPT_0x44
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
	CALL SUBOPT_0x44
	CALL SUBOPT_0x49
	BREQ _0x2020069
	CALL SUBOPT_0x44
	CALL SUBOPT_0x4B
	ST   -Y,R20
	CALL SUBOPT_0x47
	CPI  R21,0
	BREQ _0x202006A
	SUBI R21,LOW(1)
_0x202006A:
_0x2020069:
_0x2020068:
_0x2020060:
	CALL SUBOPT_0x43
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
	CALL SUBOPT_0x4C
	BREQ _0x202006C
_0x202006D:
	CPI  R21,0
	BREQ _0x202006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x47
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
	CALL SUBOPT_0x1F
    brne __floor1
__floor0:
	CALL SUBOPT_0x20
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	RJMP _0x20C0003
_sin:
	CALL SUBOPT_0x4F
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x50
	CALL SUBOPT_0x51
	CALL __PUTPARD1
	RCALL _floor
	CALL SUBOPT_0x52
	CALL SUBOPT_0x23
	CALL SUBOPT_0x50
	CALL SUBOPT_0x53
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0x53
	CALL SUBOPT_0x23
	CALL SUBOPT_0x50
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0x52
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0x53
	CALL __SUBF12
	CALL SUBOPT_0x50
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0x54
_0x2040019:
	CALL SUBOPT_0x55
	__PUTD1S 1
	CALL SUBOPT_0x56
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x23
	CALL SUBOPT_0x57
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x52
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x56
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x57
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20C0002
_cos:
	CALL SUBOPT_0x4D
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0003
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x59
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x5A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x4D
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x22
	RCALL _xatan
	RJMP _0x20C0003
_0x2040020:
	CALL SUBOPT_0x4D
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x24
	RCALL _xatan
	CALL SUBOPT_0x5C
	RJMP _0x20C0003
_0x2040021:
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5B
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x24
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0003:
	ADIW R28,4
	RET
_asin:
	CALL SUBOPT_0x4F
	__GETD1N 0xBF800000
	CALL __CMPF12
	BRLO _0x2040023
	CALL SUBOPT_0x52
	__GETD1N 0x3F800000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2040023
	RJMP _0x2040022
_0x2040023:
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0002
_0x2040022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2040025
	CALL SUBOPT_0x54
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0x55
	__GETD2N 0x3F800000
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1E
	__PUTD1S 1
	CALL SUBOPT_0x52
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0x51
	__GETD2S 1
	CALL SUBOPT_0x24
	RCALL _yatan
	CALL SUBOPT_0x5C
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x52
	CALL SUBOPT_0x24
	RCALL _yatan
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0x56
	CALL __ANEGF1
	RJMP _0x20C0002
_0x2040028:
	CALL SUBOPT_0x56
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x58
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0001
_0x204002E:
	CALL SUBOPT_0x1C
	CALL __CPD02
	BRGE _0x204002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0001
_0x204002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0001
_0x204002D:
	CALL SUBOPT_0x58
	CALL SUBOPT_0x1C
	CALL __DIVF21
	CALL SUBOPT_0x1F
	__GETD2S 4
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0x22
	RCALL _yatan
	RJMP _0x20C0001
_0x2040031:
	CALL SUBOPT_0x5D
	CALL __ANEGF1
	RJMP _0x20C0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0x5D
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x23
	RJMP _0x20C0001
_0x2040032:
	CALL SUBOPT_0x22
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
_gnd_ampl:
	.BYTE 0x4
_gnd_faza:
	.BYTE 0x4
_rock_ampl:
	.BYTE 0x4
_rock_faza:
	.BYTE 0x4
_gnd_ampl_max:
	.BYTE 0x4
_gnd_faza_max:
	.BYTE 0x4
_rock_ampl_max:
	.BYTE 0x4
_rock_faza_max:
	.BYTE 0x4
_now_ampl:
	.BYTE 0x4
_now_faza:
	.BYTE 0x4
_bar_rad:
	.BYTE 0x4
_batt_celoe:
	.BYTE 0x2
_batt_drob:
	.BYTE 0x2
_temp_ampl:
	.BYTE 0x4
_temp_faza:
	.BYTE 0x4
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x5:
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
SUBOPT_0x6:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	MOV  R30,R9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x9:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOV  R30,R10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 57 TIMES, CODE SIZE REDUCTION:109 WORDS
SUBOPT_0xF:
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,0
	SBRC R3,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,0
	SBRC R2,1
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
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x15:
	CALL __PUTPARD1
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x18:
	CALL __PUTPARD1
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	__GETD1S 12
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CALL __PUTPARD1
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x20:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x20
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x23:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x26:
	MOV  R30,R10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	STS  _now_ampl,R30
	STS  _now_ampl+1,R31
	STS  _now_ampl+2,R22
	STS  _now_ampl+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	STS  _now_faza,R30
	STS  _now_faza+1,R31
	STS  _now_faza+2,R22
	STS  _now_faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x29:
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	LDS  R26,_gnd_faza_max
	LDS  R27,_gnd_faza_max+1
	LDS  R24,_gnd_faza_max+2
	LDS  R25,_gnd_faza_max+3
	CALL __ADDF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	LDS  R26,_now_faza
	LDS  R27,_now_faza+1
	LDS  R24,_now_faza+2
	LDS  R25,_now_faza+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2B:
	LDS  R26,_bar_rad
	LDS  R27,_bar_rad+1
	LDS  R24,_bar_rad+2
	LDS  R25,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2C:
	LDS  R30,_gnd_faza_max
	LDS  R31,_gnd_faza_max+1
	LDS  R22,_gnd_faza_max+2
	LDS  R23,_gnd_faza_max+3
	CALL __SUBF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	LDS  R26,_now_faza
	LDS  R27,_now_faza+1
	LDS  R24,_now_faza+2
	LDS  R25,_now_faza+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2D:
	LDS  R26,_now_ampl
	LDS  R27,_now_ampl+1
	LDS  R24,_now_ampl+2
	LDS  R25,_now_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2E:
	__GETD1N 0x3F7D70A4
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x2D
	__GETD1N 0x3F8147AE
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x30:
	LDS  R30,_now_ampl
	LDS  R31,_now_ampl+1
	LDS  R22,_now_ampl+2
	LDS  R23,_now_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x31:
	STS  _gnd_ampl,R30
	STS  _gnd_ampl+1,R31
	STS  _gnd_ampl+2,R22
	STS  _gnd_ampl+3,R23
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
	STS  _gnd_faza,R30
	STS  _gnd_faza+1,R31
	STS  _gnd_faza+2,R22
	STS  _gnd_faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x30
	CALL __PUTPARD1
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x34:
	LDS  R30,_temp_ampl
	LDS  R31,_temp_ampl+1
	LDS  R22,_temp_ampl+2
	LDS  R23,_temp_ampl+3
	CALL __PUTPARD1
	MOV  R30,R10
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x35:
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x29
	LDS  R26,_rock_faza_max
	LDS  R27,_rock_faza_max+1
	LDS  R24,_rock_faza_max+2
	LDS  R25,_rock_faza_max+3
	CALL __ADDF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	LDS  R26,_now_faza
	LDS  R27,_now_faza+1
	LDS  R24,_now_faza+2
	LDS  R25,_now_faza+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x2B
	LDS  R30,_rock_faza_max
	LDS  R31,_rock_faza_max+1
	LDS  R22,_rock_faza_max+2
	LDS  R23,_rock_faza_max+3
	CALL __SUBF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	LDS  R26,_now_faza
	LDS  R27,_now_faza+1
	LDS  R24,_now_faza+2
	LDS  R25,_now_faza+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x2D
	__GETD1N 0x3F733333
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0x2D
	__GETD1N 0x3F866666
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x30
	STS  _rock_ampl,R30
	STS  _rock_ampl+1,R31
	STS  _rock_ampl+2,R22
	STS  _rock_ampl+3,R23
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
	STS  _rock_faza,R30
	STS  _rock_faza+1,R31
	STS  _rock_faza+2,R22
	STS  _rock_faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3D:
	CALL _th_cos
	STS  _temp_ampl,R30
	STS  _temp_ampl+1,R31
	STS  _temp_ampl+2,R22
	STS  _temp_ampl+3,R23
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:189 WORDS
SUBOPT_0x3F:
	LDS  R26,_temp_ampl
	LDS  R27,_temp_ampl+1
	LDS  R24,_temp_ampl+2
	LDS  R25,_temp_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x40:
	LDS  R26,_temp_faza
	LDS  R27,_temp_faza+1
	LDS  R24,_temp_faza+2
	LDS  R25,_temp_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x43:
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
SUBOPT_0x44:
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x47:
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
SUBOPT_0x48:
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
SUBOPT_0x49:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	MOV  R30,R16
	LDI  R31,0
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4D:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD1N 0x3F800000
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4F:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x50:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x51:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x52:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x52
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x51
	CALL __ANEGF1
	RJMP SUBOPT_0x50

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x56:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	RCALL SUBOPT_0x20
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__GETD2N 0x3FC90FDB
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	RCALL SUBOPT_0x20
	CALL __ANEGF1
	CALL __PUTPARD1
	JMP  _yatan


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,55
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
