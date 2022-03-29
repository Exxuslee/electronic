
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny26L
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 16 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Smart register allocation     : Off
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny26L
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
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	MOV  R26,R28
	MOV  R27,R29
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
	.DEF _seg0=R4
	.DEF _seg1=R5
	.DEF _seg2=R6
	.DEF _i=R7
	.DEF _j=R8
	.DEF _adc_data=R9
	.DEF _in=R11
	.DEF _in01=R13

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

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0xDF)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x70)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

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
;#include <tiny26.h>
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
;
;
;// Declare your global variables here
;unsigned char seg0, seg1, seg2, i, j;
;unsigned int adc_data;
;unsigned int in;
;unsigned int in01, in02, in03, in04;
;unsigned int in11, in12, in13, in14;
;unsigned int in21, in22, in23, in24;
;#define ADC_VREF_TYPE 0x80
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0035 {

	.CSEG
_adc_isr:
; 0000 0036 // Read the AD conversion result
; 0000 0037 adc_data=ADCW;
	__INWR 9,10,4
; 0000 0038 }
	RETI
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 003D {
_read_adc:
; 0000 003E ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x80
	OUT  0x7,R30
; 0000 003F // Delay needed for the stabilization of the ADC input voltage
; 0000 0040 delay_us(10);
	__DELAY_USB 27
; 0000 0041 #asm
; 0000 0042     in   r30,mcucr
    in   r30,mcucr
; 0000 0043     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0000 0044     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0045     out  mcucr,r30
    out  mcucr,r30
; 0000 0046     sleep
    sleep
; 0000 0047     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0000 0048     out  mcucr,r30
    out  mcucr,r30
; 0000 0049 #endasm
; 0000 004A return adc_data;
	__GETW1R 9,10
	ADIW R28,1
	RET
; 0000 004B }
;
;void codegen (char x, char y)
; 0000 004E {
_codegen:
; 0000 004F      if (y==0)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=0;
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x18,2
	SBI  0x1B,5
	RJMP _0x11B
; 0000 0050 else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x13
	CBI  0x1B,6
	SBI  0x1B,1
	SBI  0x18,4
	RJMP _0x11C
; 0000 0051 else if (y==2)  _A=1,_B=1,_C=0,_D=1,_E=1,_F=0,_G=1;
_0x13:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x23
	RCALL SUBOPT_0x0
	CBI  0x18,4
	SBI  0x18,6
	SBI  0x18,2
	CBI  0x1B,5
	SBI  0x18,3
; 0000 0052 else if (y==3)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=0,_G=1;
	RJMP _0x32
_0x23:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x33
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CBI  0x18,2
	CBI  0x1B,5
	SBI  0x18,3
; 0000 0053 else if (y==4)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=1,_G=1;
	RJMP _0x42
_0x33:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x43
	CBI  0x1B,6
	SBI  0x1B,1
	SBI  0x18,4
	CBI  0x18,6
	RCALL SUBOPT_0x2
; 0000 0054 else if (y==5)  _A=1,_B=0,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x52
_0x43:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x53
	SBI  0x1B,6
	CBI  0x1B,1
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 0055 else if (y==6)  _A=1,_B=0,_C=1,_D=1,_E=1,_F=1,_G=1;
	RJMP _0x62
_0x53:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x63
	SBI  0x1B,6
	CBI  0x1B,1
	RCALL SUBOPT_0x1
	SBI  0x18,2
	SBI  0x1B,5
	SBI  0x18,3
; 0000 0056 else if (y==7)  _A=1,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
	RJMP _0x72
_0x63:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x73
	RCALL SUBOPT_0x0
	SBI  0x18,4
	RJMP _0x11C
; 0000 0057 else if (y==8)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=1;
_0x73:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x83
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	SBI  0x18,2
	SBI  0x1B,5
	SBI  0x18,3
; 0000 0058 else if (y==9)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=1,_G=1;
	RJMP _0x92
_0x83:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x93
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
; 0000 0059 else            _A=0,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
	RJMP _0xA2
_0x93:
	CBI  0x1B,6
	CBI  0x1B,1
	CBI  0x18,4
_0x11C:
	CBI  0x18,6
	CBI  0x18,2
	CBI  0x1B,5
_0x11B:
	CBI  0x18,3
; 0000 005A 
; 0000 005B if (x==0) _0=0, _1=1, _2=1, _P=1;
_0xA2:
_0x92:
_0x72:
_0x62:
_0x52:
_0x42:
_0x32:
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0xB1
	CBI  0x1B,7
	SBI  0x1B,4
	SBI  0x1B,3
	SBI  0x18,5
; 0000 005C if (x==1) _0=1, _1=0, _2=1, _P=0;
_0xB1:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0xBA
	SBI  0x1B,7
	CBI  0x1B,4
	SBI  0x1B,3
	CBI  0x18,5
; 0000 005D if (x==2) _0=1, _1=1, _2=0, _P=0;
_0xBA:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0xC3
	SBI  0x1B,7
	SBI  0x1B,4
	CBI  0x1B,3
	CBI  0x18,5
; 0000 005E delay_us(80);
_0xC3:
	__DELAY_USB 213
; 0000 005F _0=1, _1=1, _2=1, _P=0;
	SBI  0x1B,7
	SBI  0x1B,4
	SBI  0x1B,3
	CBI  0x18,5
; 0000 0060 }
	ADIW R28,2
	RET
