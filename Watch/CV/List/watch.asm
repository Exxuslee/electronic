
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 20,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	.DEF _m=R5
	.DEF _h=R4
	.DEF _s=R7
	.DEF _seg0=R6
	.DEF _seg1=R9
	.DEF _seg2=R8
	.DEF _seg3=R11
	.DEF _i=R10

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
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
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 22.05.2014
;Author  : NeVaDa
;Company : Home
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 20,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
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
;
;#define _0 PORTB.0
;#define _1 PORTB.1
;#define _2 PORTB.2
;#define _3 PORTB.3
;
;#define _A PORTD.0
;#define _B PORTD.1
;#define _C PORTD.2
;#define _D PORTD.3
;#define _E PORTD.4
;#define _F PORTD.5
;#define _G PORTD.6
;#define _P PORTD.7
;
;#define ADC_VREF_TYPE 0xE0
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 002E {

	.CSEG
_read_adc:
; 0000 002F ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xE0)
	OUT  0x7,R30
; 0000 0030 // Delay needed for the stabilization of the ADC input voltage
; 0000 0031 delay_us(10);
	__DELAY_USB 67
; 0000 0032 // Start the AD conversion
; 0000 0033 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0034 // Wait for the AD conversion to complete
; 0000 0035 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0036 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0037 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0038 }
;
;
;// Declare your global variables here
;unsigned char m,h,s; //часы, минуты, секунды
;unsigned char seg0, seg1, seg2, seg3, i;
;
;
;void codegen (char x, char y)
; 0000 0041 {
_codegen:
; 0000 0042      if (y==0)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=0;
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x12,4
	SBI  0x12,5
	RJMP _0x19F
; 0000 0043 else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x16
	CBI  0x12,0
	SBI  0x12,1
	SBI  0x12,2
	RJMP _0x1A0
; 0000 0044 else if (y==2)  _A=1,_B=1,_C=0,_D=1,_E=1,_F=0,_G=1;
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x26
	RCALL SUBOPT_0x0
	CBI  0x12,2
	SBI  0x12,3
	SBI  0x12,4
	CBI  0x12,5
	SBI  0x12,6
; 0000 0045 else if (y==3)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=0,_G=1;
	RJMP _0x35
_0x26:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x36
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	SBI  0x12,6
; 0000 0046 else if (y==4)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=1,_G=1;
	RJMP _0x45
_0x36:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x46
	CBI  0x12,0
	SBI  0x12,1
	SBI  0x12,2
	RCALL SUBOPT_0x3
	SBI  0x12,6
; 0000 0047 else if (y==5)  _A=1,_B=0,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x55
_0x46:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x56
	SBI  0x12,0
	CBI  0x12,1
	RCALL SUBOPT_0x1
	CBI  0x12,4
	RCALL SUBOPT_0x4
; 0000 0048 else if (y==6)  _A=1,_B=0,_C=1,_D=1,_E=1,_F=1,_G=1;
	RJMP _0x65
_0x56:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x66
	SBI  0x12,0
	CBI  0x12,1
	RCALL SUBOPT_0x1
	SBI  0x12,4
	RCALL SUBOPT_0x4
; 0000 0049 else if (y==7)  _A=1,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
	RJMP _0x75
_0x66:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x76
	RCALL SUBOPT_0x0
	SBI  0x12,2
	RJMP _0x1A0
; 0000 004A else if (y==8)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=1;
_0x76:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x86
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x12,4
	RCALL SUBOPT_0x4
; 0000 004B else if (y==9)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x95
_0x86:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x96
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CBI  0x12,4
	RCALL SUBOPT_0x4
; 0000 004C else            _A=0,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xA5
_0x96:
	RCALL SUBOPT_0x5
_0x1A0:
	CBI  0x12,3
	RCALL SUBOPT_0x2
_0x19F:
	CBI  0x12,6
; 0000 004D 
; 0000 004E      if  (i== 1) _A=0,_B=0,_C=0,_D=0,_E=0,_F=1,_G=0;
_0xA5:
_0x95:
_0x75:
_0x65:
_0x55:
_0x45:
_0x35:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xB4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	CBI  0x12,6
; 0000 004F else if  (i== 2) _A=1,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xC3
_0xB4:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xC4
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x2
	CBI  0x12,6
; 0000 0050 else if  (i== 3) _A=0,_B=1,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xD3
_0xC4:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xD4
	CBI  0x12,0
	SBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
	RCALL SUBOPT_0x2
	CBI  0x12,6
; 0000 0051 else if  (i== 4) _A=0,_B=0,_C=1,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xE3
_0xD4:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xE4
	CBI  0x12,0
	CBI  0x12,1
	SBI  0x12,2
	CBI  0x12,3
	RCALL SUBOPT_0x2
	CBI  0x12,6
; 0000 0052 else if  (i== 5) _A=0,_B=0,_C=0,_D=1,_E=0,_F=0,_G=0;
	RJMP _0xF3
_0xE4:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0xF4
	RCALL SUBOPT_0x5
	SBI  0x12,3
	RCALL SUBOPT_0x2
	CBI  0x12,6
; 0000 0053 else if  (i== 6) _A=0,_B=0,_C=0,_D=0,_E=1,_F=0,_G=0;
	RJMP _0x103
_0xF4:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x104
	RCALL SUBOPT_0x5
	CBI  0x12,3
	SBI  0x12,4
	CBI  0x12,5
	CBI  0x12,6
; 0000 0054 else if  (i== 7) _A=0,_B=0,_C=0,_D=0,_E=0,_F=1,_G=0;
	RJMP _0x113
_0x104:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x114
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	CBI  0x12,6
; 0000 0055 else if  (i== 8) _A=1,_B=0,_C=0,_D=0,_E=0,_G=0;
	RJMP _0x123
_0x114:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x124
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x7
; 0000 0056 else if  (i== 9) _B=1,_C=0,_D=0,_E=0,_G=0;
	RJMP _0x131
_0x124:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0x132
	SBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
	RCALL SUBOPT_0x7
; 0000 0057 else if  (i==10) _C=1,_D=0,_E=0,_G=0;
	RJMP _0x13D
_0x132:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0x13E
	SBI  0x12,2
	CBI  0x12,3
	RCALL SUBOPT_0x7
; 0000 0058 else if  (i==11) _D=1,_E=0,_G=0;
	RJMP _0x147
_0x13E:
	LDI  R30,LOW(11)
	CP   R30,R10
	BRNE _0x148
	SBI  0x12,3
	RCALL SUBOPT_0x7
; 0000 0059 else if  (i==12) _E=1,_G=0;
	RJMP _0x14F
_0x148:
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0x150
	SBI  0x12,4
	CBI  0x12,6
; 0000 005A else if  (i==13) _G=1;
	RJMP _0x155
_0x150:
	LDI  R30,LOW(13)
	CP   R30,R10
	BRNE _0x156
	SBI  0x12,6
; 0000 005B 
; 0000 005C if (x==0) _0=0, _1=1, _2=1, _3=1, _P=0;
_0x156:
_0x155:
_0x14F:
_0x147:
_0x13D:
_0x131:
_0x123:
_0x113:
_0x103:
_0xF3:
_0xE3:
_0xD3:
_0xC3:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x159
	CBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
	SBI  0x18,3
	CBI  0x12,7
; 0000 005D if (x==1) _0=1, _1=0, _2=1, _3=1, _P=1;
_0x159:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x164
	SBI  0x18,0
	CBI  0x18,1
	SBI  0x18,2
	SBI  0x18,3
	SBI  0x12,7
; 0000 005E if (x==2) _0=1, _1=1, _2=0, _3=1, _P=0;
_0x164:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x16F
	SBI  0x18,0
	SBI  0x18,1
	CBI  0x18,2
	SBI  0x18,3
	CBI  0x12,7
; 0000 005F if (x==3) _0=1, _1=1, _2=1, _3=0, _P=0;
_0x16F:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x17A
	SBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
	CBI  0x18,3
	CBI  0x12,7
; 0000 0060 delay_ms(1);
_0x17A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0061 _0=1, _1=1, _2=1, _3=1, _P=0;
	SBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
	SBI  0x18,3
	CBI  0x12,7
; 0000 0062 }
	ADIW R28,2
	RET
