
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

void main(void)
{

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xFF;

TCCR0=0x00;
TCNT0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;

TIMSK=0x20;

ACSR=0x80;
SFIOR=0x00;

#asm("sei")

#pragma warn-
#asm
ldi R01, 128
ldi R02, 128
ldi R03, 128
ldi R04, 128
ldi R05, 128
ldi R06, 128
ldi R07, 128
ldi R08, 128
ldi R09, 128
ldi R10, 128
ldi R11, 128
ldi R12, 128
ldi R13, 128
ldi R14, 128
ldi R15, 128
ldi R16, 128
ldi R17, 128
ldi R18, 128
ldi R19, 128
ldi R20, 128
ldi R21, 128
ldi R22, 128
ldi R23, 128
ldi R24, 128
ldi R25, 128
ldi R26, 128
ldi R27, 128
ldi R28, 128
ldi R29, 128
ldi R30, 128
ldi R31, 128
ldi R32, 128
#endasm
#pragma warn+

while (1)
{

#pragma warn-
#asm      
OUT PORTD,R0
OUT PORTD,R1
OUT PORTD,R2
OUT PORTD,R3
OUT PORTD,R4
OUT PORTD,R5
OUT PORTD,R6
OUT PORTD,R7
OUT PORTD,R8
OUT PORTD,R9
OUT PORTD,R10
OUT PORTD,R11
OUT PORTD,R12
OUT PORTD,R13
OUT PORTD,R14
OUT PORTD,R15
OUT PORTD,R16
OUT PORTD,R17
OUT PORTD,R18
OUT PORTD,R19
OUT PORTD,R20
OUT PORTD,R21
OUT PORTD,R22
OUT PORTD,R23
OUT PORTD,R24
OUT PORTD,R25
OUT PORTD,R26
OUT PORTD,R27
OUT PORTD,R28
OUT PORTD,R29
OUT PORTD,R30
OUT PORTD,R31      
#endasm
#pragma warn+      
};
}

