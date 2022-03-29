#include <tiny13.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif

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
// Port B initialization
// Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
// State5=T State4=0 State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x10;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0,125 kHz
// Mode: Fast PWM top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x03;
TCCR0B=0x05;
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

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/1024k
// Watchdog Timer interrupt: Off
#pragma optsize-
WDTCR=0x39;
WDTCR=0x29;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

while (1)
      {
      // Place your code here
      if (TCNT0 == 0x00) PORTB.4=1;
      if (TCNT0 == 0x7F) PORTB.4=0;
      #asm("wdr");
      };
}