;
;void preobr()
; 0000 0065 {
_preobr:
; 0000 0066 seg0=m/10;
	MOV  R26,R5
	RCALL SUBOPT_0x8
	MOV  R6,R30
; 0000 0067 seg1=m%10;
	MOV  R26,R5
	RCALL SUBOPT_0x9
	MOV  R9,R30
; 0000 0068 seg2=s/10;
	MOV  R26,R7
	RCALL SUBOPT_0x8
	MOV  R8,R30
; 0000 0069 seg3=s%10;
	MOV  R26,R7
	RCALL SUBOPT_0x9
	MOV  R11,R30
; 0000 006A }
	RET
;
;void indik ()
; 0000 006D {
_indik:
; 0000 006E unsigned char j;
; 0000 006F 
; 0000 0070 for (i=1; i<=13; i++)
	ST   -Y,R17
;	j -> R17
	LDI  R30,LOW(1)
	MOV  R10,R30
_0x190:
	LDI  R30,LOW(13)
	CP   R30,R10
	BRLO _0x191
; 0000 0071     {
; 0000 0072     for (j=0; j<=10; j++)
	LDI  R17,LOW(0)
_0x193:
	CPI  R17,11
	BRSH _0x194
; 0000 0073         {
; 0000 0074         codegen (0, seg0);
	RCALL SUBOPT_0xA
; 0000 0075         codegen (1, seg1);
; 0000 0076         codegen (2, seg2);
; 0000 0077         codegen (3, seg3);
; 0000 0078         }
	SUBI R17,-1
	RJMP _0x193
_0x194:
; 0000 0079     }
	INC  R10
	RJMP _0x190
_0x191:
; 0000 007A i=0;
	CLR  R10
; 0000 007B }
	LD   R17,Y+
	RET
