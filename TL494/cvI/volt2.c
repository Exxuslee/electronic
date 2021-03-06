/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
? Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 24.01.2012
Author  : NeVaDa
Company : MICROSOFT
Comments:


Chip type               : ATtiny26L
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/



#include <tiny26.h>
#include <delay.h>

#define _0 PORTA.7
#define _1 PORTA.4
#define _2 PORTA.3

#define _A PORTA.6
#define _B PORTA.1
#define _C PORTB.4
#define _D PORTB.6
#define _E PORTB.2
#define _F PORTA.5
#define _G PORTB.3
#define _P PORTB.5


// Declare your global variables here
unsigned int in, in1, in2;
unsigned char seg0, seg1, seg2;

#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSR|=0x40;
// Wait for the AD conversion to complete
while ((ADCSR & 0x10)==0);
ADCSR|=0x10;
return ADCW;
}

void codegen (char x, char y)
{
_0=1, _1=1, _2=1, _P=0;

     if (y==0)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=0;
else if (y==1)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
else if (y==2)  _A=1,_B=1,_C=0,_D=1,_E=1,_F=0,_G=1;
else if (y==3)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=0,_G=1;
else if (y==4)  _A=0,_B=1,_C=1,_D=0,_E=0,_F=1,_G=1;
else if (y==5)  _A=1,_B=0,_C=1,_D=1,_E=0,_F=1,_G=1;
else if (y==6)  _A=1,_B=0,_C=1,_D=1,_E=1,_F=1,_G=1;
else if (y==7)  _A=1,_B=1,_C=1,_D=0,_E=0,_F=0,_G=0;
else if (y==8)  _A=1,_B=1,_C=1,_D=1,_E=1,_F=1,_G=1;
else if (y==9)  _A=1,_B=1,_C=1,_D=1,_E=0,_F=1,_G=1;
else            _A=0,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;

if (x==0) _0=0, _1=1, _2=1, _P=0;
if (x==1) _0=1, _1=0, _2=1, _P=1;
if (x==2) _0=1, _1=1, _2=0, _P=0;
delay_us(200);
}

void start()
{
// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=T
PORTA=0x00;
DDRA=0xFA;

// Port B initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
// State7=T State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
PORTB=0x00;
DDRB=0x7C;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFh
// OC1A output: Disconnected
// OC1B output: Disconnected
// Timer1 Overflow Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
PLLCSR=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCNT1=0x00;
OCR1A=0x00;
OCR1B=0x00;
OCR1C=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PA3, PA6, PA7 and PB4-7: Off
// Interrupt on any change on pins PB0-3: Off
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
ACSR=0x80;

// ADC initialization
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: Int., AREF discon.
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSR=0x86;
}

void main(void)
{
// Declare your local variables here
char i;

start();

while (1)
      {
      // Place your code here
      in = read_adc(0);
      in = in / 3;
      if (in >= 200) seg0=2, in=in - 200;
      else if (in >= 100) seg0=1, in=in - 100;
      else seg0=100;

      if      (in >= 90)    seg1=9, in=in-90;
      else if (in >= 80)    seg1=8, in=in-80;
      else if (in >= 70)    seg1=7, in=in-70;
      else if (in >= 60)    seg1=6, in=in-60;
      else if (in >= 50)    seg1=5, in=in-50;
      else if (in >= 40)    seg1=4, in=in-40;
      else if (in >= 30)    seg1=3, in=in-30;
      else if (in >= 20)    seg1=2, in=in-20;
      else if (in >= 10)    seg1=1, in=in-10;
      else                  seg1=0;

      if      (in == 9)     seg2=9;
      else if (in == 8)     seg2=8;
      else if (in == 7)     seg2=7;
      else if (in == 6)     seg2=6;
      else if (in == 5)     seg2=5;
      else if (in == 4)     seg2=4;
      else if (in == 3)     seg2=3;
      else if (in == 4)     seg2=2;
      else if (in == 5)     seg2=1;
      else                  seg2=0;

      for (i=0; i<60; i++)
        {
        codegen(0,seg0);
        codegen(1,seg1);
        codegen(2,seg2);
        };
      };
}








