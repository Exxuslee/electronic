
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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
	.DEF _in_0=R12

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

_0x3:
	.DB  0xB8,0x1E,0x85,0x3F
_0x27D:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _cor
	.DW  _0x3*2

	.DW  0x02
	.DW  0x0C
	.DW  _0x27D*2

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
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 21.08.2012
;Author  : NeVaDa
;Company : MICROSOFT
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
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
;
;#define ADC_VREF_TYPE 0x40
;#define _0 PORTB.5
;#define _1 PORTB.6
;#define _2 PORTB.7
;#define _3 PORTB.0
;#define _4 PORTB.1
;#define _5 PORTB.2
;#define _A PORTC.0
;#define _B PORTC.1
;#define _C PORTC.2
;#define _D PORTC.3
;#define _E PORTC.4
;#define _F PORTC.5
;#define _G PORTC.6
;#define _P PORTC.7
;
;
;// Declare your global variables here
;unsigned char seg0, seg1, seg2, seg3, seg4, seg5, i, ;
;unsigned int in_0=0, in_1=0, in_2=0, disp, dis;
;float cor=1.04, y_old=0, y_old2=0;

	.DSEG
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0033 {

	.CSEG
_read_adc:
; 0000 0034 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0035 // Delay needed for the stabilization of the ADC input voltage
; 0000 0036 delay_us(10);
	__DELAY_USB 27
; 0000 0037 // Start the AD conversion
; 0000 0038 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0039 // Wait for the AD conversion to complete
; 0000 003A while ((ADCSRA & 0x10)==0);
_0x4:
	SBIS 0x6,4
	RJMP _0x4
; 0000 003B ADCSRA|=0x10;
	SBI  0x6,4
; 0000 003C return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 003D }
;
;void codegen (char x, char y)
; 0000 0040 {
_codegen:
; 0000 0041      if (y==0)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=0;
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x7
	RCALL SUBOPT_0x0
	SBI  0x15,4
	SBI  0x15,5
	RJMP _0x275
; 0000 0042 else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
_0x7:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x17
	CBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
	RJMP _0x276
; 0000 0043 else if (y==2)  _A=1,_B=1,_C=0,_D=1,_E=1,_F=0,_G=1;
_0x17:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x27
	SBI  0x15,0
	SBI  0x15,1
	CBI  0x15,2
	SBI  0x15,3
	SBI  0x15,4
	CBI  0x15,5
	SBI  0x15,6
; 0000 0044 else if (y==3)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=0,_G=1;
	RJMP _0x36
_0x27:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x37
	RCALL SUBOPT_0x0
	CBI  0x15,4
	CBI  0x15,5
	SBI  0x15,6
; 0000 0045 else if (y==4)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=1,_G=1;
	RJMP _0x46
_0x37:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x47
	CBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
	CBI  0x15,3
	CBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 0046 else if (y==5)  _A=1,_B=0,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x56
_0x47:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x57
	SBI  0x15,0
	CBI  0x15,1
	SBI  0x15,2
	SBI  0x15,3
	CBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 0047 else if (y==6)  _A=1,_B=0,_C=1,_D=1,_E=1,_F=1,_G=1;
	RJMP _0x66
_0x57:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x67
	SBI  0x15,0
	CBI  0x15,1
	SBI  0x15,2
	SBI  0x15,3
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 0048 else if (y==7)  _A=1,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
	RJMP _0x76
_0x67:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x77
	SBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
	RJMP _0x276
; 0000 0049 else if (y==8)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=1;
_0x77:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x87
	RCALL SUBOPT_0x0
	SBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 004A else if (y==9)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x96
_0x87:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x97
	RCALL SUBOPT_0x0
	CBI  0x15,4
	SBI  0x15,5
	SBI  0x15,6
; 0000 004B else            _A=0,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xA6
_0x97:
	CBI  0x15,0
	CBI  0x15,1
	CBI  0x15,2
_0x276:
	CBI  0x15,3
	CBI  0x15,4
	CBI  0x15,5
_0x275:
	CBI  0x15,6
; 0000 004C 
; 0000 004D      if (x==0) _0=0, _1=1, _2=1, _P=0;
_0xA6:
_0x96:
_0x76:
_0x66:
_0x56:
_0x46:
_0x36:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0xB5
	CBI  0x18,5
	SBI  0x18,6
	SBI  0x18,7
	RJMP _0x277
; 0000 004E else if (x==1) _0=1, _1=0, _2=1, _P=1;
_0xB5:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0xBF
	SBI  0x18,5
	CBI  0x18,6
	SBI  0x18,7
	SBI  0x15,7
; 0000 004F else           _0=1, _1=1, _2=0, _P=0;
	RJMP _0xC8
_0xBF:
	SBI  0x18,5
	SBI  0x18,6
	CBI  0x18,7
_0x277:
	CBI  0x15,7
; 0000 0050 
; 0000 0051 delay_us(100);
_0xC8:
	__DELAY_USW 200
; 0000 0052 _0=1, _1=1, _2=1;
	SBI  0x18,5
	SBI  0x18,6
	SBI  0x18,7
; 0000 0053 return;
	RJMP _0x2000002
; 0000 0054 }
;
;void codegen2 (char x, char y)
; 0000 0057 {
_codegen2:
; 0000 0058      if (y== 0)  PORTC=0x00, PORTD=0x00;
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xD7
	LDI  R30,LOW(0)
	OUT  0x15,R30
	RJMP _0x278
; 0000 0059 else if (y== 1)  PORTC=0x00, PORTD=0x01;
_0xD7:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0xD9
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(1)
	RJMP _0x278
; 0000 005A else if (y== 2)  PORTC=0x00, PORTD=0x03;
_0xD9:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0xDB
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(3)
	RJMP _0x278
; 0000 005B else if (y== 3)  PORTC=0x00, PORTD=0x07;
_0xDB:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0xDD
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(7)
	RJMP _0x278
; 0000 005C else if (y== 4)  PORTC=0x00, PORTD=0x0F;
_0xDD:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xDF
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(15)
	RJMP _0x278
; 0000 005D else if (y== 5)  PORTC=0x00, PORTD=0x1F;
_0xDF:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0xE1
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(31)
	RJMP _0x278
; 0000 005E else if (y== 6)  PORTC=0x00, PORTD=0x3F;
_0xE1:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0xE3
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(63)
	RJMP _0x278
; 0000 005F else if (y== 7)  PORTC=0x00, PORTD=0x7F;
_0xE3:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0xE5
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(127)
	RJMP _0x278
; 0000 0060 else if (y== 8)  PORTC=0x00, PORTD=0xFF;
_0xE5:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0xE7
	LDI  R30,LOW(0)
	RJMP _0x279
; 0000 0061 else if (y== 9)  PORTC=0x01, PORTD=0xFF;
_0xE7:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0xE9
	LDI  R30,LOW(1)
	RJMP _0x279
; 0000 0062 else if (y==10)  PORTC=0x03, PORTD=0xFF;
_0xE9:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0xEB
	LDI  R30,LOW(3)
	RJMP _0x279
; 0000 0063 else if (y==11)  PORTC=0x07, PORTD=0xFF;
_0xEB:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0xED
	LDI  R30,LOW(7)
	RJMP _0x279
; 0000 0064 else if (y==12)  PORTC=0x0F, PORTD=0xFF;
_0xED:
	LD   R26,Y
	CPI  R26,LOW(0xC)
	BRNE _0xEF
	LDI  R30,LOW(15)
	RJMP _0x279
; 0000 0065 else if (y==13)  PORTC=0x1F, PORTD=0xFF;
_0xEF:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0xF1
	LDI  R30,LOW(31)
	RJMP _0x279
; 0000 0066 else if (y==14)  PORTC=0x3F, PORTD=0xFF;
_0xF1:
	LD   R26,Y
	CPI  R26,LOW(0xE)
	BRNE _0xF3
	LDI  R30,LOW(63)
	RJMP _0x279
; 0000 0067 else if (y==15)  PORTC=0x7F, PORTD=0xFF;
_0xF3:
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0xF5
	LDI  R30,LOW(127)
	RJMP _0x279
; 0000 0068 else             PORTC=0xFF, PORTD=0xFF;
_0xF5:
	LDI  R30,LOW(255)
_0x279:
	OUT  0x15,R30
	LDI  R30,LOW(255)
_0x278:
	OUT  0x12,R30
; 0000 0069 
; 0000 006A if(x==3)
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BREQ PC+3
	JMP _0xF7
; 0000 006B {
; 0000 006C if (y_old < y) y_old = y;
	LD   R30,Y
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	CALL __CMPF12
	BRSH _0xF8
	LD   R30,Y
	LDI  R26,LOW(_y_old)
	LDI  R27,HIGH(_y_old)
	RCALL SUBOPT_0x2
	CALL __PUTDP1
; 0000 006D else y_old = y_old-0.002;
	RJMP _0xF9
_0xF8:
	LDS  R30,_y_old
	LDS  R31,_y_old+1
	LDS  R22,_y_old+2
	LDS  R23,_y_old+3
	RCALL SUBOPT_0x3
	STS  _y_old,R30
	STS  _y_old+1,R31
	STS  _y_old+2,R22
	STS  _y_old+3,R23
; 0000 006E 
; 0000 006F      if (y_old >=16)  PORTC.7=1;
_0xF9:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x4
	BRLO _0xFA
	SBI  0x15,7
; 0000 0070 else if (y_old >=15)  PORTC.6=1;
	RJMP _0xFD
_0xFA:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x5
	BRLO _0xFE
	SBI  0x15,6
; 0000 0071 else if (y_old >=14)  PORTC.5=1;
	RJMP _0x101
_0xFE:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	BRLO _0x102
	SBI  0x15,5
; 0000 0072 else if (y_old >=13)  PORTC.4=1;
	RJMP _0x105
_0x102:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x7
	BRLO _0x106
	SBI  0x15,4
; 0000 0073 else if (y_old >=12)  PORTC.3=1;
	RJMP _0x109
_0x106:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	BRLO _0x10A
	SBI  0x15,3
; 0000 0074 else if (y_old >=11)  PORTC.2=1;
	RJMP _0x10D
_0x10A:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x9
	BRLO _0x10E
	SBI  0x15,2
; 0000 0075 else if (y_old >=10)  PORTC.1=1;
	RJMP _0x111
_0x10E:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xA
	BRLO _0x112
	SBI  0x15,1
; 0000 0076 else if (y_old >= 9)  PORTC.0=1;
	RJMP _0x115
_0x112:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xB
	BRLO _0x116
	SBI  0x15,0
; 0000 0077 else if (y_old >= 8)  PORTD.7=1;
	RJMP _0x119
_0x116:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xC
	BRLO _0x11A
	SBI  0x12,7
; 0000 0078 else if (y_old >= 7)  PORTD.6=1;
	RJMP _0x11D
_0x11A:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xD
	BRLO _0x11E
	SBI  0x12,6
; 0000 0079 else if (y_old >= 6)  PORTD.5=1;
	RJMP _0x121
_0x11E:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xE
	BRLO _0x122
	SBI  0x12,5
; 0000 007A else if (y_old >= 5)  PORTD.4=1;
	RJMP _0x125
_0x122:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0xF
	BRLO _0x126
	SBI  0x12,4
; 0000 007B else if (y_old >= 4)  PORTD.3=1;
	RJMP _0x129
_0x126:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x10
	BRLO _0x12A
	SBI  0x12,3
; 0000 007C else if (y_old >= 3)  PORTD.2=1;
	RJMP _0x12D
_0x12A:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x11
	BRLO _0x12E
	SBI  0x12,2
; 0000 007D else if (y_old >= 2)  PORTD.1=1;
	RJMP _0x131
_0x12E:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x12
	BRLO _0x132
	SBI  0x12,1
; 0000 007E else if (y_old >= 1)  PORTD.0=1;
	RJMP _0x135
_0x132:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x13
	BRLO _0x136
	SBI  0x12,0
; 0000 007F };
_0x136:
_0x135:
_0x131:
_0x12D:
_0x129:
_0x125:
_0x121:
_0x11D:
_0x119:
_0x115:
_0x111:
_0x10D:
_0x109:
_0x105:
_0x101:
_0xFD:
_0xF7:
; 0000 0080 
; 0000 0081 if(x==4)
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BREQ PC+3
	JMP _0x139
; 0000 0082 {
; 0000 0083 
; 0000 0084 if (y_old2 < y) y_old2 = y;
	LD   R30,Y
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x2
	CALL __CMPF12
	BRSH _0x13A
	LD   R30,Y
	LDI  R26,LOW(_y_old2)
	LDI  R27,HIGH(_y_old2)
	RCALL SUBOPT_0x2
	CALL __PUTDP1
; 0000 0085 else y_old2 = y_old2-0.002;
	RJMP _0x13B
_0x13A:
	LDS  R30,_y_old2
	LDS  R31,_y_old2+1
	LDS  R22,_y_old2+2
	LDS  R23,_y_old2+3
	RCALL SUBOPT_0x3
	STS  _y_old2,R30
	STS  _y_old2+1,R31
	STS  _y_old2+2,R22
	STS  _y_old2+3,R23
; 0000 0086 
; 0000 0087      if (y_old2 >=16)  PORTC.7=1;
_0x13B:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x4
	BRLO _0x13C
	SBI  0x15,7
; 0000 0088 else if (y_old2 >=15)  PORTC.6=1;
	RJMP _0x13F
_0x13C:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x5
	BRLO _0x140
	SBI  0x15,6
; 0000 0089 else if (y_old2 >=14)  PORTC.5=1;
	RJMP _0x143
_0x140:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x6
	BRLO _0x144
	SBI  0x15,5
; 0000 008A else if (y_old2 >=13)  PORTC.4=1;
	RJMP _0x147
_0x144:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x7
	BRLO _0x148
	SBI  0x15,4
; 0000 008B else if (y_old2 >=12)  PORTC.3=1;
	RJMP _0x14B
_0x148:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	BRLO _0x14C
	SBI  0x15,3
; 0000 008C else if (y_old2 >=11)  PORTC.2=1;
	RJMP _0x14F
_0x14C:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x9
	BRLO _0x150
	SBI  0x15,2
; 0000 008D else if (y_old2 >=10)  PORTC.1=1;
	RJMP _0x153
_0x150:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xA
	BRLO _0x154
	SBI  0x15,1
; 0000 008E else if (y_old2 >= 9)  PORTC.0=1;
	RJMP _0x157
_0x154:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xB
	BRLO _0x158
	SBI  0x15,0
; 0000 008F else if (y_old2 >= 8)  PORTD.7=1;
	RJMP _0x15B
_0x158:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xC
	BRLO _0x15C
	SBI  0x12,7
; 0000 0090 else if (y_old2 >= 7)  PORTD.6=1;
	RJMP _0x15F
_0x15C:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xD
	BRLO _0x160
	SBI  0x12,6
; 0000 0091 else if (y_old2 >= 6)  PORTD.5=1;
	RJMP _0x163
_0x160:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xE
	BRLO _0x164
	SBI  0x12,5
; 0000 0092 else if (y_old2 >= 5)  PORTD.4=1;
	RJMP _0x167
_0x164:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0xF
	BRLO _0x168
	SBI  0x12,4
; 0000 0093 else if (y_old2 >= 4)  PORTD.3=1;
	RJMP _0x16B
_0x168:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x10
	BRLO _0x16C
	SBI  0x12,3
; 0000 0094 else if (y_old2 >= 3)  PORTD.2=1;
	RJMP _0x16F
_0x16C:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x11
	BRLO _0x170
	SBI  0x12,2
; 0000 0095 else if (y_old2 >= 2)  PORTD.1=1;
	RJMP _0x173
_0x170:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x12
	BRLO _0x174
	SBI  0x12,1
; 0000 0096 else if (y_old2 >= 1)  PORTD.0=1;
	RJMP _0x177
_0x174:
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	BRLO _0x178
	SBI  0x12,0
; 0000 0097 };
_0x178:
_0x177:
_0x173:
_0x16F:
_0x16B:
_0x167:
_0x163:
_0x15F:
_0x15B:
_0x157:
_0x153:
_0x14F:
_0x14B:
_0x147:
_0x143:
_0x13F:
_0x139:
; 0000 0098 
; 0000 0099      if (x==3) _3=0, _4=1, _5=1;
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x17B
	CBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
; 0000 009A else if (x==4) _3=1, _4=0, _5=1;
	RJMP _0x182
_0x17B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x183
	SBI  0x18,0
	CBI  0x18,1
	SBI  0x18,2
; 0000 009B else           _3=1, _4=1, _5=0;
	RJMP _0x18A
_0x183:
	SBI  0x18,0
	SBI  0x18,1
	CBI  0x18,2
; 0000 009C 
; 0000 009D delay_us(200);
_0x18A:
_0x182:
	RJMP _0x2000001
; 0000 009E _3=1, _4=1, _5=1;
; 0000 009F return;
; 0000 00A0 }
;
;void codegen3 (char x, char y)
; 0000 00A3 {
_codegen3:
; 0000 00A4      if (y== 0)  PORTC=0x00, PORTD=0x00;
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x197
	LDI  R30,LOW(0)
	RJMP _0x27A
; 0000 00A5 else if (y== 1)  PORTC=0x00, PORTD=0x01;
_0x197:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x199
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(1)
	RJMP _0x27B
; 0000 00A6 else if (y== 2)  PORTC=0x00, PORTD=0x02;
_0x199:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x19B
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(2)
	RJMP _0x27B
; 0000 00A7 else if (y== 3)  PORTC=0x00, PORTD=0x04;
_0x19B:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x19D
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(4)
	RJMP _0x27B
; 0000 00A8 else if (y== 4)  PORTC=0x00, PORTD=0x08;
_0x19D:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x19F
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(8)
	RJMP _0x27B
; 0000 00A9 else if (y== 5)  PORTC=0x00, PORTD=0x10;
_0x19F:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x1A1
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(16)
	RJMP _0x27B
; 0000 00AA else if (y== 6)  PORTC=0x00, PORTD=0x20;
_0x1A1:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x1A3
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(32)
	RJMP _0x27B
; 0000 00AB else if (y== 7)  PORTC=0x00, PORTD=0x40;
_0x1A3:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x1A5
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(64)
	RJMP _0x27B
; 0000 00AC else if (y== 8)  PORTC=0x00, PORTD=0x80;
_0x1A5:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x1A7
	LDI  R30,LOW(0)
	OUT  0x15,R30
	LDI  R30,LOW(128)
	RJMP _0x27B
; 0000 00AD else if (y== 9)  PORTC=0x01, PORTD=0x00;
_0x1A7:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x1A9
	LDI  R30,LOW(1)
	RJMP _0x27A
; 0000 00AE else if (y==10)  PORTC=0x02, PORTD=0x00;
_0x1A9:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x1AB
	LDI  R30,LOW(2)
	RJMP _0x27A
; 0000 00AF else if (y==11)  PORTC=0x04, PORTD=0x00;
_0x1AB:
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0x1AD
	LDI  R30,LOW(4)
	RJMP _0x27A
; 0000 00B0 else if (y==12)  PORTC=0x08, PORTD=0x00;
_0x1AD:
	LD   R26,Y
	CPI  R26,LOW(0xC)
	BRNE _0x1AF
	LDI  R30,LOW(8)
	RJMP _0x27A
; 0000 00B1 else if (y==13)  PORTC=0x10, PORTD=0x00;
_0x1AF:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x1B1
	LDI  R30,LOW(16)
	RJMP _0x27A
; 0000 00B2 else if (y==14)  PORTC=0x20, PORTD=0x00;
_0x1B1:
	LD   R26,Y
	CPI  R26,LOW(0xE)
	BRNE _0x1B3
	LDI  R30,LOW(32)
	RJMP _0x27A
; 0000 00B3 else if (y==15)  PORTC=0x40, PORTD=0x00;
_0x1B3:
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0x1B5
	LDI  R30,LOW(64)
	RJMP _0x27A
; 0000 00B4 else             PORTC=0x80, PORTD=0x00;
_0x1B5:
	LDI  R30,LOW(128)
_0x27A:
	OUT  0x15,R30
	LDI  R30,LOW(0)
_0x27B:
	OUT  0x12,R30
; 0000 00B5 
; 0000 00B6      if (x==3) _3=0, _4=1, _5=1;
	LDD  R26,Y+1
	CPI  R26,LOW(0x3)
	BRNE _0x1B7
	CBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
; 0000 00B7 else if (x==4) _3=1, _4=0, _5=1;
	RJMP _0x1BE
_0x1B7:
	LDD  R26,Y+1
	CPI  R26,LOW(0x4)
	BRNE _0x1BF
	SBI  0x18,0
	CBI  0x18,1
	SBI  0x18,2
; 0000 00B8 else           _3=1, _4=1, _5=0;
	RJMP _0x1C6
_0x1BF:
	SBI  0x18,0
	SBI  0x18,1
	CBI  0x18,2
; 0000 00B9 
; 0000 00BA delay_us(200);
_0x1C6:
_0x1BE:
_0x2000001:
	__DELAY_USW 400
; 0000 00BB _3=1, _4=1, _5=1;
	SBI  0x18,0
	SBI  0x18,1
	SBI  0x18,2
; 0000 00BC return;
_0x2000002:
	ADIW R28,2
	RET
; 0000 00BD }
;
;void read(void)
; 0000 00C0 {
_read:
; 0000 00C1 in_0 = read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOVW R12,R30
; 0000 00C2 in_1 = read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	STS  _in_1,R30
	STS  _in_1+1,R31
; 0000 00C3 in_2 = read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	STS  _in_2,R30
	STS  _in_2+1,R31
; 0000 00C4 }
	RET