;
;
;// Timer 1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0080 {
_timer1_compa_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0081  s++;
	INC  R7
; 0000 0082  if (s>59)
	LDI  R30,LOW(59)
	CP   R30,R7
	BRSH _0x195
; 0000 0083         {
; 0000 0084         s=0;
	CLR  R7
; 0000 0085         m++;
	INC  R5
; 0000 0086         if (m>59)
	CP   R30,R5
	BRSH _0x196
; 0000 0087                 {
; 0000 0088                 m=0;
	CLR  R5
; 0000 0089                 h++;
	INC  R4
; 0000 008A                 if (h>23) h=0;
	LDI  R30,LOW(23)
	CP   R30,R4
	BRSH _0x197
	CLR  R4
; 0000 008B                 }
_0x197:
; 0000 008C         }
_0x196:
; 0000 008D  TCNT1=0;
_0x195:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 008E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;void main(void)
; 0000 0091 {
_main:
; 0000 0092 // Declare your local variables here
; 0000 0093 
; 0000 0094 // Input/Output Ports initialization
; 0000 0095 // Port B initialization
; 0000 0096 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0097 // State7=T State6=T State5=P State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0098 PORTB=0x20;
	LDI  R30,LOW(32)
	OUT  0x18,R30
; 0000 0099 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 009A 
; 0000 009B // Port C hitialization
; 0000 009C // Func6=h Func5=h Func4=h Func3=h Func2=h Func1=h Func0=h
; 0000 009D // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009E PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 009F DDRC=0x00;
	OUT  0x14,R30
; 0000 00A0 
; 0000 00A1 // Port D hitialization
; 0000 00A2 // Func7=h Func6=h Func5=h Func4=h Func3=h Func2=h Func1=h Func0=h
; 0000 00A3 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00A4 PORTD=0x00;
	OUT  0x12,R30
; 0000 00A5 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00A6 
; 0000 00A7 // Timer/Counter 0 hitialization
; 0000 00A8 // Clock source: System Clock
; 0000 00A9 // Clock value: Timer 0 Stopped
; 0000 00AA TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00AB TCNT0=0x00;
	OUT  0x32,R30
; 0000 00AC 
; 0000 00AD // Timer/Counter 1 initialization
; 0000 00AE // Clock source: System Clock
; 0000 00AF // Clock value: 4,096 kHz
; 0000 00B0 // Mode: Normal top=FFFFh
; 0000 00B1 // OC1A output: Discon.
; 0000 00B2 // OC1B output: Discon.
; 0000 00B3 // Noise Canceler: Off
; 0000 00B4 // Input Capture on Falling Edge
; 0000 00B5 // Timer 1 Overflow Interrupt: Off
; 0000 00B6 // Input Capture Interrupt: Off
; 0000 00B7 // Compare A Match Interrupt: On
; 0000 00B8 // Compare B Match Interrupt: Off
; 0000 00B9 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00BA TCCR1B=0x03;
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 00BB TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00BC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00BD ICR1H=0x00;
	OUT  0x27,R30
; 0000 00BE ICR1L=0x00;
	OUT  0x26,R30
; 0000 00BF OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C0 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C1 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C2 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C3 
; 0000 00C4 // Timer/Counter 2 hitialization
; 0000 00C5 // Clock source: System Clock
; 0000 00C6 // Clock value: Timer2 Stopped
; 0000 00C7 // Mode: Normal top=FFh
; 0000 00C8 // OC2 output: Disconnected
; 0000 00C9 ASSR=0x00;
	OUT  0x22,R30
; 0000 00CA TCCR2=0x00;
	RCALL SUBOPT_0xB
; 0000 00CB TCNT2=0x00;
; 0000 00CC OCR2=0x00;
; 0000 00CD 
; 0000 00CE // External hterrupt(s) hitialization
; 0000 00CF // hT0: Off
; 0000 00D0 // hT1: Off
; 0000 00D1 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00D2 
; 0000 00D3 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D4 TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 00D5 
; 0000 00D6 // Analog Comparator initialization
; 0000 00D7 // Analog Comparator: Off
; 0000 00D8 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D9 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DA SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00DB TCCR2=0x00;
	RCALL SUBOPT_0xB
; 0000 00DC TCNT2=0x00;
; 0000 00DD OCR2=0x00;
; 0000 00DE 
; 0000 00DF // Global enable interrupts
; 0000 00E0 #asm("sei")
	sei
; 0000 00E1 
; 0000 00E2 // ADC initialization
; 0000 00E3 // ADC Clock frequency: 312,500 kHz
; 0000 00E4 // ADC Voltage Reference: Int., cap. on AREF
; 0000 00E5 // Only the 8 most significant bits of
; 0000 00E6 // the AD conversion result are used
; 0000 00E7 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(224)
	OUT  0x7,R30
; 0000 00E8 ADCSRA=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 00E9 
; 0000 00EA h=0, m=0, s=0;
	CLR  R4
	CLR  R5
	CLR  R7
; 0000 00EB 
; 0000 00EC while (1)
_0x198:
; 0000 00ED       {
; 0000 00EE       // Place your code here
; 0000 00EF       if (read_adc(4)>0xB3 && read_adc(5)==0x98)
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	CPI  R30,LOW(0xB4)
	BRLO _0x19C
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	CPI  R30,LOW(0x98)
	BREQ _0x19D
_0x19C:
	RJMP _0x19B
_0x19D:
; 0000 00F0       {
; 0000 00F1       preobr();
	RCALL _preobr
; 0000 00F2       indik();
	RCALL _indik
; 0000 00F3       }
; 0000 00F4 
; 0000 00F5       preobr();
_0x19B:
	RCALL _preobr
; 0000 00F6 
; 0000 00F7       codegen(0,seg0);
	RCALL SUBOPT_0xA
; 0000 00F8       codegen(1,seg1);
; 0000 00F9       codegen(2,seg2);
; 0000 00FA       codegen(3,seg3);
; 0000 00FB 
; 0000 00FC 
; 0000 00FD       }
	RJMP _0x198
; 0000 00FE  }
_0x19E:
	RJMP _0x19E

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	SBI  0x12,0
	SBI  0x12,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SBI  0x12,2
	SBI  0x12,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CBI  0x12,4
	CBI  0x12,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CBI  0x12,3
	CBI  0x12,4
	SBI  0x12,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SBI  0x12,5
	SBI  0x12,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	SBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CBI  0x12,4
	CBI  0x12,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R6
	RCALL _codegen
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R9
	RCALL _codegen
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R8
	RCALL _codegen
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R11
	RJMP _codegen

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	OUT  0x25,R30
	OUT  0x24,R30
	OUT  0x23,R30
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1388
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

;END OF CODE MARKER
__END_OF_CODE:
