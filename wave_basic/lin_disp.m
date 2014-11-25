% lin_disp.m Linear wave theory dispersion relationship with current
% 
%   NOTE: there is no provision for a stopping current:
%         be carefull with large U 
%
%  There is also a Linux mex file with the same code, built from lin_disp.f
%  It will be called if it is found by Matlab 
%
% Call:  [k,error] = lin_disp(omega,g,h,U,tol)
%
%       k:     Wave number    (1/L)
%       omega: Wave frequency (1/T)
%       g:     Gravitational acceleration (defines units)
%       h:     Water depth
%       U:     Eulerian current (U>0: assisting, U<0: opposing)
%       error: error in disp relation (gk tanh(kh)-(omega-kU)^2) / k
%       tol:   max allowable error
%
%       if no U is given, it is taken as zero
%       if no tol is given, default is 10*eps (~2e-15 on a ieee machine)
%                                      1e-14 in mex file version
%       simplest example:  k = lin_disp(omega,h,g)
%
%
%       chb: Jan, 1997
%

function [k,err] = lin_disp(omega,g,h,U,tol)

maxiter = 20;
if nargin < 5;tol = 10*eps;end
if nargin < 4;U = 0; end
if (nargin < 3)
  disp('error in lin_disp: must have 3 or 4 or 5 arguments')
  error(' ')
end 

% non-dimensionalize h and U
h = omega^2*h/g;
U = U*omega/g;

% first estimate for k: Fenton & McKee
k = tanh(h^(3/4))^(-2/3);
kh = k*h;
f =  k*tanh(k*h) - (1-k*U)^2;
df = kh*(1-tanh(kh)^2)+ 2*U*(1-k*U) + tanh(kh);
err = f/k;
i = 1;
while (abs(err) > tol)&(i<maxiter)
  k = k - f/df;
  kh = k*h;
  f =  k*tanh(k*h) - (1-k*U)^2;
  df = kh*(1-tanh(kh)^2)+ 2*U*(1-k*U) + tanh(kh);
  err = f/k;
  i = i+1;
end
if i>=maxiter ;
  disp('lin_disp has not converged, check tol and stopping current')
  error(' ')
end
if k<0;
  disp('lin_disp has computed negative k, check for stopping current')
  error(' ')
end  
% re-dimensionalise k
k = omega^2 * k/g;











