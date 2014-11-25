function [J,X,Y,Z] = func_transcameraview( I, alpha, theta, phi, depth, i_fill );
%========================================================================
%
% Version 1.00
%
%
%       func_transcameraview.m
%
%
% Description:
%
% 	Transform camera captured image at peer to planer (x,y,depth) plain 
%	for Matlab.
%       This program require Matlab and Image Processing Toolbox.
%
% Specific:
%
%       - Input image must be RGB color image
%	- (x,y) axes are horizontal cooridates
%	  and z is vertical axis upward direction.
%
% Variables:
%
%       Input;
%	I		Image file (RGB)
%	alpha		A half angle of camere view (deg)
%	theta		An angle of elevation
%			camera angle from (x,y) to plain (deg)
%	phi		Horizontal angle
%			camera angle from x axis on (x,y) plain
%	depth		depth of projection plane.
%	i_fill		filled value of empty pixel
%			0   - black
%			255 - white
%
%       Output;
%       J		Transformed image on (x,y,depth)
%
% Example:
%	I = imread( 'testimage.jpg', 'jpeg' );
%	alpha =  20;
%	theta =  20;
%	phi   =  45;
%	depth = -10;
%	i_fill = 0
%	[J] = func_transcameraview( I, alpha, theta, phi, depth, i_fill );
%       f1 = imread('image1.bmp');
%       f2 = imread('image2.bmp');
%       [xi,yi,iu,iv]=mpiv(f1,f2, 20,20, 0.5,0.5, 500,500,0.033,'mqd',2,1);
% 
%======================================================================
%
% Terms:
%
%       Distributed under the terms of the terms of the BSD License
%
% Copyright:
%
%       Nobuhito Mori
%           Disaster Prevention Research Institue
%           Kyoto University, JAPAN
%           mori@oceanwave.jp
%
%======================================================================
%
% Update:
%       1.01    2009/07/01 BSD License is applied
%       1.00    2002/12/03 First version
%
%======================================================================

clear J

%
% --- set camera parameter
%

% camera view [rad]
alpha = alpha /180*pi;

% x-z angle of camera
a = theta /180*pi;

% x-y angle of camera
b = phi /180*pi;

%
% --- making camera parameter
%

l1 = abs(depth)*tan(a-alpha);
l2 = abs(depth)*tan(a+alpha);
m1 = abs(depth)*tan(alpha)*sec(a-alpha);
m2 = abs(depth)*tan(alpha)*sec(a+alpha);

X(4) = l1*cos(b) + m1*sin(b);
Y(4) =-l1*sin(b) + m1*cos(b);
Z(4) = depth;
X(1) = l2*cos(b) + m2*sin(b);
Y(1) =-l2*sin(b) + m2*cos(b);
Z(1) = depth;
X(2) = l2*cos(b) - m2*sin(b);
Y(2) =-l2*sin(b) - m2*cos(b);
Z(2) = depth;
X(3) = l1*cos(b) - m1*sin(b);
Y(3) =-l1*sin(b) - m1*cos(b);
Z(3) = depth;

%
% --- transform image
%

n  = size(I);
nx = n(2);
ny = n(1);

X_max = max(X);
X_min = min(X);
Y_max = max(Y);
Y_min = min(Y);
X_scale = (nx-1)/( X_max - X_min );
Y_scale = (ny-1)/( Y_max - Y_min );
XX = ( X_max - X ) * X_scale + 1;
YY = ( Y_max - Y ) * Y_scale + 1;

Vin  = [ 1 1; ny 1; ny nx; 1 nx];
Vout = [ YY(1) XX(1); YY(2) XX(2); YY(3) XX(3); YY(4) XX(4) ];

T = maketform( 'projective', Vin, Vout );
J = imtransform( I, T, 'cubic', 'size', size(I), 'fill', i_fill );
