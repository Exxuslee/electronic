
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
sfrb ICR1=0x26;
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
int x_1, x_2;
int faza, amplituda;
unsigned int zero_amplituda, zero_faza, viz_period, y_gnd, x_gnd;
float  gnd_amplituda, gnd_faza, rock_amplituda, rock_faza, now_amplituda, now_faza;
unsigned int period;
unsigned char vol, bar, menu, tik_old, tik_new, gnd_rage;
unsigned char viz_amplituda, viz_faza;
unsigned int batt_celoe, batt_drob;
bit kn1, kn2, kn3, kn4, kn5, kn6;

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x00 & 0xff);

delay_us(10);

ADCSRA|=0x40;

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
PORTD.6=1;
lcd_gotoxy (0,0);
sprintf (string_LCD_1, "%d.%dV V=%d B=%d   ", batt_celoe, batt_drob, vol, bar);
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "%x %x   ", faza, amplituda);
lcd_puts (string_LCD_2);
return;        
};
if (menu==2)
{
PORTD.6=1;
lcd_gotoxy (0,0);
sprintf (string_LCD_1, " TX calibration ");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "tik %d => %dHz", tik_old, viz_period);
lcd_puts (string_LCD_2);
return;        
};
if (menu==3)
{
PORTD.6=1;
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
PORTD.6=1;
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "V%d", vol);
lcd_puts (string_LCD_2);
return;
};
if (kn3==1)
{
PORTD.6=1;
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "B%d", bar);
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
sprintf (string_LCD_2, "%f %f", rock_amplituda, rock_faza);
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
sprintf (string_LCD_2, "%f %f ", gnd_amplituda, gnd_faza);
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
sprintf (string_LCD_2, "%x %x %x %x ", zero_amplituda, zero_faza, amplituda, faza);
lcd_puts (string_LCD_2);
return;
};   
lcd_gotoxy (0,0);
if (viz_amplituda==0)    sprintf (string_LCD_1, "                ");
if (viz_amplituda==1)    sprintf (string_LCD_1, "_               ");    
if (viz_amplituda==2)    sprintf (string_LCD_1, "ÿ               ");
if (viz_amplituda==3)    sprintf (string_LCD_1, "ÿ_              ");    
if (viz_amplituda==4)    sprintf (string_LCD_1, "ÿÿ              ");
if (viz_amplituda==5)    sprintf (string_LCD_1, "ÿÿ_             ");    
if (viz_amplituda==6)    sprintf (string_LCD_1, "ÿÿÿ             ");
if (viz_amplituda==7)    sprintf (string_LCD_1, "ÿÿÿ_            ");    
if (viz_amplituda==8)    sprintf (string_LCD_1, "ÿÿÿÿ            ");
if (viz_amplituda==9)    sprintf (string_LCD_1, "ÿÿÿÿ_           ");    
if (viz_amplituda==10)   sprintf (string_LCD_1, "ÿÿÿÿÿ           ");
if (viz_amplituda==11)   sprintf (string_LCD_1, "ÿÿÿÿÿ_          ");    
if (viz_amplituda==12)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ          ");
if (viz_amplituda==13)   sprintf (string_LCD_1, "ÿÿÿÿÿÿ_         ");    
if (viz_amplituda==14)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ         ");
if (viz_amplituda==15)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿ_        ");    
if (viz_amplituda==16)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ        ");
if (viz_amplituda==17)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿ_       ");    
if (viz_amplituda==18)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ       ");
if (viz_amplituda==19)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿ_      ");    
if (viz_amplituda==20)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ      ");
if (viz_amplituda==21)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿ_     ");    
if (viz_amplituda==22)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ     ");
if (viz_amplituda==23)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿ_    ");    
if (viz_amplituda==24)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ    ");
if (viz_amplituda==25)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿ_   ");    
if (viz_amplituda==26)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ   ");
if (viz_amplituda==27)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿ_  ");    
if (viz_amplituda==28)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ  ");
if (viz_amplituda==29)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_ ");   
if (viz_amplituda==30)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ");
if (viz_amplituda==31)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ_");    
if (viz_amplituda==32)   sprintf (string_LCD_1, "ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ");    
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
if (viz_faza==0)  sprintf (string_LCD_2, "   Û-----#-----Ü");
if (viz_faza==1)  sprintf (string_LCD_2, "   Û----#I-----Ü");
if (viz_faza==2)  sprintf (string_LCD_2, "   Û---#-I-----Ü");
if (viz_faza==3)  sprintf (string_LCD_2, "   Û--#--I-----Ü");
if (viz_faza==4)  sprintf (string_LCD_2, "   Û-#---I-----Ü");
if (viz_faza==5)  sprintf (string_LCD_2, "   Û#----I-----Ü");
if (viz_faza==6)  sprintf (string_LCD_2, "   Û-----I#----Ü");
if (viz_faza==7)  sprintf (string_LCD_2, "   Û-----I-#---Ü");
if (viz_faza==8)  sprintf (string_LCD_2, "   Û-----I--#--Ü");
if (viz_faza==9)  sprintf (string_LCD_2, "   Û-----I---#-Ü");
if (viz_faza==10) sprintf (string_LCD_2, "   Û-----I----#Ü");
lcd_puts (string_LCD_2);    
PORTD.6=0;
}

