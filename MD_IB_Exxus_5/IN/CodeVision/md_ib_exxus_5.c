/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 07.03.2010
Author  : 
Company : 
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 16,384000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 512
*****************************************************/

#include <mega32.h>
#include <spi.h>


#define VREF 4600
#define SS PORTB.4
#define SCK PORTB.7
#define MISO PINB.6
#define M_PI 3.1415926535897
#define pol_perioda 0x7F

// Declare your global variables here
unsigned int array1 [0x012B];      //[OCR1A];
unsigned long int zero_amp, zero_faza;
unsigned int sum_amp;
unsigned int a;

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

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0xB0;

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
OCR1AL=0x2B;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
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

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2*4096,000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x54;
SPSR=0x01;

zero_amp = 2300;

for (a=0; a<=0x012B; a++)
   {
   array1[TCNT1] = TCNT1;
   };

while (1)
      {
      // Place your code here

      unsigned int zero_faza_max, zero_faza_min;


        
      for (a=0; a<=1000; a++)       array1[TCNT1] = read_adc();
      
      for (a=0; a<=254; a++)
          {
          if (array1[a] > array1[a++]) zero_faza_max = a;
          if (array1[a] < array1[a++]) zero_faza_min = a;
          };
      if (zero_faza_max > zero_faza_min)
        {
        zero_faza = (zero_faza_max - zero_faza_min) / 2;
        for (a=zero_faza; a <= zero_faza + pol_perioda; a++) sum_amp = sum_amp + array1[a];
        };
      
      if (zero_faza_max < zero_faza_min)
        {
        zero_faza = (zero_faza_min - zero_faza_max) / 2;
        for (a=zero_faza; a <= zero_faza + pol_perioda; a++) sum_amp = sum_amp + array1[a];
        sum_amp = sum_amp + zero_amp;
        };
      sum_amp = sum_amp / pol_perioda;
      
      };
}
