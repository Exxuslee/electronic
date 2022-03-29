/*****************************************************
Project : MD_IB_Exxus
Version : 1.7
Date    : 14.06.2010
Author  : Exxus
Company : Haos
Chip type           : ATmega32
Program type        : Application
Clock frequency     : 16,384000 MHz
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

#define ADC_VREF_TYPE 0x60
#define Ftx OCR1A
#define Frx OCR1B

// Declare your global variables here
char string_LCD_1[20], string_LCD_2[20];
unsigned int st_zero_A, st_zero_F, din_zero_A;
float ampl, faza, bar_rad;
unsigned char bar, rezym;
unsigned char din_A, viz_ampl, viz_faza, viz_din, din_max, din_min, gnd_F, gnd_A, rock_F, rock_A;
float batt;
bit kn1, kn2, kn3, kn4, kn5, kn6, mod_gnd, mod_rock, mod_all_met, zemlq, kamen, menu;
unsigned char rastr_st[0x20][0x20], gnd_pos_F, gnd_pos_A, rock_pos_F, rock_pos_A, gnd_sekt_F, gnd_sekt_A, rock_sekt_F, rock_sekt_A; 
signed char geb;
eeprom unsigned int Ftx_ee, Frx_ee;

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

void batt_zarqd(void)
    {
    #asm("wdr")
    batt = read_adc(4)/14.0;
    return;
    }

void kn_klava(void)
    {
    #asm("wdr")
    kn1=0;
    kn2=0;
    kn3=0;
    kn4=0;
    kn5=0;
    kn6=0;
    DDRA.5=1;
    PORTA.5=0;
    delay_ms (2);    
    if (PINA.6==0 && PINA.7==0) kn1=1;
    if (PINA.6==1 && PINA.7==0) kn2=1;
    DDRA.5=0;
    DDRA.6=1;
    PORTA.5=1;
    PORTA.6=0;
    delay_ms (2);
    if (PINA.5==1 && PINA.7==0) kn3=1;
    if (PINA.5==0 && PINA.7==0) kn4=1;
    DDRA.6=0;
    DDRA.7=1;
    PORTA.6=1;
    PORTA.7=0;
    delay_ms (2);
    if (PINA.5==1 && PINA.6==0) kn5=1;
    if (PINA.5==0 && PINA.6==1) kn6=1;
    DDRA.7=0;
    PORTA.7=1;
    return;
    }
    
void lcd_disp(void)
    {
    #asm("wdr") 
    if (menu==1)
        {  
        lcd_gotoxy (0,0);                       
        sprintf (string_LCD_1, "%2.1fV B=%d ", batt, bar);
        lcd_puts (string_LCD_1);

        lcd_gotoxy (10,0);
             if (rezym == 0)    sprintf (string_LCD_1, "St_Vec");
        else if (rezym == 1)    sprintf (string_LCD_1, "St_Ras");
        else if (rezym == 2)    sprintf (string_LCD_1, " Dinam");        
        else                    sprintf (string_LCD_1, "StopTX");                
        lcd_puts (string_LCD_1);  

        lcd_gotoxy (0,1);        
        sprintf (string_LCD_2, "(%03.0f:%+.2f))=Z", ampl, faza);
        lcd_puts (string_LCD_2);

        lcd_gotoxy (9,1);
        if (mod_rock == 1)   sprintf (string_LCD_2, "+R");
        else                    sprintf (string_LCD_2, "  ");
        lcd_puts (string_LCD_2); 

        lcd_gotoxy (11,1);
        if (mod_gnd == 1)   sprintf (string_LCD_2, "+G");
        else                    sprintf (string_LCD_2, "  ");
        lcd_puts (string_LCD_2);                   

        lcd_gotoxy (13,1);
        if (mod_all_met == 1)   sprintf (string_LCD_2, "-Fe");
        else                    sprintf (string_LCD_2, "+Al");
        lcd_puts (string_LCD_2);   
                
        return;        
        };

    if (kn2==1)
        {
        lcd_gotoxy (0,0);
             if (rezym == 0)         sprintf (string_LCD_1, " _Static_Veckt_ ");
        else if (rezym == 1)         sprintf (string_LCD_1, " _Static_Rastr_ ");
        else if (rezym == 2)         sprintf (string_LCD_1, "    _Dinamic_   ");        
        lcd_puts (string_LCD_1);
        return;
        };

    if (kn3==1)
        {
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "Barrier %d       ", bar);
        lcd_puts (string_LCD_2);
        return;
        }; 

    if (kn4==1)
        {
        lcd_gotoxy (0,0);               
        if (rezym <2)
                {
                sprintf (string_LCD_1, ">> Rock (A:f) <<");
                lcd_puts (string_LCD_1);
                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);
                }
        else 
                {
                sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
                lcd_puts (string_LCD_1);
                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "  %+d           ", geb);                
                };
        lcd_puts (string_LCD_2);                 
        return;
        };
        
    if (kn5==1)
        {
        lcd_gotoxy (0,0);               
        if (rezym <2)
                {
                sprintf (string_LCD_1, "> Ground (A;F) <");
                lcd_puts (string_LCD_1);
                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);              
                }
        else 
                {
                sprintf (string_LCD_1, ">>>> G.E.B. <<<<");
                lcd_puts (string_LCD_1);
                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "  %+d           ", geb);                
                };
        lcd_puts (string_LCD_2);  
        return;
        };

    if (kn6==1)
        {
        lcd_gotoxy (0,0);
        sprintf (string_LCD_1, "> Zero  (A:f)  <");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "  (%03.0f:%+.2f)   ", ampl, faza);
        lcd_puts (string_LCD_2);
        return;
        };   
        
    lcd_gotoxy (0,0);
    if (rezym < 2)
        {
        if      (viz_ampl==0)    sprintf (string_LCD_1, "                ");
        else if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");    
        else if (viz_ampl==2)    sprintf (string_LCD_1, "ÿ               ");
        else if (viz_ampl==3)    sprintf (string_LCD_1, "ÿ_              ");    
        else if (viz_ampl==4)    sprintf (string_LCD_1, "ÿÿ              ");
        else if (viz_ampl==5)    sprintf (string_LCD_1, "ÿÿ_             ");    
        else if (viz_ampl==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
        else if (viz_ampl==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");    
        else if (viz_ampl==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
        else if (viz_ampl==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");    
        else if (viz_ampl==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
        else if (viz_ampl==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");    
        else if (viz_ampl==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
        else if (viz_ampl==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");    
        else if (viz_ampl==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
        else if (viz_ampl==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");    
        else if (viz_ampl==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
        else if (viz_ampl==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");    
        else if (viz_ampl==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
        else if (viz_ampl==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");    
        else if (viz_ampl==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
        else if (viz_ampl==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");    
        else if (viz_ampl==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
        else if (viz_ampl==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");    
        else if (viz_ampl==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
        else if (viz_ampl==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");    
        else if (viz_ampl==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
        else if (viz_ampl==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");    
        else if (viz_ampl==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
        else if (viz_ampl==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");   
        else if (viz_ampl==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
        else if (viz_ampl==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");    
        else                     sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");    
        }
        
    else if (rezym == 2)
        {
             if (viz_ampl==1)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿÿ ");
        else if (viz_ampl==2)    sprintf (string_LCD_1, "        ÿÿÿÿÿÿ  ");
        else if (viz_ampl==3)    sprintf (string_LCD_1, "        ÿÿÿÿÿ   ");
        else if (viz_ampl==4)    sprintf (string_LCD_1, "        ÿÿÿÿ    ");    
        else if (viz_ampl==5)    sprintf (string_LCD_1, "        ÿÿÿ     ");   
        else if (viz_ampl==6)    sprintf (string_LCD_1, "        ÿÿ      ");   
        else if (viz_ampl==7)    sprintf (string_LCD_1, "        ÿ       ");  
        else if (viz_ampl==0)    sprintf (string_LCD_1, "                ");   
        else if (viz_ampl==8)    sprintf (string_LCD_1, "       ÿ        ");   
        else if (viz_ampl==9)    sprintf (string_LCD_1, "      ÿÿ        "); 
        else if (viz_ampl==10)   sprintf (string_LCD_1, "     ÿÿÿ        ");   
        else if (viz_ampl==11)   sprintf (string_LCD_1, "    ÿÿÿÿ        ");   
        else if (viz_ampl==12)   sprintf (string_LCD_1, "   ÿÿÿÿÿ        ");   
        else if (viz_ampl==13)   sprintf (string_LCD_1, "  ÿÿÿÿÿÿ        ");
        else                     sprintf (string_LCD_1, " ÿÿÿÿÿÿÿ        ");     
        }

    else                         sprintf (string_LCD_1, "    Stop__Tx    ");

    lcd_puts (string_LCD_1);

    lcd_gotoxy (0,1);
         if (viz_faza==0)  sprintf (string_LCD_2, "Û------II------Ü");
    else if (viz_faza==1)  sprintf (string_LCD_2, "Û------II----o_O");
    else if (viz_faza==2)  sprintf (string_LCD_2, "Û------II-----#Ü");
    else if (viz_faza==3)  sprintf (string_LCD_2, "Û------II----#-Ü");
    else if (viz_faza==4)  sprintf (string_LCD_2, "Û------II---#--Ü");
    else if (viz_faza==5)  sprintf (string_LCD_2, "Û------II--#---Ü");
    else if (viz_faza==6)  sprintf (string_LCD_2, "Û------II-#----Ü");
    else if (viz_faza==7)  sprintf (string_LCD_2, "Û------II#-----Ü");
    else if (viz_faza==8)  sprintf (string_LCD_2, "Û------I#------Ü");
    else if (viz_faza==9)  sprintf (string_LCD_2, "Û------#I------Ü");
    else if (viz_faza==10) sprintf (string_LCD_2, "Û-----#II------Ü");
    else if (viz_faza==11) sprintf (string_LCD_2, "Û----#-II------Ü");
    else if (viz_faza==12) sprintf (string_LCD_2, "Û---#--II------Ü");
    else if (viz_faza==13) sprintf (string_LCD_2, "Û--#---II------Ü");
    else if (viz_faza==14) sprintf (string_LCD_2, "Û-#----II------Ü");
    else if (viz_faza==15) sprintf (string_LCD_2, "Û#-----II------Ü");
    else                   sprintf (string_LCD_2, ">_<----II------Ü");
           
    lcd_puts (string_LCD_2);    

    if (rezym == 2)
        {
        if (viz_din==0)     return;

        sprintf (string_LCD_1, "<");
             if (viz_din==1)    lcd_gotoxy (7,0);
        else if (viz_din==2)    lcd_gotoxy (6,0);    
        else if (viz_din==3)    lcd_gotoxy (5,0);
        else if (viz_din==4)    lcd_gotoxy (4,0);    
        else if (viz_din==5)    lcd_gotoxy (3,0);
        else if (viz_din==6)    lcd_gotoxy (2,0);    
        else if (viz_din==7)    lcd_gotoxy (1,0);
        else                    lcd_gotoxy (0,0);    
        lcd_puts (string_LCD_1);

        sprintf (string_LCD_2, ">");        
             if (viz_din==1)    lcd_gotoxy (8,0);
        else if (viz_din==2)    lcd_gotoxy (9,0);    
        else if (viz_din==3)    lcd_gotoxy (10,0);
        else if (viz_din==4)    lcd_gotoxy (11,0);    
        else if (viz_din==5)    lcd_gotoxy (12,0);
        else if (viz_din==6)    lcd_gotoxy (13,0);    
        else if (viz_din==7)    lcd_gotoxy (14,0);
        else                    lcd_gotoxy (15,0);    
        lcd_puts (string_LCD_2);                
        };
    return;        
    }

void new (void)
    {
    unsigned int fr;
    #asm("wdr")
    ampl = read_adc (0);
    fr = ((unsigned int)ICR1H<<8)|ICR1L;
    faza = (float)fr/0x07CE*6.28-3.14;
    return;
    } 
    
float vektor_ampl (float a, float aa_x, float b, float bb_x)
    {
    float c;
    float aabb;
    #asm("wdr");
    aabb = aa_x - bb_x;
    c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
    return c;
    }  
 
float vektor_faza (int a_v, int c_v, int c, int b)
    {
    float ab_v, b_v, ac_v;
    #asm("wdr");
    if (a_v > c_v) ac_v = a_v - c_v;
    else ac_v = c_v - a_v;
    ab_v = asin(c * sin(ac_v) / b);


    return b_v;
    }  
    
void main_menu(void)
    {
    #asm("wdr")
    menu++;
    batt_zarqd();
    while (kn1==1) 
        {
        kn_klava();
        lcd_disp();
        };
    return;
    }
    
void rezymm(void)
    {
    #asm("wdr")
    rezym++;
    if (rezym == 4) 
        {
        TCCR1B=0x19;
        TCCR0=0x1D;
        rezym =0;
        };        

    while (kn2==1) 
        {
        kn_klava();
        lcd_disp();
        };
    return;    
    }    

void barrier(void)
    {
    #asm("wdr")
    bar++;
    if (bar==10) bar=0;
    bar_rad = (float) bar*0.1;
    while (kn3==1) 
        {
        kn_klava();
        lcd_disp();
        };
    return;
    }

void rock(void)
    {
    #asm("wdr")
    if (menu==1) mod_rock++;      

    else if (rezym == 0)
        {    
        rock_A = ampl;
        rock_F = faza;
        }    
    else if (rezym == 1)
        {    
        rock_sekt_A = (int)ampl / 8;
        rock_sekt_F = (int)faza / 8;        
        rock_pos_A = (int)ampl % 8; 
        rock_pos_F = (int)faza % 8; 

             if ((rock_pos_F > 4) & (rock_pos_A > 4)) rastr_st[rock_sekt_F][rock_sekt_A] |= 0x80;
        else if ((rock_pos_F > 0) & (rock_pos_A > 4)) rastr_st[rock_sekt_F][rock_sekt_A] |= 0x40;
        else if  (rock_pos_F > 4)                     rastr_st[rock_sekt_F][rock_sekt_A] |= 0x20;        
        else                                          rastr_st[rock_sekt_F][rock_sekt_A] |= 0x10;
        }          
    else if (rezym == 2) 
    {
    geb++;
    Frx++;
    if (Frx > Ftx) Frx = 0;    
    };
    return;
    }
    

void ground(void)
    {   
    #asm("wdr")
    if (menu==1) mod_gnd++;

    else if (rezym == 0)
        {    
        gnd_A = ampl;
        gnd_F = faza;
        }    
    else if (rezym == 1) 
        {
        gnd_sekt_A = (int)ampl / 8;
        gnd_sekt_F = (int)faza / 8;        
        gnd_pos_A = (int)ampl % 8; 
        gnd_pos_F = (int)faza % 8; 

             if ((gnd_pos_F > 4) & (gnd_pos_A > 4)) rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x08;
        else if ((gnd_pos_F > 0) & (gnd_pos_A > 4)) rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x04;
        else if  (gnd_pos_F > 4)                    rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x02;        
        else                                        rastr_st[gnd_sekt_F][gnd_sekt_A] |= 0x01;
        }
    else if (rezym == 2) 
        {
        geb--;
        Frx--;
        if (Frx == 0) Frx = Ftx;        
        }; 
    return;
    }

void zero(void)
    {
    #asm("wdr")
    if (menu == 1) mod_all_met++;
    
    st_zero_A = ampl;
    st_zero_F = faza;
    din_zero_A = din_A;
    return;
    }

void vizual (void)
    {
    #asm("wdr")
    if (rezym < 2)
        {
        if      (ampl> 180 )   viz_ampl=32;
        else if (ampl> 175 )   viz_ampl=31;      
        else if (ampl> 169 )   viz_ampl=30;
        else if (ampl> 164 )   viz_ampl=29; 
        else if (ampl> 158 )   viz_ampl=28; 
        else if (ampl> 153 )   viz_ampl=27; 
        else if (ampl> 147 )   viz_ampl=26; 
        else if (ampl> 142 )   viz_ampl=25; 
        else if (ampl> 136 )   viz_ampl=24; 
        else if (ampl> 131 )   viz_ampl=23; 
        else if (ampl> 125 )   viz_ampl=22; 
        else if (ampl> 120 )   viz_ampl=21;
        else if (ampl> 114 )   viz_ampl=20;
        else if (ampl> 109 )   viz_ampl=19;
        else if (ampl> 103 )   viz_ampl=18; 
        else if (ampl> 98  )   viz_ampl=17; 
        else if (ampl> 92  )   viz_ampl=16; 
        else if (ampl> 87  )   viz_ampl=15; 
        else if (ampl> 81  )   viz_ampl=14; 
        else if (ampl> 76  )   viz_ampl=13; 
        else if (ampl> 70  )   viz_ampl=12; 
        else if (ampl> 65  )   viz_ampl=11; 
        else if (ampl> 59  )   viz_ampl=10;
        else if (ampl> 54  )   viz_ampl=9;
        else if (ampl> 48  )   viz_ampl=8;
        else if (ampl> 43  )   viz_ampl=7;
        else if (ampl> 37  )   viz_ampl=6;
        else if (ampl> 32  )   viz_ampl=5;
        else if (ampl> 26  )   viz_ampl=4; 
        else if (ampl> 21  )   viz_ampl=3; 
        else if (ampl> 15  )   viz_ampl=2; 
        else if (ampl> 10  )   viz_ampl=1; 
        else                   viz_ampl=0;   
        }

    else if (rezym == 2)
        {    
             if (din_A > din_zero_A +92 )    viz_ampl=14;
        else if (din_A > din_zero_A +81 )    viz_ampl=13;
        else if (din_A > din_zero_A +70 )    viz_ampl=12;
        else if (din_A > din_zero_A +59 )    viz_ampl=11;
        else if (din_A > din_zero_A +48 )    viz_ampl=10;
        else if (din_A > din_zero_A +37 )    viz_ampl=9;
        else if (din_A > din_zero_A +26 )    viz_ampl=8; //___
        else if (din_A > din_zero_A     )    viz_ampl=0;
        else if (din_A > din_zero_A -26 )    viz_ampl=7; //___
        else if (din_A > din_zero_A -37 )    viz_ampl=6;
        else if (din_A > din_zero_A -48 )    viz_ampl=5;
        else if (din_A > din_zero_A -59 )    viz_ampl=4;
        else if (din_A > din_zero_A -70 )    viz_ampl=3;
        else if (din_A > din_zero_A -81 )    viz_ampl=2;
        else                                 viz_ampl=1; 
        };

         if (faza> 1.40)   viz_faza=0;
    else if (faza> 1.22)   viz_faza=8;
    else if (faza> 1.05)   viz_faza=7;
    else if (faza> 0.82)   viz_faza=6;
    else if (faza> 0.70)   viz_faza=5;
    else if (faza> 0.52)   viz_faza=4;
    else if (faza> 0.35)   viz_faza=3;
    else if (faza> 0.17)   viz_faza=2;
    else if (faza> 0   )   viz_faza=1;        
    else if (faza> -0.17)  viz_faza=16;
    else if (faza> -0.35)  viz_faza=15;
    else if (faza> -0.52)  viz_faza=14;
    else if (faza> -0.70)  viz_faza=13;
    else if (faza> -0.82)  viz_faza=12;
    else if (faza> -1.05)  viz_faza=11;
    else if (faza> -1.22)  viz_faza=10;
    else if (faza> -1.30)  viz_faza=9;
    else if (faza> -1.40)  viz_faza=0;          

    return;
    }

void start(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x80;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x90;

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
// Clock value: 16000,000 kHz
// Mode: Fast PWM top=OCR1A
// OC1A output: Discon.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x23;
TCCR1B=0x19;
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

// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
WDTCR=0x00;

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
ACSR=0x07;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 500,000 kHz
// ADC Voltage Reference: AVCC pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x85;


#asm("wdr")
// LCD module initialization
lcd_init(16);

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "FINDER ^_^ Exxus");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "v1.8.1   md4u.ru");
lcd_puts (string_LCD_2);
delay_ms (25);

ampl = 0;
din_max=0x7f;
din_min=0x7f;
st_zero_F=0x7f;
st_zero_A=0x00;
din_zero_A=0x7F;
gnd_F=0x7f;
gnd_A=0x00;

//if (Ftx_ee == 0xFFFF)   Ftx_ee = 0x07CE;
//Ftx = Ftx_ee;


kn_klava();
if (kn1==1) while (1)
                {
                kn_klava();
                new();

                if (kn2==1) 
                        {
                        Ftx--; 
                        };
                if (kn3==1) 
                        {
                        Ftx++;
                        };
                if (kn6==1) 
                        {                        
                        if (Ftx != Ftx_ee) 
                                {
                                Ftx_ee = Ftx;
                                lcd_gotoxy (12,0);
                                sprintf (string_LCD_1, "Save");
                                lcd_puts (string_LCD_1);  
                                }
                        else
                                {
                                lcd_gotoxy (12,0);
                                sprintf (string_LCD_1, "O.k.");
                                lcd_puts (string_LCD_1);                                  
                                };
                        
                        if  (Frx != Frx_ee)
                                {
                                Frx_ee = Frx;
                                lcd_gotoxy (12,1);
                                sprintf (string_LCD_2, "Save");
                                lcd_puts (string_LCD_2);  
                                }     
                        else
                                {
                                lcd_gotoxy (12,1);
                                sprintf (string_LCD_2, "O.k.");
                                lcd_puts (string_LCD_2);                                  
                                };                                                           
                        while (kn6==1) kn_klava();
                        continue;
                        };

                lcd_gotoxy (0,0);
                sprintf (string_LCD_1, "Freq-TX %3x [%2x]", Ftx, ampl);
                lcd_puts (string_LCD_1);    

                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "Faza-X  %3x [%2x]", Frx, faza);
                lcd_puts (string_LCD_2);                                     

                delay_ms (20);
                };
        
if (kn6==1) PORTD.7 = 1;
}

void main(void)
{
start ();
while (1)
      {
      // Place your code here
      kn_klava();

      #asm("wdr") 
      new();
          
      if (kn1==1) main_menu();
      if (kn2==1) rezymm ();
      if (kn3==1) barrier();
      if (kn4==1) rock();   
      if (kn5==1) ground();  
      if (kn6==1) zero();

      if (rezym == 0)
        {             
        if (mod_gnd == 1)
                {
                if ((faza <= gnd_F + bar_rad + 0.005 ) && (faza >= gnd_F - bar_rad - 0.005 ))
                    {
                    gnd_A = ampl;
                    };   
                ampl = vektor_ampl (ampl, faza, gnd_A, gnd_F);
                faza = vektor_faza (ampl, faza, gnd_A, gnd_F);
                };     

        if (mod_rock == 1)
                {
                if ((faza <= rock_F + bar_rad + 0.005 ) && (faza >= rock_F - bar_rad - 0.005 ))
                    {
                    ampl = 0;
                    faza = 1.45;
                    };
                };
        }
        
      else if (rezym == 1) 
        {    
        if (mod_gnd == 1)
                {
                gnd_sekt_A = (int)ampl / 8;
                gnd_sekt_F = (int)faza / 8;        
                gnd_pos_A = (int)ampl % 8; 
                gnd_pos_F = (int)faza % 8; 

                     if ((gnd_pos_F > 4) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x08)) zemlq = 1;
                else if ((gnd_pos_F > 0) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x04)) zemlq = 1;
                else if ((gnd_pos_F > 4)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x02)) zemlq = 1;    
                else if ((gnd_pos_F > 0)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x01)) zemlq = 1;
                else                                                                                      zemlq = 0;

                if (zemlq == 1) gnd_A = ampl;
                ampl = vektor_ampl (ampl, faza, gnd_A, gnd_F);
                faza = vektor_faza (ampl, faza, gnd_A, gnd_F);
                };              
        
        if (mod_rock == 1)
                {
                rock_sekt_A = (int)ampl / 8;
                rock_sekt_F = (int)faza / 8;        
                rock_pos_A = (int)ampl % 8; 
                rock_pos_F = (int)faza % 8; 

                     if ((rock_pos_F > 4) && (rock_pos_A > 4) && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x80)) kamen = 1;
                else if ((rock_pos_F > 0) && (rock_pos_A > 4) && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x40)) kamen = 1;
                else if ((rock_pos_F > 4)                     && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x20)) kamen = 1;    
                else if ((rock_pos_F > 0)                     && (rastr_st[rock_sekt_F][rock_sekt_A] & 0x10)) kamen = 1;
                else                                                                                          kamen = 0;

                if (kamen == 1)
                    {
                    ampl = 0;
                    faza = 1.45;
                    };
                };  
        ampl = ampl - (ampl * bar_rad / 3);        
        }
        
      else if (rezym == 2) 
        {
        if (din_A >= din_zero_A)
                {
                if (din_A >= din_max) din_max=din_A;
                else 
                        {
                        din_max--;
                        din_min++;
                        };
                }
        else
                {
                if (din_A < din_min) din_min=din_A;
                else 
                        {
                        din_min++;
                        din_max--;
                        };                
                };  

        if (din_max < din_zero_A) din_max=din_zero_A;
        if (din_min > din_zero_A) din_max=din_zero_A;

        if ((din_zero_A-din_min) < (din_max-din_zero_A))
            {           
                 if (din_max> din_zero_A +92)   viz_din=8;
            else if (din_max> din_zero_A +81)   viz_din=7;             
            else if (din_max> din_zero_A +70)   viz_din=6;
            else if (din_max> din_zero_A +59)   viz_din=5;
            else if (din_max> din_zero_A +48)   viz_din=4; 
            else if (din_max> din_zero_A +37)   viz_din=3; 
            else if (din_max> din_zero_A +26)   viz_din=2; 
            else if (din_max> din_zero_A +15)   viz_din=1; 
            else                                viz_din=0;
            }         
        else 
            {
                 if (din_min> din_zero_A -5 )   viz_din=0;
            else if (din_min> din_zero_A -15)   viz_din=1;             
            else if (din_min> din_zero_A -26)   viz_din=2;
            else if (din_min> din_zero_A -37)   viz_din=3;
            else if (din_min> din_zero_A -48)   viz_din=4; 
            else if (din_min> din_zero_A -59)   viz_din=5; 
            else if (din_min> din_zero_A -70)   viz_din=6; 
            else if (din_min> din_zero_A -81)   viz_din=7; 
            else                                viz_din=8;            
            };  
        }
        
      else 
        {
        TCCR1B=0x18;
        TCCR0=0x18;
        PORTB.3=0;
        PORTD.4=0;
        PORTD.5=0;        
        viz_ampl = 0;
        viz_faza = 0;        
        };
     
      vizual();            
      lcd_disp();
         
      delay_ms (10);
      }; 
}