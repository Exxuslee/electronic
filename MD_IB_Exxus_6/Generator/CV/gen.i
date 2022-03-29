
#pragma used+
sfrb DIDR=1;
sfrb UBRRH=2;
sfrb UCSRC=3;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb GPIOR0=0x13;
sfrb GPIOR1=0x14;
sfrb GPIOR2=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb PCMSK=0x20;
sfrb WDTCR=0x21;
sfrb TCCR1C=0x22;
sfrb GTCCR=0x23;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb CLKPR=0x26;
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
sfrb TCCR0A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb OCR0A=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb EIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb OCR0B=0x3c;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned char len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned char size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned char size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

bit kn1, kn2, kn3, kn4, kn5, kn6;
char on1, ona, onb;
char data;
unsigned char amp, faza;
unsigned char a;

interrupt [8] void usart_rx_isr(void)
{
data=UDR;
}

interrupt [6] void timer1_ovf_isr(void)
{

PORTB.7 = on1;
if (on1 == 0) on1=1;
else on1=0;
}

interrupt [5] void timer1_compa_isr(void)
{

PORTB.3 = ona;
if (ona == 0) ona=1;
else ona=0;
}

interrupt [13] void timer1_compb_isr(void)
{

PORTB.4 = onb;
if (onb == 0) onb=1;
else onb=0;
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
delay_ms (5);    
if (PIND.3==0 && PIND.4==0) kn1=1;
if (PIND.3==1 && PIND.4==0) kn2=1;
DDRD.2=0;
DDRD.3=1;
PORTD.2=1;
PORTD.3=0;
delay_ms (5);
if (PIND.2==1 && PIND.4==0) kn3=1;
if (PIND.2==0 && PIND.4==0) kn4=1;
DDRD.3=0;
DDRD.4=1;
PORTD.3=1;
PORTD.4=0;
delay_ms (5);
if (PIND.2==1 && PIND.3==0) kn5=1;
if (PIND.2==0 && PIND.3==1) kn6=1;
DDRD.4=0;
PORTD.4=1;
}

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x9C;

PORTD=0x5E;
DDRD=0x60;

TCCR0A=0x83;
TCCR0B=0x01;
OCR0A=0xE0;
OCR0B=0x00;
TCNT0=0x00;

TCCR1A=0x02;
TCCR1B=0x19;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x03;
ICR1L=0xC0;
OCR1AH=0x00;
OCR1AL=0x10;
OCR1BH=0x01;
OCR1BL=0xF0;

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0xE0;

USICR=0x00;

UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x08;

DIDR=0x00;

ACSR=0x00;

#asm("sei")

ona=1;

while (1)
{

kn_klava();

if (kn1==1)       ICR1++;
if (kn2==1)       ICR1--;
if (kn3==1)
{
OCR1A++;
if (OCR1A > ICR1) OCR1A = 0;
};
if (kn4==1)
{
OCR1A--;
if (OCR1A > ICR1) OCR1A = ICR1;
};        
if (kn5==1)
{
OCR1B++;
if (OCR1B > ICR1) OCR1B = 0;
};        
if (kn6==1)
{
OCR1B--;
if (OCR1B > ICR1) OCR1B = ICR1;
};        

amp = data >> 4;
faza = data & 0x0F;

for (a=0; a<100; a++)
{
if (faza >= 0x07)
{
PORTD.5 = 1;
delay_us (100);
PORTD.5 = 0;
delay_us (100);
}
if (faza < 0x07)
{
PORTD.5 = 1;
delay_us (150);
PORTD.5 = 0;
delay_us (150);
};  
};            
if      (amp == 0x00)        delay_ms (999);      
else if (amp == 0x01)        delay_ms (800);
else if (amp == 0x02)        delay_ms (750);
else if (amp == 0x03)        delay_ms (700);
else if (amp == 0x04)        delay_ms (650);
else if (amp == 0x05)        delay_ms (600);
else if (amp == 0x06)        delay_ms (550);
else if (amp == 0x07)        delay_ms (500);
else if (amp == 0x08)        delay_ms (450);
else if (amp == 0x09)        delay_ms (400);
else if (amp == 0x0A)        delay_ms (350);
else if (amp == 0x0B)        delay_ms (300);
else if (amp == 0x0C)        delay_ms (250);
else if (amp == 0x0D)        delay_ms (200);
else if (amp == 0x0E)        delay_ms (150);
else                         delay_ms (100);      

if (ACSR & 0x20) OCR0A--; 
};
}
