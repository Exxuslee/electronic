/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 18.04.2010
Author  : 
Company : 
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 16,384000 MHz
Memory model        : Tiny
External RAM size   : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>
#include <stdio.h>

#define XY PORTB.7 

bit kn1, kn2, kn3, kn4, kn5, kn6;
char on1, ona, onb;
char data;
unsigned char amp, faza;
unsigned char a;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
data=UDR;
}

// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
PORTB.7 = on1;
if (on1 == 0) on1=1;
else on1=0;
}

// Timer 1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
PORTB.3 = ona;
if (ona == 0) ona=1;
else ona=0;
}

// Timer 1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here
PORTB.4 = onb;
if (onb == 0) onb=1;
else onb=0;
}

void kn_klava(void)
{
      kn1=0;
      kn2=0;
      kn3=0;
      kn4=0;
      kn5=0;
      kn6=0;
      DDRD.2=1;
      PORTD.2=0;
      delay_ms (5);    
      if (PIND.3==0 && PIND.4==0) kn1=1;
      if (PIND.3==1 && PIND.4==0) kn2=1;
      DDRD.2=0;
      DDRD.3=1;
      PORTD.2=1;
      PORTD.3=0;
      delay_ms (5);
      if (PIND.2==1 && PIND.4==0) kn3=1;
      if (PIND.2==0 && PIND.4==0) kn4=1;
      DDRD.3=0;
      DDRD.4=1;
      PORTD.3=1;
      PORTD.4=0;
      delay_ms (5);
      if (PIND.2==1 && PIND.3==0) kn5=1;
      if (PIND.2==0 && PIND.3==1) kn6=1;
      DDRD.4=0;
      PORTD.4=1;
}

// Declare your global variables here

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
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=T State0=T 
PORTB=0x00;
DDRB=0x9C;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x5E;
DDRD=0x60;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16384,000 kHz
// Mode: Fast PWM top=FFh
// OC0A output: Non-Inverted PWM
// OC0B output: Disconnected
TCCR0A=0x83;
TCCR0B=0x01;
OCR0A=0xE0;
OCR0B=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 16384,000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: On
TCCR1A=0x02;
TCCR1B=0x19;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x03;
ICR1L=0xC0;
OCR1AH=0x00;
OCR1AL=0x10;
OCR1BH=0x01;
OCR1BL=0xF0;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0xE0;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x08;

// Analog Comparator initialization
// Analog Comparator: On
// Digital input buffers on AIN0: On, AIN1: On
DIDR=0x00;
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x00;

// Global enable interrupts
#asm("sei")

ona=1;

while (1)
      {
      // Place your code here
      kn_klava();

      if (kn1==1)       ICR1++;
      if (kn2==1)       ICR1--;
      if (kn3==1)
        {
        OCR1A++;
        if (OCR1A > ICR1) OCR1A = 0;
        };
      if (kn4==1)
        {
        OCR1A--;
        if (OCR1A > ICR1) OCR1A = ICR1;
        };        
      if (kn5==1)
        {
        OCR1B++;
        if (OCR1B > ICR1) OCR1B = 0;
        };        
      if (kn6==1)
        {
        OCR1B--;
        if (OCR1B > ICR1) OCR1B = ICR1;
        };        
      
      amp = data >> 4;
      faza = data & 0x0F;
      
      for (a=0; a<100; a++)
        {
        if (faza >= 0x07)
            {
            PORTD.5 = 1;
            delay_us (100);
            PORTD.5 = 0;
            delay_us (100);
            }
        if (faza < 0x07)
            {
            PORTD.5 = 1;
            delay_us (150);
            PORTD.5 = 0;
            delay_us (150);
            };  
        };            
      if      (amp == 0x00)        delay_ms (999);      
      else if (amp == 0x01)        delay_ms (800);
      else if (amp == 0x02)        delay_ms (750);
      else if (amp == 0x03)        delay_ms (700);
      else if (amp == 0x04)        delay_ms (650);
      else if (amp == 0x05)        delay_ms (600);
      else if (amp == 0x06)        delay_ms (550);
      else if (amp == 0x07)        delay_ms (500);
      else if (amp == 0x08)        delay_ms (450);
      else if (amp == 0x09)        delay_ms (400);
      else if (amp == 0x0A)        delay_ms (350);
      else if (amp == 0x0B)        delay_ms (300);
      else if (amp == 0x0C)        delay_ms (250);
      else if (amp == 0x0D)        delay_ms (200);
      else if (amp == 0x0E)        delay_ms (150);
      else                         delay_ms (100);      
      
      if (ACSR & 0x20) OCR0A--; 
      };
}
