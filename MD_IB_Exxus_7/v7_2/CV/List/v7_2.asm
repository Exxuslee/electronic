
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : long, width
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
	.DEF _geb=R5
	.DEF _adc_data=R4
	.DEF _new_st_A=R7
	.DEF _new_st_F=R6
	.DEF _din_A=R9
	.DEF _din_F=R8
	.DEF _viz_ampl=R11
	.DEF _viz_faza=R10
	.DEF _viz_din=R13
	.DEF _din_max=R12

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x25,0x32,0x2E,0x31,0x66,0x56,0x20,0x42
	.DB  0x3D,0x25,0x64,0x20,0x0,0x53,0x74,0x5F
	.DB  0x56,0x65,0x63,0x0,0x53,0x74,0x5F,0x52
	.DB  0x61,0x73,0x0,0x20,0x44,0x69,0x6E,0x61
	.DB  0x6D,0x0,0x53,0x74,0x6F,0x70,0x54,0x58
	.DB  0x0,0x5B,0x25,0x32,0x78,0x3B,0x25,0x32
	.DB  0x78,0x5D,0x20,0x3D,0x0,0x2B,0x52,0x0
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
	.DB  0x2E,0x32,0x66,0x29,0x20,0x20,0x0,0x3E
	.DB  0x3E,0x3E,0x3E,0x20,0x47,0x2E,0x45,0x2E
	.DB  0x42,0x2E,0x20,0x3C,0x3C,0x3C,0x3C,0x0
	.DB  0x20,0x20,0x25,0x2B,0x64,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x3E,0x20,0x47,0x72,0x6F,0x75,0x6E
	.DB  0x64,0x20,0x5B,0x58,0x3B,0x59,0x5D,0x20
	.DB  0x3C,0x0,0x53,0x3E,0x20,0x5A,0x65,0x72
	.DB  0x6F,0x20,0x5B,0x58,0x3B,0x59,0x5D,0x20
	.DB  0x3C,0x44,0x0,0x28,0x25,0x30,0x33,0x2E
	.DB  0x30,0x66,0x3A,0x25,0x2B,0x2E,0x32,0x66
	.DB  0x29,0x20,0x5B,0x25,0x32,0x78,0x3B,0x25
	.DB  0x32,0x78,0x5D,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x5F,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F,0x20
	.DB  0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x0,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x5F,0x20,0x20,0x20,0x0,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0x20,0x20,0x20,0x0,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x5F,0x20,0x20,0x0
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x5F
	.DB  0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x0,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x5F,0x0,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0xFF,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0xFF
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0xFF,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0xFF,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0xFF,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0xFF,0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x53
	.DB  0x74,0x6F,0x70,0x5F,0x5F,0x54,0x78,0x20
	.DB  0x20,0x20,0x20,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x6F,0x5F,0x4F,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x23,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x23,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x23,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x2D,0x2D,0x23,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x23,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x49,0x23,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x23,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x23,0x49,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x23,0x49,0x49,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0,0xDB
	.DB  0x2D,0x2D,0x2D,0x2D,0x23,0x2D,0x49,0x49
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC,0x0
	.DB  0xDB,0x2D,0x2D,0x2D,0x23,0x2D,0x2D,0x49
	.DB  0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xDC
	.DB  0x0,0xDB,0x2D,0x2D,0x23,0x2D,0x2D,0x2D
	.DB  0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0xDC,0x0,0xDB,0x2D,0x23,0x2D,0x2D,0x2D
	.DB  0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xDC,0x0,0xDB,0x23,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xDC,0x0,0x3E,0x5F,0x3C,0x2D
	.DB  0x2D,0x2D,0x2D,0x49,0x49,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xDC,0x0,0x3E,0x0,0x46
	.DB  0x49,0x4E,0x44,0x45,0x52,0x20,0x5E,0x5F
	.DB  0x5E,0x20,0x45,0x78,0x78,0x75,0x73,0x0
	.DB  0x76,0x31,0x2E,0x37,0x2E,0x32,0x20,0x20
	.DB  0x20,0x6D,0x64,0x34,0x75,0x2E,0x72,0x75
	.DB  0x0,0x53,0x61,0x76,0x65,0x0,0x4F,0x2E
	.DB  0x6B,0x2E,0x0,0x46,0x72,0x65,0x71,0x2D
	.DB  0x54,0x58,0x20,0x25,0x33,0x78,0x20,0x5B
	.DB  0x25,0x32,0x78,0x5D,0x0,0x46,0x61,0x7A
	.DB  0x61,0x2D,0x58,0x20,0x20,0x25,0x33,0x78
	.DB  0x20,0x5B,0x25,0x32,0x78,0x5D,0x0
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
;Version : 1.7.2
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
;bit kn1, kn2, kn3, kn4, kn5, kn6, mod_gnd, mod_rock, mod_all_met, zemlq, kamen, menu;
;
;char string_LCD_1[20], string_LCD_2[20];
;signed char geb;
;unsigned char adc_data;
;unsigned char new_st_A, new_st_F, din_A, din_F;
;unsigned char viz_ampl, viz_faza, viz_din, din_max, din_min;
;unsigned char bar, rezym;
;unsigned char rastr_st[0x20][0x20], gnd_pos_A, gnd_pos_F, rock_pos_A, rock_pos_F, gnd_sekt_A, gnd_sekt_F, rock_sekt_A, rock_sekt_F;
;
;unsigned int din_zero_A, din_zero_F;
;
;float st_zero_A, st_zero_F;
;float ampl, faza, bar_rad, st_A, st_F;
;float gnd_A, gnd_F, rock_A, rock_F;
;
;eeprom unsigned int Ftx_ee, Frx_ee;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0033     {

	.CSEG
_adc_isr:
; 0000 0034     // Read the 8 most significant bits
; 0000 0035     // of the AD conversion result
; 0000 0036     adc_data=ADCH;
	IN   R4,5
; 0000 0037     }
	RETI
