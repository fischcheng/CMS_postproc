function [year, month, day, yearday] = jul2greg(julday)
%   convert a julian day to a gregorian day, month and year
%
%    test date is julian 244000 which is may 23, 1968.
%
igreg=2299161;
%                 yearday of beginning of each month
iyd=[1,32,60,91,121,152,182,213,244,274,305,335,366];
iydl=[1,32,61,92,122,153,183,214,245,275,306,336,367];
%     get fractional part of the julian day
jday=floor(julday);
fracday=julday-jday;

if jday >= igreg
   jalpha=floor(((jday-1867216)-0.25)/36524.25);
   ja=jday+1+jalpha-floor(0.25*jalpha);
else
   ja=jday;
end

jb=ja+1524;
jc=floor(6680.+((jb-2439870)-122.1)/365.25);
jd=365*jc+floor(0.25*jc);
je=floor((jb-jd)/30.6001);
day=jb-jd-floor(30.6001*je);
month=je-1;


%if month > 12 
%    month=month-12;

i=find(month > 12);
month(i)=month(i)-12;

year=jc-4715;

%if month > 2
%    year=year-1;

i=find(month > 2);
year(i)=year(i)-1;

%if year <= 0
%   year=year-1;

i=find(year <= 0 );
year(i)=year(i)-1;

leap=mod(year,4);

%if leap == 0
%    yearday=iydl(month)+day-1;
i=find(leap == 0);
yearday(i)=iydl(month(i))+day(i)-1;

%else
%    yearday=iyd(month)+day-1;

i=find(leap ~= 0);
yearday(i)=iyd(month(i))+day(i)-1;


%          replace fractional day
day=day+fracday;
