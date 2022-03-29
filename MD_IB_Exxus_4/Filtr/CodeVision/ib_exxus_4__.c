/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 29.01.2010
Author  :
Company :
Comments:


Chip type           : ATmega64
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 65536
Ext. SRAM wait state: 0
Data Stack size     : 1024
*****************************************************/

#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x03 ;PORTE
#endasm
#include <lcd.h>
#include <stdio.h>
#include <spi.h>
#include <delay.h>
#include <mem.h>
#include <math.h>

#define VREF 4600
#define SS PORTB.0
#define SCK PORTB.1
#define MISO PINB.3
#define M_PI (3.1415926535897932384626433832795)


// Declare your global variables here

unsigned int array1 [0x100];      //[0x07CF][OCR1A];
unsigned int array_t [0x100];
unsigned int array2 [0x100];
unsigned int a;

unsigned int T = 8;

struct Complex
    {
    float re, im;
    } array3[0x100];


//This is array exp(-2*pi*j/2^n) for n= 1,...,32
//exp(-2*pi*j/2^n) = Complex( cos(2*pi/2^n), -sin(2*pi/2^n) )

unsigned  read_adc(void)
{
unsigned result;

SS=0;
result=(unsigned) spi(0)<<8;
result|=spi(0);
SS=1;
result=result>>3;
result=result&0x03FF;
result=(unsigned) (((unsigned long) result*VREF)/1024L);

return result;
}

unsigned int reverse(unsigned int I, int T)
{
    int Shift = T - 1;
    unsigned int LowMask = 1;
    unsigned int HighMask = 1 << Shift;
    unsigned int R;
    for(R = 0; Shift >= 0; LowMask <<= 1, HighMask >>= 1, Shift -= 2)
        R |= ((I & LowMask) << Shift) | ((I & HighMask) >> Shift);
    return R;
}


void main(void)
{
// Declare your local variables here
#asm("wdr");

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0
PORTB=0x00;
DDRB=0x27;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In
// State4=T State3=T State2=T State1=T State0=T
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Mode: CTC top=OCR1A
// OC1A output: Toggle
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x40;
TCCR1B=0x0A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x01;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer 3 Stopped
// Mode: Normal top=FFFFh
// Noise Canceler: Off
// Input Capture on Falling Edge
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Timer 3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// External SRAM page configuration:
//              -              / 0000h - 7FFFh
// Lower page wait state(s): None
// Upper page wait state(s): None
MCUCR=0x80;
XMCRA=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
ETIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2*2000,000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x54;
SPSR=0x01;

while (1)
      {
      // Place your code here
      unsigned int I;
      unsigned int J;
      unsigned int N;
     // unsigned int Wre, Wim;
      float Wre, Wim;
      unsigned int Nd2, k, m, mpNd2;
      float Temp;

      unsigned int Nmax = 0x100;

      for (a=0; a<=255; a++)   array1[TCNT1] = read_adc();

      for (a=0; a<=255; a++) array_t[a] = a ;     //sin(2 * M_PI / a);

      for(I = 0; I < Nmax; I++)
        {
        J = reverse(I,T);           // reverse переставляет биты в I в обратном порядке
        array2[I] = array_t[J];
        array2[J] = array_t[I];
        };

      for (a=0; a<=255; a++) array3[a].re = array_t[a];

      for(N = 2, Nd2 = 1; N <= Nmax-1; Nd2 = N, N+=N)
        {
        for(k = 0; k < Nd2; k++)
            {
       	    Wre = cos(2*M_PI*k/N);
            Wim = - sin(2*M_PI*k/N);
            for(m = k; m < Nmax-1; m += N)
                {
                mpNd2 = m + Nd2;
                Temp = Wre * array3[mpNd2].re;
                array3[mpNd2].re = array3[m].re - Temp;
                array3[m].re += Temp;
                Temp = Wim * array3[mpNd2].im;
                array3[mpNd2].im = array3[m].im - Temp;
                array3[m].im += Temp;
                };
            };
        };

      #asm("wdr");

      };
}
