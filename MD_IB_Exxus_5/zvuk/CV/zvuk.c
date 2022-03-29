/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.03.2010
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


#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// Declare your global variables here
unsigned char volume;
unsigned char amp, faza;
unsigned char a;

// USART Receiver buffer
char data;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
data=UDR;
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
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=0 State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x20;

// pitanie
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16384,000 kHz
// Mode: Fast PWM top=FFh
// OC0A output: Disconnected
// OC0B output: Non-Inverted PWM
//TCCR0A=0x23;
//TCCR0B=0x01;
//TCNT0=0x00;
//OCR0A=0x00;
//OCR0B=0x7F;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

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
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

volume = 0x7f;
amp = 0xf;
faza = 0xf;

// Global enable interrupts
#asm("sei")


while (1)
      {
      // Place your code here
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
      
      if      (amp == 0x00)        delay_ms (1600);      
      else if (amp == 0x01)        delay_ms (1500);
      else if (amp == 0x02)        delay_ms (1400);
      else if (amp == 0x03)        delay_ms (1300);
      else if (amp == 0x04)        delay_ms (1200);
      else if (amp == 0x05)        delay_ms (1100);
      else if (amp == 0x06)        delay_ms (1000);
      else if (amp == 0x07)        delay_ms (900);
      else if (amp == 0x08)        delay_ms (800);
      else if (amp == 0x09)        delay_ms (700);
      else if (amp == 0x0A)        delay_ms (600);
      else if (amp == 0x0B)        delay_ms (500);
      else if (amp == 0x0C)        delay_ms (400);
      else if (amp == 0x0D)        delay_ms (300);
      else if (amp == 0x0E)        delay_ms (200);
      else                         delay_ms (100);
      
      
      
      };
}











