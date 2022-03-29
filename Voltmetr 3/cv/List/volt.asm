
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0010
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	.DEF _adc_data=R8
	.DEF _in=R10
	.DEF _in01=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

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
;unsigned char seg0, seg1, seg2, i;
;unsigned int adc_data;
;unsigned int in;
;unsigned int in01, in02, in03, in04;
;unsigned int in11, in12, in13, in14;
;unsigned int in21, in22, in23, in24;
;#define ADC_VREF_TYPE 0x00  //0x80
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0035 {

	.CSEG
_adc_isr:
; 0000 0036 // Read the AD conversion result
; 0000 0037 adc_data=ADCW;
	__INWR 8,9,4
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
	__GETW1R 8,9
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
	RJMP _0x11E
; 0000 0050 else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x13
	CBI  0x1B,6
	SBI  0x1B,1
	SBI  0x18,4
	RJMP _0x11F
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
	RJMP _0x11F
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
_0x11F:
	CBI  0x18,6
	CBI  0x18,2
	CBI  0x1B,5
_0x11E:
	CBI  0x18,3
; 0000 005A 
; 0000 005B if (x==0) _0=0, _1=1, _2=1, _P=0;
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
	CBI  0x18,5
; 0000 005C if (x==1) _0=1, _1=0, _2=1, _P=1;
_0xB1:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0xBA
	SBI  0x1B,7
	CBI  0x1B,4
	SBI  0x1B,3
	SBI  0x18,5
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
	__GETWRMN 12,13,0,_in02
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
; 0000 0070 in = (in01+in02+in03+in04+in11+in12+in13+in14+in21+in22+in23+in24)/24*1.1;  //1024bit=50,0Volt
	LDS  R30,_in02
	LDS  R31,_in02+1
	ADD  R30,R12
	ADC  R31,R13
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
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	RCALL __DIVW21U
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3F8CCCCD
	RCALL __MULF12
	RCALL __CFD1U
	RCALL SUBOPT_0x5
; 0000 0071 
; 0000 0072 if (in <= 100) PORTB.0=1;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x6
	BRLO _0xD4
	SBI  0x18,0
; 0000 0073     else PORTB.0=0;
	RJMP _0xD7
_0xD4:
	CBI  0x18,0
; 0000 0074 if (in >= 144) PORTB.1=1;
_0xD7:
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	RCALL SUBOPT_0x7
	BRLO _0xDA
	SBI  0x18,1
; 0000 0075     else PORTB.1=0;
	RJMP _0xDD
_0xDA:
	CBI  0x18,1
; 0000 0076 }
_0xDD:
	RET
