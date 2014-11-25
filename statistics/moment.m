function [ mt ] = moment( x )
%
% ==========================================================
% High order moment of x
%
% Output:
% mt(1) = mean
% mt(2) = std
% mt(3) = skewness
% mt(4) = kurotsis
% mt(5) = 5th order moment
% mt(6) = 6th order moment
% mt(7) = 3rd order absolute moment
% mt(8) = 4th order signed moment
% mt(9) = 5th order absolute moment
%
% Nobuhito Mori
% Update June 3, 1998
% ==========================================================
%
m=length(x);
%
mean  = sum(x)/m;
stdev = sqrt(sum((x-mean(1)).^2)/m);
%stdev = std(f,1);
mt(1) = mean;
mt(2) = stdev;
if stdev ~= 0
  mt(3) = sum( (x-mean(1)).^3 )/m/stdev.^3;
  mt(4) = sum( (x-mean(1)).^4 )/m/stdev.^4;
  mt(5) = sum( (x-mean(1)).^5 )/m/stdev.^5;
  mt(6) = sum( (x-mean(1)).^6 )/m/stdev.^6;
  mt(7) = sum( abs((x-mean(1)).^3) )/m/stdev.^3;
  mt(8) = sum( sign(x).*abs((x-mean(1)).^4) )/m/stdev.^4;
  mt(9) = sum( abs((x-mean(1)).^5) )/m/stdev.^5;
else
  mt(3:9)=0;
end
