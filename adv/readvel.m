function vel=readvel(advfname,first,last,skip)
%READVEL Read velocities from binary .ADV file
% 
% READVEL(ADVFNAME,FIRST,LAST,SKIP) reads the three velocity
% components from a single probe, binary Sontek ver. 5.3 .ADV file
% (ADVFNAME) and returns a matrix of results.  The first row of the
% returned matrix contains (u,v,w) for the record number given by
% FIRST.  SKIP records of the .ADV file are ignored so that the next
% row of the returned matrix contains (u,v,w) for record number
% FIRST+SKIP+1.  SKIP is optional and its default value is zero.  The
% last returned velocity vector will be <= to LAST, depending on
% whether or not LAST is an integer number of SKIPS from FIRST.  If
% LAST=Inf or LAST is not an input argument, data is read until the
% end of file.  If the only input argument is ADVFNAME, all velocity
% records are returned.  Returned units are meters per second.
%
% READCTL.M is called by this function.
% 
% See also READCTL, READAMP, READCOR, READTIME

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

% call readctl.m to check software version number
readctl(advfname);

advfid=fopen(advfname,'r','l');

% .ADV file parameters
header=578;         % number of bytes in .ADV file header
offset=header+2;    % offset to first velocity byte
recordsize=22;      % number of bytes per record

% Find last record if not specified
if isinf(last)
  fseek(advfid,0,'eof');
  lastbyte=ftell(advfid);
  last=(lastbyte-header)/recordsize;
end

% Determine number of records & initialize data array
numrecs=ceil((last-first+1)/(skip+1));
vel=zeros(numrecs,3);

% Determine number of bites to skip between reads
byteskip=18+skip*recordsize;

% Read data by reciever to vectorize
fseek(advfid,offset+(first-1)*recordsize,'bof');
vel(:,1)=fread(advfid,numrecs,'float32',byteskip);
fseek(advfid,offset+(first-1)*recordsize+4,'bof');
vel(:,2)=fread(advfid,numrecs,'float32',byteskip);
fseek(advfid,offset+(first-1)*recordsize+8,'bof');
vel(:,3)=fread(advfid,numrecs,'float32',byteskip);

fclose(advfid);

return

