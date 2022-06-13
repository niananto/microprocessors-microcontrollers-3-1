/*
 * practice-01.c
 *
 * Created: 6/13/2022 11:33:12 AM
 * Author : Admin
 */ 

#include <avr/io.h>
#define F_CPU 1000000
#include <util/delay.h>

int main(void)
{
	unsigned char c = 1;
	DDRB= 0b00000001;

	while(1)
	{
		PORTB = c;
		if(c)c=0;
		else c=1;
		_delay_ms(1000);
	}
}


