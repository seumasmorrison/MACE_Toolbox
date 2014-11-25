%
% example using func_transcameraview.m
%

file_read   = 'testimage.jpg'

% read jpeg RGB image (uinit8)
[ I ] = imread( file_read, 'jpeg' );

alpha =  20;
theta =  20;
phi   =  45;

depth = -10;

i_fill = 0

[ J ] = func_transcameraview( I, alpha, theta, phi, depth, i_fill );

imagesc(J)
colormap(jet);
axis equal