;
;// Read the 8 most significant bits
;// of the AD conversion result
;// with noise canceling
;unsigned char read_adc(unsigned char adc_input)
; 0000 003D     {
_read_adc:
; 0000 003E     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 003F     // Delay needed for the stabilization of the ADC input voltage
; 0000 0040     delay_us(10);
	__DELAY_USB 53
; 0000 0041     #asm
; 0000 0042         in   r30,mcucr
        in   r30,mcucr
; 0000 0043         cbr  r30,__sm_mask
        cbr  r30,__sm_mask
; 0000 0044         sbr  r30,__se_bit | __sm_adc_noise_red
        sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0045         out  mcucr,r30
        out  mcucr,r30
; 0000 0046         sleep
        sleep
; 0000 0047         cbr  r30,__se_bit
        cbr  r30,__se_bit
; 0000 0048         out  mcucr,r30
        out  mcucr,r30
; 0000 0049     #endasm
; 0000 004A     return adc_data;
	MOV  R30,R4
	ADIW R28,1
	RET
; 0000 004B     }
;
;void kn_klava(void)
; 0000 004E     {
_kn_klava:
; 0000 004F     #asm("wdr")
	wdr
; 0000 0050     kn1=0;
	CLT
	BLD  R2,0
; 0000 0051     kn2=0;
	BLD  R2,1
; 0000 0052     kn3=0;
	BLD  R2,2
; 0000 0053     kn4=0;
	BLD  R2,3
; 0000 0054     kn5=0;
	BLD  R2,4
; 0000 0055     kn6=0;
	BLD  R2,5
; 0000 0056     DDRA.5=1;
	SBI  0x1A,5
; 0000 0057     PORTA.5=0;
	CBI  0x1B,5
; 0000 0058     delay_ms (2);
	CALL SUBOPT_0x0
; 0000 0059     if (PINA.6==0 && PINA.7==0) kn1=1;
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x8
	CALL SUBOPT_0x1
	BREQ _0x9
_0x8:
	RJMP _0x7
_0x9:
	SET
	BLD  R2,0
; 0000 005A     if (PINA.6==1 && PINA.7==0) kn2=1;
_0x7:
	SBIS 0x19,6
	RJMP _0xB
	CALL SUBOPT_0x1
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
	SET
	BLD  R2,1
; 0000 005B     DDRA.5=0;
_0xA:
	CBI  0x1A,5
; 0000 005C     DDRA.6=1;
	SBI  0x1A,6
; 0000 005D     PORTA.5=1;
	SBI  0x1B,5
; 0000 005E     PORTA.6=0;
	CBI  0x1B,6
; 0000 005F     delay_ms (2);
	CALL SUBOPT_0x0
; 0000 0060     if (PINA.5==1 && PINA.7==0) kn3=1;
	SBIS 0x19,5
	RJMP _0x16
	CALL SUBOPT_0x1
	BREQ _0x17
_0x16:
	RJMP _0x15
_0x17:
	SET
	BLD  R2,2
; 0000 0061     if (PINA.5==0 && PINA.7==0) kn4=1;
_0x15:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x19
	CALL SUBOPT_0x1
	BREQ _0x1A
_0x19:
	RJMP _0x18
_0x1A:
	SET
	BLD  R2,3
; 0000 0062     DDRA.6=0;
_0x18:
	CBI  0x1A,6
; 0000 0063     DDRA.7=1;
	SBI  0x1A,7
; 0000 0064     PORTA.6=1;
	SBI  0x1B,6
; 0000 0065     PORTA.7=0;
	CBI  0x1B,7
; 0000 0066     delay_ms (2);
	CALL SUBOPT_0x0
; 0000 0067     if (PINA.5==1 && PINA.6==0) kn5=1;
	SBIS 0x19,5
	RJMP _0x24
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
; 0000 0068     if (PINA.5==0 && PINA.6==1) kn6=1;
_0x23:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x27
	SBIC 0x19,6
	RJMP _0x28
_0x27:
	RJMP _0x26
_0x28:
	SET
	BLD  R2,5
; 0000 0069     DDRA.7=0;
_0x26:
	CBI  0x1A,7
; 0000 006A     PORTA.7=1;
	SBI  0x1B,7
; 0000 006B     return;
	RET
; 0000 006C     }
;
;void lcd_disp(void)
; 0000 006F     {
_lcd_disp:
; 0000 0070     if (menu==1)
	SBRS R3,3
	RJMP _0x2D
; 0000 0071         {
; 0000 0072         lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 0073         sprintf (string_LCD_1, "%2.1fV B=%d ", read_adc(4)/14.0, bar);
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	CALL SUBOPT_0x4
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41600000
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
; 0000 0074         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL _lcd_puts
; 0000 0075 
; 0000 0076         lcd_gotoxy (10,0);
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 0077              if (rezym == 0)    sprintf (string_LCD_1, "St_Vec");
	LDS  R30,_rezym
	CPI  R30,0
	BRNE _0x2E
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,13
	RJMP _0x233
; 0000 0078         else if (rezym == 1)    sprintf (string_LCD_1, "St_Ras");
_0x2E:
	LDS  R26,_rezym
	CPI  R26,LOW(0x1)
	BRNE _0x30
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,20
	RJMP _0x233
; 0000 0079         else if (rezym == 2)    sprintf (string_LCD_1, " Dinam");
_0x30:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRNE _0x32
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,27
	RJMP _0x233
; 0000 007A         else                    sprintf (string_LCD_1, "StopTX");
_0x32:
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,34
_0x233:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 007B         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 007C 
; 0000 007D         lcd_gotoxy (0,1);
; 0000 007E         sprintf (string_LCD_2, "[%2x;%2x] =", new_st_A, new_st_F);
	__POINTW1FN _0x0,41
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 007F         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 0080 
; 0000 0081         lcd_gotoxy (9,1);
	LDI  R30,LOW(9)
	CALL SUBOPT_0xE
; 0000 0082         if (mod_rock == 1)      sprintf (string_LCD_2, "+R");
	SBRS R2,7
	RJMP _0x34
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,53
	RJMP _0x234
; 0000 0083         else                    sprintf (string_LCD_2, "  ");
_0x34:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,56
_0x234:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0084         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 0085 
; 0000 0086         lcd_gotoxy (11,1);
	LDI  R30,LOW(11)
	CALL SUBOPT_0xE
; 0000 0087         if (mod_gnd == 1)       sprintf (string_LCD_2, "+G");
	SBRS R2,6
	RJMP _0x36
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,59
	RJMP _0x235
; 0000 0088         else                    sprintf (string_LCD_2, "  ");
_0x36:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,56
_0x235:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0089         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 008A 
; 0000 008B         lcd_gotoxy (13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0xE
; 0000 008C         if (mod_all_met == 1)   sprintf (string_LCD_2, "-Fe");
	SBRS R3,0
	RJMP _0x38
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,62
	RJMP _0x236
; 0000 008D         else                    sprintf (string_LCD_2, "+Al");
_0x38:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,66
_0x236:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 008E         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 008F         return;
; 0000 0090         };
_0x2D:
; 0000 0091 
; 0000 0092     if (kn2==1)
	SBRS R2,1
	RJMP _0x3A
; 0000 0093         {
; 0000 0094         lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 0095              if (rezym == 0)    sprintf (string_LCD_1, " _Static_Veckt_ ");
	LDS  R30,_rezym
	CPI  R30,0
	BRNE _0x3B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,70
	RJMP _0x237
; 0000 0096         else if (rezym == 1)    sprintf (string_LCD_1, " _Static_Rastr_ ");
_0x3B:
	LDS  R26,_rezym
	CPI  R26,LOW(0x1)
	BRNE _0x3D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,87
	RJMP _0x237
; 0000 0097         else if (rezym == 2)    sprintf (string_LCD_1, "    _Dinamic_   ");
_0x3D:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRNE _0x3F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,104
_0x237:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0098         lcd_puts (string_LCD_1);
_0x3F:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	RJMP _0x20C0009
; 0000 0099         return;
; 0000 009A         };
_0x3A:
; 0000 009B 
; 0000 009C     if (kn3==1)
	SBRS R2,2
	RJMP _0x40
; 0000 009D         {
; 0000 009E         lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
; 0000 009F         sprintf (string_LCD_2, "Barrier %d       ", bar);
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,121
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL SUBOPT_0xF
; 0000 00A0         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00A1         return;
; 0000 00A2         };
_0x40:
; 0000 00A3 
; 0000 00A4     if (kn4==1)
	SBRS R2,3
	RJMP _0x41
; 0000 00A5         {
; 0000 00A6         lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 00A7         if (rezym <2)
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRSH _0x42
; 0000 00A8                 {
; 0000 00A9                 sprintf (string_LCD_1, ">> Rock (A:f) <<");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x10
; 0000 00AA                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 00AB                 lcd_gotoxy (0,1);
; 0000 00AC                 sprintf (string_LCD_2, "  (%03.0f:%+.2f)  ", ampl, faza);
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL __PUTPARD1
	CALL SUBOPT_0x12
	CALL __PUTPARD1
	CALL SUBOPT_0x7
; 0000 00AD                 }
; 0000 00AE         else
	RJMP _0x43
_0x42:
; 0000 00AF                 {
; 0000 00B0                 sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,175
	CALL SUBOPT_0x10
; 0000 00B1                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 00B2                 lcd_gotoxy (0,1);
; 0000 00B3                 sprintf (string_LCD_2, "  %+d           ", geb);
	CALL SUBOPT_0x13
; 0000 00B4                 };
_0x43:
; 0000 00B5         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00B6         return;
; 0000 00B7         };
_0x41:
; 0000 00B8 
; 0000 00B9     if (kn5==1)
	SBRS R2,4
	RJMP _0x44
; 0000 00BA         {
; 0000 00BB         lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 00BC         if (rezym <2)
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRSH _0x45
; 0000 00BD                 {
; 0000 00BE                 sprintf (string_LCD_1, "> Ground [X;Y] <");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,209
	CALL SUBOPT_0x10
; 0000 00BF                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 00C0                 lcd_gotoxy (0,1);
; 0000 00C1                 sprintf (string_LCD_2, "  (%03.0f:%+.2f)  ", st_A, st_F);
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
	CALL __PUTPARD1
	CALL SUBOPT_0x15
	CALL __PUTPARD1
	CALL SUBOPT_0x7
; 0000 00C2                 }
; 0000 00C3         else
	RJMP _0x46
_0x45:
; 0000 00C4                 {
; 0000 00C5                 sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,175
	CALL SUBOPT_0x10
; 0000 00C6                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 00C7                 lcd_gotoxy (0,1);
; 0000 00C8                 sprintf (string_LCD_2, "  %+d           ", geb);
	CALL SUBOPT_0x13
; 0000 00C9                 };
_0x46:
; 0000 00CA         lcd_puts (string_LCD_2);
	RJMP _0x20C0008
; 0000 00CB         return;
; 0000 00CC         };
_0x44:
; 0000 00CD 
; 0000 00CE     if (kn6==1)
	SBRS R2,5
	RJMP _0x47
; 0000 00CF         {
; 0000 00D0         lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 00D1         sprintf (string_LCD_1, "S> Zero [X;Y] <D");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x10
; 0000 00D2         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 00D3         lcd_gotoxy (0,1);
; 0000 00D4         sprintf (string_LCD_2, "(%03.0f:%+.2f) [%2x;%2x]", st_zero_A, st_zero_F, din_zero_A, din_zero_F);
	__POINTW1FN _0x0,243
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
; 0000 00D5         lcd_puts (string_LCD_2);
_0x20C0008:
	LDI  R30,LOW(_string_LCD_2)
	LDI  R31,HIGH(_string_LCD_2)
_0x20C0009:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 00D6         return;
	RET
; 0000 00D7         };
_0x47:
; 0000 00D8 
; 0000 00D9     lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 00DA     if (rezym < 2)
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRLO PC+3
	JMP _0x48
; 0000 00DB         {
; 0000 00DC         if      (viz_ampl==0)    sprintf (string_LCD_1, "                ");
	TST  R11
	BRNE _0x49
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,268
	RJMP _0x238
; 0000 00DD         else if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");
_0x49:
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x4B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,285
	RJMP _0x238
; 0000 00DE         else if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
_0x4B:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x4D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,302
	RJMP _0x238
; 0000 00DF         else if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");
_0x4D:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x4F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,319
	RJMP _0x238
; 0000 00E0         else if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
_0x4F:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x51
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,336
	RJMP _0x238
; 0000 00E1         else if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");
_0x51:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x53
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,353
	RJMP _0x238
; 0000 00E2         else if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
_0x53:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x55
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,370
	RJMP _0x238
; 0000 00E3         else if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");
_0x55:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x57
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,387
	RJMP _0x238
; 0000 00E4         else if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
_0x57:
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x59
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,404
	RJMP _0x238
; 0000 00E5         else if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");
_0x59:
	LDI  R30,LOW(9)
	CP   R30,R11
	BRNE _0x5B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,421
	RJMP _0x238
; 0000 00E6         else if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
_0x5B:
	LDI  R30,LOW(10)
	CP   R30,R11
	BRNE _0x5D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,438
	RJMP _0x238
; 0000 00E7         else if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");
_0x5D:
	LDI  R30,LOW(11)
	CP   R30,R11
	BRNE _0x5F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,455
	RJMP _0x238
; 0000 00E8         else if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
_0x5F:
	LDI  R30,LOW(12)
	CP   R30,R11
	BRNE _0x61
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,472
	RJMP _0x238
; 0000 00E9         else if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");
_0x61:
	LDI  R30,LOW(13)
	CP   R30,R11
	BRNE _0x63
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,489
	RJMP _0x238
; 0000 00EA         else if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
_0x63:
	LDI  R30,LOW(14)
	CP   R30,R11
	BRNE _0x65
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,506
	RJMP _0x238
; 0000 00EB         else if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");
_0x65:
	LDI  R30,LOW(15)
	CP   R30,R11
	BRNE _0x67
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,523
	RJMP _0x238
; 0000 00EC         else if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
_0x67:
	LDI  R30,LOW(16)
	CP   R30,R11
	BRNE _0x69
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,540
	RJMP _0x238
; 0000 00ED         else if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");
_0x69:
	LDI  R30,LOW(17)
	CP   R30,R11
	BRNE _0x6B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,557
	RJMP _0x238
; 0000 00EE         else if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
_0x6B:
	LDI  R30,LOW(18)
	CP   R30,R11
	BRNE _0x6D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,574
	RJMP _0x238
; 0000 00EF         else if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");
_0x6D:
	LDI  R30,LOW(19)
	CP   R30,R11
	BRNE _0x6F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,591
	RJMP _0x238
; 0000 00F0         else if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
_0x6F:
	LDI  R30,LOW(20)
	CP   R30,R11
	BRNE _0x71
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,608
	RJMP _0x238
; 0000 00F1         else if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");
_0x71:
	LDI  R30,LOW(21)
	CP   R30,R11
	BRNE _0x73
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,625
	RJMP _0x238
; 0000 00F2         else if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
_0x73:
	LDI  R30,LOW(22)
	CP   R30,R11
	BRNE _0x75
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,642
	RJMP _0x238
; 0000 00F3         else if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");
_0x75:
	LDI  R30,LOW(23)
	CP   R30,R11
	BRNE _0x77
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,659
	RJMP _0x238
; 0000 00F4         else if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
_0x77:
	LDI  R30,LOW(24)
	CP   R30,R11
	BRNE _0x79
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,676
	RJMP _0x238
; 0000 00F5         else if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");
_0x79:
	LDI  R30,LOW(25)
	CP   R30,R11
	BRNE _0x7B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,693
	RJMP _0x238
; 0000 00F6         else if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
_0x7B:
	LDI  R30,LOW(26)
	CP   R30,R11
	BRNE _0x7D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,710
	RJMP _0x238
; 0000 00F7         else if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");
_0x7D:
	LDI  R30,LOW(27)
	CP   R30,R11
	BRNE _0x7F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,727
	RJMP _0x238
; 0000 00F8         else if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
_0x7F:
	LDI  R30,LOW(28)
	CP   R30,R11
	BRNE _0x81
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,744
	RJMP _0x238
; 0000 00F9         else if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");
_0x81:
	LDI  R30,LOW(29)
	CP   R30,R11
	BRNE _0x83
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,761
	RJMP _0x238
; 0000 00FA         else if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
_0x83:
	LDI  R30,LOW(30)
	CP   R30,R11
	BRNE _0x85
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,778
	RJMP _0x238
; 0000 00FB         else if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");
_0x85:
	LDI  R30,LOW(31)
	CP   R30,R11
	BRNE _0x87
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,795
	RJMP _0x238
; 0000 00FC         else                     sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");
_0x87:
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,812
_0x238:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 00FD         }
; 0000 00FE 
; 0000 00FF     else if (rezym == 2)
	RJMP _0x89
_0x48:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x8A
; 0000 0100         {
; 0000 0101              if (viz_ampl==1)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ ");
	LDI  R30,LOW(1)
	CP   R30,R11
	BRNE _0x8B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,829
	RJMP _0x239
; 0000 0102         else if (viz_ampl==2)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ  ");
_0x8B:
	LDI  R30,LOW(2)
	CP   R30,R11
	BRNE _0x8D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,846
	RJMP _0x239
; 0000 0103         else if (viz_ampl==3)    sprintf (string_LCD_1, "        ÿÿÿÿÿ   ");
_0x8D:
	LDI  R30,LOW(3)
	CP   R30,R11
	BRNE _0x8F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,863
	RJMP _0x239
; 0000 0104         else if (viz_ampl==4)    sprintf (string_LCD_1, "        ÿÿÿÿ    ");
_0x8F:
	LDI  R30,LOW(4)
	CP   R30,R11
	BRNE _0x91
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,880
	RJMP _0x239
; 0000 0105         else if (viz_ampl==5)    sprintf (string_LCD_1, "        ÿÿÿ     ");
_0x91:
	LDI  R30,LOW(5)
	CP   R30,R11
	BRNE _0x93
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,897
	RJMP _0x239
; 0000 0106         else if (viz_ampl==6)    sprintf (string_LCD_1, "        ÿÿ      ");
_0x93:
	LDI  R30,LOW(6)
	CP   R30,R11
	BRNE _0x95
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,914
	RJMP _0x239
; 0000 0107         else if (viz_ampl==7)    sprintf (string_LCD_1, "        ÿ       ");
_0x95:
	LDI  R30,LOW(7)
	CP   R30,R11
	BRNE _0x97
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,931
	RJMP _0x239
; 0000 0108         else if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
_0x97:
	TST  R11
	BRNE _0x99
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,268
	RJMP _0x239
; 0000 0109         else if (viz_ampl==8)    sprintf (string_LCD_1, "       ÿ        ");
_0x99:
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x9B
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,948
	RJMP _0x239
; 0000 010A         else if (viz_ampl==9)    sprintf (string_LCD_1, "      ÿÿ        ");
_0x9B:
	LDI  R30,LOW(9)
	CP   R30,R11
	BRNE _0x9D
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,965
	RJMP _0x239
; 0000 010B         else if (viz_ampl==10)   sprintf (string_LCD_1, "     ÿÿÿ        ");
_0x9D:
	LDI  R30,LOW(10)
	CP   R30,R11
	BRNE _0x9F
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,982
	RJMP _0x239
; 0000 010C         else if (viz_ampl==11)   sprintf (string_LCD_1, "    ÿÿÿÿ        ");
_0x9F:
	LDI  R30,LOW(11)
	CP   R30,R11
	BRNE _0xA1
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,999
	RJMP _0x239
; 0000 010D         else if (viz_ampl==12)   sprintf (string_LCD_1, "   ÿÿÿÿÿ        ");
_0xA1:
	LDI  R30,LOW(12)
	CP   R30,R11
	BRNE _0xA3
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1016
	RJMP _0x239
; 0000 010E         else if (viz_ampl==13)   sprintf (string_LCD_1, "  ÿÿÿÿÿÿ        ");
_0xA3:
	LDI  R30,LOW(13)
	CP   R30,R11
	BRNE _0xA5
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1033
	RJMP _0x239
; 0000 010F         else                     sprintf (string_LCD_1, " ÿÿÿÿÿÿÿ        ");
_0xA5:
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1050
_0x239:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0110         }
; 0000 0111 
; 0000 0112     else                         sprintf (string_LCD_1, "    Stop__Tx    ");
	RJMP _0xA7
_0x8A:
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1067
	CALL SUBOPT_0x10
; 0000 0113 
; 0000 0114     lcd_puts (string_LCD_1);
_0xA7:
_0x89:
	CALL SUBOPT_0x3
	CALL _lcd_puts
; 0000 0115 
; 0000 0116     lcd_gotoxy (0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xE
; 0000 0117          if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
	TST  R10
	BRNE _0xA8
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1084
	RJMP _0x23A
; 0000 0118     else if (viz_faza==1)  sprintf (string_LCD_2, "Û------II----o_O");
_0xA8:
	LDI  R30,LOW(1)
	CP   R30,R10
	BRNE _0xAA
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1101
	RJMP _0x23A
; 0000 0119     else if (viz_faza==2)  sprintf (string_LCD_2, "Û------II-----#Ü");
_0xAA:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xAC
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1118
	RJMP _0x23A
; 0000 011A     else if (viz_faza==3)  sprintf (string_LCD_2, "Û------II----#-Ü");
_0xAC:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xAE
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1135
	RJMP _0x23A
; 0000 011B     else if (viz_faza==4)  sprintf (string_LCD_2, "Û------II---#--Ü");
_0xAE:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xB0
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1152
	RJMP _0x23A
; 0000 011C     else if (viz_faza==5)  sprintf (string_LCD_2, "Û------II--#---Ü");
_0xB0:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0xB2
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1169
	RJMP _0x23A
; 0000 011D     else if (viz_faza==6)  sprintf (string_LCD_2, "Û------II-#----Ü");
_0xB2:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0xB4
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1186
	RJMP _0x23A
; 0000 011E     else if (viz_faza==7)  sprintf (string_LCD_2, "Û------II#-----Ü");
_0xB4:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0xB6
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1203
	RJMP _0x23A
; 0000 011F     else if (viz_faza==8)  sprintf (string_LCD_2, "Û------I#------Ü");
_0xB6:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0xB8
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1220
	RJMP _0x23A
; 0000 0120     else if (viz_faza==9)  sprintf (string_LCD_2, "Û------#I------Ü");
_0xB8:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0xBA
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1237
	RJMP _0x23A
; 0000 0121     else if (viz_faza==10) sprintf (string_LCD_2, "Û-----#II------Ü");
_0xBA:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0xBC
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1254
	RJMP _0x23A
; 0000 0122     else if (viz_faza==11) sprintf (string_LCD_2, "Û----#-II------Ü");
_0xBC:
	LDI  R30,LOW(11)
	CP   R30,R10
	BRNE _0xBE
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1271
	RJMP _0x23A
; 0000 0123     else if (viz_faza==12) sprintf (string_LCD_2, "Û---#--II------Ü");
_0xBE:
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0xC0
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1288
	RJMP _0x23A
; 0000 0124     else if (viz_faza==13) sprintf (string_LCD_2, "Û--#---II------Ü");
_0xC0:
	LDI  R30,LOW(13)
	CP   R30,R10
	BRNE _0xC2
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1305
	RJMP _0x23A
; 0000 0125     else if (viz_faza==14) sprintf (string_LCD_2, "Û-#----II------Ü");
_0xC2:
	LDI  R30,LOW(14)
	CP   R30,R10
	BRNE _0xC4
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1322
	RJMP _0x23A
; 0000 0126     else if (viz_faza==15) sprintf (string_LCD_2, "Û#-----II------Ü");
_0xC4:
	LDI  R30,LOW(15)
	CP   R30,R10
	BRNE _0xC6
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1339
	RJMP _0x23A
; 0000 0127     else                   sprintf (string_LCD_2, ">_<----II------Ü");
_0xC6:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1356
_0x23A:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 0128 
; 0000 0129     lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 012A 
; 0000 012B     if (rezym == 2)
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0xC8
; 0000 012C         {
; 0000 012D         if (viz_din==0)     return;
	TST  R13
	BRNE _0xC9
	RET
; 0000 012E 
; 0000 012F         sprintf (string_LCD_1, "<");
_0xC9:
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,154
	CALL SUBOPT_0x10
; 0000 0130              if (viz_din==1)    lcd_gotoxy (7,0);
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xCA
	LDI  R30,LOW(7)
	RJMP _0x23B
; 0000 0131         else if (viz_din==2)    lcd_gotoxy (6,0);
_0xCA:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xCC
	LDI  R30,LOW(6)
	RJMP _0x23B
; 0000 0132         else if (viz_din==3)    lcd_gotoxy (5,0);
_0xCC:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xCE
	LDI  R30,LOW(5)
	RJMP _0x23B
; 0000 0133         else if (viz_din==4)    lcd_gotoxy (4,0);
_0xCE:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xD0
	RJMP _0x23B
; 0000 0134         else if (viz_din==5)    lcd_gotoxy (3,0);
_0xD0:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xD2
	LDI  R30,LOW(3)
	RJMP _0x23B
; 0000 0135         else if (viz_din==6)    lcd_gotoxy (2,0);
_0xD2:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xD4
	LDI  R30,LOW(2)
	RJMP _0x23B
; 0000 0136         else if (viz_din==7)    lcd_gotoxy (1,0);
_0xD4:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xD6
	LDI  R30,LOW(1)
	RJMP _0x23B
; 0000 0137         else                    lcd_gotoxy (0,0);
_0xD6:
	LDI  R30,LOW(0)
_0x23B:
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 0138         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL _lcd_puts
; 0000 0139 
; 0000 013A         sprintf (string_LCD_2, ">");
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1373
	CALL SUBOPT_0x10
; 0000 013B              if (viz_din==1)    lcd_gotoxy (8,0);
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xD8
	LDI  R30,LOW(8)
	RJMP _0x23C
; 0000 013C         else if (viz_din==2)    lcd_gotoxy (9,0);
_0xD8:
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0xDA
	LDI  R30,LOW(9)
	RJMP _0x23C
; 0000 013D         else if (viz_din==3)    lcd_gotoxy (10,0);
_0xDA:
	LDI  R30,LOW(3)
	CP   R30,R13
	BRNE _0xDC
	LDI  R30,LOW(10)
	RJMP _0x23C
; 0000 013E         else if (viz_din==4)    lcd_gotoxy (11,0);
_0xDC:
	LDI  R30,LOW(4)
	CP   R30,R13
	BRNE _0xDE
	LDI  R30,LOW(11)
	RJMP _0x23C
; 0000 013F         else if (viz_din==5)    lcd_gotoxy (12,0);
_0xDE:
	LDI  R30,LOW(5)
	CP   R30,R13
	BRNE _0xE0
	LDI  R30,LOW(12)
	RJMP _0x23C
; 0000 0140         else if (viz_din==6)    lcd_gotoxy (13,0);
_0xE0:
	LDI  R30,LOW(6)
	CP   R30,R13
	BRNE _0xE2
	LDI  R30,LOW(13)
	RJMP _0x23C
; 0000 0141         else if (viz_din==7)    lcd_gotoxy (14,0);
_0xE2:
	LDI  R30,LOW(7)
	CP   R30,R13
	BRNE _0xE4
	LDI  R30,LOW(14)
	RJMP _0x23C
; 0000 0142         else                    lcd_gotoxy (15,0);
_0xE4:
	LDI  R30,LOW(15)
_0x23C:
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 0143         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 0144         };
_0xC8:
; 0000 0145     return;
	RET
; 0000 0146     }
;
;void zvuk ()
; 0000 0149     {
_zvuk:
; 0000 014A     }
	RET
;
;
;void new (void)
; 0000 014E     {
_new:
; 0000 014F     new_st_A = 0xFF - read_adc (0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x1A
	MOV  R7,R26
; 0000 0150     new_st_F = 0xFF - read_adc (3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x1A
	MOV  R6,R26
; 0000 0151     st_A = new_st_A;
	MOV  R30,R7
	LDI  R26,LOW(_st_A)
	LDI  R27,HIGH(_st_A)
	CALL SUBOPT_0x4
	CALL __PUTDP1
; 0000 0152     st_F = asin((float)new_st_F/(float)new_st_A);
	MOV  R30,R6
	CALL SUBOPT_0x4
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R7
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL _asin
	STS  _st_F,R30
	STS  _st_F+1,R31
	STS  _st_F+2,R22
	STS  _st_F+3,R23
; 0000 0153     din_A = 0xFF - read_adc (1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x1A
	MOV  R9,R26
; 0000 0154     din_F = 0xFF - read_adc (2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x1A
	MOV  R8,R26
; 0000 0155     return;
	RET
; 0000 0156     }
;
;float vektor_ampl (float a, float a_v, float b, float b_v)
; 0000 0159     {
_vektor_ampl:
; 0000 015A     float c;
; 0000 015B     float ab_v;
; 0000 015C     ab_v = a_v - b_v;
	SBIW R28,8
;	a -> Y+20
;	a_v -> Y+16
;	b -> Y+12
;	b_v -> Y+8
;	c -> Y+4
;	ab_v -> Y+0
	__GETD2S 8
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
; 0000 015D     c = sqrt (a*a + b*b - 2*a*b*cos(ab_v));
	CALL SUBOPT_0x1D
	__GETD2S 20
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x1D
	__GETD2N 0x40000000
	CALL __MULF12
	CALL SUBOPT_0x1F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	CALL __PUTPARD1
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
	CALL SUBOPT_0x21
	CALL __PUTPARD1
	CALL _sqrt
	CALL SUBOPT_0x22
; 0000 015E     return c;
	CALL SUBOPT_0x23
	ADIW R28,24
	RET
; 0000 015F     }
;
;float vektor_faza (float c, float a_v, float b, float b_v)
; 0000 0162     {
_vektor_faza:
; 0000 0163     float ab_v, ac_v, c_v;
; 0000 0164     ab_v = b_v - a_v;
	SBIW R28,12
;	c -> Y+24
;	a_v -> Y+20
;	b -> Y+16
;	b_v -> Y+12
;	ab_v -> Y+8
;	ac_v -> Y+4
;	c_v -> Y+0
	__GETD2S 20
	CALL SUBOPT_0x1E
	CALL __SUBF12
	__PUTD1S 8
; 0000 0165     ac_v = asin(b * sin(ab_v) / c);
	CALL __PUTPARD1
	CALL _sin
	CALL SUBOPT_0x24
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 24
	CALL SUBOPT_0x5
	CALL _asin
	CALL SUBOPT_0x22
; 0000 0166     c_v =  a_v - ac_v;
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
; 0000 0167     return c_v;
	CALL SUBOPT_0x20
	ADIW R28,28
	RET
; 0000 0168     }
;
;void main_menu(void)
; 0000 016B     {
_main_menu:
; 0000 016C     menu++;
	LDI  R30,LOW(8)
	EOR  R3,R30
; 0000 016D     while (kn1==1)
_0xE6:
	SBRS R2,0
	RJMP _0xE8
; 0000 016E         {
; 0000 016F         kn_klava();
	CALL SUBOPT_0x26
; 0000 0170         lcd_disp();
; 0000 0171         };
	RJMP _0xE6
_0xE8:
; 0000 0172     return;
	RET
; 0000 0173     }
;
;void rezymm(void)
; 0000 0176     {
_rezymm:
; 0000 0177     rezym++;
	LDS  R30,_rezym
	SUBI R30,-LOW(1)
	STS  _rezym,R30
; 0000 0178     if (rezym == 4)
	LDS  R26,_rezym
	CPI  R26,LOW(0x4)
	BRNE _0xE9
; 0000 0179         {
; 0000 017A         TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 017B         TCCR0=0x1D;
	LDI  R30,LOW(29)
	OUT  0x33,R30
; 0000 017C         rezym =0;
	LDI  R30,LOW(0)
	STS  _rezym,R30
; 0000 017D         };
_0xE9:
; 0000 017E 
; 0000 017F     while (kn2==1)
_0xEA:
	SBRS R2,1
	RJMP _0xEC
; 0000 0180         {
; 0000 0181         kn_klava();
	CALL SUBOPT_0x26
; 0000 0182         lcd_disp();
; 0000 0183         };
	RJMP _0xEA
_0xEC:
; 0000 0184     return;
	RET
; 0000 0185     }
;
;void barrier(void)
; 0000 0188     {
_barrier:
; 0000 0189     bar++;
	LDS  R30,_bar
	SUBI R30,-LOW(1)
	STS  _bar,R30
; 0000 018A     if (bar==10) bar=0;
	LDS  R26,_bar
	CPI  R26,LOW(0xA)
	BRNE _0xED
	LDI  R30,LOW(0)
	STS  _bar,R30
; 0000 018B     bar_rad = (float) bar*0.1;
_0xED:
	LDS  R30,_bar
	CALL SUBOPT_0x4
	__GETD2N 0x3DCCCCCD
	CALL __MULF12
	STS  _bar_rad,R30
	STS  _bar_rad+1,R31
	STS  _bar_rad+2,R22
	STS  _bar_rad+3,R23
; 0000 018C     while (kn3==1)
_0xEE:
	SBRS R2,2
	RJMP _0xF0
; 0000 018D         {
; 0000 018E         kn_klava();
	CALL SUBOPT_0x26
; 0000 018F         lcd_disp();
; 0000 0190         };
	RJMP _0xEE
_0xF0:
; 0000 0191     return;
	RET
; 0000 0192     }
;
;void rock(void)
; 0000 0195     {
_rock:
; 0000 0196     if (menu==1) mod_rock++;
	SBRS R3,3
	RJMP _0xF1
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 0197 
; 0000 0198     else if (rezym == 0)
	RJMP _0xF2
_0xF1:
	LDS  R30,_rezym
	CPI  R30,0
	BRNE _0xF3
; 0000 0199         {
; 0000 019A         rock_A = vektor_ampl(st_zero_A, st_zero_F, new_st_A, new_st_F);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x27
	RCALL _vektor_ampl
	STS  _rock_A,R30
	STS  _rock_A+1,R31
	STS  _rock_A+2,R22
	STS  _rock_A+3,R23
; 0000 019B         rock_F = vektor_faza(rock_A, st_zero_F, new_st_A, new_st_F);
	CALL SUBOPT_0x28
	RCALL _vektor_faza
	STS  _rock_F,R30
	STS  _rock_F+1,R31
	STS  _rock_F+2,R22
	STS  _rock_F+3,R23
; 0000 019C         }
; 0000 019D 
; 0000 019E     else if (rezym == 1)
	RJMP _0xF4
_0xF3:
	LDS  R26,_rezym
	CPI  R26,LOW(0x1)
	BRNE _0xF5
; 0000 019F         {
; 0000 01A0         rock_sekt_A = new_st_A / 8;
	MOV  R30,R7
	LSR  R30
	LSR  R30
	LSR  R30
	STS  _rock_sekt_A,R30
; 0000 01A1         rock_sekt_F = new_st_F / 8;
	MOV  R30,R6
	LSR  R30
	LSR  R30
	LSR  R30
	STS  _rock_sekt_F,R30
; 0000 01A2         rock_pos_A = new_st_A % 8;
	MOV  R30,R7
	ANDI R30,LOW(0x7)
	STS  _rock_pos_A,R30
; 0000 01A3         rock_pos_F = new_st_F % 8;
	MOV  R30,R6
	ANDI R30,LOW(0x7)
	STS  _rock_pos_F,R30
; 0000 01A4 
; 0000 01A5              if ((rock_pos_F > 4) & (rock_pos_A > 4)) rastr_st[rock_sekt_F][rock_sekt_A] |= 0x80;
	LDS  R26,_rock_pos_F
	LDI  R30,LOW(4)
	CALL SUBOPT_0x29
	BREQ _0xF6
	CALL SUBOPT_0x2A
	ORI  R30,0x80
	RJMP _0x23D
; 0000 01A6         else if ((rock_pos_F > 0) & (rock_pos_A > 4)) rastr_st[rock_sekt_F][rock_sekt_A] |= 0x40;
_0xF6:
	LDS  R26,_rock_pos_F
	LDI  R30,LOW(0)
	CALL SUBOPT_0x29
	BREQ _0xF8
	CALL SUBOPT_0x2A
	ORI  R30,0x40
	RJMP _0x23D
; 0000 01A7         else if  (rock_pos_F > 4)                     rastr_st[rock_sekt_F][rock_sekt_A] |= 0x20;
_0xF8:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0xFA
	CALL SUBOPT_0x2A
	ORI  R30,0x20
	RJMP _0x23D
; 0000 01A8         else                                          rastr_st[rock_sekt_F][rock_sekt_A] |= 0x10;
_0xFA:
	CALL SUBOPT_0x2A
	ORI  R30,0x10
_0x23D:
	ST   X,R30
; 0000 01A9         }
; 0000 01AA     else if (rezym == 2)
	RJMP _0xFC
_0xF5:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRNE _0xFD
; 0000 01AB         {
; 0000 01AC         geb++;
	INC  R5
; 0000 01AD         Frx++;
	IN   R30,0x28
	IN   R31,0x28+1
	ADIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01AE         if (Frx > Ftx) Frx = 0;
	CALL SUBOPT_0x2B
	BRSH _0xFE
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01AF         };
_0xFE:
_0xFD:
_0xFC:
_0xF4:
_0xF2:
; 0000 01B0     return;
	RET
; 0000 01B1     }
;
;void ground(void)
; 0000 01B4     {
_ground:
; 0000 01B5     if (menu==1) mod_gnd++;
	SBRS R3,3
	RJMP _0xFF
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 01B6 
; 0000 01B7     else if (rezym == 0)
	RJMP _0x100
_0xFF:
	LDS  R30,_rezym
	CPI  R30,0
	BRNE _0x101
; 0000 01B8         {
; 0000 01B9         gnd_A = vektor_ampl(st_zero_A, st_zero_F, new_st_A, new_st_F);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x27
	RCALL _vektor_ampl
	CALL SUBOPT_0x2C
; 0000 01BA         gnd_F = vektor_faza(gnd_A, st_zero_F, new_st_A, new_st_F);
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x28
	RCALL _vektor_faza
	STS  _gnd_F,R30
	STS  _gnd_F+1,R31
	STS  _gnd_F+2,R22
	STS  _gnd_F+3,R23
; 0000 01BB         }
; 0000 01BC     else if (rezym == 1)
	RJMP _0x102
_0x101:
	LDS  R26,_rezym
	CPI  R26,LOW(0x1)
	BRNE _0x103
; 0000 01BD         {
; 0000 01BE         gnd_sekt_A = (int)ampl / 8;
	CALL SUBOPT_0x2E
	CALL __DIVW21
	STS  _gnd_sekt_A,R30
; 0000 01BF         gnd_sekt_F = (int)faza / 8;
	CALL SUBOPT_0x2F
	CALL __DIVW21
	STS  _gnd_sekt_F,R30
; 0000 01C0         gnd_pos_A = (int)ampl % 8;
	CALL SUBOPT_0x2E
	CALL __MODW21
	STS  _gnd_pos_A,R30
; 0000 01C1         gnd_pos_F = (int)faza % 8;
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
; 0000 01C2 
; 0000 01C3              if ((gnd_pos_F > 4) & (gnd_pos_A > 4)) rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x08;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x31
	BREQ _0x104
	CALL SUBOPT_0x32
	ORI  R30,8
	RJMP _0x23E
; 0000 01C4         else if ((gnd_pos_F > 0) & (gnd_pos_A > 4)) rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x04;
_0x104:
	LDS  R26,_gnd_pos_F
	LDI  R30,LOW(0)
	CALL SUBOPT_0x31
	BREQ _0x106
	CALL SUBOPT_0x32
	ORI  R30,4
	RJMP _0x23E
; 0000 01C5         else if  (gnd_pos_F > 4)                    rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x02;
_0x106:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x108
	CALL SUBOPT_0x32
	ORI  R30,2
	RJMP _0x23E
; 0000 01C6         else                                        rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x01;
_0x108:
	CALL SUBOPT_0x32
	ORI  R30,1
_0x23E:
	ST   X,R30
; 0000 01C7         }
; 0000 01C8     else if (rezym == 2)
	RJMP _0x10A
_0x103:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRNE _0x10B
; 0000 01C9         {
; 0000 01CA         geb--;
	DEC  R5
; 0000 01CB         Frx--;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01CC         if (Frx == 0) Frx = Ftx;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,0
	BRNE _0x10C
	IN   R30,0x2A
	IN   R31,0x2A+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 01CD         };
_0x10C:
_0x10B:
_0x10A:
_0x102:
_0x100:
; 0000 01CE     return;
	RET
; 0000 01CF     }
;
;void zero(void)
; 0000 01D2     {
_zero:
; 0000 01D3     if (menu == 1) mod_all_met++;
	SBRS R3,3
	RJMP _0x10D
	LDI  R30,LOW(1)
	EOR  R3,R30
; 0000 01D4 
; 0000 01D5     st_zero_A = st_A;
_0x10D:
	CALL SUBOPT_0x14
	STS  _st_zero_A,R30
	STS  _st_zero_A+1,R31
	STS  _st_zero_A+2,R22
	STS  _st_zero_A+3,R23
; 0000 01D6     st_zero_F = st_F;
	CALL SUBOPT_0x15
	STS  _st_zero_F,R30
	STS  _st_zero_F+1,R31
	STS  _st_zero_F+2,R22
	STS  _st_zero_F+3,R23
; 0000 01D7     din_zero_A = din_A;
	MOV  R30,R9
	LDI  R31,0
	STS  _din_zero_A,R30
	STS  _din_zero_A+1,R31
; 0000 01D8     din_zero_F = din_F;
	MOV  R30,R8
	LDI  R31,0
	STS  _din_zero_F,R30
	STS  _din_zero_F+1,R31
; 0000 01D9     return;
	RET
; 0000 01DA     }
;
;void vizual (void)
; 0000 01DD     {
_vizual:
; 0000 01DE     if (rezym < 2)
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BRLO PC+3
	JMP _0x10E
; 0000 01DF         {
; 0000 01E0         if      (ampl> 180 )   viz_ampl=32;
	CALL SUBOPT_0x33
	__GETD1N 0x43340000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10F
	LDI  R30,LOW(32)
	MOV  R11,R30
; 0000 01E1         else if (ampl> 175 )   viz_ampl=31;
	RJMP _0x110
_0x10F:
	CALL SUBOPT_0x33
	__GETD1N 0x432F0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x111
	LDI  R30,LOW(31)
	MOV  R11,R30
; 0000 01E2         else if (ampl> 169 )   viz_ampl=30;
	RJMP _0x112
_0x111:
	CALL SUBOPT_0x33
	__GETD1N 0x43290000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x113
	LDI  R30,LOW(30)
	MOV  R11,R30
; 0000 01E3         else if (ampl> 164 )   viz_ampl=29;
	RJMP _0x114
_0x113:
	CALL SUBOPT_0x33
	__GETD1N 0x43240000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x115
	LDI  R30,LOW(29)
	MOV  R11,R30
; 0000 01E4         else if (ampl> 158 )   viz_ampl=28;
	RJMP _0x116
_0x115:
	CALL SUBOPT_0x33
	__GETD1N 0x431E0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x117
	LDI  R30,LOW(28)
	MOV  R11,R30
; 0000 01E5         else if (ampl> 153 )   viz_ampl=27;
	RJMP _0x118
_0x117:
	CALL SUBOPT_0x33
	__GETD1N 0x43190000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x119
	LDI  R30,LOW(27)
	MOV  R11,R30
; 0000 01E6         else if (ampl> 147 )   viz_ampl=26;
	RJMP _0x11A
_0x119:
	CALL SUBOPT_0x33
	__GETD1N 0x43130000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11B
	LDI  R30,LOW(26)
	MOV  R11,R30
; 0000 01E7         else if (ampl> 142 )   viz_ampl=25;
	RJMP _0x11C
_0x11B:
	CALL SUBOPT_0x33
	__GETD1N 0x430E0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11D
	LDI  R30,LOW(25)
	MOV  R11,R30
; 0000 01E8         else if (ampl> 136 )   viz_ampl=24;
	RJMP _0x11E
_0x11D:
	CALL SUBOPT_0x33
	__GETD1N 0x43080000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x11F
	LDI  R30,LOW(24)
	MOV  R11,R30
; 0000 01E9         else if (ampl> 131 )   viz_ampl=23;
	RJMP _0x120
_0x11F:
	CALL SUBOPT_0x33
	__GETD1N 0x43030000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x121
	LDI  R30,LOW(23)
	MOV  R11,R30
; 0000 01EA         else if (ampl> 125 )   viz_ampl=22;
	RJMP _0x122
_0x121:
	CALL SUBOPT_0x33
	__GETD1N 0x42FA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x123
	LDI  R30,LOW(22)
	MOV  R11,R30
; 0000 01EB         else if (ampl> 120 )   viz_ampl=21;
	RJMP _0x124
_0x123:
	CALL SUBOPT_0x33
	__GETD1N 0x42F00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x125
	LDI  R30,LOW(21)
	MOV  R11,R30
; 0000 01EC         else if (ampl> 114 )   viz_ampl=20;
	RJMP _0x126
_0x125:
	CALL SUBOPT_0x33
	__GETD1N 0x42E40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x127
	LDI  R30,LOW(20)
	MOV  R11,R30
; 0000 01ED         else if (ampl> 109 )   viz_ampl=19;
	RJMP _0x128
_0x127:
	CALL SUBOPT_0x33
	__GETD1N 0x42DA0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x129
	LDI  R30,LOW(19)
	MOV  R11,R30
; 0000 01EE         else if (ampl> 103 )   viz_ampl=18;
	RJMP _0x12A
_0x129:
	CALL SUBOPT_0x33
	__GETD1N 0x42CE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12B
	LDI  R30,LOW(18)
	MOV  R11,R30
; 0000 01EF         else if (ampl> 98  )   viz_ampl=17;
	RJMP _0x12C
_0x12B:
	CALL SUBOPT_0x33
	__GETD1N 0x42C40000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12D
	LDI  R30,LOW(17)
	MOV  R11,R30
; 0000 01F0         else if (ampl> 92  )   viz_ampl=16;
	RJMP _0x12E
_0x12D:
	CALL SUBOPT_0x33
	__GETD1N 0x42B80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x12F
	LDI  R30,LOW(16)
	MOV  R11,R30
; 0000 01F1         else if (ampl> 87  )   viz_ampl=15;
	RJMP _0x130
_0x12F:
	CALL SUBOPT_0x33
	__GETD1N 0x42AE0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x131
	LDI  R30,LOW(15)
	MOV  R11,R30
; 0000 01F2         else if (ampl> 81  )   viz_ampl=14;
	RJMP _0x132
_0x131:
	CALL SUBOPT_0x33
	__GETD1N 0x42A20000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x133
	LDI  R30,LOW(14)
	MOV  R11,R30
; 0000 01F3         else if (ampl> 76  )   viz_ampl=13;
	RJMP _0x134
_0x133:
	CALL SUBOPT_0x33
	__GETD1N 0x42980000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x135
	LDI  R30,LOW(13)
	MOV  R11,R30
; 0000 01F4         else if (ampl> 70  )   viz_ampl=12;
	RJMP _0x136
_0x135:
	CALL SUBOPT_0x33
	__GETD1N 0x428C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x137
	LDI  R30,LOW(12)
	MOV  R11,R30
; 0000 01F5         else if (ampl> 65  )   viz_ampl=11;
	RJMP _0x138
_0x137:
	CALL SUBOPT_0x33
	__GETD1N 0x42820000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x139
	LDI  R30,LOW(11)
	MOV  R11,R30
; 0000 01F6         else if (ampl> 59  )   viz_ampl=10;
	RJMP _0x13A
_0x139:
	CALL SUBOPT_0x33
	__GETD1N 0x426C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13B
	LDI  R30,LOW(10)
	MOV  R11,R30
; 0000 01F7         else if (ampl> 54  )   viz_ampl=9;
	RJMP _0x13C
_0x13B:
	CALL SUBOPT_0x33
	__GETD1N 0x42580000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13D
	LDI  R30,LOW(9)
	MOV  R11,R30
; 0000 01F8         else if (ampl> 48  )   viz_ampl=8;
	RJMP _0x13E
_0x13D:
	CALL SUBOPT_0x33
	__GETD1N 0x42400000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x13F
	LDI  R30,LOW(8)
	MOV  R11,R30
; 0000 01F9         else if (ampl> 43  )   viz_ampl=7;
	RJMP _0x140
_0x13F:
	CALL SUBOPT_0x33
	__GETD1N 0x422C0000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x141
	LDI  R30,LOW(7)
	MOV  R11,R30
; 0000 01FA         else if (ampl> 37  )   viz_ampl=6;
	RJMP _0x142
_0x141:
	CALL SUBOPT_0x33
	__GETD1N 0x42140000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x143
	LDI  R30,LOW(6)
	MOV  R11,R30
; 0000 01FB         else if (ampl> 32  )   viz_ampl=5;
	RJMP _0x144
_0x143:
	CALL SUBOPT_0x33
	__GETD1N 0x42000000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x145
	LDI  R30,LOW(5)
	MOV  R11,R30
; 0000 01FC         else if (ampl> 26  )   viz_ampl=4;
	RJMP _0x146
_0x145:
	CALL SUBOPT_0x33
	__GETD1N 0x41D00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x147
	LDI  R30,LOW(4)
	MOV  R11,R30
; 0000 01FD         else if (ampl> 21  )   viz_ampl=3;
	RJMP _0x148
_0x147:
	CALL SUBOPT_0x33
	__GETD1N 0x41A80000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x149
	LDI  R30,LOW(3)
	MOV  R11,R30
; 0000 01FE         else if (ampl> 15  )   viz_ampl=2;
	RJMP _0x14A
_0x149:
	CALL SUBOPT_0x33
	__GETD1N 0x41700000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14B
	LDI  R30,LOW(2)
	MOV  R11,R30
; 0000 01FF         else if (ampl> 10  )   viz_ampl=1;
	RJMP _0x14C
_0x14B:
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14D
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0200         else                   viz_ampl=0;
	RJMP _0x14E
_0x14D:
	CLR  R11
; 0000 0201 
; 0000 0202         if      (faza> 1.40)   viz_faza=0;
_0x14E:
_0x14C:
_0x14A:
_0x148:
_0x146:
_0x144:
_0x142:
_0x140:
_0x13E:
_0x13C:
_0x13A:
_0x138:
_0x136:
_0x134:
_0x132:
_0x130:
_0x12E:
_0x12C:
_0x12A:
_0x128:
_0x126:
_0x124:
_0x122:
_0x120:
_0x11E:
_0x11C:
_0x11A:
_0x118:
_0x116:
_0x114:
_0x112:
_0x110:
	CALL SUBOPT_0x35
	__GETD1N 0x3FB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x14F
	RJMP _0x23F
; 0000 0203         else if (faza> 1.22)   viz_faza=8;
_0x14F:
	CALL SUBOPT_0x35
	__GETD1N 0x3F9C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x151
	LDI  R30,LOW(8)
	MOV  R10,R30
; 0000 0204         else if (faza> 1.05)   viz_faza=7;
	RJMP _0x152
_0x151:
	CALL SUBOPT_0x35
	__GETD1N 0x3F866666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x153
	LDI  R30,LOW(7)
	MOV  R10,R30
; 0000 0205         else if (faza> 0.82)   viz_faza=6;
	RJMP _0x154
_0x153:
	CALL SUBOPT_0x35
	__GETD1N 0x3F51EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x155
	LDI  R30,LOW(6)
	MOV  R10,R30
; 0000 0206         else if (faza> 0.70)   viz_faza=5;
	RJMP _0x156
_0x155:
	CALL SUBOPT_0x35
	__GETD1N 0x3F333333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x157
	LDI  R30,LOW(5)
	MOV  R10,R30
; 0000 0207         else if (faza> 0.52)   viz_faza=4;
	RJMP _0x158
_0x157:
	CALL SUBOPT_0x35
	__GETD1N 0x3F051EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x159
	LDI  R30,LOW(4)
	MOV  R10,R30
; 0000 0208         else if (faza> 0.35)   viz_faza=3;
	RJMP _0x15A
_0x159:
	CALL SUBOPT_0x35
	__GETD1N 0x3EB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x15B
	LDI  R30,LOW(3)
	MOV  R10,R30
; 0000 0209         else if (faza> 0.17)   viz_faza=2;
	RJMP _0x15C
_0x15B:
	CALL SUBOPT_0x35
	__GETD1N 0x3E2E147B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x15D
	LDI  R30,LOW(2)
	MOV  R10,R30
; 0000 020A         else if (faza> 0   )   viz_faza=1;
	RJMP _0x15E
_0x15D:
	CALL SUBOPT_0x35
	CALL __CPD02
	BRGE _0x15F
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 020B         else if (faza> -0.17)  viz_faza=16;
	RJMP _0x160
_0x15F:
	CALL SUBOPT_0x35
	__GETD1N 0xBE2E147B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x161
	LDI  R30,LOW(16)
	MOV  R10,R30
; 0000 020C         else if (faza> -0.35)  viz_faza=15;
	RJMP _0x162
_0x161:
	CALL SUBOPT_0x35
	__GETD1N 0xBEB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x163
	LDI  R30,LOW(15)
	MOV  R10,R30
; 0000 020D         else if (faza> -0.52)  viz_faza=14;
	RJMP _0x164
_0x163:
	CALL SUBOPT_0x35
	__GETD1N 0xBF051EB8
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x165
	LDI  R30,LOW(14)
	MOV  R10,R30
; 0000 020E         else if (faza> -0.70)  viz_faza=13;
	RJMP _0x166
_0x165:
	CALL SUBOPT_0x35
	__GETD1N 0xBF333333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x167
	LDI  R30,LOW(13)
	MOV  R10,R30
; 0000 020F         else if (faza> -0.82)  viz_faza=12;
	RJMP _0x168
_0x167:
	CALL SUBOPT_0x35
	__GETD1N 0xBF51EB85
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x169
	LDI  R30,LOW(12)
	MOV  R10,R30
; 0000 0210         else if (faza> -1.05)  viz_faza=11;
	RJMP _0x16A
_0x169:
	CALL SUBOPT_0x35
	__GETD1N 0xBF866666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x16B
	LDI  R30,LOW(11)
	MOV  R10,R30
; 0000 0211         else if (faza> -1.22)  viz_faza=10;
	RJMP _0x16C
_0x16B:
	CALL SUBOPT_0x35
	__GETD1N 0xBF9C28F6
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x16D
	LDI  R30,LOW(10)
	MOV  R10,R30
; 0000 0212         else if (faza> -1.30)  viz_faza=9;
	RJMP _0x16E
_0x16D:
	CALL SUBOPT_0x35
	__GETD1N 0xBFA66666
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x16F
	LDI  R30,LOW(9)
	MOV  R10,R30
; 0000 0213         else if (faza> -1.40)  viz_faza=0;
	RJMP _0x170
_0x16F:
	CALL SUBOPT_0x35
	__GETD1N 0xBFB33333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x171
_0x23F:
	CLR  R10
; 0000 0214         }
_0x171:
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
; 0000 0215 
; 0000 0216     else if (rezym == 2)
	RJMP _0x172
_0x10E:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x173
; 0000 0217         {
; 0000 0218              if (din_A > din_zero_A +92 )    viz_ampl=14;
	CALL SUBOPT_0x17
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x36
	BRSH _0x174
	LDI  R30,LOW(14)
	RJMP _0x240
; 0000 0219         else if (din_A > din_zero_A +81 )    viz_ampl=13;
_0x174:
	CALL SUBOPT_0x17
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x36
	BRSH _0x176
	LDI  R30,LOW(13)
	RJMP _0x240
; 0000 021A         else if (din_A > din_zero_A +70 )    viz_ampl=12;
_0x176:
	CALL SUBOPT_0x17
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x36
	BRSH _0x178
	LDI  R30,LOW(12)
	RJMP _0x240
; 0000 021B         else if (din_A > din_zero_A +59 )    viz_ampl=11;
_0x178:
	CALL SUBOPT_0x17
	ADIW R30,59
	CALL SUBOPT_0x36
	BRSH _0x17A
	LDI  R30,LOW(11)
	RJMP _0x240
; 0000 021C         else if (din_A > din_zero_A +48 )    viz_ampl=10;
_0x17A:
	CALL SUBOPT_0x17
	ADIW R30,48
	CALL SUBOPT_0x36
	BRSH _0x17C
	LDI  R30,LOW(10)
	RJMP _0x240
; 0000 021D         else if (din_A > din_zero_A +37 )    viz_ampl=9;
_0x17C:
	CALL SUBOPT_0x17
	ADIW R30,37
	CALL SUBOPT_0x36
	BRSH _0x17E
	LDI  R30,LOW(9)
	RJMP _0x240
; 0000 021E         else if (din_A > din_zero_A +26 )    viz_ampl=8; //___
_0x17E:
	CALL SUBOPT_0x17
	ADIW R30,26
	CALL SUBOPT_0x36
	BRSH _0x180
	LDI  R30,LOW(8)
	RJMP _0x240
; 0000 021F         else if (din_A > din_zero_A     )    viz_ampl=0;
_0x180:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x36
	BRSH _0x182
	CLR  R11
; 0000 0220         else if (din_A > din_zero_A -26 )    viz_ampl=7; //___
	RJMP _0x183
_0x182:
	CALL SUBOPT_0x17
	SBIW R30,26
	CALL SUBOPT_0x36
	BRSH _0x184
	LDI  R30,LOW(7)
	RJMP _0x240
; 0000 0221         else if (din_A > din_zero_A -37 )    viz_ampl=6;
_0x184:
	CALL SUBOPT_0x17
	SBIW R30,37
	CALL SUBOPT_0x36
	BRSH _0x186
	LDI  R30,LOW(6)
	RJMP _0x240
; 0000 0222         else if (din_A > din_zero_A -48 )    viz_ampl=5;
_0x186:
	CALL SUBOPT_0x17
	SBIW R30,48
	CALL SUBOPT_0x36
	BRSH _0x188
	LDI  R30,LOW(5)
	RJMP _0x240
; 0000 0223         else if (din_A > din_zero_A -59 )    viz_ampl=4;
_0x188:
	CALL SUBOPT_0x17
	SBIW R30,59
	CALL SUBOPT_0x36
	BRSH _0x18A
	LDI  R30,LOW(4)
	RJMP _0x240
; 0000 0224         else if (din_A > din_zero_A -70 )    viz_ampl=3;
_0x18A:
	CALL SUBOPT_0x17
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x36
	BRSH _0x18C
	LDI  R30,LOW(3)
	RJMP _0x240
; 0000 0225         else if (din_A > din_zero_A -81 )    viz_ampl=2;
_0x18C:
	CALL SUBOPT_0x17
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x36
	BRSH _0x18E
	LDI  R30,LOW(2)
	RJMP _0x240
; 0000 0226         else                                 viz_ampl=1;
_0x18E:
	LDI  R30,LOW(1)
_0x240:
	MOV  R11,R30
; 0000 0227 
; 0000 0228              if (din_F > din_zero_F +92 )    viz_faza=16;
_0x183:
	CALL SUBOPT_0x19
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x37
	BRSH _0x190
	LDI  R30,LOW(16)
	RJMP _0x241
; 0000 0229         else if (din_F > din_zero_F +81 )    viz_faza=15;
_0x190:
	CALL SUBOPT_0x19
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x37
	BRSH _0x192
	LDI  R30,LOW(15)
	RJMP _0x241
; 0000 022A         else if (din_F > din_zero_F +70 )    viz_faza=14;
_0x192:
	CALL SUBOPT_0x19
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x37
	BRSH _0x194
	LDI  R30,LOW(14)
	RJMP _0x241
; 0000 022B         else if (din_F > din_zero_F +59 )    viz_faza=13;
_0x194:
	CALL SUBOPT_0x19
	ADIW R30,59
	CALL SUBOPT_0x37
	BRSH _0x196
	LDI  R30,LOW(13)
	RJMP _0x241
; 0000 022C         else if (din_F > din_zero_F +48 )    viz_faza=12;
_0x196:
	CALL SUBOPT_0x19
	ADIW R30,48
	CALL SUBOPT_0x37
	BRSH _0x198
	LDI  R30,LOW(12)
	RJMP _0x241
; 0000 022D         else if (din_F > din_zero_F +37 )    viz_faza=11;
_0x198:
	CALL SUBOPT_0x19
	ADIW R30,37
	CALL SUBOPT_0x37
	BRSH _0x19A
	LDI  R30,LOW(11)
	RJMP _0x241
; 0000 022E         else if (din_F > din_zero_F +26 )    viz_faza=10;
_0x19A:
	CALL SUBOPT_0x19
	ADIW R30,26
	CALL SUBOPT_0x37
	BRSH _0x19C
	LDI  R30,LOW(10)
	RJMP _0x241
; 0000 022F         else if (din_F > din_zero_F +15 )    viz_faza=9;
_0x19C:
	CALL SUBOPT_0x19
	ADIW R30,15
	CALL SUBOPT_0x37
	BRSH _0x19E
	LDI  R30,LOW(9)
	RJMP _0x241
; 0000 0230         else if (din_F > din_zero_F     )    viz_faza=0;
_0x19E:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x37
	BRSH _0x1A0
	CLR  R10
; 0000 0231         else if (din_F > din_zero_F -15 )    viz_faza=8;
	RJMP _0x1A1
_0x1A0:
	CALL SUBOPT_0x19
	SBIW R30,15
	CALL SUBOPT_0x37
	BRSH _0x1A2
	LDI  R30,LOW(8)
	RJMP _0x241
; 0000 0232         else if (din_F > din_zero_F -26 )    viz_faza=7;
_0x1A2:
	CALL SUBOPT_0x19
	SBIW R30,26
	CALL SUBOPT_0x37
	BRSH _0x1A4
	LDI  R30,LOW(7)
	RJMP _0x241
; 0000 0233         else if (din_F > din_zero_F -37 )    viz_faza=6;
_0x1A4:
	CALL SUBOPT_0x19
	SBIW R30,37
	CALL SUBOPT_0x37
	BRSH _0x1A6
	LDI  R30,LOW(6)
	RJMP _0x241
; 0000 0234         else if (din_F > din_zero_F -48 )    viz_faza=5;
_0x1A6:
	CALL SUBOPT_0x19
	SBIW R30,48
	CALL SUBOPT_0x37
	BRSH _0x1A8
	LDI  R30,LOW(5)
	RJMP _0x241
; 0000 0235         else if (din_F > din_zero_F -59 )    viz_faza=4;
_0x1A8:
	CALL SUBOPT_0x19
	SBIW R30,59
	CALL SUBOPT_0x37
	BRSH _0x1AA
	LDI  R30,LOW(4)
	RJMP _0x241
; 0000 0236         else if (din_F > din_zero_F -70 )    viz_faza=3;
_0x1AA:
	CALL SUBOPT_0x19
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x37
	BRSH _0x1AC
	LDI  R30,LOW(3)
	RJMP _0x241
; 0000 0237         else if (din_F > din_zero_F -81 )    viz_faza=2;
_0x1AC:
	CALL SUBOPT_0x19
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x37
	BRSH _0x1AE
	LDI  R30,LOW(2)
	RJMP _0x241
; 0000 0238         else                                 viz_faza=1;
_0x1AE:
	LDI  R30,LOW(1)
_0x241:
	MOV  R10,R30
; 0000 0239         };
_0x1A1:
_0x173:
_0x172:
; 0000 023A     return;
	RET
; 0000 023B     }
;
;void start(void)
; 0000 023E     {
_start:
; 0000 023F     // Declare your local variables here
; 0000 0240 
; 0000 0241     // Input/Output Ports initialization
; 0000 0242     // Port A initialization
; 0000 0243     PORTA=0x80;
	LDI  R30,LOW(128)
	OUT  0x1B,R30
; 0000 0244     DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0245 
; 0000 0246     // Port B initialization
; 0000 0247     PORTB=0x00;
	OUT  0x18,R30
; 0000 0248     DDRB=0x08;
	LDI  R30,LOW(8)
	OUT  0x17,R30
; 0000 0249 
; 0000 024A     // Port C initialization
; 0000 024B     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 024C     DDRC=0x00;
	OUT  0x14,R30
; 0000 024D 
; 0000 024E     // Port D initialization
; 0000 024F     PORTD=0x00;
	OUT  0x12,R30
; 0000 0250     DDRD=0xB0;
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 0251 
; 0000 0252     // Timer/Counter 0 initialization
; 0000 0253     // Clock source: System Clock
; 0000 0254     // Clock value: 16,000 kHz
; 0000 0255     // Mode: Fast PWM top=FFh
; 0000 0256     // OC0 output: Non-Inverted PWM
; 0000 0257     TCCR0=0x6D;
	LDI  R30,LOW(109)
	OUT  0x33,R30
; 0000 0258     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0259     OCR0=0x00;
	OUT  0x3C,R30
; 0000 025A 
; 0000 025B     // Timer/Counter 1 initialization
; 0000 025C     // Clock source: System Clock
; 0000 025D     // Clock value: 16384,000 kHz
; 0000 025E     // Mode: CTC top=ICR1
; 0000 025F     // OC1A output: Toggle
; 0000 0260     // OC1B output: Toggle
; 0000 0261     // Noise Canceler: Off
; 0000 0262     // Input Capture on Falling Edge
; 0000 0263     // Timer 1 Overflow Interrupt: Off
; 0000 0264     // Input Capture Interrupt: Off
; 0000 0265     // Compare A Match Interrupt: Off
; 0000 0266     // Compare B Match Interrupt: Off
; 0000 0267     TCCR1A=0x50;
	LDI  R30,LOW(80)
	OUT  0x2F,R30
; 0000 0268     TCCR1B=0x19;
	LDI  R30,LOW(25)
	OUT  0x2E,R30
; 0000 0269     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 026A     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 026B     ICR1H=0x02;
	LDI  R30,LOW(2)
	OUT  0x27,R30
; 0000 026C     ICR1L=0x85;
	LDI  R30,LOW(133)
	OUT  0x26,R30
; 0000 026D     OCR1AH=0x02;
	LDI  R30,LOW(2)
	OUT  0x2B,R30
; 0000 026E     OCR1AL=0x84;
	LDI  R30,LOW(132)
	OUT  0x2A,R30
; 0000 026F     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0270     OCR1BL=0x40;
	LDI  R30,LOW(64)
	OUT  0x28,R30
; 0000 0271 
; 0000 0272     // Timer/Counter 2 initialization
; 0000 0273     // Clock source: System Clock
; 0000 0274     // Clock value: Timer 2 Stopped
; 0000 0275     // Mode: Normal top=FFh
; 0000 0276     // OC2 output: Disconnected
; 0000 0277     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x22,R30
; 0000 0278     TCCR2=0x00;
	OUT  0x25,R30
; 0000 0279     TCNT2=0x00;
	OUT  0x24,R30
; 0000 027A     OCR2=0x00;
	OUT  0x23,R30
; 0000 027B 
; 0000 027C     // External Interrupt(s) initialization
; 0000 027D     // INT0: Off
; 0000 027E     // INT1: Off
; 0000 027F     // INT2: Off
; 0000 0280     MCUCR=0x00;
	OUT  0x35,R30
; 0000 0281     MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0282 
; 0000 0283     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0284     TIMSK=0x00;
	OUT  0x39,R30
; 0000 0285 
; 0000 0286     // Analog Comparator initialization
; 0000 0287     // Analog Comparator: Off
; 0000 0288     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0289     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 028A     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 028B 
; 0000 028C     // ADC initialization
; 0000 028D     // ADC Clock frequency: 256,000 kHz
; 0000 028E     // ADC Voltage Reference: Int., cap. on AREF
; 0000 028F     // Only the 8 most significant bits of
; 0000 0290     // the AD conversion result are used
; 0000 0291     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0292     ADCSRA=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 0293 
; 0000 0294     #asm("wdr")
	wdr
; 0000 0295     // LCD module initialization
; 0000 0296     lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0297 
; 0000 0298     lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 0299     sprintf (string_LCD_1, "FINDER ^_^ Exxus");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1375
	CALL SUBOPT_0x10
; 0000 029A     lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 029B     lcd_gotoxy (0,1);
; 0000 029C     sprintf (string_LCD_2, "v1.7.2   md4u.ru");
	__POINTW1FN _0x0,1392
	CALL SUBOPT_0x10
; 0000 029D     lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 029E     delay_ms (2);
	CALL SUBOPT_0x0
; 0000 029F 
; 0000 02A0     #asm("sei")
	sei
; 0000 02A1 
; 0000 02A2     if (Ftx_ee == 0xFFFF)
	CALL SUBOPT_0x38
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x1B0
; 0000 02A3         {
; 0000 02A4         Ftx_ee = 0x0284;
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	LDI  R30,LOW(644)
	LDI  R31,HIGH(644)
	CALL __EEPROMWRW
; 0000 02A5         ICR1H = 0x02;
	LDI  R30,LOW(2)
	OUT  0x27,R30
; 0000 02A6         ICR1L = 0x85;
	LDI  R30,LOW(133)
	OUT  0x26,R30
; 0000 02A7         };
_0x1B0:
; 0000 02A8     if (Frx_ee == 0xFFFF) Frx_ee = 0x0040;
	CALL SUBOPT_0x39
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x1B1
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL __EEPROMWRW
; 0000 02A9     Ftx = Ftx_ee;
_0x1B1:
	CALL SUBOPT_0x38
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 02AA     Frx = Frx_ee;
	CALL SUBOPT_0x39
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 02AB 
; 0000 02AC     kn_klava();
	CALL _kn_klava
; 0000 02AD     if (kn1==1) while (1)
	SBRS R2,0
	RJMP _0x1B2
_0x1B3:
; 0000 02AE                 {
; 0000 02AF                 kn_klava();
	CALL _kn_klava
; 0000 02B0                 new();
	RCALL _new
; 0000 02B1 
; 0000 02B2                 if (kn2==1)
	SBRS R2,1
	RJMP _0x1B6
; 0000 02B3                         {
; 0000 02B4                         Ftx--;
	IN   R30,0x2A
	IN   R31,0x2A+1
	SBIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	ADIW R30,1
; 0000 02B5                         ICR1L--;
	IN   R30,0x26
	SUBI R30,LOW(1)
	OUT  0x26,R30
	SUBI R30,-LOW(1)
; 0000 02B6                         };
_0x1B6:
; 0000 02B7                 if (kn3==1)
	SBRS R2,2
	RJMP _0x1B7
; 0000 02B8                         {
; 0000 02B9                         Ftx++;
	IN   R30,0x2A
	IN   R31,0x2A+1
	ADIW R30,1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	SBIW R30,1
; 0000 02BA                         ICR1L++;
	IN   R30,0x26
	SUBI R30,-LOW(1)
	OUT  0x26,R30
	SUBI R30,LOW(1)
; 0000 02BB                         };
_0x1B7:
; 0000 02BC                 if (kn4==1)
	SBRS R2,3
	RJMP _0x1B8
; 0000 02BD                         {
; 0000 02BE                         Frx++;
	IN   R30,0x28
	IN   R31,0x28+1
	ADIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
	SBIW R30,1
; 0000 02BF                         if (Frx > Ftx) Frx = 0;
	CALL SUBOPT_0x2B
	BRSH _0x1B9
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 02C0                         };
_0x1B9:
_0x1B8:
; 0000 02C1                 if (kn5==1)
	SBRS R2,4
	RJMP _0x1BA
; 0000 02C2                         {
; 0000 02C3                         Frx--;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,1
	OUT  0x28+1,R31
	OUT  0x28,R30
	ADIW R30,1
; 0000 02C4                         if (Frx == 0) Frx = Ftx;
	IN   R30,0x28
	IN   R31,0x28+1
	SBIW R30,0
	BRNE _0x1BB
	IN   R30,0x2A
	IN   R31,0x2A+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 02C5                         };
_0x1BB:
_0x1BA:
; 0000 02C6                 if (kn6==1)
	SBRS R2,5
	RJMP _0x1BC
; 0000 02C7                         {
; 0000 02C8                         lcd_gotoxy (12,0);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL SUBOPT_0x8
; 0000 02C9                         if (Ftx != Ftx_ee)
	__INWR 0,1,42
	CALL SUBOPT_0x38
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x1BD
; 0000 02CA                                 {
; 0000 02CB                                 Ftx_ee = Ftx;
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	CALL __EEPROMWRW
; 0000 02CC                                 sprintf (string_LCD_1, "Save");
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1409
	RJMP _0x242
; 0000 02CD                                 }
; 0000 02CE                         else    sprintf (string_LCD_1, "O.k.");
_0x1BD:
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1414
_0x242:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 02CF                         lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL _lcd_puts
; 0000 02D0 
; 0000 02D1                         lcd_gotoxy (12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xE
; 0000 02D2                         if  (Frx != Frx_ee)
	__INWR 0,1,40
	CALL SUBOPT_0x39
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x1BF
; 0000 02D3                                 {
; 0000 02D4                                 Frx_ee = Frx;
	IN   R30,0x28
	IN   R31,0x28+1
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	CALL __EEPROMWRW
; 0000 02D5                                 sprintf (string_LCD_2, "Save");
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1409
	RJMP _0x243
; 0000 02D6                                 }
; 0000 02D7                         else    sprintf (string_LCD_2, "O.k.");
_0x1BF:
	CALL SUBOPT_0xD
	__POINTW1FN _0x0,1414
_0x243:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
; 0000 02D8                         lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 02D9 
; 0000 02DA                         while (kn6==1) kn_klava();
_0x1C1:
	SBRS R2,5
	RJMP _0x1C3
	CALL _kn_klava
	RJMP _0x1C1
_0x1C3:
; 0000 02DB continue;
	RJMP _0x1B3
; 0000 02DC                         };
_0x1BC:
; 0000 02DD 
; 0000 02DE                 lcd_gotoxy (0,0);
	CALL SUBOPT_0x2
; 0000 02DF                 sprintf (string_LCD_1, "Freq-TX %3x [%2x]", Ftx, new_st_A);
	CALL SUBOPT_0x3
	__POINTW1FN _0x0,1419
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CALL SUBOPT_0x18
	CALL SUBOPT_0xB
	CALL SUBOPT_0x7
; 0000 02E0                 lcd_puts (string_LCD_1);
	CALL SUBOPT_0x3
	CALL SUBOPT_0xA
; 0000 02E1 
; 0000 02E2                 lcd_gotoxy (0,1);
; 0000 02E3                 sprintf (string_LCD_2, "Faza-X  %3x [%2x]", Frx, new_st_F);
	__POINTW1FN _0x0,1437
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x28
	IN   R31,0x28+1
	CALL SUBOPT_0x18
	CALL SUBOPT_0xC
; 0000 02E4                 lcd_puts (string_LCD_2);
	CALL SUBOPT_0xD
	CALL _lcd_puts
; 0000 02E5 
; 0000 02E6                 delay_ms (200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 02E7                 };
	RJMP _0x1B3
_0x1B2:
; 0000 02E8 
; 0000 02E9     if (kn6==1) PORTD.7 = 1;
	SBRC R2,5
	SBI  0x12,7
; 0000 02EA     }
	RET
;
;void main(void)
; 0000 02ED {
_main:
; 0000 02EE start ();
	RCALL _start
; 0000 02EF while (1)
_0x1C7:
; 0000 02F0     {
; 0000 02F1     // Place your code here
; 0000 02F2     kn_klava();
	CALL _kn_klava
; 0000 02F3     new();
	RCALL _new
; 0000 02F4 
; 0000 02F5     if (kn1==1) main_menu();
	SBRC R2,0
	RCALL _main_menu
; 0000 02F6     if (kn2==1) rezymm ();
	SBRC R2,1
	RCALL _rezymm
; 0000 02F7     if (kn3==1) barrier();
	SBRC R2,2
	RCALL _barrier
; 0000 02F8     if (kn4==1) rock();
	SBRC R2,3
	RCALL _rock
; 0000 02F9     if (kn5==1) ground();
	SBRC R2,4
	RCALL _ground
; 0000 02FA     if (kn6==1) zero();
	SBRC R2,5
	RCALL _zero
; 0000 02FB 
; 0000 02FC     ampl = vektor_ampl (st_zero_A, st_zero_F, new_st_A, new_st_F);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x27
	CALL SUBOPT_0x3A
; 0000 02FD     faza = vektor_faza (ampl, st_zero_F, new_st_A, new_st_F);
	CALL SUBOPT_0x28
	CALL SUBOPT_0x3B
; 0000 02FE 
; 0000 02FF     if (rezym == 0)
	LDS  R30,_rezym
	CPI  R30,0
	BREQ PC+3
	JMP _0x1D0
; 0000 0300         {
; 0000 0301         if (mod_gnd == 1)
	SBRS R2,6
	RJMP _0x1D1
; 0000 0302                 {
; 0000 0303                 if ((new_st_F <= gnd_F + bar_rad + 0.005 ) && (new_st_F >= gnd_F - bar_rad - 0.005 ))
	CALL SUBOPT_0x3C
	LDS  R26,_gnd_F
	LDS  R27,_gnd_F+1
	LDS  R24,_gnd_F+2
	LDS  R25,_gnd_F+3
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
	BREQ PC+4
	BRCS PC+3
	JMP  _0x1D3
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL SUBOPT_0x3E
	BRSH _0x1D4
_0x1D3:
	RJMP _0x1D2
_0x1D4:
; 0000 0304                     {
; 0000 0305                     gnd_A = new_st_A;
	MOV  R30,R7
	LDI  R26,LOW(_gnd_A)
	LDI  R27,HIGH(_gnd_A)
	CALL SUBOPT_0x4
	CALL __PUTDP1
; 0000 0306                     };
_0x1D2:
; 0000 0307                 ampl = vektor_ampl (gnd_A, gnd_F, new_st_A, new_st_F);
	CALL SUBOPT_0x42
	CALL SUBOPT_0x3A
; 0000 0308                 faza = vektor_faza (ampl, gnd_F, new_st_A, new_st_F);
	CALL SUBOPT_0x43
	CALL SUBOPT_0x3B
; 0000 0309                 };
_0x1D1:
; 0000 030A 
; 0000 030B         if (mod_rock == 1)
	SBRS R2,7
	RJMP _0x1D5
; 0000 030C                 {
; 0000 030D                 if ((faza <= rock_F + bar_rad + 0.005 ) && (faza >= rock_F - bar_rad - 0.005 ))
	CALL SUBOPT_0x3C
	LDS  R26,_rock_F
	LDS  R27,_rock_F+1
	LDS  R24,_rock_F+2
	LDS  R25,_rock_F+3
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x35
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x1D7
	CALL SUBOPT_0x3F
	LDS  R30,_rock_F
	LDS  R31,_rock_F+1
	LDS  R22,_rock_F+2
	LDS  R23,_rock_F+3
	CALL SUBOPT_0x41
	CALL SUBOPT_0x35
	CALL __CMPF12
	BRSH _0x1D8
_0x1D7:
	RJMP _0x1D6
_0x1D8:
; 0000 030E                     {
; 0000 030F                     ampl = 0;
	CALL SUBOPT_0x44
; 0000 0310                     faza = 1.45;
; 0000 0311                     };
_0x1D6:
; 0000 0312                 };
_0x1D5:
; 0000 0313         }
; 0000 0314 
; 0000 0315     else if (rezym == 1)
	RJMP _0x1D9
_0x1D0:
	LDS  R26,_rezym
	CPI  R26,LOW(0x1)
	BREQ PC+3
	JMP _0x1DA
; 0000 0316         {
; 0000 0317         if (mod_gnd == 1)
	SBRS R2,6
	RJMP _0x1DB
; 0000 0318                 {
; 0000 0319                 gnd_sekt_A = (int)new_st_A / 8;
	CALL SUBOPT_0x45
	STS  _gnd_sekt_A,R30
; 0000 031A                 gnd_sekt_F = (int)new_st_F / 8;
	CALL SUBOPT_0x46
	STS  _gnd_sekt_F,R30
; 0000 031B                 gnd_pos_A = (int)new_st_A % 8;
	CALL SUBOPT_0x47
	STS  _gnd_pos_A,R30
; 0000 031C                 gnd_pos_F = (int)new_st_F % 8;
	MOV  R26,R6
	CLR  R27
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x30
; 0000 031D 
; 0000 031E                      if ((gnd_pos_F > 4) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x08)) zemlq = 1;
	CPI  R26,LOW(0x5)
	BRLO _0x1DD
	LDS  R26,_gnd_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1DD
	CALL SUBOPT_0x32
	ANDI R30,LOW(0x8)
	BRNE _0x1DE
_0x1DD:
	RJMP _0x1DC
_0x1DE:
	SET
	RJMP _0x244
; 0000 031F                 else if ((gnd_pos_F > 0) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x04)) zemlq = 1;
_0x1DC:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1E1
	LDS  R26,_gnd_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1E1
	CALL SUBOPT_0x32
	ANDI R30,LOW(0x4)
	BRNE _0x1E2
_0x1E1:
	RJMP _0x1E0
_0x1E2:
	SET
	RJMP _0x244
; 0000 0320                 else if ((gnd_pos_F > 4)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x02)) zemlq = 1;
_0x1E0:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x1E5
	CALL SUBOPT_0x32
	ANDI R30,LOW(0x2)
	BRNE _0x1E6
_0x1E5:
	RJMP _0x1E4
_0x1E6:
	SET
	RJMP _0x244
; 0000 0321                 else if ((gnd_pos_F > 0)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x01)) zemlq = 1;
_0x1E4:
	LDS  R26,_gnd_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1E9
	CALL SUBOPT_0x32
	ANDI R30,LOW(0x1)
	BRNE _0x1EA
_0x1E9:
	RJMP _0x1E8
_0x1EA:
	SET
	RJMP _0x244
; 0000 0322                 else                                                                                      zemlq = 0;
_0x1E8:
	CLT
_0x244:
	BLD  R3,1
; 0000 0323 
; 0000 0324                 if (zemlq == 1) gnd_A = ampl;
	SBRS R3,1
	RJMP _0x1EC
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2C
; 0000 0325                 ampl = vektor_ampl (gnd_A, gnd_F, new_st_A, new_st_F);
_0x1EC:
	CALL SUBOPT_0x42
	CALL SUBOPT_0x3A
; 0000 0326                 faza = vektor_faza (ampl, gnd_F, new_st_A, new_st_F);
	CALL SUBOPT_0x43
	CALL SUBOPT_0x3B
; 0000 0327                 };
_0x1DB:
; 0000 0328 
; 0000 0329         if (mod_rock == 1)
	SBRS R2,7
	RJMP _0x1ED
; 0000 032A                 {
; 0000 032B                 rock_sekt_A = (int)new_st_A / 8;
	CALL SUBOPT_0x45
	STS  _rock_sekt_A,R30
; 0000 032C                 rock_sekt_F = (int)new_st_F / 8;
	CALL SUBOPT_0x46
	STS  _rock_sekt_F,R30
; 0000 032D                 rock_pos_A = (int)new_st_A % 8;
	CALL SUBOPT_0x47
	STS  _rock_pos_A,R30
; 0000 032E                 rock_pos_F = (int)new_st_F % 8;
	MOV  R26,R6
	CLR  R27
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	STS  _rock_pos_F,R30
; 0000 032F 
; 0000 0330                      if ((rock_pos_F > 4) && (rock_pos_A > 4) && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x80)) kamen = 1;
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x1EF
	LDS  R26,_rock_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1EF
	CALL SUBOPT_0x2A
	ANDI R30,LOW(0x80)
	BRNE _0x1F0
_0x1EF:
	RJMP _0x1EE
_0x1F0:
	SET
	RJMP _0x245
; 0000 0331                 else if ((rock_pos_F > 0) && (rock_pos_A > 4) && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x40)) kamen = 1;
_0x1EE:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1F3
	LDS  R26,_rock_pos_A
	CPI  R26,LOW(0x5)
	BRLO _0x1F3
	CALL SUBOPT_0x2A
	ANDI R30,LOW(0x40)
	BRNE _0x1F4
_0x1F3:
	RJMP _0x1F2
_0x1F4:
	SET
	RJMP _0x245
; 0000 0332                 else if ((rock_pos_F > 4)                     && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x20)) kamen = 1;
_0x1F2:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x5)
	BRLO _0x1F7
	CALL SUBOPT_0x2A
	ANDI R30,LOW(0x20)
	BRNE _0x1F8
_0x1F7:
	RJMP _0x1F6
_0x1F8:
	SET
	RJMP _0x245
; 0000 0333                 else if ((rock_pos_F > 0)                     && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x10)) kamen = 1;
_0x1F6:
	LDS  R26,_rock_pos_F
	CPI  R26,LOW(0x1)
	BRLO _0x1FB
	CALL SUBOPT_0x2A
	ANDI R30,LOW(0x10)
	BRNE _0x1FC
_0x1FB:
	RJMP _0x1FA
_0x1FC:
	SET
	RJMP _0x245
; 0000 0334                 else                                                                                          kamen = 0;
_0x1FA:
	CLT
_0x245:
	BLD  R3,2
; 0000 0335 
; 0000 0336                 if (kamen == 1)
	SBRS R3,2
	RJMP _0x1FE
; 0000 0337                     {
; 0000 0338                     ampl = 0;
	CALL SUBOPT_0x44
; 0000 0339                     faza = 1.45;
; 0000 033A                     };
_0x1FE:
; 0000 033B                 };
_0x1ED:
; 0000 033C         ampl = ampl - (ampl * bar_rad / 3);
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x33
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x40400000
	CALL __DIVF21
	CALL SUBOPT_0x33
	CALL SUBOPT_0x21
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
; 0000 033D         }
; 0000 033E 
; 0000 033F     else if (rezym == 2)
	RJMP _0x1FF
_0x1DA:
	LDS  R26,_rezym
	CPI  R26,LOW(0x2)
	BREQ PC+3
	JMP _0x200
; 0000 0340         {
; 0000 0341         if (din_A >= din_zero_A)
	CALL SUBOPT_0x17
	MOV  R26,R9
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x201
; 0000 0342                 {
; 0000 0343                 if (din_A >= din_max) din_max=din_A;
	CP   R9,R12
	BRLO _0x202
	MOV  R12,R9
; 0000 0344                 else
	RJMP _0x203
_0x202:
; 0000 0345                         {
; 0000 0346                         din_max--;
	DEC  R12
; 0000 0347                         din_min++;
	LDS  R30,_din_min
	SUBI R30,-LOW(1)
	STS  _din_min,R30
; 0000 0348                         };
_0x203:
; 0000 0349                 }
; 0000 034A     else
	RJMP _0x204
_0x201:
; 0000 034B                 {
; 0000 034C                 if (din_A < din_min) din_min=din_A;
	LDS  R30,_din_min
	CP   R9,R30
	BRSH _0x205
	STS  _din_min,R9
; 0000 034D                 else
	RJMP _0x206
_0x205:
; 0000 034E                         {
; 0000 034F                         din_min++;
	LDS  R30,_din_min
	SUBI R30,-LOW(1)
	STS  _din_min,R30
; 0000 0350                         din_max--;
	DEC  R12
; 0000 0351                         };
_0x206:
; 0000 0352                 };
_0x204:
; 0000 0353 
; 0000 0354         if (din_max < din_zero_A) din_max=din_zero_A;
	CALL SUBOPT_0x48
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x207
	LDS  R12,_din_zero_A
; 0000 0355         if (din_min > din_zero_A) din_max=din_zero_A;
_0x207:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x49
	BRSH _0x208
	LDS  R12,_din_zero_A
; 0000 0356 
; 0000 0357         if ((din_zero_A-din_min) < (din_max-din_zero_A))
_0x208:
	LDS  R30,_din_min
	LDS  R26,_din_zero_A
	LDS  R27,_din_zero_A+1
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	MOVW R22,R26
	CALL SUBOPT_0x48
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CP   R22,R30
	CPC  R23,R31
	BRLO PC+3
	JMP _0x209
; 0000 0358             {
; 0000 0359                  if (din_max> din_zero_A +92)   viz_din=8;
	CALL SUBOPT_0x17
	SUBI R30,LOW(-92)
	SBCI R31,HIGH(-92)
	CALL SUBOPT_0x4A
	BRSH _0x20A
	LDI  R30,LOW(8)
	MOV  R13,R30
; 0000 035A             else if (din_max> din_zero_A +81)   viz_din=7;
	RJMP _0x20B
_0x20A:
	CALL SUBOPT_0x17
	SUBI R30,LOW(-81)
	SBCI R31,HIGH(-81)
	CALL SUBOPT_0x4A
	BRSH _0x20C
	LDI  R30,LOW(7)
	MOV  R13,R30
; 0000 035B             else if (din_max> din_zero_A +70)   viz_din=6;
	RJMP _0x20D
_0x20C:
	CALL SUBOPT_0x17
	SUBI R30,LOW(-70)
	SBCI R31,HIGH(-70)
	CALL SUBOPT_0x4A
	BRSH _0x20E
	LDI  R30,LOW(6)
	MOV  R13,R30
; 0000 035C             else if (din_max> din_zero_A +59)   viz_din=5;
	RJMP _0x20F
_0x20E:
	CALL SUBOPT_0x17
	ADIW R30,59
	CALL SUBOPT_0x4A
	BRSH _0x210
	LDI  R30,LOW(5)
	MOV  R13,R30
; 0000 035D             else if (din_max> din_zero_A +48)   viz_din=4;
	RJMP _0x211
_0x210:
	CALL SUBOPT_0x17
	ADIW R30,48
	CALL SUBOPT_0x4A
	BRSH _0x212
	LDI  R30,LOW(4)
	MOV  R13,R30
; 0000 035E             else if (din_max> din_zero_A +37)   viz_din=3;
	RJMP _0x213
_0x212:
	CALL SUBOPT_0x17
	ADIW R30,37
	CALL SUBOPT_0x4A
	BRSH _0x214
	LDI  R30,LOW(3)
	MOV  R13,R30
; 0000 035F             else if (din_max> din_zero_A +26)   viz_din=2;
	RJMP _0x215
_0x214:
	CALL SUBOPT_0x17
	ADIW R30,26
	CALL SUBOPT_0x4A
	BRSH _0x216
	LDI  R30,LOW(2)
	MOV  R13,R30
; 0000 0360             else if (din_max> din_zero_A +15)   viz_din=1;
	RJMP _0x217
_0x216:
	CALL SUBOPT_0x17
	ADIW R30,15
	CALL SUBOPT_0x4A
	BRSH _0x218
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0361             else                                viz_din=0;
	RJMP _0x219
_0x218:
	CLR  R13
; 0000 0362             }
_0x219:
_0x217:
_0x215:
_0x213:
_0x211:
_0x20F:
_0x20D:
_0x20B:
; 0000 0363         else
	RJMP _0x21A
_0x209:
; 0000 0364             {
; 0000 0365                  if (din_min> din_zero_A -5 )   viz_din=0;
	CALL SUBOPT_0x17
	SBIW R30,5
	CALL SUBOPT_0x49
	BRSH _0x21B
	CLR  R13
; 0000 0366             else if (din_min> din_zero_A -15)   viz_din=1;
	RJMP _0x21C
_0x21B:
	CALL SUBOPT_0x17
	SBIW R30,15
	CALL SUBOPT_0x49
	BRSH _0x21D
	LDI  R30,LOW(1)
	RJMP _0x246
; 0000 0367             else if (din_min> din_zero_A -26)   viz_din=2;
_0x21D:
	CALL SUBOPT_0x17
	SBIW R30,26
	CALL SUBOPT_0x49
	BRSH _0x21F
	LDI  R30,LOW(2)
	RJMP _0x246
; 0000 0368             else if (din_min> din_zero_A -37)   viz_din=3;
_0x21F:
	CALL SUBOPT_0x17
	SBIW R30,37
	CALL SUBOPT_0x49
	BRSH _0x221
	LDI  R30,LOW(3)
	RJMP _0x246
; 0000 0369             else if (din_min> din_zero_A -48)   viz_din=4;
_0x221:
	CALL SUBOPT_0x17
	SBIW R30,48
	CALL SUBOPT_0x49
	BRSH _0x223
	LDI  R30,LOW(4)
	RJMP _0x246
; 0000 036A             else if (din_min> din_zero_A -59)   viz_din=5;
_0x223:
	CALL SUBOPT_0x17
	SBIW R30,59
	CALL SUBOPT_0x49
	BRSH _0x225
	LDI  R30,LOW(5)
	RJMP _0x246
; 0000 036B             else if (din_min> din_zero_A -70)   viz_din=6;
_0x225:
	CALL SUBOPT_0x17
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	CALL SUBOPT_0x49
	BRSH _0x227
	LDI  R30,LOW(6)
	RJMP _0x246
; 0000 036C             else if (din_min> din_zero_A -81)   viz_din=7;
_0x227:
	CALL SUBOPT_0x17
	SUBI R30,LOW(81)
	SBCI R31,HIGH(81)
	CALL SUBOPT_0x49
	BRSH _0x229
	LDI  R30,LOW(7)
	RJMP _0x246
; 0000 036D             else                                viz_din=8;
_0x229:
	LDI  R30,LOW(8)
_0x246:
	MOV  R13,R30
; 0000 036E             };
_0x21C:
_0x21A:
; 0000 036F         }
; 0000 0370 
; 0000 0371       else
	RJMP _0x22B
_0x200:
; 0000 0372         {
; 0000 0373         TCCR1B=0x18;
	LDI  R30,LOW(24)
	OUT  0x2E,R30
; 0000 0374         TCCR0=0x18;
	OUT  0x33,R30
; 0000 0375         PORTB.3=0;
	CBI  0x18,3
; 0000 0376         PORTD.4=0;
	CBI  0x12,4
; 0000 0377         PORTD.5=0;
	CBI  0x12,5
; 0000 0378         viz_ampl = 0;
	CLR  R11
; 0000 0379         viz_faza = 0;
	CLR  R10
; 0000 037A         };
_0x22B:
_0x1FF:
_0x1D9:
; 0000 037B 
; 0000 037C 
; 0000 037D     zvuk();
	CALL _zvuk
; 0000 037E     vizual ();
	CALL _vizual
; 0000 037F     lcd_disp();
	CALL _lcd_disp
; 0000 0380 
; 0000 0381     delay_ms (2);
	CALL SUBOPT_0x0
; 0000 0382     }
	RJMP _0x1C7
