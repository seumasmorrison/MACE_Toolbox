function[ x_er_h, x_er_a, y_er_height, y_er_amp ] = ers2( n, m4 );
%
%  calculate exceedance Simplified ER distribution normalized by Erms
%    modified by Peter Janssen
%
%  Input - n  : number of point to calcualte  
%          m4 : kurtosis
%
%  Output - x_er   : x-axis
%           y_er   : pdf of ER distribution
%           y_er_e : exceedance probability of  distribution
%

%
% --- init value 1
%

x_max_h13  = 3.0;

%
% --- init value 2
%

i_type = 4;
if i_type == 1
  a = 0.5*sqrt(pi);
  x_max = 1.597*x_max_h13;
elseif i_type ==2
  a = 1;
  x_max = 1.416*x_max_h13;
elseif i_type == 3
  a = 4.004/sqrt(8.0);
  x_max = x_max_h13;
elseif i_type == 4
  a = 1/sqrt(8.0);
  x_max = 4.004*x_max_h13;
else
  error('i_type in ER.m is wrong!!!');
end

dx = x_max/n;

x_er_h = 0:dx:x_max;
x_er_a = 0:dx/2:x_max/2;
H = x_er_h;
A = x_er_a;

gauss_height = exp( -H.^2/8 );
gauss_amp    = exp( -A.^2/2 );

%
% --- height
%

b41 = (m4 - 3)/384;

y_er_height = gauss_height.*( 1 ...
+ b41*H.^2.*( H.^2 -  16 ) ...
);


%
% --- crest amplitude
%
a41 = (m4 - 3)/24;

y_er_amp = gauss_amp.*( 1 ...
+ a41*A.^2.*( A.^2 - 4 ) ...
);

