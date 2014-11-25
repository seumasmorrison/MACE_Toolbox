function cor=readcor(advfname,first,last,skip)
%READAMP Read correlation from binary .ADV file
% 
% READVEL reads the correlation of 3 recievers from a binary Sontek
% ver. 5.3 .ADV file and returns a matrix of results.  The first row
% of the returned matrix contains (cor1,cor2,cor3) for the record
% number given by FIRST.  SKIP records of the .ADV file are ignored so
% that the next row of the returned matrix contians (cor1,cor2,cor3)
% for record number FIRST+SKIP+1.  SKIP is optional and its default
% value is zero.  The last returned correlation triple will be <= to
% LAST, depending on whether or not LAST is skipped.  If LAST=Inf or
% LAST is not an input argument, data is read until the end of file.
% If the only input argument is ADVFNAME, all velocity records are
% returned.  Returned units are correlation percentage.
%
% READCTL.M is called by this function.
% 
% See also READCTL, READAMP, READVEL, READTIME

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
header=578;          % number of bytes in .ADV file header 
offset=header+17;    % offset to first correlation byte
recordsize=22;       % number of bytes per record

% Find last record if not specified
if isinf(last)
  fseek(advfid,0,'eof');
  lastbyte=ftell(advfid);
  last=(lastbyte-header)/recordsize;
end

% Determine number of records & initialize data array
numrecs=ceil((last-first+1)/(skip+1));
cor=zeros(numrecs,3);

% Determine number of bites to skip between reads
byteskip=21+skip*recordsize;

% Read data by reciever to vectorize
fseek(advfid,offset+(first-1)*recordsize,'bof');
cor(:,1)=fread(advfid,numrecs,'uchar',byteskip);
fseek(advfid,offset+(first-1)*recordsize+1,'bof');
cor(:,2)=fread(advfid,numrecs,'uchar',byteskip);
fseek(advfid,offset+(first-1)*recordsize+2,'bof');
cor(:,3)=fread(advfid,numrecs,'uchar',byteskip);

fclose(advfid);

return



