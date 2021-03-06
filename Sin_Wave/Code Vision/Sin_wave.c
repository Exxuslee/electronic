/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 13.06.2009
Author  : 
Company : 
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
/*
unsigned int cycle;
unsigned int tik;
unsigned char temp=0;
const unsigned char sinetable[256] = 
    {
    128,131,134,137,140,143,146,149,152,156,159,162,165,168,171,174,
    176,179,182,185,188,191,193,196,199,201,204,206,209,211,213,216,
    218,220,222,224,226,228,230,232,234,236,237,239,240,242,243,245,
    246,247,248,249,250,251,252,252,253,254,254,255,255,255,255,255,
    255,255,255,255,255,255,254,254,253,252,252,251,250,249,248,247,
    246,245,243,242,240,239,237,236,234,232,230,228,226,224,222,220,
    218,216,213,211,209,206,204,201,199,196,193,191,188,185,182,179,
    176,174,171,168,165,162,159,156,152,149,146,143,140,137,134,131,
	128,124,121,118,115,112,109,106,103,99, 96, 93, 90, 87, 84, 81, 
	79, 76, 73, 70, 67, 64, 62, 59, 56, 54, 51, 49, 46, 44, 42, 39, 
	37, 35, 33, 31, 29, 27, 25, 23, 21, 19, 18, 16, 15, 13, 12, 10, 
	9,  8,  7,  6,  5,  4,  3,  3,  2,  1,  1,  0,  0,  0,  0,  0,  
	0,  0,  0,  0,  0,  0,  1,  1,  2,  3,  3,  4,  5,  6,  7,  8,  
	9,  10, 12, 13, 15, 16, 18, 19, 21, 23, 25, 27, 29, 31, 33, 35, 
	37, 39, 42, 44, 46, 49, 51, 54, 56, 59, 62, 64, 67, 70, 73, 76, 
	79, 81, 84, 87, 90, 93, 96, 99, 103,106,109,112,115,118,121,124
    };

// Timer 1 input capture interrupt service routine
interrupt [TIM1_CAPT] void timer1_capt_isr(void)
{
// Place your code here
cycle=ICR1;
tik=cycle/256;
}
*/
// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: On
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: On
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;  //81;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x20;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")

#pragma warn-
#asm
ldi R01, 128
ldi R02, 128
ldi R03, 128
ldi R04, 128
ldi R05, 128
ldi R06, 128
ldi R07, 128
ldi R08, 128
ldi R09, 128
ldi R10, 128
ldi R11, 128
ldi R12, 128
ldi R13, 128
ldi R14, 128
ldi R15, 128
ldi R16, 128
ldi R17, 128
ldi R18, 128
ldi R19, 128
ldi R20, 128
ldi R21, 128
ldi R22, 128
ldi R23, 128
ldi R24, 128
ldi R25, 128
ldi R26, 128
ldi R27, 128
ldi R28, 128
ldi R29, 128
ldi R30, 128
ldi R31, 128
ldi R32, 128
#endasm
#pragma warn+


while (1)
      {
      // Place your code here
//      PORTD=sinetable[temp++];
//      while (tik!=0) tik--;
//      tik=0x03;
#pragma warn-
#asm      
OUT PORTD,R0
OUT PORTD,R1
OUT PORTD,R2
OUT PORTD,R3
OUT PORTD,R4
OUT PORTD,R5
OUT PORTD,R6
OUT PORTD,R7
OUT PORTD,R8
OUT PORTD,R9
OUT PORTD,R10
OUT PORTD,R11
OUT PORTD,R12
OUT PORTD,R13
OUT PORTD,R14
OUT PORTD,R15
OUT PORTD,R16
OUT PORTD,R17
OUT PORTD,R18
OUT PORTD,R19
OUT PORTD,R20
OUT PORTD,R21
OUT PORTD,R22
OUT PORTD,R23
OUT PORTD,R24
OUT PORTD,R25
OUT PORTD,R26
OUT PORTD,R27
OUT PORTD,R28
OUT PORTD,R29
OUT PORTD,R30
OUT PORTD,R31      
#endasm
#pragma warn+      
      };
}

