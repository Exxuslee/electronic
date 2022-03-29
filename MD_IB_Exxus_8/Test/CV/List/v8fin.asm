
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
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
	.DEF _st_zero_A=R4
	.DEF _st_zero_F=R6
	.DEF _din_zero_A=R8
	.DEF _bar=R11
	.DEF _rezym=R10
	.DEF _din_A=R13
	.DEF _viz_ampl=R12

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x25,0x32,0x2E,0x31,0x66,0x56,0x20,0x42
	.DB  0x3D,0x25,0x64,0x20,0x0,0x53,0x74,0x5F
	.DB  0x56,0x65,0x63,0x0,0x53,0x74,0x5F,0x52
	.DB  0x61,0x73,0x0,0x20,0x44,0x69,0x6E,0x61
	.DB  0x6D,0x0,0x53,0x74,0x6F,0x70,0x54,0x58
	.DB  0x0,0x28,0x25,0x30,0x33,0x2E,0x30,0x66
	.DB  0x3A,0x25,0x2B,0x2E,0x32,0x66,0x29,0x29
	.DB  0x3D,0x5A,0x0,0x2B,0x52,0x0,0x20,0x20
	.DB  0x0,0x2B,0x47,0x0,0x2D,0x46,0x65,0x0
	.DB  0x2B,0x41,0x6C,0x0,0x20,0x5F,0x53,0x74
	.DB  0x61,0x74,0x69,0x63,0x5F,0x56,0x65,0x63
	.DB  0x6B,0x74,0x5F,0x20,0x0,0x20,0x5F,0x53
	.DB  0x74,0x61,0x74,0x69,0x63,0x5F,0x52,0x61
	.DB  0x73,0x74,0x72,0x5F,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x5F,0x44,0x69,0x6E,0x61,0x6D
	.DB  0x69,0x63,0x5F,0x20,0x20,0x20,0x0,0x42
	.DB  0x61,0x72,0x72,0x69,0x65,0x72,0x20,0x25
	.DB  0x64,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x3E,0x3E,0x20,0x52,0x6F,0x63,0x6B
	.DB  0x20,0x28,0x41,0x3A,0x66,0x29,0x20,0x3C
	.DB  0x3C,0x0,0x20,0x20,0x28,0x25,0x30,0x33
	.DB  0x2E,0x30,0x66,0x3A,0x25,0x2B,0x2E,0x32
	.DB  0x66,0x29,0x20,0x20,0x20,0x0,0x3E,0x3E
	.DB  0x3E,0x3E,0x20,0x47,0x2E,0x45,0x2E,0x42
	.DB  0x2E,0x20,0x3C,0x3C,0x3C,0x3C,0x0,0x20
	.DB  0x20,0x25,0x2B,0x64,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x3E,0x20,0x47,0x72,0x6F,0x75,0x6E,0x64
	.DB  0x20,0x28,0x41,0x3B,0x46,0x29,0x20,0x3C
	.DB  0x0,0x3E,0x20,0x5A,0x65,0x72,0x6F,0x20
	.DB  0x20,0x28,0x41,0x3A,0x66,0x29,0x20,0x20
	.DB  0x3C,0x0,0x20,0x20,0x20,0x20,0x20,0x20
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
	.DB  0xFF,0xFF,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x53,0x74,0x6F
	.DB  0x70,0x5F,0x5F,0x54,0x78,0x20,0x20,0x20
	.DB  0x20,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x6F,0x5F,0x4F,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x23,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x23,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x23,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x23,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x23,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x23,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x23,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x23,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x23,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x23,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x23,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x23,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x23,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x23,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0x3E,0x5F,0x3C,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0x3E,0x0,0x46,0x49,0x4E
	.DB  0x44,0x45,0x52,0x20,0x5E,0x5F,0x5E,0x20
	.DB  0x45,0x78,0x78,0x75,0x73,0x0,0x76,0x31
	.DB  0x2E,0x38,0x2E,0x31,0x20,0x20,0x20,0x6D
	.DB  0x64,0x34,0x75,0x2E,0x72,0x75,0x0,0x53
	.DB  0x61,0x76,0x65,0x0,0x4F,0x2E,0x6B,0x2E
	.DB  0x0,0x46,0x72,0x65,0x71,0x2D,0x54,0x58
	.DB  0x20,0x25,0x33,0x78,0x20,0x5B,0x25,0x32
	.DB  0x78,0x5D,0x0,0x46,0x61,0x7A,0x61,0x2D
	.DB  0x58,0x20,0x20,0x25,0x33,0x78,0x20,0x5B
	.DB  0x25,0x32,0x78,0x5D,0x0
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
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
;#define ADC_VREF_TYPE 0x60
;#define Ftx OCR1A
;#define Frx OCR1B
;
;// Declare your global variables here
;char string_LCD_1[20], string_LCD_2[20];
;unsigned int st_zero_A, st_zero_F, din_zero_A;
;float ampl, faza, bar_rad;
;unsigned char bar, rezym;
;unsigned char din_A, viz_ampl, viz_faza, viz_din, din_max, din_min, gnd_F, gnd_A, rock_F, rock_A;
;float batt;
;bit kn1, kn2, kn3, kn4, kn5, kn6, mod_gnd, mod_rock, mod_all_met, zemlq, kamen, menu;
;unsigned char rastr_st[0x20][0x20], gnd_pos_F, gnd_pos_A, rock_pos_F, rock_pos_A, gnd_sekt_F, gnd_sekt_A, rock_sekt_F, rock_sekt_A;
;signed char geb;
;eeprom unsigned int Ftx_ee, Frx_ee;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 002D {

	.CSEG
_read_adc:
; 0000 002E ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 002F // Delay needed for the stabilization of the ADC input voltage
; 0000 0030 delay_us(10);
	__DELAY_USB 53
; 0000 0031 // Start the AD conversion
; 0000 0032 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0033 // Wait for the AD conversion to complete
; 0000 0034 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0035 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0036 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0037 }
;
;void batt_zarqd(void)
; 0000 003A     {
_batt_zarqd:
; 0000 003B     #asm("wdr")
	wdr
; 0000 003C     batt = read_adc(4)/14.0;
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
; 0000 003D     return;
	RET
; 0000 003E     }
;
;void kn_klava(void)
; 0000 0041     {
_kn_klava:
; 0000 0042     #asm("wdr")
	wdr
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
; 0000 0049     DDRA.5=1;
	SBI  0x1A,5
; 0000 004A     PORTA.5=0;
	CBI  0x1B,5
; 0000 004B     delay_ms (2);
	CALL SUBOPT_0x1
; 0000 004C     if (PINA.6==0 && PINA.7==0) kn1=1;
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB
	CALL SUBOPT_0x2
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
	SET
	BLD  R2,0
; 0000 004D     if (PINA.6==1 && PINA.7==0) kn2=1;
_0xA:
	SBIS 0x19,6
	RJMP _0xE
	CALL SUBOPT_0x2
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
	SET
	BLD  R2,1
; 0000 004E     DDRA.5=0;
_0xD:
	CBI  0x1A,5
; 0000 004F     DDRA.6=1;
	SBI  0x1A,6
; 0000 0050     PORTA.5=1;
	SBI  0x1B,5
; 0000 0051     PORTA.6=0;
	CBI  0x1B,6
; 0000 0052     delay_ms (2);
	CALL SUBOPT_0x1
; 0000 0053     if (PINA.5==1 && PINA.7==0) kn3=1;
	SBIS 0x19,5
	RJMP _0x19
	CALL SUBOPT_0x2
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	SET
	BLD  R2,2
; 0000 0054     if (PINA.5==0 && PINA.7==0) kn4=1;
_0x18:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x1C
	CALL SUBOPT_0x2
	BREQ _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
	SET
	BLD  R2,3
; 0000 0055     DDRA.6=0;
_0x1B:
	CBI  0x1A,6
; 0000 0056     DDRA.7=1;
	SBI  0x1A,7
; 0000 0057     PORTA.6=1;
	SBI  0x1B,6
; 0000 0058     PORTA.7=0;
	CBI  0x1B,7
; 0000 0059     delay_ms (2);
	CALL SUBOPT_0x1
; 0000 005A     if (PINA.5==1 && PINA.6==0) kn5=1;
	SBIS 0x19,5
	RJMP _0x27
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,4
; 0000 005B     if (PINA.5==0 && PINA.6==1) kn6=1;
_0x26:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2A
	SBIC 0x19,6
	RJMP _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	SET
	BLD  R2,5
; 0000 005C     DDRA.7=0;
_0x29:
	CBI  0x1A,7
; 0000 005D     PORTA.7=1;
	SBI  0x1B,7
; 0000 005E     return;
	RET
; 0000 005F     }
;
;void lcd_disp(void)
; 0000 0062     {
_lcd_disp:
; 0000 0063     #asm("wdr")
	wdr
; 0000 0064     if (menu==1)
	SBRS R3,3
	RJMP _0x30
; 0000 0065         {
; 0000 0066         lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 0067         sprintf (string_LCD_1, "%2.1fV B=%d ", batt, bar);
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_batt
	LDS  R31,_batt+1
	LDS  R22,_batt+2
	LDS  R23,_batt+3
	CALL __PUTPARD1
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
; 0000 0068         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL _lcd_puts
; 0000 0069 
; 0000 006A         lcd_gotoxy (10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x7
; 0000 006B              if (rezym == 0)    sprintf (string_LCD_1, "St_Vec");
	TST  R10
	BRNE _0x31
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,13
	RJMP _0x212
; 0000 006C         else if (rezym == 1)    sprintf (string_LCD_1, "St_Ras");
_0x31:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x33
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,20
	RJMP _0x212
; 0000 006D         else if (rezym == 2)    sprintf (string_LCD_1, " Dinam");
_0x33:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x35
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,27
	RJMP _0x212
; 0000 006E         else                    sprintf (string_LCD_1, "StopTX");
_0x35:
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,34
_0x212:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 006F         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 0070 
; 0000 0071         lcd_gotoxy (0,1);
; 0000 0072         sprintf (string_LCD_2, "(%03.0f:%+.2f))=Z", ampl, faza);
	__POINTW1FN _0x0,41
	CALL SUBOPT_0xA
; 0000 0073         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 0074 
; 0000 0075         lcd_gotoxy (9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0xC
; 0000 0076         if (mod_rock == 1)   sprintf (string_LCD_2, "+R");
	SBRS R2,7
	RJMP _0x37
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,59
	RJMP _0x213
; 0000 0077         else                    sprintf (string_LCD_2, "  ");
_0x37:
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,62
_0x213:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 0078         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 0079 
; 0000 007A         lcd_gotoxy (11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0xC
; 0000 007B         if (mod_gnd == 1)   sprintf (string_LCD_2, "+G");
	SBRS R2,6
	RJMP _0x39
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,65
	RJMP _0x214
; 0000 007C         else                    sprintf (string_LCD_2, "  ");
_0x39:
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,62
_0x214:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 007D         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 007E 
; 0000 007F         lcd_gotoxy (13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0xC
; 0000 0080         if (mod_all_met == 1)   sprintf (string_LCD_2, "-Fe");
	SBRS R3,0
	RJMP _0x3B
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,68
	RJMP _0x215
; 0000 0081         else                    sprintf (string_LCD_2, "+Al");
_0x3B:
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,72
_0x215:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 0082         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 0083 
; 0000 0084         return;
; 0000 0085         };
_0x30:
; 0000 0086 
; 0000 0087     if (kn2==1)
	SBRS R2,1
	RJMP _0x3D
; 0000 0088         {
; 0000 0089         lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 008A              if (rezym == 0)         sprintf (string_LCD_1, " _Static_Veckt_ ");
	TST  R10
	BRNE _0x3E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,76
	RJMP _0x216
; 0000 008B         else if (rezym == 1)         sprintf (string_LCD_1, " _Static_Rastr_ ");
_0x3E:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x40
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,93
	RJMP _0x216
; 0000 008C         else if (rezym == 2)         sprintf (string_LCD_1, "    _Dinamic_   ");
_0x40:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x42
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,110
_0x216:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 008D         lcd_puts (string_LCD_1);
_0x42:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	RJMP _0x20C0009
; 0000 008E         return;
; 0000 008F         };
_0x3D:
; 0000 0090 
; 0000 0091     if (kn3==1)
	SBRS R2,2
	RJMP _0x43
; 0000 0092         {
; 0000 0093         lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC
; 0000 0094         sprintf (string_LCD_2, "Barrier %d       ", bar);
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,127
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5
	CALL SUBOPT_0xD
; 0000 0095         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 0096         return;
; 0000 0097         };
_0x43:
; 0000 0098 
; 0000 0099     if (kn4==1)
	SBRS R2,3
	RJMP _0x44
; 0000 009A         {
; 0000 009B         lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 009C         if (rezym <2)
	LDI  R30,LOW(2)
	CP   R10,R30
	BRSH _0x45
; 0000 009D                 {
; 0000 009E                 sprintf (string_LCD_1, ">> Rock (A:f) <<");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,145
	CALL SUBOPT_0xE
; 0000 009F                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 00A0                 lcd_gotoxy (0,1);
; 0000 00A1                 sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);
	CALL SUBOPT_0xF
; 0000 00A2                 }
; 0000 00A3         else
	RJMP _0x46
_0x45:
; 0000 00A4                 {
; 0000 00A5                 sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,182
	CALL SUBOPT_0xE
; 0000 00A6                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 00A7                 lcd_gotoxy (0,1);
; 0000 00A8                 sprintf (string_LCD_2, "  %+d           ", geb);
	CALL SUBOPT_0x10
; 0000 00A9                 };
_0x46:
; 0000 00AA         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00AB         return;
; 0000 00AC         };
_0x44:
; 0000 00AD 
; 0000 00AE     if (kn5==1)
	SBRS R2,4
	RJMP _0x47
; 0000 00AF         {
; 0000 00B0         lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 00B1         if (rezym <2)
	LDI  R30,LOW(2)
	CP   R10,R30
	BRSH _0x48
; 0000 00B2                 {
; 0000 00B3                 sprintf (string_LCD_1, "> Ground (A;F) <");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,216
	CALL SUBOPT_0xE
; 0000 00B4                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 00B5                 lcd_gotoxy (0,1);
; 0000 00B6                 sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);
	CALL SUBOPT_0xF
; 0000 00B7                 }
; 0000 00B8         else
	RJMP _0x49
_0x48:
; 0000 00B9                 {
; 0000 00BA                 sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,182
	CALL SUBOPT_0xE
; 0000 00BB                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 00BC                 lcd_gotoxy (0,1);
; 0000 00BD                 sprintf (string_LCD_2, "  %+d           ", geb);
	CALL SUBOPT_0x10
; 0000 00BE                 };
_0x49:
; 0000 00BF         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00C0         return;
; 0000 00C1         };
_0x47:
; 0000 00C2 
; 0000 00C3     if (kn6==1)
	SBRS R2,5
	RJMP _0x4A
; 0000 00C4         {
; 0000 00C5         lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 00C6         sprintf (string_LCD_1, "> Zero  (A:f)  <");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,233
	CALL SUBOPT_0xE
; 0000 00C7         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 00C8         lcd_gotoxy (0,1);
; 0000 00C9         sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);
	CALL SUBOPT_0xF
; 0000 00CA         lcd_puts (string_LCD_2);
_0x20C0008:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
_0x20C0009:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00CB         return;
	RET
; 0000 00CC         };
_0x4A:
; 0000 00CD 
; 0000 00CE     lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 00CF     if (rezym < 2)
	LDI  R30,LOW(2)
	CP   R10,R30
	BRLO PC+3
	JMP _0x4B
; 0000 00D0         {
; 0000 00D1         if      (viz_ampl==0)    sprintf (string_LCD_1, "                ");
	TST  R12
	BRNE _0x4C
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,250
	RJMP _0x217
; 0000 00D2         else if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");
_0x4C:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x4E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,267
	RJMP _0x217
; 0000 00D3         else if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
_0x4E:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x50
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,284
	RJMP _0x217
; 0000 00D4         else if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x50:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x52
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,301
	RJMP _0x217
; 0000 00D5         else if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x52:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x54
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,318
	RJMP _0x217
; 0000 00D6         else if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x54:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x56
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,335
	RJMP _0x217
; 0000 00D7         else if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x56:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x58
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,352
	RJMP _0x217
; 0000 00D8         else if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x58:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x5A
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,369
	RJMP _0x217
; 0000 00D9         else if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x5A:
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x5C
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,386
	RJMP _0x217
; 0000 00DA         else if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x5C:
	LDI  R30,LOW(9)
	CP   R30,R12
	BRNE _0x5E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,403
	RJMP _0x217
; 0000 00DB         else if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x5E:
	LDI  R30,LOW(10)
	CP   R30,R12
	BRNE _0x60
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,420
	RJMP _0x217
; 0000 00DC         else if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x60:
	LDI  R30,LOW(11)
	CP   R30,R12
	BRNE _0x62
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,437
	RJMP _0x217
; 0000 00DD         else if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x62:
	LDI  R30,LOW(12)
	CP   R30,R12
	BRNE _0x64
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,454
	RJMP _0x217
; 0000 00DE         else if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x64:
	LDI  R30,LOW(13)
	CP   R30,R12
	BRNE _0x66
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,471
	RJMP _0x217
; 0000 00DF         else if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x66:
	LDI  R30,LOW(14)
	CP   R30,R12
	BRNE _0x68
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,488
	RJMP _0x217
; 0000 00E0         else if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x68:
	LDI  R30,LOW(15)
	CP   R30,R12
	BRNE _0x6A
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,505
	RJMP _0x217
; 0000 00E1         else if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x6A:
	LDI  R30,LOW(16)
	CP   R30,R12
	BRNE _0x6C
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,522
	RJMP _0x217
; 0000 00E2         else if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x6C:
	LDI  R30,LOW(17)
	CP   R30,R12
	BRNE _0x6E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,539
	RJMP _0x217
; 0000 00E3         else if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x6E:
	LDI  R30,LOW(18)
	CP   R30,R12
	BRNE _0x70
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,556
	RJMP _0x217
; 0000 00E4         else if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x70:
	LDI  R30,LOW(19)
	CP   R30,R12
	BRNE _0x72
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,573
	RJMP _0x217
; 0000 00E5         else if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x72:
	LDI  R30,LOW(20)
	CP   R30,R12
	BRNE _0x74
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,590
	RJMP _0x217
; 0000 00E6         else if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x74:
	LDI  R30,LOW(21)
	CP   R30,R12
	BRNE _0x76
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,607
	RJMP _0x217
; 0000 00E7         else if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x76:
	LDI  R30,LOW(22)
	CP   R30,R12
	BRNE _0x78
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,624
	RJMP _0x217
; 0000 00E8         else if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x78:
	LDI  R30,LOW(23)
	CP   R30,R12
	BRNE _0x7A
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,641
	RJMP _0x217
; 0000 00E9         else if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x7A:
	LDI  R30,LOW(24)
	CP   R30,R12
	BRNE _0x7C
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,658
	RJMP _0x217
; 0000 00EA         else if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x7C:
	LDI  R30,LOW(25)
	CP   R30,R12
	BRNE _0x7E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,675
	RJMP _0x217
; 0000 00EB         else if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x7E:
	LDI  R30,LOW(26)
	CP   R30,R12
	BRNE _0x80
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,692
	RJMP _0x217
; 0000 00EC         else if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x80:
	LDI  R30,LOW(27)
	CP   R30,R12
	BRNE _0x82
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,709
	RJMP _0x217
; 0000 00ED         else if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x82:
	LDI  R30,LOW(28)
	CP   R30,R12
	BRNE _0x84
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,726
	RJMP _0x217
; 0000 00EE         else if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x84:
	LDI  R30,LOW(29)
	CP   R30,R12
	BRNE _0x86
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,743
	RJMP _0x217
; 0000 00EF         else if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x86:
	LDI  R30,LOW(30)
	CP   R30,R12
	BRNE _0x88
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,760
	RJMP _0x217
; 0000 00F0         else if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x88:
	LDI  R30,LOW(31)
	CP   R30,R12
	BRNE _0x8A
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,777
	RJMP _0x217
; 0000 00F1         else                     sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x8A:
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,794
_0x217:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 00F2         }
; 0000 00F3 
; 0000 00F4     else if (rezym == 2)
	RJMP _0x8C
_0x4B:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0x8D
; 0000 00F5         {
; 0000 00F6              if (viz_ampl==1)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ ");
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x8E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,811
	RJMP _0x218
; 0000 00F7         else if (viz_ampl==2)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ  ");
_0x8E:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x90
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,828
	RJMP _0x218
; 0000 00F8         else if (viz_ampl==3)    sprintf (string_LCD_1, "        ÿÿÿÿÿ   ");
_0x90:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x92
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,845
	RJMP _0x218
; 0000 00F9         else if (viz_ampl==4)    sprintf (string_LCD_1, "        ÿÿÿÿ    ");
_0x92:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x94
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,862
	RJMP _0x218
; 0000 00FA         else if (viz_ampl==5)    sprintf (string_LCD_1, "        ÿÿÿ     ");
_0x94:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x96
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,879
	RJMP _0x218
; 0000 00FB         else if (viz_ampl==6)    sprintf (string_LCD_1, "        ÿÿ      ");
_0x96:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x98
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,896
	RJMP _0x218
; 0000 00FC         else if (viz_ampl==7)    sprintf (string_LCD_1, "        ÿ       ");
_0x98:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x9A
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,913
	RJMP _0x218
; 0000 00FD         else if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
_0x9A:
	TST  R12
	BRNE _0x9C
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,250
	RJMP _0x218
; 0000 00FE         else if (viz_ampl==8)    sprintf (string_LCD_1, "       ÿ        ");
_0x9C:
	LDI  R30,LOW(8)
	CP   R30,R12
	BRNE _0x9E
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,930
	RJMP _0x218
; 0000 00FF         else if (viz_ampl==9)    sprintf (string_LCD_1, "      ÿÿ        ");
_0x9E:
	LDI  R30,LOW(9)
	CP   R30,R12
	BRNE _0xA0
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,947
	RJMP _0x218
; 0000 0100         else if (viz_ampl==10)   sprintf (string_LCD_1, "     ÿÿÿ        ");
_0xA0:
	LDI  R30,LOW(10)
	CP   R30,R12
	BRNE _0xA2
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,964
	RJMP _0x218
; 0000 0101         else if (viz_ampl==11)   sprintf (string_LCD_1, "    ÿÿÿÿ        ");
_0xA2:
	LDI  R30,LOW(11)
	CP   R30,R12
	BRNE _0xA4
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,981
	RJMP _0x218
; 0000 0102         else if (viz_ampl==12)   sprintf (string_LCD_1, "   ÿÿÿÿÿ        ");
_0xA4:
	LDI  R30,LOW(12)
	CP   R30,R12
	BRNE _0xA6
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,998
	RJMP _0x218
; 0000 0103         else if (viz_ampl==13)   sprintf (string_LCD_1, "  ÿÿÿÿÿÿ        ");
_0xA6:
	LDI  R30,LOW(13)
	CP   R30,R12
	BRNE _0xA8
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1015
	RJMP _0x218
; 0000 0104         else                     sprintf (string_LCD_1, " ÿÿÿÿÿÿÿ        ");
_0xA8:
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1032
_0x218:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 0105         }
; 0000 0106 
; 0000 0107     else                         sprintf (string_LCD_1, "    Stop__Tx    ");
	RJMP _0xAA
_0x8D:
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1049
	CALL SUBOPT_0xE
; 0000 0108 
; 0000 0109     lcd_puts (string_LCD_1);
_0xAA:
_0x8C:
	CALL SUBOPT_0x4
	CALL _lcd_puts
; 0000 010A 
; 0000 010B     lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xC
; 0000 010C          if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
	LDS  R30,_viz_faza
	CPI  R30,0
	BRNE _0xAB
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1066
	RJMP _0x219
; 0000 010D     else if (viz_faza==1)  sprintf (string_LCD_2, "Û------II----o_O");
_0xAB:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x1)
	BRNE _0xAD
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1083
	RJMP _0x219
; 0000 010E     else if (viz_faza==2)  sprintf (string_LCD_2, "Û------II-----#Ü");
_0xAD:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x2)
	BRNE _0xAF
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1100
	RJMP _0x219