void real_faza_i_amp (void)
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
if (faza > period) faza = faza - period;   
};
while (TCNT1 != faza); 
PORTA.6=1;
amplituda=read_adc(3);
PORTA.6=0;
}

float vektor_amp (unsigned int koord_1_1, unsigned int koord_1_2, unsigned int koord_2_1, unsigned int koord_2_2)
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

float th_cos (float a, float aa_x, float b, float bb_x)
{
float c;
float aabb;
#asm("wdr");
aabb = aa_x - bb_x;
c = sqrt (a*a + b*b - 2*a*b*cos(aabb));
return c;
}   

float th_sin (float c, int b_y, int b_x, int c_y, int c_x)
{
int ab;
float temp;
#asm("wdr");
if (b_y > c_y) ab = b_y - c_y;
else ab = c_y - b_y; 
temp = asin (ab/c);
if (c_x > b_x) temp = 3.141593 - temp;
return temp;
}   

void main_menu(void)
{
#asm("wdr");
menu++;
if (menu==255) menu=3;
if (menu==4) menu=0;
while (kn1==1) 
{
kn_klava();
lcd_disp();
};
}

void volume(void)
{
#asm("wdr");
if (menu==2) tik_new++;
if (menu==3) gnd_rage++;
else vol++;
if (vol==10) vol=0;
while (kn2==1) 
{
kn_klava();
lcd_disp();
};
}    

void barrier(void)
{
#asm("wdr");
if (menu==2) tik_new--;
if (menu==3) gnd_rage--;
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
rock_amplituda = vektor_amp(amplituda, faza, zero_amplituda, zero_faza);
rock_faza = vektor_faza(amplituda, faza, zero_amplituda, zero_faza);
}

void ground(void)
{
#asm("wdr");
y_gnd = amplituda;
x_gnd = faza;
gnd_amplituda = vektor_amp(amplituda, faza, zero_amplituda, zero_faza);
gnd_faza = vektor_faza(amplituda, faza, zero_amplituda, zero_faza);
}

void zero(void)
{
#asm("wdr");
zero_amplituda=0;
zero_faza=0x0320;

}

void TX_calibration(void)
{
if (tik_old < tik_new) 
{
PORTD.0=0;
delay_ms(1);
PORTD.0=1;
tik_old = tik_new;
};
if  (tik_old > tik_new)
{        
PORTD.1=0;
delay_ms(1);
PORTD.1=1;
tik_old = tik_new;
};
viz_period = period / 8;
}

void main(void)
{

PORTA=0x00;
DDRA=0xC0;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x03;
DDRD=0xA3;

ACSR=0x00;
SFIOR=0x00;

ADMUX=0x00 & 0xff;
ADCSRA=0x83;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x61;
TCNT2=0x00;
OCR2=0x7F;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x0C;

WDTCR=0x00;

lcd_init(16);

lcd_gotoxy (0,0);
sprintf (string_LCD_1, "$$$ MD_Exxus $$$");
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "   v0.4   ^_^   ");
lcd_puts (string_LCD_2);
delay_ms (2000);

