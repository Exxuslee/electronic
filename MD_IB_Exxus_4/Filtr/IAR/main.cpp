
#include "D:\Lexx\Pro\Project\MD_IB_Exxus_4\IAR\Inc\cmath"
#include "D:\Lexx\Pro\Project\MD_IB_Exxus_4\IAR\Inc\vector"
#include "D:\Lexx\Pro\Project\MD_IB_Exxus_4\IAR\Inc\iostream"
#include "D:\Lexx\Pro\Project\MD_IB_Exxus_4\IAR\Inc\iom64.h"
 

#define VREF 4600
#define SS PORTB.0
#define SCK PORTB.1
#define MISO PINB.3
#define M_PI (3.1415926535897932384626433832795)


// Declare your global variables here


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


vector<double> FFT(const vector<int>& dIn, int nn, int beginData)
{
	int i, j, n, m, mmax, istep;
	double tempr, tempi, wtemp, theta, wpr, wpi, wr, wi;
 
	int isign = -1;
	vector<double> data(nn*2 + 1);
 
	j = 0;
	for (i = beginData; i < beginData + nn; i++)
	{
		if (i < dIn.size())
		{
			data[j*2]   = 0;
			data[j*2+1] = dIn[i];
		}
		else
		{
			data[j*2]   = 0;
			data[j*2+1] = 0;
		}
		j++;
	}
 
	n = nn << 1;
	j = 1;
	i = 1;
	while (i < n)
	{
		if (j > i)
		{
			tempr = data[i];   data[i]   = data[j];   data[j]   = tempr;
			tempr = data[i+1]; data[i+1] = data[j+1]; data[j+1] = tempr;
		}
		m = n >> 1;
		while ((m >= 2) && (j > m))
		{
			j = j - m;
			m = m >> 1;
		}
		j = j + m;
		i = i + 2;
	}
	mmax = 2;
	while (n > mmax)
	{
		istep = 2 * mmax;
		theta = 2.0*M_PI / (isign * mmax);
		wtemp = sin(0.5 * theta);
		wpr   = -2.0 * wtemp * wtemp;
		wpi   = sin(theta);
		wr    = 1.0;
		wi    = 0.0;
		m    = 1;
		while (m < mmax)
		{
			i = m;
			while (i < n)
			{
				j         = i + mmax;
				tempr     = wr * data[j] - wi * data[j+1];
				tempi     = wr * data[j+1] + wi * data[j];
				data[j]   = data[i] - tempr;
				data[j+1] = data[i+1] - tempi;
				data[i]   = data[i] + tempr;
				data[i+1] = data[i+1] + tempi;
				i         = i + istep;
			}
			wtemp = wr;
			wr    = wtemp * wpr - wi * wpi + wr;
			wi    = wi * wpr + wtemp * wpi + wi;
			m     = m + 2;
		}
		mmax = istep;
	}
	vector<double> dOut(nn / 2);
 
	for (i = 0; i < (nn / 2); i++)
	{
		dOut[i] = sqrt( data[i*2] * data[i*2] + data[i*2+1] * data[i*2+1] );
	}
 
	return dOut;
}
 
int main()
{
	vector<int> dsin;
 
	for (double x = 0; x <= 10*M_PI; x += M_PI/180.0)
	{
		dsin.push_back( sin(x)*1000 + cos(0.5*x)*1000 );
	}
 
	vector<double> dfourier = FFT(dsin, 1024, 1);
 
	for (int i = 0; i < dfourier.size(); i++)
	{
		cout << i << "\t" << dfourier[i] << endl;
	}
	return 0;
}

