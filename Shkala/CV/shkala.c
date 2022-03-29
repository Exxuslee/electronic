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
Company : MICROSOFT
Comments:


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x40
#define _0 PORTB.5
#define _1 PORTB.6
#define _2 PORTB.7
#define _3 PORTB.0
#define _4 PORTB.1
#define _5 PORTB.2
#define _A PORTC.0
#define _B PORTC.1
#define _C PORTC.2
#define _D PORTC.3
#define _E PORTC.4
#define _F PORTC.5
#define _G PORTC.6
#define _P PORTC.7


// Declare your global variables here
unsigned char seg0, seg1, seg2, seg3, seg4, seg5, i, ;
unsigned int in_0=0, in_1=0, in_2=0, disp, dis;
float cor=1.04, y_old=0, y_old2=0;

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

void codegen (char x, char y)
{
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
else if (x==1) _0=1, _1=0, _2=1, _P=1;
else           _0=1, _1=1, _2=0, _P=0;

delay_us(100);
_0=1, _1=1, _2=1;
return;
}

void codegen2 (char x, char y)
{
     if (y== 0)  PORTC=0x00, PORTD=0x00;
else if (y== 1)  PORTC=0x00, PORTD=0x01;
else if (y== 2)  PORTC=0x00, PORTD=0x03;
else if (y== 3)  PORTC=0x00, PORTD=0x07;
else if (y== 4)  PORTC=0x00, PORTD=0x0F;
else if (y== 5)  PORTC=0x00, PORTD=0x1F;
else if (y== 6)  PORTC=0x00, PORTD=0x3F;
else if (y== 7)  PORTC=0x00, PORTD=0x7F;
else if (y== 8)  PORTC=0x00, PORTD=0xFF;
else if (y== 9)  PORTC=0x01, PORTD=0xFF;
else if (y==10)  PORTC=0x03, PORTD=0xFF;
else if (y==11)  PORTC=0x07, PORTD=0xFF;
else if (y==12)  PORTC=0x0F, PORTD=0xFF;
else if (y==13)  PORTC=0x1F, PORTD=0xFF;
else if (y==14)  PORTC=0x3F, PORTD=0xFF;
else if (y==15)  PORTC=0x7F, PORTD=0xFF;
else             PORTC=0xFF, PORTD=0xFF;

if(x==3)
{
if (y_old < y) y_old = y;
else y_old = y_old-0.002;

     if (y_old >=16)  PORTC.7=1;
else if (y_old >=15)  PORTC.6=1;
else if (y_old >=14)  PORTC.5=1;
else if (y_old >=13)  PORTC.4=1;
else if (y_old >=12)  PORTC.3=1;
else if (y_old >=11)  PORTC.2=1;
else if (y_old >=10)  PORTC.1=1;
else if (y_old >= 9)  PORTC.0=1;
else if (y_old >= 8)  PORTD.7=1;
else if (y_old >= 7)  PORTD.6=1;
else if (y_old >= 6)  PORTD.5=1;
else if (y_old >= 5)  PORTD.4=1;
else if (y_old >= 4)  PORTD.3=1;
else if (y_old >= 3)  PORTD.2=1;
else if (y_old >= 2)  PORTD.1=1;
else if (y_old >= 1)  PORTD.0=1;
};

if(x==4)
{

if (y_old2 < y) y_old2 = y;
else y_old2 = y_old2-0.002;

     if (y_old2 >=16)  PORTC.7=1;
else if (y_old2 >=15)  PORTC.6=1;
else if (y_old2 >=14)  PORTC.5=1;
else if (y_old2 >=13)  PORTC.4=1;
else if (y_old2 >=12)  PORTC.3=1;
else if (y_old2 >=11)  PORTC.2=1;
else if (y_old2 >=10)  PORTC.1=1;
else if (y_old2 >= 9)  PORTC.0=1;
else if (y_old2 >= 8)  PORTD.7=1;
else if (y_old2 >= 7)  PORTD.6=1;
else if (y_old2 >= 6)  PORTD.5=1;
else if (y_old2 >= 5)  PORTD.4=1;
else if (y_old2 >= 4)  PORTD.3=1;
else if (y_old2 >= 3)  PORTD.2=1;
else if (y_old2 >= 2)  PORTD.1=1;
else if (y_old2 >= 1)  PORTD.0=1;
};

     if (x==3) _3=0, _4=1, _5=1;
else if (x==4) _3=1, _4=0, _5=1;
else           _3=1, _4=1, _5=0;

delay_us(200);
_3=1, _4=1, _5=1;
return;
}

void codegen3 (char x, char y)
{
     if (y== 0)  PORTC=0x00, PORTD=0x00;
else if (y== 1)  PORTC=0x00, PORTD=0x01;
else if (y== 2)  PORTC=0x00, PORTD=0x02;
else if (y== 3)  PORTC=0x00, PORTD=0x04;
else if (y== 4)  PORTC=0x00, PORTD=0x08;
else if (y== 5)  PORTC=0x00, PORTD=0x10;
else if (y== 6)  PORTC=0x00, PORTD=0x20;
else if (y== 7)  PORTC=0x00, PORTD=0x40;
else if (y== 8)  PORTC=0x00, PORTD=0x80;
else if (y== 9)  PORTC=0x01, PORTD=0x00;
else if (y==10)  PORTC=0x02, PORTD=0x00;
else if (y==11)  PORTC=0x04, PORTD=0x00;
else if (y==12)  PORTC=0x08, PORTD=0x00;
else if (y==13)  PORTC=0x10, PORTD=0x00;
else if (y==14)  PORTC=0x20, PORTD=0x00;
else if (y==15)  PORTC=0x40, PORTD=0x00;
else             PORTC=0x80, PORTD=0x00;

     if (x==3) _3=0, _4=1, _5=1;
else if (x==4) _3=1, _4=0, _5=1;
else           _3=1, _4=1, _5=0;

delay_us(200);
_3=1, _4=1, _5=1;
return;
}

