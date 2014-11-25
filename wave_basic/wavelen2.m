function L = wavelen2(d,T,nmax,difL,g)
%% Description 
% function wavelen2(d,T,nmax,difL,g);
%
% d     : depth (m), positive or negative (works with array too :o) )
% T     : period(s)  (works with an array of periods too)
% nmax  : maximum number of iterations
% difL  : Recquired difference in % for L between the steps of the iteration
% g     : gravitational accelaration; g = 32.2 or 9.81
%% Credits
% Author:   sflamp
% Inspired by C.M.Day's wavelength script
%% Check the inputs
error(nargchk(2, 5, nargin))        % if d and T not defined, script stops
if nargin < 5,  g = 9.81;       end % default g     (m/s^2)
if nargin < 4,  difL = 0.05;	end % default difL  (%)
if nargin < 3,  nmax = 15;      end % default nmax  (#)
%% Calculations
d = abs(d);
L = [];
for i_t = 1:length(T)
    Lm = (g*(T(i_t)^2)*0.5/pi)*sqrt(tanh(4*pi*pi*d/(T(i_t)*T(i_t)*g)));    % 1984 SPM, p.2-7
    L1 = Lm;
    L2 = 0;
    n = 1;
    while n<=nmax && abs(100*(L1-L2)/L1)>difL
        if n==1
            L2 = (g*(T(i_t)^2)*0.5/pi)*tanh(2*pi*d./L1);
        else
            L1=L2;
            L2 = (g*(T(i_t)^2)*0.5/pi)*tanh(2*pi*d./L1);
        end
        n = n + 1;
    end
    disp(L2)
    L = [L;L2];
end
