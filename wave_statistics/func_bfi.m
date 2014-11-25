function [bfi, qp, eps, P, f] = func_bfi(eta,depth,Fs,iopt)
%======================================================================
%
% This function calculate Benjamin-Feir index (Janssen, 2004),
%  and spectrum parameter Qp defined by Goda
%
% Janssen, P.A.E.M. (2003) Nonlinear four wave interactions
%  and freak waves, Technical Memorandum, ECMWF, No.366, 35p.
% Goda, Y. (1983) Analysis of Wave Grouping and Spectra of 
%  Long-travelled Swell, Report of the Port and Harbour Research 
%  Institute, Vol. 22, No 1, pp.3-41.
%
% Input
%   eta    : surface elevation (mean should be zero)
%   depth  : water depth [m]
%   Fs     : maximum sampling frequency (fmax);
%   iopt   : 1        - 0.5*f0 < f0 1.5*fp
%            other    -  no effect
%            negative - smoothing for spectrum estimation
%
% Output
%   bfi    : Benjamin-Feir Index
%   qp     : Qp, Goda's wave spectrum parameter
%   eps    : mean wave steepness defined by k0*\sqrt{m0}
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
%       Nobuhito Mori, Osaka City University
%
%========================================================================
%
% Update:
%       1.00    2007/08/17 Nobuhito Mori, Osaka City University
%
%========================================================================
i_test = 0;

nfft = length(eta);
if iopt >= 0
    % normal spectrum estimation
    [P, f] = cpsd(eta,eta,[],[],nfft,Fs);
else
    % overlapped spectrum estimation
    [P, f] = cpsd(eta,eta,nfft/32,[],nfft,Fs);
end
%disp('mean energy of x by cpsd');

%m0 = sum(P)/length(eta)*Fs
df = f(2);
m0 = trapz(f,P);

% Wave steepness
% peak frequency defined by spectrum moment
%f0   = trapz(f,f.*P)/m0;
[Pmax I] = max(P);
f0 = f(I);
np = round(f0/df);
if f0~=0
    t0 = 1/f0;
else
    t0 = NaN;
end
[ k0, L0 ]=wavenumber( t0, depth );
eps = k0*sqrt(m0);

% Qp
if abs(iopt) == 1
    if np~=0
      P2 = P;
      np_min = round(0.50*np);
      np_max = round(2.0*np);
      P2(1:np_min) = 0;
      P2(np_max:length(P2)) = 0;
    else
      P2 = NaN;
    end
else
  P2 = P;
end
if np~=0
    m02 = trapz(f,P2);
    qp = 2*trapz(f,f.*P2.^2)/m02^2;
else
    qp = NaN;
end

% BFI
bfi = eps*qp^2;

% test
if i_test == 1
    loglog(f,P,'g--');
    hold on
    loglog(f,P2,'b-');
    loglog(f(np),P2(np),'ro')
    loglog(f(np_min),P(np_min),'r*')
    loglog(f(np_max),P(np_max),'r*')
    hold off
    pause
end
