function [qp, P, f] = func_qp(eta,Fs)
%======================================================================
%
% This function calculate spectrum parameter Qp defined by Goda
%
% Goda, Y. (1983) Analysis of Wave Grouping and Spectra of 
% Long-travelled Swell, Report of the Port and Harbour Research 
% Institute, Vol. 22, No 1, pp.3-41.
%
% Input
%   eta    : surface elevation (mean should be zero)
%   Fs     : maximum sampling frequency (fmax);
%
% Output
%   qp     : Qp
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
%       1.01    2008/09/17 NM minor change
%       1.00    2007/08/17 NM first release
%
%========================================================================

nfft = length(eta);
[P, f] = cpsd(eta,eta,[],[],nfft,Fs);
disp('mean energy of eta is computed by cpsd');
%m0 = sum(P)/length(eta)*Fs
m0 = trapz(f,P);
qp = 2*trapz(f,f.*P.^2)/m0^2;

%loglog(f,P);
