/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
? Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 02.06.2009
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

#define ADC_VREF_TYPE 0x00
#define light PORTD.6

// Declare your global variables here
char string_LCD_1[20], string_LCD_2[20];
int x_1, x_2;
int faza, ampl;
unsigned int zero_ampl, zero_faza, y_gnd, x_gnd;
float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, now_ampl, now_faza;
unsigned int period;
unsigned char vol, bar, menu, rezhym, gnd_rage;
unsigned char viz_ampl, viz_faza;
unsigned int batt_celoe, batt_drob;
bit kn1, kn2, kn3, kn4, kn5, kn6, all_met;

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

void batt_zarqd(void)
    {
    unsigned int temp;
    #asm("wdr");
    temp=read_adc(0);
    batt_celoe=temp/10;
    batt_drob=temp%10;
    }

void kn_klava(void)
    {
    #asm("wdr");
    kn1=0;
    kn2=0;
    kn3=0;
    kn4=0;
    kn5=0;
    kn6=0;
    DDRD.2=1;
    PORTD.2=0;
    delay_ms (1);    
    if (PIND.3==0 && PIND.4==0) kn1=1;
    if (PIND.3==1 && PIND.4==0) kn2=1;
    DDRD.2=0;
    DDRD.3=1;
    PORTD.2=1;
    PORTD.3=0;
    delay_ms (1);
    if (PIND.2==1 && PIND.4==0) kn3=1;
    if (PIND.2==0 && PIND.4==0) kn4=1;
    DDRD.3=0;
    DDRD.4=1;
    PORTD.3=1;
    PORTD.4=0;
    delay_ms (1);
    if (PIND.2==1 && PIND.3==0) kn5=1;
    if (PIND.2==0 && PIND.3==1) kn6=1;
    DDRD.4=0;
    PORTD.4=1;
    }
    
