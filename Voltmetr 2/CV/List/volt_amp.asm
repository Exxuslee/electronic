
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
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
	.DEF _seg0=R5
	.DEF _seg1=R4
	.DEF _seg2=R7
	.DEF _seg3=R6
	.DEF _seg4=R9
	.DEF _seg5=R8
	.DEF _i=R11
	.DEF _j=R10
	.DEF _in_v=R12

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

_0x1A2:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0C
	.DW  _0x1A2*2

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
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
;Date    : 29.07.2012
;Author  : NeVaDa
;Company : MICROSOFT
;Comments:
;
;
;Chip type               : ATmega8A
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
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
;#define _beep PORTD.3
;#define _0 PORTD.0
;#define _1 PORTC.1
;#define _2 PORTC.2
;#define _3 PORTB.2
;#define _4 PORTD.7
;#define _5 PORTD.6
;
;#define _A PORTB.1
;#define _B PORTD.5
;#define _C PORTB.4
;#define _D PORTD.2
;#define _E PORTD.1
;#define _F PORTB.0
;#define _G PORTB.5
;#define _P PORTB.3
;#define ADC_VREF_TYPE 0x40
;
;// Declare your global variables here
;unsigned char seg0, seg1, seg2, seg3, seg4, seg5, i, j;
;//unsigned int adc_data;
;unsigned int in_v=0, in_a=0;
;unsigned int in01=0, in02=0, in03=0, in04=0;
;unsigned int in11=0, in12=0, in13=0, in14=0;
;unsigned int in21=0, in22=0, in23=0, in24=0;
;eeprom float vol_cor, amp_cor;
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0037 {

	.CSEG
_read_adc:
; 0000 0038 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0039 // Delay needed for the stabilization of the ADC input voltage
; 0000 003A delay_us(10);
	__DELAY_USB 53
; 0000 003B // Start the AD conversion
; 0000 003C ADCSRA|=0x40;
	SBI  0x6,6
; 0000 003D // Wait for the AD conversion to complete
; 0000 003E while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 003F ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0040 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0041 }
;
;void codegen (char x, char y)
; 0000 0044 {
_codegen:
; 0000 0045      if (y==0)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=0;
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x6
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x12,1
	SBI  0x18,0
	RJMP _0x19F
; 0000 0046 else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
_0x6:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x16
	CBI  0x18,1
	SBI  0x12,5
	SBI  0x18,4
	RJMP _0x1A0
; 0000 0047 else if (y==2)  _A=1,_B=1,_C=0,_D=1,_E=1,_F=0,_G=1;
_0x16:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x26
	RCALL SUBOPT_0x0
	CBI  0x18,4
	SBI  0x12,2
	SBI  0x12,1
	CBI  0x18,0
	SBI  0x18,5
; 0000 0048 else if (y==3)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=0,_G=1;
	RJMP _0x35
_0x26:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x36
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CBI  0x12,1
	CBI  0x18,0
	SBI  0x18,5
; 0000 0049 else if (y==4)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=1,_G=1;
	RJMP _0x45
_0x36:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x46
	CBI  0x18,1
	SBI  0x12,5
	SBI  0x18,4
	CBI  0x12,2
	RCALL SUBOPT_0x2
; 0000 004A else if (y==5)  _A=1,_B=0,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x55
_0x46:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x56
	SBI  0x18,1
	CBI  0x12,5
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 004B else if (y==6)  _A=1,_B=0,_C=1,_D=1,_E=1,_F=1,_G=1;
	RJMP _0x65
_0x56:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x66
	SBI  0x18,1
	CBI  0x12,5
	RCALL SUBOPT_0x1
	SBI  0x12,1
	SBI  0x18,0
	SBI  0x18,5
; 0000 004C else if (y==7)  _A=1,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
	RJMP _0x75
_0x66:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x76
	RCALL SUBOPT_0x0
	SBI  0x18,4
	RJMP _0x1A0
; 0000 004D else if (y==8)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=1;
_0x76:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x86
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x12,1
	SBI  0x18,0
	SBI  0x18,5
; 0000 004E else if (y==9)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x95
_0x86:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x96
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 004F else            _A=0,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xA5
_0x96:
	CBI  0x18,1
	CBI  0x12,5
	CBI  0x18,4
_0x1A0:
	CBI  0x12,2
	CBI  0x12,1
	CBI  0x18,0
_0x19F:
	CBI  0x18,5
; 0000 0050 
; 0000 0051      if (x==0) _0=0, _1=1, _2=1, _3=1, _4=1, _5=1, _P=0;
_0xA5:
_0x95:
_0x75:
_0x65:
_0x55:
_0x45:
_0x35:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0xB4
	CBI  0x12,0
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RJMP _0x1A1
; 0000 0052 else if (x==1) _0=1, _1=0, _2=1, _3=1, _4=1, _5=1, _P=1;
_0xB4:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0xC4
	SBI  0x12,0
	CBI  0x15,1
	SBI  0x15,2
	RCALL SUBOPT_0x4
	SBI  0x18,3
; 0000 0053 else if (x==2) _0=1, _1=1, _2=0, _3=1, _4=1, _5=1, _P=0;
	RJMP _0xD3
_0xC4:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0xD4
	SBI  0x12,0
	SBI  0x15,1
	CBI  0x15,2
	RCALL SUBOPT_0x4
	RJMP _0x1A1
; 0000 0054 
; 0000 0055 else if (x==3) _0=1, _1=1, _2=1, _3=0, _4=1, _5=1, _P=1;
_0xD4:
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0xE4
	RCALL SUBOPT_0x5
	CBI  0x18,2
	SBI  0x12,7
	SBI  0x12,6
	SBI  0x18,3
; 0000 0056 else if (x==4) _0=1, _1=1, _2=1, _3=1, _4=0, _5=1, _P=0;
	RJMP _0xF3
_0xE4:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0xF4
	RCALL SUBOPT_0x5
	SBI  0x18,2
	CBI  0x12,7
	SBI  0x12,6
	RJMP _0x1A1
; 0000 0057 else           _0=1, _1=1, _2=1, _3=1, _4=1, _5=0, _P=0;
_0xF4:
	RCALL SUBOPT_0x5
	SBI  0x18,2
	SBI  0x12,7
	CBI  0x12,6
_0x1A1:
	CBI  0x18,3
; 0000 0058 
; 0000 0059 delay_us(100);
_0xF3:
_0xD3:
	__DELAY_USW 400
; 0000 005A _0=1, _1=1, _2=1, _3=1, _4=1, _5=1;
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
; 0000 005B return;
	ADIW R28,2
	RET
; 0000 005C }
;
;void read(void)
; 0000 005F {
_read:
; 0000 0060 in01 = in02;
	RCALL SUBOPT_0x6
	STS  _in01,R30
	STS  _in01+1,R31
; 0000 0061 in02 = in03;
	LDS  R30,_in03
	LDS  R31,_in03+1
	STS  _in02,R30
	STS  _in02+1,R31
; 0000 0062 in03 = in04;
	LDS  R30,_in04
	LDS  R31,_in04+1
	STS  _in03,R30
	STS  _in03+1,R31
; 0000 0063 in04 = in11;
	LDS  R30,_in11
	LDS  R31,_in11+1
	STS  _in04,R30
	STS  _in04+1,R31
; 0000 0064 in11 = in12;
	LDS  R30,_in12
	LDS  R31,_in12+1
	STS  _in11,R30
	STS  _in11+1,R31
; 0000 0065 in12 = read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	STS  _in12,R30
	STS  _in12+1,R31
; 0000 0066 in_v = (in01+in02+in03+in04+in11+in12)/6;
	RCALL SUBOPT_0x6
	LDS  R26,_in01
	LDS  R27,_in01+1
	RCALL SUBOPT_0x7
	LDS  R26,_in03
	LDS  R27,_in03+1
	RCALL SUBOPT_0x7
	LDS  R26,_in04
	LDS  R27,_in04+1
	RCALL SUBOPT_0x7
	LDS  R26,_in11
	LDS  R27,_in11+1
	RCALL SUBOPT_0x7
	LDS  R26,_in12
	LDS  R27,_in12+1
	RCALL SUBOPT_0x8
	MOVW R12,R30
; 0000 0067 
; 0000 0068 in13 = in14;
	RCALL SUBOPT_0x9
	STS  _in13,R30
	STS  _in13+1,R31
; 0000 0069 in14 = in21;
	LDS  R30,_in21
	LDS  R31,_in21+1
	STS  _in14,R30
	STS  _in14+1,R31
; 0000 006A in21 = in22;
	LDS  R30,_in22
	LDS  R31,_in22+1
	STS  _in21,R30
	STS  _in21+1,R31
; 0000 006B in22 = in23;
	LDS  R30,_in23
	LDS  R31,_in23+1
	STS  _in22,R30
	STS  _in22+1,R31
; 0000 006C in23 = in24;
	LDS  R30,_in24
	LDS  R31,_in24+1
	STS  _in23,R30
	STS  _in23+1,R31
; 0000 006D in24 = read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	STS  _in24,R30
	STS  _in24+1,R31
; 0000 006E in_a = (in13+in14+in21+in22+in23+in24)/6;
	RCALL SUBOPT_0x9
	LDS  R26,_in13
	LDS  R27,_in13+1
	RCALL SUBOPT_0x7
	LDS  R26,_in21
	LDS  R27,_in21+1
	RCALL SUBOPT_0x7
	LDS  R26,_in22
	LDS  R27,_in22+1
	RCALL SUBOPT_0x7
	LDS  R26,_in23
	LDS  R27,_in23+1
	RCALL SUBOPT_0x7
	LDS  R26,_in24
	LDS  R27,_in24+1
	RCALL SUBOPT_0x8
	STS  _in_a,R30
	STS  _in_a+1,R31
; 0000 006F return;
	RET
; 0000 0070 }
;
;void preobr(float a, float b)
; 0000 0073 {
_preobr:
; 0000 0074 a = a / vol_cor;
;	a -> Y+4
;	b -> Y+0
	LDI  R26,LOW(_vol_cor)
	LDI  R27,HIGH(_vol_cor)
	RCALL __EEPROMRDD
	RCALL SUBOPT_0xA
	RCALL __DIVF21
	RCALL SUBOPT_0xB
; 0000 0075      if (a >= 900)   seg0=9, a=a - 900;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xC
	BRLO _0x11E
	LDI  R30,LOW(9)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xB
; 0000 0076 else if (a >= 800)   seg0=8, a=a - 800;
	RJMP _0x11F
_0x11E:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xF
	BRLO _0x120
	LDI  R30,LOW(8)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xB
; 0000 0077 else if (a >= 700)   seg0=7, a=a - 700;
	RJMP _0x121
_0x120:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x11
	BRLO _0x122
	LDI  R30,LOW(7)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xB
; 0000 0078 else if (a >= 600)   seg0=6, a=a - 600;
	RJMP _0x123
_0x122:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x13
	BRLO _0x124
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xB
; 0000 0079 else if (a >= 500)   seg0=5, a=a - 500;
	RJMP _0x125
_0x124:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x15
	BRLO _0x126
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0xB
; 0000 007A else if (a >= 400)   seg0=4, a=a - 400;
	RJMP _0x127
_0x126:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x17
	BRLO _0x128
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xB
; 0000 007B else if (a >= 300)   seg0=3, a=a - 300;
	RJMP _0x129
_0x128:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x19
	BRLO _0x12A
	LDI  R30,LOW(3)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0xB
; 0000 007C else if (a >= 200)   seg0=2, a=a - 200;
	RJMP _0x12B
_0x12A:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x1B
	BRLO _0x12C
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0xB
; 0000 007D else if (a >= 100)   seg0=1, a=a - 100;
	RJMP _0x12D
_0x12C:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x1D
	BRLO _0x12E
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0xB
; 0000 007E else                 seg0=10;
	RJMP _0x12F
_0x12E:
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 007F 
; 0000 0080 if      (a >= 90)    seg1=9, a=a-90;
_0x12F:
_0x12D:
_0x12B:
_0x129:
_0x127:
_0x125:
_0x123:
_0x121:
_0x11F:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x1F
	BRLO _0x130
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0xB
; 0000 0081 else if (a >= 80)    seg1=8, a=a-80;
	RJMP _0x131
_0x130:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x22
	BRLO _0x132
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0xB
; 0000 0082 else if (a >= 70)    seg1=7, a=a-70;
	RJMP _0x133
_0x132:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x24
	BRLO _0x134
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0xB
; 0000 0083 else if (a >= 60)    seg1=6, a=a-60;
	RJMP _0x135
_0x134:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x26
	BRLO _0x136
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0xB
; 0000 0084 else if (a >= 50)    seg1=5, a=a-50;
	RJMP _0x137
_0x136:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x28
	BRLO _0x138
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0xB
; 0000 0085 else if (a >= 40)    seg1=4, a=a-40;
	RJMP _0x139
_0x138:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x2A
	BRLO _0x13A
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0xB
; 0000 0086 else if (a >= 30)    seg1=3, a=a-30;
	RJMP _0x13B
_0x13A:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x2C
	BRLO _0x13C
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0xB
; 0000 0087 else if (a >= 20)    seg1=2, a=a-20;
	RJMP _0x13D
_0x13C:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x2E
	BRLO _0x13E
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0xB
; 0000 0088 else if (a >= 10)    seg1=1, a=a-10;
	RJMP _0x13F
_0x13E:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x30
	BRLO _0x140
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0xB
; 0000 0089 else                 seg1=0;
	RJMP _0x141
_0x140:
	CLR  R4
; 0000 008A 
; 0000 008B if      (a == 9)     seg2=9;
_0x141:
_0x13F:
_0x13D:
_0x13B:
_0x139:
_0x137:
_0x135:
_0x133:
_0x131:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x32
	BRNE _0x142
	LDI  R30,LOW(9)
	MOV  R7,R30
; 0000 008C else if (a == 8)     seg2=8;
	RJMP _0x143
_0x142:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x33
	BRNE _0x144
	LDI  R30,LOW(8)
	MOV  R7,R30
; 0000 008D else if (a == 7)     seg2=7;
	RJMP _0x145
_0x144:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x34
	BRNE _0x146
	LDI  R30,LOW(7)
	MOV  R7,R30
; 0000 008E else if (a == 6)     seg2=6;
	RJMP _0x147
_0x146:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x35
	BRNE _0x148
	LDI  R30,LOW(6)
	MOV  R7,R30
; 0000 008F else if (a == 5)     seg2=5;
	RJMP _0x149
_0x148:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x36
	BRNE _0x14A
	LDI  R30,LOW(5)
	MOV  R7,R30
; 0000 0090 else if (a == 4)     seg2=4;
	RJMP _0x14B
_0x14A:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x37
	BRNE _0x14C
	LDI  R30,LOW(4)
	MOV  R7,R30
; 0000 0091 else if (a == 3)     seg2=3;
	RJMP _0x14D
_0x14C:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x38
	BRNE _0x14E
	LDI  R30,LOW(3)
	MOV  R7,R30
; 0000 0092 else if (a == 2)     seg2=2;
	RJMP _0x14F
_0x14E:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x39
	BRNE _0x150
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 0093 else if (a == 1)     seg2=1;
	RJMP _0x151
_0x150:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x3A
	BRNE _0x152
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0094 else                 seg2=0;
	RJMP _0x153
_0x152:
	CLR  R7
; 0000 0095 
; 0000 0096 b = b / amp_cor;
_0x153:
_0x151:
_0x14F:
_0x14D:
_0x14B:
_0x149:
_0x147:
_0x145:
_0x143:
	LDI  R26,LOW(_amp_cor)
	LDI  R27,HIGH(_amp_cor)
	RCALL __EEPROMRDD
	RCALL SUBOPT_0x3B
	RCALL __DIVF21
	RCALL SUBOPT_0x3C
; 0000 0097 if (b >=1000)
	RCALL SUBOPT_0x3B
	__GETD1N 0x447A0000
	RCALL __CMPF12
	BRLO _0x154
; 0000 0098     {
; 0000 0099     if (j > 127) seg3=9, seg4=9, seg5=9, _beep=1;
	LDI  R30,LOW(127)
	CP   R30,R10
	BRSH _0x155
	LDI  R30,LOW(9)
	MOV  R6,R30
	MOV  R9,R30
	MOV  R8,R30
	SBI  0x12,3
; 0000 009A         else seg3=10, seg4=10, seg5=10, _beep=0;
	RJMP _0x158
_0x155:
	LDI  R30,LOW(10)
	MOV  R6,R30
	MOV  R9,R30
	MOV  R8,R30
	CBI  0x12,3
; 0000 009B     return;
_0x158:
	RJMP _0x2000001
; 0000 009C     }
; 0000 009D _beep=0;
_0x154:
	CBI  0x12,3
; 0000 009E 
; 0000 009F      if (b >= 900)   seg3=9, b=b - 900;
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0xC
	BRLO _0x15D
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x3C
; 0000 00A0 else if (b >= 800)   seg3=8, b=b - 800;
	RJMP _0x15E
_0x15D:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0xF
	BRLO _0x15F
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x3C
; 0000 00A1 else if (b >= 700)   seg3=7, b=b - 700;
	RJMP _0x160
_0x15F:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x11
	BRLO _0x161
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x3C
; 0000 00A2 else if (b >= 600)   seg3=6, b=b - 600;
	RJMP _0x162
_0x161:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x13
	BRLO _0x163
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x3C
; 0000 00A3 else if (b >= 500)   seg3=5, b=b - 500;
	RJMP _0x164
_0x163:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x15
	BRLO _0x165
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x3C
; 0000 00A4 else if (b >= 400)   seg3=4, b=b - 400;
	RJMP _0x166
_0x165:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x17
	BRLO _0x167
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x3C
; 0000 00A5 else if (b >= 300)   seg3=3, b=b - 300;
	RJMP _0x168
_0x167:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x19
	BRLO _0x169
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x3C
; 0000 00A6 else if (b >= 200)   seg3=2, b=b - 200;
	RJMP _0x16A
_0x169:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x1B
	BRLO _0x16B
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x3C
; 0000 00A7 else if (b >= 100)   seg3=1, b=b - 100;
	RJMP _0x16C
_0x16B:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x1D
	BRLO _0x16D
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x3C
; 0000 00A8 else                 seg3=0;
	RJMP _0x16E
_0x16D:
	CLR  R6
; 0000 00A9 
; 0000 00AA if      (b >= 90)    seg4=9, b=b-90;
_0x16E:
_0x16C:
_0x16A:
_0x168:
_0x166:
_0x164:
_0x162:
_0x160:
_0x15E:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x1F
	BRLO _0x16F
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x3C
; 0000 00AB else if (b >= 80)    seg4=8, b=b-80;
	RJMP _0x170
_0x16F:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x22
	BRLO _0x171
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x3C
; 0000 00AC else if (b >= 70)    seg4=7, b=b-70;
	RJMP _0x172
_0x171:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x24
	BRLO _0x173
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x3C
; 0000 00AD else if (b >= 60)    seg4=6, b=b-60;
	RJMP _0x174
_0x173:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x26
	BRLO _0x175
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x3C
; 0000 00AE else if (b >= 50)    seg4=5, b=b-50;
	RJMP _0x176
_0x175:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x28
	BRLO _0x177
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x3C
; 0000 00AF else if (b >= 40)    seg4=4, b=b-40;
	RJMP _0x178
_0x177:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x2A
	BRLO _0x179
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x3C
; 0000 00B0 else if (b >= 30)    seg4=3, b=b-30;
	RJMP _0x17A
_0x179:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x2C
	BRLO _0x17B
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x3C
; 0000 00B1 else if (b >= 20)    seg4=2, b=b-20;
	RJMP _0x17C
_0x17B:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x2E
	BRLO _0x17D
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x3C
; 0000 00B2 else if (b >= 10)    seg4=1, b=b-10;
	RJMP _0x17E
_0x17D:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x30
	BRLO _0x17F
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x3C
; 0000 00B3 else                 seg4=0;
	RJMP _0x180
_0x17F:
	CLR  R9
; 0000 00B4 
; 0000 00B5 if      (b == 9)     seg5=9;
_0x180:
_0x17E:
_0x17C:
_0x17A:
_0x178:
_0x176:
_0x174:
_0x172:
_0x170:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x32
	BRNE _0x181
	LDI  R30,LOW(9)
	MOV  R8,R30
; 0000 00B6 else if (b == 8)     seg5=8;
	RJMP _0x182
_0x181:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x33
	BRNE _0x183
	LDI  R30,LOW(8)
	MOV  R8,R30
; 0000 00B7 else if (b == 7)     seg5=7;
	RJMP _0x184
_0x183:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x34
	BRNE _0x185
	LDI  R30,LOW(7)
	MOV  R8,R30
; 0000 00B8 else if (b == 6)     seg5=6;
	RJMP _0x186
_0x185:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x35
	BRNE _0x187
	LDI  R30,LOW(6)
	MOV  R8,R30
; 0000 00B9 else if (b == 5)     seg5=5;
	RJMP _0x188
_0x187:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x36
	BRNE _0x189
	LDI  R30,LOW(5)
	MOV  R8,R30
; 0000 00BA else if (b == 4)     seg5=4;
	RJMP _0x18A
_0x189:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x37
	BRNE _0x18B
	LDI  R30,LOW(4)
	MOV  R8,R30
; 0000 00BB else if (b == 3)     seg5=3;
	RJMP _0x18C
_0x18B:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x38
	BRNE _0x18D
	LDI  R30,LOW(3)
	MOV  R8,R30
; 0000 00BC else if (b == 2)     seg5=2;
	RJMP _0x18E
_0x18D:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x39
	BRNE _0x18F
	LDI  R30,LOW(2)
	MOV  R8,R30
; 0000 00BD else if (b == 1)     seg5=1;
	RJMP _0x190
_0x18F:
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3A
	BRNE _0x191
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 00BE else                 seg5=0;
	RJMP _0x192
_0x191:
	CLR  R8
; 0000 00BF 
; 0000 00C0 return;
_0x192:
_0x190:
_0x18E:
_0x18C:
_0x18A:
_0x188:
_0x186:
_0x184:
_0x182:
_0x2000001:
	ADIW R28,8
	RET
; 0000 00C1 }
;
;void start(void)
; 0000 00C4 {
_start:
; 0000 00C5 // Input/Output Ports initialization
; 0000 00C6 // Port B initialization
; 0000 00C7 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00C8 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00C9 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00CA DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00CB 
; 0000 00CC // Port C initialization
; 0000 00CD // Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=In
; 0000 00CE // State6=T State5=P State4=P State3=P State2=0 State1=0 State0=P
; 0000 00CF PORTC=0x39;
	LDI  R30,LOW(57)
	OUT  0x15,R30
; 0000 00D0 DDRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x14,R30
; 0000 00D1 
; 0000 00D2 // Port D initialization
; 0000 00D3 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00D4 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00D5 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00D6 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00D7 
; 0000 00D8 // Timer/Counter 0 initialization
; 0000 00D9 // Clock source: System Clock
; 0000 00DA // Clock value: Timer 0 Stopped
; 0000 00DB TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00DC TCNT0=0x00;
	OUT  0x32,R30
; 0000 00DD 
; 0000 00DE // Timer/Counter 1 initialization
; 0000 00DF // Clock source: System Clock
; 0000 00E0 // Clock value: Timer1 Stopped
; 0000 00E1 // Mode: Normal top=FFFFh
; 0000 00E2 // OC1A output: Discon.
; 0000 00E3 // OC1B output: Discon.
; 0000 00E4 // Noise Canceler: Off
; 0000 00E5 // Input Capture on Falling Edge
; 0000 00E6 // Timer1 Overflow Interrupt: Off
; 0000 00E7 // Input Capture Interrupt: Off
; 0000 00E8 // Compare A Match Interrupt: Off
; 0000 00E9 // Compare B Match Interrupt: Off
; 0000 00EA TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00EB TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00EC TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00ED TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00EE ICR1H=0x00;
	OUT  0x27,R30
; 0000 00EF ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F0 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F1 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F2 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F3 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F4 
; 0000 00F5 // Timer/Counter 2 initialization
; 0000 00F6 // Clock source: System Clock
; 0000 00F7 // Clock value: Timer2 Stopped
; 0000 00F8 // Mode: Normal top=FFh
; 0000 00F9 // OC2 output: Disconnected
; 0000 00FA ASSR=0x00;
	OUT  0x22,R30
; 0000 00FB TCCR2=0x00;
	OUT  0x25,R30
; 0000 00FC TCNT2=0x00;
	OUT  0x24,R30
; 0000 00FD OCR2=0x00;
	OUT  0x23,R30
; 0000 00FE 
; 0000 00FF // External Interrupt(s) initialization
; 0000 0100 // INT0: Off
; 0000 0101 // INT1: Off
; 0000 0102 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0103 
; 0000 0104 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0105 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0106 
; 0000 0107 // Analog Comparator initialization
; 0000 0108 // Analog Comparator: Off
; 0000 0109 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 010A ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 010B SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 010C 
; 0000 010D // ADC initialization
; 0000 010E // ADC Clock frequency: 250,000 kHz
; 0000 010F // ADC Voltage Reference: AVCC pin
; 0000 0110 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0111 ADCSRA=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0112 
; 0000 0113 // Global enable interrupts
; 0000 0114 //#asm("sei")
; 0000 0115 if (vol_cor == 0xFFFFFFFF) vol_cor = 4.00;
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	BRNE _0x193
	RCALL SUBOPT_0x3F
	__GETD1N 0x40800000
	RCALL __EEPROMWRD
; 0000 0116 if (amp_cor == 0xFFFFFFFF) amp_cor = 1.00;
_0x193:
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x40
	BRNE _0x194
	RCALL SUBOPT_0x41
	__GETD1N 0x3F800000
	RCALL __EEPROMWRD
; 0000 0117 return;
_0x194:
	RET
; 0000 0118 }
;
;void main(void)
; 0000 011B {
_main:
; 0000 011C start ();
	RCALL _start
; 0000 011D 
; 0000 011E while (1)
_0x195:
; 0000 011F       {
; 0000 0120       // Place your code here
; 0000 0121       read();
	RCALL _read
; 0000 0122       if (i == 0) preobr(in_v, in_a);
	TST  R11
	BRNE _0x198
	MOVW R30,R12
	RCALL SUBOPT_0x42
	LDS  R30,_in_a
	LDS  R31,_in_a+1
	RCALL SUBOPT_0x42
	RCALL _preobr
; 0000 0123 
; 0000 0124       codegen(0,seg0);
_0x198:
	RCALL SUBOPT_0x43
; 0000 0125       codegen(1,seg1);
	RCALL SUBOPT_0x44
; 0000 0126       codegen(2,seg2);
; 0000 0127       codegen(3,seg3);
	RCALL SUBOPT_0x45
; 0000 0128       codegen(4,seg4);
	RCALL SUBOPT_0x46
; 0000 0129       codegen(5,seg5);
; 0000 012A 
; 0000 012B       codegen(1,seg1);
	RCALL SUBOPT_0x44
; 0000 012C       codegen(2,seg2);
; 0000 012D       codegen(0,seg0);
	RCALL SUBOPT_0x43
; 0000 012E       codegen(4,seg4);
	RCALL SUBOPT_0x46
; 0000 012F       codegen(5,seg5);
; 0000 0130       codegen(3,seg3);
	RCALL SUBOPT_0x45
; 0000 0131 
; 0000 0132       codegen(2,seg2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R7
	RCALL _codegen
; 0000 0133       codegen(0,seg0);
	RCALL SUBOPT_0x43
; 0000 0134       codegen(1,seg1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R4
	RCALL _codegen
; 0000 0135       codegen(5,seg5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	ST   -Y,R8
	RCALL _codegen
; 0000 0136       codegen(3,seg3);
	RCALL SUBOPT_0x45
; 0000 0137       codegen(4,seg4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	ST   -Y,R9
	RCALL _codegen
; 0000 0138 
; 0000 0139       i++;
	INC  R11
; 0000 013A       if (i>=50)
	LDI  R30,LOW(50)
	CP   R11,R30
	BRLO _0x199
; 0000 013B         {
; 0000 013C         if (PORTC.0 == 0) vol_cor=+0.01;
	SBIC 0x15,0
	RJMP _0x19A
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x47
; 0000 013D         if (PORTC.3 == 0) vol_cor=-0.01;
_0x19A:
	SBIC 0x15,3
	RJMP _0x19B
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x48
; 0000 013E         if (PORTC.4 == 0) amp_cor=+0.01;
_0x19B:
	SBIC 0x15,4
	RJMP _0x19C
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x47
; 0000 013F         if (PORTC.5 == 0) amp_cor=-0.01;
_0x19C:
	SBIC 0x15,5
	RJMP _0x19D
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x48
; 0000 0140         i=0;
_0x19D:
	CLR  R11
; 0000 0141         };
_0x199:
; 0000 0142       j=j+4;
	LDI  R30,LOW(4)
	ADD  R10,R30
; 0000 0143 
; 0000 0144       };
	RJMP _0x195
; 0000 0145 }
_0x19E:
	RJMP _0x19E

	.DSEG
_in_a:
	.BYTE 0x2
_in01:
	.BYTE 0x2
_in02:
	.BYTE 0x2
_in03:
	.BYTE 0x2
_in04:
	.BYTE 0x2
_in11:
	.BYTE 0x2
_in12:
	.BYTE 0x2
_in13:
	.BYTE 0x2
_in14:
	.BYTE 0x2
_in21:
	.BYTE 0x2
_in22:
	.BYTE 0x2
_in23:
	.BYTE 0x2
_in24:
	.BYTE 0x2

	.ESEG
_vol_cor:
	.BYTE 0x4
_amp_cor:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	SBI  0x18,1
	SBI  0x12,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SBI  0x18,4
	SBI  0x12,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CBI  0x12,1
	SBI  0x18,0
	SBI  0x18,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	SBI  0x15,1
	SBI  0x15,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	SBI  0x18,2
	SBI  0x12,7
	SBI  0x12,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SBI  0x12,0
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,_in02
	LDS  R31,_in02+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R30,_in14
	LDS  R31,_in14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0xA:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0xB:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	__GETD1N 0x44610000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xD:
	MOV  R5,R30
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	__GETD2N 0x44610000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	__GETD1N 0x44480000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	__GETD2N 0x44480000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	__GETD1N 0x442F0000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	__GETD2N 0x442F0000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	__GETD1N 0x44160000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	__GETD2N 0x44160000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__GETD1N 0x43FA0000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	__GETD2N 0x43FA0000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	__GETD1N 0x43C80000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	__GETD2N 0x43C80000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__GETD1N 0x43960000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__GETD2N 0x43960000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	__GETD1N 0x43480000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	__GETD2N 0x43480000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	__GETD1N 0x42C80000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	__GETD2N 0x42C80000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	__GETD1N 0x42B40000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x20:
	MOV  R4,R30
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	__GETD2N 0x42B40000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	__GETD1N 0x42A00000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	__GETD2N 0x42A00000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	__GETD1N 0x428C0000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	__GETD2N 0x428C0000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	__GETD1N 0x42700000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	__GETD2N 0x42700000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	__GETD1N 0x42480000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	__GETD2N 0x42480000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	__GETD1N 0x42200000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	__GETD2N 0x42200000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	__GETD1N 0x41F00000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2D:
	__GETD2N 0x41F00000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	__GETD1N 0x41A00000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	__GETD2N 0x41A00000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	__GETD1N 0x41200000
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	__GETD2N 0x41200000
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	__CPD2N 0x41100000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	__CPD2N 0x41000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
	__CPD2N 0x40E00000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	__CPD2N 0x40C00000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	__CPD2N 0x40A00000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	__CPD2N 0x40800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	__CPD2N 0x40400000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	__CPD2N 0x40000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3A:
	__CPD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x3B:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x3C:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x3D:
	MOV  R6,R30
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x3E:
	MOV  R9,R30
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(_vol_cor)
	LDI  R27,HIGH(_vol_cor)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	RCALL __EEPROMRDD
	__CPD1N 0x4F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(_amp_cor)
	LDI  R27,HIGH(_amp_cor)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R5
	RJMP _codegen

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R4
	RCALL _codegen
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R7
	RJMP _codegen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x45:
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R6
	RJMP _codegen

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(4)
	ST   -Y,R30
	ST   -Y,R9
	RCALL _codegen
	LDI  R30,LOW(5)
	ST   -Y,R30
	ST   -Y,R8
	RJMP _codegen

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x47:
	__GETD1N 0x3C23D70A
	RCALL __EEPROMWRD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x48:
	__GETD1N 0xBC23D70A
	RCALL __EEPROMWRD
	RET


	.CSEG
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

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
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
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
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

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

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

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
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

;END OF CODE MARKER
__END_OF_CODE:
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      