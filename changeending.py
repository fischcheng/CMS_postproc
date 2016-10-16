import os
import glob

shuf='shift2'
exptname='HRC07p2d_shift2_chunk02'
flist=sorted(glob.glob('/scratch/projects/cpp/ycheng/CMSexpt/Shuffle/'+shuf+'/expt_'+exptname+'/output/traj_file_??'))
os.chdir('/scratch/projects/cpp/ycheng/CMSexpt/Shuffle/'+shuf+'/expt_'+exptname+'/output/')
for name in flist:
	fname=name[-12:]
	cmd='mv '+fname+' '+fname+'.txt'
	os.system(cmd)

