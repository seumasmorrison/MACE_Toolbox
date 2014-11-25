function[ xh, ph_n, phe ] = waveheight_distribution( wh, h_normalize,...
				       n_hist, i_normalize, i_type, i_plot );
%
%  waveheight_distribution
%
%  Input - wh: wave height record
%          h_normalize: wave height parameter to normalize wh
%          i_normalize: 1     - yes (pdf)
%                       2     - percentage
%                       other - real number
%          n_hist : number of histgram between 0 to 3 H1/3
%          i_type : 1 - H13
%                   2 - Erms
%          i_plot : 1 - yes
%
%  Output - xh   : x-axis value
%           ph_n : normalized pdf
%           phe  : exceedance probability of ph_n
%
%  By Nobuhito Mori
%  Update 2001/07/14
%

%
% --- init
%

nw = length(wh);

hist_max_h13  = 3.0;
hist_max_hrms = hist_max_h13*4.004;

%n_hist = 31;

dh13  = hist_max_h13/(n_hist-1);
dhrms = hist_max_hrms/(n_hist-1);

if i_type == 1
  dh = dh13;
  hist_max = hist_max_h13;
else
  dh = dhrms;
  hist_max = hist_max_hrms;
end

xh  = 0:dh:hist_max;
whn = wh/h_normalize;

%
% --- cal pdf
%

n  = 0;
ph = zeros(1,n_hist);
for i=1:nw
  for j=1:n_hist-1
     if ( whn(i) >= xh(j) ) & ( whn(i) < xh(j+1) )
       n = n + 1;
       ph(j) = ph(j) + 1;
     end
  end
end

if n~=nw
     warning('There is mismach counting number of wave in hist')
  n
  nw
end

%
% --- normalize pdf
%

if i_normalize == 1
  ph_n = ph/(n*dh);
elseif i_normalize == 2
  ph_n = ph/n;
else
  ph_n = ph;
end

%
% --- exceedance pdf
%

%phe(1) = 1;
%for j=2:n_hist
%  phe(j) = phe(j-1) - ph(j)/n;
%end


phe(n_hist) = ph(n_hist);
for j=n_hist-1:-1:1
  phe(j) = phe(j+1) + ph(j);
end
phe = phe/phe(1);

%
% --- plot
%

if i_plot == 1
subplot(2,2,1)
     bar(xh,ph_n);
subplot(2,2,2)
  semilogy(xh,phe,'o')
end
