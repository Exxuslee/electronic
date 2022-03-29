/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : MD_Exxus_32
Version : 0.2
Date    : 14.05.2009
Author  : Exxus
Company : Haos
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>
#include <lcd.h>
#include <stdio.h>
#include <delay.h>
#include <math.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm

#define ADC_VREF_TYPE 0x20
#define light PORTC.5

unsigned int amplituda_new, faza_new, amplituda_old, faza_old; 
bit cycle;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0xE0;                                                       //koli4estvo periodov
// Place your code here
faza_new=TCNT1;
cycle=1;
}

// Timer 2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Place your code here
TCNT1H=0x00;
TCNT1L=0x00;
}

// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
// Place your code here
amplituda_new=TCNT1;
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
    DDRD.3=1;
    PORTD.3=0;
    if (PIND.4==0 && PIND.5==0) kn1=1;
    if (PIND.4==1 && PIND.5==0) kn2=1;
    DDRD.3=0;
    DDRD.4=1;
    PORTD.3=1;
    PORTD.4=0;
    if (PIND.3==1 && PIND.5==0) kn3=1;
    if (PIND.3==0 && PIND.5==0) kn4=1;
    DDRD.4=0;
    DDRD.5=1;
    PORTD.4=1;
    PORTD.5=0;
    if (PIND.3==1 && PIND.4==0) kn5=1;
    if (PIND.3==0 && PIND.4==1) kn6=1;
    DDRD.5=0;
    PORTD.5=1;
    }
    
void lcd_disp(void)
    {
    if (kn1==1 || kn2==1)
        {
        light=1;
        lcd_gotoxy (14,1);
        sprintf (string_LCD_2, "V%d", vol);
        lcd_puts (string_LCD_2);
        return;
        };
    if (kn3==1 || kn4==1)
        {
        light=1;
        lcd_gotoxy (14,1);
        sprintf (string_LCD_2, "B%d", bar);
        lcd_puts (string_LCD_2);
        return;
        }; 
    if (kn5==1)
        {
        light=1;
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
        light=1;
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">>>>> Zero <<<<<");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "  %x    %x  ", zero_amplituda, zero_faza);
        lcd_puts (string_LCD_2);
        return;
        };   
    lcd_gotoxy (0,0);
    if (viz_amplituda==0)  sprintf (string_LCD_1, "           %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==1)  sprintf (string_LCD_1, "ÿ          %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==2)  sprintf (string_LCD_1, "ÿÿ         %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==3)  sprintf (string_LCD_1, "ÿÿÿ        %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==4)  sprintf (string_LCD_1, "ÿÿÿÿ       %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==5)  sprintf (string_LCD_1, "ÿÿÿÿÿ      %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==6)  sprintf (string_LCD_1, "ÿÿÿÿÿÿ     %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==7)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ    %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==8)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ   %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==9)  sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ  %d.%dV ", batt_celoe, batt_drob);
    if (viz_amplituda==10) sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ %d.%dV ", batt_celoe, batt_drob);
    lcd_puts (string_LCD_1);
    lcd_gotoxy (0,1);
    if (viz_faza==0)  sprintf (string_LCD_2, "Û-----#-----Ü   ");
    if (viz_faza==1)  sprintf (string_LCD_2, "Û----#I-----Ü   ");
    if (viz_faza==2)  sprintf (string_LCD_2, "Û---#-I-----Ü   ");
    if (viz_faza==3)  sprintf (string_LCD_2, "Û--#--I-----Ü   ");
    if (viz_faza==4)  sprintf (string_LCD_2, "Û-#---I-----Ü   ");
    if (viz_faza==5)  sprintf (string_LCD_2, "Û#----I-----Ü   ");
    if (viz_faza==6)  sprintf (string_LCD_2, "Û-----I#----Ü   ");
    if (viz_faza==7)  sprintf (string_LCD_2, "Û-----I-#---Ü   ");
    if (viz_faza==8)  sprintf (string_LCD_2, "Û-----I--#--Ü   ");
    if (viz_faza==9)  sprintf (string_LCD_2, "Û-----I---#-Ü   ");
    if (viz_faza==10) sprintf (string_LCD_2, "Û-----I----#Ü   ");
    lcd_puts (string_LCD_2);    
    light=0;
    }

void volume(void)
    {
    if (kn1==1) vol++;
    if (kn2==1) vol--;
    if (vol==255) vol=9;
    if (vol==10) vol=0;
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
    if (bar==255) bar=9;
    if (bar==10) bar=0;
    while (kn3==1 || kn4==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }

void ground(void)
    {
    gnd_amplituda=amplituda_new;
    gnd_faza=faza_new;
    }

void zero(void)
    {
    zero_amplituda=amplituda_new;
    zero_faza=faza_new;
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
// Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x20;

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
TCNT0=0xE0;                                              //koli4estvo periodov
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
// Clock value: 31,250 kHz
// Mode: Fast PWM top=FFh
// OC2 output: Inverted PWM
ASSR=0x00;
TCCR2=0x7E;
TCNT2=0x00;
OCR2=0x0C;                                               // Impuls naka4ki

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x41;

// Analog Comparator initialization
// Analog Comparator: On
// Interrupt on Falling Output Edge
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x0A;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "   v0.2   ^_^   ");
lcd_puts (string_LCD_2);
delay_ms (500);

while (1)
    {
    unsigned int temp_amplituda;
    unsigned int temp_faza;
    while (cycle==0);
    kn_klava();
    if (kn1==1 || kn2 ==1) volume();
    if (kn3==1 || kn4 ==1) barrier();    
    if (kn5==1) ground();  
    if (kn6==1) zero();

    temp_amplituda= zero_amplituda - amplituda_new;
    temp_faza=zero_faza - faza_new;
    if (temp_amplituda>0x0000) viz_amplituda=0;
    if (temp_amplituda>0x0080) viz_amplituda=1;
    if (temp_amplituda>0x0100) viz_amplituda=2; 
    if (temp_amplituda>0x0180) viz_amplituda=3; 
    if (temp_amplituda>0x0200) viz_amplituda=4; 
    if (temp_amplituda>0x0280) viz_amplituda=5; 
    if (temp_amplituda>0x0300) viz_amplituda=6; 
    if (temp_amplituda>0x0380) viz_amplituda=7; 
    if (temp_amplituda>0x0400) viz_amplituda=8; 
    if (temp_amplituda>0x0480) viz_amplituda=9; 
    if (temp_amplituda>0x0500) viz_amplituda=10;
    if (temp_amplituda>0x0700) viz_amplituda=0; 
    if (temp_faza>0x0000) viz_faza=0;
    if (temp_faza>0x0400) viz_faza=1;
    if (temp_faza>0x0800) viz_faza=2;
    if (temp_faza>0x0C00) viz_faza=3;
    if (temp_faza>0x1000) viz_faza=4;
    if (temp_faza>0x1400) viz_faza=5;
    if (temp_faza>0xE4FF) viz_faza=10;
    if (temp_faza>0xEBFF) viz_faza=9;
    if (temp_faza>0xEFFF) viz_faza=8;
    if (temp_faza>0xF8FF) viz_faza=7; 
    if (temp_faza>0xF4FF) viz_faza=6;     
    if (temp_faza>0xFBFF) viz_faza=0;
                     
    batt_zarqd();
    lcd_disp();
    cycle=0;
    };
}



