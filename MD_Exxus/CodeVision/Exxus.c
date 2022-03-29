/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 24.04.2009
Author  : 
Company : 
Comments: 


Chip type           : ATmega8535
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 128
*****************************************************/

#include <mega8535.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm
#include <lcd.h>
#include <stdio.h>
#include <delay.h>
#include <math.h>

#define ADC_VREF_TYPE 0x60

unsigned int code_symbol;
unsigned int amplituda_1, faza_1, amplituda_2, faza_2; 
bit cycle;


// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
// Place your code here
amplituda_1=TCNT1;
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0xF9;         //TCNT0=0xE1;
// Place your code here
faza_1=TCNT1;
cycle=1;
}

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


// Declare your global variables here
char string_LCD_1[20], string_LCD_2[20];
unsigned int zero_amplituda, zero_faza, gnd_amplituda, gnd_faza;
unsigned char vol, bar;
unsigned char viz_amplituda, viz_faza;
unsigned char batt_celoe, batt_drob;
bit kn1, kn2, kn3, kn4, kn5, kn6;
    
void batt_zarqd(void)
    {
    unsigned char temp;
    temp=read_adc(3);
    batt_celoe=temp/10;
    batt_drob=temp%10;
    }

void kn_klava(void)
    {
    kn1=0;
    kn2=0;
    kn3=0;
    kn4=0;
    kn5=0;
    kn6=0;
    DDRD.0=1;
    PORTD.0=0;
    if (PIND.1==0 && PIND.2==0) kn1=1;
    if (PIND.1==1 && PIND.2==0) kn2=1;
    DDRD.0=0;
    DDRD.1=1;
    PORTD.0=1;
    PORTD.1=0;
    if (PIND.0==1 && PIND.2==0) kn3=1;
    if (PIND.0==0 && PIND.2==0) kn4=1;
    DDRD.1=0;
    DDRD.2=1;
    PORTD.1=1;
    PORTD.2=0;
    if (PIND.0==1 && PIND.1==0) kn5=1;
    if (PIND.0==0 && PIND.1==1) kn6=1;
    DDRD.2=0;
    PORTD.2=1;
    }
    
void lcd_disp(void)
    {
    if (kn1==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">>> Volume + <<<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "       %d      ", vol);
        lcd_puts (string_LCD_2);
        return;
        };
    if (kn2==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">>> Volume - <<<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "       %d      ", vol);
        lcd_puts (string_LCD_2);
        return;
        }; 
    if (kn3==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">> Barrier +  <<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "       %d      ", bar);
        lcd_puts (string_LCD_2);
        return;
        }; 
    if (kn4==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">> Barrier -  <<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "       %d      ", bar);
        lcd_puts (string_LCD_2);
        return;
        }; 
    if (kn5==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">>>> Ground <<<<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "  %x    %x  ", gnd_amplituda, gnd_faza);
        lcd_puts (string_LCD_2);
        return;
        };
    if (kn6==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">>>>> Zero <<<<<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "  %x    %x  ", zero_amplituda, zero_faza);
        lcd_puts (string_LCD_2);
        return;
        };   
    lcd_gotoxy (0,0);
    if (viz_amplituda==0)  sprintf (string_LCD_1, "           %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==1)  sprintf (string_LCD_1, "ÿ          %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==2)  sprintf (string_LCD_1, "ÿÿ         %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==3)  sprintf (string_LCD_1, "ÿÿÿ        %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==4)  sprintf (string_LCD_1, "ÿÿÿÿ       %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==5)  sprintf (string_LCD_1, "ÿÿÿÿÿ      %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==6)  sprintf (string_LCD_1, "ÿÿÿÿÿÿ     %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==7)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ    %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==8)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ   %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==9)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ  %d.%dV", batt_celoe, batt_drob);
    if (viz_amplituda==10) sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ %d.%dV", batt_celoe, batt_drob);
    lcd_puts (string_LCD_1);
    lcd_gotoxy (0,1);
    if (viz_faza==0)  sprintf (string_LCD_2, "|-----#-----|   ");
    if (viz_faza==1)  sprintf (string_LCD_2, "|----#|-----|   ");
    if (viz_faza==2)  sprintf (string_LCD_2, "|---#-|-----|   ");
    if (viz_faza==3)  sprintf (string_LCD_2, "|--#--|-----|   ");
    if (viz_faza==4)  sprintf (string_LCD_2, "|-#---|-----|   ");
    if (viz_faza==5)  sprintf (string_LCD_2, "|#----|-----|   ");
    if (viz_faza==6)  sprintf (string_LCD_2, "|-----|#----|   ");
    if (viz_faza==7)  sprintf (string_LCD_2, "|-----|-#---|   ");
    if (viz_faza==8)  sprintf (string_LCD_2, "|-----|--#--|   ");
    if (viz_faza==9)  sprintf (string_LCD_2, "|-----|---#-|   ");
    if (viz_faza==10) sprintf (string_LCD_2, "|-----|----#|   ");
    lcd_puts (string_LCD_2);    
    }

void volume(void)
    {
    if (kn1==1) vol++;
    if (kn2==1) vol--;
    while (kn1==1 || kn2==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }

void barrier(void)
    {
    if (kn3==1) bar++;
    if (kn4==1) bar--;
    while (kn3==1 || kn4==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }

void ground(void)
    {
    gnd_amplituda=amplituda_1/amplituda_2;
    gnd_faza=faza_1/faza_2;
    }

void zero(void)
    {
    zero_amplituda=amplituda_1;
    zero_faza=faza_1;
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
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x80;

// Timer/Counter 0 initialization
// Clock source: T0 pin Falling Edge
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x06;
TCNT0=0xF9;         // =0xE1
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x01;
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
// Clock value: 62,500 kHz
// Mode: Fast PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x6D;
TCNT2=0x00;
OCR2=0x0A;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// Analog Comparator initialization
// Analog Comparator: On
// Interrupt on Falling Output Edge
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x0A;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC High Speed Mode: Off
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;
SFIOR&=0xEF;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "   v0.1   ^_^   ");
lcd_puts (string_LCD_2);
delay_ms (500);

while (1)
    {
    while (cycle==0);
    code_symbol=TCNT1;
    kn_klava();
    if (kn1==1 || kn2 ==1) volume();
    if (kn3==1 || kn4 ==1) barrier();    
    if (kn5==1) ground();  
    if (kn6==1) zero();
    viz_amplituda= (amplituda_1-zero_amplituda) - gnd_amplituda*(amplituda_2-zero_amplituda);
    viz_faza= (faza_1-zero_faza) - gnd_faza*(faza_2-zero_faza);    
    batt_zarqd();
    lcd_disp();
    cycle=0;
    };
}

