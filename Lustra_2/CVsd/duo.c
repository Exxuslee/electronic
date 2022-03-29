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
float skvaz;
unsigned int period;
float temp;
unsigned int save=0;
eeprom float skvaz_ee;
eeprom unsigned int period_ee;

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
if (PINB.4 == 0) PORTB.4=1;
else PORTB.4=0;
return;
}

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
// Clock value: 1000,000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Non-Inv.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x82;
TCCR1B=0x1A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x03;
ICR1L=0x00;
OCR1AH=0x01;
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
TIMSK=0x40;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Global enable interrupts
#asm("sei")


if (period_ee == 0xFFFF) period_ee = 0x0300;
ICR1 = period_ee;

if (skvaz_ee == 0xFFFFFFFF) skvaz_ee = 0.2;
temp = ICR1 * skvaz;
OCR1A = (int)temp;
OCR1B = (int)temp;
        
while (1)
      {
      // Place your code here
      if (PIND.2 == 0) 
        {
        skvaz += 0.005;
        if (skvaz > 0.95) skvaz = 0.95;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = (int)temp;
        };
      if (PIND.3 == 0) 
        {
        skvaz -= 0.005;
        if (skvaz < 0.010) skvaz = 0.010;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = (int)temp;
        };       
            
      if (PIND.4 == 0)  
        {
        period = ICR1;
        if (period < 0xFD70) period = period*1.01 +1;
        ICR1 = (int)period;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = (int)temp;
        };
      if (PIND.5 == 0)
        {
        period = ICR1;
        if (temp > 2.0) period = period*0.99 -1;
        ICR1 = (int)period;        
        temp = ICR1 * skvaz;
        OCR1A = (int)temp;
        OCR1B = (int)temp;
        };                 

      if (period != period_ee)
        {
        save++;
        if (save == 0)   period_ee = period;
        };
        
      if (skvaz != skvaz_ee)
        {
        save++;
        if (save == 0)   skvaz_ee = skvaz;
        };
              
      delay_ms (20);
      };
}