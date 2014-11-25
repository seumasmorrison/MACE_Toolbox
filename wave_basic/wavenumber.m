function [ k, L ]=wavenumber( T, h );
%
%  Computing wave length from wave period within 0.4% accuracy
%
%  Input
%		T : wave period
%		h : water depth ( -1 -> deep-water )
%
%  Output
%		k : wave number
%		L : wave length
%

%
% --- setup
%

pi  = acos(-1.0);
pi2 = acos(-1.0)*2.0;
ga  = 9.80;

%
% --- main
%

if h < 0
	k = (pi2/T)^2/ga;
	L = pi2/k;
else
      L0 = ga*T^2/pi2;
      D  = pi2*h/L0;

      x2 = D*( D + 1.0/(1.0 + D*( 0.65220 + D*(0.46220+D^2*(0.0864 + 0.0675*D)))));

      L = (pi2*h)/sqrt(x2);
      k = pi2/L;
end
