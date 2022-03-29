
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

unsigned char volume;
unsigned char amp, faza;
unsigned char a;

char data;

interrupt [8] void usart_rx_isr(void)
{
data=UDR;
}

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTD=0x00;
DDRD=0x20;

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0x00;

USICR=0x00;

UCSRA=0x00;
UCSRB=0x90;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x08;

ACSR=0x80;

volume = 0x7f;
amp = 0xf;
faza = 0xf;

#asm("sei")

while (1)
{

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

if      (amp == 0x00)        delay_ms (1600);      
else if (amp == 0x01)        delay_ms (1500);
else if (amp == 0x02)        delay_ms (1400);
else if (amp == 0x03)        delay_ms (1300);
else if (amp == 0x04)        delay_ms (1200);
else if (amp == 0x05)        delay_ms (1100);
else if (amp == 0x06)        delay_ms (1000);
else if (amp == 0x07)        delay_ms (900);
else if (amp == 0x08)        delay_ms (800);
else if (amp == 0x09)        delay_ms (700);
else if (amp == 0x0A)        delay_ms (600);
else if (amp == 0x0B)        delay_ms (500);
else if (amp == 0x0C)        delay_ms (400);
else if (amp == 0x0D)        delay_ms (300);
else if (amp == 0x0E)        delay_ms (200);
else                         delay_ms (100);

};
}

