
#pragma used+
sfrb ACSR=8;
sfrb UBRR=9;
sfrb UCR=0xa;
sfrb USR=0xb;
sfrb UDR=0xc;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb WDTCR=0x21;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb OCR1L=0x2a;
sfrb OCR1H=0x2b;
sfrw OCR1=0x2a;   
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

unsigned char skvazh;
bit period;

interrupt [7] void timer0_ovf_isr(void)
{

if (period ==0)
{
PORTB.2=0;
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTB.3=1;
}
else 
{
PORTB.2=0;
PORTB.3=0;
TCCR0=0x00;   
};

TCNT0=skvazh;
period++;
}

interrupt [5] void timer1_comp_isr(void)
{

PORTB.3=0;
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
#asm("nop")
PORTB.2=1;
TCCR0=0x02;
}

void main(void)
{

PORTB=0x00;
DDRB=0x0C;

PORTD=0x3C;
DDRD=0x00;

TCCR0=0x00;
TCNT0=0xA0;

TCCR1A=0x00;
TCCR1B=0x09;
TCNT1H=0x00;
TCNT1L=0x00;
OCR1H=0x60;
OCR1L=0x00;

GIMSK=0x00;
MCUCR=0x00;

TIMSK=0x42;

ACSR=0x80;

#asm("sei")

while (1)
{

if (PIND.2 == 0)
{
OCR1=OCR1+0x40;
while (PIND.2 ==0)
{
};
};
if (PIND.3 == 0)
{
OCR1=OCR1-0x40;
while (PIND.3 ==0)
{
};
};      
if (PIND.4 == 0)
{
skvazh++;
while (PIND.4 ==0)
{
};
};
if (PIND.5 == 0)
{
skvazh--;
while (PIND.5 ==0)
{
};
};      
};
}

