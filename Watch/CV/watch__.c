/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
? Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
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
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
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


// SPI functions
#include <spi.h>
#define ADC_VREF_TYPE 0xE0

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}


// Declare your global variables here
unsigned char m,h,s; //????, ??????, ???????
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
seg0=m/10;
seg1=m%10;
seg2=s/10;
seg3=s%10;
}

void indik ()
{
unsigned char j;

for (i=1; i<=13; i++)
    {
    for (j=0; j<=10; j++)
        {
        codegen (0, seg0);
        codegen (1, seg1);
        codegen (2, seg2);
        codegen (3, seg3);
        }
    }
i=0;
}


// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
 s++;
 if (s>59)
        {
        s=0;
        m++;
        if (m>59)
                {
                m=0;
                h++;
                if (h>23) h=0;
                }
        }
 TCNT1=0;
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

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 4,096 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x03;
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

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x10;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// SPI initialization
// SPI Type: Slave
// SPI Clock Rate: 5000,000 kHz
// SPI Clock Phase: Cycle Half
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x40;
SPSR=0x00;

// Global enable interrupts
#asm("sei")

// ADC initialization
// ADC Clock frequency: 312,500 kHz
// ADC Voltage Reference: Int., cap. on AREF
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x86;

h=0, m=0, s=0;

while (1)
      {
/*      // Place your code here
      if (read_adc(4)>0xB3 && read_adc(5)==0x98)
      {
      preobr();
      indik();
      }

      preobr();

      codegen(0,seg0);
      codegen(1,seg1);
      codegen(2,seg2);
      codegen(3,seg3);
 */
 spi (0xaa);
      }
 }
