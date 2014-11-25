function[ x, p, pe ] = func_weibull( n, a, i_type );
%
%  calculate one parameter weibull distribution
%
%  Input - n: number of point to calcualte  
%          i_type: 1 - H* = Hmean
%                  2 - H* = Hrms 
%                  3 - H* = H1/3
%                  4 - H* = Erms
%                 -1 - A* = Amean
%                 -2 - A* = Arms
%                 -3 - A* = A1/3
%                 -4 - A* = Erms
%
%  Output - x  : x-axis
%           p  : pdf of weibull distribution
%           pe : exceedance probability of weibull distribution
%

%
% --- init value 1
%

x_max_h13 = 3.0;

%
% --- init value 2
%

b = 0;
if i_type == 1
  b = pi/4;
  x_max = 1.597*x_max_h13;
elseif i_type == 2
  b = 1;
  x_max = 1.416*x_max_h13;
elseif i_type == 3
  b = 4.004^2/8
  x_max = x_max_h13;
elseif i_type == 4
  b = 1/8;
  x_max = 4.004*x_max_h13;
elseif i_type == -1
  b = pi;
  x_max = 1.597*x_max_h13;
elseif i_type == -2
  b = 1;
  x_max = 1.416*x_max_h13;
elseif i_type == -3
  x_max = x_max_h13;
elseif i_type == -4
  b = 1/2;
  x_max = 4.004*x_max_h13;
else
  error('i_type in rayleigh.m is wrong!!!');
end

dx = x_max/(n-1);

x = 0:dx:x_max;

p  = a*b*x.^(a-1).*exp( -b*x.^a );
pe =               exp( -b*x.^a );
