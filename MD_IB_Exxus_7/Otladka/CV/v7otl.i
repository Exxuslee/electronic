
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADCSR=6;     
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

#pragma used-
#pragma library lcd.lib

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma used+

signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);

#pragma used-
#pragma library math.lib

char string_LCD_1[20], string_LCD_2[20];
unsigned int st_zero_Y, st_zero_X, din_zero_Y, din_zero_X;
float  gnd_faza, rock_faza;
float ampl, faza, bar_rad;
unsigned char bar, rezym;
unsigned char st_X, st_Y, din_X, din_Y, viz_ampl, viz_faza, viz_din, din_max, din_min, gnd_X, gnd_Y, rock_X, rock_Y;
unsigned char adc_data;
float batt;
bit kn1, kn2, kn3, kn4, kn5, kn6, mod_gnd, mod_rock, mod_all_met, zemlq, kamen, menu;
unsigned char rastr_st[0x20][0x20], gnd_pos_X, gnd_pos_Y, rock_pos_X, rock_pos_Y, gnd_sekt_X, gnd_sekt_Y, rock_sekt_X, rock_sekt_Y; 
signed char geb;
eeprom unsigned int Ftx_ee, Frx_ee;

interrupt [17] void adc_isr(void)
{

adc_data=ADCH;
}

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x20 & 0xff);

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
sprintf (string_LCD_2, "[%2x;%2x]=Z", st_X, st_Y);
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
sprintf (string_LCD_1, "> Ground [X;Y] <");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "  [%2x;%2x]   ", st_X, st_Y);              
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
sprintf (string_LCD_2, "[%2x;%2x]  [%2x;%2x]", st_zero_X, st_zero_Y, din_zero_X, din_zero_Y);
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

void zvuk ()
{
#asm("wdr")
if ((mod_all_met == 1) && (viz_faza > 11))
{
OCR0 = 0x00;
return;
};

if (rezym <2)
{
if      (viz_ampl == 0)  OCR0 = 0x00;
else if (viz_ampl <  2)  OCR0 = 0x10;
else if (viz_ampl <  4)  OCR0 = 0x20;
else if (viz_ampl <  6)  OCR0 = 0x30;
else if (viz_ampl <  8)  OCR0 = 0x40;
else if (viz_ampl < 10)  OCR0 = 0x50;
else if (viz_ampl < 12)  OCR0 = 0x60;
else if (viz_ampl < 14)  OCR0 = 0x70;
else if (viz_ampl < 16)  OCR0 = 0x80;
else if (viz_ampl < 18)  OCR0 = 0x90;
else if (viz_ampl < 20)  OCR0 = 0xA0;
else if (viz_ampl < 22)  OCR0 = 0xB0;
else if (viz_ampl < 24)  OCR0 = 0xC0;
else if (viz_ampl < 26)  OCR0 = 0xD0;
else if (viz_ampl < 28)  OCR0 = 0xE0;
else if (viz_ampl < 30)  OCR0 = 0xF0;
else                     OCR0 = 0xFF;
}
else if (rezym == 2)
{
if (viz_din ==1 )   OCR0 = 0x00;
else if (viz_din == 2)   OCR0 = 0x20;
else if (viz_din == 3)   OCR0 = 0x40;
else if (viz_din == 4)   OCR0 = 0x60;
else if (viz_din == 5)   OCR0 = 0x80;    
else if (viz_din == 6)   OCR0 = 0xA0;   
else if (viz_din == 7)   OCR0 = 0xC0;   
else if (viz_din == 8)   OCR0 = 0xE0;  
else                     OCR0 = 0xFF;    
};
return;    
}

void new_X_Y_stat (void)
{
#asm("wdr")
st_X = 0xFF - read_adc (0);
st_Y = 0xFF - read_adc (3);
return;
}

void new_X_Y_din (void)
{
#asm("wdr")
din_X = 0xFF - read_adc (1);
din_Y = 0xFF - read_adc (2);
return;      
}    

