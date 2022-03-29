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
float temp_f;
unsigned int temp_int;
unsigned char save=0;
eeprom float skvaz_ee;
eeprom unsigned int period_ee;

// Timer1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here
if (PINB.5 == 0) 
    {
    PORTB.5=1;
    PORTB.3=0;
    }
else 
    {
    PORTB.5=0;
    PORTB.3=1;
    };
#asm("wdr")
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
PORTB=0x04;
DDRB=0x3C;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x1F;
DDRD=0x60;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Ph. correct PWM top=OCR0A
// OC0A output: Disconnected
// OC0B output: Non-Inverted PWM
TCCR0A=0x21;
TCCR0B=0x0D;
TCNT0=0x00;
OCR0A=0xF0;
OCR0B=0x01;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x20;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2k
// Watchdog Timer interrupt: Off
#pragma optsize-
WDTCR=0x18;
WDTCR=0x08;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Global enable interrupts
#asm("sei")


if (period_ee == 0xFFFF) period_ee = 0x200;
period = period_ee; 
ICR1 = period_ee;

if (skvaz_ee == 0xFFFFFFFF) skvaz_ee = 0.20;
skvaz = skvaz_ee;
temp_f = period * skvaz;
OCR1B = (int)temp_f;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Discon.
// OC1B output: Inverted
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: On
TCCR1A=0x32;
TCCR1B=0x19;
/*
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x03;
ICR1L=0x00;
OCR1AH=0x01;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
*/

        
while (1)
      {
      // Place your code here
      if (PIND.0 == 0)
        {
        if (OCR0A < 0xff) OCR0A++;
        };
      if (PIND.1 == 0)
        {
        if (OCR0A > 0x00) OCR0A--;
        };     
      
      if (PIND.2 == 0) 
        {
        skvaz += 0.005;
        if (skvaz > 0.95) skvaz = 0.95;        
        temp_f = period * skvaz;
        OCR1B = (int)temp_f;
        };
      if (PIND.3 == 0) 
        {
        skvaz -= 0.005;
        if (skvaz < 0.10) skvaz = 0.10;        
        temp_f = period * skvaz;
        OCR1B = (int)temp_f;
        };       
            
      if (PIND.4 == 0)  
        {
        period = ICR1;
        if (period < 0xFD70) period = period*1.01 +1;
        ICR1 = period;        
        temp_f = period * skvaz;
        OCR1B = (int)temp_f;
        };
      if (PINB.2 == 0)
        {
        period = ICR1;
        if (period > 0x20) period = period*0.99 -1;
        ICR1 = period;        
        temp_f = period * skvaz;
        OCR1B = (int)temp_f;
        };                 

      temp_int = period_ee;
      if (period != temp_int)
        {
        save++;
        if (save == 0xff)   
            {
            period_ee = period;
            PORTD.6=0;
            };
        };
        
      temp_f = skvaz_ee;
      if (skvaz != temp_f)
        {
        save++;
        if (save == 0xff)   
            {
            skvaz_ee = skvaz;
            PORTD.6=0;
            };
        };
              
      delay_ms (100);
      PORTD.6=1;
      };
}