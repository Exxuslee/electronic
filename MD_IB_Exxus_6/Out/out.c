
#include <mega32.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

#include <lcd.h>
#include <stdio.h>
#include <delay.h>
#include <math.h>

#define ADC_VREF_TYPE 0x20
#define light PORTD.6

// Declare your global variables here
char string_LCD_1[20], string_LCD_2[20];
unsigned int zero_Y, zero_X;
float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, gnd_ampl_max, gnd_faza_max, rock_ampl_max, rock_faza_max;
float now_ampl, now_faza, bar_rad;
float temp_ampl, temp_faza;
unsigned char bar;
unsigned char X, Y, viz_ampl, viz_faza;
unsigned char adc_data;
unsigned int batt_celoe, batt_drob;
bit kn1, kn2, kn3, kn4, kn5, kn6, menu, mod_gnd, mod_rock, mod_all_met, rezym;

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the 8 most significant bits
// of the AD conversion result
adc_data=ADCH;
}

// Read the 8 most significant bits
// of the AD conversion result
// with noise canceling
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}

void batt_zarqd(void)
    {
    unsigned int temp;
    temp=read_adc(4);
    batt_celoe=temp/20;
    batt_drob=temp%20;
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
    if (menu==1)
        {
        light=1;
  
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, "%d.%dV B=%d       ", batt_celoe, batt_drob, bar);
        lcd_puts (string_LCD_1);
        
        lcd_gotoxy (12,0);
        if (rezym == 0)         sprintf (string_LCD_1, "Stat");
        else                    sprintf (string_LCD_1, "Din ");
        lcd_puts (string_LCD_1);  

        lcd_gotoxy (0,1);        
        sprintf (string_LCD_2, "%x %x =Z", X, Y);
        lcd_puts (string_LCD_2);

        lcd_gotoxy (8,1);
        if (mod_gnd == 1)   sprintf (string_LCD_2, "+G");
        else                    sprintf (string_LCD_2, "  ");
        lcd_puts (string_LCD_2);                   

        lcd_gotoxy (10,1);
        if (mod_rock == 1)   sprintf (string_LCD_2, "+R");
        else                    sprintf (string_LCD_2, "  ");
        lcd_puts (string_LCD_2);  
        
        lcd_gotoxy (12,1);
        if (mod_all_met == 1)   sprintf (string_LCD_2, "+All");
        else                    sprintf (string_LCD_2, "-Fe ");
        lcd_puts (string_LCD_2);   
                
        return;        
        };

    if (kn2==1)
        {
        light=1;
        lcd_gotoxy (0,0);
        if (rezym == 0)         sprintf (string_LCD_1, "    _Static_    ");
        else                    sprintf (string_LCD_1, "    _Dinamic_   ");
        lcd_puts (string_LCD_1);
        return;
        };

    if (kn3==1)
        {
        light=1;
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "Barrier %d       ", bar);
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
        sprintf (string_LCD_2, "%x %x %x %x ", zero_Y, zero_X, Y, X);
        lcd_puts (string_LCD_2);
        return;
        };   
    lcd_gotoxy (0,0);
    if (rezym == 0)
        {
        if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
        if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");    
        if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
        if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");    
        if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
        if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");    
        if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
        if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");    
        if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
        if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");    
        if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
        if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");    
        if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
        if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");    
        if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
        if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");    
        if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
        if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");    
        if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
        if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");    
        if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
        if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");    
        if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
        if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");    
        if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
        if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");    
        if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
        if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");    
        if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
        if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");   
        if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
        if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");    
        if (viz_ampl==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");    
        };
    if (rezym == 1)
        {
        if (viz_ampl==0)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿÿ");
        if (viz_ampl==1)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ_");    
        if (viz_ampl==2)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ ");
        if (viz_ampl==3)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ_ ");    
        if (viz_ampl==4)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ  ");
        if (viz_ampl==5)    sprintf (string_LCD_1, "        ÿÿÿÿÿ_  ");    
        if (viz_ampl==6)    sprintf (string_LCD_1, "        ÿÿÿÿÿ   ");
        if (viz_ampl==7)    sprintf (string_LCD_1, "        ÿÿÿÿ_   ");    
        if (viz_ampl==8)    sprintf (string_LCD_1, "        ÿÿÿÿ    ");
        if (viz_ampl==9)    sprintf (string_LCD_1, "        ÿÿÿ_    ");    
        if (viz_ampl==10)   sprintf (string_LCD_1, "        ÿÿÿ     ");
        if (viz_ampl==11)   sprintf (string_LCD_1, "        ÿÿ_     ");    
        if (viz_ampl==12)   sprintf (string_LCD_1, "        ÿÿ      ");
        if (viz_ampl==13)   sprintf (string_LCD_1, "        ÿ_      ");    
        if (viz_ampl==14)   sprintf (string_LCD_1, "        ÿ       ");
        if (viz_ampl==15)   sprintf (string_LCD_1, "        _       ");    
        if (viz_ampl==16)   sprintf (string_LCD_1, "                ");
        if (viz_ampl==17)   sprintf (string_LCD_1, "       _        ");    
        if (viz_ampl==18)   sprintf (string_LCD_1, "       ÿ        ");
        if (viz_ampl==19)   sprintf (string_LCD_1, "      _ÿ        ");    
        if (viz_ampl==20)   sprintf (string_LCD_1, "      ÿÿ        ");
        if (viz_ampl==21)   sprintf (string_LCD_1, "     _ÿÿ        ");    
        if (viz_ampl==22)   sprintf (string_LCD_1, "     ÿÿÿ        ");
        if (viz_ampl==23)   sprintf (string_LCD_1, "    _ÿÿÿ        ");    
        if (viz_ampl==24)   sprintf (string_LCD_1, "    ÿÿÿÿ        ");
        if (viz_ampl==25)   sprintf (string_LCD_1, "   _ÿÿÿÿ        ");    
        if (viz_ampl==26)   sprintf (string_LCD_1, "   ÿÿÿÿÿ        ");
        if (viz_ampl==27)   sprintf (string_LCD_1, "  _ÿÿÿÿÿ        ");    
        if (viz_ampl==28)   sprintf (string_LCD_1, "  ÿÿÿÿÿÿ        ");
        if (viz_ampl==29)   sprintf (string_LCD_1, " _ÿÿÿÿÿÿ        ");   
        if (viz_ampl==30)   sprintf (string_LCD_1, " ÿÿÿÿÿÿÿ        ");
        if (viz_ampl==31)   sprintf (string_LCD_1, "_ÿÿÿÿÿÿÿ        ");    
        if (viz_ampl==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");        
        };
    lcd_puts (string_LCD_1);
    lcd_gotoxy (0,1);
    if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");    
    if (viz_faza==1)  sprintf (string_LCD_2, "Û------#I------Ü");
    if (viz_faza==2)  sprintf (string_LCD_2, "Û-----#II------Ü");
    if (viz_faza==3)  sprintf (string_LCD_2, "Û----#-II------Ü");
    if (viz_faza==4)  sprintf (string_LCD_2, "Û---#--II------Ü");
    if (viz_faza==5)  sprintf (string_LCD_2, "Û--#---II------Ü");
    if (viz_faza==6)  sprintf (string_LCD_2, "Û-#----II------Ü");
    if (viz_faza==7)  sprintf (string_LCD_2, "Û#-----II------Ü");
    if (viz_faza==8)  sprintf (string_LCD_2, ">_<----II------Ü");
    if (viz_faza==9)  sprintf (string_LCD_2, "Û------I#------Ü");
    if (viz_faza==10) sprintf (string_LCD_2, "Û------II#-----Ü");
    if (viz_faza==11) sprintf (string_LCD_2, "Û------II-#----Ü");
    if (viz_faza==12) sprintf (string_LCD_2, "Û------II--#---Ü");
    if (viz_faza==13) sprintf (string_LCD_2, "Û------II---#--Ü");
    if (viz_faza==14) sprintf (string_LCD_2, "Û------II----#-Ü");    
    if (viz_faza==15) sprintf (string_LCD_2, "Û------II-----#Ü");
    if (viz_faza==16) sprintf (string_LCD_2, "Û------II----o_O");        
    lcd_puts (string_LCD_2);    
    }
    
void zvuk ()
    {
    UDR = X;
    }

void new_X_Y_stat (void)
    {
    X = read_adc (0);
    Y = read_adc (1);
    }

void new_X_Y_din (void)
    {
    X = read_adc (2);
    Y = read_adc (3);      
    }    
    
float vektor_ampl (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
    {
    long int YY, XX;
    long unsigned int YX2;
    float YX3;
    if (Y_1 > Y_2) YY = Y_1 - Y_2;
    else YY = Y_2 - Y_1;
    if (X_1 > X_2) XX = X_1 - X_2;
    else XX = X_2 - X_1; 
    YX2  = YY*YY + XX*XX;
    YX3 = sqrt (YX2); 
    return YX3;
    }

    
float vektor_faza (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
    {
    signed int YY, XX;
    float YX2;
    YY = Y_1 - Y_2;
    XX = X_1 - X_2;
    YX2 = atan2 (YY,XX);    
    return YX2;
    } 

float th_cos (float a, float aa_x, float b, float bb_x)
    {
    float c;
    float aabb;
    aabb = aa_x - bb_x;
    c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
    return c;
    }   

float th_sin (float c, int b_y, int b_x, int c_y, int c_x)
    {
    int ab;
    float temp;
    if (b_y > c_y) ab = b_y - c_y;
    else ab = c_y - b_y; 
    temp = asin (ab/c);
    if (c_x > b_x) temp = 3.141593 - temp;
    return temp;
    } 
    
void main_menu(void)
    {
    menu++;
    while (kn1==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }
    
void rezymm(void)
    {
    rezym++;
    while (kn2==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }    

void barrier(void)
    {
    bar++;
    if (bar==10) bar=0;
    bar_rad = (float) bar*0.174532925;
    while (kn3==1) 
        {
        kn_klava();
        lcd_disp();
        };
    }

void rock(void)
    {
    if (menu==1) mod_rock++;
    rock_ampl_max = vektor_ampl(Y, X, zero_Y, zero_X);
    rock_faza_max = vektor_faza(Y, X, zero_Y, zero_X);
    }

void ground(void)
    {
    if (menu==1) mod_gnd++; 
    gnd_ampl_max = vektor_ampl(Y, X, zero_Y, zero_X);
    gnd_faza_max = vektor_faza(Y, X, zero_Y, zero_X);
    }

void zero(void)
    {
    if (menu==1) mod_all_met++;
    zero_X = X;
    zero_Y = Y;
    }

void start (void)
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
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State7=0 State6=T State5=0 State4=T State3=T State2=T State1=T State0=0 
PORTD=0x03;
DDRD=0xA3;

// ADC initialization
// ADC Clock frequency: 256,000 kHz
// ADC Voltage Reference: Int., cap. on AREF
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x8E;

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
// Clock value: Timer 1 Stopped
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
TCCR1B=0x00;
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
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x08;

// LCD module initialization
lcd_init(16);

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "$$$ IB_Exxus $$$");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "v1.6 ^_^ md4u.ru");
lcd_puts (string_LCD_2);
delay_ms (5000);

// Global enable interrupts
#asm("sei")
}

void main(void)
{
start ();
temp_ampl = 0;

while (1)
      {
      // Place your code here
      kn_klava();

      if (rezym == 0) new_X_Y_stat ();
      else new_X_Y_din ();
          
      if (kn1==1) main_menu();
      if (kn2==1) rezymm ();
      if (kn3==1) barrier();
      if (kn4==1) rock();   
      if (kn5==1) ground();  
      if (kn6==1) zero();
      
      
      if (rezym == 0)
        {
        now_ampl = vektor_ampl (Y, X, zero_Y, zero_X);
        now_faza = vektor_faza (Y, X, zero_Y, zero_X);
      
        if (mod_gnd || mod_rock == 1)
                {
                if ((now_faza <= gnd_faza_max + bar_rad + 0.005 ) && (now_faza >= gnd_faza_max - bar_rad + 0.005 ))
                {
                if ((now_ampl * 0.99 <= gnd_ampl ) && (now_ampl * 1.01 >= gnd_ampl))
                        {
                        gnd_ampl = now_ampl;
                        gnd_faza = now_faza;
                        };
                    };
                now_ampl = th_cos (now_ampl, now_faza, gnd_ampl, gnd_faza);
                now_faza = th_sin (temp_ampl, Y, X, gnd_ampl, gnd_faza);
                if ((now_faza <= rock_faza_max + bar_rad + 0.005 ) && (now_faza >= rock_faza_max - bar_rad + 0.005 ))
                    {
                    if ((now_ampl * 0.95 <= rock_ampl ) && (now_ampl * 1.05 >= rock_ampl))
                        {
                        rock_ampl = now_ampl;
                        rock_faza = now_faza;
                        };
                    };                
                temp_ampl = th_cos (now_ampl, now_faza, rock_ampl, rock_faza);
                temp_faza = th_sin (temp_ampl, Y, X, rock_ampl, rock_faza);
                }
        
        else if (mod_gnd == 1)
                {
                if ((now_faza <= gnd_faza_max + bar_rad + 0.005 ) && (now_faza >= gnd_faza_max - bar_rad + 0.005 ))
                    {
                    if ((now_ampl * 0.99 <= gnd_ampl ) && (now_ampl * 1.01 >= gnd_ampl))
                        {
                        gnd_ampl = now_ampl;
                        gnd_faza = now_faza;
                        };
                    };   
                temp_ampl = th_cos (now_ampl, now_faza, gnd_ampl, gnd_faza);
                temp_faza = th_sin (temp_ampl, Y, X, gnd_ampl, gnd_faza);
                }      

        else if (mod_rock == 1)
                {
                if ((now_faza <= rock_faza_max + bar_rad + 0.005 ) && (now_faza >= rock_faza_max - bar_rad + 0.005 ))
                    {
                    if ((now_ampl * 0.95 <= rock_ampl ) && (now_ampl * 1.05 >= rock_ampl))
                        {
                        rock_ampl = now_ampl;
                        rock_faza = now_faza;
                        };
                    };   
                temp_ampl = th_cos (now_ampl, now_faza, rock_ampl, rock_faza);
                temp_faza = th_sin (temp_ampl, Y, X, rock_ampl, rock_faza);
                }
        
        else 
                {
                temp_ampl = now_ampl;
                temp_faza = now_faza;
                };
                
        if      (temp_ampl> 160 )   viz_ampl=32;
        else if (temp_ampl> 155 )   viz_ampl=31;      
        else if (temp_ampl> 150 )   viz_ampl=30;
        else if (temp_ampl> 145 )   viz_ampl=29; 
        else if (temp_ampl> 140 )   viz_ampl=28; 
        else if (temp_ampl> 135 )   viz_ampl=27; 
        else if (temp_ampl> 130 )   viz_ampl=26; 
        else if (temp_ampl> 125 )   viz_ampl=25; 
        else if (temp_ampl> 120 )   viz_ampl=24; 
        else if (temp_ampl> 115 )   viz_ampl=23; 
        else if (temp_ampl> 110 )   viz_ampl=22; 
        else if (temp_ampl> 105 )   viz_ampl=21;
        else if (temp_ampl> 100 )   viz_ampl=20;
        else if (temp_ampl> 95  )   viz_ampl=19;
        else if (temp_ampl> 90  )   viz_ampl=18; 
        else if (temp_ampl> 85  )   viz_ampl=17; 
        else if (temp_ampl> 80  )   viz_ampl=16; 
        else if (temp_ampl> 75  )   viz_ampl=15; 
        else if (temp_ampl> 70  )   viz_ampl=14; 
        else if (temp_ampl> 65  )   viz_ampl=13; 
        else if (temp_ampl> 60  )   viz_ampl=12; 
        else if (temp_ampl> 55  )   viz_ampl=11; 
        else if (temp_ampl> 50  )   viz_ampl=10;
        else if (temp_ampl> 45  )   viz_ampl=9;
        else if (temp_ampl> 40  )   viz_ampl=8;
        else if (temp_ampl> 35  )   viz_ampl=7;
        else if (temp_ampl> 30  )   viz_ampl=6;
        else if (temp_ampl> 25  )   viz_ampl=5;
        else if (temp_ampl> 20  )   viz_ampl=4; 
        else if (temp_ampl> 15  )   viz_ampl=3; 
        else if (temp_ampl> 10  )   viz_ampl=2; 
        else if (temp_ampl> 5   )   viz_ampl=1; 
        else if (temp_ampl> 0   )   viz_ampl=0; 
       
        if (temp_faza> 3.14) viz_faza=0;
        else if (temp_faza> 2.944) viz_faza=8;  
        else if (temp_faza> 2.748) viz_faza=7;      
        else if (temp_faza> 2.552) viz_faza=6;
        else if (temp_faza> 2.356) viz_faza=5;
        else if (temp_faza> 2.160) viz_faza=4;
        else if (temp_faza> 1.964) viz_faza=3;
        else if (temp_faza> 1.768) viz_faza=2;
        else if (temp_faza> 1.572) viz_faza=1;
      
        else if (temp_faza> 1.376) viz_faza=9;
        else if (temp_faza> 1.180) viz_faza=10;
        else if (temp_faza> 0.984) viz_faza=11;
        else if (temp_faza> 0.788) viz_faza=12; 
        else if (temp_faza> 0.592) viz_faza=13;  
        else if (temp_faza> 0.396) viz_faza=14; 
        else if (temp_faza> 0.200) viz_faza=15;          
        else if (temp_faza> 0.000) viz_faza=16; 
        };
        
      if (rezym == 1) 
        {
        if      (Y > 160 )     viz_ampl=32;
        else if (Y > 155 )     viz_ampl=31;
        else if (Y > 150 )     viz_ampl=30;
        else if (Y > 145 )     viz_ampl=29;
        else if (Y > 140 )     viz_ampl=28;
        else if (Y > 135 )     viz_ampl=27;  
        else if (Y > 130 )     viz_ampl=26;
        else if (Y > 125 )     viz_ampl=25;  
        else if (Y > 120 )     viz_ampl=24;
        else if (Y > 115 )     viz_ampl=23;  
        else if (Y > 110 )     viz_ampl=22;
        else if (Y > 105 )     viz_ampl=21;  
        else if (Y > 100 )     viz_ampl=20;
        else if (Y > 95  )     viz_ampl=19;  
        else if (Y > 90  )     viz_ampl=18; //___
        else if (Y > 85  )     viz_ampl=17;
        else if (Y > 80  )     viz_ampl=16; //___
        else if (Y > 75  )     viz_ampl=15;  
        else if (Y > 70  )     viz_ampl=14;
        else if (Y > 65  )     viz_ampl=13;  
        else if (Y > 60  )     viz_ampl=12;
        else if (Y > 55  )     viz_ampl=11;  
        else if (Y > 50  )     viz_ampl=10;
        else if (Y > 45  )     viz_ampl=9;  
        else if (Y > 40  )     viz_ampl=8;
        else if (Y > 35  )     viz_ampl=7;  
        else if (Y > 30  )     viz_ampl=6;
        else if (Y > 25  )     viz_ampl=5;  
        else if (Y > 20  )     viz_ampl=4;
        else if (Y > 15  )     viz_ampl=3;  
        else if (Y > 10  )     viz_ampl=2;
        else if (Y > 5   )     viz_ampl=1;
        else if (Y > 0   )     viz_ampl=0;  
        
        if      (X > 150 )     viz_faza=8;
        else if (X > 140 )     viz_faza=7;
        else if (X > 130 )     viz_faza=6;
        else if (X > 120 )     viz_faza=5;
        else if (X > 110 )     viz_faza=4;
        else if (X > 100 )     viz_faza=3;  
        else if (X > 90  )     viz_faza=2;
        else if (X > 80  )     viz_faza=1; 
        else if (X > 70  )     viz_faza=9;
        else if (X > 60  )     viz_faza=10;  
        else if (X > 50  )     viz_faza=11;
        else if (X > 40  )     viz_faza=12;  
        else if (X > 30  )     viz_faza=13;
        else if (X > 20  )     viz_faza=14;  
        else if (X > 10  )     viz_faza=15;
        else if (X > 0   )     viz_faza=16;        
        };
                   
      batt_zarqd();
      lcd_disp();
      zvuk();
      
      delay_ms (200);
      light=0;
      };
}
