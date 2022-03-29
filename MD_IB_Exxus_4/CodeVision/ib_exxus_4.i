
#pragma used+
sfrb PINF=0;
sfrb PINE=1;
sfrb DDRE=2;
sfrb PORTE=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRR0L=9;
sfrb UCSR0B=0xa;
sfrb UCSR0A=0xb;
sfrb UDR0=0xc;
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
sfrb SFIOR=0x20;
sfrb WDTCR=0x21;
sfrb OCDR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
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
sfrb ASSR=0x30;
sfrb OCR0=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x36;
sfrb TIMSK=0x37;
sfrb EIFR=0x38;
sfrb EIMSK=0x39;
sfrb EICRB=0x3a;
sfrb XDIV=0x3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#asm
   .equ __lcd_port=0x03 ;PORTE
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
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

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

unsigned int array1 [0x100];      
unsigned int array_t [0x100];     
unsigned int array2 [0x100];
unsigned int a;

unsigned int T = 8;

struct Complex
{
int re;
int im;
unsigned int amp;
int faza;
} array3[0x100];

unsigned  read_adc(void)
{
unsigned result;

PORTB.0=0;
result=(unsigned) spi(0)<<8; 
result|=spi(0);
PORTB.0=1;
result=result>>3;
result=result&0x03FF;
result=(unsigned) (((unsigned long) result*4600)/1024L);

return result;
}

unsigned int reverse(unsigned int I, int T)
{
int Shift = T - 1;
unsigned int LowMask = 1;
unsigned int HighMask = 1 << Shift;
unsigned int R;
for(R = 0; Shift >= 0; LowMask <<= 1, HighMask >>= 1, Shift -= 2)
R |= ((I & LowMask) << Shift) | ((I & HighMask) >> Shift);
return R;
}

unsigned int vektor_amplituda ( float X, float Y)
{
float temp;
X = (X * X);
Y = (Y * Y);
temp = sqrt (X + Y);
return (unsigned int)temp;
}

int vektor_faza (int Y,  int X)
{
float temp;
temp = atan2 (Y,X);    
temp = temp * 180 / 3.141592653589793;
return (int)temp;
} 

void main(void)
{

#asm("wdr");

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x27;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;

PORTE=0x00;
DDRE=0x00;

(*(unsigned char *) 0x62)=0x00;
(*(unsigned char *) 0x61)=0x00;

(*(unsigned char *) 0x65)=0x00;
(*(unsigned char *) 0x64)=0x00;

ASSR=0x00;
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

TCCR1A=0x40;
TCCR1B=0x0A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x01;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
(*(unsigned char *) 0x79)=0x00;
(*(unsigned char *) 0x78)=0x00;

TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

(*(unsigned char *) 0x8b)=0x00;
(*(unsigned char *) 0x8a)=0x00;
(*(unsigned char *) 0x89)=0x00;
(*(unsigned char *) 0x88)=0x00;
(*(unsigned char *) 0x81)=0x00;
(*(unsigned char *) 0x80)=0x00;
(*(unsigned char *) 0x87)=0x00;
(*(unsigned char *) 0x86)=0x00;
(*(unsigned char *) 0x85)=0x00;
(*(unsigned char *) 0x84)=0x00;
(*(unsigned char *) 0x83)=0x00;
(*(unsigned char *) 0x82)=0x00;

(*(unsigned char *) 0x6a)=0x00;
EICRB=0x00;
EIMSK=0x00;

MCUCR=0x80;
(*(unsigned char *) 0x6d)=0x00;

TIMSK=0x00;
(*(unsigned char *) 0x7d)=0x00;

ACSR=0x80;
SFIOR=0x00;

SPCR=0x54;
SPSR=0x01;

while (1)
{

unsigned int I;
unsigned int J;
unsigned int N;
unsigned int Nd2, k, m, mpNd2;
signed int TEMPre, TEMPim;
int TEMPfaza, W;

unsigned int Nmax = 0x100; 

for (a=0; a<=255; a++)   array1[TCNT1] = read_adc();

for (a=0; a<=255; a++)   array_t[a] = sin(3.141592653589793 * a / 128) * 1000;   

for(I = 0; I < Nmax; I++)
{
J = reverse(I,T);           
array2[I] = array_t[J];
array2[J] = array_t[I];
};

for (a=0; a<=255; a++)
{
array3[a].re = array2[a];
if (array3[a].re > 0) 
{
array3[a].amp = array2[a]+1;
array3[a].faza = 0;
}
else 
{
array3[a].amp = -array2[a]+1;
array3[a].faza = 180;
};
};

for(N = 2, Nd2 = 1; N <= Nmax-1; Nd2 = N, N+=N)
{
for(k = 0; k < Nd2; k++)
{
W = 360 * k / N;                                                    
for(m = k; m < Nmax; m += N)
{
mpNd2 = m + Nd2;

TEMPfaza = W + array3[mpNd2].faza;
TEMPfaza = TEMPfaza * 3.141592653589793 / 180;

TEMPre = (int) (array3[mpNd2].amp * cos(TEMPfaza));
TEMPim = (int) (array3[mpNd2].amp * sin(TEMPfaza));

array3[mpNd2].re = array3[m].re - TEMPre;
array3[mpNd2].im = array3[m].im - TEMPim;

array3[m].re = array3[m].re + TEMPre; 
array3[m].im = array3[m].im + TEMPim;

array3[mpNd2].amp = vektor_amplituda (array3[mpNd2].re, array3[mpNd2].im);
array3[mpNd2].faza = vektor_faza (array3[mpNd2].im, array3[mpNd2].re);
array3[m].amp = vektor_amplituda (array3[m].re, array3[m].im);
array3[m].faza = vektor_faza (array3[m].im, array3[m].re);                

};
};
};

for (a=0; a<=255; a++)
{
array3[a].re = array3[a].re / 0x100;
array3[a].im = array3[a].im / 0x100;
array3[a].amp = array3[a].amp / 0x100;
if (array3[a].amp == 0 ) array3[a].faza = 0;
};

#asm("wdr");  

};
}
