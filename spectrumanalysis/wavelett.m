function [Wt,Ws,f]=wavelett(x,fs)
%
%WAVELETT: Continuous Wavelet Transform and Spectrum estimate.
%
%   From input
%				x = signal vector
%				fs = sampling frequency 
%   WAVELETT using Morlet wavelet (call function morl)
%        to estimate as output
%				Wt = Complex Wavelet Transform 
%				Ws = Wavelet Spectrum
%				f = corresponding frequency scale
%   
%   Author  : B. Chapron
%   Revised : P. Liu
%
n = size(x,1);
if n == 1
   n = size(x,2);
   x=x';
end
%
g=fft(x(1:n));
h=g(1:1+n/2);
h(1)=g(1)/2;
%
qmin=input('Octave min :');
qmax=input('Octave max :');
nv=12;
ntot=(abs(qmax-qmin)+1)*nv;
for i=1:ntot
    G(:,i)=h;
end
%
k=1;
for q=qmax:-1:qmin
   for j=nv-1:-1:0
          a(k)=2^(q+j/nv);
          w(:,k)=morl(a(k),n,2*pi*fs);
          f(k)=1/(2*pi*a(k));
          k=k+1;
      end
end
%
Y=2*G.*w;
Wt=ifft(Y,n);
Ws=abs(Wt).^2;