;
;void read()
; 0000 0063 {
_read:
; 0000 0064 in01 = in02;
	__GETWRMN 13,14,0,_in02
; 0000 0065 in02 = in03;
	LDS  R30,_in03
	LDS  R31,_in03+1
	STS  _in02,R30
	STS  _in02+1,R31
; 0000 0066 in03 = in04;
	LDS  R30,_in04
	LDS  R31,_in04+1
	STS  _in03,R30
	STS  _in03+1,R31
; 0000 0067 in04 = in11;
	LDS  R30,_in11
	LDS  R31,_in11+1
	STS  _in04,R30
	STS  _in04+1,R31
; 0000 0068 in11 = in12;
	LDS  R30,_in12
	LDS  R31,_in12+1
	STS  _in11,R30
	STS  _in11+1,R31
; 0000 0069 in12 = in13;
	LDS  R30,_in13
	LDS  R31,_in13+1
	STS  _in12,R30
	STS  _in12+1,R31
; 0000 006A in13 = in14;
	LDS  R30,_in14
	LDS  R31,_in14+1
	STS  _in13,R30
	STS  _in13+1,R31
; 0000 006B in14 = in21;
	LDS  R30,_in21
	LDS  R31,_in21+1
	STS  _in14,R30
	STS  _in14+1,R31
; 0000 006C in21 = in22;
	LDS  R30,_in22
	LDS  R31,_in22+1
	STS  _in21,R30
	STS  _in21+1,R31
; 0000 006D in22 = in23;
	LDS  R30,_in23
	LDS  R31,_in23+1
	STS  _in22,R30
	STS  _in22+1,R31
; 0000 006E in23 = in24;
	LDS  R30,_in24
	LDS  R31,_in24+1
	STS  _in23,R30
	STS  _in23+1,R31
; 0000 006F in24 = read_adc(0);
	RCALL SUBOPT_0x3
	RCALL _read_adc
	STS  _in24,R30
	STS  _in24+1,R31
; 0000 0070 in = (in01+in02+in03+in04+in11+in12+in13+in14+in21+in22+in23+in24)/12;
	LDS  R30,_in02
	LDS  R31,_in02+1
	ADD  R30,R13
	ADC  R31,R14
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
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RCALL __DIVW21U
	RCALL SUBOPT_0x5
; 0000 0071 }
	RET