; 0000 010F     else if (viz_faza==3)  sprintf (string_LCD_2, "Û------II----#-Ü");
_0xAF:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x3)
	BRNE _0xB1
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1117
	RJMP _0x219
; 0000 0110     else if (viz_faza==4)  sprintf (string_LCD_2, "Û------II---#--Ü");
_0xB1:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x4)
	BRNE _0xB3
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1134
	RJMP _0x219
; 0000 0111     else if (viz_faza==5)  sprintf (string_LCD_2, "Û------II--#---Ü");
_0xB3:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x5)
	BRNE _0xB5
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1151
	RJMP _0x219
; 0000 0112     else if (viz_faza==6)  sprintf (string_LCD_2, "Û------II-#----Ü");
_0xB5:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x6)
	BRNE _0xB7
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1168
	RJMP _0x219
; 0000 0113     else if (viz_faza==7)  sprintf (string_LCD_2, "Û------II#-----Ü");
_0xB7:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x7)
	BRNE _0xB9
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1185
	RJMP _0x219
; 0000 0114     else if (viz_faza==8)  sprintf (string_LCD_2, "Û------I#------Ü");
_0xB9:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x8)
	BRNE _0xBB
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1202
	RJMP _0x219
; 0000 0115     else if (viz_faza==9)  sprintf (string_LCD_2, "Û------#I------Ü");
_0xBB:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0x9)
	BRNE _0xBD
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1219
	RJMP _0x219
; 0000 0116     else if (viz_faza==10) sprintf (string_LCD_2, "Û-----#II------Ü");
_0xBD:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xA)
	BRNE _0xBF
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1236
	RJMP _0x219
; 0000 0117     else if (viz_faza==11) sprintf (string_LCD_2, "Û----#-II------Ü");
_0xBF:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xB)
	BRNE _0xC1
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1253
	RJMP _0x219
