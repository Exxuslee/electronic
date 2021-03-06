/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 17.12.2009
Author  : 
Company : 
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 8,000000 MHz
Memory model        : Tiny
External RAM size   : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>

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
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x0F;

// Port D initialization
// Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=0 State4=T State3=P State2=P State1=P State0=P 
PORTD=0x0F;
DDRD=0x20;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=OCR0A
// OC0A output: Disconnected
// OC0B output: Non-Inverted PWM
TCCR0A=0x23;
TCCR0B=0x09;
TCNT0=0x00;
OCR0A=0x01;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

while (1)
      {
      // Place your code here
      if (PIND.0 == 0)
        {
        OCR0A++;
        while (PIND.0 ==0)
            {
            if (OCR0A == 0 )      OCR0A=1;
            if (OCR0A <= OCR0B)   OCR0B=0;
            };
        };
      if (PIND.1 == 0)
        {
        OCR0A--;
        while (PIND.1 ==0)
            {
            if (OCR0A == 0 )      OCR0A=1;
            if (OCR0A <= OCR0B)   OCR0B=0;
            };
        };      
      if (PIND.2 == 0)
        {
        OCR0B++;
        while (PIND.2 ==0)
            {
            if (OCR0A == 0 )      OCR0A=1;
            if (OCR0A <= OCR0B)   OCR0B=0;
            };
        };
      if (PIND.3 == 0)
        {
        OCR0B--;
        while (PIND.3 ==0)
            {
            if (OCR0A == 0 )      OCR0A=1;
            if (OCR0A <= OCR0B)   OCR0B=0;
            };
        };      
      };
}