;
;void preobr()
; 0000 0079 {
_preobr:
; 0000 007A      if (in >= 900)   seg0=9, in=in - 900;
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0x7
	BRLO _0xE0
	LDI  R30,LOW(9)
	MOV  R4,R30
	LDI  R30,LOW(900)
	LDI  R31,HIGH(900)
	RCALL SUBOPT_0x8
; 0000 007B else if (in >= 800)   seg0=8, in=in - 800;
	RJMP _0xE1
_0xE0:
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	RCALL SUBOPT_0x7
	BRLO _0xE2
	LDI  R30,LOW(8)
	MOV  R4,R30
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	RCALL SUBOPT_0x8
; 0000 007C else if (in >= 700)   seg0=7, in=in - 700;
	RJMP _0xE3
_0xE2:
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RCALL SUBOPT_0x7
	BRLO _0xE4
	LDI  R30,LOW(7)
	MOV  R4,R30
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RCALL SUBOPT_0x8
; 0000 007D else if (in >= 600)   seg0=6, in=in - 600;
	RJMP _0xE5
_0xE4:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL SUBOPT_0x7
	BRLO _0xE6
	LDI  R30,LOW(6)
	MOV  R4,R30
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	RCALL SUBOPT_0x8
; 0000 007E else if (in >= 500)   seg0=5, in=in - 500;
	RJMP _0xE7
_0xE6:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x7
	BRLO _0xE8
	LDI  R30,LOW(5)
	MOV  R4,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x8
; 0000 007F else if (in >= 400)   seg0=4, in=in - 400;
	RJMP _0xE9
_0xE8:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x7
	BRLO _0xEA
	LDI  R30,LOW(4)
	MOV  R4,R30
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RCALL SUBOPT_0x8
; 0000 0080 else if (in >= 300)   seg0=3, in=in - 300;
	RJMP _0xEB
_0xEA:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x7
	BRLO _0xEC
	LDI  R30,LOW(3)
	MOV  R4,R30
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x8
; 0000 0081 else if (in >= 200)   seg0=2, in=in - 200;
	RJMP _0xED
_0xEC:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x7
	BRLO _0xEE
	LDI  R30,LOW(2)
	MOV  R4,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x8
; 0000 0082 else if (in >= 100)   seg0=1, in=in - 100;
	RJMP _0xEF
_0xEE:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x7
	BRLO _0xF0
	LDI  R30,LOW(1)
	MOV  R4,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x8
; 0000 0083 else                  seg0=10;
	RJMP _0xF1
_0xF0:
	LDI  R30,LOW(10)
	MOV  R4,R30
; 0000 0084 
; 0000 0085 if      (in >= 90)    seg1=9, in=in-90;
_0xF1:
_0xEF:
_0xED:
_0xEB:
_0xE9:
_0xE7:
_0xE5:
_0xE3:
_0xE1:
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x7
	BRLO _0xF2
	LDI  R30,LOW(9)
	MOV  R5,R30
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x8
; 0000 0086 else if (in >= 80)    seg1=8, in=in-80;
	RJMP _0xF3
_0xF2:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x7
	BRLO _0xF4
	LDI  R30,LOW(8)
	MOV  R5,R30
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RCALL SUBOPT_0x8
; 0000 0087 else if (in >= 70)    seg1=7, in=in-70;
	RJMP _0xF5
_0xF4:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x7
	BRLO _0xF6
	LDI  R30,LOW(7)
	MOV  R5,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0x8
; 0000 0088 else if (in >= 60)    seg1=6, in=in-60;
	RJMP _0xF7
_0xF6:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RCALL SUBOPT_0x7
	BRLO _0xF8
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x9
	SBIW R30,60
	RCALL SUBOPT_0x5
; 0000 0089 else if (in >= 50)    seg1=5, in=in-50;
	RJMP _0xF9
_0xF8:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x7
	BRLO _0xFA
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x9
	SBIW R30,50
	RCALL SUBOPT_0x5
; 0000 008A else if (in >= 40)    seg1=4, in=in-40;
	RJMP _0xFB
_0xFA:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL SUBOPT_0x7
	BRLO _0xFC
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x9
	SBIW R30,40
	RCALL SUBOPT_0x5
; 0000 008B else if (in >= 30)    seg1=3, in=in-30;
	RJMP _0xFD
_0xFC:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x7
	BRLO _0xFE
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x9
	SBIW R30,30
	RCALL SUBOPT_0x5
; 0000 008C else if (in >= 20)    seg1=2, in=in-20;
	RJMP _0xFF
_0xFE:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x7
	BRLO _0x100
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x9
	SBIW R30,20
	RCALL SUBOPT_0x5
; 0000 008D else if (in >= 10)    seg1=1, in=in-10;
	RJMP _0x101
_0x100:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x7
	BRLO _0x102
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
	SBIW R30,10
	RCALL SUBOPT_0x5
; 0000 008E else                  seg1=0;
	RJMP _0x103
_0x102:
	CLR  R5
; 0000 008F 
; 0000 0090 if      (in == 9)     seg2=9;
_0x103:
_0x101:
_0xFF:
_0xFD:
_0xFB:
_0xF9:
_0xF7:
_0xF5:
_0xF3:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x6
	BRNE _0x104
	LDI  R30,LOW(9)
	MOV  R6,R30
; 0000 0091 else if (in == 8)     seg2=8;
	RJMP _0x105
_0x104:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	RCALL SUBOPT_0x6
	BRNE _0x106
	LDI  R30,LOW(8)
	MOV  R6,R30
; 0000 0092 else if (in == 7)     seg2=7;
	RJMP _0x107
_0x106:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL SUBOPT_0x6
	BRNE _0x108
	LDI  R30,LOW(7)
	MOV  R6,R30
; 0000 0093 else if (in == 6)     seg2=6;
	RJMP _0x109
_0x108:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x6
	BRNE _0x10A
	LDI  R30,LOW(6)
	MOV  R6,R30
; 0000 0094 else if (in == 5)     seg2=5;
	RJMP _0x10B
_0x10A:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x6
	BRNE _0x10C
	LDI  R30,LOW(5)
	MOV  R6,R30
; 0000 0095 else if (in == 4)     seg2=4;
	RJMP _0x10D
_0x10C:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x6
	BRNE _0x10E
	LDI  R30,LOW(4)
	MOV  R6,R30
; 0000 0096 else if (in == 3)     seg2=3;
	RJMP _0x10F
_0x10E:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x6
	BRNE _0x110
	LDI  R30,LOW(3)
	MOV  R6,R30
; 0000 0097 else if (in == 2)     seg2=2;
	RJMP _0x111
_0x110:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x6
	BRNE _0x112
	LDI  R30,LOW(2)
	MOV  R6,R30
; 0000 0098 else if (in == 1)     seg2=1;
	RJMP _0x113
_0x112:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x6
	BRNE _0x114
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0099 else                  seg2=0;
	RJMP _0x115
_0x114:
	CLR  R6
; 0000 009A }
_0x115:
_0x113:
_0x111:
_0x10F:
_0x10D:
_0x10B:
_0x109:
_0x107:
_0x105:
	RET
