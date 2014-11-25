function amp=readamp(advfname,first,last,skip)
%READAMP Read amplitude backscatter from binary .ADV file
% 
% READVEL reads the amplitude backscatter of 3 recievers from a single
% probe, binary Sontek ver. 5.3 .ADV file and returns a matrix of
% results.  The first row of the returned matrix contains
% (amp1,amp2,amp3) for the record number given by FIRST.  SKIP records
% of the .ADV file are ignored so that the next row of the returned
% matrix contians (amp1,amp2,amp3) for record number FIRST+SKIP+1.
% SKIP is optional and its default value is zero.  The last returned
% backscatter triple will be <= to LAST, depending on whether or not
% LAST is skipped.  If LAST=Inf or LAST is not an input argument, data
% is read until the end of file.  If the only input argument is
% ADVFNAME, all velocity records are returned.  Returned units are ADV
% counts
%
% READCTL.M is called by this function.
% 
% See also READCTL, READVEL, READCOR, READTIME

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
header=578;           % number of bytes in .ADV file header
offset=header+14;     % offset to first velocity byte
recordsize=22;        % number of bytes per record

% Find last record if not specified
if isinf(last)
  fseek(advfid,0,'eof');
  lastbyte=ftell(advfid);
  last=(lastbyte-offset)/recordsize;
end

% Determine number of records & initialize data array
numrecs=ceil((last-first+1)/(skip+1));
amp=zeros(numrecs,3);

% Determine number of bites to skip between reads
byteskip=21+skip*recordsize;

% Read data by reciever to vectorize
fseek(advfid,offset+(first-1)*recordsize,'bof');
amp(:,1)=fread(advfid,numrecs,'uchar',byteskip);
fseek(advfid,offset+(first-1)*recordsize+1,'bof');
amp(:,2)=fread(advfid,numrecs,'uchar',byteskip);
fseek(advfid,offset+(first-1)*recordsize+2,'bof');
amp(:,3)=fread(advfid,numrecs,'uchar',byteskip);

fclose(advfid);

return

