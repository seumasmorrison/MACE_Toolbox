function[ h13, h10, hmax, t13, t10, tmax ] = signif( wh, wp, iprint );
%
%  signif.m: calculate significant wave height, 1/10 and max 
%
%  Input - wh: wave height
%          wp: wave period
%          iprint: =1 print data, !=1 no output to display
%
%  Output - h13 : significant wave height
%           h10 : 1/10 wave height
%           hmax: maxinum wave height
%           t13 : significant wave period
%           t10 : 1/10 wave period
%           tmax: maxinum wave period
%
%  By Nobuhito Mori
%  Update 2001/04/10
%

%
% --- test
%

itest = 0;
if itest == 9
nw  = 10
wh = rand(1,nw);
wp = rand(1,nw);
end

%
% --- main computation
%

nw = length( wh );

h13 =0.0;
h10 =0.0;
hmax=0.0;
t13 =0.0;
t10 =0.0;
tmax=0.0;

for i=1:nw
   vw1(i)=wh(i);
   vw3(i)=wp(i);
   vw2(i)=0;
   vw4(i)=0;
end


for i=1:nw
  for j=1:nw-i+1
     if vw1(j) > vw2(i)
        vw2(i)=vw1(j);
        vw4(i)=vw3(j);
        imax=j;
     end
  end
  k=1;
  for j=1:nw-i+1
     if j~=imax
        vw1(k)=vw1(j);
        vw3(k)=vw3(j);
        k=k+1;
     end
  end
end

n13 = round(nw/3);
n10 = round(nw/10);

h13 = sum(vw2(1:n13))/n13;
t13 = sum(vw4(1:n13))/n13;
h10 = sum(vw2(1:n10))/n10;
t10 = sum(vw4(1:n10))/n10;
hmax= vw2(1);
tmax= vw4(1);

%
% --- print to display
%

if iprint == 1
fprintf(1,'> Number of data: nw=%d, n13=%d, n10=%d\n', nw, n13, n10 );
fprintf(1,'> Wave height   : Hmax=%8.3f, H13=%8.3f, T10=%8.3f\n', ...
          hmax, h13, h10 );
fprintf(1,'> Wave period   : Tmax=%8.3f, T13=%8.3f, T10=%8.3f\n', ...
          tmax, t13, t10 );
end