;
;void preobr(float a,float b, float c)
; 0000 00C7 {
_preobr:
; 0000 00C8 a = a / cor;
;	a -> Y+8
;	b -> Y+4
;	c -> Y+0
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	CALL __DIVF21
	__PUTD1S 8
; 0000 00C9 b = b / cor;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x17
	CALL __DIVF21
	__PUTD1S 4
; 0000 00CA c = c / cor;
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x18
	CALL __DIVF21
	RCALL SUBOPT_0x19
; 0000 00CB 
; 0000 00CC      if (a >= 960)   seg3=16;
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1A
	BRLO _0x1D3
	LDI  R30,LOW(16)
	MOV  R6,R30
; 0000 00CD else if (a >= 896)   seg3=15;
	RJMP _0x1D4
_0x1D3:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1B
	BRLO _0x1D5
	LDI  R30,LOW(15)
	MOV  R6,R30
; 0000 00CE else if (a >= 832)   seg3=14;
	RJMP _0x1D6
_0x1D5:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1C
	BRLO _0x1D7
	LDI  R30,LOW(14)
	MOV  R6,R30
; 0000 00CF else if (a >= 768)   seg3=13;
	RJMP _0x1D8
_0x1D7:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1D
	BRLO _0x1D9
	LDI  R30,LOW(13)
	MOV  R6,R30
; 0000 00D0 else if (a >= 704)   seg3=12;
	RJMP _0x1DA
_0x1D9:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1E
	BRLO _0x1DB
	LDI  R30,LOW(12)
	MOV  R6,R30
; 0000 00D1 else if (a >= 640)   seg3=11;
	RJMP _0x1DC
_0x1DB:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1F
	BRLO _0x1DD
	LDI  R30,LOW(11)
	MOV  R6,R30
; 0000 00D2 else if (a >= 576)   seg3=10;
	RJMP _0x1DE
_0x1DD:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x20
	BRLO _0x1DF
	LDI  R30,LOW(10)
	MOV  R6,R30
; 0000 00D3 else if (a >= 512)   seg3=9;
	RJMP _0x1E0
_0x1DF:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x21
	BRLO _0x1E1
	LDI  R30,LOW(9)
	MOV  R6,R30
; 0000 00D4 else if (a >= 448)   seg3=8;
	RJMP _0x1E2
_0x1E1:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x22
	BRLO _0x1E3
	LDI  R30,LOW(8)
	MOV  R6,R30
; 0000 00D5 else if (a >= 384)   seg3=7;
	RJMP _0x1E4
_0x1E3:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x23
	BRLO _0x1E5
	LDI  R30,LOW(7)
	MOV  R6,R30
; 0000 00D6 else if (a >= 320)   seg3=6;
	RJMP _0x1E6
_0x1E5:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x24
	BRLO _0x1E7
	LDI  R30,LOW(6)
	MOV  R6,R30
; 0000 00D7 else if (a >= 256)   seg3=5;
	RJMP _0x1E8
_0x1E7:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x25
	BRLO _0x1E9
	LDI  R30,LOW(5)
	MOV  R6,R30
; 0000 00D8 else if (a >= 192)   seg3=4;
	RJMP _0x1EA
_0x1E9:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x26
	BRLO _0x1EB
	LDI  R30,LOW(4)
	MOV  R6,R30
; 0000 00D9 else if (a >= 128)   seg3=3;
	RJMP _0x1EC
_0x1EB:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x27
	BRLO _0x1ED
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 00DA else if (a >= 64 )   seg3=2;
	RJMP _0x1EE
_0x1ED:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x28
	BRLO _0x1EF
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 00DB else if (a >= 32 )   seg3=1;
	RJMP _0x1F0
_0x1EF:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x29
	BRLO _0x1F1
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00DC else                 seg3=0;
	RJMP _0x1F2
_0x1F1:
	CLR  R6
; 0000 00DD 
; 0000 00DE      if (b >= 960)   seg4=16;
_0x1F2:
_0x1F0:
_0x1EE:
_0x1EC:
_0x1EA:
_0x1E8:
_0x1E6:
_0x1E4:
_0x1E2:
_0x1E0:
_0x1DE:
_0x1DC:
_0x1DA:
_0x1D8:
_0x1D6:
_0x1D4:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1A
	BRLO _0x1F3
	LDI  R30,LOW(16)
	MOV  R9,R30
; 0000 00DF else if (b >= 896)   seg4=15;
	RJMP _0x1F4
_0x1F3:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1B
	BRLO _0x1F5
	LDI  R30,LOW(15)
	MOV  R9,R30
; 0000 00E0 else if (b >= 832)   seg4=14;
	RJMP _0x1F6
_0x1F5:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1C
	BRLO _0x1F7
	LDI  R30,LOW(14)
	MOV  R9,R30
; 0000 00E1 else if (b >= 768)   seg4=13;
	RJMP _0x1F8
_0x1F7:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1D
	BRLO _0x1F9
	LDI  R30,LOW(13)
	MOV  R9,R30
; 0000 00E2 else if (b >= 704)   seg4=12;
	RJMP _0x1FA
_0x1F9:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1E
	BRLO _0x1FB
	LDI  R30,LOW(12)
	MOV  R9,R30
; 0000 00E3 else if (b >= 640)   seg4=11;
	RJMP _0x1FC
_0x1FB:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1F
	BRLO _0x1FD
	LDI  R30,LOW(11)
	MOV  R9,R30
; 0000 00E4 else if (b >= 576)   seg4=10;
	RJMP _0x1FE
_0x1FD:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x20
	BRLO _0x1FF
	LDI  R30,LOW(10)
	MOV  R9,R30
; 0000 00E5 else if (b >= 512)   seg4=9;
	RJMP _0x200
_0x1FF:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x21
	BRLO _0x201
	LDI  R30,LOW(9)
	MOV  R9,R30
; 0000 00E6 else if (b >= 448)   seg4=8;
	RJMP _0x202
_0x201:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x22
	BRLO _0x203
	LDI  R30,LOW(8)
	MOV  R9,R30
; 0000 00E7 else if (b >= 384)   seg4=7;
	RJMP _0x204
_0x203:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x23
	BRLO _0x205
	LDI  R30,LOW(7)
	MOV  R9,R30
; 0000 00E8 else if (b >= 320)   seg4=6;
	RJMP _0x206
_0x205:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x24
	BRLO _0x207
	LDI  R30,LOW(6)
	MOV  R9,R30
; 0000 00E9 else if (b >= 256)   seg4=5;
	RJMP _0x208
_0x207:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x25
	BRLO _0x209
	LDI  R30,LOW(5)
	MOV  R9,R30
; 0000 00EA else if (b >= 192)   seg4=4;
	RJMP _0x20A
_0x209:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x26
	BRLO _0x20B
	LDI  R30,LOW(4)
	MOV  R9,R30
; 0000 00EB else if (b >= 128)   seg4=3;
	RJMP _0x20C
_0x20B:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x27
	BRLO _0x20D
	LDI  R30,LOW(3)
	MOV  R9,R30
; 0000 00EC else if (b >= 64 )   seg4=2;
	RJMP _0x20E
_0x20D:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x28
	BRLO _0x20F
	LDI  R30,LOW(2)
	MOV  R9,R30
; 0000 00ED else if (b >= 32 )   seg4=1;
	RJMP _0x210
_0x20F:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x29
	BRLO _0x211
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 00EE else                 seg4=0;
	RJMP _0x212
_0x211:
	CLR  R9
; 0000 00EF 
; 0000 00F0      if (c >= 960)   seg5=16;
_0x212:
_0x210:
_0x20E:
_0x20C:
_0x20A:
_0x208:
_0x206:
_0x204:
_0x202:
_0x200:
_0x1FE:
_0x1FC:
_0x1FA:
_0x1F8:
_0x1F6:
_0x1F4:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1A
	BRLO _0x213
	LDI  R30,LOW(16)
	MOV  R8,R30
; 0000 00F1 else if (c >= 896)   seg5=15;
	RJMP _0x214
_0x213:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1B
	BRLO _0x215
	LDI  R30,LOW(15)
	MOV  R8,R30
; 0000 00F2 else if (c >= 832)   seg5=14;
	RJMP _0x216
_0x215:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1C
	BRLO _0x217
	LDI  R30,LOW(14)
	MOV  R8,R30
; 0000 00F3 else if (c >= 768)   seg5=13;
	RJMP _0x218
_0x217:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1D
	BRLO _0x219
	LDI  R30,LOW(13)
	MOV  R8,R30
; 0000 00F4 else if (c >= 704)   seg5=12;
	RJMP _0x21A
_0x219:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1E
	BRLO _0x21B
	LDI  R30,LOW(12)
	MOV  R8,R30
; 0000 00F5 else if (c >= 640)   seg5=11;
	RJMP _0x21C
_0x21B:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1F
	BRLO _0x21D
	LDI  R30,LOW(11)
	MOV  R8,R30
; 0000 00F6 else if (c >= 576)   seg5=10;
	RJMP _0x21E
_0x21D:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x20
	BRLO _0x21F
	LDI  R30,LOW(10)
	MOV  R8,R30
; 0000 00F7 else if (c >= 512)   seg5=9;
	RJMP _0x220
_0x21F:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x21
	BRLO _0x221
	LDI  R30,LOW(9)
	MOV  R8,R30
; 0000 00F8 else if (c >= 448)   seg5=8;
	RJMP _0x222
_0x221:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x22
	BRLO _0x223
	LDI  R30,LOW(8)
	MOV  R8,R30
; 0000 00F9 else if (c >= 384)   seg5=7;
	RJMP _0x224
_0x223:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x23
	BRLO _0x225
	LDI  R30,LOW(7)
	MOV  R8,R30
; 0000 00FA else if (c >= 320)   seg5=6;
	RJMP _0x226
_0x225:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x24
	BRLO _0x227
	LDI  R30,LOW(6)
	MOV  R8,R30
; 0000 00FB else if (c >= 256)   seg5=5;
	RJMP _0x228
_0x227:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x25
	BRLO _0x229
	LDI  R30,LOW(5)
	MOV  R8,R30
; 0000 00FC else if (c >= 192)   seg5=4;
	RJMP _0x22A
_0x229:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x26
	BRLO _0x22B
	LDI  R30,LOW(4)
	MOV  R8,R30
; 0000 00FD else if (c >= 128)   seg5=3;
	RJMP _0x22C
_0x22B:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x27
	BRLO _0x22D
	LDI  R30,LOW(3)
	MOV  R8,R30
; 0000 00FE else if (c >= 64 )   seg5=2;
	RJMP _0x22E
_0x22D:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x28
	BRLO _0x22F
	LDI  R30,LOW(2)
	MOV  R8,R30
; 0000 00FF else if (c >= 32 )   seg5=1;
	RJMP _0x230
_0x22F:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x29
	BRLO _0x231
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0100 else                 seg5=0;
	RJMP _0x232
_0x231:
	CLR  R8
; 0000 0101 }
_0x232:
_0x230:
_0x22E:
_0x22C:
_0x22A:
_0x228:
_0x226:
_0x224:
_0x222:
_0x220:
_0x21E:
_0x21C:
_0x21A:
_0x218:
_0x216:
_0x214:
	ADIW R28,12
	RET
