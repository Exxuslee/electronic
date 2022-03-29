
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8,000000 MHz
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
;global 'const' stored in FLASH: Yes
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
	.DEF _modul_00=R4
	.DEF _modul_01=R3
	.DEF _modul_10=R6
	.DEF _modul_11=R5
	.DEF _modul_20=R8
	.DEF _modul_21=R7
	.DEF _modul_30=R10
	.DEF _modul_31=R9
	.DEF _modul_40=R12
	.DEF _modul_41=R11
	.DEF _modul_50=R14
	.DEF _modul_51=R13

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
;Date    : 26.10.2010
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
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
;#define pvv PORTC.0
;#define got PORTC.1
;
;#define prm PORTC.2
;#define vdch PORTC.3
;
;#define ust PINC.4
;#define otv PINC.5
;
;#define sh_data_in PIND
;#define sh_data_out PORTD
;#define sh_adr PORTB
;#define KORZ_INP 0x000f
;#define KORZ_OUT 0x00f0
;
;// Declare your global variables here
;char modul_00, modul_01, modul_10, modul_11, modul_20, modul_21, modul_30, modul_31;
;char modul_40, modul_41, modul_50, modul_51, modul_60, modul_61, modul_70, modul_71;
;unsigned int i;
;
;void dannye()      //zapis i chtenie dannyh s modulej v korzine
; 0000 0030     {

	.CSEG
_dannye:
; 0000 0031     // Place your code here
; 0000 0032     for (sh_adr=0, i=1; sh_adr<=15;sh_adr++, i<<=1)
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x0
_0x4:
	IN   R30,0x18
	CPI  R30,LOW(0x10)
	BRLO PC+2
	RJMP _0x5
; 0000 0033         {
; 0000 0034         if ((KORZ_INP & i) == i)               //esli modul - vhodnoj, to
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	BREQ PC+2
	RJMP _0x6
; 0000 0035             {
; 0000 0036             DDRD=0x00;                          //nastraivaem port na vhod
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0037             prm=1;
	SBI  0x15,2
; 0000 0038             while (otv==0)
_0x9:
	SBIC 0x13,5
	RJMP _0xB
; 0000 0039                 {
; 0000 003A                 switch (sh_adr)
	IN   R30,0x18
; 0000 003B                     {
; 0000 003C                     case 0 : modul_71=sh_data_in;
	CPI  R30,0
	BRNE _0xF
	IN   R30,0x10
	STS  _modul_71,R30
; 0000 003D                     case 1 : modul_70=sh_data_in;
	RJMP _0x10
_0xF:
	CPI  R30,LOW(0x1)
	BRNE _0x11
_0x10:
	IN   R30,0x10
	STS  _modul_70,R30
; 0000 003E                     case 2 : modul_61=sh_data_in;
	RJMP _0x12
_0x11:
	CPI  R30,LOW(0x2)
	BRNE _0x13
_0x12:
	IN   R30,0x10
	STS  _modul_61,R30
; 0000 003F                     case 3 : modul_60=sh_data_in;
	RJMP _0x14
_0x13:
	CPI  R30,LOW(0x3)
	BRNE _0x15
_0x14:
	IN   R30,0x10
	STS  _modul_60,R30
; 0000 0040                     case 4 : modul_51=sh_data_in;
	RJMP _0x16
_0x15:
	CPI  R30,LOW(0x4)
	BRNE _0x17
_0x16:
	IN   R13,16
; 0000 0041                     case 5 : modul_50=sh_data_in;
	RJMP _0x18
_0x17:
	CPI  R30,LOW(0x5)
	BRNE _0x19
_0x18:
	IN   R14,16
; 0000 0042                     case 6 : modul_41=sh_data_in;
	RJMP _0x1A
_0x19:
	CPI  R30,LOW(0x6)
	BRNE _0x1B
_0x1A:
	IN   R11,16
; 0000 0043                     case 7 : modul_40=sh_data_in;
	RJMP _0x1C
_0x1B:
	CPI  R30,LOW(0x7)
	BRNE _0x1D
_0x1C:
	IN   R12,16
; 0000 0044                     case 8 : modul_31=sh_data_in;
	RJMP _0x1E
_0x1D:
	CPI  R30,LOW(0x8)
	BRNE _0x1F
_0x1E:
	IN   R9,16
; 0000 0045                     case 9 : modul_30=sh_data_in;
	RJMP _0x20
_0x1F:
	CPI  R30,LOW(0x9)
	BRNE _0x21
_0x20:
	IN   R10,16
; 0000 0046                     case 10 : modul_21=sh_data_in;
	RJMP _0x22
_0x21:
	CPI  R30,LOW(0xA)
	BRNE _0x23
_0x22:
	IN   R7,16
; 0000 0047                     case 11 : modul_20=sh_data_in;
	RJMP _0x24
_0x23:
	CPI  R30,LOW(0xB)
	BRNE _0x25
_0x24:
	IN   R8,16
; 0000 0048                     case 12 : modul_11=sh_data_in;
	RJMP _0x26
_0x25:
	CPI  R30,LOW(0xC)
	BRNE _0x27
_0x26:
	IN   R5,16
; 0000 0049                     case 13 : modul_10=sh_data_in;
	RJMP _0x28
_0x27:
	CPI  R30,LOW(0xD)
	BRNE _0x29
_0x28:
	IN   R6,16
; 0000 004A                     case 14 : modul_01=sh_data_in;
	RJMP _0x2A
_0x29:
	CPI  R30,LOW(0xE)
	BRNE _0x2B
_0x2A:
	IN   R3,16
; 0000 004B                     case 15 : modul_00=sh_data_in;
	RJMP _0x2C
_0x2B:
	CPI  R30,LOW(0xF)
	BRNE _0xE
_0x2C:
	IN   R4,16
; 0000 004C                     };
_0xE:
; 0000 004D                 };
	RJMP _0x9
_0xB:
; 0000 004E             prm=0;
	CBI  0x15,2
; 0000 004F             };
_0x6:
; 0000 0050         if ((KORZ_OUT & i) == i)        //esli modul - vyhodnoj, to
	RCALL SUBOPT_0x3
	BREQ PC+2
	RJMP _0x30
; 0000 0051             {
; 0000 0052             DDRD=0xff;                    //port na vihod
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0053             vdch=1;
	SBI  0x15,3
; 0000 0054             while (otv==0)
_0x33:
	SBIC 0x13,5
	RJMP _0x35
; 0000 0055                 {
; 0000 0056                 switch (sh_adr)
	IN   R30,0x18
; 0000 0057                     {
; 0000 0058                     case 0 : sh_data_out=modul_00;
	CPI  R30,0
	BRNE _0x39
	OUT  0x12,R4
; 0000 0059                     case 1 : sh_data_out=modul_01;
	RJMP _0x3A
_0x39:
	CPI  R30,LOW(0x1)
	BRNE _0x3B
_0x3A:
	OUT  0x12,R3
; 0000 005A                     case 2 : sh_data_out=modul_10;
	RJMP _0x3C
_0x3B:
	CPI  R30,LOW(0x2)
	BRNE _0x3D
_0x3C:
	OUT  0x12,R6
; 0000 005B                     case 3 : sh_data_out=modul_11;
	RJMP _0x3E
_0x3D:
	CPI  R30,LOW(0x3)
	BRNE _0x3F
_0x3E:
	OUT  0x12,R5
; 0000 005C                     case 4 : sh_data_out=modul_20;
	RJMP _0x40
_0x3F:
	CPI  R30,LOW(0x4)
	BRNE _0x41
_0x40:
	OUT  0x12,R8
; 0000 005D                     case 5 : sh_data_out=modul_21;
	RJMP _0x42
_0x41:
	CPI  R30,LOW(0x5)
	BRNE _0x43
_0x42:
	OUT  0x12,R7
; 0000 005E                     case 6 : sh_data_out=modul_30;
	RJMP _0x44
_0x43:
	CPI  R30,LOW(0x6)
	BRNE _0x45
_0x44:
	OUT  0x12,R10
; 0000 005F                     case 7 : sh_data_out=modul_31;
	RJMP _0x46
_0x45:
	CPI  R30,LOW(0x7)
	BRNE _0x47
_0x46:
	OUT  0x12,R9
; 0000 0060                     case 8 : sh_data_out=modul_40;
	RJMP _0x48
_0x47:
	CPI  R30,LOW(0x8)
	BRNE _0x49
_0x48:
	OUT  0x12,R12
; 0000 0061                     case 9 : sh_data_out=modul_41;
	RJMP _0x4A
_0x49:
	CPI  R30,LOW(0x9)
	BRNE _0x4B
_0x4A:
	OUT  0x12,R11
; 0000 0062                     case 10 : sh_data_out=modul_50;
	RJMP _0x4C
_0x4B:
	CPI  R30,LOW(0xA)
	BRNE _0x4D
_0x4C:
	OUT  0x12,R14
; 0000 0063                     case 11 : sh_data_out=modul_51;
	RJMP _0x4E
_0x4D:
	CPI  R30,LOW(0xB)
	BRNE _0x4F
_0x4E:
	OUT  0x12,R13
; 0000 0064                     case 12 : sh_data_out=modul_60;
	RJMP _0x50
_0x4F:
	CPI  R30,LOW(0xC)
	BRNE _0x51
_0x50:
	LDS  R30,_modul_60
	OUT  0x12,R30
; 0000 0065                     case 13 : sh_data_out=modul_61;
	RJMP _0x52
_0x51:
	CPI  R30,LOW(0xD)
	BRNE _0x53
_0x52:
	LDS  R30,_modul_61
	OUT  0x12,R30
; 0000 0066                     case 14 : sh_data_out=modul_70;
	RJMP _0x54
_0x53:
	CPI  R30,LOW(0xE)
	BRNE _0x55
_0x54:
	LDS  R30,_modul_70
	OUT  0x12,R30
; 0000 0067                     case 15 : sh_data_out=modul_71;
	RJMP _0x56
_0x55:
	CPI  R30,LOW(0xF)
	BRNE _0x38
_0x56:
	LDS  R30,_modul_71
	OUT  0x12,R30
; 0000 0068                     };
_0x38:
; 0000 0069                 };
	RJMP _0x33
_0x35:
; 0000 006A             vdch=0;
	CBI  0x15,3
; 0000 006B             };
_0x30:
; 0000 006C         };
	RCALL SUBOPT_0x4
	RJMP _0x4
_0x5:
; 0000 006D     };
	RET