; 0000 0383 }
_0x232:
	RJMP _0x232
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
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4B
	RCALL __long_delay_G100
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G100
	RCALL __long_delay_G100
	LDI  R30,LOW(40)
	CALL SUBOPT_0x4C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4C
	LDI  R30,LOW(133)
	CALL SUBOPT_0x4C
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
	CALL SUBOPT_0x4D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x4D
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
	CALL SUBOPT_0x4E
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
	CALL SUBOPT_0x4E
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
	CALL SUBOPT_0x4F
	RJMP _0x202001C
_0x202001E:
	CALL SUBOPT_0x1E
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x4F
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x50
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020021
	CALL SUBOPT_0x4F
_0x2020022:
	CALL SUBOPT_0x50
	BRLO _0x2020024
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x50
	BRSH _0x2020028
	CALL SUBOPT_0x51
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0x4F
_0x2020025:
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x55
	CALL SUBOPT_0x54
	CALL SUBOPT_0x50
	BRLO _0x2020029
	CALL SUBOPT_0x51
	CALL SUBOPT_0x52
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	CALL SUBOPT_0x25
	CALL SUBOPT_0x56
	CALL SUBOPT_0x55
	CALL SUBOPT_0x57
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	CALL SUBOPT_0x51
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x58
	CALL SUBOPT_0x59
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5A
	CALL SUBOPT_0x51
	CALL SUBOPT_0x21
	CALL SUBOPT_0x54
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x58
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x5B
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	CALL SUBOPT_0x58
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R19
_0x202002E:
	CPI  R19,10
	BRLT _0x202002F
	CALL SUBOPT_0x5B
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x202002F:
	CALL SUBOPT_0x5B
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
	CALL SUBOPT_0x4D
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
	CALL SUBOPT_0x5C
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x5C
	RJMP _0x2020111
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
	CALL SUBOPT_0x5D
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5D
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x5F
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
	CALL SUBOPT_0x60
	CALL __GETD1P
	CALL SUBOPT_0x61
	CALL SUBOPT_0x62
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	RJMP _0x202005E
_0x202005B:
	CALL SUBOPT_0x63
	CALL __ANEGF1
	CALL SUBOPT_0x61
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x202005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x5F
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
	CALL SUBOPT_0x63
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL _ftoa
	RJMP _0x2020063
