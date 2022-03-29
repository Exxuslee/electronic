
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
	.DEF _bar=R9
	.DEF _X=R8
	.DEF _Y=R11
	.DEF _viz_ampl=R10
	.DEF _viz_faza=R13
	.DEF _adc_data=R12

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x25,0x64,0x2E,0x25,0x64,0x56,0x20,0x42
	.DB  0x3D,0x25,0x64,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x53,0x74,0x61,0x74,0x0
	.DB  0x44,0x69,0x6E,0x20,0x0,0x25,0x78,0x20
	.DB  0x25,0x78,0x20,0x3D,0x5A,0x0,0x2B,0x47
	.DB  0x0,0x2B,0x52,0x0,0x2B,0x41,0x6C,0x6C
	.DB  0x0,0x2D,0x46,0x65,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x5F,0x53,0x74,0x61,0x74,0x69
	.DB  0x63,0x5F,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x5F,0x44,0x69,0x6E,0x61
	.DB  0x6D,0x69,0x63,0x5F,0x20,0x20,0x20,0x0
	.DB  0x42,0x61,0x72,0x72,0x69,0x65,0x72,0x20
	.DB  0x25,0x64,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x3E,0x3E,0x3E,0x3E,0x3E,0x20
	.DB  0x52,0x6F,0x63,0x6B,0x20,0x3C,0x3C,0x3C
	.DB  0x3C,0x3C,0x0,0x25,0x66,0x20,0x25,0x66
	.DB  0x0,0x3E,0x3E,0x3E,0x3E,0x20,0x47,0x72
	.DB  0x6F,0x75,0x6E,0x64,0x20,0x3C,0x3C,0x3C
	.DB  0x3C,0x0,0x25,0x66,0x20,0x25,0x66,0x20
	.DB  0x0,0x3E,0x3E,0x3E,0x3E,0x3E,0x20,0x5A
	.DB  0x65,0x72,0x6F,0x20,0x3C,0x3C,0x3C,0x3C
	.DB  0x3C,0x0,0x25,0x78,0x20,0x25,0x78,0x20
	.DB  0x25,0x78,0x20,0x25,0x78,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x5F,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x5F,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x5F,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x5F,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x5F,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x5F,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x5F,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xDB
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
	.DB  0x24,0x24,0x24,0x20,0x49,0x42,0x5F,0x45
	.DB  0x78,0x78,0x75,0x73,0x20,0x24,0x24,0x24
	.DB  0x0,0x76,0x31,0x2E,0x36,0x20,0x5E,0x5F
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
; 0000 0007 #endasm
;
;#include <lcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;
;#define ADC_VREF_TYPE 0x20
;#define light PORTD.6
;
;// Declare your global variables here
;char string_LCD_1[20], string_LCD_2[20];
;unsigned int zero_Y, zero_X;
;float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, gnd_ampl_max, gnd_faza_max, rock_ampl_max, rock_faza_max;
;float now_ampl, now_faza, bar_rad;
;float temp_ampl, temp_faza;
;unsigned char bar;
;unsigned char X, Y, viz_ampl, viz_faza;
;unsigned char adc_data;
;unsigned int batt_celoe, batt_drob;
;bit kn1, kn2, kn3, kn4, kn5, kn6, menu, mod_gnd, mod_rock, mod_all_met, rezym;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 001F {

	.CSEG
_adc_isr:
; 0000 0020 // Read the 8 most significant bits
; 0000 0021 // of the AD conversion result
; 0000 0022 adc_data=ADCH;
	IN   R12,5
; 0000 0023 }
	RETI
;
;// Read the 8 most significant bits
;// of the AD conversion result
;// with noise canceling
;unsigned char read_adc(unsigned char adc_input)
; 0000 0029 {
_read_adc:
; 0000 002A ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 002B // Delay needed for the stabilization of the ADC input voltage
; 0000 002C delay_us(10);
	__DELAY_USB 55
; 0000 002D #asm
; 0000 002E     in   r30,mcucr
    in   r30,mcucr
; 0000 002F     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0000 0030     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0031     out  mcucr,r30
    out  mcucr,r30
; 0000 0032     sleep
    sleep
; 0000 0033     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0000 0034     out  mcucr,r30
    out  mcucr,r30
; 0000 0035 #endasm
; 0000 0036 return adc_data;
	MOV  R30,R12
	ADIW R28,1
	RET
; 0000 0037 }
;
;void batt_zarqd(void)
; 0000 003A     {
_batt_zarqd:
; 0000 003B     unsigned int temp;
; 0000 003C     temp=read_adc(4);
	ST   -Y,R17
	ST   -Y,R16
;	temp -> R16,R17
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R16,R30
	CLR  R17
; 0000 003D     batt_celoe=temp/20;
	MOVW R26,R16
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21U
	STS  _batt_celoe,R30
	STS  _batt_celoe+1,R31
; 0000 003E     batt_drob=temp%20;
	MOVW R26,R16
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __MODW21U
	STS  _batt_drob,R30
	STS  _batt_drob+1,R31
; 0000 003F     }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void kn_klava(void)
; 0000 0042     {
_kn_klava:
; 0000 0043     kn1=0;
	CLT
	BLD  R2,0
; 0000 0044     kn2=0;
	BLD  R2,1
; 0000 0045     kn3=0;
	BLD  R2,2
; 0000 0046     kn4=0;
	BLD  R2,3
; 0000 0047     kn5=0;
	BLD  R2,4
; 0000 0048     kn6=0;
	BLD  R2,5
; 0000 0049     DDRD.2=1;
	SBI  0x11,2
; 0000 004A     PORTD.2=0;
	CBI  0x12,2
; 0000 004B     delay_ms (1);
	CALL SUBOPT_0x1
; 0000 004C     if (PIND.3==0 && PIND.4==0) kn1=1;
	LDI  R26,0
	SBIC 0x10,3
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
; 0000 004D     if (PIND.3==1 && PIND.4==0) kn2=1;
_0x7:
	LDI  R26,0
	SBIC 0x10,3
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
; 0000 004E     DDRD.2=0;
_0xA:
	CBI  0x11,2
; 0000 004F     DDRD.3=1;
	SBI  0x11,3
; 0000 0050     PORTD.2=1;
	SBI  0x12,2
; 0000 0051     PORTD.3=0;
	CBI  0x12,3
; 0000 0052     delay_ms (1);
	CALL SUBOPT_0x1
; 0000 0053     if (PIND.2==1 && PIND.4==0) kn3=1;
	LDI  R26,0
	SBIC 0x10,2
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
; 0000 0054     if (PIND.2==0 && PIND.4==0) kn4=1;
_0x15:
	LDI  R26,0
	SBIC 0x10,2
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
; 0000 0055     DDRD.3=0;
_0x18:
	CBI  0x11,3
; 0000 0056     DDRD.4=1;
	SBI  0x11,4
; 0000 0057     PORTD.3=1;
	SBI  0x12,3
; 0000 0058     PORTD.4=0;
	CBI  0x12,4
; 0000 0059     delay_ms (1);
	CALL SUBOPT_0x1
; 0000 005A     if (PIND.2==1 && PIND.3==0) kn5=1;
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x24
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x25
_0x24:
	RJMP _0x23
_0x25:
	SET
	BLD  R2,4
; 0000 005B     if (PIND.2==0 && PIND.3==1) kn6=1;
_0x23:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x27
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,5
; 0000 005C     DDRD.4=0;
_0x26:
	CBI  0x11,4
; 0000 005D     PORTD.4=1;
	SBI  0x12,4
; 0000 005E     }
	RET
