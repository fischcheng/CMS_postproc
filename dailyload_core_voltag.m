function [AL_TS, transit_vol,total_leaked]= dailyload_core_voltag(matpath,tagpath,exptname,stdate,endate,ltstp,mode)
% read in a given crossing-determined .mat file, bin them monthly and attach volume tag, then export as AL timeseries
% 2014/5/15 add the time_length till lastcrossing
% 2014/8/27 modified for pentad use
% 2014/10/30 modified for HRC07ctrl output
% 2014/11/04 debugging
% 2015/10/29 adapt for fixed leakage index
% 2015/11/13 lean down to its core form for modulized use

clear *ptle*
ptletrans=textread([tagpath,exptname,'_voltag']);
clear *cross* *idx

load([matpath,exptname,'_ptleGHidx']);

start_date = datenum(stdate);
end_date= datenum(endate);
daycount=[start_date:end_date];

if mode==1   % for fixed recirculation TS
	GHptletrans=ptletrans(ptleGHidx);    %load in leakage particles indices, easily change with the fixed version
    total_leaked=length(ptleGHidx);      % total number of leaked particles
    [binptle,binint]=histc(lastcrosstime,daycount);
    timelength=timelength2lastcross;
    clear binptle

else
	GHptletrans=ptletrans(ptleGHidx_old);    %load in leakage particles indices, easily change with the fixed version
    total_leaked=length(ptleGHidx_old);      % total number of leaked particles
    [binptle,binint]=histc(lastcrosstime_old,daycount);
    timelength=timelength2lastcross_old;
    clear binptle

end

for ii=1:length(daycount)
   idx=find(binint==ii);
   AL_TS(ii)=sum(GHptletrans(idx));
   clear idx
end


% This is for the histogram of transit times according to transport., not needed now
for jj=1:ltstp   % need to be automatic, 5year integration length
   idx2=find(timelength==jj);
   transit_vol(jj)=sum(GHptletrans(idx2));
   clear idx2
end


% Obsolete:  THis need to be revived for the Heat and Salt transport approach
%only need this for profiles plotting >>> find the last crossling location
%for pp=1:length(ptleGHidx)
  %lastcrosslon(pp)=crosslon(ptleGHidx(pp));   
  %lastcrosslat(pp)=crosslat(ptleGHidx(pp));
%end
