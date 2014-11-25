function [ fo, n2 ]= sub_resample( fi, n1, n_sample, icfg );
%
% Version 1.00
% resampling of data
%   - fft filter
%   - moving average
%
% Input - fi      : input function
%         n1      : number of data of fi
%         n_sampe : resampling frequency
%         icfg    :  = 1 moving average
%                   ~= 1 FFT filter
%
% Output- fo      : output data
%         n2      : number of resampled data
%
%  By Nobuhito Mori
%  Update 2001/04/10
%

%
% --- init setup
%

n2 = n1/n_sample;

%
% --- di-trend
%

if icfg == 1

% moving average

fo = zeros(n2,1);
for i=1:n2
   fo(i) = sum( fi( (i-1)*n_sample+1:i*n_sample ) )/n_sample;
end
fo = fo';%'

else

% fft filter

nc = n2/2;
c = fft( fi, n1 );
cn(1:nc+1)  = c(1:nc+1);
cn(nc+2:n2) = conj(c(nc:-1:2));
cn = cn/n1*n2;
fo = real(ifft(cn, n2));

end
