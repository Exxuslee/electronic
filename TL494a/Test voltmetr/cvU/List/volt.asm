
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny261
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny261
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x0A
	.EQU GPIOR1=0x0B
	.EQU GPIOR2=0x0C

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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _seg0=R3
	.DEF _seg1=R2
	.DEF _seg2=R5
	.DEF _i=R4
	.DEF _adc_data=R6
	.DEF _in=R8
	.DEF _in01=R10
	.DEF _in02=R12

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
	RJMP _adc_isr
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
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x80)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,0x00
	OUT  GPIOR0,R30
	OUT  GPIOR1,R30
	OUT  GPIOR2,R30

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x80)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

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
;Date    : 24.01.2012
;Author  : NeVaDa
;Company : MICROSOFT
;Comments:
;
;
;Chip type               : ATtiny26L
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;
;
;#include <tiny261.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define _0 PORTA.7
;#define _1 PORTA.4
;#define _2 PORTA.3
;
;#define _A PORTA.6
;#define _B PORTA.1
;#define _C PORTB.4
;#define _D PORTB.6
;#define _E PORTB.2
;#define _F PORTA.5
;#define _G PORTB.3
;#define _P PORTB.5
;#define ADC_VREF_TYPE 0x00  //0x80
;
;// Declare your global variables here
;unsigned char seg0, seg1, seg2, i;
;unsigned int adc_data;
;unsigned int in;
;unsigned int in01, in02, in03, in04;
;unsigned int in11, in12, in13, in14;
;unsigned int in21, in22, in23, in24;
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0034 {

	.CSEG
_adc_isr:
; 0000 0035 // Read the AD conversion result
; 0000 0036 adc_data=ADCW;
	__INWR 6,7,4
; 0000 0037 }
	RETI
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 003C {
_read_adc:
; 0000 003D ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 003E // Delay needed for the stabilization of the ADC input voltage
; 0000 003F delay_us(10);
	__DELAY_USB 27
; 0000 0040 #asm
; 0000 0041     in   r30,mcucr
    in   r30,mcucr
; 0000 0042     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0000 0043     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0044     out  mcucr,r30
    out  mcucr,r30
; 0000 0045     sleep
    sleep
; 0000 0046     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0000 0047     out  mcucr,r30
    out  mcucr,r30
; 0000 0048 #endasm
; 0000 0049 return adc_data;
	MOVW R30,R6
	ADIW R28,1
	RET
; 0000 004A }
;
;void codegen (char x, char y)
; 0000 004D {
_codegen:
; 0000 004E _0=1, _1=1, _2=1, _P=0;
;	x -> Y+1
;	y -> Y+0
	SBI  0x1B,7
	SBI  0x1B,4
	SBI  0x1B,3
	CBI  0x18,5
; 0000 004F 
; 0000 0050      if (y==0)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=0;
	LD   R30,Y
	CPI  R30,0
	BRNE _0xB
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x18,2
	SBI  0x1B,5
	RJMP _0x10F
; 0000 0051 else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
_0xB:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x1B
	CBI  0x1B,6
	SBI  0x1B,1
	SBI  0x18,4
	RJMP _0x110
; 0000 0052 else if (y==2)  _A=1,_B=1,_C=0,_D=1,_E=1,_F=0,_G=1;
_0x1B:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x2B
	RCALL SUBOPT_0x0
	CBI  0x18,4
	SBI  0x18,6
	SBI  0x18,2
	CBI  0x1B,5
	SBI  0x18,3
; 0000 0053 else if (y==3)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=0,_G=1;
	RJMP _0x3A
_0x2B:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x3B
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CBI  0x18,2
	CBI  0x1B,5
	SBI  0x18,3
; 0000 0054 else if (y==4)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=1,_G=1;
	RJMP _0x4A
_0x3B:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x4B
	CBI  0x1B,6
	SBI  0x1B,1
	SBI  0x18,4
	CBI  0x18,6
	RCALL SUBOPT_0x2
; 0000 0055 else if (y==5)  _A=1,_B=0,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x5A
_0x4B:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x5B
	SBI  0x1B,6
	CBI  0x1B,1
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 0056 else if (y==6)  _A=1,_B=0,_C=1,_D=1,_E=1,_F=1,_G=1;
	RJMP _0x6A
_0x5B:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x6B
	SBI  0x1B,6
	CBI  0x1B,1
	RCALL SUBOPT_0x1
	SBI  0x18,2
	SBI  0x1B,5
	SBI  0x18,3
; 0000 0057 else if (y==7)  _A=1,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
	RJMP _0x7A
_0x6B:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x7B
	RCALL SUBOPT_0x0
	SBI  0x18,4
	RJMP _0x110
; 0000 0058 else if (y==8)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=1;
_0x7B:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x8B
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x18,2
	SBI  0x1B,5
	SBI  0x18,3
; 0000 0059 else if (y==9)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x9A
_0x8B:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x9B
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 005A else            _A=0,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xAA
_0x9B:
	CBI  0x1B,6
	CBI  0x1B,1
	CBI  0x18,4
_0x110:
	CBI  0x18,6
	CBI  0x18,2
	CBI  0x1B,5
_0x10F:
	CBI  0x18,3
; 0000 005B 
; 0000 005C if (x==0) _0=0, _1=1, _2=1, _P=0;
_0xAA:
_0x9A:
_0x7A:
_0x6A:
_0x5A:
_0x4A:
_0x3A:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0xB9
	CBI  0x1B,7
	SBI  0x1B,4
	SBI  0x1B,3
	CBI  0x18,5
; 0000 005D if (x==1) _0=1, _1=0, _2=1, _P=1;
_0xB9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0xC2
	SBI  0x1B,7
	CBI  0x1B,4
	SBI  0x1B,3
	SBI  0x18,5
; 0000 005E if (x==2) _0=1, _1=1, _2=0, _P=0;
_0xC2:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0xCB
	SBI  0x1B,7
	SBI  0x1B,4
	CBI  0x1B,3
	CBI  0x18,5
; 0000 005F 
; 0000 0060 delay_us(100);
_0xCB:
	__DELAY_USW 200
; 0000 0061 
; 0000 0062 }
	RJMP _0x2000001
