
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
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
sfrb OCDR=0x31;
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
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#asm
   .equ __lcd_port=0x1B ;PORTA
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

unsigned int code_symbol;
unsigned int amplituda_1, faza_1, amplituda_2, faza_2; 
bit cycle;

interrupt [17] void ana_comp_isr(void)
{

amplituda_1=TCNT1;
}

interrupt [10] void timer0_ovf_isr(void)
{

TCNT0=0xF9;         

faza_1=TCNT1;
cycle=1;
}

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x60 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

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

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x80;

TCCR0=0x06;
TCNT0=0xF9;         
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x6D;
TCNT2=0x00;
OCR2=0x0A;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x01;

ACSR=0x0A;
SFIOR=0x00;

ADMUX=0x60 & 0xff;
ADCSRA=0x83;
SFIOR&=0xEF;

lcd_init(16);

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