_0x2020062:
	CALL SUBOPT_0x63
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
	CALL SUBOPT_0x64
	RJMP _0x2020064
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020066
	CALL SUBOPT_0x62
	CALL SUBOPT_0x65
	CALL SUBOPT_0x64
	RJMP _0x2020067
_0x2020066:
	CPI  R30,LOW(0x70)
	BRNE _0x2020069
	CALL SUBOPT_0x62
	CALL SUBOPT_0x65
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
	CALL SUBOPT_0x66
	LDI  R17,LOW(10)
	RJMP _0x2020075
_0x2020074:
	__GETD1N 0x2710
	CALL SUBOPT_0x66
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
	CALL SUBOPT_0x66
	LDI  R17,LOW(8)
	RJMP _0x2020075
_0x202007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x66
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
	CALL SUBOPT_0x62
	CALL SUBOPT_0x60
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020112
_0x202007D:
	SBRS R16,2
	RJMP _0x202007F
	CALL SUBOPT_0x62
	CALL SUBOPT_0x65
	CALL __CWD1
	RJMP _0x2020112
_0x202007F:
	CALL SUBOPT_0x62
	CALL SUBOPT_0x65
	CLR  R22
	CLR  R23
_0x2020112:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020082
	CALL SUBOPT_0x63
	CALL __ANEGD1
	CALL SUBOPT_0x61
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
	CALL SUBOPT_0x5C
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
	CALL SUBOPT_0x67
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x5F
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
	CALL SUBOPT_0x5C
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
	CALL SUBOPT_0x68
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
	CALL SUBOPT_0x24
	__CPD2N 0x1
	BRNE _0x20200A6