;
;void read()
; 0000 0065 {
_read:
; 0000 0066 in01 = in02;
	MOVW R10,R12
; 0000 0067 in02 = in03;
	__GETWRMN 12,13,0,_in03
; 0000 0068 in03 = in04;
	LDS  R30,_in04
	LDS  R31,_in04+1
	STS  _in03,R30
	STS  _in03+1,R31
; 0000 0069 in04 = in11;
	LDS  R30,_in11
	LDS  R31,_in11+1
	STS  _in04,R30
	STS  _in04+1,R31
; 0000 006A in11 = in12;
	LDS  R30,_in12
	LDS  R31,_in12+1
	STS  _in11,R30
	STS  _in11+1,R31
; 0000 006B in12 = in13;
	LDS  R30,_in13
	LDS  R31,_in13+1
	STS  _in12,R30
	STS  _in12+1,R31
; 0000 006C in13 = in14;
	LDS  R30,_in14
	LDS  R31,_in14+1
	STS  _in13,R30
	STS  _in13+1,R31
; 0000 006D in14 = in21;
	LDS  R30,_in21
	LDS  R31,_in21+1
	STS  _in14,R30
	STS  _in14+1,R31
; 0000 006E in21 = in22;
	LDS  R30,_in22
	LDS  R31,_in22+1
	STS  _in21,R30
	STS  _in21+1,R31
; 0000 006F in22 = in23;
	LDS  R30,_in23
	LDS  R31,_in23+1
	STS  _in22,R30
	STS  _in22+1,R31
; 0000 0070 in23 = in24;
	LDS  R30,_in24
	LDS  R31,_in24+1
	STS  _in23,R30
	STS  _in23+1,R31
; 0000 0071 in24 = read_adc(0);
	RCALL SUBOPT_0x3
	RCALL _read_adc
	STS  _in24,R30
	STS  _in24+1,R31
; 0000 0072 in = (in01+in02+in03+in04+in11+in12+in13+in14+in21+in22+in23+in24)/35;  //1024bit=50,0Volt
	MOVW R30,R12
	ADD  R30,R10
	ADC  R31,R11
	LDS  R26,_in03
	LDS  R27,_in03+1
	RCALL SUBOPT_0x4
	LDS  R26,_in04
	LDS  R27,_in04+1
	RCALL SUBOPT_0x4
	LDS  R26,_in11
	LDS  R27,_in11+1
	RCALL SUBOPT_0x4
	LDS  R26,_in12
	LDS  R27,_in12+1
	RCALL SUBOPT_0x4
	LDS  R26,_in13
	LDS  R27,_in13+1
	RCALL SUBOPT_0x4
	LDS  R26,_in14
	LDS  R27,_in14+1
	RCALL SUBOPT_0x4
	LDS  R26,_in21
	LDS  R27,_in21+1
	RCALL SUBOPT_0x4
	LDS  R26,_in22
	LDS  R27,_in22+1
	RCALL SUBOPT_0x4
	LDS  R26,_in23
	LDS  R27,_in23+1
	RCALL SUBOPT_0x4
	LDS  R26,_in24
	LDS  R27,_in24+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	RCALL __DIVW21U
	MOVW R8,R30
; 0000 0073 }
	RET
