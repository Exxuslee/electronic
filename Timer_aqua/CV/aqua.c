/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Aqua
Version :
Date    : 06.05.2012
Author  : NeVaDa
Company : MICROSOFT
Comments:


Chip type               : ATtiny13A
AVR Core Clock frequency: 4,800000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*****************************************************/

#include <tiny13a.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x20

unsigned char time;
unsigned long int i;

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
// Port B initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
// State5=T State4=T State3=T State2=T State1=T State0=1
PORTB=0x01;
DDRB=0x01;

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

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=0x80;
ADCSRB=0x00;

// ADC initialization
// ADC Clock frequency: 300,000 kHz
// ADC Bandgap Voltage Reference: Off
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
// Digital input buffers on ADC0: Off, ADC1: Off, ADC2: On, ADC3: Off
DIDR0&=0x03;
DIDR0|=0x2C;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

while (1)
      {
      PORTB=0x01;
      for (i=0; i<480; i++)    delay_ms(60000);   //480=8hours
      time = read_adc(2);
      for (i=0; i<time; i++)   delay_ms(60000);   //60.000
      PORTB=0x00;
      for (i=time; i<960; i++) delay_ms(60000);   //960=16hours
      };
}
