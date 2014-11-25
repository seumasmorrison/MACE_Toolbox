function [starttime,numrecs,samprate]=readctl(advfname,fileflag)
%READCTL Read configuration info from binary .ADV file
% 
% READCTL(ADVFNAME,FILEFLAG) reads the configuration information from
% a binary Sontek .ADV file, ver. 5.3.  If FILEFLAG==1, then the
% function summarizes the results into a file with the same name as
% ADVFNAME with '.ctl' extension. If FILEFLAG is ~=1 or not given, no
% information is written to file.  The format of the .ctl file is
% similar, but not identical to the .ctl file created by GETCTL.EXE.
% The function also returns the following:
%
%     STARTTIME = starting time of .ADV file in MatLab's
%                 date number format (see DATENUM.M)
%     NUMRECS   = number of measurement records in the file
%     SAMPRATE  = sampling rate of the data   
% 
% Restrictions: Max 1 probe per file; Recorded units assumed metric; 
%               Internal compass or other sensor data not recorded;
%               3 reciever ADV files
% 
% See also READVEL, READAMP, READCOR, READTIME

% written by Matt Brennan, Stanford University, 5/3/00

if nargin==1
  fileflag=0;
end

% .ADV file parameters
maxprobes=8;     % maximum number of probes per file
SampleLength=22; % number of bytes in each sample

% Open .ADV file
[advfid,message]=fopen(advfname,'r','l');
if advfid==-1
  error(message)
end

% Read binary data into variables
softver=char(fread(advfid,8,'char'))'; % software version
if ~strcmp(softver(1:7),'ADF 5.3')
  error(['Trying to read incompatible software version ' softver])
end

strtyear=fread(advfid,1,'int16');      % start time year
starttime=fread(advfid,6,'char');      % start time [day month min hr
                                       %             sec100 sec]
probestat=fread(advfid,maxprobes,'uchar');  % probe status for each probe 
unknown=fread(advfid,26,'char');       % unknown data block
temp=fread(advfid,1,'float32');        % temperature (deg C)
sal=fread(advfid,1,'float32');         % salinity (ppt)
spdsnd=fread(advfid,1,'float32');      % speed of sound (m/s)
samprate=fread(advfid,1,'float32');    % sampling rate (Hz)
velrange=fread(advfid,1,'int16');      % velocity range flag
extsynch=fread(advfid,1,'int16');      % external synch flag
adon=fread(advfid,1,'int16');          % A/D module flag
comp=fread(advfid,1,'int16');          % compass flag
spare1=fread(advfid,2,'char');         % spare 1
recfile=char(fread(advfid,40,'char'))';% recording file name
com1=char(fread(advfid,60,'char'))';   % comment 1
com2=char(fread(advfid,60,'char'))';   % comment 2
com3=char(fread(advfid,60,'char'))';   % comment 3
spare2=fread(advfid,28,'char');        % spare 2
spare3=fread(advfid,10,'uchar');       % spare 3
serialnum=char(fread(advfid,6,'char'))';% probe serial number
Bpar=fread(advfid,226,'uchar');        % sample volume info
Fpar=fread(advfid,3,'float32');        % sample volume info

% Calculate boundary distances (units: cm)
if Fpar(1)>0
  r=Bpar(179)./Bpar(177);
  r=Fpar(2)*r+Fpar(3)/r;
  ProbeBoundaryRange=Fpar(1)*100;
  VolumeBoundaryRange=(Fpar(1)-r)*100;
else
  ProbeBoundaryRange=-1.0;
  VolumeBoundaryRange=-1.0;
end

% Determine file size & number of samples
ConfLength=ftell(advfid);
fseek(advfid,0,'eof');
BytesInFile=ftell(advfid);
SampleInterval=1.0/samprate;
SamplesInFile=(BytesInFile-ConfLength)/SampleLength;
TotalTime=SamplesInFile*SampleInterval;

if fclose(advfid)==-1
  error('Error closing .ADV file')
end

if fileflag==1
  % Open output file
  [ctlfid,message]=fopen([advfname(1:end-4) '.ctl'],'w');
  if ctlfid==-1
    error(message)
  end

  % Output to file
  fprintf(ctlfid,'Data File ---------------  %s',recfile);
  fprintf(ctlfid,'\nSoftware version --------  %s',softver);
  fprintf(ctlfid,'\nFile Size ---------------  %ld bytes',BytesInFile);
  fprintf(ctlfid,'\nConfiguration Header Size  %ld bytes',ConfLength);
  fprintf(ctlfid,'\nStart Date/Time --------- %02d/%02d/%4d  %02d:%02d:%02d',...
	[starttime(2) starttime(1) strtyear starttime(4) starttime(3) ...
	 starttime(6)]);
  fprintf(ctlfid,'\n\nFile Comments: %s',com1);
  fprintf(ctlfid,'\n               %s',com2);
  fprintf(ctlfid,'\n               %s',com3);
  fprintf(ctlfid,'\n');

  fprintf(ctlfid,'\nProbes in File:');
  fprintf(ctlfid,'\n    Probe 1 - Serial Number: %6s',serialnum);
  fprintf(ctlfid,'\n');

  fprintf(ctlfid,'\nSampling Rate ----------- %10.3f Hz',samprate);
  fprintf(ctlfid,'\nSampling Interval ------- %10.3f s',SampleInterval);
  fprintf(ctlfid,'\n# of Samples in File ---- %10.1f',SamplesInFile);
  fprintf(ctlfid,'\nLength of Time Series --- %10.3f s',TotalTime);

  fprintf(ctlfid,'\nTemperature ------------- %10.2f deg C',temp);
  fprintf(ctlfid,'\nSalinity ---------------- %10.2f ppt',sal);
  fprintf(ctlfid,'\nSpeed of Sound ---------- %10.2f m/s',spdsnd);

  velrangelist=[3 10 30 100 250 NaN];
  fprintf(ctlfid,'\nVelocity Range ---------- %10s cm/s',...
	num2str(velrangelist(velrange+1)));

  fprintf(ctlfid,'\nA/D Data ---------------- ');
    if (adon==1) 
      fprintf(ctlfid,'PRESENT');
    else
      fprintf(ctlfid,'NOT PRESENT');
    end

  fprintf(ctlfid,'\nCompass Data ------------ ');
    if(comp==2) 
      fprintf(ctlfid,'PRESENT');
    else
      fprintf(ctlfid,'NOT PRESENT');
    end
   
  fprintf(ctlfid,'\nVelocity Coordinates ---- ');
    if(comp == 2)
      fprintf(ctlfid,'Earth (East,North,Up)');
    else 
      fprintf(ctlfid,'Probe (X,Y,Z)');
    end

  fprintf(ctlfid,'\n\n                    Distances to Boundary');
  fprintf(ctlfid,'\nProbe #     from probe tip     from sampling volume');
  fprintf(ctlfid,'\n---------------------------------------------------');
  fprintf(ctlfid,'\n%5d',1);
    if(ProbeBoundaryRange > 0)
      fprintf(ctlfid,'%14.2f cm  %14.2f cm', ProbeBoundaryRange,...
	     VolumeBoundaryRange);
    else 
      fprintf(ctlfid,'     Not Detected ');
    end
   
  fprintf(ctlfid,['\n---------------------------------------------']);

  fclose(ctlfid);
end

% Determine function's returned variables
seconds=starttime(6)+starttime(5)/100;
starttime=datenum(strtyear,starttime(2),starttime(1),starttime(4),...
		  starttime(3),seconds);
numrecs=SamplesInFile;

return
