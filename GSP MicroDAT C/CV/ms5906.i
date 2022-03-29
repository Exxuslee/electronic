
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

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma uchar+

char modul_00, modul_01, modul_10, modul_11, modul_20, modul_21, modul_30, modul_31;
char modul_40, modul_41, modul_50, modul_51, modul_60, modul_61, modul_70, modul_71;
unsigned int temp;

interrupt [10] void timer0_ovf_isr(void)      
{

temp=0x01;
for (PORTC=0; PORTC<=15; PORTC++)
{
if ((0b000000100001111&temp) >> PORTC == 1)               
{
DDRD=0x00;                          
PINB.4=1;
while (PINB.7==1)
{
switch (PORTC)
{
case 0 : modul_71=PIND;
case 1 : modul_70=PIND;
case 2 : modul_61=PIND;
case 3 : modul_60=PIND;
case 4 : modul_51=PIND;
case 5 : modul_50=PIND;
case 6 : modul_41=PIND;
case 7 : modul_40=PIND;
case 8 : modul_31=PIND;
case 9 : modul_30=PIND;
case 10 : modul_21=PIND;
case 11 : modul_20=PIND;
case 12 : modul_11=PIND;
case 13 : modul_10=PIND;
case 14 : modul_01=PIND;
case 15 : modul_00=PIND;
};
};
PINB.4=0;
};
if ((0b000000011110000&temp) >> PORTC ==1 )        
{
DDRD=0xff;                    
PORTB.5=1;
while (PINB.7==1)
{
switch (PORTC)
{
case 0 : PORTD                            =modul_00;
case 1 : PORTD                            =modul_01;
case 2 : PORTD                            =modul_10;
case 3 : PORTD                            =modul_11;
case 4 : PORTD                            =modul_20;
case 5 : PORTD                            =modul_21;
case 6 : PORTD                            =modul_30;
case 7 : PORTD                            =modul_31;
case 8 : PORTD                            =modul_40;
case 9 : PORTD                            =modul_41;
case 10 : PORTD                            =modul_50;
case 11 : PORTD                            =modul_51;
case 12 : PORTD                            =modul_60;
case 13 : PORTD                            =modul_61;
case 14 : PORTD                            =modul_70;
case 15 : PORTD                            =modul_71;
};
};        
PORTB.5=0;
};
temp<<=1;
};
};

void main(void)
{

PORTB=0xC0;
DDRB=0x3F;

PORTC=0x00;
DDRC=0x1F;

PORTD=0xFF;
DDRD=0x00;

TCCR0=0x05;     
TCNT0=0x00;

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
TCCR2=0x01;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

PORTB.2=1;
PORTB.0=0;
while (PINB.6!=1) PORTB.0=0;
PORTB.0=1;
temp=1;
for (PORTC=0; PORTC<=15; PORTC++)
{
if ( (0b000000100001111&temp) >> PORTC ==1)               
{
DDRD=0x00;                          
PINB.4=1;
while (PINB.7!=0);
PINB.4=0;
};
if ( (0b000000011110000&temp) >> PORTC ==1)        
{
DDRD=0xff;                    
PORTB.5=1;
while (PINB.7!=0);
PORTB.5=0;
};
temp<<1;
};
PORTB.2=0;

#asm("sei")

while (1)
{

temp=temp|modul_00;
temp=temp|modul_01;
temp=temp|modul_10;
temp=temp|modul_11;
temp=temp|modul_20;
modul_21=temp;
modul_30=temp;
modul_31=temp;
modul_40=temp;
};
}