; 0000 0118     else if (viz_faza==12) sprintf (string_LCD_2, "Û---#--II------Ü");
_0xC1:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xC)
	BRNE _0xC3
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1270
	RJMP _0x219
; 0000 0119     else if (viz_faza==13) sprintf (string_LCD_2, "Û--#---II------Ü");
_0xC3:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xD)
	BRNE _0xC5
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1287
	RJMP _0x219
; 0000 011A     else if (viz_faza==14) sprintf (string_LCD_2, "Û-#----II------Ü");
_0xC5:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xE)
	BRNE _0xC7
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1304
	RJMP _0x219
; 0000 011B     else if (viz_faza==15) sprintf (string_LCD_2, "Û#-----II------Ü");
_0xC7:
	LDS  R26,_viz_faza
	CPI  R26,LOW(0xF)
	BRNE _0xC9
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1321
	RJMP _0x219
; 0000 011C     else                   sprintf (string_LCD_2, ">_<----II------Ü");
_0xC9:
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1338
_0x219:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 011D 
; 0000 011E     lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 011F 
; 0000 0120     if (rezym == 2)
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0xCB
; 0000 0121         {
; 0000 0122         if (viz_din==0)     return;
	LDS  R30,_viz_din
	CPI  R30,0
	BRNE _0xCC
	RET
; 0000 0123 
; 0000 0124         sprintf (string_LCD_1, "<");
_0xCC:
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,160
	CALL SUBOPT_0xE
; 0000 0125              if (viz_din==1)    lcd_gotoxy (7,0);
	LDS  R26,_viz_din
	CPI  R26,LOW(0x1)
	BRNE _0xCD
	LDI  R30,LOW(7)
	RJMP _0x21A
; 0000 0126         else if (viz_din==2)    lcd_gotoxy (6,0);
_0xCD:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x2)
	BRNE _0xCF
	LDI  R30,LOW(6)
	RJMP _0x21A
; 0000 0127         else if (viz_din==3)    lcd_gotoxy (5,0);
_0xCF:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x3)
	BRNE _0xD1
	LDI  R30,LOW(5)
	RJMP _0x21A
; 0000 0128         else if (viz_din==4)    lcd_gotoxy (4,0);
_0xD1:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x4)
	BRNE _0xD3
	LDI  R30,LOW(4)
	RJMP _0x21A
; 0000 0129         else if (viz_din==5)    lcd_gotoxy (3,0);
_0xD3:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x5)
	BRNE _0xD5
	LDI  R30,LOW(3)
	RJMP _0x21A
; 0000 012A         else if (viz_din==6)    lcd_gotoxy (2,0);
_0xD5:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x6)
	BRNE _0xD7
	LDI  R30,LOW(2)
	RJMP _0x21A
; 0000 012B         else if (viz_din==7)    lcd_gotoxy (1,0);
_0xD7:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x7)
	BRNE _0xD9
	LDI  R30,LOW(1)
	RJMP _0x21A
; 0000 012C         else                    lcd_gotoxy (0,0);
_0xD9:
	LDI  R30,LOW(0)
_0x21A:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 012D         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL _lcd_puts
; 0000 012E 
; 0000 012F         sprintf (string_LCD_2, ">");
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1355
	CALL SUBOPT_0xE
; 0000 0130              if (viz_din==1)    lcd_gotoxy (8,0);
	LDS  R26,_viz_din
	CPI  R26,LOW(0x1)
	BRNE _0xDB
	LDI  R30,LOW(8)
	RJMP _0x21B
; 0000 0131         else if (viz_din==2)    lcd_gotoxy (9,0);
_0xDB:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x2)
	BRNE _0xDD
	LDI  R30,LOW(9)
	RJMP _0x21B
; 0000 0132         else if (viz_din==3)    lcd_gotoxy (10,0);
_0xDD:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x3)
	BRNE _0xDF
	LDI  R30,LOW(10)
	RJMP _0x21B
; 0000 0133         else if (viz_din==4)    lcd_gotoxy (11,0);
_0xDF:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x4)
	BRNE _0xE1
	LDI  R30,LOW(11)
	RJMP _0x21B
; 0000 0134         else if (viz_din==5)    lcd_gotoxy (12,0);
_0xE1:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x5)
	BRNE _0xE3
	LDI  R30,LOW(12)
	RJMP _0x21B
; 0000 0135         else if (viz_din==6)    lcd_gotoxy (13,0);
_0xE3:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x6)
	BRNE _0xE5
	LDI  R30,LOW(13)
	RJMP _0x21B
; 0000 0136         else if (viz_din==7)    lcd_gotoxy (14,0);
_0xE5:
	LDS  R26,_viz_din
	CPI  R26,LOW(0x7)
	BRNE _0xE7
	LDI  R30,LOW(14)
	RJMP _0x21B
; 0000 0137         else                    lcd_gotoxy (15,0);
_0xE7:
	LDI  R30,LOW(15)
_0x21B:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0138         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 0139         };
_0xCB:
; 0000 013A     return;
	RET
