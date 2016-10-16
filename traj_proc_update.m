% Processing trajctory files, main program
% 2015/11/13, must modulize the old processing scripts, either use single_chunk, or multi-chunks.
% Usage: trajectory_proc('HRC07p2d',64,8,'1941-01-15','1950-10-15',0)
% Input description: exptname, number of trajectory files, number of chunks, start_date, end_date, turbulent module
% 2016/10/14, modified for ascii processing.

% Initialization
addpath /nethome/ycheng1/matlib
%clear all
%close all'
exptname='HRC07p2d_shift2_chunk01'
shuf='shift2'
num_traj=64;
stdate='1951-01-01'
endate='1960-12-31'
exist=0
time=[0,86400*[1:5*365]];
ltstp=length(time);


%the absolute path should be adjusted to your need
trajpath=['/scratch/projects/cpp/ycheng/CMSexpt/Shuffle/',shuf,'/expt_',exptname,'/output/'];
matpath=['/scratch/projects/cpp/ycheng/CMSexpt/Shuffle/',shuf,'/ptlecrossing/'];
%tagpath=['/scratch/users/ycheng1/',exptname,'/ptlecrossing/'];
tagpath=['/nethome/ycheng1/ReleaseFiles/Shuffle_chunks/',shuf,'/'] ;%can be modified


% Call the functions
if exist==0
% call the single_chunk_ascii processing, looping through 64 traj files:
[ptleGHidx,lastcrosstime, timelength2lastcross,lastcrosslon,lastcrosslat,lasscrossdep]=cms_ascii_postproc(trajpath,num_traj);
% save the intermediate .mat files
save([matpath,exptname,'_ptleGHidx'],'ptleGHidx','lastcrosstime', 'timelength2lastcross','lastcrosslon','lastcrosslat','lastcrossdep');

% run the core_voltag function twice in different mode to claculate histogram and time-series
[AL_TS, transit_vol,total_leaked]=dailyload_core_voltag(matpath,tagpath,exptname,stdate,endate,ltstp,1);
smo_TS=smooth(AL_TS,31);  % 31 days running mean, no necessary work on every cases
%smo2_TS=smooth(AL_TS,31);
save([exptname,'_TS_transit'],'AL_TS', 'smo_TS', 'transit_vol')


else % if the _ptleGHidx already exists
[AL_TS, transit_vol,total_leaked]=dailyload_core_voltag(matpath,tagpath,exptname,stdate,endate,ltstp,1);
smo_TS=smooth(AL_TS,31);  % 31 days running mean, no necessary work on every cases
%smo2_TS=smooth(AL_TS,31);

save([exptname,'_TS_transit'],'AL_TS', 'smo_TS', 'transit_vol') % final product
	
end
exit
%
