function [eps, nu, r, tm01, P, f] = func_spectbandwidth(eta, Fs)
%======================================================================
%
% This function calculate spectrum bandwidth parameters
%
% Input
%   eta    : surface elevation (mean should be zero)
%   Fs     : maximum sampling frequency (fmax);
%
% Output
%   eps    : spectrum bandwith by Cartwright and Longuet-Higgins (1956)
%   nu     : spectrum bandwith by Longuet-Higgins (1975)
%   r      : spectrum bandwith by Rice (1945)
%   tm01   : mean frequecy by m1/m0
%   P      : power spectra
%   f      : frequency 
%
% Unit [mks] 
%
% Example: 
%
%======================================================================
%
% Terms:
%       Distributed under the terms of the terms of the 
%       GNU General Public License
%
% Copyright: 
%       Nobuhito Mori
%       Disaster Prevention Research Institute
%       Kyoto University
%       Uji, Kyoto 611-0011, Japan
%       mori@oceanwave.jp
%
%========================================================================
%
% Update:
%       1.00    2008/09/17 Nobuhito Mori
%
%========================================================================

nfft = length(eta);
[P, f] = cpsd(eta,eta,[],[],nfft,Fs);
disp('mean energy of eta is computed by cpsd');

% setup
%m0 = sum(P)/length(eta)*Fs
m0 = trapz(f, P);
m1 = trapz(f, f.*P);
m2 = trapz(f, f.^2.*P);
m4 = trapz(f, f.^4.*P);
fm = m1/m0;

% spectrum bandwidth by Cartwright and Longuet-Higgins (1956) 
eps = sqrt( 1 - m2^2/(m0*m4) );
% spectrum bandwith by Longuet-Higgins (1975)
nu  = sqrt( (m0*m2)/m1^2 - 1 );
% spectrum bandwith by Rice (1945)
tm01 = 1/fm;
%r1 = trapz( f, P.*cos((2*pi)*(f-fm)*tm) );
%r2 = trapz( f, P.*sin((2*pi)*(f-fm)*tm) );
%r = sqrt(r1^2+r2^2)
r1 = trapz( f, P.*cos(2*pi*f*tm01) );
r2 = trapz( f, P.*sin(2*pi*f*tm01) );
r  = sqrt( (r1/m0)^2+ (r2/m0)^2 );

%loglog(f,P);