; 0000 013B     }
;
;void new (void)
; 0000 013E     {
_new:
; 0000 013F     unsigned int fr;
; 0000 0140     #asm("wdr")
	ST   -Y,R17
	ST   -Y,R16
;	fr -> R16,R17
	wdr
; 0000 0141     ampl = read_adc (0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(_ampl)
	LDI  R27,HIGH(_ampl)
	CALL SUBOPT_0x0
	CALL __PUTDP1
; 0000 0142     fr = ((unsigned int)ICR1H<<8)|ICR1L;
	IN   R30,0x27
	MOV  R31,R30
	LDI  R30,0
	MOVW R26,R30
	IN   R30,0x26
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R16,R30
; 0000 0143     faza = (float)fr/0x07CE*6.28-3.14;
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x44F9C000
	CALL __DIVF21
	__GETD2N 0x40C8F5C3
	CALL SUBOPT_0x11
	__GETD1N 0x4048F5C3
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 0144     return;
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 0145     }
;
;float vektor_ampl (float a, float aa_x, float b, float bb_x)
; 0000 0148     {
_vektor_ampl:
; 0000 0149     float c;
; 0000 014A     float aabb;
; 0000 014B     #asm("wdr");
	SBIW R28,8
;	a -> Y+20
;	aa_x -> Y+16
;	b -> Y+12
;	bb_x -> Y+8
;	c -> Y+4
;	aabb -> Y+0
	wdr
; 0000 014C     aabb = aa_x - bb_x;
	__GETD2S 8
	CALL SUBOPT_0x14
	CALL __SUBF12
	CALL SUBOPT_0x15
; 0000 014D     c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
	__GETD1S 20
	__GETD2S 20
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x17
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x12
	CALL __PUTPARD1
	CALL _sqrt
	CALL SUBOPT_0x19
; 0000 014E     return c;
	CALL SUBOPT_0x1A
	ADIW R28,24
	RET
; 0000 014F     }
;
;float vektor_faza (int a_v, int c_v, int c, int b)
; 0000 0152     {
_vektor_faza:
; 0000 0153     float ab_v, b_v, ac_v;
; 0000 0154     #asm("wdr");
	SBIW R28,12
;	a_v -> Y+18
;	c_v -> Y+16
;	c -> Y+14
;	b -> Y+12
;	ab_v -> Y+8
;	b_v -> Y+4
;	ac_v -> Y+0
	wdr
; 0000 0155     if (a_v > c_v) ac_v = a_v - c_v;
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0xE9
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	RJMP _0x21C
; 0000 0156     else ac_v = c_v - a_v;
_0xE9:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDD  R30,Y+16
	LDD  R31,Y+16+1
_0x21C:
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x15
; 0000 0157     ab_v = asin(c * sin(ac_v) / b);
	CALL SUBOPT_0x18
	CALL _sin
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL __CWD2
	CALL __CDF2
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x1B
	CALL _asin
	__PUTD1S 8
; 0000 0158 
; 0000 0159 
; 0000 015A     return b_v;
	CALL SUBOPT_0x1A
	ADIW R28,20
	RET
; 0000 015B     }
;
;void main_menu(void)
; 0000 015E     {
_main_menu:
; 0000 015F     #asm("wdr")
	wdr
; 0000 0160     menu++;
	LDI  R30,LOW(8)
	EOR  R3,R30
; 0000 0161     batt_zarqd();
	RCALL _batt_zarqd
; 0000 0162     while (kn1==1)
_0xEB:
	SBRS R2,0
	RJMP _0xED
; 0000 0163         {
; 0000 0164         kn_klava();
	CALL SUBOPT_0x1C
; 0000 0165         lcd_disp();
; 0000 0166         };
	RJMP _0xEB
_0xED:
; 0000 0167     return;
	RET
; 0000 0168     }
;
;void rezymm(void)
; 0000 016B     {
_rezymm:
; 0000 016C     #asm("wdr")
	wdr
; 0000 016D     rezym++;
	INC  R10
; 0000 016E     if (rezym == 4)
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xEE
; 0000 016F         {
; 0000 0170         TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 0171         TCCR0=0x1D;
	LDI  R30,LOW(29)
	OUT  0x33,R30
; 0000 0172         rezym =0;
	CLR  R10
; 0000 0173         };
_0xEE:
; 0000 0174 
; 0000 0175     while (kn2==1)
_0xEF:
	SBRS R2,1
	RJMP _0xF1
; 0000 0176         {
; 0000 0177         kn_klava();
	CALL SUBOPT_0x1C
; 0000 0178         lcd_disp();
; 0000 0179         };
	RJMP _0xEF
_0xF1:
; 0000 017A     return;
	RET
; 0000 017B     }
;
;void barrier(void)
; 0000 017E     {
_barrier:
; 0000 017F     #asm("wdr")
	wdr
; 0000 0180     bar++;
	INC  R11
; 0000 0181     if (bar==10) bar=0;
	LDI  R30,LOW(10)
	CP   R30,R11
	BRNE _0xF2
	CLR  R11
; 0000 0182     bar_rad = (float) bar*0.1;
_0xF2:
	MOV  R30,R11
	CALL SUBOPT_0x0
	__GETD2N 0x3DCCCCCD
	CALL __MULF12
	STS  _bar_rad,R30
	STS  _bar_rad+1,R31
	STS  _bar_rad+2,R22
	STS  _bar_rad+3,R23
; 0000 0183     while (kn3==1)
_0xF3:
	SBRS R2,2
	RJMP _0xF5
; 0000 0184         {
; 0000 0185         kn_klava();
	CALL SUBOPT_0x1C
; 0000 0186         lcd_disp();
; 0000 0187         };
	RJMP _0xF3
_0xF5:
; 0000 0188     return;
	RET
; 0000 0189     }
;
;void rock(void)
; 0000 018C     {
_rock:
; 0000 018D     #asm("wdr")
	wdr
; 0000 018E     if (menu==1) mod_rock++;
	SBRS R3,3
	RJMP _0xF6
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 018F 
; 0000 0190     else if (rezym == 0)
	RJMP _0xF7
_0xF6:
	TST  R10
	BRNE _0xF8
; 0000 0191         {
; 0000 0192         rock_A = ampl;
	CALL SUBOPT_0x1D
	LDI  R26,LOW(_rock_A)
	LDI  R27,HIGH(_rock_A)
	CALL SUBOPT_0x1E
; 0000 0193         rock_F = faza;
	LDI  R26,LOW(_rock_F)
	LDI  R27,HIGH(_rock_F)
	CALL __CFD1U
	ST   X,R30
; 0000 0194         }
; 0000 0195     else if (rezym == 1)
	RJMP _0xF9
_0xF8:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xFA
; 0000 0196         {
; 0000 0197         rock_sekt_A = (int)ampl / 8;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 0198         rock_sekt_F = (int)faza / 8;
; 0000 0199         rock_pos_A = (int)ampl % 8;
	CALL SUBOPT_0x21
; 0000 019A         rock_pos_F = (int)faza % 8;
; 0000 019B 
; 0000 019C              if ((rock_pos_F > 4) & (rock_pos_A > 4)) rastr_st[rock_sekt_F][rock_sekt_A] |= 0x80;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x22
	BREQ _0xFB
	CALL SUBOPT_0x23
	ORI  R30,0x80
	RJMP _0x21D
; 0000 019D         else if ((rock_pos_F > 0) & (rock_pos_A > 4)) rastr_st[rock_sekt_F][rock_sekt_A] |= 0x40;
_0xFB:
	LDS  R26,_rock_pos_F
	LDI  R30,LOW(0)
	CALL SUBOPT_0x22
	BREQ _0xFD
	CALL SUBOPT_0x23
	ORI  R30,0x40
	RJMP _0x21D
; 0000 019E         else if  (rock_pos_F > 4)                     rastr_st[rock_sekt_F][rock_sekt_A] |= 0x20;
_0xFD:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0xFF
	CALL SUBOPT_0x23
	ORI  R30,0x20
	RJMP _0x21D
; 0000 019F         else                                          rastr_st[rock_sekt_F][rock_sekt_A] |= 0x10;
_0xFF:
	CALL SUBOPT_0x23
	ORI  R30,0x10
_0x21D:
	ST   X,R30
; 0000 01A0         }
; 0000 01A1     else if (rezym == 2)
	RJMP _0x101
_0xFA:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x102
; 0000 01A2     {
; 0000 01A3     geb++;
	LDS  R30,_geb
	SUBI R30,-LOW(1)
	STS  _geb,R30
; 0000 01A4     Frx++;
	IN   R30,0x28
	IN   R31,0x28+1
	ADIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01A5     if (Frx > Ftx) Frx = 0;
	IN   R30,0x28
	IN   R31,0x28+1
	MOVW R26,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x103
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01A6     };
_0x103:
_0x102:
_0x101:
_0xF9:
_0xF7:
; 0000 01A7     return;
	RET
; 0000 01A8     }
;
;
;void ground(void)
; 0000 01AC     {
_ground:
; 0000 01AD     #asm("wdr")
	wdr
; 0000 01AE     if (menu==1) mod_gnd++;
	SBRS R3,3
	RJMP _0x104
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 01AF 
; 0000 01B0     else if (rezym == 0)
	RJMP _0x105
_0x104:
	TST  R10
	BRNE _0x106
; 0000 01B1         {
; 0000 01B2         gnd_A = ampl;
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1E
; 0000 01B3         gnd_F = faza;
	LDI  R26,LOW(_gnd_F)
	LDI  R27,HIGH(_gnd_F)
	CALL __CFD1U
	ST   X,R30
; 0000 01B4         }
; 0000 01B5     else if (rezym == 1)
	RJMP _0x107
_0x106:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0x108
; 0000 01B6         {
; 0000 01B7         gnd_sekt_A = (int)ampl / 8;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x25
; 0000 01B8         gnd_sekt_F = (int)faza / 8;
; 0000 01B9         gnd_pos_A = (int)ampl % 8;
	CALL SUBOPT_0x26
; 0000 01BA         gnd_pos_F = (int)faza % 8;
; 0000 01BB 
; 0000 01BC              if ((gnd_pos_F > 4) & (gnd_pos_A > 4)) rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x08;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x27
	BREQ _0x109
	CALL SUBOPT_0x28
	ORI  R30,8
	RJMP _0x21E
; 0000 01BD         else if ((gnd_pos_F > 0) & (gnd_pos_A > 4)) rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x04;
_0x109:
	LDS  R26,_gnd_pos_F
	LDI  R30,LOW(0)
	CALL SUBOPT_0x27
	BREQ _0x10B
	CALL SUBOPT_0x28
	ORI  R30,4
	RJMP _0x21E
; 0000 01BE         else if  (gnd_pos_F > 4)                    rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x02;
_0x10B:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x10D
	CALL SUBOPT_0x28
	ORI  R30,2
	RJMP _0x21E
; 0000 01BF         else                                        rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x01;
_0x10D:
	CALL SUBOPT_0x28
	ORI  R30,1
_0x21E:
	ST   X,R30
; 0000 01C0         }
; 0000 01C1     else if (rezym == 2)
	RJMP _0x10F
_0x108:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x110
; 0000 01C2         {
; 0000 01C3         geb--;
	LDS  R30,_geb
	SUBI R30,LOW(1)
	STS  _geb,R30
; 0000 01C4         Frx--;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01C5         if (Frx == 0) Frx = Ftx;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,0
	BRNE _0x111
	IN   R30,0x2A
	IN   R31,0x2A+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01C6         };
_0x111:
_0x110:
_0x10F:
_0x107:
_0x105:
; 0000 01C7     return;
	RET
; 0000 01C8     }
;
;void zero(void)
; 0000 01CB     {
_zero:
; 0000 01CC     #asm("wdr")
	wdr
; 0000 01CD     if (menu == 1) mod_all_met++;
	SBRS R3,3
	RJMP _0x112
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 01CE 
; 0000 01CF     st_zero_A = ampl;
_0x112:
	CALL SUBOPT_0x1D
	CALL __CFD1U
	MOVW R4,R30
; 0000 01D0     st_zero_F = faza;
	CALL SUBOPT_0x29
	CALL __CFD1U
	MOVW R6,R30
; 0000 01D1     din_zero_A = din_A;
	MOV  R8,R13
	CLR  R9
; 0000 01D2     return;
	RET
; 0000 01D3     }
;
;void vizual (void)
; 0000 01D6     {
_vizual:
; 0000 01D7     #asm("wdr")
	wdr
; 0000 01D8     if (rezym < 2)
	LDI  R30,LOW(2)
	CP   R10,R30
	BRLO PC+3
	JMP _0x113
; 0000 01D9         {
; 0000 01DA         if      (ampl> 180 )   viz_ampl=32;
	CALL SUBOPT_0x2A
	__GETD1N 0x43340000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x114
	LDI  R30,LOW(32)
	MOV  R12,R30
; 0000 01DB         else if (ampl> 175 )   viz_ampl=31;
	RJMP _0x115
_0x114:
	CALL SUBOPT_0x2A
	__GETD1N 0x432F0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x116
	LDI  R30,LOW(31)
	MOV  R12,R30
; 0000 01DC         else if (ampl> 169 )   viz_ampl=30;
	RJMP _0x117
_0x116:
	CALL SUBOPT_0x2A
	__GETD1N 0x43290000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x118
	LDI  R30,LOW(30)
	MOV  R12,R30
; 0000 01DD         else if (ampl> 164 )   viz_ampl=29;
	RJMP _0x119
_0x118:
	CALL SUBOPT_0x2A
	__GETD1N 0x43240000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11A
	LDI  R30,LOW(29)
	MOV  R12,R30
; 0000 01DE         else if (ampl> 158 )   viz_ampl=28;
	RJMP _0x11B
_0x11A:
	CALL SUBOPT_0x2A
	__GETD1N 0x431E0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11C
	LDI  R30,LOW(28)
	MOV  R12,R30
; 0000 01DF         else if (ampl> 153 )   viz_ampl=27;
	RJMP _0x11D
_0x11C:
	CALL SUBOPT_0x2A
	__GETD1N 0x43190000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11E
	LDI  R30,LOW(27)
	MOV  R12,R30
; 0000 01E0         else if (ampl> 147 )   viz_ampl=26;
	RJMP _0x11F
_0x11E:
	CALL SUBOPT_0x2A
	__GETD1N 0x43130000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x120
	LDI  R30,LOW(26)
	MOV  R12,R30
; 0000 01E1         else if (ampl> 142 )   viz_ampl=25;
	RJMP _0x121
_0x120:
	CALL SUBOPT_0x2A
	__GETD1N 0x430E0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x122
	LDI  R30,LOW(25)
	MOV  R12,R30
; 0000 01E2         else if (ampl> 136 )   viz_ampl=24;
	RJMP _0x123
_0x122:
	CALL SUBOPT_0x2A
	__GETD1N 0x43080000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x124
	LDI  R30,LOW(24)
	MOV  R12,R30
; 0000 01E3         else if (ampl> 131 )   viz_ampl=23;
	RJMP _0x125
_0x124:
	CALL SUBOPT_0x2A
	__GETD1N 0x43030000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x126
	LDI  R30,LOW(23)
	MOV  R12,R30
; 0000 01E4         else if (ampl> 125 )   viz_ampl=22;
	RJMP _0x127
_0x126:
	CALL SUBOPT_0x2A
	__GETD1N 0x42FA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x128
	LDI  R30,LOW(22)
	MOV  R12,R30
; 0000 01E5         else if (ampl> 120 )   viz_ampl=21;
	RJMP _0x129
_0x128:
	CALL SUBOPT_0x2A
	__GETD1N 0x42F00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12A
	LDI  R30,LOW(21)
	MOV  R12,R30
; 0000 01E6         else if (ampl> 114 )   viz_ampl=20;
	RJMP _0x12B
_0x12A:
	CALL SUBOPT_0x2A
	__GETD1N 0x42E40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12C
	LDI  R30,LOW(20)
	MOV  R12,R30
; 0000 01E7         else if (ampl> 109 )   viz_ampl=19;
	RJMP _0x12D
_0x12C:
	CALL SUBOPT_0x2A
	__GETD1N 0x42DA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12E
	LDI  R30,LOW(19)
	MOV  R12,R30
; 0000 01E8         else if (ampl> 103 )   viz_ampl=18;
	RJMP _0x12F
_0x12E:
	CALL SUBOPT_0x2A
	__GETD1N 0x42CE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x130
	LDI  R30,LOW(18)
	MOV  R12,R30
; 0000 01E9         else if (ampl> 98  )   viz_ampl=17;
	RJMP _0x131
_0x130:
	CALL SUBOPT_0x2A
	__GETD1N 0x42C40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x132
	LDI  R30,LOW(17)
	MOV  R12,R30
; 0000 01EA         else if (ampl> 92  )   viz_ampl=16;
	RJMP _0x133
_0x132:
	CALL SUBOPT_0x2A
	__GETD1N 0x42B80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x134
	LDI  R30,LOW(16)
	MOV  R12,R30
; 0000 01EB         else if (ampl> 87  )   viz_ampl=15;
	RJMP _0x135
_0x134:
	CALL SUBOPT_0x2A
	__GETD1N 0x42AE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x136
	LDI  R30,LOW(15)
	MOV  R12,R30
; 0000 01EC         else if (ampl> 81  )   viz_ampl=14;
	RJMP _0x137
_0x136:
	CALL SUBOPT_0x2A
	__GETD1N 0x42A20000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x138
	LDI  R30,LOW(14)
	MOV  R12,R30
; 0000 01ED         else if (ampl> 76  )   viz_ampl=13;
	RJMP _0x139
_0x138:
	CALL SUBOPT_0x2A
	__GETD1N 0x42980000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13A
	LDI  R30,LOW(13)
	MOV  R12,R30
; 0000 01EE         else if (ampl> 70  )   viz_ampl=12;
	RJMP _0x13B
_0x13A:
	CALL SUBOPT_0x2A
	__GETD1N 0x428C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13C
	LDI  R30,LOW(12)
	MOV  R12,R30
; 0000 01EF         else if (ampl> 65  )   viz_ampl=11;
	RJMP _0x13D
_0x13C:
	CALL SUBOPT_0x2A
	__GETD1N 0x42820000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13E
	LDI  R30,LOW(11)
	MOV  R12,R30
; 0000 01F0         else if (ampl> 59  )   viz_ampl=10;
	RJMP _0x13F
_0x13E:
	CALL SUBOPT_0x2A
	__GETD1N 0x426C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x140
	LDI  R30,LOW(10)
	MOV  R12,R30
; 0000 01F1         else if (ampl> 54  )   viz_ampl=9;
	RJMP _0x141
_0x140:
	CALL SUBOPT_0x2A
	__GETD1N 0x42580000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x142
	LDI  R30,LOW(9)
	MOV  R12,R30
; 0000 01F2         else if (ampl> 48  )   viz_ampl=8;
	RJMP _0x143
_0x142:
	CALL SUBOPT_0x2A
	__GETD1N 0x42400000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x144
	LDI  R30,LOW(8)
	MOV  R12,R30
; 0000 01F3         else if (ampl> 43  )   viz_ampl=7;
	RJMP _0x145
_0x144:
	CALL SUBOPT_0x2A
	__GETD1N 0x422C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x146
	LDI  R30,LOW(7)
	MOV  R12,R30
; 0000 01F4         else if (ampl> 37  )   viz_ampl=6;
	RJMP _0x147
_0x146:
	CALL SUBOPT_0x2A
	__GETD1N 0x42140000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x148
	LDI  R30,LOW(6)
	MOV  R12,R30
; 0000 01F5         else if (ampl> 32  )   viz_ampl=5;
	RJMP _0x149
_0x148:
	CALL SUBOPT_0x2A
	__GETD1N 0x42000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14A
	LDI  R30,LOW(5)
	MOV  R12,R30
; 0000 01F6         else if (ampl> 26  )   viz_ampl=4;
	RJMP _0x14B
_0x14A:
	CALL SUBOPT_0x2A
	__GETD1N 0x41D00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14C
	LDI  R30,LOW(4)
	MOV  R12,R30
; 0000 01F7         else if (ampl> 21  )   viz_ampl=3;
	RJMP _0x14D
_0x14C:
	CALL SUBOPT_0x2A
	__GETD1N 0x41A80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14E
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 01F8         else if (ampl> 15  )   viz_ampl=2;
	RJMP _0x14F
_0x14E:
	CALL SUBOPT_0x2A
	__GETD1N 0x41700000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x150
	LDI  R30,LOW(2)
	MOV  R12,R30
; 0000 01F9         else if (ampl> 10  )   viz_ampl=1;
	RJMP _0x151
_0x150:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x152
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 01FA         else                   viz_ampl=0;
	RJMP _0x153
_0x152:
	CLR  R12
; 0000 01FB         }
_0x153:
_0x151:
_0x14F:
_0x14D:
_0x14B:
_0x149:
_0x147:
_0x145:
_0x143:
_0x141:
_0x13F:
_0x13D:
_0x13B:
_0x139:
_0x137:
_0x135:
_0x133:
_0x131:
_0x12F:
_0x12D:
_0x12B:
_0x129:
_0x127:
_0x125:
_0x123:
_0x121:
_0x11F:
_0x11D:
_0x11B:
_0x119:
_0x117:
_0x115:
; 0000 01FC 
; 0000 01FD     else if (rezym == 2)
	RJMP _0x154
_0x113:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0x155
; 0000 01FE         {
; 0000 01FF              if (din_A > din_zero_A +92 )    viz_ampl=14;
	MOVW R30,R8
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x2C
	BRSH _0x156
	LDI  R30,LOW(14)
	RJMP _0x21F
; 0000 0200         else if (din_A > din_zero_A +81 )    viz_ampl=13;
_0x156:
	MOVW R30,R8
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x2C
	BRSH _0x158
	LDI  R30,LOW(13)
	RJMP _0x21F
; 0000 0201         else if (din_A > din_zero_A +70 )    viz_ampl=12;
_0x158:
	MOVW R30,R8
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x2C
	BRSH _0x15A
	LDI  R30,LOW(12)
	RJMP _0x21F
; 0000 0202         else if (din_A > din_zero_A +59 )    viz_ampl=11;
_0x15A:
	MOVW R30,R8
	ADIW R30,59
	CALL SUBOPT_0x2C
	BRSH _0x15C
	LDI  R30,LOW(11)
	RJMP _0x21F
; 0000 0203         else if (din_A > din_zero_A +48 )    viz_ampl=10;
_0x15C:
	MOVW R30,R8
	ADIW R30,48
	CALL SUBOPT_0x2C
	BRSH _0x15E
	LDI  R30,LOW(10)
	RJMP _0x21F
; 0000 0204         else if (din_A > din_zero_A +37 )    viz_ampl=9;
_0x15E:
	MOVW R30,R8
	ADIW R30,37
	CALL SUBOPT_0x2C
	BRSH _0x160
	LDI  R30,LOW(9)
	RJMP _0x21F
; 0000 0205         else if (din_A > din_zero_A +26 )    viz_ampl=8; //___
_0x160:
	MOVW R30,R8
	ADIW R30,26
	CALL SUBOPT_0x2C
	BRSH _0x162
	LDI  R30,LOW(8)
	RJMP _0x21F
; 0000 0206         else if (din_A > din_zero_A     )    viz_ampl=0;
_0x162:
	MOVW R30,R8
	CALL SUBOPT_0x2C
	BRSH _0x164
	CLR  R12
; 0000 0207         else if (din_A > din_zero_A -26 )    viz_ampl=7; //___
	RJMP _0x165
_0x164:
	MOVW R30,R8
	SBIW R30,26
	CALL SUBOPT_0x2C
	BRSH _0x166
	LDI  R30,LOW(7)
	RJMP _0x21F
; 0000 0208         else if (din_A > din_zero_A -37 )    viz_ampl=6;
_0x166:
	MOVW R30,R8
	SBIW R30,37
	CALL SUBOPT_0x2C
	BRSH _0x168
	LDI  R30,LOW(6)
	RJMP _0x21F
; 0000 0209         else if (din_A > din_zero_A -48 )    viz_ampl=5;
_0x168:
	MOVW R30,R8
	SBIW R30,48
	CALL SUBOPT_0x2C
	BRSH _0x16A
	LDI  R30,LOW(5)
	RJMP _0x21F
; 0000 020A         else if (din_A > din_zero_A -59 )    viz_ampl=4;
_0x16A:
	MOVW R30,R8
	SBIW R30,59
	CALL SUBOPT_0x2C
	BRSH _0x16C
	LDI  R30,LOW(4)
	RJMP _0x21F
; 0000 020B         else if (din_A > din_zero_A -70 )    viz_ampl=3;
_0x16C:
	MOVW R30,R8
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x2C
	BRSH _0x16E
	LDI  R30,LOW(3)
	RJMP _0x21F
; 0000 020C         else if (din_A > din_zero_A -81 )    viz_ampl=2;
_0x16E:
	MOVW R30,R8
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x2C
	BRSH _0x170
	LDI  R30,LOW(2)
	RJMP _0x21F
; 0000 020D         else                                 viz_ampl=1;
_0x170:
	LDI  R30,LOW(1)
_0x21F:
	MOV  R12,R30
; 0000 020E         };
_0x165:
_0x155:
_0x154:
; 0000 020F 
; 0000 0210          if (faza> 1.40)   viz_faza=0;
	CALL SUBOPT_0x2D
	__GETD1N 0x3FB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x172
	RJMP _0x220
; 0000 0211     else if (faza> 1.22)   viz_faza=8;
_0x172:
	CALL SUBOPT_0x2D
	__GETD1N 0x3F9C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x174
	LDI  R30,LOW(8)
	RJMP _0x221
; 0000 0212     else if (faza> 1.05)   viz_faza=7;
_0x174:
	CALL SUBOPT_0x2D
	__GETD1N 0x3F866666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x176
	LDI  R30,LOW(7)
	RJMP _0x221
; 0000 0213     else if (faza> 0.82)   viz_faza=6;
_0x176:
	CALL SUBOPT_0x2D
	__GETD1N 0x3F51EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x178
	LDI  R30,LOW(6)
	RJMP _0x221
; 0000 0214     else if (faza> 0.70)   viz_faza=5;
_0x178:
	CALL SUBOPT_0x2D
	__GETD1N 0x3F333333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17A
	LDI  R30,LOW(5)
	RJMP _0x221
; 0000 0215     else if (faza> 0.52)   viz_faza=4;
_0x17A:
	CALL SUBOPT_0x2D
	__GETD1N 0x3F051EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17C
	LDI  R30,LOW(4)
	RJMP _0x221
; 0000 0216     else if (faza> 0.35)   viz_faza=3;
_0x17C:
	CALL SUBOPT_0x2D
	__GETD1N 0x3EB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x17E
	LDI  R30,LOW(3)
	RJMP _0x221
; 0000 0217     else if (faza> 0.17)   viz_faza=2;
_0x17E:
	CALL SUBOPT_0x2D
	__GETD1N 0x3E2E147B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x180
	LDI  R30,LOW(2)
	RJMP _0x221
; 0000 0218     else if (faza> 0   )   viz_faza=1;
_0x180:
	CALL SUBOPT_0x2D
	CALL __CPD02
	BRGE _0x182
	LDI  R30,LOW(1)
	RJMP _0x221
; 0000 0219     else if (faza> -0.17)  viz_faza=16;
_0x182:
	CALL SUBOPT_0x2D
	__GETD1N 0xBE2E147B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x184
	LDI  R30,LOW(16)
	RJMP _0x221
; 0000 021A     else if (faza> -0.35)  viz_faza=15;
_0x184:
	CALL SUBOPT_0x2D
	__GETD1N 0xBEB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x186
	LDI  R30,LOW(15)
	RJMP _0x221
; 0000 021B     else if (faza> -0.52)  viz_faza=14;
_0x186:
	CALL SUBOPT_0x2D
	__GETD1N 0xBF051EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x188
	LDI  R30,LOW(14)
	RJMP _0x221
; 0000 021C     else if (faza> -0.70)  viz_faza=13;
_0x188:
	CALL SUBOPT_0x2D
	__GETD1N 0xBF333333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18A
	LDI  R30,LOW(13)
	RJMP _0x221
; 0000 021D     else if (faza> -0.82)  viz_faza=12;
_0x18A:
	CALL SUBOPT_0x2D
	__GETD1N 0xBF51EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18C
	LDI  R30,LOW(12)
	RJMP _0x221
; 0000 021E     else if (faza> -1.05)  viz_faza=11;
_0x18C:
	CALL SUBOPT_0x2D
	__GETD1N 0xBF866666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x18E
	LDI  R30,LOW(11)
	RJMP _0x221
; 0000 021F     else if (faza> -1.22)  viz_faza=10;
_0x18E:
	CALL SUBOPT_0x2D
	__GETD1N 0xBF9C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x190
	LDI  R30,LOW(10)
	RJMP _0x221
; 0000 0220     else if (faza> -1.30)  viz_faza=9;
_0x190:
	CALL SUBOPT_0x2D
	__GETD1N 0xBFA66666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x192
	LDI  R30,LOW(9)
	RJMP _0x221
; 0000 0221     else if (faza> -1.40)  viz_faza=0;
_0x192:
	CALL SUBOPT_0x2D
	__GETD1N 0xBFB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x194
_0x220:
	LDI  R30,LOW(0)
_0x221:
	STS  _viz_faza,R30
; 0000 0222 
; 0000 0223     return;
_0x194:
	RET
; 0000 0224     }
;
;void start(void)
; 0000 0227 {
_start:
; 0000 0228 // Declare your local variables here
; 0000 0229 
; 0000 022A // Input/Output Ports initialization
; 0000 022B // Port A initialization
; 0000 022C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 022D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 022E PORTA=0x80;
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 022F DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0230 
; 0000 0231 // Port B initialization
; 0000 0232 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 0233 // State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T
; 0000 0234 PORTB=0x00;
	OUT  0x18,R30
; 0000 0235 DDRB=0x00;
	OUT  0x17,R30
; 0000 0236 
; 0000 0237 // Port C initialization
; 0000 0238 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0239 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 023A PORTC=0x00;
	OUT  0x15,R30
; 0000 023B DDRC=0x00;
	OUT  0x14,R30
; 0000 023C 
; 0000 023D // Port D initialization
; 0000 023E // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 023F // State7=0 State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0240 PORTD=0x00;
	OUT  0x12,R30
; 0000 0241 DDRD=0x90;
	LDI  R30,LOW(144)
	OUT  0x11,R30
; 0000 0242 
; 0000 0243 // Timer/Counter 0 initialization
; 0000 0244 // Clock source: System Clock
; 0000 0245 // Clock value: Timer 0 Stopped
; 0000 0246 // Mode: Normal top=FFh
; 0000 0247 // OC0 output: Disconnected
; 0000 0248 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0249 TCNT0=0x00;
	OUT  0x32,R30
; 0000 024A OCR0=0x00;
	OUT  0x3C,R30
; 0000 024B 
; 0000 024C // Timer/Counter 1 initialization
; 0000 024D // Clock source: System Clock
; 0000 024E // Clock value: 16000,000 kHz
; 0000 024F // Mode: Fast PWM top=OCR1A
; 0000 0250 // OC1A output: Discon.
; 0000 0251 // OC1B output: Non-Inv.
; 0000 0252 // Noise Canceler: Off
; 0000 0253 // Input Capture on Falling Edge
; 0000 0254 // Timer1 Overflow Interrupt: Off
; 0000 0255 // Input Capture Interrupt: Off
; 0000 0256 // Compare A Match Interrupt: Off
; 0000 0257 // Compare B Match Interrupt: Off
; 0000 0258 TCCR1A=0x23;
	LDI  R30,LOW(35)
	OUT  0x2F,R30
; 0000 0259 TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 025A TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 025B TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 025C ICR1H=0x00;
	OUT  0x27,R30
; 0000 025D ICR1L=0x00;
	OUT  0x26,R30
; 0000 025E OCR1AH=0x07;
	LDI  R30,LOW(7)
	OUT  0x2B,R30
; 0000 025F OCR1AL=0xCE;
	LDI  R30,LOW(206)
	OUT  0x2A,R30
; 0000 0260 OCR1BH=0x03;
	LDI  R30,LOW(3)
	OUT  0x29,R30
; 0000 0261 OCR1BL=0xE7;
	LDI  R30,LOW(231)
	OUT  0x28,R30
; 0000 0262 
; 0000 0263 // Timer/Counter 2 initialization
; 0000 0264 // Clock source: System Clock
; 0000 0265 // Clock value: Timer 2 Stopped
; 0000 0266 // Mode: Normal top=FFh
; 0000 0267 // OC2 output: Disconnected
; 0000 0268 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 0269 TCCR2=0x00;
	OUT  0x25,R30
; 0000 026A TCNT2=0x00;
	OUT  0x24,R30
; 0000 026B OCR2=0x00;
	OUT  0x23,R30
; 0000 026C 
; 0000 026D // Watchdog Timer initialization
; 0000 026E // Watchdog Timer Prescaler: OSC/2048k
; 0000 026F WDTCR=0x00;
	OUT  0x21,R30
; 0000 0270 
; 0000 0271 // External Interrupt(s) initialization
; 0000 0272 // INT0: Off
; 0000 0273 // INT1: Off
; 0000 0274 // INT2: Off
; 0000 0275 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0276 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0277 
; 0000 0278 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0279 TIMSK=0x00;
	OUT  0x39,R30
; 0000 027A 
; 0000 027B // Analog Comparator initialization
; 0000 027C // Analog Comparator: On
; 0000 027D // Analog Comparator Input Capture by Timer/Counter 1: On
; 0000 027E ACSR=0x07;
	LDI  R30,LOW(7)
	OUT  0x8,R30
; 0000 027F SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0280 
; 0000 0281 // ADC initialization
; 0000 0282 // ADC Clock frequency: 500,000 kHz
; 0000 0283 // ADC Voltage Reference: AVCC pin
; 0000 0284 // Only the 8 most significant bits of
; 0000 0285 // the AD conversion result are used
; 0000 0286 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0287 ADCSRA=0x85;
	LDI  R30,LOW(133)
	OUT  0x6,R30
; 0000 0288 
; 0000 0289 
; 0000 028A #asm("wdr")
	wdr
; 0000 028B // LCD module initialization
; 0000 028C lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 028D 
; 0000 028E lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 028F sprintf (string_LCD_1, "FINDER ^_^ Exxus");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1357
	CALL SUBOPT_0xE
; 0000 0290 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 0291 lcd_gotoxy (0,1);
; 0000 0292 sprintf (string_LCD_2, "v1.8.1   md4u.ru");
	__POINTW1FN _0x0,1374
	CALL SUBOPT_0xE
; 0000 0293 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 0294 delay_ms (25);
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x2E
; 0000 0295 
; 0000 0296 ampl = 0;
	CALL SUBOPT_0x2F
; 0000 0297 din_max=0x7f;
	LDI  R30,LOW(127)
	STS  _din_max,R30
; 0000 0298 din_min=0x7f;
	STS  _din_min,R30
; 0000 0299 st_zero_F=0x7f;
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	MOVW R6,R30
; 0000 029A st_zero_A=0x00;
	CLR  R4
	CLR  R5
; 0000 029B din_zero_A=0x7F;
	MOVW R8,R30
; 0000 029C gnd_F=0x7f;
	STS  _gnd_F,R30
; 0000 029D gnd_A=0x00;
	LDI  R30,LOW(0)
	STS  _gnd_A,R30
; 0000 029E 
; 0000 029F //if (Ftx_ee == 0xFFFF)   Ftx_ee = 0x07CE;
; 0000 02A0 //Ftx = Ftx_ee;
; 0000 02A1 
; 0000 02A2 
; 0000 02A3 kn_klava();
	CALL _kn_klava
; 0000 02A4 if (kn1==1) while (1)
	SBRS R2,0
	RJMP _0x195
_0x196:
; 0000 02A5                 {
; 0000 02A6                 kn_klava();
	CALL _kn_klava
; 0000 02A7                 new();
	CALL _new
; 0000 02A8 
; 0000 02A9                 if (kn2==1)
	SBRS R2,1
	RJMP _0x199
; 0000 02AA                         {
; 0000 02AB                         Ftx--;
	IN   R30,0x2A
	IN   R31,0x2A+1
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	ADIW R30,1
; 0000 02AC                         };
_0x199:
; 0000 02AD                 if (kn3==1)
	SBRS R2,2
	RJMP _0x19A
; 0000 02AE                         {
; 0000 02AF                         Ftx++;
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBIW R30,1
; 0000 02B0                         };
_0x19A:
; 0000 02B1                 if (kn6==1)
	SBRS R2,5
	RJMP _0x19B
; 0000 02B2                         {
; 0000 02B3                         if (Ftx != Ftx_ee)
	__INWR 0,1,42
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x19C
; 0000 02B4                                 {
; 0000 02B5                                 Ftx_ee = Ftx;
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	CALL __EEPROMWRW
; 0000 02B6                                 lcd_gotoxy (12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x7
; 0000 02B7                                 sprintf (string_LCD_1, "Save");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1391
	RJMP _0x222
; 0000 02B8                                 lcd_puts (string_LCD_1);
; 0000 02B9                                 }
; 0000 02BA                         else
_0x19C:
; 0000 02BB                                 {
; 0000 02BC                                 lcd_gotoxy (12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x7
; 0000 02BD                                 sprintf (string_LCD_1, "O.k.");
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1396
_0x222:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 02BE                                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL _lcd_puts
; 0000 02BF                                 };
; 0000 02C0 
; 0000 02C1                         if  (Frx != Frx_ee)
	__INWR 0,1,40
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	CALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x19E
; 0000 02C2                                 {
; 0000 02C3                                 Frx_ee = Frx;
	IN   R30,0x28
	IN   R31,0x28+1
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	CALL __EEPROMWRW
; 0000 02C4                                 lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xC
; 0000 02C5                                 sprintf (string_LCD_2, "Save");
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1391
	RJMP _0x223
; 0000 02C6                                 lcd_puts (string_LCD_2);
; 0000 02C7                                 }
; 0000 02C8                         else
_0x19E:
; 0000 02C9                                 {
; 0000 02CA                                 lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xC
; 0000 02CB                                 sprintf (string_LCD_2, "O.k.");
	CALL SUBOPT_0xB
	__POINTW1FN _0x0,1396
_0x223:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 02CC                                 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 02CD                                 };
; 0000 02CE                         while (kn6==1) kn_klava();
_0x1A0:
	SBRS R2,5
	RJMP _0x1A2
	CALL _kn_klava
	RJMP _0x1A0
_0x1A2:
; 0000 02CF continue;
	RJMP _0x196
; 0000 02D0                         };
_0x19B:
; 0000 02D1 
; 0000 02D2                 lcd_gotoxy (0,0);
	CALL SUBOPT_0x3
; 0000 02D3                 sprintf (string_LCD_1, "Freq-TX %3x [%2x]", Ftx, ampl);
	CALL SUBOPT_0x4
	__POINTW1FN _0x0,1401
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	CALL SUBOPT_0x30
	CALL SUBOPT_0x6
; 0000 02D4                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
; 0000 02D5 
; 0000 02D6                 lcd_gotoxy (0,1);
; 0000 02D7                 sprintf (string_LCD_2, "Faza-X  %3x [%2x]", Frx, faza);
	__POINTW1FN _0x0,1419
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x28
	IN   R31,0x28+1
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	CALL SUBOPT_0x31
	CALL SUBOPT_0x6
; 0000 02D8                 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xB
	CALL _lcd_puts
; 0000 02D9 
; 0000 02DA                 delay_ms (20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x2E
; 0000 02DB                 };
	RJMP _0x196
_0x195:
; 0000 02DC 
; 0000 02DD if (kn6==1) PORTD.7 = 1;
	SBRC R2,5
	SBI  0x12,7
; 0000 02DE }
	RET
;
;void main(void)
; 0000 02E1 {
_main:
; 0000 02E2 start ();
	RCALL _start
; 0000 02E3 while (1)
_0x1A6:
; 0000 02E4       {
; 0000 02E5       // Place your code here
; 0000 02E6       kn_klava();
	CALL _kn_klava
; 0000 02E7 
; 0000 02E8       #asm("wdr")
	wdr
; 0000 02E9       new();
	CALL _new
; 0000 02EA 
; 0000 02EB       if (kn1==1) main_menu();
	SBRS R2,0
	RJMP _0x1A9
	CALL _main_menu
; 0000 02EC       if (kn2==1) rezymm ();
_0x1A9:
	SBRS R2,1
	RJMP _0x1AA
	CALL _rezymm
; 0000 02ED       if (kn3==1) barrier();
_0x1AA:
	SBRC R2,2
	RCALL _barrier
; 0000 02EE       if (kn4==1) rock();
	SBRC R2,3
	RCALL _rock
; 0000 02EF       if (kn5==1) ground();
	SBRC R2,4
	RCALL _ground
; 0000 02F0       if (kn6==1) zero();
	SBRC R2,5
	RCALL _zero
; 0000 02F1 
; 0000 02F2       if (rezym == 0)
	TST  R10
	BRNE _0x1AF
; 0000 02F3         {
; 0000 02F4         if (mod_gnd == 1)
	SBRS R2,6
	RJMP _0x1B0
; 0000 02F5                 {
; 0000 02F6                 if ((faza <= gnd_F + bar_rad + 0.005 ) && (faza >= gnd_F - bar_rad - 0.005 ))
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
	BREQ PC+4
	BRCS PC+3
	JMP  _0x1B2
	CALL SUBOPT_0x32
	CALL SUBOPT_0x12
	CALL SUBOPT_0x34
	CALL SUBOPT_0x2D
	CALL __CMPF12
	BRSH _0x1B3
_0x1B2:
	RJMP _0x1B1
_0x1B3:
; 0000 02F7                     {
; 0000 02F8                     gnd_A = ampl;
	CALL SUBOPT_0x24
	CALL __CFD1U
	ST   X,R30
; 0000 02F9                     };
_0x1B1:
; 0000 02FA                 ampl = vektor_ampl (ampl, faza, gnd_A, gnd_F);
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x35
; 0000 02FB                 faza = vektor_faza (ampl, faza, gnd_A, gnd_F);
; 0000 02FC                 };
_0x1B0:
; 0000 02FD 
; 0000 02FE         if (mod_rock == 1)
	SBRS R2,7
	RJMP _0x1B4
; 0000 02FF                 {
; 0000 0300                 if ((faza <= rock_F + bar_rad + 0.005 ) && (faza >= rock_F - bar_rad - 0.005 ))
	CALL SUBOPT_0x36
	CALL SUBOPT_0x33
	BREQ PC+4
	BRCS PC+3
	JMP  _0x1B6
	CALL SUBOPT_0x36
	CALL SUBOPT_0x12
	CALL SUBOPT_0x34
	CALL SUBOPT_0x2D
	CALL __CMPF12
	BRSH _0x1B7
_0x1B6:
	RJMP _0x1B5
_0x1B7:
; 0000 0301                     {
; 0000 0302                     ampl = 0;
	CALL SUBOPT_0x2F
; 0000 0303                     faza = 1.45;
	CALL SUBOPT_0x37
; 0000 0304                     };
_0x1B5:
; 0000 0305                 };
_0x1B4:
; 0000 0306         }
; 0000 0307 
; 0000 0308       else if (rezym == 1)
	RJMP _0x1B8
_0x1AF:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+3
	JMP _0x1B9
; 0000 0309         {
; 0000 030A         if (mod_gnd == 1)
	SBRS R2,6
	RJMP _0x1BA
; 0000 030B                 {
; 0000 030C                 gnd_sekt_A = (int)ampl / 8;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x25
; 0000 030D                 gnd_sekt_F = (int)faza / 8;
; 0000 030E                 gnd_pos_A = (int)ampl % 8;
	CALL SUBOPT_0x26
; 0000 030F                 gnd_pos_F = (int)faza % 8;
; 0000 0310 
; 0000 0311                      if ((gnd_pos_F > 4) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x08)) zemlq = 1;
	CPI  R26,LOW(0x5)
	BRLO _0x1BC
	LDS  R26,_gnd_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1BC
	CALL SUBOPT_0x28
	ANDI R30,LOW(0x8)
	BRNE _0x1BD
_0x1BC:
	RJMP _0x1BB
_0x1BD:
	SET
	RJMP _0x224
; 0000 0312                 else if ((gnd_pos_F > 0) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x04)) zemlq = 1;
_0x1BB:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1C0
	LDS  R26,_gnd_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1C0
	CALL SUBOPT_0x28
	ANDI R30,LOW(0x4)
	BRNE _0x1C1
_0x1C0:
	RJMP _0x1BF
_0x1C1:
	SET
	RJMP _0x224
; 0000 0313                 else if ((gnd_pos_F > 4)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x02)) zemlq = 1;
_0x1BF:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x1C4
	CALL SUBOPT_0x28
	ANDI R30,LOW(0x2)
	BRNE _0x1C5
_0x1C4:
	RJMP _0x1C3
_0x1C5:
	SET
	RJMP _0x224
; 0000 0314                 else if ((gnd_pos_F > 0)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x01)) zemlq = 1;
_0x1C3:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1C8
	CALL SUBOPT_0x28
	ANDI R30,LOW(0x1)
	BRNE _0x1C9
_0x1C8:
	RJMP _0x1C7
_0x1C9:
	SET
	RJMP _0x224
; 0000 0315                 else                                                                                      zemlq = 0;
_0x1C7:
	CLT
_0x224:
	BLD  R3,1
; 0000 0316 
; 0000 0317                 if (zemlq == 1) gnd_A = ampl;
	SBRS R3,1
	RJMP _0x1CB
	CALL SUBOPT_0x24
	CALL __CFD1U
	ST   X,R30
; 0000 0318                 ampl = vektor_ampl (ampl, faza, gnd_A, gnd_F);
_0x1CB:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x35
; 0000 0319                 faza = vektor_faza (ampl, faza, gnd_A, gnd_F);
; 0000 031A                 };
_0x1BA:
; 0000 031B 
; 0000 031C         if (mod_rock == 1)
	SBRS R2,7
	RJMP _0x1CC
; 0000 031D                 {
; 0000 031E                 rock_sekt_A = (int)ampl / 8;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
; 0000 031F                 rock_sekt_F = (int)faza / 8;
; 0000 0320                 rock_pos_A = (int)ampl % 8;
	CALL SUBOPT_0x21
; 0000 0321                 rock_pos_F = (int)faza % 8;
; 0000 0322 
; 0000 0323                      if ((rock_pos_F > 4) && (rock_pos_A > 4) && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x80)) kamen = 1;
	CPI  R26,LOW(0x5)
	BRLO _0x1CE
	LDS  R26,_rock_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1CE
	CALL SUBOPT_0x23
	ANDI R30,LOW(0x80)
	BRNE _0x1CF
_0x1CE:
	RJMP _0x1CD
_0x1CF:
	SET
	RJMP _0x225
; 0000 0324                 else if ((rock_pos_F > 0) && (rock_pos_A > 4) && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x40)) kamen = 1;
_0x1CD:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1D2
	LDS  R26,_rock_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1D2
	CALL SUBOPT_0x23
	ANDI R30,LOW(0x40)
	BRNE _0x1D3
_0x1D2:
	RJMP _0x1D1
_0x1D3:
	SET
	RJMP _0x225
; 0000 0325                 else if ((rock_pos_F > 4)                     && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x20)) kamen = 1;
_0x1D1:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x1D6
	CALL SUBOPT_0x23
	ANDI R30,LOW(0x20)
	BRNE _0x1D7
_0x1D6:
	RJMP _0x1D5
_0x1D7:
	SET
	RJMP _0x225
; 0000 0326                 else if ((rock_pos_F > 0)                     && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x10)) kamen = 1;
_0x1D5:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1DA
	CALL SUBOPT_0x23
	ANDI R30,LOW(0x10)
	BRNE _0x1DB
