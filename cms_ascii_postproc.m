function [ptleGHidx_full,lastcrosstime_full,timelength2lastcross_full,lastcrosslon_full,lastcrosslat_full,lastcrossdep_full]= cms_ascii_postproc(trajpath,num_traj)
%function [ptleGHidx,ptleGHidx_old,lastcrosstime,lastcrosstime_old, timelength2lastcross, timelength2lastcross_old]= single_chunk(trajpath,num_traj)
addpath /nethome/ycheng1/matlib
% The new post-processing tool for ascii output, avoiding using netcdf features:
% 2016/10/14 starting 
% use new MATLAB function (available after 2016a) tabularTextDatastore('traj_file_01','TreatAsMissing','NA','MissingValue',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set the Sections coordinates GH and ACT
mgh_lon=[18.1, 7.1];
mgh_lat=[-34.15, -45.15];

% slightly move ACT line west-ward by 0.1 deg. to make sure all release particle cross at least once
actlat=[-33.55,-35.75];
actlon=[27.3,29.5];    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loop through trajectory files: 
%num_traj=2;
time=[0,86400*[1:5*365]];

if num_traj<10
dig='%d';
else
dig='%02d';
end
dig='%02d';
for trajfileidx=1:num_traj % loop through all traj files

%disp(['Determine Trajectory file # ',num2str(trajfileidx)]);
ds=tabularTextDatastore([trajpath,'traj_file_',num2str(trajfileidx,dig),'.txt']);
ds.VariableNames = {'particleid','sameloc','time','lon','lat','depth','distance','exitcode','releasedate'};
ds.SelectedVariableNames = {'particleid','time','lon','lat','depth','releasedate'};

% Actually load in the data:
trajdata=readall(ds);
% Set up invariant variables:
if trajfileidx==1
	totalparticle=max(trajdata.particleid);
end
%totalparticle=1100;
releasedate=trajdata.releasedate(1:totalparticle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First nested loop, determine the crossing points of each trajectory.
% Determine particle crossing, number of crossing, index of crossing, not yet leakage. 
disp(['Determine Trajectory file # ',num2str(trajfileidx)]);
for ptle=1:totalparticle
if mod(ptle,1000)==1
   	disp(['Determine particle crossing for particle # ',num2str(ptle)]);
end 

traj_lon=trajdata.lon(trajdata.particleid==ptle+totalparticle*(trajfileidx-1));
traj_lat=trajdata.lat(trajdata.particleid==ptle+totalparticle*(trajfileidx-1));
traj_depth=trajdata.depth(trajdata.particleid==ptle+totalparticle*(trajfileidx-1));

[X0,Y0,II]=polyxpoly(mgh_lon,mgh_lat,traj_lon, traj_lat);
[xact,yact,Idxact]=polyxpoly(actlon,actlat,traj_lon, traj_lat);

crosslon{ptle}=X0;
crosslat{ptle}=Y0;
locidx{ptle}=II;

% MAKE SURE IF A PARTICLE CROSS THE ACT FOR MULTIPLE TIMES
crosslat2{ptle}=yact;

clear X0 Y0 II 
clear xact yact Idxact
clear traj_lon traj_lat  traj_depth 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second nested loop. (about 260 sec, a bit more than 4min per trajectory file.)
% Determine leaked index of particles by odd number of crossing/ crossing only once on ACT
cnt=1;
%cnt2=1;
for ptle=1:totalparticle
if mod(ptle,1000)==1
disp(['Determine particle leakage for particle # ',num2str(ptle)]);
end 
%Crossing GoodHope for odd number and ACT only once  >> recirculation condition
if mod(length(crosslat{ptle}),2)==1 & (length(crosslat2{ptle})<2)
ptleGHidx(cnt)=ptle+(trajfileidx-1)*totalparticle;        % Index need to add up the processed chunks                       
cnt=cnt+1;
end
%Determine leaked index of particles by odd number of crossing the GoodHope Line
%if mod(length(crosslat{ptle}),2)==1
%ptleGHidx_old(cnt2)=ptle;                            
%cnt2=cnt2+1;
%end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Particle release date (convert from Julian date to matlab datenum/Gregorian date): TIME STAMP
for ptle=1:totalparticle
if mod(ptle,1000)==1
disp(['Determine last crossing date for particle # ',num2str(ptle)]);
end
[yy,mm,dd,yd]=jul2greg(releasedate(ptle));
releasedatenum(ptle)=datenum(yy,mm,dd);            %every particles release date<< something wrong with this line
clear yy mm dd yd
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Last nested loop, determine the timing of GHline crossing, only looping through leakage particles
if exist('ptleGHidx')==1 

for pp=1:length(ptleGHidx) 
lc_tidx(pp)=round(max(locidx{ptleGHidx(pp)-totalparticle*(trajfileidx-1)}(:,2)));   %time index for last crossing   
reldatenum(pp)=releasedatenum(ptleGHidx(pp)-totalparticle*(trajfileidx-1));       %particle release date >>> used below, dont worry
end

% 10 sec this part
for pp=1:length(ptleGHidx)
timelength2lastcross(pp)=time(lc_tidx(pp))/86400;  %days
lastcrosstime(pp)=time(lc_tidx(pp))/86400 + reldatenum(pp);  %timestamp of particle crossing
lastcrosslon(pp)=crosslon{ptleGHidx(pp)-(trajfileidx-1)*totalparticle}(end);
lastcrosslat(pp)=crosslat{ptleGHidx(pp)-(trajfileidx-1)*totalparticle}(end);
crossingdeplist=trajdata.depth(trajdata.particleid==ptleGHidx(pp));
lastcrossdep(pp)=crossingdeplist(lc_tidx(pp));
clear crossingdeplist
end

clear ds trajdata


if trajfileidx==1
lastcrosstime_full=lastcrosstime;
lastcrosslat_full=lastcrosslat;
lastcrosslon_full=lastcrosslon;
lastcrossdep_full=lastcrossdep;
timelength2lastcross_full=timelength2lastcross;
ptleGHidx_full=ptleGHidx;
else
lastcrosstime_full=[lastcrosstime_full,lastcrosstime];
lastcrosslat_full=[lastcrosslat_full,lastcrosslat];
lastcrosslon_full=[lastcrosslon_full,lastcrosslon];
lastcrossdep_full=[lastcrossdep_full,lastcrossdep];
timelength2lastcross_full=[timelength2lastcross_full,timelength2lastcross];
ptleGHidx_full=[ptleGHidx_full,ptleGHidx];
end

clear lastcrosstime lastcrosslon lastcrosslat lastcrossdep timelength2lastcross ptleGHidx
end % the if condition to determine if ptleGHidx exists
end % the loop for files
% return [ptleGHidx,ptleGHidx_old,lastcrosstime,lastcrosstime_old, timelength2lastcross, timelength2lastcross_old]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concatenate all process files together