_0x20200A7:
	RJMP _0x20200A9
_0x20200A6:
	CP   R20,R19
	BRSH _0x2020113
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
_0x2020113:
	LDI  R18,LOW(48)
_0x20200A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AF
	CALL SUBOPT_0x67
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AF:
_0x20200AE:
_0x20200A5:
	CALL SUBOPT_0x5C
	CPI  R21,0
	BREQ _0x20200B1
	SUBI R21,LOW(1)
_0x20200B1:
_0x20200AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x68
	CALL __MODD21U
	CALL SUBOPT_0x61
	LDD  R30,Y+20
	CALL SUBOPT_0x24
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x66
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x5F
	RJMP _0x20200B3
_0x20200B5:
_0x20200B2:
_0x20200B6:
_0x2020054:
_0x2020111:
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
	CALL SUBOPT_0x69
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
	CALL SUBOPT_0x69
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
	CALL SUBOPT_0x20
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x20
	RJMP _0x20C0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0x6A
	CALL __SUBF12
	RJMP _0x20C0004
_sin:
	CALL SUBOPT_0x6B
	__GETD1N 0x3E22F983
	CALL __MULF12
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x57
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x21
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x6F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040017
	CALL SUBOPT_0x6D
	__GETD2N 0x3F000000
	CALL __SUBF12
	CALL SUBOPT_0x6C
	LDI  R17,LOW(1)