;
;void preobr()
; 0000 0074 {
_preobr:
; 0000 0075 if (in >=1000)
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x6
	BRLO _0xD4
; 0000 0076     {
; 0000 0077     if (j > 127) seg0=9, seg1=9, seg2=9, PORTA.2=1;
	LDI  R30,LOW(127)
	CP   R30,R8
	BRSH _0xD5
	LDI  R30,LOW(9)
	MOV  R4,R30
	MOV  R5,R30
	MOV  R6,R30
	SBI  0x1B,2
; 0000 0078         else seg0=10, seg1=10, seg2=10, PORTA.2=0;
	RJMP _0xD8
_0xD5:
	LDI  R30,LOW(10)
	MOV  R4,R30
	MOV  R5,R30
	MOV  R6,R30
	CBI  0x1B,2
; 0000 0079     return;
_0xD8:
	RET
; 0000 007A     }
; 0000 007B PORTA.2=0;
_0xD4:
	CBI  0x1B,2
; 0000 007C      if (in >= 900)   seg0=9, in=in - 900;
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0x6
	BRLO _0xDD
	LDI  R30,LOW(9)
	MOV  R4,R30
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0x7
; 0000 007D else if (in >= 800)   seg0=8, in=in - 800;
	RJMP _0xDE
_0xDD:
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	RCALL SUBOPT_0x6
	BRLO _0xDF
	LDI  R30,LOW(8)
	MOV  R4,R30
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	RCALL SUBOPT_0x7
; 0000 007E else if (in >= 700)   seg0=7, in=in - 700;
	RJMP _0xE0
_0xDF:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RCALL SUBOPT_0x6
	BRLO _0xE1
	LDI  R30,LOW(7)
	MOV  R4,R30
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RCALL SUBOPT_0x7
; 0000 007F else if (in >= 600)   seg0=6, in=in - 600;
	RJMP _0xE2
_0xE1:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL SUBOPT_0x6
	BRLO _0xE3
	LDI  R30,LOW(6)
	MOV  R4,R30
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL SUBOPT_0x7
; 0000 0080 else if (in >= 500)   seg0=5, in=in - 500;
	RJMP _0xE4
_0xE3:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x6
	BRLO _0xE5
	LDI  R30,LOW(5)
	MOV  R4,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x7
; 0000 0081 else if (in >= 400)   seg0=4, in=in - 400;
	RJMP _0xE6
_0xE5:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x6
	BRLO _0xE7
	LDI  R30,LOW(4)
	MOV  R4,R30
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x7
; 0000 0082 else if (in >= 300)   seg0=3, in=in - 300;
	RJMP _0xE8
_0xE7:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x6
	BRLO _0xE9
	LDI  R30,LOW(3)
	MOV  R4,R30
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x7
; 0000 0083 else if (in >= 200)   seg0=2, in=in - 200;
	RJMP _0xEA
_0xE9:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x6
	BRLO _0xEB
	LDI  R30,LOW(2)
	MOV  R4,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x7
; 0000 0084 else if (in >= 100)   seg0=1, in=in - 100;
	RJMP _0xEC
_0xEB:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x6
	BRLO _0xED
	LDI  R30,LOW(1)
	MOV  R4,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x7
; 0000 0085 else                  seg0=0;
	RJMP _0xEE
_0xED:
	CLR  R4
; 0000 0086 
; 0000 0087 if      (in >= 90)    seg1=9, in=in-90;
_0xEE:
_0xEC:
_0xEA:
_0xE8:
_0xE6:
_0xE4:
_0xE2:
_0xE0:
_0xDE:
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x6
	BRLO _0xEF
	LDI  R30,LOW(9)
	MOV  R5,R30
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x7
; 0000 0088 else if (in >= 80)    seg1=8, in=in-80;
	RJMP _0xF0
_0xEF:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x6
	BRLO _0xF1
	LDI  R30,LOW(8)
	MOV  R5,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x7
; 0000 0089 else if (in >= 70)    seg1=7, in=in-70;
	RJMP _0xF2
_0xF1:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x6
	BRLO _0xF3
	LDI  R30,LOW(7)
	MOV  R5,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x7
; 0000 008A else if (in >= 60)    seg1=6, in=in-60;
	RJMP _0xF4
_0xF3:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RCALL SUBOPT_0x6
	BRLO _0xF5
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x8
	SBIW R30,60
	RCALL SUBOPT_0x5
; 0000 008B else if (in >= 50)    seg1=5, in=in-50;
	RJMP _0xF6
_0xF5:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x6
	BRLO _0xF7
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x8
	SBIW R30,50
	RCALL SUBOPT_0x5
; 0000 008C else if (in >= 40)    seg1=4, in=in-40;
	RJMP _0xF8
_0xF7:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x6
	BRLO _0xF9
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x8
	SBIW R30,40
	RCALL SUBOPT_0x5
; 0000 008D else if (in >= 30)    seg1=3, in=in-30;
	RJMP _0xFA
_0xF9:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x6
	BRLO _0xFB
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x8
	SBIW R30,30
	RCALL SUBOPT_0x5
; 0000 008E else if (in >= 20)    seg1=2, in=in-20;
	RJMP _0xFC
_0xFB:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x6
	BRLO _0xFD
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x8
	SBIW R30,20
	RCALL SUBOPT_0x5
; 0000 008F else if (in >= 10)    seg1=1, in=in-10;
	RJMP _0xFE
_0xFD:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x6
	BRLO _0xFF
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x8
	SBIW R30,10
	RCALL SUBOPT_0x5
; 0000 0090 else                  seg1=0;
	RJMP _0x100
_0xFF:
	CLR  R5
; 0000 0091 
; 0000 0092 if      (in == 9)     seg2=9;
_0x100:
_0xFE:
_0xFC:
_0xFA:
_0xF8:
_0xF6:
_0xF4:
_0xF2:
_0xF0:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x9
	BRNE _0x101
	LDI  R30,LOW(9)
	MOV  R6,R30
; 0000 0093 else if (in == 8)     seg2=8;
	RJMP _0x102
_0x101:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x9
	BRNE _0x103
	LDI  R30,LOW(8)
	MOV  R6,R30
; 0000 0094 else if (in == 7)     seg2=7;
	RJMP _0x104
_0x103:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x9
	BRNE _0x105
	LDI  R30,LOW(7)
	MOV  R6,R30
; 0000 0095 else if (in == 6)     seg2=6;
	RJMP _0x106
_0x105:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x9
	BRNE _0x107
	LDI  R30,LOW(6)
	MOV  R6,R30
; 0000 0096 else if (in == 5)     seg2=5;
	RJMP _0x108
_0x107:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x9
	BRNE _0x109
	LDI  R30,LOW(5)
	MOV  R6,R30
; 0000 0097 else if (in == 4)     seg2=4;
	RJMP _0x10A
_0x109:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x9
	BRNE _0x10B
	LDI  R30,LOW(4)
	MOV  R6,R30
; 0000 0098 else if (in == 3)     seg2=3;
	RJMP _0x10C
_0x10B:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x9
	BRNE _0x10D
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 0099 else if (in == 2)     seg2=2;
	RJMP _0x10E
_0x10D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x9
	BRNE _0x10F
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 009A else if (in == 1)     seg2=1;
	RJMP _0x110
_0x10F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x9
	BRNE _0x111
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 009B else                  seg2=0;
	RJMP _0x112
_0x111:
	CLR  R6
; 0000 009C }
_0x112:
_0x110:
_0x10E:
_0x10C:
_0x10A:
_0x108:
_0x106:
_0x104:
_0x102:
	RET
