/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 09.01.2010
Author  : 
Company : 
Comments: 


Chip type           : AT90S2313
Clock frequency     : 8,000000 MHz
Memory model        : Tiny
External RAM size   : 0
Data Stack size     : 32
*****************************************************/

#include <90s2313.h>

unsigned char skvazh;
bit period;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
if (period ==0)
    {
    PORTB.2=0;
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    #asm("nop")
    PORTB.3=1;
    }
   else 
   {
   PORTB.2=0;
   PORTB.3=0;
   TCCR0=0x00;   
   };
// Reinitialize Timer 0 value
TCNT0=skvazh;
period++;
}

// Timer 1 output compare interrupt service routine
interrupt [TIM1_COMP] void timer1_comp_isr(void)
{
// Place your code here
PORTB.3=0;

#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")

PORTB.2=1;
TCCR0=0x02;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=T State0=T 
PORTB=0x00;
DDRB=0x0C;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=P State4=P State3=P State2=P State1=T State0=T 
PORTD=0x3C;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
TCCR0=0x00;
TCNT0=0xA0;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: CTC top=OCR1A
// OC1 output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare Match Interrupt: On
TCCR1A=0x00;
TCCR1B=0x09;
TCNT1H=0x00;
TCNT1L=0x00;
OCR1H=0x60;
OCR1L=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x42;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      if (PIND.2 == 0)
        {
        OCR1=OCR1+0x40;
        while (PIND.2 ==0)
            {
            };
        };
      if (PIND.3 == 0)
        {
        OCR1=OCR1-0x40;
        while (PIND.3 ==0)
            {
            };
        };      
      if (PIND.4 == 0)
        {
        skvazh++;
        while (PIND.4 ==0)
            {
            };
        };
      if (PIND.5 == 0)
        {
        skvazh--;
        while (PIND.5 ==0)
            {
            };
        };      
      };
}