;
;void preobr2 (float a)
; 0000 0104 {
_preobr2:
; 0000 0105      if (a >= 900)   seg0=9, a=a - 900;
;	a -> Y+0
	RCALL SUBOPT_0x18
	__GETD1N 0x44610000
	CALL __CMPF12
	BRLO _0x233
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x2A
	__GETD2N 0x44610000
	RCALL SUBOPT_0x2B
; 0000 0106 else if (a >= 800)   seg0=8, a=a - 800;
	RJMP _0x234
_0x233:
	RCALL SUBOPT_0x18
	__GETD1N 0x44480000
	CALL __CMPF12
	BRLO _0x235
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x2A
	__GETD2N 0x44480000
	RCALL SUBOPT_0x2B
; 0000 0107 else if (a >= 700)   seg0=7, a=a - 700;
	RJMP _0x236
_0x235:
	RCALL SUBOPT_0x18
	__GETD1N 0x442F0000
	CALL __CMPF12
	BRLO _0x237
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x2A
	__GETD2N 0x442F0000
	RCALL SUBOPT_0x2B
; 0000 0108 else if (a >= 600)   seg0=6, a=a - 600;
	RJMP _0x238
_0x237:
	RCALL SUBOPT_0x18
	__GETD1N 0x44160000
	CALL __CMPF12
	BRLO _0x239
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x2A
	__GETD2N 0x44160000
	RCALL SUBOPT_0x2B
; 0000 0109 else if (a >= 500)   seg0=5, a=a - 500;
	RJMP _0x23A
_0x239:
	RCALL SUBOPT_0x18
	__GETD1N 0x43FA0000
	CALL __CMPF12
	BRLO _0x23B
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x2A
	__GETD2N 0x43FA0000
	RCALL SUBOPT_0x2B
; 0000 010A else if (a >= 400)   seg0=4, a=a - 400;
	RJMP _0x23C
_0x23B:
	RCALL SUBOPT_0x18
	__GETD1N 0x43C80000
	CALL __CMPF12
	BRLO _0x23D
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2A
	__GETD2N 0x43C80000
	RCALL SUBOPT_0x2B
; 0000 010B else if (a >= 300)   seg0=3, a=a - 300;
	RJMP _0x23E
_0x23D:
	RCALL SUBOPT_0x18
	__GETD1N 0x43960000
	CALL __CMPF12
	BRLO _0x23F
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x2A
	__GETD2N 0x43960000
	RCALL SUBOPT_0x2B
; 0000 010C else if (a >= 200)   seg0=2, a=a - 200;
	RJMP _0x240
_0x23F:
	RCALL SUBOPT_0x18
	__GETD1N 0x43480000
	CALL __CMPF12
	BRLO _0x241
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2A
	__GETD2N 0x43480000
	RCALL SUBOPT_0x2B
; 0000 010D else if (a >= 100)   seg0=1, a=a - 100;
	RJMP _0x242
_0x241:
	RCALL SUBOPT_0x18
	__GETD1N 0x42C80000
	CALL __CMPF12
	BRLO _0x243
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2A
	__GETD2N 0x42C80000
	RCALL SUBOPT_0x2B
; 0000 010E else                 seg0=10;
	RJMP _0x244
_0x243:
	LDI  R30,LOW(10)
	MOV  R5,R30
; 0000 010F 
; 0000 0110 if      (a >= 90)    seg1=9, a=a-90;
_0x244:
_0x242:
_0x240:
_0x23E:
_0x23C:
_0x23A:
_0x238:
_0x236:
_0x234:
	RCALL SUBOPT_0x18
	__GETD1N 0x42B40000
	CALL __CMPF12
	BRLO _0x245
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x2C
	__GETD2N 0x42B40000
	RCALL SUBOPT_0x2B
; 0000 0111 else if (a >= 80)    seg1=8, a=a-80;
	RJMP _0x246
_0x245:
	RCALL SUBOPT_0x18
	__GETD1N 0x42A00000
	CALL __CMPF12
	BRLO _0x247
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x2C
	__GETD2N 0x42A00000
	RCALL SUBOPT_0x2B
; 0000 0112 else if (a >= 70)    seg1=7, a=a-70;
	RJMP _0x248
_0x247:
	RCALL SUBOPT_0x18
	__GETD1N 0x428C0000
	CALL __CMPF12
	BRLO _0x249
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x2C
	__GETD2N 0x428C0000
	RCALL SUBOPT_0x2B
; 0000 0113 else if (a >= 60)    seg1=6, a=a-60;
	RJMP _0x24A
_0x249:
	RCALL SUBOPT_0x18
	__GETD1N 0x42700000
	CALL __CMPF12
	BRLO _0x24B
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x2C
	__GETD2N 0x42700000
	RCALL SUBOPT_0x2B
; 0000 0114 else if (a >= 50)    seg1=5, a=a-50;
	RJMP _0x24C
_0x24B:
	RCALL SUBOPT_0x18
	__GETD1N 0x42480000
	CALL __CMPF12
	BRLO _0x24D
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x2C
	__GETD2N 0x42480000
	RCALL SUBOPT_0x2B
; 0000 0115 else if (a >= 40)    seg1=4, a=a-40;
	RJMP _0x24E
_0x24D:
	RCALL SUBOPT_0x18
	__GETD1N 0x42200000
	CALL __CMPF12
	BRLO _0x24F
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x2C
	__GETD2N 0x42200000
	RCALL SUBOPT_0x2B
; 0000 0116 else if (a >= 30)    seg1=3, a=a-30;
	RJMP _0x250
_0x24F:
	RCALL SUBOPT_0x18
	__GETD1N 0x41F00000
	CALL __CMPF12
	BRLO _0x251
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x2C
	__GETD2N 0x41F00000
	RCALL SUBOPT_0x2B
; 0000 0117 else if (a >= 20)    seg1=2, a=a-20;
	RJMP _0x252
_0x251:
	RCALL SUBOPT_0x18
	__GETD1N 0x41A00000
	CALL __CMPF12
	BRLO _0x253
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2C
	__GETD2N 0x41A00000
	RCALL SUBOPT_0x2B
; 0000 0118 else if (a >= 10)    seg1=1, a=a-10;
	RJMP _0x254
_0x253:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xA
	BRLO _0x255
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2C
	__GETD2N 0x41200000
	RCALL SUBOPT_0x2B
; 0000 0119 else                 seg1=0;
	RJMP _0x256
_0x255:
	CLR  R4
; 0000 011A 
; 0000 011B if      (a >= 9)     seg2=9;
_0x256:
_0x254:
_0x252:
_0x250:
_0x24E:
_0x24C:
_0x24A:
_0x248:
_0x246:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xB
	BRLO _0x257
	LDI  R30,LOW(9)
	MOV  R7,R30
; 0000 011C else if (a >= 8)     seg2=8;
	RJMP _0x258
_0x257:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xC
	BRLO _0x259
	LDI  R30,LOW(8)
	MOV  R7,R30
; 0000 011D else if (a >= 7)     seg2=7;
	RJMP _0x25A
_0x259:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xD
	BRLO _0x25B
	LDI  R30,LOW(7)
	MOV  R7,R30
; 0000 011E else if (a >= 6)     seg2=6;
	RJMP _0x25C
_0x25B:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xE
	BRLO _0x25D
	LDI  R30,LOW(6)
	MOV  R7,R30
; 0000 011F else if (a >= 5)     seg2=5;
	RJMP _0x25E
_0x25D:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xF
	BRLO _0x25F
	LDI  R30,LOW(5)
	MOV  R7,R30
; 0000 0120 else if (a >= 4)     seg2=4;
	RJMP _0x260
_0x25F:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x10
	BRLO _0x261
	LDI  R30,LOW(4)
	MOV  R7,R30
; 0000 0121 else if (a >= 3)     seg2=3;
	RJMP _0x262
_0x261:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x11
	BRLO _0x263
	LDI  R30,LOW(3)
	MOV  R7,R30
; 0000 0122 else if (a >= 2)     seg2=2;
	RJMP _0x264
_0x263:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x12
	BRLO _0x265
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 0123 else if (a >= 1)     seg2=1;
	RJMP _0x266
_0x265:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x13
	BRLO _0x267
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0124 else                 seg2=0;
	RJMP _0x268
_0x267:
	CLR  R7
; 0000 0125 }
_0x268:
_0x266:
_0x264:
_0x262:
_0x260:
_0x25E:
_0x25C:
_0x25A:
_0x258:
	ADIW R28,4
	RET