void lcd_disp(void)
    {
    #asm("wdr");
    if (menu==1)
        {
        light=1;
  
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, "%d.%dV V=%d B=%d   ", batt_celoe, batt_drob, vol, bar);
        lcd_puts (string_LCD_1);
        
        lcd_gotoxy (0,1);        
             if (rezhym == 0 && all_met == 0) sprintf (string_LCD_2, "%x %x   Z   %", faza, ampl);
        else if (rezhym == 0 && all_met == 1) sprintf (string_LCD_2, "%x %x   ZG  $", faza, ampl);      
        else if (rezhym == 1 && all_met == 0) sprintf (string_LCD_2, "%x %x   ZGR %", faza, ampl);
        else if (rezhym == 1 && all_met == 1) sprintf (string_LCD_2, "%x %x   Z   $", faza, ampl);
        else if (rezhym == 2 && all_met == 0) sprintf (string_LCD_2, "%x %x   ZG  %", faza, ampl);      
        else if (rezhym == 2 && all_met == 1) sprintf (string_LCD_2, "%x %x   ZGR $", faza, ampl);
        lcd_puts (string_LCD_2);
        
        return;        
        };

    if (menu==2)
        {
        light=1;
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, "> Ground rage  <");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, " %d              ", gnd_rage);
        lcd_puts (string_LCD_2);
        return;        
        };                        

    if (kn2==1)
        {
        light=1;
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "Volume %d       ", vol);
        lcd_puts (string_LCD_2);
        return;
        };

    if (kn3==1)
        {
        light=1;
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "Barrier %d      ", bar);
        lcd_puts (string_LCD_2);
        return;
        }; 

    if (kn4==1)
        {
        light=1;
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, ">>>>> Rock <<<<<", bar);
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "%f %f", rock_ampl, rock_faza);
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
        sprintf (string_LCD_2, "%f %f ", gnd_ampl, gnd_faza);
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
        sprintf (string_LCD_2, "%x %x %x %x ", zero_ampl, zero_faza, ampl, faza);
        lcd_puts (string_LCD_2);
        return;
        };   
    lcd_gotoxy (0,0);
    if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
    if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");    
    if (viz_ampl==2)    sprintf (string_LCD_1, "?               ");
    if (viz_ampl==3)    sprintf (string_LCD_1, "?_              ");    
    if (viz_ampl==4)    sprintf (string_LCD_1, "??              ");
    if (viz_ampl==5)    sprintf (string_LCD_1, "??_             ");    
    if (viz_ampl==6)    sprintf (string_LCD_1, "???             ");
    if (viz_ampl==7)    sprintf (string_LCD_1, "???_            ");    
    if (viz_ampl==8)    sprintf (string_LCD_1, "????            ");
    if (viz_ampl==9)    sprintf (string_LCD_1, "????_           ");    
    if (viz_ampl==10)   sprintf (string_LCD_1, "?????           ");
    if (viz_ampl==11)   sprintf (string_LCD_1, "?????_          ");    
    if (viz_ampl==12)   sprintf (string_LCD_1, "??????          ");
    if (viz_ampl==13)   sprintf (string_LCD_1, "??????_         ");    
    if (viz_ampl==14)   sprintf (string_LCD_1, "???????         ");
    if (viz_ampl==15)   sprintf (string_LCD_1, "???????_        ");    
    if (viz_ampl==16)   sprintf (string_LCD_1, "????????        ");
    if (viz_ampl==17)   sprintf (string_LCD_1, "????????_       ");    
    if (viz_ampl==18)   sprintf (string_LCD_1, "?????????       ");
    if (viz_ampl==19)   sprintf (string_LCD_1, "?????????_      ");    
    if (viz_ampl==20)   sprintf (string_LCD_1, "??????????      ");
    if (viz_ampl==21)   sprintf (string_LCD_1, "??????????_     ");    
    if (viz_ampl==22)   sprintf (string_LCD_1, "???????????     ");
    if (viz_ampl==23)   sprintf (string_LCD_1, "???????????_    ");    
    if (viz_ampl==24)   sprintf (string_LCD_1, "????????????    ");
    if (viz_ampl==25)   sprintf (string_LCD_1, "????????????_   ");    
    if (viz_ampl==26)   sprintf (string_LCD_1, "?????????????   ");
    if (viz_ampl==27)   sprintf (string_LCD_1, "?????????????_  ");    
    if (viz_ampl==28)   sprintf (string_LCD_1, "??????????????  ");
    if (viz_ampl==29)   sprintf (string_LCD_1, "??????????????_ ");   
    if (viz_ampl==30)   sprintf (string_LCD_1, "??????????????? ");
    if (viz_ampl==31)   sprintf (string_LCD_1, "???????????????_");    
    if (viz_ampl==32)   sprintf (string_LCD_1, "????????????????");    
    lcd_puts (string_LCD_1);
    lcd_gotoxy (0,1);
    if (viz_faza==0)  sprintf (string_LCD_2, "?------II------?");    
    if (viz_faza==1)  sprintf (string_LCD_2, "?------#I------?");
    if (viz_faza==2)  sprintf (string_LCD_2, "?-----#II------?");
    if (viz_faza==3)  sprintf (string_LCD_2, "?----#-II------?");
    if (viz_faza==4)  sprintf (string_LCD_2, "?---#--II------?");
    if (viz_faza==5)  sprintf (string_LCD_2, "?--#---II------?");
    if (viz_faza==6)  sprintf (string_LCD_2, "?-#----II------?");
    if (viz_faza==7)  sprintf (string_LCD_2, "?#-----II------?");
    if (viz_faza==8)  sprintf (string_LCD_2, "?------I#------?");
    if (viz_faza==9)  sprintf (string_LCD_2, "?------II#-----?");
    if (viz_faza==10) sprintf (string_LCD_2, "?------II-#----?");
    if (viz_faza==11) sprintf (string_LCD_2, "?------II--#---?");
    if (viz_faza==12) sprintf (string_LCD_2, "?------II---#--?");
    if (viz_faza==13) sprintf (string_LCD_2, "?------II----#-?");    
    if (viz_faza==14) sprintf (string_LCD_2, "?------II-----#?");      
    
    lcd_puts (string_LCD_2);    
    light=0;
    }