;
;void main(void)
; 0000 0070 {
_main:
; 0000 0071 // Declare your local variables here
; 0000 0072 
; 0000 0073 // Input/Output Ports initialization
; 0000 0074 // Port B initialization
; 0000 0075 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0076 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0077 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0078 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0079 
; 0000 007A // Port C initialization
; 0000 007B // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 007C // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 007D PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 007E DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 007F 
; 0000 0080 // Port D initialization
; 0000 0081 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0082 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0083 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0084 DDRD=0x00;
	OUT  0x11,R30
; 0000 0085 
; 0000 0086 // Timer/Counter 0 initialization
; 0000 0087 // Clock source: System Clock
; 0000 0088 // Clock value: Timer 0 Stopped
; 0000 0089 TCCR0=0x00;
	OUT  0x33,R30
; 0000 008A TCNT0=0x00;
	OUT  0x32,R30
; 0000 008B 
; 0000 008C // Timer/Counter 1 initialization
; 0000 008D // Clock source: System Clock
; 0000 008E // Clock value: Timer1 Stopped
; 0000 008F // Mode: Normal top=FFFFh
; 0000 0090 // OC1A output: Discon.
; 0000 0091 // OC1B output: Discon.
; 0000 0092 // Noise Canceler: Off
; 0000 0093 // Input Capture on Falling Edge
; 0000 0094 // Timer1 Overflow Interrupt: Off
; 0000 0095 // Input Capture Interrupt: Off
; 0000 0096 // Compare A Match Interrupt: Off
; 0000 0097 // Compare B Match Interrupt: Off
; 0000 0098 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0099 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 009A TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 009B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 009C ICR1H=0x00;
	OUT  0x27,R30
; 0000 009D ICR1L=0x00;
	OUT  0x26,R30
; 0000 009E OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 009F OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A0 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A1 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A2 
; 0000 00A3 // Timer/Counter 2 initialization
; 0000 00A4 // Clock source: System Clock
; 0000 00A5 // Clock value: Timer2 Stopped
; 0000 00A6 // Mode: Normal top=FFh
; 0000 00A7 // OC2 output: Disconnected
; 0000 00A8 ASSR=0x00;
	OUT  0x22,R30
; 0000 00A9 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00AA TCNT2=0x00;
	OUT  0x24,R30
; 0000 00AB OCR2=0x00;
	OUT  0x23,R30
; 0000 00AC 
; 0000 00AD // External Interrupt(s) initialization
; 0000 00AE // INT0: Off
; 0000 00AF // INT1: Off
; 0000 00B0 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00B1 
; 0000 00B2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B3 TIMSK=0x00;
	OUT  0x39,R30
; 0000 00B4 
; 0000 00B5 // Analog Comparator initialization
; 0000 00B6 // Analog Comparator: Off
; 0000 00B7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00B8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B9 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00BA 
; 0000 00BB pvv=1;
	SBI  0x15,0
; 0000 00BC got=0;
	CBI  0x15,1
; 0000 00BD while (ust==1) got=0;
_0x5E:
	SBIS 0x13,4
	RJMP _0x60
	CBI  0x15,1
	RJMP _0x5E
_0x60:
; 0000 00BE PORTC.1=1;
	SBI  0x15,1
; 0000 00BF for (sh_adr=0, i=1; sh_adr<=15;sh_adr++, i<<=1)
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x0
_0x66:
	IN   R30,0x18
	CPI  R30,LOW(0x10)
	BRSH _0x67
; 0000 00C0     {
; 0000 00C1     if ((KORZ_INP & i) == i)               //esli modul - vhodnoj, to
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	BRNE _0x68
; 0000 00C2             {
; 0000 00C3             DDRD=0x00;                          //nastraivaem port na vhod
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00C4             prm=1;
	SBI  0x15,2
; 0000 00C5             while (otv==0);
_0x6B:
	SBIS 0x13,5
	RJMP _0x6B
; 0000 00C6             prm=0;
	CBI  0x15,2
; 0000 00C7             };
_0x68:
; 0000 00C8     if ((KORZ_OUT & i) == i)        //esli modul - vyhodnoj, to
	RCALL SUBOPT_0x3
	BRNE _0x70
; 0000 00C9             {
; 0000 00CA             DDRD=0xff;                    //port na vihod
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 00CB             vdch=1;
	SBI  0x15,3
; 0000 00CC             while (otv==0);
_0x73:
	SBIS 0x13,5
	RJMP _0x73
; 0000 00CD             vdch=0;
	CBI  0x15,3
; 0000 00CE             };
_0x70:
; 0000 00CF     };
	RCALL SUBOPT_0x4
	RJMP _0x66
_0x67:
; 0000 00D0 pvv=0;
	CBI  0x15,0
; 0000 00D1 
; 0000 00D2 while (1)
_0x7A:
; 0000 00D3       {
; 0000 00D4       // Place your code here
; 0000 00D5       char temp=0;
; 0000 00D6 
; 0000 00D7       dannye();
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	temp -> Y+0
	RCALL _dannye
; 0000 00D8 
; 0000 00D9       temp=temp|modul_00;
	MOV  R30,R4
	RCALL SUBOPT_0x5
; 0000 00DA       temp=temp|modul_01;
	MOV  R30,R3
	RCALL SUBOPT_0x5
; 0000 00DB       temp=temp|modul_10;
	MOV  R30,R6
	RCALL SUBOPT_0x5
; 0000 00DC       temp=temp|modul_11;
	MOV  R30,R5
	RCALL SUBOPT_0x5
; 0000 00DD       temp=temp|modul_20;
	MOV  R30,R8
	RCALL SUBOPT_0x5
; 0000 00DE       modul_21=temp;
	LDD  R7,Y+0
; 0000 00DF       modul_30=temp;
	LDD  R10,Y+0
; 0000 00E0       modul_31=temp;
	LDD  R9,Y+0
; 0000 00E1       modul_40=temp;
	LDD  R12,Y+0
; 0000 00E2 
; 0000 00E3       delay_ms (10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 00E4       };
	ADIW R28,1
	RJMP _0x7A
; 0000 00E5 }
_0x7D:
	RJMP _0x7D

	.DSEG
_modul_60:
	.BYTE 0x1
_modul_61:
	.BYTE 0x1
_modul_70:
	.BYTE 0x1
_modul_71:
	.BYTE 0x1
_i:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	OUT  0x18,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R26,R30
	RCALL SUBOPT_0x1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x1
	ANDI R30,LOW(0xF0)
	ANDI R31,HIGH(0xF0)
	MOVW R26,R30
	RCALL SUBOPT_0x1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
	IN   R30,0x18
	SUBI R30,-LOW(1)
	OUT  0x18,R30
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x1
	LSL  R30
	ROL  R31
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LD   R26,Y
	OR   R30,R26
	ST   Y,R30
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

;END OF CODE MARKER
__END_OF_CODE:
