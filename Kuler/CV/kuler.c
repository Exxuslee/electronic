/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
? Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 25.09.2012
Author  : NeVaDa
Company : MICROSOFT
Comments:


Chip type               : ATtiny13A
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*****************************************************/

#include <tiny13a.h>

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x3C;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Analog Comparator initialization
// Analog Comparator: On
// Digital input buffers on AIN0: Off, AIN1: Off
DIDR0=0x03;
ACSR=0x00;
ADCSRB=0x00;

while (1)
      {
      // Place your code here
      //PORTB.4=ACO;
      if (ACSR==0x10) PORTB.2=1, PORTB.3=0, PORTB.4=1;
      if (ACSR==0x30) PORTB.2=0, PORTB.3=1, PORTB.4=0;

      };
}