;
;void preobr(unsigned int x)
; 0000 0076 {
_preobr:
; 0000 0077      if (x >= 900)   seg0=9, x=x - 900;
;	x -> Y+0
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x384)
	LDI  R30,HIGH(0x384)
	CPC  R27,R30
	BRLO _0xD4
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(900)
	SBCI R31,HIGH(900)
	RCALL SUBOPT_0x7
; 0000 0078 else if (x >= 800)   seg0=8, x=x - 800;
	RJMP _0xD5
_0xD4:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x320)
	LDI  R30,HIGH(0x320)
	CPC  R27,R30
	BRLO _0xD6
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(800)
	SBCI R31,HIGH(800)
	RCALL SUBOPT_0x7
; 0000 0079 else if (x >= 700)   seg0=7, x=x - 700;
	RJMP _0xD7
_0xD6:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x2BC)
	LDI  R30,HIGH(0x2BC)
	CPC  R27,R30
	BRLO _0xD8
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(700)
	SBCI R31,HIGH(700)
	RCALL SUBOPT_0x7
; 0000 007A else if (x >= 600)   seg0=6, x=x - 600;
	RJMP _0xD9
_0xD8:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x258)
	LDI  R30,HIGH(0x258)
	CPC  R27,R30
	BRLO _0xDA
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(600)
	SBCI R31,HIGH(600)
	RCALL SUBOPT_0x7
; 0000 007B else if (x >= 500)   seg0=5, x=x - 500;
	RJMP _0xDB
_0xDA:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRLO _0xDC
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(500)
	SBCI R31,HIGH(500)
	RCALL SUBOPT_0x7
; 0000 007C else if (x >= 400)   seg0=4, x=x - 400;
	RJMP _0xDD
_0xDC:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x190)
	LDI  R30,HIGH(0x190)
	CPC  R27,R30
	BRLO _0xDE
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(400)
	SBCI R31,HIGH(400)
	RCALL SUBOPT_0x7
; 0000 007D else if (x >= 300)   seg0=3, x=x - 300;
	RJMP _0xDF
_0xDE:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x12C)
	LDI  R30,HIGH(0x12C)
	CPC  R27,R30
	BRLO _0xE0
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(300)
	SBCI R31,HIGH(300)
	RCALL SUBOPT_0x7
; 0000 007E else if (x >= 200)   seg0=2, x=x - 200;
	RJMP _0xE1
_0xE0:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRLO _0xE2
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(200)
	SBCI R31,HIGH(200)
	RCALL SUBOPT_0x7
; 0000 007F else if (x >= 100)   seg0=1, x=x - 100;
	RJMP _0xE3
_0xE2:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0xE4
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x6
	SUBI R30,LOW(100)
	SBCI R31,HIGH(100)
	RCALL SUBOPT_0x7
; 0000 0080 else                 seg0=10;
	RJMP _0xE5
_0xE4:
	LDI  R30,LOW(10)
	MOV  R3,R30
; 0000 0081 
; 0000 0082 if      (x >= 90)    seg1=9, x=x-90;
_0xE5:
_0xE3:
_0xE1:
_0xDF:
_0xDD:
_0xDB:
_0xD9:
_0xD7:
_0xD5:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x5A)
	LDI  R30,HIGH(0x5A)
	CPC  R27,R30
	BRLO _0xE6
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x8
	SUBI R30,LOW(90)
	SBCI R31,HIGH(90)
	RCALL SUBOPT_0x7
