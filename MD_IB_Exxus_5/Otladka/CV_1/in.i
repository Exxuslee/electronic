
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

#pragma used+
unsigned char spi(unsigned char data);
#pragma used-

#pragma library spi.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

unsigned int array1 [0x110], array2 [0x110];      
unsigned long int zero_amp;
unsigned int faza_zero, amp_max, amp_min;
unsigned int a;
unsigned char faza_max, faza_min;
unsigned char faza = 0xab;
unsigned char amplituda = 0xcd;

interrupt [20] void twi_isr(void)
{

TWDR = faza;
TWCR |= 0x84;
while (!(TWCR & 0x80));
TWDR = amplituda;
TWCR |= 0x84;
while (!(TWCR & 0x80));
TWCR |= 0x80;

for (a=0; a<=0xF9; a++)
{
array2[a] = array1[a]>>3;
array2[a] = array2[a] & 0x03FF;
array2[a] =(unsigned) (((unsigned long) array2[a] * 4600) / 1024L);
};

amp_max = 2300;
amp_min = 2300;

for (a=0; a<=0xF9; a++)
{
if (array2[a] >= amp_max)
{
faza_max = a;
amp_max = array2[a];
};
if (array2[a] <= amp_min)
{
faza_min = a;
amp_min = array2[a];
};

};

if (faza_max > faza_min)    faza_zero = (faza_max - faza_min) ;
if (faza_max < faza_min)    faza_zero = (faza_min - faza_max) ;
faza = faza_max;
amplituda = faza_min;

return;
}

unsigned  read_adc(void)
{
unsigned result;
PORTB.4=0;
delay_us (1);
result=(unsigned) spi(0)<<8; 
result|=spi(0);
PORTB.4=1;
return result;
}

void main(void)
{

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0xB0;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

TCCR1A=0x00;
TCCR1B=0x1A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0xF9;
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

SPCR=0x51;
SPSR=0x00;

TWSR=0x00;
TWBR=0x0D;
TWAR=0x88;
TWCR=0x45;

zero_amp = 2300;

#asm ("sei")

while (1)
{

array1[TCNT1] = read_adc(); 
delay_us (1);

};
}