_0x1DA:
	RJMP _0x1D9
_0x1DB:
	SET
	RJMP _0x225
; 0000 0327                 else                                                                                          kamen = 0;
_0x1D9:
	CLT
_0x225:
	BLD  R3,2
; 0000 0328 
; 0000 0329                 if (kamen == 1)
	SBRS R3,2
	RJMP _0x1DD
; 0000 032A                     {
; 0000 032B                     ampl = 0;
	CALL SUBOPT_0x2F
; 0000 032C                     faza = 1.45;
	CALL SUBOPT_0x37
; 0000 032D                     };
_0x1DD:
; 0000 032E                 };
_0x1CC:
; 0000 032F         ampl = ampl - (ampl * bar_rad / 3);
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x11
	__GETD1N 0x40400000
	CALL __DIVF21
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x12
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
; 0000 0330         }
; 0000 0331 
; 0000 0332       else if (rezym == 2)
	RJMP _0x1DE
_0x1B9:
	LDI  R30,LOW(2)
	CP   R30,R10
	BREQ PC+3
	JMP _0x1DF
; 0000 0333         {
; 0000 0334         if (din_A >= din_zero_A)
	MOVW R30,R8
	MOV  R26,R13
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1E0
; 0000 0335                 {
; 0000 0336                 if (din_A >= din_max) din_max=din_A;
	LDS  R30,_din_max
	CP   R13,R30
	BRLO _0x1E1
	STS  _din_max,R13
; 0000 0337                 else
	RJMP _0x1E2
_0x1E1:
; 0000 0338                         {
; 0000 0339                         din_max--;
	LDS  R30,_din_max
	SUBI R30,LOW(1)
	STS  _din_max,R30
; 0000 033A                         din_min++;
	LDS  R30,_din_min
	SUBI R30,-LOW(1)
	STS  _din_min,R30
; 0000 033B                         };
_0x1E2:
; 0000 033C                 }
; 0000 033D         else
	RJMP _0x1E3
_0x1E0:
; 0000 033E                 {
; 0000 033F                 if (din_A < din_min) din_min=din_A;
	LDS  R30,_din_min
	CP   R13,R30
	BRSH _0x1E4
	STS  _din_min,R13
; 0000 0340                 else
	RJMP _0x1E5
_0x1E4:
; 0000 0341                         {
; 0000 0342                         din_min++;
	LDS  R30,_din_min
	SUBI R30,-LOW(1)
	STS  _din_min,R30
; 0000 0343                         din_max--;
	LDS  R30,_din_max
	SUBI R30,LOW(1)
	STS  _din_max,R30
; 0000 0344                         };
_0x1E5:
; 0000 0345                 };
_0x1E3:
; 0000 0346 
; 0000 0347         if (din_max < din_zero_A) din_max=din_zero_A;
	CALL SUBOPT_0x38
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x1E6
	STS  _din_max,R8
; 0000 0348         if (din_min > din_zero_A) din_max=din_zero_A;
_0x1E6:
	MOVW R30,R8
	CALL SUBOPT_0x39
	BRSH _0x1E7
	STS  _din_max,R8
; 0000 0349 
; 0000 034A         if ((din_zero_A-din_min) < (din_max-din_zero_A))
_0x1E7:
	LDS  R30,_din_min
	MOVW R26,R8
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R22,R26
	CALL SUBOPT_0x38
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CP   R22,R30
	CPC  R23,R31
	BRLO PC+3
	JMP _0x1E8
; 0000 034B             {
; 0000 034C                  if (din_max> din_zero_A +92)   viz_din=8;
	MOVW R30,R8
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x3A
	BRSH _0x1E9
	LDI  R30,LOW(8)
	RJMP _0x226
; 0000 034D             else if (din_max> din_zero_A +81)   viz_din=7;
_0x1E9:
	MOVW R30,R8
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x3A
	BRSH _0x1EB
	LDI  R30,LOW(7)
	RJMP _0x226
; 0000 034E             else if (din_max> din_zero_A +70)   viz_din=6;
_0x1EB:
	MOVW R30,R8
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x3A
	BRSH _0x1ED
	LDI  R30,LOW(6)
	RJMP _0x226
; 0000 034F             else if (din_max> din_zero_A +59)   viz_din=5;
_0x1ED:
	MOVW R30,R8
	ADIW R30,59
	CALL SUBOPT_0x3A
	BRSH _0x1EF
	LDI  R30,LOW(5)
	RJMP _0x226
; 0000 0350             else if (din_max> din_zero_A +48)   viz_din=4;
_0x1EF:
	MOVW R30,R8
	ADIW R30,48
	CALL SUBOPT_0x3A
	BRSH _0x1F1
	LDI  R30,LOW(4)
	RJMP _0x226
; 0000 0351             else if (din_max> din_zero_A +37)   viz_din=3;
_0x1F1:
	MOVW R30,R8
	ADIW R30,37
	CALL SUBOPT_0x3A
	BRSH _0x1F3
	LDI  R30,LOW(3)
	RJMP _0x226
; 0000 0352             else if (din_max> din_zero_A +26)   viz_din=2;
_0x1F3:
	MOVW R30,R8
	ADIW R30,26
	CALL SUBOPT_0x3A
	BRSH _0x1F5
	LDI  R30,LOW(2)
	RJMP _0x226
; 0000 0353             else if (din_max> din_zero_A +15)   viz_din=1;
_0x1F5:
	MOVW R30,R8
	ADIW R30,15
	CALL SUBOPT_0x3A
	BRSH _0x1F7
	LDI  R30,LOW(1)
	RJMP _0x226
; 0000 0354             else                                viz_din=0;
_0x1F7:
	LDI  R30,LOW(0)
_0x226:
	STS  _viz_din,R30
; 0000 0355             }
; 0000 0356         else
	RJMP _0x1F9
_0x1E8:
; 0000 0357             {
; 0000 0358                  if (din_min> din_zero_A -5 )   viz_din=0;
	MOVW R30,R8
	SBIW R30,5
	CALL SUBOPT_0x39
	BRSH _0x1FA
	LDI  R30,LOW(0)
	RJMP _0x227
; 0000 0359             else if (din_min> din_zero_A -15)   viz_din=1;
_0x1FA:
	MOVW R30,R8
	SBIW R30,15
	CALL SUBOPT_0x39
	BRSH _0x1FC
	LDI  R30,LOW(1)
	RJMP _0x227
; 0000 035A             else if (din_min> din_zero_A -26)   viz_din=2;
_0x1FC:
	MOVW R30,R8
	SBIW R30,26
	CALL SUBOPT_0x39
	BRSH _0x1FE
	LDI  R30,LOW(2)
	RJMP _0x227
; 0000 035B             else if (din_min> din_zero_A -37)   viz_din=3;
_0x1FE:
	MOVW R30,R8
	SBIW R30,37
	CALL SUBOPT_0x39
	BRSH _0x200
	LDI  R30,LOW(3)
	RJMP _0x227
; 0000 035C             else if (din_min> din_zero_A -48)   viz_din=4;
_0x200:
	MOVW R30,R8
	SBIW R30,48
	CALL SUBOPT_0x39
	BRSH _0x202
	LDI  R30,LOW(4)
	RJMP _0x227
; 0000 035D             else if (din_min> din_zero_A -59)   viz_din=5;
_0x202:
	MOVW R30,R8
	SBIW R30,59
	CALL SUBOPT_0x39
	BRSH _0x204
	LDI  R30,LOW(5)
	RJMP _0x227
; 0000 035E             else if (din_min> din_zero_A -70)   viz_din=6;
_0x204:
	MOVW R30,R8
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x39
	BRSH _0x206
	LDI  R30,LOW(6)
	RJMP _0x227
; 0000 035F             else if (din_min> din_zero_A -81)   viz_din=7;
_0x206:
	MOVW R30,R8
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x39
	BRSH _0x208
	LDI  R30,LOW(7)
	RJMP _0x227
; 0000 0360             else                                viz_din=8;
_0x208:
	LDI  R30,LOW(8)
_0x227:
	STS  _viz_din,R30
; 0000 0361             };
_0x1F9:
; 0000 0362         }
; 0000 0363 
; 0000 0364       else
	RJMP _0x20A