float vektor_ampl (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
{
long int YY, XX;
float YX2;
float YX3;
#asm("wdr")
if (Y_1 > Y_2) YY = Y_1 - Y_2;
else YY = Y_2 - Y_1;
if (X_1 > X_2) XX = X_1 - X_2;
else XX = X_2 - X_1; 
YX2 = YY*YY + XX*XX;
YX3 = sqrt (YX2); 
return YX3;
}

float vektor_faza (unsigned int Y_1, unsigned int X_1, unsigned int Y_2, unsigned int X_2)
{
signed int YY, XX;
float YX2;
#asm("wdr")
YY = Y_1 - Y_2;
XX = X_1 - X_2; 
YX2 = atan ((float)YY/XX);    
return YX2;
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
rock_faza = vektor_faza(st_Y, st_X, st_zero_Y, st_zero_X);
rock_X = st_X;
rock_Y = st_Y;
}    
else if (rezym == 1)
{    
rock_sekt_X = st_X / 8;
rock_sekt_Y = st_Y / 8;        
rock_pos_X = st_X % 8; 
rock_pos_Y = st_Y % 8; 

if ((rock_pos_X > 4) & (rock_pos_Y > 4)) rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x80;
else if ((rock_pos_X > 0) & (rock_pos_Y > 4)) rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x40;
else if  (rock_pos_X > 4)                     rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x20;        
else                                          rastr_st[rock_sekt_X][rock_sekt_Y] |= 0x10;
}          
else if (rezym == 2) 
{
geb++;
OCR1B++;
if (OCR1B > OCR1A) OCR1B = 0;    
};
return;
}

void ground(void)
{   
#asm("wdr")
if (menu==1) mod_gnd++;

else if (rezym == 0)
{    
gnd_faza = vektor_faza(st_Y, st_X, st_zero_Y, st_zero_X);
gnd_X = st_X;
gnd_Y = st_Y;
}    
else if (rezym == 1) 
{
gnd_sekt_X = st_X / 8;
gnd_sekt_Y = st_Y / 8;        
gnd_pos_X = st_X % 8; 
gnd_pos_Y = st_Y % 8; 

if ((gnd_pos_X > 4) & (gnd_pos_Y > 4)) rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x08;
else if ((gnd_pos_X > 0) & (gnd_pos_Y > 4)) rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x04;
else if  (gnd_pos_X > 4)                    rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x02;        
else                                        rastr_st[gnd_sekt_X][gnd_sekt_Y] |= 0x01;
}
else if (rezym == 2) 
{
geb--;
OCR1B--;
if (OCR1B == 0) OCR1B = OCR1A;        
}; 
return;
}

void zero(void)
{
#asm("wdr")
if (menu == 1) mod_all_met++;

st_zero_X = st_X;
st_zero_Y = st_Y;
din_zero_X = din_X;
din_zero_Y = din_Y;
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
if (din_Y > din_zero_Y +92 )    viz_ampl=14;
else if (din_Y > din_zero_Y +81 )    viz_ampl=13;
else if (din_Y > din_zero_Y +70 )    viz_ampl=12;
else if (din_Y > din_zero_Y +59 )    viz_ampl=11;
else if (din_Y > din_zero_Y +48 )    viz_ampl=10;
else if (din_Y > din_zero_Y +37 )    viz_ampl=9;
else if (din_Y > din_zero_Y +26 )    viz_ampl=8; 
else if (din_Y > din_zero_Y     )    viz_ampl=0;
else if (din_Y > din_zero_Y -26 )    viz_ampl=7; 
else if (din_Y > din_zero_Y -37 )    viz_ampl=6;
else if (din_Y > din_zero_Y -48 )    viz_ampl=5;
else if (din_Y > din_zero_Y -59 )    viz_ampl=4;
else if (din_Y > din_zero_Y -70 )    viz_ampl=3;
else if (din_Y > din_zero_Y -81 )    viz_ampl=2;
else                                 viz_ampl=1; 

if (din_X > din_zero_X +92 )    viz_faza=16;
else if (din_X > din_zero_X +81 )    viz_faza=15;
else if (din_X > din_zero_X +70 )    viz_faza=14;
else if (din_X > din_zero_X +59 )    viz_faza=13;
else if (din_X > din_zero_X +48 )    viz_faza=12;
else if (din_X > din_zero_X +37 )    viz_faza=11;  
else if (din_X > din_zero_X +26 )    viz_faza=10;
else if (din_X > din_zero_X +15 )    viz_faza=9; 
else if (din_X > din_zero_X     )    viz_faza=0;
else if (din_X > din_zero_X -15 )    viz_faza=8;  
else if (din_X > din_zero_X -26 )    viz_faza=7;
else if (din_X > din_zero_X -37 )    viz_faza=6;  
else if (din_X > din_zero_X -48 )    viz_faza=5;
else if (din_X > din_zero_X -59 )    viz_faza=4;  
else if (din_X > din_zero_X -70 )    viz_faza=3;
else if (din_X > din_zero_X -81 )    viz_faza=2;        
else                                 viz_faza=1;   
};
return;
}

void start(void)
{

PORTA=0x80;
DDRA=0x00;

PORTB=0x00;
DDRB=0x08;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xB0;

TCCR0=0x6D;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

WDTCR=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x00;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x20 & 0xff;
ADCSRA=0x8E;

#asm("wdr")

lcd_init(16);

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "FINDER ^_^ Exxus");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "v1.7.0   md4u.ru");
lcd_puts (string_LCD_2);
delay_ms (2500);

ampl = 0;
din_max=0x7f;
din_min=0x7f;
st_zero_X=0x7f;
st_zero_Y=0x00;
din_zero_X=0x7f;
din_zero_Y=0x7F;
gnd_X=0x7f;
gnd_Y=0x00;

#asm("sei")

if (Ftx_ee == 0xFFFF)
{
Ftx_ee = 0x0284;
ICR1H = 0x02;
ICR1L = 0x85;
};
if (Frx_ee == 0xFFFF) Frx_ee = 0x0040;
OCR1A = Ftx_ee;
OCR1B = Frx_ee;

kn_klava();
if (kn1==1) while (1)
{
kn_klava();
new_X_Y_stat ();

if (kn2==1) 
{
OCR1A--;
ICR1L--;   
};
if (kn3==1) 
{
OCR1A++;
ICR1L++;   
};
if (kn4==1) 
{
OCR1B++;
if (OCR1B > OCR1A) OCR1B = 0;
};   
if (kn5==1) 
{
OCR1B--;
if (OCR1B == 0) OCR1B = OCR1A;
};  
if (kn6==1) 
{                        
if (OCR1A != Ftx_ee) 
{
Ftx_ee = OCR1A;
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

if  (OCR1B != Frx_ee)
{
Frx_ee = OCR1B;
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
sprintf (string_LCD_1, "Freq-TX %3x [%2x]", OCR1A, st_Y);
lcd_puts (string_LCD_1);    

lcd_gotoxy (0,1);
sprintf (string_LCD_2, "Faza-X  %3x [%2x]", OCR1B, st_X);
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

kn_klava();

#asm("wdr") 
new_X_Y_stat ();
new_X_Y_din ();

if (kn1==1) main_menu();
if (kn2==1) rezymm ();
if (kn3==1) barrier();
if (kn4==1) rock();   
if (kn5==1) ground();  
if (kn6==1) zero();

if (rezym == 0)
{      

ampl = vektor_ampl (st_Y, st_X, st_zero_Y, st_zero_X);
faza = vektor_faza (st_Y, st_X, st_zero_Y, st_zero_X);          

if (mod_gnd == 1)
{
if ((faza <= gnd_faza + bar_rad + 0.005 ) && (faza >= gnd_faza - bar_rad - 0.005 ))
{
gnd_X = st_X;
gnd_Y = st_Y;
};   
ampl = vektor_ampl (st_Y, st_X, gnd_Y, gnd_X);
faza = vektor_faza (st_Y, st_X, gnd_Y, gnd_X);
};     

if (mod_rock == 1)
{
if ((faza <= rock_faza + bar_rad + 0.005 ) && (faza >= rock_faza - bar_rad - 0.005 ))
{
ampl = 0;
faza = 1.45;
};
};
}

else if (rezym == 1) 
{    
ampl = vektor_ampl (st_Y, st_X, st_zero_Y, st_zero_X);
faza = vektor_faza (st_Y, st_X, st_zero_Y, st_zero_X);  

if (mod_gnd == 1)
{
gnd_sekt_X = st_X / 8;
gnd_sekt_Y = st_Y / 8;        
gnd_pos_X = st_X % 8; 
gnd_pos_Y = st_Y % 8; 

if ((gnd_pos_X > 4) && (gnd_pos_Y > 4) && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x08)) zemlq = 1;
else if ((gnd_pos_X > 0) && (gnd_pos_Y > 4) && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x04)) zemlq = 1;
else if ((gnd_pos_X > 4)                    && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x02)) zemlq = 1;    
else if ((gnd_pos_X > 0)                    && (rastr_st[gnd_sekt_X][gnd_sekt_Y] & 0x01)) zemlq = 1;
else                                                                                      zemlq = 0;

if (zemlq == 1)
{
gnd_X = st_X;
gnd_Y = st_Y;
};
ampl = vektor_ampl (st_Y, st_X, gnd_Y, gnd_X);
faza = vektor_faza (st_Y, st_X, gnd_Y, gnd_X);
};              

if (mod_rock == 1)
{
rock_sekt_X = st_X / 8;
rock_sekt_Y = st_Y / 8;        
rock_pos_X = st_X % 8; 
rock_pos_Y = st_Y % 8; 

if ((rock_pos_X > 4) && (rock_pos_Y > 4) && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x80)) kamen = 1;
else if ((rock_pos_X > 0) && (rock_pos_Y > 4) && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x40)) kamen = 1;
else if ((rock_pos_X > 4)                     && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x20)) kamen = 1;    
else if ((rock_pos_X > 0)                     && (rastr_st[rock_sekt_X][rock_sekt_Y] & 0x10)) kamen = 1;
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
if (din_Y >= din_zero_Y)
{
if (din_Y >= din_max) din_max=din_Y;
else 
{
din_max--;
din_min++;
};
}
else
{
if (din_Y < din_min) din_min=din_Y;
else 
{
din_min++;
din_max--;
};                
};  

if (din_max < din_zero_Y) din_max=din_zero_Y;
if (din_min > din_zero_Y) din_max=din_zero_Y;

if ((din_zero_Y-din_min) < (din_max-din_zero_Y))
{           
if (din_max> din_zero_Y +92)   viz_din=8;
else if (din_max> din_zero_Y +81)   viz_din=7;             
else if (din_max> din_zero_Y +70)   viz_din=6;
else if (din_max> din_zero_Y +59)   viz_din=5;
else if (din_max> din_zero_Y +48)   viz_din=4; 
else if (din_max> din_zero_Y +37)   viz_din=3; 
else if (din_max> din_zero_Y +26)   viz_din=2; 
else if (din_max> din_zero_Y +15)   viz_din=1; 
else                                viz_din=0;
}         
else 
{
if (din_min> din_zero_Y -5 )   viz_din=0;
else if (din_min> din_zero_Y -15)   viz_din=1;             
else if (din_min> din_zero_Y -26)   viz_din=2;
else if (din_min> din_zero_Y -37)   viz_din=3;
else if (din_min> din_zero_Y -48)   viz_din=4; 
else if (din_min> din_zero_Y -59)   viz_din=5; 
else if (din_min> din_zero_Y -70)   viz_din=6; 
else if (din_min> din_zero_Y -81)   viz_din=7; 
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

delay_ms (200);
}; 
}
