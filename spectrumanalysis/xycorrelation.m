function [ c, t, ccoef ] = xycorrelation( x, y )
% ==========================================================
% calculation of correlation function between x and y
%
% Input: 
%   x and y with n
%
% Output:
%   c - correlation function
%   ccoef - correlation coefficent
%
% Nobuhito Mori
% Update June 4, 2002
% ==========================================================
%
nx = length(x);
ny = length(y);
if nx ~= ny
  error('length of x is different from y!!!');
else
  n = nx;
end

%
% --- cal variance of x and y
%
m = n/2;
for i=1:m
  a = x(1:m);
  b = x(1+i-1:m+i-1);
  c = a.*b;
  r_x(i) = sum(c)/m;
end
for i=1:m
  a = y(1:m);
  b = y(1+i-1:m+i-1);
  c = a.*b;
  r_y(i) = sum(c)/m;
end

%x_std = std(x,1);
%y_std = std(y,1);
%x_var = x_std^2;
%y_var = y_std^2;
r_x(1);
r_y(1);

%
% --- calucation of correlation function
%
t    = zeros(1,2*m+1);
r_xy = zeros(1,2*m+1);

for i=1:m
  a = x(1:m);
  b = y(1+i:m+i);
  c = a.*b;
  t(m+1+i) = i;  
  r_xy(m+1+i) = sum(c)/m;
end
for i=1:m
  a = y(1:m);
  b = x(1+i:m+i);
  c = a.*b;
  t(m+1-i) = -i;  
  r_xy(m+1-i) = sum(c)/m;
end

a = x(1:m);
b = y(1:m);
c = a.*b;
t(m+1)    = 0;  
r_xy(m+1) = sum(c)/m;

c = r_xy/(sqrt(r_x(1)*r_y(1)));
ccoef = c(m+1);
