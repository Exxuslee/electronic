
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

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x0F;

PORTD=0x0F;
DDRD=0x20;

TCCR0A=0x23;
TCCR0B=0x09;
TCNT0=0x00;
OCR0A=0x01;
OCR0B=0x00;

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

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0x00;

USICR=0x00;

ACSR=0x80;

while (1)
{

if (PIND.0 == 0)
{
OCR0A++;
while (PIND.0 ==0)
{
if (OCR0A == 0 )      OCR0A=1;
if (OCR0A <= OCR0B)   OCR0B=0;
};
};
if (PIND.1 == 0)
{
OCR0A--;
while (PIND.1 ==0)
{
if (OCR0A == 0 )      OCR0A=1;
if (OCR0A <= OCR0B)   OCR0B=0;
};
};      
if (PIND.2 == 0)
{
OCR0B++;
while (PIND.2 ==0)
{
if (OCR0A == 0 )      OCR0A=1;
if (OCR0A <= OCR0B)   OCR0B=0;
};
};
if (PIND.3 == 0)
{
OCR0B--;
while (PIND.3 ==0)
{
if (OCR0A == 0 )      OCR0A=1;
if (OCR0A <= OCR0B)   OCR0B=0;
};
};      
};
}
