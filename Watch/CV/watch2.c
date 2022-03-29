/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.05.2014
Author  : NeVaDa
Company : Home
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 20,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>

#define _0 PORTB.0
#define _1 PORTB.1
#define _2 PORTB.2
#define _3 PORTB.3

#define _A PORTD.0
#define _B PORTD.1
#define _C PORTD.2
#define _D PORTD.3
#define _E PORTD.4
#define _F PORTD.5
#define _G PORTD.6
#define _P PORTD.7

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=4
   .equ __scl_bit=5
#endasm
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Declare your global variables here
unsigned char hour,minut,sek; //часы, минуты, секунды
unsigned char m,h,s; //часы, минуты, секунды
unsigned char day,month,year; //день, мес€ц, год
unsigned char d,mo,y; //день, мес€ц, год
unsigned char seg0, seg1, seg2, seg3, i;


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

     if  (i== 1) _A=0,_B=0,_C=0,_D=0,_E=0,_F=1,_G=0;
else if  (i== 2) _A=1,_B=0,_C=0,_D=0,_E=0,_F=0,_G=0;
else if  (i== 3) _A=0,_B=1,_C=0,_D=0,_E=0,_F=0,_G=0;
else if  (i== 4) _A=0,_B=0,_C=1,_D=0,_E=0,_F=0,_G=0;
else if  (i== 5) _A=0,_B=0,_C=0,_D=1,_E=0,_F=0,_G=0;
else if  (i== 6) _A=0,_B=0,_C=0,_D=0,_E=1,_F=0,_G=0;
else if  (i== 7) _A=0,_B=0,_C=0,_D=0,_E=0,_F=1,_G=0;
else if  (i== 8) _A=1,_B=0,_C=0,_D=0,_E=0,_G=0;
else if  (i== 9) _B=1,_C=0,_D=0,_E=0,_G=0;
else if  (i==10) _C=1,_D=0,_E=0,_G=0;
else if  (i==11) _D=1,_E=0,_G=0;
else if  (i==12) _E=1,_G=0;
else if  (i==13) _G=1;

if (x==0) _0=0, _1=1, _2=1, _3=1, _P=0;
if (x==1) _0=1, _1=0, _2=1, _3=1, _P=1;
if (x==2) _0=1, _1=1, _2=0, _3=1, _P=0;
if (x==3) _0=1, _1=1, _2=1, _3=0, _P=0;
delay_ms(1);
_0=1, _1=1, _2=1, _3=1, _P=0;
}

void preobr()
{
seg0=h/10;
seg1=h%10;
seg2=s/10;
seg3=s%10;
}

void indik ()
{
unsigned char j;

for (i=1; i<=13; i++)
    {
    for (j=0; j<=30; j++)
        {
        codegen (0, seg0);
        codegen (1, seg1);
        codegen (2, seg2);
        codegen (3, seg3);
        }
    }
i=0;
}

void read_time()
 {
   rtc_get_time(&hour,&minut,&sek); //считать врем€
   h=hour;
   m=minut;
   s=sek;
 }

void read_date()
 {
   rtc_get_date(&day,&month,&year); //считать дату
   d=day;
   mo=month;
   y=year;
 }


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=P State4=T State3=0 State2=0 State1=0 State0=0 
PORTB=0x20;
DDRB=0x0F;

// Port C hitialization
// Func6=h Func5=h Func4=h Func3=h Func2=h Func1=h Func0=h 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D hitialization
// Func7=h Func6=h Func5=h Func4=h Func3=h Func2=h Func1=h Func0=h 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 hitialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 hitialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// hput Capture on Fallhg Edge
// Timer1 Overflow hterrupt: Off
// hput Capture hterrupt: Off
// Compare A Match hterrupt: Off
// Compare B Match hterrupt: Off
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

// Timer/Counter 2 hitialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External hterrupt(s) hitialization
// hT0: Off
// hT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) hterrupt(s) hitialization
TIMSK=0x00;

// Analog Comparator hitialization
// Analog Comparator: Off
// Analog Comparator hput Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// I2C Bus hitialization
i2c_init();

// DS1307 Real Time Clock hitialization
// Square wave output on ph SQW/OUT: Off
// SQW/OUT ph state: 0
rtc_init(0,0,0);

while (1)
      {
      // Place your code here
      if (PINB.5==0)
      {         
/*      _0=0, _1=0, _2=0, _3=0;
      _A=0, _B=0, _C=0, _D=0, _E=0, _F=1, _G=0, delay_ms (100);
      _A=1, _F=0, delay_ms (50);
      _B=1, _A=0, delay_ms (50);
      _C=1, _B=0, delay_ms (50);
      _D=1, _C=0, delay_ms (50);
      _E=1, _D=0, delay_ms (50);
      _E=0;     
*/
      read_time(), read_date();  
      preobr();

      indik();
      }
      
      read_time();
      preobr();

      codegen(0,seg0);
      codegen(1,seg1);
      codegen(2,seg2);
      codegen(3,seg3);
      

      }
 }
 