_0x1DF:
; 0000 0365         {
; 0000 0366         TCCR1B=0x18;
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0000 0367         TCCR0=0x18;
	OUT  0x33,R30
; 0000 0368         PORTB.3=0;
	CBI  0x18,3
; 0000 0369         PORTD.4=0;
	CBI  0x12,4
; 0000 036A         PORTD.5=0;
	CBI  0x12,5
; 0000 036B         viz_ampl = 0;
	CLR  R12
; 0000 036C         viz_faza = 0;
	LDI  R30,LOW(0)
	STS  _viz_faza,R30
; 0000 036D         };
_0x20A:
_0x1DE:
_0x1B8:
; 0000 036E 
; 0000 036F       vizual();
	RCALL _vizual
; 0000 0370       lcd_disp();
	CALL _lcd_disp
; 0000 0371 
; 0000 0372       delay_ms (10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2E
; 0000 0373       };
	RJMP _0x1A6
; 0000 0374 }
_0x211:
	RJMP _0x211
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
	JMP  _0x20C0007
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
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
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
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0007
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
	RJMP _0x20C0007
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
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3B
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x3C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x3C
	LDI  R30,LOW(133)
	CALL SUBOPT_0x3C
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
_0x20C0007:
	ADIW R28,1
	RET
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
_put_buff_G101:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x3D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x3D
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
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
	BRNE _0x2020019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,0
	CALL SUBOPT_0x3E
	RJMP _0x20C0006
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x2020000,1
	CALL SUBOPT_0x3E
	RJMP _0x20C0006
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001E
	CALL SUBOPT_0x3F
	RJMP _0x202001C