_0x2040017:
	CALL SUBOPT_0x6E
	__GETD1N 0x3E800000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040018
	CALL SUBOPT_0x6F
	CALL __SUBF12
	CALL SUBOPT_0x6C
_0x2040018:
	CPI  R17,0
	BREQ _0x2040019
	CALL SUBOPT_0x70
_0x2040019:
	CALL SUBOPT_0x71
	__PUTD1S 1
	CALL SUBOPT_0x72
	__GETD2N 0x4226C4B1
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x422DE51D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x73
	__GETD2N 0x4104534C
	CALL __ADDF12
	CALL SUBOPT_0x6E
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
	__GETD2N 0x3FDEED11
	CALL __ADDF12
	CALL SUBOPT_0x73
	__GETD2N 0x3FA87B5E
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RJMP _0x20C0003
_cos:
	CALL SUBOPT_0x74
	__GETD1N 0x3FC90FDB
	CALL __SUBF12
	CALL __PUTPARD1
	RCALL _sin
	RJMP _0x20C0004
_xatan:
	SBIW R28,4
	CALL SUBOPT_0x23
	CALL SUBOPT_0x5A
	CALL __PUTD1S0
	CALL SUBOPT_0x20
	__GETD2N 0x40CBD065
	CALL SUBOPT_0x75
	CALL SUBOPT_0x5A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	__GETD2N 0x41296D00
	CALL __ADDF12
	CALL SUBOPT_0x74
	CALL SUBOPT_0x75
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	ADIW R28,8
	RET
