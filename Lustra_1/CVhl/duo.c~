/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 27.08.2010
Author  : NeVaDa
Company : Haos
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>

// Declare your global variables here
float skvaz = 0.2;

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
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=0 State3=0 State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x18;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x3C;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Ph. correct PWM top=ICR1
// OC1A output: Inverted
// OC1B output: Inverted
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xF2;
TCCR1B=0x11;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x02;
ICR1L=0xFF;
OCR1AH=0x00;
OCR1AL=0x30;
OCR1BH=0x02;
OCR1BL=0xC0;

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
      float temp;
      if (PIND.2 == 0) 
        {
        skvaz += 0.005;
        if (skvaz > 0.470) skvaz = 0.470;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = ICR1 - (int)temp;
        };
      if (PIND.3 == 0) 
        {
        skvaz -= 0.005;
        if (skvaz < 0.010) skvaz = 0.010;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = ICR1 - (int)temp;
        };       
            
      if (PIND.4 == 0)  
        {
        temp = (float)ICR1;
        temp = temp*1.01 +1;
        ICR1 = (int)temp;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = ICR1 - (int)temp;
        };
      if (PIND.5 == 0)
        {
        temp = (float)ICR1;
        temp = temp*0.99 -1;
        ICR1 = (int)temp;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = ICR1 - (int)temp;
        };                 

      delay_ms (100);
      };
}