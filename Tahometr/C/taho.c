/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 19.01.2009
Author  : 
Company : 
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 1,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x60
#define SV_Y1 PORTB.0 
#define SV_Y2 PORTD.6 
#define SV_Y3 PORTB.2 
#define SV_G1 PORTD.0 
#define SV_G2 PORTD.1 
#define SV_G3 PORTC.4

unsigned int rezhim=1;
unsigned int time=0;
unsigned int temp=0; 
unsigned int temp2=0; 

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
rezhim++;
if (rezhim==7) rezhim=1;
while (PIND.5==0)
    {
    if (rezhim==1)
        {
        SV_Y1=1;
        SV_Y2=0;
        SV_Y3=0;
        SV_G1=0;
        SV_G2=0;
        SV_G3=0;
        };
    if (rezhim==2)
        {
        SV_Y1=0;
        SV_Y2=1;
        SV_Y3=0;
        SV_G1=0;
        SV_G2=0;
        SV_G3=0;
        };
    if (rezhim==3)
        {
        SV_Y1=0;
        SV_Y2=0;
        SV_Y3=1;
        SV_G1=0;
        SV_G2=0;
        SV_G3=0;
        };
    if (rezhim==4)
        {
        SV_Y1=0;
        SV_Y2=0;
        SV_Y3=0;
        SV_G1=1;
        SV_G2=0;
        SV_G3=0;
        };
    if (rezhim==5)
        {
        SV_Y1=0;
        SV_Y2=0;
        SV_Y3=0;
        SV_G1=0;
        SV_G2=1;
        SV_G3=0;
        };
    if (rezhim==6)
        {
        SV_Y1=0;
        SV_Y2=0;
        SV_Y3=0;
        SV_G1=0;
        SV_G2=0;
        SV_G3=1;
        };               
    TCNT1H=0x00;
    TCNT1L=0x00;
    };
};


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
};

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x07;

// Port C initialization
// Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=0 State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x10;

// Port D initialization
// Func7=Out Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=0 State6=0 State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTD=0x00;
DDRD=0xC3;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;
    
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 0,977 kHz
// Mode: CTC top=OCR1A
// OC1A output: Toggle
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x48;
TCCR1B=0x0D;
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
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Low level
GICR|=0x80;
MCUCR=0x00;
GIFR=0x80;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 500,000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x81;


// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      temp=rezhim*85;
      temp2=read_adc(0)/3;
      time=temp+temp2;
      SV_G1=1;
      SV_G2=1;
      SV_G3=1;
      SV_Y1=0;
      SV_Y2=0;
      SV_Y3=0;      
      delay_ms (time);
      SV_G1=0;
      SV_G2=0;
      SV_G3=0;
      SV_Y1=1;
      SV_Y2=1;
      SV_Y3=1;      
      delay_ms (time);
      };
};