_yatan:
	CALL SUBOPT_0x74
	__GETD1N 0x3ED413CD
	CALL __CMPF12
	BRSH _0x2040020
	CALL SUBOPT_0x20
	CALL __PUTPARD1
	RCALL _xatan
	RJMP _0x20C0004
_0x2040020:
	CALL SUBOPT_0x74
	__GETD1N 0x401A827A
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040021
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x5
	RCALL _xatan
	CALL SUBOPT_0x76
	RJMP _0x20C0004
_0x2040021:
	CALL SUBOPT_0x6A
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x5
	RCALL _xatan
	__GETD2N 0x3F490FDB
	CALL __ADDF12
_0x20C0004:
	ADIW R28,4
	RET
_asin:
	CALL SUBOPT_0x6B
	__GETD1N 0xBF800000
	CALL __CMPF12
	BRLO _0x2040023
	CALL SUBOPT_0x6E
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
	CALL SUBOPT_0x70
	LDI  R17,LOW(1)
_0x2040025:
	CALL SUBOPT_0x71
	__GETD2N 0x3F800000
	CALL SUBOPT_0x21
	CALL __PUTPARD1
	CALL _sqrt
	__PUTD1S 1
	CALL SUBOPT_0x6E
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2040026
	CALL SUBOPT_0x6D
	__GETD2S 1
	CALL SUBOPT_0x5
	RCALL _yatan
	CALL SUBOPT_0x76
	RJMP _0x2040035
