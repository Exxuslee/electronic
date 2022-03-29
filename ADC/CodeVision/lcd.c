/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.04.2009
Author  : 
Company : 
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
#include <lcd.h>
#include <stdio.h>
#include <math.h>
#include <spi.h>
#include <delay.h>

/* AD7896 reference voltage [mV] */
#define VREF 5000


/* AD7896 control signals PORTB bit allocation */
#define NCONVST PORTB.0

// Declare your global variables here
      char asd_asd[20];

unsigned  read_adc(void)
{
unsigned  result;
/* start conversion in mode 1, (high sampling performance) */
NCONVST=0;
/* read the MSB using SPI */
result=(unsigned) spi(0)<<8; 
/* read the LSB using SPI and combine with MSB */
result|=spi(0);
result=result>>3;
result=result&0x03FF;
/* calculate the voltage in [mV] */
result=(unsigned) (((unsigned long) result*VREF)/1024L);

NCONVST=1;
/* return the measured voltage */
return result;
}


void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=0 State2=0 State1=T State0=T 
PORTB=0x00;
DDRB=0x25;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
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
TCCR0=0x00;
TCNT0=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 2000,000 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x54;
SPSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;


// LCD module initialization
lcd_init(16);

      lcd_gotoxy(0,0);
      sprintf(asd_asd, "Hello");
      lcd_puts(asd_asd);

while (1)
      {
      // Place your code here
      lcd_gotoxy(0,0);
      sprintf(asd_asd, "Hello");
      lcd_puts(asd_asd);
      lcd_gotoxy(0,1);
      sprintf(asd_asd,"Uadc=%4u mV",read_adc());
      lcd_puts(asd_asd);
      delay_ms(10);     
      };
}