;
;void main(void)
; 0000 0128 {
_main:
; 0000 0129 // Declare your local variables here
; 0000 012A 
; 0000 012B // Input/Output Ports initialization
; 0000 012C // Port A initialization
; 0000 012D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 012E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 012F PORTA=0xE0;
	LDI  R30,LOW(224)
	OUT  0x1B,R30
; 0000 0130 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0131 
; 0000 0132 // Port B initialization
; 0000 0133 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0134 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0135 PORTB=0x00;
	OUT  0x18,R30
; 0000 0136 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0137 
; 0000 0138 // Port C initialization
; 0000 0139 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 013A // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 013B PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 013C DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 013D 
; 0000 013E // Port D initialization
; 0000 013F // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0140 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0141 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0142 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0143 
; 0000 0144 // Timer/Counter 0 initialization
; 0000 0145 // Clock source: System Clock
; 0000 0146 // Clock value: Timer 0 Stopped
; 0000 0147 // Mode: Normal top=FFh
; 0000 0148 // OC0 output: Disconnected
; 0000 0149 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 014A TCNT0=0x00;
	OUT  0x32,R30
; 0000 014B OCR0=0x00;
	OUT  0x3C,R30
; 0000 014C 
; 0000 014D // Timer/Counter 1 initialization
; 0000 014E // Clock source: System Clock
; 0000 014F // Clock value: Timer1 Stopped
; 0000 0150 // Mode: Normal top=FFFFh
; 0000 0151 // OC1A output: Discon.
; 0000 0152 // OC1B output: Discon.
; 0000 0153 // Noise Canceler: Off
; 0000 0154 // Input Capture on Falling Edge
; 0000 0155 // Timer1 Overflow Interrupt: Off
; 0000 0156 // Input Capture Interrupt: Off
; 0000 0157 // Compare A Match Interrupt: Off
; 0000 0158 // Compare B Match Interrupt: Off
; 0000 0159 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 015A TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 015B TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 015C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 015D ICR1H=0x00;
	OUT  0x27,R30
; 0000 015E ICR1L=0x00;
	OUT  0x26,R30
; 0000 015F OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0160 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0161 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0162 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0163 
; 0000 0164 // Timer/Counter 2 initialization
; 0000 0165 // Clock source: System Clock
; 0000 0166 // Clock value: Timer2 Stopped
; 0000 0167 // Mode: Normal top=FFh
; 0000 0168 // OC2 output: Disconnected
; 0000 0169 ASSR=0x00;
	OUT  0x22,R30
; 0000 016A TCCR2=0x00;
	OUT  0x25,R30
; 0000 016B TCNT2=0x00;
	OUT  0x24,R30
; 0000 016C OCR2=0x00;
	OUT  0x23,R30
; 0000 016D 
; 0000 016E // External Interrupt(s) initialization
; 0000 016F // INT0: Off
; 0000 0170 // INT1: Off
; 0000 0171 // INT2: Off
; 0000 0172 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0173 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0174 
; 0000 0175 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0176 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0177 
; 0000 0178 // Analog Comparator initialization
; 0000 0179 // Analog Comparator: Off
; 0000 017A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 017B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 017C SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 017D 
; 0000 017E // ADC initialization
; 0000 017F // ADC Clock frequency: 250,000 kHz
; 0000 0180 // ADC Voltage Reference: AVCC pin
; 0000 0181 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0182 ADCSRA=0x85;
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 0183 
; 0000 0184 while (1)
_0x269:
; 0000 0185       {
; 0000 0186       // Place your code here
; 0000 0187       read();
	RCALL _read
; 0000 0188       i++;
	INC  R11
; 0000 0189       if (PINA.5==0) dis=0;
	SBIC 0x19,5
	RJMP _0x26C
	LDI  R30,LOW(0)
	STS  _dis,R30
	STS  _dis+1,R30
; 0000 018A       if (PINA.6==0) dis=1;
_0x26C:
	SBIC 0x19,6
	RJMP _0x26D
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dis,R30
	STS  _dis+1,R31
; 0000 018B       if (PINA.7==0) dis=2;
_0x26D:
	SBIC 0x19,7
	RJMP _0x26E
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _dis,R30
	STS  _dis+1,R31
; 0000 018C       if      (dis==0) disp=in_0;
_0x26E:
	LDS  R30,_dis
	LDS  R31,_dis+1
	SBIW R30,0
	BRNE _0x26F
	__PUTWMRN _disp,0,12,13
; 0000 018D       else if (dis==1) disp=in_1;
	RJMP _0x270
_0x26F:
	LDS  R26,_dis
	LDS  R27,_dis+1
	SBIW R26,1
	BRNE _0x271
	LDS  R30,_in_1
	LDS  R31,_in_1+1
	RJMP _0x27C
; 0000 018E       else             disp=in_2;
_0x271:
	LDS  R30,_in_2
	LDS  R31,_in_2+1
_0x27C:
	STS  _disp,R30
	STS  _disp+1,R31
; 0000 018F 
; 0000 0190       if (i >= 50) preobr(in_0, in_1, in_2), preobr2(disp), i=0;
_0x270:
	LDI  R30,LOW(50)
	CP   R11,R30
	BRLO _0x273
	MOVW R30,R12
	RCALL SUBOPT_0x2D
	LDS  R30,_in_1
	LDS  R31,_in_1+1
	RCALL SUBOPT_0x2D
	LDS  R30,_in_2
	LDS  R31,_in_2+1
	RCALL SUBOPT_0x2D
	RCALL _preobr
	LDS  R30,_disp
	LDS  R31,_disp+1
	RCALL SUBOPT_0x2D
	RCALL _preobr2
	CLR  R11
; 0000 0191 
; 0000 0192       codegen(0,seg0);
_0x273:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R5
	RCALL _codegen
; 0000 0193       codegen(1,seg1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R4
	RCALL _codegen
; 0000 0194       codegen(2,seg2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R7
	RCALL _codegen
; 0000 0195       codegen2(3,seg3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R6
	RCALL _codegen2
; 0000 0196       codegen2(4,seg4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	ST   -Y,R9
	RCALL _codegen2
; 0000 0197       codegen3(5,seg5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	ST   -Y,R8
	RCALL _codegen3
; 0000 0198       };
	RJMP _0x269
; 0000 0199 }
_0x274:
	RJMP _0x274

	.DSEG
_in_1:
	.BYTE 0x2
_in_2:
	.BYTE 0x2
_disp:
	.BYTE 0x2
_dis:
	.BYTE 0x2
_cor:
	.BYTE 0x4
_y_old:
	.BYTE 0x4
_y_old2:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	SBI  0x15,0
	SBI  0x15,1
	SBI  0x15,2
	SBI  0x15,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x1:
	LDS  R26,_y_old
	LDS  R27,_y_old+1
	LDS  R24,_y_old+2
	LDS  R25,_y_old+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD2N 0x3B03126F
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETD1N 0x41800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__GETD1N 0x41700000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	__GETD1N 0x41600000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD1N 0x41500000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x41400000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD1N 0x41300000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	__GETD1N 0x41200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	__GETD1N 0x41100000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	__GETD1N 0x41000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	__GETD1N 0x40E00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	__GETD1N 0x40C00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	__GETD1N 0x40A00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	__GETD1N 0x40800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__GETD1N 0x40400000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	__GETD1N 0x40000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	__GETD1N 0x3F800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x14:
	LDS  R26,_y_old2
	LDS  R27,_y_old2+1
	LDS  R24,_y_old2+2
	LDS  R25,_y_old2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	LDS  R30,_cor
	LDS  R31,_cor+1
	LDS  R22,_cor+2
	LDS  R23,_cor+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x16:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x17:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x18:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x19:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	__GETD1N 0x44700000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	__GETD1N 0x44600000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	__GETD1N 0x44500000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	__GETD1N 0x44400000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__GETD1N 0x44300000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	__GETD1N 0x44200000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	__GETD1N 0x44100000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	__GETD1N 0x44000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	__GETD1N 0x43E00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	__GETD1N 0x43C00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x24:
	__GETD1N 0x43A00000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__GETD1N 0x43800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	__GETD1N 0x43400000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__GETD1N 0x43000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	__GETD1N 0x42800000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	__GETD1N 0x42000000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	MOV  R5,R30
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x2B:
	CALL __SUBF12
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2C:
	MOV  R4,R30
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTPARD1
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

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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

;END OF CODE MARKER
__END_OF_CODE:
