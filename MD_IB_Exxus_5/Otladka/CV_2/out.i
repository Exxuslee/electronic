
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

#asm
   .equ __i2c_port=0x18 ;PORTB
   .equ __sda_bit=1
   .equ __scl_bit=0
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

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

char string_LCD_1[20], string_LCD_2[20];
unsigned int zero_Y, zero_X;
float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, gnd_ampl_max, gnd_faza_max, rock_ampl_max, rock_faza_max;
float now_ampl, now_faza, bar_rad;
unsigned char vol, bar;
unsigned char X, Y, viz_ampl, viz_faza;
unsigned int batt_celoe, batt_drob;
bit kn1, kn2, kn3, kn4, kn5, kn6, menu, mod_gnd, mod_rock, mod_all_met;

float temp_ampl = 0;
float temp_faza = 0;

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x60 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

void batt_zarqd(void)
{
unsigned int temp;
temp=read_adc(0);
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
PORTD.6=1;

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "%d.%dV V=%d B=%d   ", batt_celoe, batt_drob, vol, bar);
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
PORTD.6=1;
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "Volume %d        ", vol);
lcd_puts (string_LCD_2);
return;
};

if (kn3==1)
{
PORTD.6=1;
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "Barrier %d       ", bar);
lcd_puts (string_LCD_2);
return;
}; 

if (kn4==1)
{
PORTD.6=1;
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
PORTD.6=1;
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
PORTD.6=1;
lcd_gotoxy (0,0);
sprintf (string_LCD_1, ">>>>> Zero <<<<<");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "%x %x %x %x ", zero_Y, zero_X, Y, X);
lcd_puts (string_LCD_2);
return;
};   
lcd_gotoxy (0,0);
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

void new_X_Y (void)
{
unsigned char adres = 0x89;
i2c_start();
delay_us (20);
i2c_write(adres);
delay_us (20);
X = i2c_read(1);
delay_us (20);
Y = i2c_read(0);
delay_us (20);      
i2c_stop();
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

void volume(void)
{
vol++;
if (vol==10) vol=0;
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
zero_Y=0;
zero_X=X;

}

void main(void)
{

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0xFF;

PORTD=0x03;
DDRD=0xA3;

ADMUX=0x60 & 0xff;
ADCSRA=0x83;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x00;

ACSR=0x80;
SFIOR=0x00;

UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x08;

lcd_init(16);

i2c_init();

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "v1.5 ^_^ md4u.ru");
lcd_puts (string_LCD_2);
delay_ms (4000);

while (1)
{

#asm("wdr")
new_X_Y ();
kn_klava();

if (kn1==1) main_menu();
if (kn2==1) volume();
if (kn3==1) barrier();
if (kn4==1) rock();   
if (kn5==1) ground();  
if (kn6==1) zero();

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

batt_zarqd();
lcd_disp();
zvuk();

delay_ms (100);
PORTD.6=0;
};
}