void read(void)
{
in_0 = read_adc(0);
in_1 = read_adc(1);
in_2 = read_adc(2);
}

void preobr(float a,float b, float c)
{
a = a / cor;
b = b / cor;
c = c / cor;

     if (a >= 960)   seg3=16;
else if (a >= 896)   seg3=15;
else if (a >= 832)   seg3=14;
else if (a >= 768)   seg3=13;
else if (a >= 704)   seg3=12;
else if (a >= 640)   seg3=11;
else if (a >= 576)   seg3=10;
else if (a >= 512)   seg3=9;
else if (a >= 448)   seg3=8;
else if (a >= 384)   seg3=7;
else if (a >= 320)   seg3=6;
else if (a >= 256)   seg3=5;
else if (a >= 192)   seg3=4;
else if (a >= 128)   seg3=3;
else if (a >= 64 )   seg3=2;
else if (a >= 32 )   seg3=1;
else                 seg3=0;

     if (b >= 960)   seg4=16;
else if (b >= 896)   seg4=15;
else if (b >= 832)   seg4=14;
else if (b >= 768)   seg4=13;
else if (b >= 704)   seg4=12;
else if (b >= 640)   seg4=11;
else if (b >= 576)   seg4=10;
else if (b >= 512)   seg4=9;
else if (b >= 448)   seg4=8;
else if (b >= 384)   seg4=7;
else if (b >= 320)   seg4=6;
else if (b >= 256)   seg4=5;
else if (b >= 192)   seg4=4;
else if (b >= 128)   seg4=3;
else if (b >= 64 )   seg4=2;
else if (b >= 32 )   seg4=1;
else                 seg4=0;

     if (c >= 960)   seg5=16;
else if (c >= 896)   seg5=15;
else if (c >= 832)   seg5=14;
else if (c >= 768)   seg5=13;
else if (c >= 704)   seg5=12;
else if (c >= 640)   seg5=11;
else if (c >= 576)   seg5=10;
else if (c >= 512)   seg5=9;
else if (c >= 448)   seg5=8;
else if (c >= 384)   seg5=7;
else if (c >= 320)   seg5=6;
else if (c >= 256)   seg5=5;
else if (c >= 192)   seg5=4;
else if (c >= 128)   seg5=3;
else if (c >= 64 )   seg5=2;
else if (c >= 32 )   seg5=1;
else                 seg5=0;
}

void preobr2 (float a)
{
     if (a >= 900)   seg0=9, a=a - 900;
else if (a >= 800)   seg0=8, a=a - 800;
else if (a >= 700)   seg0=7, a=a - 700;
else if (a >= 600)   seg0=6, a=a - 600;
else if (a >= 500)   seg0=5, a=a - 500;
else if (a >= 400)   seg0=4, a=a - 400;
else if (a >= 300)   seg0=3, a=a - 300;
else if (a >= 200)   seg0=2, a=a - 200;
else if (a >= 100)   seg0=1, a=a - 100;
else                 seg0=10;

if      (a >= 90)    seg1=9, a=a-90;
else if (a >= 80)    seg1=8, a=a-80;
else if (a >= 70)    seg1=7, a=a-70;
else if (a >= 60)    seg1=6, a=a-60;
else if (a >= 50)    seg1=5, a=a-50;
else if (a >= 40)    seg1=4, a=a-40;
else if (a >= 30)    seg1=3, a=a-30;
else if (a >= 20)    seg1=2, a=a-20;
else if (a >= 10)    seg1=1, a=a-10;
else                 seg1=0;

if      (a >= 9)     seg2=9;
else if (a >= 8)     seg2=8;
else if (a >= 7)     seg2=7;
else if (a >= 6)     seg2=6;
else if (a >= 5)     seg2=5;
else if (a >= 4)     seg2=4;
else if (a >= 3)     seg2=3;
else if (a >= 2)     seg2=2;
else if (a >= 1)     seg2=1;
else                 seg2=0;
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
PORTA=0xE0;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 250,000 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x85;

while (1)
      {
      // Place your code here
      read();
      i++;
      if (PINA.5==0) dis=0;
      if (PINA.6==0) dis=1;
      if (PINA.7==0) dis=2;
      if      (dis==0) disp=in_0;
      else if (dis==1) disp=in_1;
      else             disp=in_2;

      if (i >= 50) preobr(in_0, in_1, in_2), preobr2(disp), i=0;

      codegen(0,seg0);
      codegen(1,seg1);
      codegen(2,seg2);
      codegen2(3,seg3);
      codegen2(4,seg4);
      codegen3(5,seg5);
      };
}