_0x2040026:
	CALL SUBOPT_0x72
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x5
	RCALL _yatan
_0x2040035:
	__PUTD1S 1
	CPI  R17,0
	BREQ _0x2040028
	CALL SUBOPT_0x72
	CALL __ANEGF1
	RJMP _0x20C0003
_0x2040028:
	CALL SUBOPT_0x72
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
	RCALL SUBOPT_0x4E
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
	RCALL SUBOPT_0x4E
	RJMP _0x20C0002
_0x20A000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x20A000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x78
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
	RCALL SUBOPT_0x79
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x7A
	RJMP _0x20A0011
_0x20A0013:
	RCALL SUBOPT_0x7B
	CALL __ADDF12
	RCALL SUBOPT_0x77
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x7A
_0x20A0014:
	RCALL SUBOPT_0x7B
	CALL __CMPF12
	BRLO _0x20A0016
	RCALL SUBOPT_0x79
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x7A
	SUBI R17,-LOW(1)
	RJMP _0x20A0014
_0x20A0016:
	CPI  R17,0
	BRNE _0x20A0017
	RCALL SUBOPT_0x78
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x20A0018
_0x20A0017:
_0x20A0019:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20A001B
	RCALL SUBOPT_0x79
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x7A
	RCALL SUBOPT_0x7B
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x78
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x79
	RCALL SUBOPT_0x4
	CALL __MULF12
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x77
	RJMP _0x20A0019
_0x20A001B:
_0x20A0018:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0001
	RCALL SUBOPT_0x78
	LDI  R30,LOW(46)
	ST   X,R30
_0x20A001D:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x20A001F
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x77
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x78
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x77
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
_din_min:
	.BYTE 0x1
_bar:
	.BYTE 0x1
_rezym:
	.BYTE 0x1
_rastr_st:
	.BYTE 0x400
_gnd_pos_A:
	.BYTE 0x1
_gnd_pos_F:
	.BYTE 0x1
_rock_pos_A:
	.BYTE 0x1
_rock_pos_F:
	.BYTE 0x1
_gnd_sekt_A:
	.BYTE 0x1
_gnd_sekt_F:
	.BYTE 0x1
_rock_sekt_A:
	.BYTE 0x1
_rock_sekt_F:
	.BYTE 0x1
_din_zero_A:
	.BYTE 0x2
_din_zero_F:
	.BYTE 0x2
_st_zero_A:
	.BYTE 0x4
_st_zero_F:
	.BYTE 0x4
_ampl:
	.BYTE 0x4
_faza:
	.BYTE 0x4
_bar_rad:
	.BYTE 0x4
_st_A:
	.BYTE 0x4
_st_F:
	.BYTE 0x4
_gnd_A:
	.BYTE 0x4
_gnd_F:
	.BYTE 0x4
_rock_A:
	.BYTE 0x4
_rock_F:
	.BYTE 0x4

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
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 79 TIMES, CODE SIZE REDUCTION:153 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(_string_LCD_1)
	LDI  R31,HIGH(_string_LCD_1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x4:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL __DIVF21
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDS  R30,_bar
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	MOV  R30,R6
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x11:
	LDS  R30,_ampl
	LDS  R31,_ampl+1
	LDS  R22,_ampl+2
	LDS  R23,_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDS  R30,_faza
	LDS  R31,_faza+1
	LDS  R22,_faza+2
	LDS  R23,_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	__POINTW1FN _0x0,192
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL __CBD1
	CALL __PUTPARD1
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	LDS  R30,_st_A
	LDS  R31,_st_A+1
	LDS  R22,_st_A+2
	LDS  R23,_st_A+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDS  R30,_st_F
	LDS  R31,_st_F+1
	LDS  R22,_st_F+2
	LDS  R23,_st_F+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x16:
	LDS  R30,_st_zero_A
	LDS  R31,_st_zero_A+1
	LDS  R22,_st_zero_A+2
	LDS  R23,_st_zero_A+3
	CALL __PUTPARD1
	LDS  R30,_st_zero_F
	LDS  R31,_st_zero_F+1
	LDS  R22,_st_zero_F+2
	LDS  R23,_st_zero_F+3
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x17:
	LDS  R30,_din_zero_A
	LDS  R31,_din_zero_A+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x19:
	LDS  R30,_din_zero_F
	LDS  R31,_din_zero_F+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	CALL _read_adc
	LDI  R26,LOW(255)
	SUB  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL __SUBF12
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD2S 12
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x20:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x21:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CALL _kn_klava
	JMP  _lcd_disp

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x27:
	MOV  R30,R7
	RCALL SUBOPT_0x4
	CALL __PUTPARD1
	MOV  R30,R6
	RCALL SUBOPT_0x4
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x28:
	CALL __PUTPARD1
	LDS  R30,_st_zero_F
	LDS  R31,_st_zero_F+1
	LDS  R22,_st_zero_F+2
	LDS  R23,_st_zero_F+3
	CALL __PUTPARD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	CALL __GTB12U
	MOV  R0,R30
	LDS  R26,_rock_pos_A
	LDI  R30,LOW(4)
	CALL __GTB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x2A:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	IN   R30,0x28
	IN   R31,0x28+1
	MOVW R26,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	STS  _gnd_A,R30
	STS  _gnd_A+1,R31
	STS  _gnd_A+2,R22
	STS  _gnd_A+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2D:
	LDS  R30,_gnd_A
	LDS  R31,_gnd_A+1
	LDS  R22,_gnd_A+2
	LDS  R23,_gnd_A+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0x11
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2F:
	RCALL SUBOPT_0x12
	CALL __CFD1
	MOVW R26,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	CALL __MODW21
	STS  _gnd_pos_F,R30
	LDS  R26,_gnd_pos_F
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
	CALL __GTB12U
	MOV  R0,R30
	LDS  R26,_gnd_pos_A
	LDI  R30,LOW(4)
	CALL __GTB12U
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:123 WORDS
SUBOPT_0x32:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:195 WORDS
SUBOPT_0x33:
	LDS  R26,_ampl
	LDS  R27,_ampl+1
	LDS  R24,_ampl+2
	LDS  R25,_ampl+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x34:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x35:
	LDS  R26,_faza
	LDS  R27,_faza+1
	LDS  R24,_faza+2
	LDS  R25,_faza+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x36:
	MOV  R26,R9
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x37:
	MOV  R26,R8
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	LDI  R26,LOW(_Ftx_ee)
	LDI  R27,HIGH(_Ftx_ee)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(_Frx_ee)
	LDI  R27,HIGH(_Frx_ee)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x3A:
	CALL _vektor_ampl
	STS  _ampl,R30
	STS  _ampl+1,R31
	STS  _ampl+2,R22
	STS  _ampl+3,R23
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	CALL _vektor_faza
	STS  _faza,R30
	STS  _faza+1,R31
	STS  _faza+2,R22
	STS  _faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3C:
	LDS  R30,_bar_rad
	LDS  R31,_bar_rad+1
	LDS  R22,_bar_rad+2
	LDS  R23,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	CALL __ADDF12
	__GETD2N 0x3BA3D70A
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	MOV  R26,R6
	CLR  R27
	CLR  R24
	CLR  R25
	CALL __CDF2
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	LDS  R26,_bar_rad
	LDS  R27,_bar_rad+1
	LDS  R24,_bar_rad+2
	LDS  R25,_bar_rad+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x40:
	LDS  R30,_gnd_F
	LDS  R31,_gnd_F+1
	LDS  R22,_gnd_F+2
	LDS  R23,_gnd_F+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3BA3D70A
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x2D
	CALL __PUTPARD1
	RCALL SUBOPT_0x40
	CALL __PUTPARD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	CALL __PUTPARD1
	RCALL SUBOPT_0x40
	CALL __PUTPARD1
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(0)
	STS  _ampl,R30
	STS  _ampl+1,R30
	STS  _ampl+2,R30
	STS  _ampl+3,R30
	__GETD1N 0x3FB9999A
	STS  _faza,R30
	STS  _faza+1,R31
	STS  _faza+2,R22
	STS  _faza+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	MOV  R26,R7
	LDI  R27,0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	MOV  R26,R6
	LDI  R27,0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	MOV  R26,R7
	CLR  R27
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	RCALL SUBOPT_0x17
	MOV  R26,R12
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x49:
	LDS  R26,_din_min
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4A:
	MOV  R26,R12
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	CALL __long_delay_G100
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strcpyf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4F:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x34
	CALL __MULF12
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x50:
	RCALL SUBOPT_0x23
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x52:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	RCALL SUBOPT_0x34
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x56:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x58:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	RCALL SUBOPT_0x25
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5C:
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
SUBOPT_0x5D:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5E:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5F:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x60:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x62:
	RCALL SUBOPT_0x5D
	RJMP SUBOPT_0x5E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x64:
	STD  Y+14,R30
	STD  Y+14+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x60
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x66:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x67:
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
SUBOPT_0x68:
	RCALL SUBOPT_0x1B
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6A:
	RCALL SUBOPT_0x20
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6B:
	SBIW R28,4
	ST   -Y,R17
	LDI  R17,0
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6C:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6D:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6E:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	RCALL SUBOPT_0x6E
	__GETD1N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	RCALL SUBOPT_0x6D
	CALL __ANEGF1
	RJMP SUBOPT_0x6C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x6E
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x72:
	__GETD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	__GETD2S 1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x74:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x75:
	CALL __MULF12
	__GETD2N 0x414A8F4E
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	__GETD2N 0x3FC90FDB
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x77:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x78:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x79:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7A:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7B:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
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