; 0000 0083 else if (x >= 80)    seg1=8, x=x-80;
	RJMP _0xE7
_0xE6:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x50)
	LDI  R30,HIGH(0x50)
	CPC  R27,R30
	BRLO _0xE8
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x8
	SUBI R30,LOW(80)
	SBCI R31,HIGH(80)
	RCALL SUBOPT_0x7
; 0000 0084 else if (x >= 70)    seg1=7, x=x-70;
	RJMP _0xE9
_0xE8:
	RCALL SUBOPT_0x5
	CPI  R26,LOW(0x46)
	LDI  R30,HIGH(0x46)
	CPC  R27,R30
	BRLO _0xEA
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x8
	SUBI R30,LOW(70)
	SBCI R31,HIGH(70)
	RCALL SUBOPT_0x7
; 0000 0085 else if (x >= 60)    seg1=6, x=x-60;
	RJMP _0xEB
_0xEA:
	RCALL SUBOPT_0x5
	SBIW R26,60
	BRLO _0xEC
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x8
	SBIW R30,60
	RCALL SUBOPT_0x7
; 0000 0086 else if (x >= 50)    seg1=5, x=x-50;
	RJMP _0xED
_0xEC:
	RCALL SUBOPT_0x5
	SBIW R26,50
	BRLO _0xEE
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x8
	SBIW R30,50
	RCALL SUBOPT_0x7
; 0000 0087 else if (x >= 40)    seg1=4, x=x-40;
	RJMP _0xEF
_0xEE:
	RCALL SUBOPT_0x5
	SBIW R26,40
	BRLO _0xF0
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x8
	SBIW R30,40
	RCALL SUBOPT_0x7
; 0000 0088 else if (x >= 30)    seg1=3, x=x-30;
	RJMP _0xF1
_0xF0:
	RCALL SUBOPT_0x5
	SBIW R26,30
	BRLO _0xF2
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x8
	SBIW R30,30
	RCALL SUBOPT_0x7
; 0000 0089 else if (x >= 20)    seg1=2, x=x-20;
	RJMP _0xF3
_0xF2:
	RCALL SUBOPT_0x5
	SBIW R26,20
	BRLO _0xF4
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x8
	SBIW R30,20
	RCALL SUBOPT_0x7
; 0000 008A else if (x >= 10)    seg1=1, x=x-10;
	RJMP _0xF5
_0xF4:
	RCALL SUBOPT_0x5
	SBIW R26,10
	BRLO _0xF6
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x8
	SBIW R30,10
	RCALL SUBOPT_0x7
; 0000 008B else                 seg1=0;
	RJMP _0xF7
_0xF6:
	CLR  R2
; 0000 008C 
; 0000 008D if      (x == 9)     seg2=9;
_0xF7:
_0xF5:
_0xF3:
_0xF1:
_0xEF:
_0xED:
_0xEB:
_0xE9:
_0xE7:
	RCALL SUBOPT_0x5
	SBIW R26,9
	BRNE _0xF8
	LDI  R30,LOW(9)
	MOV  R5,R30
; 0000 008E else if (x == 8)     seg2=8;
	RJMP _0xF9
_0xF8:
	RCALL SUBOPT_0x5
	SBIW R26,8
	BRNE _0xFA
	LDI  R30,LOW(8)
	MOV  R5,R30
; 0000 008F else if (x == 7)     seg2=7;
	RJMP _0xFB
_0xFA:
	RCALL SUBOPT_0x5
	SBIW R26,7
	BRNE _0xFC
	LDI  R30,LOW(7)
	MOV  R5,R30
; 0000 0090 else if (x == 6)     seg2=6;
	RJMP _0xFD
_0xFC:
	RCALL SUBOPT_0x5
	SBIW R26,6
	BRNE _0xFE
	LDI  R30,LOW(6)
	MOV  R5,R30
; 0000 0091 else if (x == 5)     seg2=5;
	RJMP _0xFF