void new_X_Y (void)
    {
    #asm("wdr");
    while (ACSR.5==0);
    while (ACSR.5==1);
    while (ACSR.5==0);
    while (ACSR.5==1)
        {
        x_1=TCNT1;
        PORTA.7=1;
        };
    while (ACSR.5==0)
        {
        x_2=TCNT1;
        PORTA.7=0;
        };
    if (x_2 > x_1) faza= (x_2 + x_1) / 2;
    if (x_2 < x_1)
        {
        faza= (x_1 - x_2) + (x_1 + x_2) / 2;
        if (faza > period) faza = faza - period;   // ICR1
        };
    while (TCNT1 != faza); 
    PORTA.6=1;
    ampl = read_adc(3);
    PORTA.6=0;
    }
    
float vektor_ampl (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
    {
    long int Y;
    long int X;
    long unsigned int temp3;
    float temp;
    #asm("wdr");
    koord_1_1 = koord_1_1 /2;
    koord_1_2 = koord_1_2 /2;
    koord_2_1 = koord_2_1 /2;
    koord_2_2 = koord_2_2 /2;
    if (koord_1_1 > koord_2_1) Y = koord_1_1 - koord_2_1;
    else Y = koord_2_1 - koord_1_1;
    if (koord_1_2 > koord_2_2) X = koord_1_2 - koord_2_2;
    else X = koord_2_2 - koord_1_2; 
    temp3  = Y*Y + X*X;
    temp = sqrt (temp3); 
    return temp;
    }

    
float vektor_faza (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
    {
    signed int Y;
    signed int X;
    float temp;
    #asm("wdr");
    Y = koord_1_1 - koord_2_1;
    X = koord_1_2 - koord_2_2;
    temp = atan2 (Y,X);    
    return temp;
    } 
    
void main_menu(void)
    {
    #asm("wdr");
    menu++;
    if (menu==255) menu=2;
    if (menu==3) menu=0;
    while (kn1==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }
    
void volume(void)
    {
    #asm("wdr");
    if (menu==1) rezhym++;
    else if (menu==2) gnd_rage++;
    else vol++;
    if (vol==10) vol=0;
    if (rezhym==4) rezhym=0;  
    while (kn2==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }    

void barrier(void)
    {
    #asm("wdr");
    if (menu==1) all_met++;
    else if (menu==2) gnd_rage--;
    else bar++;
    if (bar==10) bar=0;
    while (kn3==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }

void rock(void)
    {
    #asm("wdr");
    rock_ampl = vektor_ampl(ampl, faza, zero_ampl, zero_faza);
    rock_faza = vektor_faza(ampl, faza, zero_ampl, zero_faza);
    }

void ground(void)
    {
    #asm("wdr");
    y_gnd = ampl;
    x_gnd = faza;
    gnd_ampl = vektor_ampl(ampl, faza, zero_ampl, zero_faza);
    gnd_faza = vektor_faza(ampl, faza, zero_ampl, zero_faza);
    }

void zero(void)
    {
    #asm("wdr");
    zero_ampl=0;
    zero_faza=0x0320;
//    zero_ampl=ampl;
//    zero_faza=faza;
    }
    
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0xC0;

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
// Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=0 
PORTD=0x03;
DDRD=0xA3;

// Analog Comparator initialization
// Analog Comparator: On
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x00;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Phase correct PWM top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Non-Inv.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x82;
TCCR1B=0x19;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x06;
ICR1L=0x3F;
OCR1AH=0x00;
OCR1AL=0x0F;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Phase correct PWM top=FFh
// OC2 output: Non-Inverted PWM
ASSR=0x00;
TCCR2=0x61;
TCNT2=0x00;
OCR2=0x7F;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x0C;

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
WDTCR=0x00;


// LCD module initialization
lcd_init(16);


lcd_gotoxy (0,0);
sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "   v0.4   ^_^   ");
lcd_puts (string_LCD_2);
delay_ms (500);

period=0x063F;              //period
x_gnd=period/2;
zero_faza=period/2;

while (1)
      {
      // Place your code here
      float temp_ampl, temp_faza;
      #asm("wdr");
      new_X_Y ();
      kn_klava();
          
      if (kn1==1) main_menu();
      if (kn2==1) volume();
      if (kn3==1) barrier();
      if (kn4==1) rock();   
      if (kn5==1) ground();  
      if (kn6==1) zero();
      
      
      
      now_ampl = vektor_ampl (ampl, faza, zero_ampl, zero_faza);
      now_faza      = vektor_faza (ampl, faza, zero_ampl, zero_faza);
      
      if (rezhym == 0)
        {
        temp_ampl = now_ampl;
        temp_faza = now_faza;
        };
      if (rezhym == 1)
        {
        temp_ampl = now_ampl - gnd_ampl;
        temp_faza = now_faza - gnd_faza;
        };      
      if (rezhym == 2)
        {
        temp_ampl = now_ampl - gnd_ampl - rock_ampl;
        temp_faza = now_faza - gnd_faza - rock_faza;
        };
        
      if (temp_ampl> 2079 )        viz_ampl=32;
      else if (temp_ampl> 2016 )   viz_ampl=31;      
      else if (temp_ampl> 1953 )   viz_ampl=30;
      else if (temp_ampl> 1890 )   viz_ampl=29; 
      else if (temp_ampl> 1827 )   viz_ampl=28; 
      else if (temp_ampl> 1764 )   viz_ampl=27; 
      else if (temp_ampl> 1701 )   viz_ampl=26; 
      else if (temp_ampl> 1638 )   viz_ampl=25; 
      else if (temp_ampl> 1575 )   viz_ampl=24; 
      else if (temp_ampl> 1512 )   viz_ampl=23; 
      else if (temp_ampl> 1449 )   viz_ampl=22; 
      else if (temp_ampl> 1386 )   viz_ampl=21;
      else if (temp_ampl> 1323 )   viz_ampl=20;
      else if (temp_ampl> 1260 )   viz_ampl=19;
      else if (temp_ampl> 1197 )   viz_ampl=18; 
      else if (temp_ampl> 1134 )   viz_ampl=17; 
      else if (temp_ampl> 1071 )   viz_ampl=16; 
      else if (temp_ampl> 1008 )   viz_ampl=15; 
      else if (temp_ampl> 945  )   viz_ampl=14; 
      else if (temp_ampl> 882  )   viz_ampl=13; 
      else if (temp_ampl> 819  )   viz_ampl=12; 
      else if (temp_ampl> 756  )   viz_ampl=11; 
      else if (temp_ampl> 693  )   viz_ampl=10;
      else if (temp_ampl> 630  )   viz_ampl=9;
      else if (temp_ampl> 567  )   viz_ampl=8;
      else if (temp_ampl> 504  )   viz_ampl=7;
      else if (temp_ampl> 441  )   viz_ampl=6;
      else if (temp_ampl> 378  )   viz_ampl=5;
      else if (temp_ampl> 315  )   viz_ampl=4; 
      else if (temp_ampl> 252  )   viz_ampl=3; 
      else if (temp_ampl> 189  )   viz_ampl=2; 
      else if (temp_ampl> 126  )   viz_ampl=1; 
      else if (temp_ampl> 63   )   viz_ampl=0; 
       
      if (temp_faza> 3.14) viz_faza=0;
      else if (temp_faza> 2.89) viz_faza=7;      
      else if (temp_faza> 2.67) viz_faza=6;
      else if (temp_faza> 2.45) viz_faza=5;
      else if (temp_faza> 2.23) viz_faza=4;
      else if (temp_faza> 2.01) viz_faza=3;
      else if (temp_faza> 1.79) viz_faza=2;
      else if (temp_faza> 1.57) viz_faza=1;
      
      else if (temp_faza> 1.35) viz_faza=8;
      else if (temp_faza> 1.13) viz_faza=9;
      else if (temp_faza> 0.91) viz_faza=10;
      else if (temp_faza> 0.69) viz_faza=11; 
      else if (temp_faza> 0.47) viz_faza=12;  
      else if (temp_faza> 0.25) viz_faza=13; 
      else if (temp_faza> 0.00) viz_faza=14;          
             
      batt_zarqd();
      lcd_disp();
      #asm("wdr");
      };
}
