function w=morl(a,n,ns)
%
%  To generate Morlet Wavelet in Fourier Domain
%  ln(2)/pi=0.2206356
% 
%   Author  : B. Chapron
%   Revised : P. Liu
%
nu=a*ns*(0:n/2)'/n;
w=exp(-1/sqrt(2)*((nu-1)/.220636).^2);