_0xFE:
	RCALL SUBOPT_0x5
	SBIW R26,5
	BRNE _0x100
	LDI  R30,LOW(5)
	MOV  R5,R30
; 0000 0092 else if (x == 4)     seg2=4;
	RJMP _0x101
_0x100:
	RCALL SUBOPT_0x5
	SBIW R26,4
	BRNE _0x102
	LDI  R30,LOW(4)
	MOV  R5,R30
; 0000 0093 else if (x == 3)     seg2=3;
	RJMP _0x103
_0x102:
	RCALL SUBOPT_0x5
	SBIW R26,3
	BRNE _0x104
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0094 else if (x == 2)     seg2=2;
	RJMP _0x105
_0x104:
	RCALL SUBOPT_0x5
	SBIW R26,2
	BRNE _0x106
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0095 else if (x == 1)     seg2=1;
	RJMP _0x107
_0x106:
	RCALL SUBOPT_0x5
	SBIW R26,1
	BRNE _0x108
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0096 else                 seg2=0;
	RJMP _0x109
_0x108:
	CLR  R5
; 0000 0097 }
_0x109:
_0x107:
_0x105:
_0x103:
_0x101:
_0xFF:
_0xFD:
_0xFB:
_0xF9:
_0x2000001:
	ADIW R28,2
	RET
;
;void start()
; 0000 009A {
_start:
; 0000 009B // Input/Output Ports initialization
; 0000 009C // Port A initialization
; 0000 009D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In
; 0000 009E // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=T
; 0000 009F PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00A0 DDRA=0xFA;
	LDI  R30,LOW(250)
	OUT  0x1A,R30
; 0000 00A1 
; 0000 00A2 // Port B initialization
; 0000 00A3 // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 00A4 // State7=T State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 00A5 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00A6 DDRB=0x7C;
	LDI  R30,LOW(124)
	OUT  0x17,R30
; 0000 00A7 
; 0000 00A8 // Timer/Counter 0 initialization
; 0000 00A9 // Clock source: System Clock
; 0000 00AA // Clock value: Timer 0 Stopped
; 0000 00AB // Mode: 8bit top=0xFF
; 0000 00AC TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00AD TCCR0B=0x00;
	OUT  0x33,R30
; 0000 00AE TCNT0H=0x00;
	OUT  0x14,R30
; 0000 00AF TCNT0L=0x00;
	OUT  0x32,R30
; 0000 00B0 OCR0A=0x00;
	OUT  0x13,R30
; 0000 00B1 OCR0B=0x00;
	OUT  0x12,R30
; 0000 00B2 
; 0000 00B3 // Timer/Counter 1 initialization
; 0000 00B4 // Clock source: System Clock
; 0000 00B5 // Clock value: Timer1 Stopped
; 0000 00B6 // Mode: Normal top=FFh
; 0000 00B7 // OC1A output: Disconnected
; 0000 00B8 // OC1B output: Disconnected
; 0000 00B9 // Timer1 Overflow Interrupt: Off
; 0000 00BA // Compare A Match Interrupt: Off
; 0000 00BB // Compare B Match Interrupt: Off
; 0000 00BC PLLCSR=0x00;
	OUT  0x29,R30
; 0000 00BD 
; 0000 00BE TCCR1A=0x00;
	OUT  0x30,R30
; 0000 00BF TCCR1B=0x00;
	OUT  0x2F,R30
; 0000 00C0 TCNT1=0x00;
	OUT  0x2E,R30
; 0000 00C1 OCR1A=0x00;
	OUT  0x2D,R30
; 0000 00C2 OCR1B=0x00;
	OUT  0x2C,R30
; 0000 00C3 OCR1C=0x00;
	OUT  0x2B,R30
; 0000 00C4 
; 0000 00C5 // External Interrupt(s) initialization
; 0000 00C6 // INT0: Off
; 0000 00C7 // Interrupt on any change on pins PA3, PA6, PA7 and PB4-7: Off
; 0000 00C8 // Interrupt on any change on pins PB0-3: Off
; 0000 00C9 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 00CA MCUCR=0x00;
	OUT  0x35,R30
; 0000 00CB 
; 0000 00CC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00CD TIMSK=0x00;
	OUT  0x39,R30
; 0000 00CE 
; 0000 00CF // Universal Serial Interface initialization
; 0000 00D0 // Mode: Disabled
; 0000 00D1 // Clock source: Register & Counter=no clk.
; 0000 00D2 // USI Counter Overflow Interrupt: Off
; 0000 00D3 USICR=0x00;
	OUT  0xD,R30
; 0000 00D4 
; 0000 00D5 // Analog Comparator initialization
; 0000 00D6 // Analog Comparator: Off
; 0000 00D7 ACSRA=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D8 // Hysterezis level: 0 mV
; 0000 00D9 ACSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x9,R30
; 0000 00DA DIDR1=0x00;
	OUT  0x2,R30
; 0000 00DB 
; 0000 00DC // ADC initialization
; 0000 00DD // ADC Clock frequency: 125,000 kHz
; 0000 00DE // ADC Voltage Reference: AVCC pin
; 0000 00DF // ADC Bipolar Input Mode: Off
; 0000 00E0 // ADC Auto Trigger Source: None
; 0000 00E1 // Digital input buffers on ADC0: On, ADC1: Off, ADC2: Off, Aref: Off
; 0000 00E2 // ADC3: Off, ADC4: Off, ADC5: Off, ADC6: Off
; 0000 00E3 DIDR0=0x00;
	OUT  0x1,R30
; 0000 00E4 // Digital input buffers on ADC7: Off, ADC8: Off, ADC9: Off, ADC10: Off
; 0000 00E5 DIDR1=0x00;
	OUT  0x2,R30
; 0000 00E6 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00E7 ADCSRA=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 00E8 ADCSRB&=0x7F;
	CBI  0x3,7
; 0000 00E9 ADCSRB|=0x00 | ((ADC_VREF_TYPE & 0x100) >> 4);
	IN   R30,0x3
	OUT  0x3,R30
; 0000 00EA 
; 0000 00EB // Global enable interrupts
; 0000 00EC #asm("sei")
	sei
; 0000 00ED }
	RET