_0x202001E:
	CALL SUBOPT_0x16
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x3F
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x40
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020021
	CALL SUBOPT_0x3F
_0x2020022:
	CALL SUBOPT_0x40
	BRLO _0x2020024
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x40
	BRSH _0x2020028
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0x3F
_0x2020025:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x45
	CALL SUBOPT_0x44
	CALL SUBOPT_0x40
	BRLO _0x2020029
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x41
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x0
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x41
	CALL SUBOPT_0x12
	CALL SUBOPT_0x44
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x49
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x4C
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	CALL SUBOPT_0x49
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x202002E:
	CPI  R19,10
	BRLT _0x202002F
	CALL SUBOPT_0x4C
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x202002F:
	CALL SUBOPT_0x4C
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
_0x20C0006:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G101:
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x3D
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	CALL SUBOPT_0x4D
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x4D
	RJMP _0x202010E
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x4E
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x50
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x202005A
_0x2020059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x51
	CALL __GETD1P
	CALL SUBOPT_0x52
	CALL SUBOPT_0x53
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	RJMP _0x202005E
_0x202005B:
	CALL SUBOPT_0x54
	CALL __ANEGF1
	CALL SUBOPT_0x52
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x202005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x50
	RJMP _0x2020060
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020060:
_0x202005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020062
	CALL SUBOPT_0x54
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2020063
_0x2020062:
	CALL SUBOPT_0x54
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL __ftoe_G101
_0x2020063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x55
	RJMP _0x2020064
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020066
	CALL SUBOPT_0x53
	CALL SUBOPT_0x56
	CALL SUBOPT_0x55
	RJMP _0x2020067
_0x2020066:
	CPI  R30,LOW(0x70)
	BRNE _0x2020069
	CALL SUBOPT_0x53
	CALL SUBOPT_0x56
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006B
	CP   R20,R17
	BRLO _0x202006C
_0x202006B:
	RJMP _0x202006A
_0x202006C:
	MOV  R17,R20
_0x202006A:
_0x2020064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006D
_0x2020069:
	CPI  R30,LOW(0x64)
	BREQ _0x2020070
	CPI  R30,LOW(0x69)
	BRNE _0x2020071
_0x2020070:
	ORI  R16,LOW(4)
	RJMP _0x2020072
_0x2020071:
	CPI  R30,LOW(0x75)
	BRNE _0x2020073
_0x2020072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x57
	LDI  R17,LOW(10)
	RJMP _0x2020075
_0x2020074:
	__GETD1N 0x2710
	CALL SUBOPT_0x57
	LDI  R17,LOW(5)
	RJMP _0x2020075
_0x2020073:
	CPI  R30,LOW(0x58)
	BRNE _0x2020077
	ORI  R16,LOW(8)
	RJMP _0x2020078