tik_new=1;
period=0x063F;              
x_gnd=period/2;
zero_faza=period/2;

while (1)
{

float temp_amplituda;
float temp_faza;
#asm("wdr");
real_faza_i_amp ();
kn_klava();
if (kn1==1) main_menu();
if (kn2==1) volume();
if (kn3==1) barrier();
if (kn4==1) rock();   
if (kn5==1) ground();  
if (kn6==1) zero();
if (menu==2) TX_calibration();

now_amplituda= vektor_amp (amplituda, faza, zero_amplituda, zero_faza);
now_faza= vektor_faza (amplituda, faza, zero_amplituda, zero_faza);

temp_amplituda = th_cos (now_amplituda, now_faza, gnd_amplituda, gnd_faza);
temp_faza = th_sin (temp_amplituda, amplituda, faza, y_gnd, x_gnd);

if (temp_amplituda> 2079 ) viz_amplituda=32;
else if (temp_amplituda> 2016 ) viz_amplituda=31;      
else if (temp_amplituda> 1953 ) viz_amplituda=30;
else if (temp_amplituda> 1890 ) viz_amplituda=29; 
else if (temp_amplituda> 1827 ) viz_amplituda=28; 
else if (temp_amplituda> 1764 ) viz_amplituda=27; 
else if (temp_amplituda> 1701 ) viz_amplituda=26; 
else if (temp_amplituda> 1638 ) viz_amplituda=25; 
else if (temp_amplituda> 1575 ) viz_amplituda=24; 
else if (temp_amplituda> 1512 ) viz_amplituda=23; 
else if (temp_amplituda> 1449 ) viz_amplituda=22; 
else if (temp_amplituda> 1386 ) viz_amplituda=21;
else if (temp_amplituda> 1323 ) viz_amplituda=20;
else if (temp_amplituda> 1260 ) viz_amplituda=19;
else if (temp_amplituda> 1197 ) viz_amplituda=18; 
else if (temp_amplituda> 1134 ) viz_amplituda=17; 
else if (temp_amplituda> 1071 ) viz_amplituda=16; 
else if (temp_amplituda> 1008 ) viz_amplituda=15; 
else if (temp_amplituda> 945  ) viz_amplituda=14; 
else if (temp_amplituda> 882  ) viz_amplituda=13; 
else if (temp_amplituda> 819  ) viz_amplituda=12; 
else if (temp_amplituda> 756  ) viz_amplituda=11; 
else if (temp_amplituda> 693  ) viz_amplituda=10;
else if (temp_amplituda> 630  ) viz_amplituda=9;
else if (temp_amplituda> 567  ) viz_amplituda=8;
else if (temp_amplituda> 504  ) viz_amplituda=7;
else if (temp_amplituda> 441  ) viz_amplituda=6;
else if (temp_amplituda> 378  ) viz_amplituda=5;
else if (temp_amplituda> 315  ) viz_amplituda=4; 
else if (temp_amplituda> 252  ) viz_amplituda=3; 
else if (temp_amplituda> 189  ) viz_amplituda=2; 
else if (temp_amplituda> 126  ) viz_amplituda=1; 
else if (temp_amplituda> 63   ) viz_amplituda=0; 

if (temp_faza> 3.14) viz_faza=0;
else if (temp_faza> 2.86) viz_faza=5;
else if (temp_faza> 2.57) viz_faza=4;
else if (temp_faza> 2.28) viz_faza=3;
else if (temp_faza> 2.00) viz_faza=2;
else if (temp_faza> 1.71) viz_faza=1;
else if (temp_faza> 1.43) viz_faza=0;
else if (temp_faza> 1.14) viz_faza=6;
else if (temp_faza> 0.86) viz_faza=7;
else if (temp_faza> 0.57) viz_faza=8;
else if (temp_faza> 0.29) viz_faza=9; 
else if (temp_faza> 0.00) viz_faza=10;     

batt_zarqd();
lcd_disp();
#asm("wdr");
};
}
