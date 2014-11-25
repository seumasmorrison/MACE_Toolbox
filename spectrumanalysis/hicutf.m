function [P]=hicutf(x,nc,n)
%
% cut more than nc-th mode of x vector of n column
%

c1=fft(x,n);
nc=nc+1;
nc1=nc;
nc2=n-nc+2;

c2=c1;
%c2(nc1:nc2)=[zeros]
for i=nc1:nc2
  c2(i)=0.0;
end

P=real(ifft(c2,n));
