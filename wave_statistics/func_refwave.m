function [KR, A_in,A_ref, SP1,SP2, n_min,n_max] = func_estimation_irwave(eta1,eta2,dL,h,dt,g_min,g_max,p_flag)
% ======================================================================
% version 1.21
% 
% Update
% 2008/11/25 NM Update help
% 2006/01/25 NM Additional input parameters g_min and g_max are added
% 2006/03/02 Nakajo
% ======================================================================
%
% Unit: All units - SI, meter, second, kg
% subscripts: 1...offshore wave gauge , 2...shore wave gauge
%
% Input
% 	eta1.....wave hight of probe No.1 (offshore gauge) [m]
% 	eta2.....wave hight of probe No.2 (onshore gauge) [m]
% 	dL.......distance between two probes [m]
% 	h........water depth [m]
% 	dt.......interval of measurement [sec]
% 	g_min ...minimum frequency ratio / suggest 0.05 L_min = dL/g_min -> f_min
% 	g_max ...maximum frequency ratio / suggest 0.45 L_max = dL/g_max -> f_max
%		g_min and g_max indicate range of significant components of
%		spectra. Please check the output data with p_flag=1. See detail in Goda's book
%	p_frag...plot frag 
%		1. plot figure: eta1 & eta2 ,A_in & A_ref,KR,H_in & H_ref
%		Other. no plot
%
% Output
% 	KR.......rate of refrection
% 	A_in.....amplitude of incident wave [m]
% 	A_ref....amplitude of refrection wave [m]
% 	n_min....minimum number of array, A_in and A_ref
% 	n_max....maximum number of array, A_in and A_ref
%
% ======================================================================
% Sample
% [KR,A_in,A_ref,S1,S1,n1,n2] = func_estimation_irwave(eta1,eta2,dL,h,dt,0.05,0.45,p_frag)
% ======================================================================
nfft  = length(eta1);
T0     = nfft*dt;
df     = 1/T0;
kn_max = nfft/2;
n      = 1:nfft;		% number of data
t      = dt*(n-1); 	% time

%------------ï™ó£êÑíË
C1 = fft(eta1,nfft)/kn_max;
C2 = fft(eta2,nfft)/kn_max;

SP1 = C1.*conj(C1);
SP2 = C2.*conj(C2);

A1 = real(C1(1:kn_max));
B1 = imag(C1(1:kn_max));
A2 = real(C2(1:kn_max));
B2 = imag(C2(1:kn_max));

k(1) = 0;
for ik=1:kn_max-1
  w(ik) = 2*pi*ik/T0;
  [ k(ik+1), L ]=wavenumber( T0/ik, h );
end

lcd = 2*abs(sin(k.*dL));
nume1 = (A2-A1.*cos(k.*dL)-B1.*sin(k.*dL)).^2;
nume2 = (B2+A1.*sin(k.*dL)-B1.*cos(k.*dL)).^2;
nume3 = (A2-A1.*cos(k.*dL)+B1.*sin(k.*dL)).^2;
nume4 = (B2-A1.*sin(k.*dL)-B1.*cos(k.*dL)).^2;

for a = 1:kn_max;
    if lcd(a) ~= 0;
    A_in(a)  = sqrt(nume3(a) + nume4(a)) ./ lcd(a);
    A_ref(a) = sqrt(nume1(a) + nume2(a)) ./ lcd(a);
    else
    A_in(a)  = NaN;
    A_ref(a)  = NaN;
    end
end

% eliminate outbound frequency components
L_min = dL/g_max;
L_max = dL/g_min;
k_min = 2*pi/L_min;
k_max = 2*pi/L_max;
w_min = sqrt(9.8*k_min*tanh(k_min*h));
w_max = sqrt(9.8*k_max*tanh(k_max*h));
f_min = k_min/(2*pi);
f_max = k_max/(2*pi);
n_min = round(f_max/df);
n_max = round(f_min/df);
clear B_in B_ref
 B_in =  A_in(n_min:n_max);
B_ref = A_ref(n_min:n_max);

%
 E_in = nansum( (B_in.^2) / 2);
E_ref = nansum( (B_ref.^2)/ 2);

KR = sqrt(E_ref ./ E_in);

% --- plot test
if p_flag == 1
    K = 1:kn_max;
    clf;
    subplot(211)
%    plot(t,eta1,t,eta2);
    semilogx(K,SP1(1:15000),'b-');
    semilogx(K,SP1(1:15000),'g-');
    subplot(212)
    semilogx(K,A_in,K,A_ref);
    hold on
    semilogx([K(n_min) K(n_min)],[0 max(A_in)],'k--');
    semilogx([K(n_max) K(n_max)],[0 max(A_in)],'k--');
    hold off
end