_0x2020077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200B6
_0x2020078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x57
	LDI  R17,LOW(8)
	RJMP _0x2020075
_0x202007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x57
	LDI  R17,LOW(4)
_0x2020075:
	CPI  R20,0
	BREQ _0x202007B
	ANDI R16,LOW(127)
	RJMP _0x202007C
_0x202007B:
	LDI  R20,LOW(1)
_0x202007C:
	SBRS R16,1
	RJMP _0x202007D
	CALL SUBOPT_0x53
	CALL SUBOPT_0x51
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x202010F
_0x202007D:
	SBRS R16,2
	RJMP _0x202007F
	CALL SUBOPT_0x53
	CALL SUBOPT_0x56
	CALL __CWD1
	RJMP _0x202010F
_0x202007F:
	CALL SUBOPT_0x53
	CALL SUBOPT_0x56
	CLR  R22
	CLR  R23
_0x202010F:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020082
	CALL SUBOPT_0x54
	CALL __ANEGD1
	CALL SUBOPT_0x52
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020084
_0x2020083:
	ANDI R16,LOW(251)
_0x2020084:
_0x2020081:
	MOV  R19,R20
_0x202006D:
	SBRC R16,0
	RJMP _0x2020085
_0x2020086:
	CP   R17,R21
	BRSH _0x2020089
	CP   R19,R21
	BRLO _0x202008A
_0x2020089:
	RJMP _0x2020088
_0x202008A:
	SBRS R16,7
	RJMP _0x202008B
	SBRS R16,2
	RJMP _0x202008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008D
_0x202008C:
	LDI  R18,LOW(48)
_0x202008D:
	RJMP _0x202008E
_0x202008B:
	LDI  R18,LOW(32)
_0x202008E:
	CALL SUBOPT_0x4D
	SUBI R21,LOW(1)
	RJMP _0x2020086
_0x2020088:
_0x2020085:
_0x202008F:
	CP   R17,R20
	BRSH _0x2020091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020092
	CALL SUBOPT_0x58
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x50
	CPI  R21,0
	BREQ _0x2020094
	SUBI R21,LOW(1)
_0x2020094:
	SUBI R20,LOW(1)
	RJMP _0x202008F
_0x2020091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020095
_0x2020096:
	CPI  R19,0
	BREQ _0x2020098
	SBRS R16,3
	RJMP _0x2020099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x202009A
_0x2020099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009A:
	CALL SUBOPT_0x4D
	CPI  R21,0
	BREQ _0x202009B
	SUBI R21,LOW(1)
_0x202009B:
	SUBI R19,LOW(1)
	RJMP _0x2020096
_0x2020098:
	RJMP _0x202009C
_0x2020095:
_0x202009E:
	CALL SUBOPT_0x59
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A0
	SBRS R16,3
	RJMP _0x20200A1
	SUBI R18,-LOW(55)
	RJMP _0x20200A2
_0x20200A1:
	SUBI R18,-LOW(87)
_0x20200A2:
	RJMP _0x20200A3
_0x20200A0:
	SUBI R18,-LOW(48)
_0x20200A3:
	SBRC R16,4
	RJMP _0x20200A5
	CPI  R18,49
	BRSH _0x20200A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200A6
_0x20200A7:
	RJMP _0x20200A9
_0x20200A6:
	CP   R20,R19
	BRSH _0x2020110
	CP   R21,R19
	BRLO _0x20200AC
	SBRS R16,0
	RJMP _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200AE
_0x2020110:
	LDI  R18,LOW(48)
_0x20200A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AF
	CALL SUBOPT_0x58
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AF:
_0x20200AE:
_0x20200A5:
	CALL SUBOPT_0x4D
	CPI  R21,0
	BREQ _0x20200B1
	SUBI R21,LOW(1)
_0x20200B1:
_0x20200AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x59
	CALL __MODD21U
	CALL SUBOPT_0x52
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x57
	CALL SUBOPT_0x14
	CALL __CPD10
	BREQ _0x202009F
	RJMP _0x202009E
_0x202009F:
_0x202009C:
	SBRS R16,0
	RJMP _0x20200B2
_0x20200B3:
	CPI  R21,0
	BREQ _0x20200B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x50
	RJMP _0x20200B3
_0x20200B5:
_0x20200B2:
_0x20200B6:
_0x2020054:
_0x202010E:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x5A
	SBIW R30,0
	BRNE _0x20200B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0005
_0x20200B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x5A
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0005:
	CALL __LOADLOCR4
	ADIW R28,10
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
	CALL SUBOPT_0x18
	CALL _ftrunc
	CALL SUBOPT_0x15
    brne __floor1
__floor0:
	CALL SUBOPT_0x5B
	RJMP _0x20C0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0x5C
	CALL __SUBF12
	RJMP _0x20C0004
_sin:
	CALL SUBOPT_0x5D
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x48
	CALL SUBOPT_0x60
	CALL SUBOPT_0x12
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x61
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0x5F
	__GETD2N 0x3F000000
	CALL __SUBF12
	CALL SUBOPT_0x5E
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0x60
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0x61
	CALL __SUBF12
	CALL SUBOPT_0x5E
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0x62
_0x2040019:
	CALL SUBOPT_0x63
	__PUTD1S 1
	CALL SUBOPT_0x64
	__GETD2N 0x4226C4B1
	CALL SUBOPT_0x11
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x12
	CALL SUBOPT_0x65
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x60
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x64
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x65
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20C0003
_cos:
	CALL SUBOPT_0x66
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0004
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x15
	CALL SUBOPT_0x5B
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x67
	CALL SUBOPT_0x4B
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5B
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x66
	CALL SUBOPT_0x67
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x66
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x18
	RCALL _xatan
	RJMP _0x20C0004
_0x2040020:
	CALL SUBOPT_0x66
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x5C
	CALL SUBOPT_0x1B
	RCALL _xatan
	CALL SUBOPT_0x68
	RJMP _0x20C0004
_0x2040021:
	CALL SUBOPT_0x5C
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5C
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x1B
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0004:
	ADIW R28,4
	RET
_asin:
	CALL SUBOPT_0x5D
	__GETD1N 0xBF800000
	CALL __CMPF12
	BRLO _0x2040023
	CALL SUBOPT_0x60
	__GETD1N 0x3F800000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x2040023
	RJMP _0x2040022
_0x2040023:
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0003
_0x2040022:
	LDD  R26,Y+8
	TST  R26
	BRPL _0x2040025
	CALL SUBOPT_0x62
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0x63
	__GETD2N 0x3F800000
	CALL SUBOPT_0x12
	CALL __PUTPARD1
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0x60
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0x5F
	__GETD2S 1
	CALL SUBOPT_0x1B
	RCALL _yatan
	CALL SUBOPT_0x68
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0x64
	CALL SUBOPT_0x60
	CALL SUBOPT_0x1B
	RCALL _yatan
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0x64
	CALL __ANEGF1
	RJMP _0x20C0003
_0x2040028:
	CALL SUBOPT_0x64
_0x20C0003:
	LDD  R17,Y+0
	ADIW R28,9
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
	RCALL SUBOPT_0x3E
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
	RCALL SUBOPT_0x3E
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x69
	RCALL SUBOPT_0x6A
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
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x6C
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x6D
	CALL __ADDF12
	RCALL SUBOPT_0x69
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x6C
_0x20A0014:
	RCALL SUBOPT_0x6D
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x6C
	SUBI R17,-LOW(1)
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0017
	RCALL SUBOPT_0x6A
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0018
_0x20A0017:
_0x20A0019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001B
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x6D
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x0
	CALL __MULF12
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x69
	RJMP _0x20A0019
_0x20A001B:
_0x20A0018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x6A
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A001F
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x69
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x6E
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x69
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
_ampl:
	.BYTE 0x4
_faza:
	.BYTE 0x4
_bar_rad:
	.BYTE 0x4
_viz_faza:
	.BYTE 0x1
_viz_din:
	.BYTE 0x1
_din_max:
	.BYTE 0x1
_din_min:
	.BYTE 0x1
_gnd_F:
	.BYTE 0x1
_gnd_A:
	.BYTE 0x1
_rock_F:
	.BYTE 0x1
_rock_A:
	.BYTE 0x1
_batt:
	.BYTE 0x4
_rastr_st:
	.BYTE 0x400
_gnd_pos_F:
	.BYTE 0x1
_gnd_pos_A:
	.BYTE 0x1
_rock_pos_F:
	.BYTE 0x1
_rock_pos_A:
	.BYTE 0x1
_gnd_sekt_F:
	.BYTE 0x1
_gnd_sekt_A:
	.BYTE 0x1
_rock_sekt_F:
	.BYTE 0x1
_rock_sekt_A:
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
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 79 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x8:
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x9:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0xA:
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
	CALL __PUTPARD1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__POINTW1FN _0x0,162
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	__POINTW1FN _0x0,199
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_geb
	CALL __CBD1
	CALL __PUTPARD1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x12:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x13:
	STS  _faza,R30
	STS  _faza+1,R31
	STS  _faza+2,R22
	STS  _faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETD2S 12
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	CALL __GETD1S0
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1A:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:99 WORDS
SUBOPT_0x1D:
	LDS  R30,_ampl
	LDS  R31,_ampl+1
	LDS  R22,_ampl+2
	LDS  R23,_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	CALL __CFD1U
	ST   X,R30
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x1D
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x20:
	CALL __DIVW21
	STS  _rock_sekt_A,R30
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STS  _rock_sekt_F,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x21:
	CALL __MODW21
	STS  _rock_pos_A,R30
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	STS  _rock_pos_F,R30
	LDS  R26,_rock_pos_F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	CALL __GTB12U
	MOV  R0,R30
	LDS  R26,_rock_pos_A
	LDI  R30,LOW(4)
	CALL __GTB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x23:
	LDS  R30,_rock_sekt_F
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-_rastr_st)
	SBCI R31,HIGH(-_rastr_st)
	MOVW R26,R30
	LDS  R30,_rock_sekt_A
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(_gnd_A)
	LDI  R27,HIGH(_gnd_A)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x25:
	CALL __DIVW21
	STS  _gnd_sekt_A,R30
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STS  _gnd_sekt_F,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x26:
	CALL __MODW21
	STS  _gnd_pos_A,R30
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	STS  _gnd_pos_F,R30
	LDS  R26,_gnd_pos_F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	CALL __GTB12U
	MOV  R0,R30
	LDS  R26,_gnd_pos_A
	LDI  R30,LOW(4)
	CALL __GTB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x28:
	LDS  R30,_gnd_sekt_F
	LDI  R31,0
	LSL  R30
	ROL  R31
	CALL __LSLW4
	SUBI R30,LOW(-_rastr_st)
	SBCI R31,HIGH(-_rastr_st)
	MOVW R26,R30
	LDS  R30,_gnd_sekt_A
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x29:
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x2A:
	LDS  R26,_ampl
	LDS  R27,_ampl+1
	LDS  R24,_ampl+2
	LDS  R25,_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2B:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x2C:
	MOV  R26,R13
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x2D:
	LDS  R26,_faza
	LDS  R27,_faza+1
	LDS  R24,_faza+2
	LDS  R25,_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _ampl,R30
	STS  _ampl+1,R30
	STS  _ampl+2,R30
	STS  _ampl+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	RCALL SUBOPT_0x1D
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	RCALL SUBOPT_0x29
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x32:
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	LDS  R26,_gnd_F
	CLR  R27
	CLR  R24
	CLR  R25
	CALL __CDF2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	CALL __ADDF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	RCALL SUBOPT_0x2D
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3BA3D70A
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x35:
	LDS  R30,_gnd_A
	RCALL SUBOPT_0x0
	CALL __PUTPARD1
	LDS  R30,_gnd_F
	RCALL SUBOPT_0x0
	CALL __PUTPARD1
	CALL _vektor_ampl
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
	RCALL SUBOPT_0x1D
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x29
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_A
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_gnd_F
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _vektor_faza
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x36:
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	LDS  R26,_rock_F
	CLR  R27
	CLR  R24
	CLR  R25
	CALL __CDF2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETD1N 0x3FB9999A
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	MOVW R30,R8
	LDS  R26,_din_max
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x39:
	LDS  R26,_din_min
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x3A:
	LDS  R26,_din_max
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3B:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3F:
	__GETD2S 4
	RCALL SUBOPT_0x2B
	CALL __MULF12
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0x1A
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x2B
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	RCALL SUBOPT_0x46
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4C:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4D:
	ST   -Y,R18
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4E:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4F:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x50:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x51:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x4E
	RJMP SUBOPT_0x4F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x55:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x56:
	RCALL SUBOPT_0x51
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x57:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x58:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW1SX 87
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 91
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	RCALL SUBOPT_0x14
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5B:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5C:
	RCALL SUBOPT_0x5B
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5D:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5E:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5F:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x60:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	RCALL SUBOPT_0x60
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	RCALL SUBOPT_0x5F
	CALL __ANEGF1
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x60
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	__GETD2N 0x3FC90FDB
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x69:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__CBD2:
	MOV  R27,R26
	ADD  R27,R27
	SBC  R27,R27
	MOV  R24,R27
	MOV  R25,R27
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
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

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
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