;
;void lcd_disp(void)
; 0000 0061     {
_lcd_disp:
; 0000 0062     if (menu==1)
	CALL SUBOPT_0x3
	BREQ PC+3
	JMP _0x2D
; 0000 0063         {
; 0000 0064         light=1;
	CALL SUBOPT_0x4
; 0000 0065 
; 0000 0066         lcd_gotoxy (0,0);
; 0000 0067         sprintf (string_LCD_1, "%d.%dV B=%d       ", batt_celoe, batt_drob, bar);
	CALL SUBOPT_0x5
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
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0068         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL _lcd_puts
; 0000 0069 
; 0000 006A         lcd_gotoxy (12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x8
; 0000 006B         if (rezym == 0)         sprintf (string_LCD_1, "Stat");
	SBRC R3,2
	RJMP _0x30
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,19
	RJMP _0x1A4
; 0000 006C         else                    sprintf (string_LCD_1, "Din ");
_0x30:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,24
_0x1A4:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 006D         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 006E 
; 0000 006F         lcd_gotoxy (0,1);
; 0000 0070         sprintf (string_LCD_2, "%x %x =Z", X, Y);
	__POINTW1FN _0x0,29
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
; 0000 0071         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xE
	CALL _lcd_puts
; 0000 0072 
; 0000 0073         lcd_gotoxy (8,1);
	LDI  R30,LOW(8)
	CALL SUBOPT_0xF
; 0000 0074         if (mod_gnd == 1)   sprintf (string_LCD_2, "+G");
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x32
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,38
	RJMP _0x1A5
; 0000 0075         else                    sprintf (string_LCD_2, "  ");
_0x32:
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,16
_0x1A5:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0076         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xE
	CALL _lcd_puts
; 0000 0077 
; 0000 0078         lcd_gotoxy (10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0xF
; 0000 0079         if (mod_rock == 1)   sprintf (string_LCD_2, "+R");
	CALL SUBOPT_0x10
	BRNE _0x34
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,41
	RJMP _0x1A6
; 0000 007A         else                    sprintf (string_LCD_2, "  ");
_0x34:
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,16
_0x1A6:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 007B         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xE
	CALL _lcd_puts
; 0000 007C 
; 0000 007D         lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xF
; 0000 007E         if (mod_all_met == 1)   sprintf (string_LCD_2, "+All");
	LDI  R26,0
	SBRC R3,1
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x36
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,44
	RJMP _0x1A7
; 0000 007F         else                    sprintf (string_LCD_2, "-Fe ");
_0x36:
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,49
_0x1A7:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0080         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 0081 
; 0000 0082         return;
; 0000 0083         };
_0x2D:
; 0000 0084 
; 0000 0085     if (kn2==1)
	CALL SUBOPT_0x11
	BRNE _0x38
; 0000 0086         {
; 0000 0087         light=1;
	CALL SUBOPT_0x4
; 0000 0088         lcd_gotoxy (0,0);
; 0000 0089         if (rezym == 0)         sprintf (string_LCD_1, "    _Static_    ");
	SBRC R3,2
	RJMP _0x3B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,54
	RJMP _0x1A8
; 0000 008A         else                    sprintf (string_LCD_1, "    _Dinamic_   ");
_0x3B:
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,71
_0x1A8:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 008B         lcd_puts (string_LCD_1);
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	RJMP _0x20C0009
; 0000 008C         return;
; 0000 008D         };
_0x38:
; 0000 008E 
; 0000 008F     if (kn3==1)
	CALL SUBOPT_0x12
	BRNE _0x3D
; 0000 0090         {
; 0000 0091         light=1;
	SBI  0x12,6
; 0000 0092         lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 0093         sprintf (string_LCD_2, "Barrier %d       ", bar);
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,88
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0094         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 0095         return;
; 0000 0096         };
_0x3D:
; 0000 0097 
; 0000 0098     if (kn4==1)
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x40
; 0000 0099         {
; 0000 009A         light=1;
	CALL SUBOPT_0x4
; 0000 009B         lcd_gotoxy (0,0);
; 0000 009C         sprintf (string_LCD_1, ">>>>> Rock <<<<<", bar);
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,106
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x7
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 009D         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 009E         lcd_gotoxy (0,1);
; 0000 009F         sprintf (string_LCD_2, "%f %f", rock_ampl, rock_faza);
	__POINTW1FN _0x0,123
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0xD
; 0000 00A0         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00A1         return;
; 0000 00A2         };
_0x40:
; 0000 00A3 
; 0000 00A4     if (kn5==1)
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x43
; 0000 00A5         {
; 0000 00A6         light=1;
	CALL SUBOPT_0x4
; 0000 00A7         lcd_gotoxy (0,0);
; 0000 00A8         sprintf (string_LCD_1, ">>>> Ground <<<<");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,129
	CALL SUBOPT_0x15
; 0000 00A9         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00AA         lcd_gotoxy (0,1);
; 0000 00AB         sprintf (string_LCD_2, "%f %f ", gnd_ampl, gnd_faza);
	__POINTW1FN _0x0,146
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0xD
; 0000 00AC         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00AD         return;
; 0000 00AE         };
_0x43:
; 0000 00AF     if (kn6==1)
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0x46
; 0000 00B0         {
; 0000 00B1         light=1;
	CALL SUBOPT_0x4
; 0000 00B2         lcd_gotoxy (0,0);
; 0000 00B3         sprintf (string_LCD_1, ">>>>> Zero <<<<<");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x15
; 0000 00B4         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 00B5         lcd_gotoxy (0,1);
; 0000 00B6         sprintf (string_LCD_2, "%x %x %x %x ", zero_Y, zero_X, Y, X);
	__POINTW1FN _0x0,170
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R4
	CALL SUBOPT_0x6
	MOVW R30,R6
	CALL SUBOPT_0x6
	CALL SUBOPT_0xC
	CALL SUBOPT_0xB
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00B7         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00B8         return;
; 0000 00B9         };
_0x46:
; 0000 00BA     lcd_gotoxy (0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 00BB     if (rezym == 0)
	SBRC R3,2
	RJMP _0x49
; 0000 00BC         {
; 0000 00BD         if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
	TST  R10
	BRNE _0x4A
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,183
	CALL SUBOPT_0x15
; 0000 00BE         if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");
_0x4A:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x4B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,200
	CALL SUBOPT_0x15
; 0000 00BF         if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
_0x4B:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x4C
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,217
	CALL SUBOPT_0x15
; 0000 00C0         if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x4C:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x4D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x15
; 0000 00C1         if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x4D:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x4E
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,251
	CALL SUBOPT_0x15
; 0000 00C2         if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x4E:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x4F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,268
	CALL SUBOPT_0x15
; 0000 00C3         if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x4F:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x50
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,285
	CALL SUBOPT_0x15
; 0000 00C4         if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x50:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x51
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,302
	CALL SUBOPT_0x15
; 0000 00C5         if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x51:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x52
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,319
	CALL SUBOPT_0x15
; 0000 00C6         if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x52:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0x53
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,336
	CALL SUBOPT_0x15
; 0000 00C7         if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x53:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0x54
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,353
	CALL SUBOPT_0x15
; 0000 00C8         if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x54:
	LDI  R30,LOW(11)
	CP   R30,R10
	BRNE _0x55
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,370
	CALL SUBOPT_0x15
; 0000 00C9         if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x55:
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0x56
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,387
	CALL SUBOPT_0x15
; 0000 00CA         if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x56:
	LDI  R30,LOW(13)
	CP   R30,R10
	BRNE _0x57
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,404
	CALL SUBOPT_0x15
; 0000 00CB         if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x57:
	LDI  R30,LOW(14)
	CP   R30,R10
	BRNE _0x58
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,421
	CALL SUBOPT_0x15
; 0000 00CC         if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x58:
	LDI  R30,LOW(15)
	CP   R30,R10
	BRNE _0x59
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,438
	CALL SUBOPT_0x15
; 0000 00CD         if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x59:
	LDI  R30,LOW(16)
	CP   R30,R10
	BRNE _0x5A
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,455
	CALL SUBOPT_0x15
; 0000 00CE         if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x5A:
	LDI  R30,LOW(17)
	CP   R30,R10
	BRNE _0x5B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,472
	CALL SUBOPT_0x15
; 0000 00CF         if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x5B:
	LDI  R30,LOW(18)
	CP   R30,R10
	BRNE _0x5C
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,489
	CALL SUBOPT_0x15
; 0000 00D0         if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x5C:
	LDI  R30,LOW(19)
	CP   R30,R10
	BRNE _0x5D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,506
	CALL SUBOPT_0x15
; 0000 00D1         if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x5D:
	LDI  R30,LOW(20)
	CP   R30,R10
	BRNE _0x5E
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,523
	CALL SUBOPT_0x15
; 0000 00D2         if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x5E:
	LDI  R30,LOW(21)
	CP   R30,R10
	BRNE _0x5F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,540
	CALL SUBOPT_0x15
; 0000 00D3         if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x5F:
	LDI  R30,LOW(22)
	CP   R30,R10
	BRNE _0x60
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,557
	CALL SUBOPT_0x15
; 0000 00D4         if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x60:
	LDI  R30,LOW(23)
	CP   R30,R10
	BRNE _0x61
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,574
	CALL SUBOPT_0x15
; 0000 00D5         if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x61:
	LDI  R30,LOW(24)
	CP   R30,R10
	BRNE _0x62
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,591
	CALL SUBOPT_0x15
; 0000 00D6         if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x62:
	LDI  R30,LOW(25)
	CP   R30,R10
	BRNE _0x63
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,608
	CALL SUBOPT_0x15
; 0000 00D7         if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x63:
	LDI  R30,LOW(26)
	CP   R30,R10
	BRNE _0x64
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,625
	CALL SUBOPT_0x15
; 0000 00D8         if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x64:
	LDI  R30,LOW(27)
	CP   R30,R10
	BRNE _0x65
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,642
	CALL SUBOPT_0x15
; 0000 00D9         if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x65:
	LDI  R30,LOW(28)
	CP   R30,R10
	BRNE _0x66
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,659
	CALL SUBOPT_0x15
; 0000 00DA         if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x66:
	LDI  R30,LOW(29)
	CP   R30,R10
	BRNE _0x67
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,676
	CALL SUBOPT_0x15
; 0000 00DB         if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x67:
	LDI  R30,LOW(30)
	CP   R30,R10
	BRNE _0x68
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,693
	CALL SUBOPT_0x15
; 0000 00DC         if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x68:
	LDI  R30,LOW(31)
	CP   R30,R10
	BRNE _0x69
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,710
	CALL SUBOPT_0x15
; 0000 00DD         if (viz_ampl==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x69:
	LDI  R30,LOW(32)
	CP   R30,R10
	BRNE _0x6A
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,727
	CALL SUBOPT_0x15
; 0000 00DE         };
_0x6A:
_0x49:
; 0000 00DF     if (rezym == 1)
	LDI  R26,0
	SBRC R3,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x6B
; 0000 00E0         {
; 0000 00E1         if (viz_ampl==0)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿÿ");
	TST  R10
	BRNE _0x6C
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,744
	CALL SUBOPT_0x15
; 0000 00E2         if (viz_ampl==1)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ_");
_0x6C:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x6D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,761
	CALL SUBOPT_0x15
; 0000 00E3         if (viz_ampl==2)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ ");
_0x6D:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x6E
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,778
	CALL SUBOPT_0x15
; 0000 00E4         if (viz_ampl==3)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ_ ");
_0x6E:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x6F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,795
	CALL SUBOPT_0x15
; 0000 00E5         if (viz_ampl==4)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ  ");
_0x6F:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x70
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,812
	CALL SUBOPT_0x15
; 0000 00E6         if (viz_ampl==5)    sprintf (string_LCD_1, "        ÿÿÿÿÿ_  ");
_0x70:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x71
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,829
	CALL SUBOPT_0x15
; 0000 00E7         if (viz_ampl==6)    sprintf (string_LCD_1, "        ÿÿÿÿÿ   ");
_0x71:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x72
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,846
	CALL SUBOPT_0x15
; 0000 00E8         if (viz_ampl==7)    sprintf (string_LCD_1, "        ÿÿÿÿ_   ");
_0x72:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x73
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,863
	CALL SUBOPT_0x15
; 0000 00E9         if (viz_ampl==8)    sprintf (string_LCD_1, "        ÿÿÿÿ    ");
_0x73:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x74
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,880
	CALL SUBOPT_0x15
; 0000 00EA         if (viz_ampl==9)    sprintf (string_LCD_1, "        ÿÿÿ_    ");
_0x74:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0x75
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,897
	CALL SUBOPT_0x15
; 0000 00EB         if (viz_ampl==10)   sprintf (string_LCD_1, "        ÿÿÿ     ");
_0x75:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0x76
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,914
	CALL SUBOPT_0x15
; 0000 00EC         if (viz_ampl==11)   sprintf (string_LCD_1, "        ÿÿ_     ");
_0x76:
	LDI  R30,LOW(11)
	CP   R30,R10
	BRNE _0x77
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,931
	CALL SUBOPT_0x15
; 0000 00ED         if (viz_ampl==12)   sprintf (string_LCD_1, "        ÿÿ      ");
_0x77:
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0x78
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,948
	CALL SUBOPT_0x15
; 0000 00EE         if (viz_ampl==13)   sprintf (string_LCD_1, "        ÿ_      ");
_0x78:
	LDI  R30,LOW(13)
	CP   R30,R10
	BRNE _0x79
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,965
	CALL SUBOPT_0x15
; 0000 00EF         if (viz_ampl==14)   sprintf (string_LCD_1, "        ÿ       ");
_0x79:
	LDI  R30,LOW(14)
	CP   R30,R10
	BRNE _0x7A
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,982
	CALL SUBOPT_0x15
; 0000 00F0         if (viz_ampl==15)   sprintf (string_LCD_1, "        _       ");
_0x7A:
	LDI  R30,LOW(15)
	CP   R30,R10
	BRNE _0x7B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,999
	CALL SUBOPT_0x15
; 0000 00F1         if (viz_ampl==16)   sprintf (string_LCD_1, "                ");
_0x7B:
	LDI  R30,LOW(16)
	CP   R30,R10
	BRNE _0x7C
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,183
	CALL SUBOPT_0x15
; 0000 00F2         if (viz_ampl==17)   sprintf (string_LCD_1, "       _        ");
_0x7C:
	LDI  R30,LOW(17)
	CP   R30,R10
	BRNE _0x7D
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1016
	CALL SUBOPT_0x15
; 0000 00F3         if (viz_ampl==18)   sprintf (string_LCD_1, "       ÿ        ");
_0x7D:
	LDI  R30,LOW(18)
	CP   R30,R10
	BRNE _0x7E
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1033
	CALL SUBOPT_0x15
; 0000 00F4         if (viz_ampl==19)   sprintf (string_LCD_1, "      _ÿ        ");
_0x7E:
	LDI  R30,LOW(19)
	CP   R30,R10
	BRNE _0x7F
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1050
	CALL SUBOPT_0x15
; 0000 00F5         if (viz_ampl==20)   sprintf (string_LCD_1, "      ÿÿ        ");
_0x7F:
	LDI  R30,LOW(20)
	CP   R30,R10
	BRNE _0x80
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1067
	CALL SUBOPT_0x15
; 0000 00F6         if (viz_ampl==21)   sprintf (string_LCD_1, "     _ÿÿ        ");
_0x80:
	LDI  R30,LOW(21)
	CP   R30,R10
	BRNE _0x81
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1084
	CALL SUBOPT_0x15
; 0000 00F7         if (viz_ampl==22)   sprintf (string_LCD_1, "     ÿÿÿ        ");
_0x81:
	LDI  R30,LOW(22)
	CP   R30,R10
	BRNE _0x82
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1101
	CALL SUBOPT_0x15
; 0000 00F8         if (viz_ampl==23)   sprintf (string_LCD_1, "    _ÿÿÿ        ");
_0x82:
	LDI  R30,LOW(23)
	CP   R30,R10
	BRNE _0x83
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1118
	CALL SUBOPT_0x15
; 0000 00F9         if (viz_ampl==24)   sprintf (string_LCD_1, "    ÿÿÿÿ        ");
_0x83:
	LDI  R30,LOW(24)
	CP   R30,R10
	BRNE _0x84
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1135
	CALL SUBOPT_0x15
; 0000 00FA         if (viz_ampl==25)   sprintf (string_LCD_1, "   _ÿÿÿÿ        ");
_0x84:
	LDI  R30,LOW(25)
	CP   R30,R10
	BRNE _0x85
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1152
	CALL SUBOPT_0x15
; 0000 00FB         if (viz_ampl==26)   sprintf (string_LCD_1, "   ÿÿÿÿÿ        ");
_0x85:
	LDI  R30,LOW(26)
	CP   R30,R10
	BRNE _0x86
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1169
	CALL SUBOPT_0x15
; 0000 00FC         if (viz_ampl==27)   sprintf (string_LCD_1, "  _ÿÿÿÿÿ        ");
_0x86:
	LDI  R30,LOW(27)
	CP   R30,R10
	BRNE _0x87
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1186
	CALL SUBOPT_0x15
; 0000 00FD         if (viz_ampl==28)   sprintf (string_LCD_1, "  ÿÿÿÿÿÿ        ");
_0x87:
	LDI  R30,LOW(28)
	CP   R30,R10
	BRNE _0x88
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1203
	CALL SUBOPT_0x15
; 0000 00FE         if (viz_ampl==29)   sprintf (string_LCD_1, " _ÿÿÿÿÿÿ        ");
_0x88:
	LDI  R30,LOW(29)
	CP   R30,R10
	BRNE _0x89
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1220
	CALL SUBOPT_0x15
; 0000 00FF         if (viz_ampl==30)   sprintf (string_LCD_1, " ÿÿÿÿÿÿÿ        ");
_0x89:
	LDI  R30,LOW(30)
	CP   R30,R10
	BRNE _0x8A
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1237
	CALL SUBOPT_0x15
; 0000 0100         if (viz_ampl==31)   sprintf (string_LCD_1, "_ÿÿÿÿÿÿÿ        ");
_0x8A:
	LDI  R30,LOW(31)
	CP   R30,R10
	BRNE _0x8B
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1254
	CALL SUBOPT_0x15
; 0000 0101         if (viz_ampl==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x8B:
	LDI  R30,LOW(32)
	CP   R30,R10
	BRNE _0x8C
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,455
	CALL SUBOPT_0x15
; 0000 0102         };
_0x8C:
_0x6B:
; 0000 0103     lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL _lcd_puts
; 0000 0104     lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 0105     if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
	TST  R13
	BRNE _0x8D
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1271
	CALL SUBOPT_0x15
; 0000 0106     if (viz_faza==1)  sprintf (string_LCD_2, "Û------#I------Ü");
_0x8D:
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x8E
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1288
	CALL SUBOPT_0x15
; 0000 0107     if (viz_faza==2)  sprintf (string_LCD_2, "Û-----#II------Ü");
_0x8E:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x8F
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1305
	CALL SUBOPT_0x15
; 0000 0108     if (viz_faza==3)  sprintf (string_LCD_2, "Û----#-II------Ü");
_0x8F:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0x90
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1322
	CALL SUBOPT_0x15
; 0000 0109     if (viz_faza==4)  sprintf (string_LCD_2, "Û---#--II------Ü");
_0x90:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0x91
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1339
	CALL SUBOPT_0x15
; 0000 010A     if (viz_faza==5)  sprintf (string_LCD_2, "Û--#---II------Ü");
_0x91:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0x92
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1356
	CALL SUBOPT_0x15
; 0000 010B     if (viz_faza==6)  sprintf (string_LCD_2, "Û-#----II------Ü");
_0x92:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0x93
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1373
	CALL SUBOPT_0x15
; 0000 010C     if (viz_faza==7)  sprintf (string_LCD_2, "Û#-----II------Ü");
_0x93:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0x94
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1390
	CALL SUBOPT_0x15
; 0000 010D     if (viz_faza==8)  sprintf (string_LCD_2, ">_<----II------Ü");
_0x94:
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x95
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1407
	CALL SUBOPT_0x15
; 0000 010E     if (viz_faza==9)  sprintf (string_LCD_2, "Û------I#------Ü");
_0x95:
	LDI  R30,LOW(9)
	CP   R30,R13
	BRNE _0x96
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1424
	CALL SUBOPT_0x15
; 0000 010F     if (viz_faza==10) sprintf (string_LCD_2, "Û------II#-----Ü");
_0x96:
	LDI  R30,LOW(10)
	CP   R30,R13
	BRNE _0x97
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1441
	CALL SUBOPT_0x15
; 0000 0110     if (viz_faza==11) sprintf (string_LCD_2, "Û------II-#----Ü");
_0x97:
	LDI  R30,LOW(11)
	CP   R30,R13
	BRNE _0x98
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1458
	CALL SUBOPT_0x15
; 0000 0111     if (viz_faza==12) sprintf (string_LCD_2, "Û------II--#---Ü");
_0x98:
	LDI  R30,LOW(12)
	CP   R30,R13
	BRNE _0x99
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1475
	CALL SUBOPT_0x15
; 0000 0112     if (viz_faza==13) sprintf (string_LCD_2, "Û------II---#--Ü");
_0x99:
	LDI  R30,LOW(13)
	CP   R30,R13
	BRNE _0x9A
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1492
	CALL SUBOPT_0x15
; 0000 0113     if (viz_faza==14) sprintf (string_LCD_2, "Û------II----#-Ü");
_0x9A:
	LDI  R30,LOW(14)
	CP   R30,R13
	BRNE _0x9B
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1509
	CALL SUBOPT_0x15
; 0000 0114     if (viz_faza==15) sprintf (string_LCD_2, "Û------II-----#Ü");
_0x9B:
	LDI  R30,LOW(15)
	CP   R30,R13
	BRNE _0x9C
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1526
	CALL SUBOPT_0x15
; 0000 0115     if (viz_faza==16) sprintf (string_LCD_2, "Û------II----o_O");
_0x9C:
	LDI  R30,LOW(16)
	CP   R30,R13
	BRNE _0x9D
	CALL SUBOPT_0xE
	__POINTW1FN _0x0,1543
	CALL SUBOPT_0x15
; 0000 0116     lcd_puts (string_LCD_2);
_0x9D:
_0x20C0008:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
_0x20C0009:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0117     }
	RET
;
;void zvuk ()
; 0000 011A     {
_zvuk:
; 0000 011B     UDR = X;
	OUT  0xC,R8
; 0000 011C     }
	RET
;
;void new_X_Y_stat (void)
; 0000 011F     {
_new_X_Y_stat:
; 0000 0120     X = read_adc (0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R8,R30
; 0000 0121     Y = read_adc (1);
	LDI  R30,LOW(1)
	RJMP _0x20C0007
; 0000 0122     }
;
;void new_X_Y_din (void)
; 0000 0125     {
_new_X_Y_din:
; 0000 0126     X = read_adc (2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R8,R30
; 0000 0127     Y = read_adc (3);
	LDI  R30,LOW(3)
_0x20C0007:
	ST   -Y,R30
	RCALL _read_adc
	MOV  R11,R30
; 0000 0128     }
	RET
;
;float vektor_ampl (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
; 0000 012B     {
_vektor_ampl:
; 0000 012C     long int YY, XX;
; 0000 012D     long unsigned int YX2;
; 0000 012E     float YX3;
; 0000 012F     if (Y_1 > Y_2) YY = Y_1 - Y_2;
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
	BRSH _0x9E
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RJMP _0x1A9
; 0000 0130     else YY = Y_2 - Y_1;
_0x9E:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
_0x1A9:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 12
; 0000 0131     if (X_1 > X_2) XX = X_1 - X_2;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0xA0
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	RJMP _0x1AA
; 0000 0132     else XX = X_2 - X_1;
_0xA0:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
_0x1AA:
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__PUTD1S 8
; 0000 0133     YX2  = YY*YY + XX*XX;
	CALL SUBOPT_0x18
	CALL __MULD12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 8
	CALL SUBOPT_0x19
	CALL __MULD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	CALL SUBOPT_0x1A
; 0000 0134     YX3 = sqrt (YX2);
	CALL __CDF1U
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 0135     return YX3;
	CALL SUBOPT_0x1D
	RJMP _0x20C0006
; 0000 0136     }
;
;
;float vektor_faza (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
; 0000 013A     {
_vektor_faza:
; 0000 013B     signed int YY, XX;
; 0000 013C     float YX2;
; 0000 013D     YY = Y_1 - Y_2;
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
; 0000 013E     XX = X_1 - X_2;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0000 013F     YX2 = atan2 (YY,XX);
	MOVW R30,R16
	CALL SUBOPT_0x1E
	MOVW R30,R18
	CALL SUBOPT_0x1E
	CALL _atan2
	CALL SUBOPT_0x1A
; 0000 0140     return YX2;
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; 0000 0141     }
;
;float th_cos (float a, float aa_x, float b, float bb_x)
; 0000 0144     {
_th_cos:
; 0000 0145     float c;
; 0000 0146     float aabb;
; 0000 0147     aabb = aa_x - bb_x;
	SBIW R28,8
;	a -> Y+20
;	aa_x -> Y+16
;	b -> Y+12
;	bb_x -> Y+8
;	c -> Y+4
;	aabb -> Y+0
	CALL SUBOPT_0x19
	__GETD1S 16
	CALL __SUBF12
	CALL SUBOPT_0x1C
; 0000 0148     c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
	__GETD1S 20
	__GETD2S 20
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1A
; 0000 0149     return c;
_0x20C0006:
	ADIW R28,24
	RET
; 0000 014A     }
;
;float th_sin (float c, int b_y, int b_x, int c_y, int c_x)
; 0000 014D     {
_th_sin:
; 0000 014E     int ab;
; 0000 014F     float temp;
; 0000 0150     if (b_y > c_y) ab = b_y - c_y;
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
	BRGE _0xA2
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RJMP _0x1AB
; 0000 0151     else ab = c_y - b_y;
_0xA2:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x1AB:
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
; 0000 0152     temp = asin (ab/c);
	__GETD1S 14
	MOVW R26,R16
	CALL __CWD2
	CALL __CDF2
	CALL SUBOPT_0x21
	CALL _asin
	__PUTD1S 2
; 0000 0153     if (c_x > b_x) temp = 3.141593 - temp;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xA4
	__GETD2S 2
	__GETD1N 0x40490FDC
	CALL __SUBF12
	__PUTD1S 2
; 0000 0154     return temp;
_0xA4:
	__GETD1S 2
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,18
	RET
; 0000 0155     }
;
;void main_menu(void)
; 0000 0158     {
_main_menu:
; 0000 0159     menu++;
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 015A     while (kn1==1)
_0xA5:
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xA7
; 0000 015B         {
; 0000 015C         kn_klava();
	CALL SUBOPT_0x22
; 0000 015D         lcd_disp();
; 0000 015E         };
	RJMP _0xA5
_0xA7:
; 0000 015F     }
	RET
;
;void rezymm(void)
; 0000 0162     {
_rezymm:
; 0000 0163     rezym++;
	LDI  R30,LOW(4)
	EOR  R3,R30
; 0000 0164     while (kn2==1)
_0xA8:
	CALL SUBOPT_0x11
	BRNE _0xAA
; 0000 0165         {
; 0000 0166         kn_klava();
	CALL SUBOPT_0x22
; 0000 0167         lcd_disp();
; 0000 0168         };
	RJMP _0xA8
_0xAA:
; 0000 0169     }
	RET
;
;void barrier(void)
; 0000 016C     {
_barrier:
; 0000 016D     bar++;
	INC  R9
; 0000 016E     if (bar==10) bar=0;
	LDI  R30,LOW(10)
	CP   R30,R9
	BRNE _0xAB
	CLR  R9
; 0000 016F     bar_rad = (float) bar*0.174532925;
_0xAB:
	MOV  R30,R9
	CALL __CBD1
	CALL __CDF1
	__GETD2N 0x3E32B8C2
	CALL __MULF12
	STS  _bar_rad,R30
	STS  _bar_rad+1,R31
	STS  _bar_rad+2,R22
	STS  _bar_rad+3,R23
; 0000 0170     while (kn3==1)
_0xAC:
	CALL SUBOPT_0x12
	BRNE _0xAE
; 0000 0171         {
; 0000 0172         kn_klava();
	CALL SUBOPT_0x22
; 0000 0173         lcd_disp();
; 0000 0174         };
	RJMP _0xAC
_0xAE:
; 0000 0175     }
	RET
;
;void rock(void)
; 0000 0178     {
_rock:
; 0000 0179     if (menu==1) mod_rock++;
	CALL SUBOPT_0x3
	BRNE _0xAF
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 017A     rock_ampl_max = vektor_ampl(Y, X, zero_Y, zero_X);
_0xAF:
	CALL SUBOPT_0x23
	RCALL _vektor_ampl
	STS  _rock_ampl_max,R30
	STS  _rock_ampl_max+1,R31
	STS  _rock_ampl_max+2,R22
	STS  _rock_ampl_max+3,R23
; 0000 017B     rock_faza_max = vektor_faza(Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x23
	RCALL _vektor_faza
	STS  _rock_faza_max,R30
	STS  _rock_faza_max+1,R31
	STS  _rock_faza_max+2,R22
	STS  _rock_faza_max+3,R23
; 0000 017C     }
	RET
;
;void ground(void)
; 0000 017F     {
_ground:
; 0000 0180     if (menu==1) mod_gnd++;
	CALL SUBOPT_0x3
	BRNE _0xB0
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0181     gnd_ampl_max = vektor_ampl(Y, X, zero_Y, zero_X);
_0xB0:
	CALL SUBOPT_0x23
	RCALL _vektor_ampl
	STS  _gnd_ampl_max,R30
	STS  _gnd_ampl_max+1,R31
	STS  _gnd_ampl_max+2,R22
	STS  _gnd_ampl_max+3,R23
; 0000 0182     gnd_faza_max = vektor_faza(Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x23
	RCALL _vektor_faza
	STS  _gnd_faza_max,R30
	STS  _gnd_faza_max+1,R31
	STS  _gnd_faza_max+2,R22
	STS  _gnd_faza_max+3,R23
; 0000 0183     }
	RET
;
;void zero(void)
; 0000 0186     {
_zero:
; 0000 0187     if (menu==1) mod_all_met++;
	CALL SUBOPT_0x3
	BRNE _0xB1
	LDI  R30,LOW(2)
	EOR  R3,R30
; 0000 0188     zero_X = X;
_0xB1:
	MOV  R6,R8
	CLR  R7
; 0000 0189     zero_Y = Y;
	MOV  R4,R11
	CLR  R5
; 0000 018A     }
	RET
;
;void start (void)
; 0000 018D {
_start:
; 0000 018E // Declare your local variables here
; 0000 018F 
; 0000 0190 // Input/Output Ports initialization
; 0000 0191 // Port A initialization
; 0000 0192 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0193 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0194 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0195 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0196 
; 0000 0197 // Port B initialization
; 0000 0198 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0199 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 019A PORTB=0x00;
	OUT  0x18,R30
; 0000 019B DDRB=0x00;
	OUT  0x17,R30
; 0000 019C 
; 0000 019D // Port C initialization
; 0000 019E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 019F // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01A0 PORTC=0x00;
	OUT  0x15,R30
; 0000 01A1 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 01A2 
; 0000 01A3 // Port D initialization
; 0000 01A4 // Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 01A5 // State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=0
; 0000 01A6 PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 01A7 DDRD=0xA3;
	LDI  R30,LOW(163)
	OUT  0x11,R30
; 0000 01A8 
; 0000 01A9 // ADC initialization
; 0000 01AA // ADC Clock frequency: 256,000 kHz
; 0000 01AB // ADC Voltage Reference: Int., cap. on AREF
; 0000 01AC // Only the 8 most significant bits of
; 0000 01AD // the AD conversion result are used
; 0000 01AE ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 01AF ADCSRA=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 01B0 
; 0000 01B1 // Timer/Counter 0 initialization
; 0000 01B2 // Clock source: System Clock
; 0000 01B3 // Clock value: Timer 0 Stopped
; 0000 01B4 // Mode: Normal top=FFh
; 0000 01B5 // OC0 output: Disconnected
; 0000 01B6 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01B7 TCNT0=0x00;
	OUT  0x32,R30
; 0000 01B8 OCR0=0x00;
	OUT  0x3C,R30
; 0000 01B9 
; 0000 01BA // Timer/Counter 1 initialization
; 0000 01BB // Clock source: System Clock
; 0000 01BC // Clock value: Timer 1 Stopped
; 0000 01BD // Mode: Normal top=FFFFh
; 0000 01BE // OC1A output: Discon.
; 0000 01BF // OC1B output: Discon.
; 0000 01C0 // Noise Canceler: Off
; 0000 01C1 // Input Capture on Falling Edge
; 0000 01C2 // Timer 1 Overflow Interrupt: Off
; 0000 01C3 // Input Capture Interrupt: Off
; 0000 01C4 // Compare A Match Interrupt: Off
; 0000 01C5 // Compare B Match Interrupt: Off
; 0000 01C6 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01C7 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01C8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01C9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01CA ICR1H=0x00;
	OUT  0x27,R30
; 0000 01CB ICR1L=0x00;
	OUT  0x26,R30
; 0000 01CC OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01CD OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01CE OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01CF OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01D0 
; 0000 01D1 // Timer/Counter 2 initialization
; 0000 01D2 // Clock source: System Clock
; 0000 01D3 // Clock value: Timer 2 Stopped
; 0000 01D4 // Mode: Normal top=FFh
; 0000 01D5 // OC2 output: Disconnected
; 0000 01D6 ASSR=0x00;
	OUT  0x22,R30
; 0000 01D7 TCCR2=0x00;
	OUT  0x25,R30
; 0000 01D8 TCNT2=0x00;
	OUT  0x24,R30
; 0000 01D9 OCR2=0x00;
	OUT  0x23,R30
; 0000 01DA 
; 0000 01DB // External Interrupt(s) initialization
; 0000 01DC // INT0: Off
; 0000 01DD // INT1: Off
; 0000 01DE // INT2: Off
; 0000 01DF MCUCR=0x00;
	OUT  0x35,R30
; 0000 01E0 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01E1 
; 0000 01E2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01E3 TIMSK=0x00;
	OUT  0x39,R30
; 0000 01E4 
; 0000 01E5 // Analog Comparator initialization
; 0000 01E6 // Analog Comparator: Off
; 0000 01E7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01E8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01E9 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01EA 
; 0000 01EB // USART initialization
; 0000 01EC // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01ED // USART Receiver: Off
; 0000 01EE // USART Transmitter: On
; 0000 01EF // USART Mode: Asynchronous
; 0000 01F0 // USART Baud Rate: 115200
; 0000 01F1 UCSRA=0x00;
	OUT  0xB,R30
; 0000 01F2 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 01F3 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01F4 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01F5 UBRRL=0x08;
	LDI  R30,LOW(8)
	OUT  0x9,R30
; 0000 01F6 
; 0000 01F7 // LCD module initialization
; 0000 01F8 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 01F9 
; 0000 01FA lcd_gotoxy (0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
; 0000 01FB sprintf (string_LCD_1, "$$$ IB_Exxus $$$");
	CALL SUBOPT_0x5
	__POINTW1FN _0x0,1560
	CALL SUBOPT_0x15
; 0000 01FC lcd_puts (string_LCD_1);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xA
; 0000 01FD lcd_gotoxy (0,1);
; 0000 01FE sprintf (string_LCD_2, "v1.6 ^_^ md4u.ru");
	__POINTW1FN _0x0,1577
	CALL SUBOPT_0x15
; 0000 01FF lcd_puts (string_LCD_2);
	CALL SUBOPT_0xE
	CALL _lcd_puts
; 0000 0200 delay_ms (5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0201 
; 0000 0202 // Global enable interrupts
; 0000 0203 #asm("sei")
	sei
; 0000 0204 }
	RET
;
;void main(void)
; 0000 0207 {
_main:
; 0000 0208 start ();
	RCALL _start
; 0000 0209 temp_ampl = 0;
	__GETD1N 0x0
	CALL SUBOPT_0x24
; 0000 020A 
; 0000 020B while (1)
_0xB2:
; 0000 020C       {
; 0000 020D       // Place your code here
; 0000 020E       kn_klava();
	RCALL _kn_klava
; 0000 020F 
; 0000 0210       if (rezym == 0) new_X_Y_stat ();
	SBRC R3,2
	RJMP _0xB5
	RCALL _new_X_Y_stat
; 0000 0211       else new_X_Y_din ();
	RJMP _0xB6
_0xB5:
	RCALL _new_X_Y_din
; 0000 0212 
; 0000 0213       if (kn1==1) main_menu();
_0xB6:
	LDI  R26,0
	SBRC R2,0
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xB7
	RCALL _main_menu
; 0000 0214       if (kn2==1) rezymm ();
_0xB7:
	CALL SUBOPT_0x11
	BRNE _0xB8
	RCALL _rezymm
; 0000 0215       if (kn3==1) barrier();
_0xB8:
	CALL SUBOPT_0x12
	BRNE _0xB9
	RCALL _barrier
; 0000 0216       if (kn4==1) rock();
_0xB9:
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBA
	RCALL _rock
; 0000 0217       if (kn5==1) ground();
_0xBA:
	LDI  R26,0
	SBRC R2,4
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBB
	RCALL _ground
; 0000 0218       if (kn6==1) zero();
_0xBB:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xBC
	RCALL _zero
; 0000 0219 
; 0000 021A 
; 0000 021B       if (rezym == 0)
_0xBC:
	SBRC R3,2
	RJMP _0xBD
; 0000 021C         {
; 0000 021D         now_ampl = vektor_ampl (Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x23
	RCALL _vektor_ampl
	CALL SUBOPT_0x25
; 0000 021E         now_faza = vektor_faza (Y, X, zero_Y, zero_X);
	CALL SUBOPT_0x23
	RCALL _vektor_faza
	CALL SUBOPT_0x26
; 0000 021F 
; 0000 0220         if (mod_gnd || mod_rock == 1)
	SBRC R2,7
	RJMP _0xBF
	CALL SUBOPT_0x10
	BREQ _0xBF
	RJMP _0xBE
_0xBF:
; 0000 0221                 {
; 0000 0222                 if ((now_faza <= gnd_faza_max + bar_rad + 0.005 ) && (now_faza >= gnd_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC2
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	BRSH _0xC3
_0xC2:
	RJMP _0xC1
_0xC3:
; 0000 0223                 {
; 0000 0224                 if ((now_ampl * 0.99 <= gnd_ampl ) && (now_ampl * 1.01 >= gnd_ampl))
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC5
	CALL SUBOPT_0x2D
	BRSH _0xC6
_0xC5:
	RJMP _0xC4
_0xC6:
; 0000 0225                         {
; 0000 0226                         gnd_ampl = now_ampl;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
; 0000 0227                         gnd_faza = now_faza;
; 0000 0228                         };
_0xC4:
; 0000 0229                     };
_0xC1:
; 0000 022A                 now_ampl = th_cos (now_ampl, now_faza, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	RCALL _th_cos
	CALL SUBOPT_0x25
; 0000 022B                 now_faza = th_sin (temp_ampl, Y, X, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x32
	CALL SUBOPT_0x16
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	RCALL _th_sin
	CALL SUBOPT_0x26
; 0000 022C                 if ((now_faza <= rock_faza_max + bar_rad + 0.005 ) && (now_faza >= rock_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x35
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC8
	CALL SUBOPT_0x36
	BRSH _0xC9
_0xC8:
	RJMP _0xC7
_0xC9:
; 0000 022D                     {
; 0000 022E                     if ((now_ampl * 0.95 <= rock_ampl ) && (now_ampl * 1.05 >= rock_ampl))
	CALL SUBOPT_0x37
	BREQ PC+4
	BRCS PC+3
	JMP  _0xCB
	CALL SUBOPT_0x38
	BRSH _0xCC
_0xCB:
	RJMP _0xCA
_0xCC:
; 0000 022F                         {
; 0000 0230                         rock_ampl = now_ampl;
	CALL SUBOPT_0x39
; 0000 0231                         rock_faza = now_faza;
; 0000 0232                         };
_0xCA:
; 0000 0233                     };
_0xC7:
; 0000 0234                 temp_ampl = th_cos (now_ampl, now_faza, rock_ampl, rock_faza);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
; 0000 0235                 temp_faza = th_sin (temp_ampl, Y, X, rock_ampl, rock_faza);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x33
	CALL SUBOPT_0x3C
	RCALL _th_sin
	RJMP _0x1AC
; 0000 0236                 }
; 0000 0237 
; 0000 0238         else if (mod_gnd == 1)
_0xBE:
	LDI  R26,0
	SBRC R2,7
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xCE
; 0000 0239                 {
; 0000 023A                 if ((now_faza <= gnd_faza_max + bar_rad + 0.005 ) && (now_faza >= gnd_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	BREQ PC+4
	BRCS PC+3
	JMP  _0xD0
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	BRSH _0xD1
_0xD0:
	RJMP _0xCF
_0xD1:
; 0000 023B                     {
; 0000 023C                     if ((now_ampl * 0.99 <= gnd_ampl ) && (now_ampl * 1.01 >= gnd_ampl))
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	BREQ PC+4
	BRCS PC+3
	JMP  _0xD3
	CALL SUBOPT_0x2D
	BRSH _0xD4
_0xD3:
	RJMP _0xD2
_0xD4:
; 0000 023D                         {
; 0000 023E                         gnd_ampl = now_ampl;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
; 0000 023F                         gnd_faza = now_faza;
; 0000 0240                         };
_0xD2:
; 0000 0241                     };
_0xCF:
; 0000 0242                 temp_ampl = th_cos (now_ampl, now_faza, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x3B
; 0000 0243                 temp_faza = th_sin (temp_ampl, Y, X, gnd_ampl, gnd_faza);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	RCALL _th_sin
	RJMP _0x1AC
; 0000 0244                 }
; 0000 0245 
; 0000 0246         else if (mod_rock == 1)
_0xCE:
	CALL SUBOPT_0x10
	BRNE _0xD6
; 0000 0247                 {
; 0000 0248                 if ((now_faza <= rock_faza_max + bar_rad + 0.005 ) && (now_faza >= rock_faza_max - bar_rad + 0.005 ))
	CALL SUBOPT_0x35
	BREQ PC+4
	BRCS PC+3
	JMP  _0xD8
	CALL SUBOPT_0x36
	BRSH _0xD9
_0xD8:
	RJMP _0xD7
_0xD9:
; 0000 0249                     {
; 0000 024A                     if ((now_ampl * 0.95 <= rock_ampl ) && (now_ampl * 1.05 >= rock_ampl))
	CALL SUBOPT_0x37
	BREQ PC+4
	BRCS PC+3
	JMP  _0xDB
	CALL SUBOPT_0x38
	BRSH _0xDC
_0xDB:
	RJMP _0xDA
_0xDC:
; 0000 024B                         {
; 0000 024C                         rock_ampl = now_ampl;
	CALL SUBOPT_0x39
; 0000 024D                         rock_faza = now_faza;
; 0000 024E                         };
_0xDA:
; 0000 024F                     };
_0xD7:
; 0000 0250                 temp_ampl = th_cos (now_ampl, now_faza, rock_ampl, rock_faza);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
; 0000 0251                 temp_faza = th_sin (temp_ampl, Y, X, rock_ampl, rock_faza);
	CALL SUBOPT_0x13
	CALL SUBOPT_0x33
	CALL SUBOPT_0x3C
	RCALL _th_sin
	RJMP _0x1AC
; 0000 0252                 }
; 0000 0253 
; 0000 0254         else
_0xD6:
; 0000 0255                 {
; 0000 0256                 temp_ampl = now_ampl;
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x24
; 0000 0257                 temp_faza = now_faza;
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
_0x1AC:
	STS  _temp_faza,R30
	STS  _temp_faza+1,R31
	STS  _temp_faza+2,R22
	STS  _temp_faza+3,R23
; 0000 0258                 };
; 0000 0259 
; 0000 025A         if      (temp_ampl> 160 )   viz_ampl=32;
	CALL SUBOPT_0x3D
	__GETD1N 0x43200000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xDE
	LDI  R30,LOW(32)
	MOV  R10,R30
; 0000 025B         else if (temp_ampl> 155 )   viz_ampl=31;
	RJMP _0xDF
_0xDE:
	CALL SUBOPT_0x3D
	__GETD1N 0x431B0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE0
	LDI  R30,LOW(31)
	MOV  R10,R30
; 0000 025C         else if (temp_ampl> 150 )   viz_ampl=30;
	RJMP _0xE1
_0xE0:
	CALL SUBOPT_0x3D
	__GETD1N 0x43160000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE2
	LDI  R30,LOW(30)
	MOV  R10,R30
; 0000 025D         else if (temp_ampl> 145 )   viz_ampl=29;
	RJMP _0xE3
_0xE2:
	CALL SUBOPT_0x3D
	__GETD1N 0x43110000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE4
	LDI  R30,LOW(29)
	MOV  R10,R30
; 0000 025E         else if (temp_ampl> 140 )   viz_ampl=28;
	RJMP _0xE5
_0xE4:
	CALL SUBOPT_0x3D
	__GETD1N 0x430C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE6
	LDI  R30,LOW(28)
	MOV  R10,R30
; 0000 025F         else if (temp_ampl> 135 )   viz_ampl=27;
	RJMP _0xE7
_0xE6:
	CALL SUBOPT_0x3D
	__GETD1N 0x43070000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xE8
	LDI  R30,LOW(27)
	MOV  R10,R30
; 0000 0260         else if (temp_ampl> 130 )   viz_ampl=26;
	RJMP _0xE9
_0xE8:
	CALL SUBOPT_0x3D
	__GETD1N 0x43020000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEA
	LDI  R30,LOW(26)
	MOV  R10,R30
; 0000 0261         else if (temp_ampl> 125 )   viz_ampl=25;
	RJMP _0xEB
_0xEA:
	CALL SUBOPT_0x3D
	__GETD1N 0x42FA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEC
	LDI  R30,LOW(25)
	MOV  R10,R30
; 0000 0262         else if (temp_ampl> 120 )   viz_ampl=24;
	RJMP _0xED
_0xEC:
	CALL SUBOPT_0x3D
	__GETD1N 0x42F00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xEE
	LDI  R30,LOW(24)
	MOV  R10,R30
; 0000 0263         else if (temp_ampl> 115 )   viz_ampl=23;
	RJMP _0xEF
_0xEE:
	CALL SUBOPT_0x3D
	__GETD1N 0x42E60000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF0
	LDI  R30,LOW(23)
	MOV  R10,R30
; 0000 0264         else if (temp_ampl> 110 )   viz_ampl=22;
	RJMP _0xF1
_0xF0:
	CALL SUBOPT_0x3D
	__GETD1N 0x42DC0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF2
	LDI  R30,LOW(22)
	MOV  R10,R30
; 0000 0265         else if (temp_ampl> 105 )   viz_ampl=21;
	RJMP _0xF3
_0xF2:
	CALL SUBOPT_0x3D
	__GETD1N 0x42D20000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF4
	LDI  R30,LOW(21)
	MOV  R10,R30
; 0000 0266         else if (temp_ampl> 100 )   viz_ampl=20;
	RJMP _0xF5
_0xF4:
	CALL SUBOPT_0x3D
	__GETD1N 0x42C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF6
	LDI  R30,LOW(20)
	MOV  R10,R30
; 0000 0267         else if (temp_ampl> 95  )   viz_ampl=19;
	RJMP _0xF7
_0xF6:
	CALL SUBOPT_0x3D
	__GETD1N 0x42BE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xF8
	LDI  R30,LOW(19)
	MOV  R10,R30
; 0000 0268         else if (temp_ampl> 90  )   viz_ampl=18;
	RJMP _0xF9
_0xF8:
	CALL SUBOPT_0x3D
	__GETD1N 0x42B40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFA
	LDI  R30,LOW(18)
	MOV  R10,R30
; 0000 0269         else if (temp_ampl> 85  )   viz_ampl=17;
	RJMP _0xFB
_0xFA:
	CALL SUBOPT_0x3D
	__GETD1N 0x42AA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFC
	LDI  R30,LOW(17)
	MOV  R10,R30
; 0000 026A         else if (temp_ampl> 80  )   viz_ampl=16;
	RJMP _0xFD
_0xFC:
	CALL SUBOPT_0x3D
	__GETD1N 0x42A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xFE
	LDI  R30,LOW(16)
	MOV  R10,R30
; 0000 026B         else if (temp_ampl> 75  )   viz_ampl=15;
	RJMP _0xFF
_0xFE:
	CALL SUBOPT_0x3D
	__GETD1N 0x42960000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x100
	LDI  R30,LOW(15)
	MOV  R10,R30
; 0000 026C         else if (temp_ampl> 70  )   viz_ampl=14;
	RJMP _0x101
_0x100:
	CALL SUBOPT_0x3D
	__GETD1N 0x428C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x102
	LDI  R30,LOW(14)
	MOV  R10,R30
; 0000 026D         else if (temp_ampl> 65  )   viz_ampl=13;
	RJMP _0x103
_0x102:
	CALL SUBOPT_0x3D
	__GETD1N 0x42820000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x104
	LDI  R30,LOW(13)
	MOV  R10,R30
; 0000 026E         else if (temp_ampl> 60  )   viz_ampl=12;
	RJMP _0x105
_0x104:
	CALL SUBOPT_0x3D
	__GETD1N 0x42700000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x106
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 026F         else if (temp_ampl> 55  )   viz_ampl=11;
	RJMP _0x107
_0x106:
	CALL SUBOPT_0x3D
	__GETD1N 0x425C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x108
	LDI  R30,LOW(11)
	MOV  R10,R30
; 0000 0270         else if (temp_ampl> 50  )   viz_ampl=10;
	RJMP _0x109
_0x108:
	CALL SUBOPT_0x3D
	__GETD1N 0x42480000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10A
	LDI  R30,LOW(10)
	MOV  R10,R30
; 0000 0271         else if (temp_ampl> 45  )   viz_ampl=9;
	RJMP _0x10B
_0x10A:
	CALL SUBOPT_0x3D
	__GETD1N 0x42340000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10C
	LDI  R30,LOW(9)
	MOV  R10,R30
; 0000 0272         else if (temp_ampl> 40  )   viz_ampl=8;
	RJMP _0x10D
_0x10C:
	CALL SUBOPT_0x3D
	__GETD1N 0x42200000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10E
	LDI  R30,LOW(8)
	MOV  R10,R30
; 0000 0273         else if (temp_ampl> 35  )   viz_ampl=7;
	RJMP _0x10F
_0x10E:
	CALL SUBOPT_0x3D
	__GETD1N 0x420C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x110
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 0274         else if (temp_ampl> 30  )   viz_ampl=6;
	RJMP _0x111
_0x110:
	CALL SUBOPT_0x3D
	__GETD1N 0x41F00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x112
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 0275         else if (temp_ampl> 25  )   viz_ampl=5;
	RJMP _0x113
_0x112:
	CALL SUBOPT_0x3D
	__GETD1N 0x41C80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x114
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 0276         else if (temp_ampl> 20  )   viz_ampl=4;
	RJMP _0x115
_0x114:
	CALL SUBOPT_0x3D
	__GETD1N 0x41A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x116
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 0277         else if (temp_ampl> 15  )   viz_ampl=3;
	RJMP _0x117
_0x116:
	CALL SUBOPT_0x3D
	__GETD1N 0x41700000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x118
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 0278         else if (temp_ampl> 10  )   viz_ampl=2;
	RJMP _0x119
_0x118:
	CALL SUBOPT_0x3D
	__GETD1N 0x41200000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11A
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 0279         else if (temp_ampl> 5   )   viz_ampl=1;
	RJMP _0x11B
_0x11A:
	CALL SUBOPT_0x3D
	__GETD1N 0x40A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11C
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 027A         else if (temp_ampl> 0   )   viz_ampl=0;
	RJMP _0x11D
_0x11C:
	CALL SUBOPT_0x3D
	CALL __CPD02
	BRGE _0x11E
	CLR  R10
; 0000 027B 
; 0000 027C         if (temp_faza> 3.14) viz_faza=0;
_0x11E:
_0x11D:
_0x11B:
_0x119:
_0x117:
_0x115:
_0x113:
_0x111:
_0x10F:
_0x10D:
_0x10B:
_0x109:
_0x107:
_0x105:
_0x103:
_0x101:
_0xFF:
_0xFD:
_0xFB:
_0xF9:
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
	CALL SUBOPT_0x3E
	__GETD1N 0x4048F5C3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11F
	CLR  R13
; 0000 027D         else if (temp_faza> 2.944) viz_faza=8;
	RJMP _0x120
_0x11F:
	CALL SUBOPT_0x3E
	__GETD1N 0x403C6A7F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x121
	LDI  R30,LOW(8)
	RJMP _0x1AD
; 0000 027E         else if (temp_faza> 2.748) viz_faza=7;
_0x121:
	CALL SUBOPT_0x3E
	__GETD1N 0x402FDF3B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x123
	LDI  R30,LOW(7)
	RJMP _0x1AD
; 0000 027F         else if (temp_faza> 2.552) viz_faza=6;
_0x123:
	CALL SUBOPT_0x3E
	__GETD1N 0x402353F8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x125
	LDI  R30,LOW(6)
	RJMP _0x1AD
; 0000 0280         else if (temp_faza> 2.356) viz_faza=5;
_0x125:
	CALL SUBOPT_0x3E
	__GETD1N 0x4016C8B4
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x127
	LDI  R30,LOW(5)
	RJMP _0x1AD
; 0000 0281         else if (temp_faza> 2.160) viz_faza=4;
_0x127:
	CALL SUBOPT_0x3E
	__GETD1N 0x400A3D71
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x129
	LDI  R30,LOW(4)
	RJMP _0x1AD
; 0000 0282         else if (temp_faza> 1.964) viz_faza=3;
_0x129:
	CALL SUBOPT_0x3E
	__GETD1N 0x3FFB645A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12B
	LDI  R30,LOW(3)
	RJMP _0x1AD
; 0000 0283         else if (temp_faza> 1.768) viz_faza=2;
_0x12B:
	CALL SUBOPT_0x3E
	__GETD1N 0x3FE24DD3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12D
	LDI  R30,LOW(2)
	RJMP _0x1AD
; 0000 0284         else if (temp_faza> 1.572) viz_faza=1;
_0x12D:
	CALL SUBOPT_0x3E
	__GETD1N 0x3FC9374C
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12F
	LDI  R30,LOW(1)
	RJMP _0x1AD
; 0000 0285 
; 0000 0286         else if (temp_faza> 1.376) viz_faza=9;
_0x12F:
	CALL SUBOPT_0x3E
	__GETD1N 0x3FB020C5
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x131
	LDI  R30,LOW(9)
	RJMP _0x1AD
; 0000 0287         else if (temp_faza> 1.180) viz_faza=10;
_0x131:
	CALL SUBOPT_0x3E
	__GETD1N 0x3F970A3D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x133
	LDI  R30,LOW(10)
	RJMP _0x1AD
; 0000 0288         else if (temp_faza> 0.984) viz_faza=11;
_0x133:
	CALL SUBOPT_0x3E
	__GETD1N 0x3F7BE76D
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x135
	LDI  R30,LOW(11)
	RJMP _0x1AD
; 0000 0289         else if (temp_faza> 0.788) viz_faza=12;
_0x135:
	CALL SUBOPT_0x3E
	__GETD1N 0x3F49BA5E
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x137
	LDI  R30,LOW(12)
	RJMP _0x1AD
; 0000 028A         else if (temp_faza> 0.592) viz_faza=13;
_0x137:
	CALL SUBOPT_0x3E
	__GETD1N 0x3F178D50
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x139
	LDI  R30,LOW(13)
	RJMP _0x1AD
; 0000 028B         else if (temp_faza> 0.396) viz_faza=14;
_0x139:
	CALL SUBOPT_0x3E
	__GETD1N 0x3ECAC083
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13B
	LDI  R30,LOW(14)
	RJMP _0x1AD
; 0000 028C         else if (temp_faza> 0.200) viz_faza=15;
_0x13B:
	CALL SUBOPT_0x3E
	__GETD1N 0x3E4CCCCD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13D
	LDI  R30,LOW(15)
	RJMP _0x1AD
; 0000 028D         else if (temp_faza> 0.000) viz_faza=16;
_0x13D:
	CALL SUBOPT_0x3E
	CALL __CPD02
	BRGE _0x13F
	LDI  R30,LOW(16)
_0x1AD:
	MOV  R13,R30
; 0000 028E         };
_0x13F:
_0x120:
_0xBD:
; 0000 028F 
; 0000 0290       if (rezym == 1)
	LDI  R26,0
	SBRC R3,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x140
; 0000 0291         {
; 0000 0292         if      (Y > 160 )     viz_ampl=32;
	LDI  R30,LOW(160)
	CP   R30,R11
	BRSH _0x141
	LDI  R30,LOW(32)
	MOV  R10,R30
; 0000 0293         else if (Y > 155 )     viz_ampl=31;
	RJMP _0x142
_0x141:
	LDI  R30,LOW(155)
	CP   R30,R11
	BRSH _0x143
	LDI  R30,LOW(31)
	MOV  R10,R30
; 0000 0294         else if (Y > 150 )     viz_ampl=30;
	RJMP _0x144
_0x143:
	LDI  R30,LOW(150)
	CP   R30,R11
	BRSH _0x145
	LDI  R30,LOW(30)
	MOV  R10,R30
; 0000 0295         else if (Y > 145 )     viz_ampl=29;
	RJMP _0x146
_0x145:
	LDI  R30,LOW(145)
	CP   R30,R11
	BRSH _0x147
	LDI  R30,LOW(29)
	MOV  R10,R30
; 0000 0296         else if (Y > 140 )     viz_ampl=28;
	RJMP _0x148
_0x147:
	LDI  R30,LOW(140)
	CP   R30,R11
	BRSH _0x149
	LDI  R30,LOW(28)
	MOV  R10,R30
; 0000 0297         else if (Y > 135 )     viz_ampl=27;
	RJMP _0x14A
_0x149:
	LDI  R30,LOW(135)
	CP   R30,R11
	BRSH _0x14B
	LDI  R30,LOW(27)
	MOV  R10,R30
; 0000 0298         else if (Y > 130 )     viz_ampl=26;
	RJMP _0x14C
_0x14B:
	LDI  R30,LOW(130)
	CP   R30,R11
	BRSH _0x14D
	LDI  R30,LOW(26)
	MOV  R10,R30
; 0000 0299         else if (Y > 125 )     viz_ampl=25;
	RJMP _0x14E
_0x14D:
	LDI  R30,LOW(125)
	CP   R30,R11
	BRSH _0x14F
	LDI  R30,LOW(25)
	MOV  R10,R30
; 0000 029A         else if (Y > 120 )     viz_ampl=24;
	RJMP _0x150
_0x14F:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRSH _0x151
	LDI  R30,LOW(24)
	MOV  R10,R30
; 0000 029B         else if (Y > 115 )     viz_ampl=23;
	RJMP _0x152
_0x151:
	LDI  R30,LOW(115)
	CP   R30,R11
	BRSH _0x153
	LDI  R30,LOW(23)
	MOV  R10,R30
; 0000 029C         else if (Y > 110 )     viz_ampl=22;
	RJMP _0x154
_0x153:
	LDI  R30,LOW(110)
	CP   R30,R11
	BRSH _0x155
	LDI  R30,LOW(22)
	MOV  R10,R30
; 0000 029D         else if (Y > 105 )     viz_ampl=21;
	RJMP _0x156
_0x155:
	LDI  R30,LOW(105)
	CP   R30,R11
	BRSH _0x157
	LDI  R30,LOW(21)
	MOV  R10,R30
; 0000 029E         else if (Y > 100 )     viz_ampl=20;
	RJMP _0x158
_0x157:
	LDI  R30,LOW(100)
	CP   R30,R11
	BRSH _0x159
	LDI  R30,LOW(20)
	MOV  R10,R30
; 0000 029F         else if (Y > 95  )     viz_ampl=19;
	RJMP _0x15A
_0x159:
	LDI  R30,LOW(95)
	CP   R30,R11
	BRSH _0x15B
	LDI  R30,LOW(19)
	MOV  R10,R30
; 0000 02A0         else if (Y > 90  )     viz_ampl=18; //___
	RJMP _0x15C
_0x15B:
	LDI  R30,LOW(90)
	CP   R30,R11
	BRSH _0x15D
	LDI  R30,LOW(18)
	MOV  R10,R30
; 0000 02A1         else if (Y > 85  )     viz_ampl=17;
	RJMP _0x15E
_0x15D:
	LDI  R30,LOW(85)
	CP   R30,R11
	BRSH _0x15F
	LDI  R30,LOW(17)
	MOV  R10,R30
; 0000 02A2         else if (Y > 80  )     viz_ampl=16; //___
	RJMP _0x160
_0x15F:
	LDI  R30,LOW(80)
	CP   R30,R11
	BRSH _0x161
	LDI  R30,LOW(16)
	MOV  R10,R30
; 0000 02A3         else if (Y > 75  )     viz_ampl=15;
	RJMP _0x162
_0x161:
	LDI  R30,LOW(75)
	CP   R30,R11
	BRSH _0x163
	LDI  R30,LOW(15)
	MOV  R10,R30
; 0000 02A4         else if (Y > 70  )     viz_ampl=14;
	RJMP _0x164
_0x163:
	LDI  R30,LOW(70)
	CP   R30,R11
	BRSH _0x165
	LDI  R30,LOW(14)
	MOV  R10,R30
; 0000 02A5         else if (Y > 65  )     viz_ampl=13;
	RJMP _0x166
_0x165:
	LDI  R30,LOW(65)
	CP   R30,R11
	BRSH _0x167
	LDI  R30,LOW(13)
	MOV  R10,R30
; 0000 02A6         else if (Y > 60  )     viz_ampl=12;
	RJMP _0x168
_0x167:
	LDI  R30,LOW(60)
	CP   R30,R11
	BRSH _0x169
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 02A7         else if (Y > 55  )     viz_ampl=11;
	RJMP _0x16A
_0x169:
	LDI  R30,LOW(55)
	CP   R30,R11
	BRSH _0x16B
	LDI  R30,LOW(11)
	MOV  R10,R30
; 0000 02A8         else if (Y > 50  )     viz_ampl=10;
	RJMP _0x16C
_0x16B:
	LDI  R30,LOW(50)
	CP   R30,R11
	BRSH _0x16D
	LDI  R30,LOW(10)
	MOV  R10,R30
; 0000 02A9         else if (Y > 45  )     viz_ampl=9;
	RJMP _0x16E
_0x16D:
	LDI  R30,LOW(45)
	CP   R30,R11
	BRSH _0x16F
	LDI  R30,LOW(9)
	MOV  R10,R30
; 0000 02AA         else if (Y > 40  )     viz_ampl=8;
	RJMP _0x170
_0x16F:
	LDI  R30,LOW(40)
	CP   R30,R11
	BRSH _0x171
	LDI  R30,LOW(8)
	MOV  R10,R30
; 0000 02AB         else if (Y > 35  )     viz_ampl=7;
	RJMP _0x172
_0x171:
	LDI  R30,LOW(35)
	CP   R30,R11
	BRSH _0x173
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 02AC         else if (Y > 30  )     viz_ampl=6;
	RJMP _0x174
_0x173:
	LDI  R30,LOW(30)
	CP   R30,R11
	BRSH _0x175
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 02AD         else if (Y > 25  )     viz_ampl=5;
	RJMP _0x176
_0x175:
	LDI  R30,LOW(25)
	CP   R30,R11
	BRSH _0x177
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 02AE         else if (Y > 20  )     viz_ampl=4;
	RJMP _0x178
_0x177:
	LDI  R30,LOW(20)
	CP   R30,R11
	BRSH _0x179
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 02AF         else if (Y > 15  )     viz_ampl=3;
	RJMP _0x17A
_0x179:
	LDI  R30,LOW(15)
	CP   R30,R11
	BRSH _0x17B
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 02B0         else if (Y > 10  )     viz_ampl=2;
	RJMP _0x17C
_0x17B:
	LDI  R30,LOW(10)
	CP   R30,R11
	BRSH _0x17D
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 02B1         else if (Y > 5   )     viz_ampl=1;
	RJMP _0x17E
_0x17D:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRSH _0x17F
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 02B2         else if (Y > 0   )     viz_ampl=0;
	RJMP _0x180
_0x17F:
	LDI  R30,LOW(0)
	CP   R30,R11
	BRSH _0x181
	CLR  R10
; 0000 02B3 
; 0000 02B4         if      (X > 150 )     viz_faza=8;
_0x181:
_0x180:
_0x17E:
_0x17C:
_0x17A:
_0x178:
_0x176:
_0x174:
_0x172:
_0x170:
_0x16E:
_0x16C:
_0x16A:
_0x168:
_0x166:
_0x164:
_0x162:
_0x160:
_0x15E:
_0x15C:
_0x15A:
_0x158:
_0x156:
_0x154:
_0x152:
_0x150:
_0x14E:
_0x14C:
_0x14A:
_0x148:
_0x146:
_0x144:
_0x142:
	LDI  R30,LOW(150)
	CP   R30,R8
	BRSH _0x182
	LDI  R30,LOW(8)
	RJMP _0x1AE
; 0000 02B5         else if (X > 140 )     viz_faza=7;
_0x182:
	LDI  R30,LOW(140)
	CP   R30,R8
	BRSH _0x184
	LDI  R30,LOW(7)
	RJMP _0x1AE
; 0000 02B6         else if (X > 130 )     viz_faza=6;
_0x184:
	LDI  R30,LOW(130)
	CP   R30,R8
	BRSH _0x186
	LDI  R30,LOW(6)
	RJMP _0x1AE
; 0000 02B7         else if (X > 120 )     viz_faza=5;
_0x186:
	LDI  R30,LOW(120)
	CP   R30,R8
	BRSH _0x188
	LDI  R30,LOW(5)
	RJMP _0x1AE
; 0000 02B8         else if (X > 110 )     viz_faza=4;
_0x188:
	LDI  R30,LOW(110)
	CP   R30,R8
	BRSH _0x18A
	LDI  R30,LOW(4)
	RJMP _0x1AE
; 0000 02B9         else if (X > 100 )     viz_faza=3;
_0x18A:
	LDI  R30,LOW(100)
	CP   R30,R8
	BRSH _0x18C
	LDI  R30,LOW(3)
	RJMP _0x1AE
; 0000 02BA         else if (X > 90  )     viz_faza=2;
_0x18C:
	LDI  R30,LOW(90)
	CP   R30,R8
	BRSH _0x18E
	LDI  R30,LOW(2)
	RJMP _0x1AE
; 0000 02BB         else if (X > 80  )     viz_faza=1;
_0x18E:
	LDI  R30,LOW(80)
	CP   R30,R8
	BRSH _0x190
	LDI  R30,LOW(1)
	RJMP _0x1AE
; 0000 02BC         else if (X > 70  )     viz_faza=9;
_0x190:
	LDI  R30,LOW(70)
	CP   R30,R8
	BRSH _0x192
	LDI  R30,LOW(9)
	RJMP _0x1AE
; 0000 02BD         else if (X > 60  )     viz_faza=10;
_0x192:
	LDI  R30,LOW(60)
	CP   R30,R8
	BRSH _0x194
	LDI  R30,LOW(10)
	RJMP _0x1AE
; 0000 02BE         else if (X > 50  )     viz_faza=11;
_0x194:
	LDI  R30,LOW(50)
	CP   R30,R8
	BRSH _0x196
	LDI  R30,LOW(11)
	RJMP _0x1AE
; 0000 02BF         else if (X > 40  )     viz_faza=12;
_0x196:
	LDI  R30,LOW(40)
	CP   R30,R8
	BRSH _0x198
	LDI  R30,LOW(12)
	RJMP _0x1AE
; 0000 02C0         else if (X > 30  )     viz_faza=13;
_0x198:
	LDI  R30,LOW(30)
	CP   R30,R8
	BRSH _0x19A
	LDI  R30,LOW(13)
	RJMP _0x1AE
; 0000 02C1         else if (X > 20  )     viz_faza=14;
_0x19A:
	LDI  R30,LOW(20)
	CP   R30,R8
	BRSH _0x19C
	LDI  R30,LOW(14)
	RJMP _0x1AE
; 0000 02C2         else if (X > 10  )     viz_faza=15;
_0x19C:
	LDI  R30,LOW(10)
	CP   R30,R8
	BRSH _0x19E
	LDI  R30,LOW(15)
	RJMP _0x1AE
; 0000 02C3         else if (X > 0   )     viz_faza=16;
_0x19E:
	LDI  R30,LOW(0)
	CP   R30,R8
	BRSH _0x1A0
	LDI  R30,LOW(16)
_0x1AE:
	MOV  R13,R30
; 0000 02C4         };
_0x1A0:
_0x140:
; 0000 02C5 
; 0000 02C6       batt_zarqd();
	CALL _batt_zarqd
; 0000 02C7       lcd_disp();
	CALL _lcd_disp
; 0000 02C8       zvuk();
	RCALL _zvuk
; 0000 02C9 
; 0000 02CA       delay_ms (200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 02CB       light=0;
	CBI  0x12,6
; 0000 02CC       };
	RJMP _0xB2
; 0000 02CD }
_0x1A3:
	RJMP _0x1A3
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
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x3F
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x40
	LDI  R30,LOW(4)
	CALL SUBOPT_0x40
	LDI  R30,LOW(133)
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x41
_0x202001D:
	RJMP _0x202001A
_0x202001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x202001E
	CPI  R18,37
	BRNE _0x202001F
	CALL SUBOPT_0x41
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
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x43
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x202002E
	CALL SUBOPT_0x44
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x45
	RJMP _0x202002F
_0x202002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2020031
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020032
_0x2020031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2020034
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	CALL _strlenf
	MOV  R17,R30
	CALL SUBOPT_0x42
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
_0x2020032:
	CALL SUBOPT_0x42
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x42
	CALL SUBOPT_0x47
	BREQ _0x2020041
	CALL SUBOPT_0x44
	CALL SUBOPT_0x48
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
	CALL SUBOPT_0x42
	CALL SUBOPT_0x49
_0x2020044:
	RJMP _0x2020045
_0x2020041:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x48
_0x2020045:
_0x2020035:
	CALL SUBOPT_0x4A
	BRNE _0x2020046
_0x2020047:
	CP   R17,R21
	BRSH _0x2020049
	CALL SUBOPT_0x42
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004A
	CALL SUBOPT_0x42
	CALL SUBOPT_0x47
	BREQ _0x202004B
	CALL SUBOPT_0x42
	CALL SUBOPT_0x49
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
	CALL SUBOPT_0x41
	SUBI R21,LOW(1)
	RJMP _0x2020047
_0x2020049:
_0x2020046:
	MOV  R19,R17
	CALL SUBOPT_0x42
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202004E
_0x202004F:
	CPI  R19,0
	BREQ _0x2020051
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x42
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x202005D
	CALL SUBOPT_0x43
	ADIW R30,7
	RJMP _0x20200BE
_0x202005D:
	CALL SUBOPT_0x43
	ADIW R30,39
_0x20200BE:
	MOV  R18,R30
_0x202005C:
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x4A
	BREQ _0x2020067
_0x2020066:
	RJMP _0x2020065
_0x2020067:
	LDI  R18,LOW(32)
	CALL SUBOPT_0x42
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
	CALL SUBOPT_0x42
	CALL SUBOPT_0x47
	BREQ _0x2020069
	CALL SUBOPT_0x42
	CALL SUBOPT_0x49
	ST   -Y,R20
	CALL SUBOPT_0x45
	CPI  R21,0
	BREQ _0x202006A
	SUBI R21,LOW(1)
_0x202006A:
_0x2020069:
_0x2020068:
_0x2020060:
	CALL SUBOPT_0x41
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
	CALL SUBOPT_0x4A
	BREQ _0x202006C
_0x202006D:
	CPI  R21,0
	BREQ _0x202006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x1F
	CALL _ftrunc
	CALL SUBOPT_0x1C
    brne __floor1
__floor0:
	CALL SUBOPT_0x1D
	RJMP _0x20C0003
__floor1:
    brtc __floor0
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	RJMP _0x20C0003
_sin:
	CALL SUBOPT_0x4D
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	CALL __PUTPARD1
	RCALL _floor
	CALL SUBOPT_0x50
	CALL SUBOPT_0x20
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x51
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0x51
	CALL SUBOPT_0x20
	CALL SUBOPT_0x4E
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0x50
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0x51
	CALL __SUBF12
	CALL SUBOPT_0x4E
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0x52
_0x2040019:
	CALL SUBOPT_0x53
	__PUTD1S 1
	CALL SUBOPT_0x54
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x20
	CALL SUBOPT_0x55
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x50
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x54
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x55
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20C0002
_cos:
	CALL SUBOPT_0x4B
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0003
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x56
	CALL SUBOPT_0x57
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x58
	CALL SUBOPT_0x57
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1D
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x58
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x4B
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x1F
	RCALL _xatan
	RJMP _0x20C0003
_0x2040020:
	CALL SUBOPT_0x4B
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x59
	CALL SUBOPT_0x21
	RCALL _xatan
	CALL SUBOPT_0x5A
	RJMP _0x20C0003
_0x2040021:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4C
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x59
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x21
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0003:
	ADIW R28,4
	RET
_asin:
	CALL SUBOPT_0x4D
	__GETD1N 0xBF800000
	CALL __CMPF12
	BRLO _0x2040023
	CALL SUBOPT_0x50
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
	CALL SUBOPT_0x52
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0x53
	__GETD2N 0x3F800000
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	__PUTD1S 1
	CALL SUBOPT_0x50
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0x4F
	__GETD2S 1
	CALL SUBOPT_0x21
	RCALL _yatan
	CALL SUBOPT_0x5A
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0x54
	CALL SUBOPT_0x50
	CALL SUBOPT_0x21
	RCALL _yatan
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0x54
	CALL __ANEGF1
	RJMP _0x20C0002
_0x2040028:
	CALL SUBOPT_0x54
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,9
	RET
_atan2:
	SBIW R28,4
	CALL SUBOPT_0x56
	CALL __CPD10
	BRNE _0x204002D
	__GETD1S 8
	CALL __CPD10
	BRNE _0x204002E
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0001
_0x204002E:
	CALL SUBOPT_0x19
	CALL __CPD02
	BRGE _0x204002F
	__GETD1N 0x3FC90FDB
	RJMP _0x20C0001
_0x204002F:
	__GETD1N 0xBFC90FDB
	RJMP _0x20C0001
_0x204002D:
	CALL SUBOPT_0x56
	CALL SUBOPT_0x19
	CALL __DIVF21
	CALL SUBOPT_0x1C
	__GETD2S 4
	CALL __CPD02
	BRGE _0x2040030
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040031
	CALL SUBOPT_0x1F
	RCALL _yatan
	RJMP _0x20C0001
_0x2040031:
	CALL SUBOPT_0x5B
	CALL __ANEGF1
	RJMP _0x20C0001
_0x2040030:
	LDD  R26,Y+11
	TST  R26
	BRMI _0x2040032
	CALL SUBOPT_0x5B
	__GETD2N 0x40490FDB
	CALL SUBOPT_0x20
	RJMP _0x20C0001
_0x2040032:
	CALL SUBOPT_0x1F
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
_temp_ampl:
	.BYTE 0x4
_temp_faza:
	.BYTE 0x4
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x4:
	SBI  0x12,6
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 82 TIMES, CODE SIZE REDUCTION:159 WORDS
SUBOPT_0x5:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	MOV  R30,R9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 92 TIMES, CODE SIZE REDUCTION:179 WORDS
SUBOPT_0x9:
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

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
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x14:
	CALL __PUTPARD1
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 87 TIMES, CODE SIZE REDUCTION:169 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x17:
	CALL __PUTPARD1
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__GETD1S 12
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL __PUTPARD1
	JMP  _sqrt

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1D:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x1D
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x20:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x23:
	MOV  R30,R11
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R5
	ST   -Y,R4
	ST   -Y,R7
	ST   -Y,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x24:
	STS  _temp_ampl,R30
	STS  _temp_ampl+1,R31
	STS  _temp_ampl+2,R22
	STS  _temp_ampl+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	STS  _now_ampl,R30
	STS  _now_ampl+1,R31
	STS  _now_ampl+2,R22
	STS  _now_ampl+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	STS  _now_faza,R30
	STS  _now_faza+1,R31
	STS  _now_faza+2,R22
	STS  _now_faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x27:
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x28:
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
SUBOPT_0x29:
	LDS  R26,_bar_rad
	LDS  R27,_bar_rad+1
	LDS  R24,_bar_rad+2
	LDS  R25,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
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
SUBOPT_0x2B:
	LDS  R26,_now_ampl
	LDS  R27,_now_ampl+1
	LDS  R24,_now_ampl+2
	LDS  R25,_now_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2C:
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
SUBOPT_0x2D:
	RCALL SUBOPT_0x2B
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
SUBOPT_0x2E:
	LDS  R30,_now_ampl
	LDS  R31,_now_ampl+1
	LDS  R22,_now_ampl+2
	LDS  R23,_now_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2F:
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
SUBOPT_0x30:
	RCALL SUBOPT_0x2E
	CALL __PUTPARD1
	LDS  R30,_now_faza
	LDS  R31,_now_faza+1
	LDS  R22,_now_faza+2
	LDS  R23,_now_faza+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	LDS  R30,_gnd_ampl
	LDS  R31,_gnd_ampl+1
	LDS  R22,_gnd_ampl+2
	LDS  R23,_gnd_ampl+3
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x32:
	LDS  R30,_temp_ampl
	LDS  R31,_temp_ampl+1
	LDS  R22,_temp_ampl+2
	LDS  R23,_temp_ampl+3
	CALL __PUTPARD1
	MOV  R30,R11
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R8
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x33:
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	LDS  R30,_gnd_faza
	LDS  R31,_gnd_faza+1
	LDS  R22,_gnd_faza+2
	LDS  R23,_gnd_faza+3
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x27
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
SUBOPT_0x36:
	RCALL SUBOPT_0x29
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
SUBOPT_0x37:
	RCALL SUBOPT_0x2B
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
SUBOPT_0x38:
	RCALL SUBOPT_0x2B
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
SUBOPT_0x39:
	RCALL SUBOPT_0x2E
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
SUBOPT_0x3A:
	LDS  R30,_rock_ampl
	LDS  R31,_rock_ampl+1
	LDS  R22,_rock_ampl+2
	LDS  R23,_rock_ampl+3
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	CALL _th_cos
	RCALL SUBOPT_0x24
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDS  R30,_rock_faza
	LDS  R31,_rock_faza+1
	LDS  R22,_rock_faza+2
	LDS  R23,_rock_faza+3
	RJMP SUBOPT_0x33

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:189 WORDS
SUBOPT_0x3D:
	LDS  R26,_temp_ampl
	LDS  R27,_temp_ampl+1
	LDS  R24,_temp_ampl+2
	LDS  R25,_temp_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x3E:
	LDS  R26,_temp_faza
	LDS  R27,_temp_faza+1
	LDS  R24,_temp_faza+2
	LDS  R25,_temp_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x41:
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
SUBOPT_0x42:
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x45:
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
SUBOPT_0x46:
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
SUBOPT_0x47:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	MOV  R30,R16
	LDI  R31,0
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	__GETD1N 0x3F800000
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4D:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4E:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4F:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x50:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	RCALL SUBOPT_0x50
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	RCALL SUBOPT_0x4F
	CALL __ANEGF1
	RJMP SUBOPT_0x4E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x4F
	RCALL SUBOPT_0x50
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	__GETD2S 4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x58:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	RCALL SUBOPT_0x1D
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	__GETD2N 0x3FC90FDB
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	RCALL SUBOPT_0x1D
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
