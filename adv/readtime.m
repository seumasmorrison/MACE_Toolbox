function time=readtime(advfname,first,last,skip)
% READTIME Determines sample times for .ADV file
%
% TIME=READTIME(ADVFNAME,FIRST,LAST,SKIP)
%
% For the ver. 5.3 .ADV file ADVFNAME, this function returns the time
% stamp, in serial date number format (see datenum.m).  The first time
% stamp returned corresponds to record number FIRST of the data file,
% the next time stamp to record FIRST+SKIP+1 etc., such that the last
% record number is less than or equal to LAST.  SKIP is optional and
% its default value is zero.  If LAST==Inf or if LAST is not an input
% argument, times are calculated until the end of file.
%
% READCTL.M is called by this function.

% written by Matt Brennan, Stanford University, 5/3/00

switch nargin
 case 3
  skip=0;
 case 2
  skip=0;
  last=inf;
 case 1
  skip=0;
  last=inf;
  first=1;
end
  
[starttime,numrecs,samprate]=readctl(advfname,0);

if isinf(last)
  last=numrecs;
end

index=first:(skip+1):last;

time=(starttime+(index-1)./samprate./86400)';

return