;
;void start()
; 0000 009F {
_start:
; 0000 00A0 // Input/Output Ports initialization
; 0000 00A1 // Port A initialization
; 0000 00A2 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In
; 0000 00A3 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=T
; 0000 00A4 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00A5 DDRA=0xFE;
	LDI  R30,LOW(254)
	OUT  0x1A,R30
; 0000 00A6 
; 0000 00A7 // Port B initialization
; 0000 00A8 // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 00A9 // State7=T State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 00AA PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00AB DDRB=0x7C;
	LDI  R30,LOW(124)
	OUT  0x17,R30
; 0000 00AC 
; 0000 00AD // Timer/Counter 0 initialization
; 0000 00AE // Clock source: System Clock
; 0000 00AF // Clock value: Timer 0 Stopped
; 0000 00B0 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00B1 TCNT0=0x00;
	OUT  0x32,R30
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
; 0000 00D7 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D8 
; 0000 00D9 // ADC initialization
; 0000 00DA // ADC Clock frequency: 125,000 kHz
; 0000 00DB // ADC Voltage Reference: Int., AREF discon.
; 0000 00DC ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00DD ADCSR=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 00DE 
; 0000 00DF // Global enable interrupts
; 0000 00E0 #asm("sei")
	sei
; 0000 00E1 }
	RET
;
;void main(void)
; 0000 00E4 {
_main:
; 0000 00E5 // Declare your local variables here
; 0000 00E6 
; 0000 00E7 start();
	RCALL _start
; 0000 00E8 
; 0000 00E9 while (1)
_0x113:
; 0000 00EA       {
; 0000 00EB       // Place your code here
; 0000 00EC       read();
	RCALL _read
; 0000 00ED       if (i == 0) preobr();
	TST  R7
	BRNE _0x116
	RCALL _preobr
; 0000 00EE       codegen(2,seg2);
_0x116:
	RCALL SUBOPT_0xA
; 0000 00EF       codegen(0,seg0);
	ST   -Y,R4
	RCALL SUBOPT_0xB
; 0000 00F0       codegen(1,seg1);
; 0000 00F1       read();
	RCALL _read
; 0000 00F2       if (i == 0) preobr();
	TST  R7
	BRNE _0x117
	RCALL _preobr
; 0000 00F3       codegen(1,seg1);
_0x117:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R5
	RCALL _codegen
; 0000 00F4       codegen(2,seg2);
	RCALL SUBOPT_0xA
; 0000 00F5       codegen(0,seg0);
	ST   -Y,R4
	RCALL _codegen
; 0000 00F6       read();
	RCALL _read
; 0000 00F7       if (i == 0) preobr();
	TST  R7
	BRNE _0x118
	RCALL _preobr
; 0000 00F8       codegen(0,seg0);
_0x118:
	RCALL SUBOPT_0x3
	ST   -Y,R4
	RCALL SUBOPT_0xB
; 0000 00F9       codegen(1,seg1);
; 0000 00FA       codegen(2,seg2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R6
	RCALL _codegen
; 0000 00FB       i++;
	INC  R7
; 0000 00FC       if (i>=25) i=0;
	LDI  R30,LOW(25)
	CP   R7,R30
	BRLO _0x119
	CLR  R7
; 0000 00FD       j=j+4;
_0x119:
	LDI  R30,LOW(4)
	ADD  R8,R30
; 0000 00FE 
; 0000 00FF       };
	RJMP _0x113
; 0000 0100 }
_0x11A:
	RJMP _0x11A

	.DSEG
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	__PUTW1R 11,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x6:
	CP   R11,R30
	CPC  R12,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	__SUBWRR 11,12,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x8:
	MOV  R5,R30
	__GETW1R 11,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	CP   R30,R11
	CPC  R31,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R6
	RCALL _codegen
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	RCALL _codegen
	LDI  R30,LOW(1)
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
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          