;
;void start()
; 0000 009D {
_start:
; 0000 009E // Input/Output Ports initialization
; 0000 009F // Port A initialization
; 0000 00A0 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In
; 0000 00A1 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=T
; 0000 00A2 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00A3 DDRA=0xFA;
	LDI  R30,LOW(250)
	OUT  0x1A,R30
; 0000 00A4 
; 0000 00A5 // Port B initialization
; 0000 00A6 // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 00A7 // State7=T State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 00A8 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00A9 DDRB=0x7F;
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 00AA 
; 0000 00AB // Timer/Counter 0 initialization
; 0000 00AC // Clock source: System Clock
; 0000 00AD // Clock value: Timer 0 Stopped
; 0000 00AE TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00AF TCNT0=0x00;
	OUT  0x32,R30
; 0000 00B0 
; 0000 00B1 // Timer/Counter 1 initialization
; 0000 00B2 // Clock source: System Clock
; 0000 00B3 // Clock value: Timer1 Stopped
; 0000 00B4 // Mode: Normal top=FFh
; 0000 00B5 // OC1A output: Disconnected
; 0000 00B6 // OC1B output: Disconnected
; 0000 00B7 // Timer1 Overflow Interrupt: Off
; 0000 00B8 // Compare A Match Interrupt: Off
; 0000 00B9 // Compare B Match Interrupt: Off
; 0000 00BA PLLCSR=0x00;
	OUT  0x29,R30
; 0000 00BB 
; 0000 00BC TCCR1A=0x00;
	OUT  0x30,R30
; 0000 00BD TCCR1B=0x00;
	OUT  0x2F,R30
; 0000 00BE TCNT1=0x00;
	OUT  0x2E,R30
; 0000 00BF OCR1A=0x00;
	OUT  0x2D,R30
; 0000 00C0 OCR1B=0x00;
	OUT  0x2C,R30
; 0000 00C1 OCR1C=0x00;
	OUT  0x2B,R30
; 0000 00C2 
; 0000 00C3 // External Interrupt(s) initialization
; 0000 00C4 // INT0: Off
; 0000 00C5 // Interrupt on any change on pins PA3, PA6, PA7 and PB4-7: Off
; 0000 00C6 // Interrupt on any change on pins PB0-3: Off
; 0000 00C7 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 00C8 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00C9 
; 0000 00CA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00CB TIMSK=0x00;
	OUT  0x39,R30
; 0000 00CC 
; 0000 00CD // Universal Serial Interface initialization
; 0000 00CE // Mode: Disabled
; 0000 00CF // Clock source: Register & Counter=no clk.
; 0000 00D0 // USI Counter Overflow Interrupt: Off
; 0000 00D1 USICR=0x00;
	OUT  0xD,R30
; 0000 00D2 
; 0000 00D3 // Analog Comparator initialization
; 0000 00D4 // Analog Comparator: Off
; 0000 00D5 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D6 
; 0000 00D7 // ADC initialization
; 0000 00D8 // ADC Clock frequency: 125,000 kHz
; 0000 00D9 // ADC Voltage Reference: Int., AREF discon.
; 0000 00DA ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00DB ADCSR=0x8E;
	LDI  R30,LOW(142)
	OUT  0x6,R30
; 0000 00DC 
; 0000 00DD // Global enable interrupts
; 0000 00DE #asm("sei")
	sei
; 0000 00DF }
	RET
;
;void main(void)
; 0000 00E2 {
_main:
; 0000 00E3 // Declare your local variables here
; 0000 00E4 
; 0000 00E5 start();
	RCALL _start
; 0000 00E6 
; 0000 00E7 while (1)
_0x116:
; 0000 00E8       {
; 0000 00E9       // Place your code here
; 0000 00EA       read();
	RCALL _read
; 0000 00EB       if (i == 0) preobr();
	TST  R7
	BRNE _0x119
	RCALL _preobr
; 0000 00EC       codegen(2,seg2);
_0x119:
	RCALL SUBOPT_0xA
; 0000 00ED       codegen(0,seg0);
	ST   -Y,R4
	RCALL SUBOPT_0xB
; 0000 00EE       codegen(1,seg1);
; 0000 00EF       read();
	RCALL _read
; 0000 00F0       if (i == 0) preobr();
	TST  R7
	BRNE _0x11A
	RCALL _preobr
; 0000 00F1       codegen(1,seg1);
_0x11A:
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R5
	RCALL _codegen
; 0000 00F2       codegen(2,seg2);
	RCALL SUBOPT_0xA
; 0000 00F3       codegen(0,seg0);
	ST   -Y,R4
	RCALL _codegen
; 0000 00F4       read();
	RCALL _read
; 0000 00F5       if (i == 0) preobr();
	TST  R7
	BRNE _0x11B
	RCALL _preobr
; 0000 00F6       codegen(0,seg0);
_0x11B:
	RCALL SUBOPT_0x3
	ST   -Y,R4
	RCALL SUBOPT_0xB
; 0000 00F7       codegen(1,seg1);
; 0000 00F8       codegen(2,seg2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R6
	RCALL _codegen
; 0000 00F9       i++;
	INC  R7
; 0000 00FA       if (i>=25) i=0;
	LDI  R30,LOW(25)
	CP   R7,R30
	BRLO _0x11C
	CLR  R7
; 0000 00FB       };
_0x11C:
	RJMP _0x116
; 0000 00FC }
_0x11D:
	RJMP _0x11D

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
	__PUTW1R 10,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x7:
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	__SUBWRR 10,11,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	MOV  R5,R30
	__GETW1R 10,11
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
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
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
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
