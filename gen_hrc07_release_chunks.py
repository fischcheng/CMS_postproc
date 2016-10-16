'''
# 2015/07/28 modified for HRC06m2d
# 2015/11/02 modified for HRC07p2d, only first year for sensitivity test of Integration length
# 2015/11/22 HRC07p2d_clim 30year release File
# 2016/06/09 write it into a function
# 2016/06/21 adjust for shuffyr experiment add one more argument exptname
# 2016/08/01 for shift1 experiment
'''
import numpy as np
import os
import datetime as dt
import scipy.io

def gen_chunks(chunkidx,matname): 
	case='HRC07p2d_shift2_chunk'+str(chunkidx+1).zfill(2)
	file_id = scipy.io.loadmat(matname)
	volfluxes=file_id['volfluxes']  # Already negative (southward volume flux)
	vlat=file_id['vlat']
	vlon=file_id['vlon']
	zt=file_id['rgnzt']


	ind=0
	table=[]
	index=[]

	#list_date=[]
	#for yr in range(102,155):
	#    list_date.extend([dt.datetime(yr, i, 15) for i in range(1,13)])


	#start date
	# date in matfile: flist[0][96:107]
	yy=int(matname[97:101])
	mm=int(matname[102:104])
	dd=int(matname[105:107])
	sdate=dt.date(yy,mm,dd).toordinal()

	for t in range(np.size(volfluxes,2)):
	        for l in range(1,np.size(volfluxes,1)+1): #something wrong with this indexing
	                for z in range(np.size(volfluxes,0)):
	                        if np.sign(volfluxes[z,l-1,t])==-1.0: #and np.floor(abs(volfluxes[z,l,t]/1e6)/ptle)>0:
	                                if zt[z]<10:
	                                          content='1   '+str('%.1f' %(vlon[l]))+' '+str('%.2f' %(vlat[l]))+'    '+str('%.6f' %(zt[z]))+'       1      '+str(dt.date.fromordinal(sdate+t).year).zfill(4)+'    '+str(dt.date.fromordinal(sdate+t).month)+'      '+str(dt.date.fromordinal(sdate+t).day)+'       0'
	                                elif zt[z]>=10 and zt[z]<100:
	                                        content='1   '+str('%.1f' %(vlon[l]))+' '+str('%.2f' %(vlat[l]))+'    '+str('%.5f' %(zt[z]))+'       1      '+str(dt.date.fromordinal(sdate+t).year).zfill(4)+'    '+str(dt.date.fromordinal(sdate+t).month)+'      '+str(dt.date.fromordinal(sdate+t).day)+'       0'
	                                elif zt[z]>=100 and zt[z]<1000:
	                                        content='1   '+str('%.1f' %(vlon[l]))+' '+str('%.2f' %(vlat[l]))+'    '+str('%.4f' %(zt[z]))+'       1      '+str(dt.date.fromordinal(sdate+t).year).zfill(4)+'    '+str(dt.date.fromordinal(sdate+t).month)+'      '+str(dt.date.fromordinal(sdate+t).day)+'       0'
	                                elif zt[z]>=1000 and zt[z]<10000:
	                                        content='1   '+str('%.1f' %(vlon[l]))+' '+str('%.2f' %(vlat[l]))+'    '+str('%.3f' %(zt[z]))+'       1      '+str(dt.date.fromordinal(sdate+t).year).zfill(4)+'    '+str(dt.date.fromordinal(sdate+t).month)+'      '+str(dt.date.fromordinal(sdate+t).day)+'       0'
	                                table.append(content)
	                                ind+=1
	                                volu=str('%.5f' %abs(volfluxes[z,l-1,t]/1e6))
	                                index.append(volu)


	# Loop through lines and save into releaseFile
	rmo='rm ./'+case+'_releaseFile'
	rmo2='rm ./'+case+'_voltag'
	os.system(rmo)
	os.system(rmo2)


	fname1=case+"_releaseFile"
	fname2=case+"_voltag"
	fid = open(fname1, "w")
	for i in range(len(table)):
	    a=table[i]+'\n'
	    fid.write(a)
	fid.close()
	fid2 = open(fname2, "w")
	for i in range(len(index)):
	    b=index[i]+'\n'
	    fid2.write(b)
	fid2.close()                              

