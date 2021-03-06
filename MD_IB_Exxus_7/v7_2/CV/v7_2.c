/*****************************************************
Project : MD_IB_Exxus
Version : 1.7.2
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

#define ADC_VREF_TYPE 0x20
#define Ftx OCR1A
#define Frx OCR1B

// Declare your global variables here
bit kn1, kn2, kn3, kn4, kn5, kn6, mod_gnd, mod_rock, mod_all_met, zemlq, kamen, menu;

char string_LCD_1[20], string_LCD_2[20];
signed char geb;
unsigned char adc_data;
unsigned char new_st_A, new_st_F, din_A, din_F;
unsigned char viz_ampl, viz_faza, viz_din, din_max, din_min;
unsigned char bar, rezym;
unsigned char rastr_st[0x20][0x20], gnd_pos_A, gnd_pos_F, rock_pos_A, rock_pos_F, gnd_sekt_A, gnd_sekt_F, rock_sekt_A, rock_sekt_F; 

unsigned int din_zero_A, din_zero_F;

float st_zero_A, st_zero_F;
float ampl, faza, bar_rad, st_A, st_F;
float gnd_A, gnd_F, rock_A, rock_F;

eeprom unsigned int Ftx_ee, Frx_ee;

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
    if (menu==1)
        {  
        lcd_gotoxy (0,0);                       
        sprintf (string_LCD_1, "%2.1fV B=%d ", read_adc(4)/14.0, bar);
        lcd_puts (string_LCD_1);

        lcd_gotoxy (10,0);
             if (rezym == 0)    sprintf (string_LCD_1, "St_Vec");
        else if (rezym == 1)    sprintf (string_LCD_1, "St_Ras");
        else if (rezym == 2)    sprintf (string_LCD_1, " Dinam");        
        else                    sprintf (string_LCD_1, "StopTX");                
        lcd_puts (string_LCD_1);  

        lcd_gotoxy (0,1);        
        sprintf (string_LCD_2, "[%2x;%2x] =", new_st_A, new_st_F);
        lcd_puts (string_LCD_2);

        lcd_gotoxy (9,1);
        if (mod_rock == 1)      sprintf (string_LCD_2, "+R");
        else                    sprintf (string_LCD_2, "  ");
        lcd_puts (string_LCD_2); 

        lcd_gotoxy (11,1);
        if (mod_gnd == 1)       sprintf (string_LCD_2, "+G");
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
             if (rezym == 0)    sprintf (string_LCD_1, " _Static_Veckt_ ");
        else if (rezym == 1)    sprintf (string_LCD_1, " _Static_Rastr_ ");
        else if (rezym == 2)    sprintf (string_LCD_1, "    _Dinamic_   ");        
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
                sprintf (string_LCD_2, "  (%03.0f:%+.2f)  ", ampl, faza);
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
                sprintf (string_LCD_1, "> Ground [X;Y] <");
                lcd_puts (string_LCD_1);
                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "  (%03.0f:%+.2f)  ", st_A, st_F);              
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
        sprintf (string_LCD_1, "S> Zero [X;Y] <D");
        lcd_puts (string_LCD_1);
        lcd_gotoxy (0,1);
        sprintf (string_LCD_2, "(%03.0f:%+.2f) [%2x;%2x]", st_zero_A, st_zero_F, din_zero_A, din_zero_F);
        lcd_puts (string_LCD_2);
        return;
        };   
        
    lcd_gotoxy (0,0);
    if (rezym < 2)
        {
        if      (viz_ampl==0)    sprintf (string_LCD_1, "                ");
        else if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");    
        else if (viz_ampl==2)    sprintf (string_LCD_1, "?               ");
        else if (viz_ampl==3)    sprintf (string_LCD_1, "?_              ");    
        else if (viz_ampl==4)    sprintf (string_LCD_1, "??              ");
        else if (viz_ampl==5)    sprintf (string_LCD_1, "??_             ");    
        else if (viz_ampl==6)    sprintf (string_LCD_1, "???             ");
        else if (viz_ampl==7)    sprintf (string_LCD_1, "???_            ");    
        else if (viz_ampl==8)    sprintf (string_LCD_1, "????            ");
        else if (viz_ampl==9)    sprintf (string_LCD_1, "????_           ");    
        else if (viz_ampl==10)   sprintf (string_LCD_1, "?????           ");
        else if (viz_ampl==11)   sprintf (string_LCD_1, "?????_          ");    
        else if (viz_ampl==12)   sprintf (string_LCD_1, "??????          ");
        else if (viz_ampl==13)   sprintf (string_LCD_1, "??????_         ");    
        else if (viz_ampl==14)   sprintf (string_LCD_1, "???????         ");
        else if (viz_ampl==15)   sprintf (string_LCD_1, "???????_        ");    
        else if (viz_ampl==16)   sprintf (string_LCD_1, "????????        ");
        else if (viz_ampl==17)   sprintf (string_LCD_1, "????????_       ");    
        else if (viz_ampl==18)   sprintf (string_LCD_1, "?????????       ");
        else if (viz_ampl==19)   sprintf (string_LCD_1, "?????????_      ");    
        else if (viz_ampl==20)   sprintf (string_LCD_1, "??????????      ");
        else if (viz_ampl==21)   sprintf (string_LCD_1, "??????????_     ");    
        else if (viz_ampl==22)   sprintf (string_LCD_1, "???????????     ");
        else if (viz_ampl==23)   sprintf (string_LCD_1, "???????????_    ");    
        else if (viz_ampl==24)   sprintf (string_LCD_1, "????????????    ");
        else if (viz_ampl==25)   sprintf (string_LCD_1, "????????????_   ");    
        else if (viz_ampl==26)   sprintf (string_LCD_1, "?????????????   ");
        else if (viz_ampl==27)   sprintf (string_LCD_1, "?????????????_  ");    
        else if (viz_ampl==28)   sprintf (string_LCD_1, "??????????????  ");
        else if (viz_ampl==29)   sprintf (string_LCD_1, "??????????????_ ");   
        else if (viz_ampl==30)   sprintf (string_LCD_1, "??????????????? ");
        else if (viz_ampl==31)   sprintf (string_LCD_1, "???????????????_");    
        else                     sprintf (string_LCD_1, "????????????????");    
        }
        
    else if (rezym == 2)
        {
             if (viz_ampl==1)    sprintf (string_LCD_1, "        ??????? ");
        else if (viz_ampl==2)    sprintf (string_LCD_1, "        ??????  ");
        else if (viz_ampl==3)    sprintf (string_LCD_1, "        ?????   ");
        else if (viz_ampl==4)    sprintf (string_LCD_1, "        ????    ");    
        else if (viz_ampl==5)    sprintf (string_LCD_1, "        ???     ");   
        else if (viz_ampl==6)    sprintf (string_LCD_1, "        ??      ");   
        else if (viz_ampl==7)    sprintf (string_LCD_1, "        ?       ");  
        else if (viz_ampl==0)    sprintf (string_LCD_1, "                ");   
        else if (viz_ampl==8)    sprintf (string_LCD_1, "       ?        ");   
        else if (viz_ampl==9)    sprintf (string_LCD_1, "      ??        "); 
        else if (viz_ampl==10)   sprintf (string_LCD_1, "     ???        ");   
        else if (viz_ampl==11)   sprintf (string_LCD_1, "    ????        ");   
        else if (viz_ampl==12)   sprintf (string_LCD_1, "   ?????        ");   
        else if (viz_ampl==13)   sprintf (string_LCD_1, "  ??????        ");
        else                     sprintf (string_LCD_1, " ???????        ");     
        }

    else                         sprintf (string_LCD_1, "    Stop__Tx    ");

    lcd_puts (string_LCD_1);

    lcd_gotoxy (0,1);
         if (viz_faza==0)  sprintf (string_LCD_2, "?------II------?");
    else if (viz_faza==1)  sprintf (string_LCD_2, "?------II----o_O");
    else if (viz_faza==2)  sprintf (string_LCD_2, "?------II-----#?");
    else if (viz_faza==3)  sprintf (string_LCD_2, "?------II----#-?");
    else if (viz_faza==4)  sprintf (string_LCD_2, "?------II---#--?");
    else if (viz_faza==5)  sprintf (string_LCD_2, "?------II--#---?");
    else if (viz_faza==6)  sprintf (string_LCD_2, "?------II-#----?");
    else if (viz_faza==7)  sprintf (string_LCD_2, "?------II#-----?");
    else if (viz_faza==8)  sprintf (string_LCD_2, "?------I#------?");
    else if (viz_faza==9)  sprintf (string_LCD_2, "?------#I------?");
    else if (viz_faza==10) sprintf (string_LCD_2, "?-----#II------?");
    else if (viz_faza==11) sprintf (string_LCD_2, "?----#-II------?");
    else if (viz_faza==12) sprintf (string_LCD_2, "?---#--II------?");
    else if (viz_faza==13) sprintf (string_LCD_2, "?--#---II------?");
    else if (viz_faza==14) sprintf (string_LCD_2, "?-#----II------?");
    else if (viz_faza==15) sprintf (string_LCD_2, "?#-----II------?");
    else                   sprintf (string_LCD_2, ">_<----II------?");
           
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

void zvuk ()
    {  
    }    


void new (void)
    {
    new_st_A = 0xFF - read_adc (0);
    new_st_F = 0xFF - read_adc (3);
    st_A = new_st_A;
    st_F = asin((float)new_st_F/(float)new_st_A);    
    din_A = 0xFF - read_adc (1);
    din_F = 0xFF - read_adc (2);    
    return;
    }
    
float vektor_ampl (float a, float a_v, float b, float b_v)
    {
    float c;
    float ab_v;
    ab_v = a_v - b_v;
    c = sqrt (a*a + b*b - 2*a*b*cos(ab_v));
    return c;
    }  
 
float vektor_faza (float c, float a_v, float b, float b_v)
    {
    float ab_v, ac_v, c_v;
    ab_v = b_v - a_v;
    ac_v = asin(b * sin(ab_v) / c);
    c_v =  a_v - ac_v;
    return c_v;
    }         

void main_menu(void)
    {
    menu++;
    while (kn1==1) 
        {
        kn_klava();
        lcd_disp();
        };
    return;
    }
    
void rezymm(void)
    {    
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
    if (menu==1) mod_rock++;      

    else if (rezym == 0)
        {
        rock_A = vektor_ampl(st_zero_A, st_zero_F, new_st_A, new_st_F);
        rock_F = vektor_faza(rock_A, st_zero_F, new_st_A, new_st_F);
        }

    else if (rezym == 1)
        {    
        rock_sekt_A = new_st_A / 8;
        rock_sekt_F = new_st_F / 8;        
        rock_pos_A = new_st_A % 8; 
        rock_pos_F = new_st_F % 8; 

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
    if (menu==1) mod_gnd++;

    else if (rezym == 0)
        {
        gnd_A = vektor_ampl(st_zero_A, st_zero_F, new_st_A, new_st_F);
        gnd_F = vektor_faza(gnd_A, st_zero_F, new_st_A, new_st_F);
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
    if (menu == 1) mod_all_met++;

    st_zero_A = st_A;
    st_zero_F = st_F;
    din_zero_A = din_A;
    din_zero_F = din_F;
    return;
    }    

void vizual (void)
    {
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

        if      (faza> 1.40)   viz_faza=0;
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

             if (din_F > din_zero_F +92 )    viz_faza=16;
        else if (din_F > din_zero_F +81 )    viz_faza=15;
        else if (din_F > din_zero_F +70 )    viz_faza=14;
        else if (din_F > din_zero_F +59 )    viz_faza=13;
        else if (din_F > din_zero_F +48 )    viz_faza=12;
        else if (din_F > din_zero_F +37 )    viz_faza=11;  
        else if (din_F > din_zero_F +26 )    viz_faza=10;
        else if (din_F > din_zero_F +15 )    viz_faza=9; 
        else if (din_F > din_zero_F     )    viz_faza=0;
        else if (din_F > din_zero_F -15 )    viz_faza=8;  
        else if (din_F > din_zero_F -26 )    viz_faza=7;
        else if (din_F > din_zero_F -37 )    viz_faza=6;  
        else if (din_F > din_zero_F -48 )    viz_faza=5;
        else if (din_F > din_zero_F -59 )    viz_faza=4;  
        else if (din_F > din_zero_F -70 )    viz_faza=3;
        else if (din_F > din_zero_F -81 )    viz_faza=2;        
        else                                 viz_faza=1;   
        };
    return;
    }
    
void start(void)
    {
    // Declare your local variables here

    // Input/Output Ports initialization
    // Port A initialization
    PORTA=0x80;
    DDRA=0x00;

    // Port B initialization
    PORTB=0x00;
    DDRB=0x08;

    // Port C initialization
    PORTC=0x00;
    DDRC=0x00;

    // Port D initialization
    PORTD=0x00;
    DDRD=0xB0;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 16,000 kHz
    // Mode: Fast PWM top=FFh
    // OC0 output: Non-Inverted PWM
    TCCR0=0x6D;
    TCNT0=0x00;
    OCR0=0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 16384,000 kHz
    // Mode: CTC top=ICR1
    // OC1A output: Toggle
    // OC1B output: Toggle
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer 1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=0x50;
    TCCR1B=0x19;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x02;
    ICR1L=0x85;
    OCR1AH=0x02;
    OCR1AL=0x84;
    OCR1BH=0x00;
    OCR1BL=0x40;

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

    // ADC initialization
    // ADC Clock frequency: 256,000 kHz
    // ADC Voltage Reference: Int., cap. on AREF
    // Only the 8 most significant bits of
    // the AD conversion result are used
    ADMUX=ADC_VREF_TYPE & 0xff;
    ADCSRA=0x8E;

    #asm("wdr")
    // LCD module initialization
    lcd_init(16);

    lcd_gotoxy (0,0);
    sprintf (string_LCD_1, "FINDER ^_^ Exxus");
    lcd_puts (string_LCD_1);
    lcd_gotoxy (0,1);
    sprintf (string_LCD_2, "v1.7.2   md4u.ru");
    lcd_puts (string_LCD_2);
    delay_ms (2);    

    #asm("sei")

    if (Ftx_ee == 0xFFFF)
        {
        Ftx_ee = 0x0284;
        ICR1H = 0x02;
        ICR1L = 0x85;
        };
    if (Frx_ee == 0xFFFF) Frx_ee = 0x0040;
    Ftx = Ftx_ee;
    Frx = Frx_ee;

    kn_klava();
    if (kn1==1) while (1)
                {
                kn_klava();
                new();

                if (kn2==1) 
                        {
                        Ftx--;
                        ICR1L--;   
                        };
                if (kn3==1) 
                        {
                        Ftx++;
                        ICR1L++;   
                        };
                if (kn4==1) 
                        {
                        Frx++;
                        if (Frx > Ftx) Frx = 0;
                        };   
                if (kn5==1) 
                        {
                        Frx--;
                        if (Frx == 0) Frx = Ftx;
                        };  
                if (kn6==1) 
                        {                        
                        lcd_gotoxy (12,0);
                        if (Ftx != Ftx_ee) 
                                {
                                Ftx_ee = Ftx;
                                sprintf (string_LCD_1, "Save");
                                }
                        else    sprintf (string_LCD_1, "O.k.");                              
                        lcd_puts (string_LCD_1);  

                        lcd_gotoxy (12,1);
                        if  (Frx != Frx_ee)
                                {
                                Frx_ee = Frx;
                                sprintf (string_LCD_2, "Save");
                                }     
                        else    sprintf (string_LCD_2, "O.k.");                                                               
                        lcd_puts (string_LCD_2);   

                        while (kn6==1) kn_klava();
                        continue;
                        };

                lcd_gotoxy (0,0);
                sprintf (string_LCD_1, "Freq-TX %3x [%2x]", Ftx, new_st_A);
                lcd_puts (string_LCD_1);    

                lcd_gotoxy (0,1);
                sprintf (string_LCD_2, "Faza-X  %3x [%2x]", Frx, new_st_F);
                lcd_puts (string_LCD_2);                                     

                delay_ms (200);
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
    new();
          
    if (kn1==1) main_menu();
    if (kn2==1) rezymm ();
    if (kn3==1) barrier();
    if (kn4==1) rock();   
    if (kn5==1) ground();  
    if (kn6==1) zero();

    ampl = vektor_ampl (st_zero_A, st_zero_F, new_st_A, new_st_F);  
    faza = vektor_faza (ampl, st_zero_F, new_st_A, new_st_F); 

    if (rezym == 0)
        {      
        if (mod_gnd == 1)
                {
                if ((new_st_F <= gnd_F + bar_rad + 0.005 ) && (new_st_F >= gnd_F - bar_rad - 0.005 ))
                    {
                    gnd_A = new_st_A;
                    };   
                ampl = vektor_ampl (gnd_A, gnd_F, new_st_A, new_st_F);  
                faza = vektor_faza (ampl, gnd_F, new_st_A, new_st_F); 
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
                gnd_sekt_A = (int)new_st_A / 8;
                gnd_sekt_F = (int)new_st_F / 8;        
                gnd_pos_A = (int)new_st_A % 8; 
                gnd_pos_F = (int)new_st_F % 8; 

                     if ((gnd_pos_F > 4) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x08)) zemlq = 1;
                else if ((gnd_pos_F > 0) && (gnd_pos_A > 4) && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x04)) zemlq = 1;
                else if ((gnd_pos_F > 4)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x02)) zemlq = 1;    
                else if ((gnd_pos_F > 0)                    && (rastr_st[gnd_sekt_F][gnd_sekt_A] & 0x01)) zemlq = 1;
                else                                                                                      zemlq = 0;

                if (zemlq == 1) gnd_A = ampl;
                ampl = vektor_ampl (gnd_A, gnd_F, new_st_A, new_st_F);  
                faza = vektor_faza (ampl, gnd_F, new_st_A, new_st_F); 
                };              

        if (mod_rock == 1)
                {
                rock_sekt_A = (int)new_st_A / 8;
                rock_sekt_F = (int)new_st_F / 8;        
                rock_pos_A = (int)new_st_A % 8; 
                rock_pos_F = (int)new_st_F % 8; 

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


    zvuk();         
    vizual ();            
    lcd_disp();
           
    delay_ms (2);
    }
}