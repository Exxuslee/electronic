
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
int x_1, x_2;
int faza, ampl;
unsigned int zero_ampl, zero_faza, y_gnd, x_gnd;
float  gnd_ampl, gnd_faza, rock_ampl, rock_faza, now_ampl, now_faza;
unsigned int period;
unsigned char vol, bar, menu, rezhym, gnd_rage;
unsigned char viz_ampl, viz_faza;
unsigned int batt_celoe, batt_drob;
bit kn1, kn2, kn3, kn4, kn5, kn6, all_met;

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
sprintf (string_LCD_2, "Volume %d       ", vol);
lcd_puts (string_LCD_2);
return;
};

if (kn3==1)
{
PORTD.6=1;
lcd_gotoxy (0,1);
sprintf (string_LCD_2, "Barrier %d      ", bar);
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
sprintf (string_LCD_2, "%x %x %x %x ", zero_ampl, zero_faza, ampl, faza);
lcd_puts (string_LCD_2);
return;
};   
lcd_gotoxy (0,0);
if (viz_ampl==0)    sprintf (string_LCD_1, "                ");
if (viz_ampl==1)    sprintf (string_LCD_1, "_               ");    
if (viz_ampl==2)    sprintf (string_LCD_1, "�               ");
if (viz_ampl==3)    sprintf (string_LCD_1, "�_              ");    
if (viz_ampl==4)    sprintf (string_LCD_1, "��              ");
if (viz_ampl==5)    sprintf (string_LCD_1, "��_             ");    
if (viz_ampl==6)    sprintf (string_LCD_1, "���             ");
if (viz_ampl==7)    sprintf (string_LCD_1, "���_            ");    
if (viz_ampl==8)    sprintf (string_LCD_1, "����            ");
if (viz_ampl==9)    sprintf (string_LCD_1, "����_           ");    
if (viz_ampl==10)   sprintf (string_LCD_1, "�����           ");
if (viz_ampl==11)   sprintf (string_LCD_1, "�����_          ");    
if (viz_ampl==12)   sprintf (string_LCD_1, "������          ");
if (viz_ampl==13)   sprintf (string_LCD_1, "������_         ");    
if (viz_ampl==14)   sprintf (string_LCD_1, "�������         ");
if (viz_ampl==15)   sprintf (string_LCD_1, "�������_        ");    
if (viz_ampl==16)   sprintf (string_LCD_1, "��������        ");
if (viz_ampl==17)   sprintf (string_LCD_1, "��������_       ");    
if (viz_ampl==18)   sprintf (string_LCD_1, "���������       ");
if (viz_ampl==19)   sprintf (string_LCD_1, "���������_      ");    
if (viz_ampl==20)   sprintf (string_LCD_1, "����������      ");
if (viz_ampl==21)   sprintf (string_LCD_1, "����������_     ");    
if (viz_ampl==22)   sprintf (string_LCD_1, "�����������     ");
if (viz_ampl==23)   sprintf (string_LCD_1, "�����������_    ");    
if (viz_ampl==24)   sprintf (string_LCD_1, "������������    ");
if (viz_ampl==25)   sprintf (string_LCD_1, "������������_   ");    
if (viz_ampl==26)   sprintf (string_LCD_1, "�������������   ");
if (viz_ampl==27)   sprintf (string_LCD_1, "�������������_  ");    
if (viz_ampl==28)   sprintf (string_LCD_1, "��������������  ");
if (viz_ampl==29)   sprintf (string_LCD_1, "��������������_ ");   
if (viz_ampl==30)   sprintf (string_LCD_1, "��������������� ");
if (viz_ampl==31)   sprintf (string_LCD_1, "���������������_");    
if (viz_ampl==32)   sprintf (string_LCD_1, "����������������");    
lcd_puts (string_LCD_1);
lcd_gotoxy (0,1);
if (viz_faza==0)  sprintf (string_LCD_2, "�------II------�");    
if (viz_faza==1)  sprintf (string_LCD_2, "�------#I------�");
if (viz_faza==2)  sprintf (string_LCD_2, "�-----#II------�");
if (viz_faza==3)  sprintf (string_LCD_2, "�----#-II------�");
if (viz_faza==4)  sprintf (string_LCD_2, "�---#--II------�");
if (viz_faza==5)  sprintf (string_LCD_2, "�--#---II------�");
if (viz_faza==6)  sprintf (string_LCD_2, "�-#----II------�");
if (viz_faza==7)  sprintf (string_LCD_2, "�#-----II------�");
if (viz_faza==8)  sprintf (string_LCD_2, "�------I#------�");
if (viz_faza==9)  sprintf (string_LCD_2, "�------II#-----�");
if (viz_faza==10) sprintf (string_LCD_2, "�------II-#----�");
if (viz_faza==11) sprintf (string_LCD_2, "�------II--#---�");
if (viz_faza==12) sprintf (string_LCD_2, "�------II---#--�");
if (viz_faza==13) sprintf (string_LCD_2, "�------II----#-�");    
if (viz_faza==14) sprintf (string_LCD_2, "�------II-----#�");      

lcd_puts (string_LCD_2);    
PORTD.6=0;
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
if (faza > period) faza = faza - period;   
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
delay_ms (500);

period=0x063F;              
x_gnd=period/2;
zero_faza=period/2;

while (1)
{

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
