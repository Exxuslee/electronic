/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <delay.h>


#define VREF 4600
#define SS PORTB.4
#define SCK PORTB.7
#define MISO PINB.6
#define M_PI 3.1415926535897
#define pol_perioda 0x32

// Declare your global variables here
unsigned int array1 [0x110], array2 [0x110];      //[OCR1A];
unsigned long int zero_amp;
unsigned int faza_zero, amp_max, amp_min;
unsigned int a;
unsigned char faza_max, faza_min;
unsigned char faza = 0xab;
unsigned char amplituda = 0xcd;


// 2 Wire bus interrupt service routine
interrupt [TWI] void twi_isr(void)
{
// Place your code here
TWDR = faza;
TWCR |= 0x84;
while (!(TWCR & 0x80));
TWDR = amplituda;
TWCR |= 0x84;
while (!(TWCR & 0x80));
TWCR |= 0x80;
      
for (a=0; a<=0xF9; a++)
    {
    array2[a] = array1[a]>>3;
    array2[a] = array2[a] & 0x03FF;
    array2[a] =(unsigned) (((unsigned long) array2[a] * VREF) / 1024L);
    };

amp_max = 2300;
amp_min = 2300;

    for (a=0; a<=0xF9; a++)
    {
    if (array2[a] >= amp_max)
        {
        faza_max = a;
        amp_max = array2[a];
        };
    if (array2[a] <= amp_min)
        {
        faza_min = a;
        amp_min = array2[a];
        };

    };
    
if (faza_max > faza_min)    faza_zero = (faza_max - faza_min) ;
if (faza_max < faza_min)    faza_zero = (faza_min - faza_max) ;
faza = faza_max;
amplituda = faza_min;

//#asm ("wdr")
return;
}

unsigned  read_adc(void)
{
unsigned result;
SS=0;
delay_us (1);
result=(unsigned) spi(0)<<8; 
result|=spi(0);
SS=1;
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
// Clock value: 2048,000 kHz
// Mode: CTC top=ICR1
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x1A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0xF9;
OCR1AH=0x00;
OCR1AL=0x00;
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
// SPI Clock Rate: 1024,000 kHz
// SPI Clock Phase: Cycle Half
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x51;
SPSR=0x00;

// 2 Wire Bus initialization
// Generate Acknowledge Pulse: On
// 2 Wire Bus Slave Address: 44h
// General Call Recognition: Off
// Bit Rate: 390,095 kHz
TWSR=0x00;
TWBR=0x0D;
TWAR=0x88;
TWCR=0x45;

zero_amp = 2300;
//for (a=0; a<=0x100; a++) array2[a]= a;


#asm ("sei")

while (1)
      {
      // Place your code here
      array1[TCNT1] = read_adc(); 
      delay_us (1);
//      #asm ("wdr")
      };
}
