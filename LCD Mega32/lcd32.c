/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 04.08.2009
Author  : 
Company : 
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 512
*****************************************************/

#include <mega32.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>
#include <stdio.h>
#include <delay.h>
#include <math.h>



// Declare your global variables here
char string_LCD_1[20], string_LCD_2[20];
#define ADC_VREF_TYPE 0x60

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

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x80;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xF0;

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
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=OCR1A
// OC1A output: Discon.
// OC1B output: Non-Inv.
// Noise Canceler: On
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x07;
OCR1AL=0xCE;
OCR1BH=0x03;
OCR1BL=0xE7;

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
// Analog Comparator: On
// Analog Comparator Input Capture by Timer/Counter 1: On
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 250,000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x85;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
WDTCR=0x00;

// Global enable interrupts
#asm("sei")

    #asm("wdr");
// LCD module initialization
lcd_init(16);
    #asm("wdr");
      
while (1)
      {      
      char Y, X;
      float st_A, st_F;

      Y = 0x10;
      X = 0x10;
      st_A = Y;
      st_F = asin((float)X/Y);          
           
      lcd_gotoxy (0,0);
      sprintf (string_LCD_1, "%3.0f %+3.2f ", st_A, st_F);
      lcd_puts (string_LCD_1);
      lcd_gotoxy (0,1);
      sprintf (string_LCD_2, "%x %x  ", Y, X);
      lcd_puts (string_LCD_2);

      delay_ms (1);
      #asm("wdr");
      };
}

/*
while (1)
      {      
      float yy;
      Y = 0;
      Y = ((unsigned int)ICR1H<<8)|ICR1L;
      yy = (float)Y/0x07CE*6.28-3.14;

      X = read_adc(0);

      PORTD.7=1;
      PORTD.7=0;           
           
      lcd_gotoxy (0,0);
      sprintf (string_LCD_1, "%2.2f  ", yy);
      lcd_puts (string_LCD_1);
      lcd_gotoxy (0,1);
      sprintf (string_LCD_2, "%x  ", Y);
      lcd_puts (string_LCD_2);

      delay_ms (1);
      #asm("wdr");
      };
*/