;
;void main(void)
; 0000 00F0 {
_main:
; 0000 00F1 // Declare your local variables here
; 0000 00F2 
; 0000 00F3 start();
	RCALL _start
; 0000 00F4 
; 0000 00F5 while (1)
_0x10A:
; 0000 00F6       {
; 0000 00F7       // Place your code here
; 0000 00F8       read();
	RCALL _read
; 0000 00F9       codegen(1,seg1);
	RCALL SUBOPT_0x9
; 0000 00FA       codegen(0,seg0);
	RCALL SUBOPT_0x3
	ST   -Y,R3
	RCALL _codegen
; 0000 00FB       codegen(2,seg2);
	RCALL SUBOPT_0xA
; 0000 00FC 
; 0000 00FD       codegen(1,seg1);
	RCALL SUBOPT_0x9
; 0000 00FE       codegen(2,seg2);
	RCALL SUBOPT_0xA
; 0000 00FF       codegen(0,seg0);
	RCALL SUBOPT_0x3
	ST   -Y,R3
	RCALL _codegen
; 0000 0100 
; 0000 0101       codegen(0,seg0);
	RCALL SUBOPT_0x3
	ST   -Y,R3
	RCALL _codegen
; 0000 0102       codegen(1,seg1);
	RCALL SUBOPT_0x9
; 0000 0103       codegen(2,seg2);
	RCALL SUBOPT_0xA
; 0000 0104       i++;
	INC  R4
; 0000 0105       if (i>=25) i=0, preobr(in);
	LDI  R30,LOW(25)
	CP   R4,R30
	BRLO _0x10D
	CLR  R4
	ST   -Y,R9
	ST   -Y,R8
	RCALL _preobr
; 0000 0106       };
_0x10D:
	RJMP _0x10A
; 0000 0107 }
_0x10E:
	RJMP _0x10E

	.DSEG
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	SBI  0x1B,6
	SBI  0x1B,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SBI  0x18,4
	SBI  0x18,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	CBI  0x18,2
	SBI  0x1B,5
	SBI  0x18,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x5:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x6:
	MOV  R3,R30
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7:
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x8:
	MOV  R2,R30
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R2
	RJMP _codegen

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R5
	RJMP _codegen


	.CSEG
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

;END OF CODE MARKER
__END_OF_CODE:
