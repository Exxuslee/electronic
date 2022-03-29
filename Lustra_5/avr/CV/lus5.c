/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 21.08.2012
Author  : NeVaDa
Company :
Comments:


Chip type               : ATtiny2313
AVR Core Clock frequency: 20,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>


// Declare your global variables here
float period, skvaz, temp_f, temp_int;
unsigned char save=0;
eeprom float skvaz_ee;
eeprom float period_ee;

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
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=In Func0=In
// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=T State0=T
PORTB=0x00;
DDRB=0x1C;

// Port D initialization
// Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
// State6=T State5=0 State4=T State3=P State2=P State1=P State0=P
PORTD=0x2F;
DDRD=0x20;

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
// Clock value: 20000,000 kHz
// Mode: Ph. correct PWM top=ICR1
// OC1A output: Inverted
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xE2;
TCCR1B=0x11;
/*
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0xFF;
ICR1L=0xFF;
OCR1AH=0xfF;
OCR1AL=0xdF;
OCR1BH=0x00;
OCR1BL=0x20;
*/

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

if (period_ee == 0xFFFFFFFF) period_ee = 0x200;
period = period_ee;
period = 0x7ff;

if (skvaz_ee == 0xFFFFFFFF) skvaz_ee = 0.25;
skvaz = skvaz_ee;
skvaz = 0.25;

while (1)
      {
      // Place your code here
      if ((PIND.0 == 0)&(period < 0xFD70)) period = period*1.01 +1;
      if ((PIND.1 == 0)&(period > 0x30)) period = period*0.99 -1;
      if ((PIND.2 == 0)&(skvaz < 0.45)) skvaz += 0.005;
      if ((PIND.3 == 0)&(skvaz > 0.05)) skvaz -= 0.005;

      temp_f = period * skvaz;
      ICR1 = (int)period;
      OCR1A = period - (int)temp_f;
      OCR1B = (int)temp_f;

      temp_int = period_ee;
      if (period != temp_int)
        {
        save++;
        if (save == 0xff) period_ee = period;
        };

      temp_f = skvaz_ee;
      if (skvaz != temp_f)
        {
        save++;
        if (save == 0xff) skvaz_ee = skvaz;
        };

      delay_ms (10);
      };
}


