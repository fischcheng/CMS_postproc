'''
2016/5/24 Auto chunking for large/eddy separation since single sequence runs too slow.
2016/5/31 modified for HRC07m2d
2016/6/13 modified for HRC07m2d
2016/6/23 modified for shuffle experiment
2016/7/11 modified for chunk traj processing.

Yu Cheng
'''
import os
import glob

# User-defined variables, experiment and so on 
case='HRC07p2d'
shuf='shift2'
# Directories
parent='/scratch/projects/cpp/ycheng/CMSexpt/Shuffle/'+shuf
#inputchunk='/scratch/projects/cpp/ycheng/CMSexpt/HRC07m2d/input_HRC07m2d_chunk'
flist=sorted(glob.glob('/projects/rsmas/kirtman/ycheng/rawCMS/ACTmatfiles/HRC07p2d/'+shuf+'/vertTrans_ACTvoltrans_HRC07p2d_*.mat'))
#glob.glob('HRIE_10ATM_01.cam2.1.h0.*.nc')   #121-163, ensemble member 1-9
last=2
num=2
for i in range(last,last+num):
        os.chdir(parent)
        cmd='cp -f ./postprocess_tool_ascii/traj_proc_update.m proc_traj_chunk'+str(i+1).zfill(2)+'.m'
        os.system(cmd)   # copy the set of separation scr

        cmd2='cp -f ./postprocess_tool_ascii/proc_sub proc_sub_chunk'+str(i+1).zfill(2)
        os.system(cmd2)

        # Find number of trajectory files
        trajoutput='expt_'+case+'_'+shuf+'_chunk'+str(i+1).zfill(2)+'/output'
        num_traj=len(os.listdir(trajoutput))
        
        # Modify the proc_traj_chunk.m file
        Sdate=flist[i][97:107]
        YYs=flist[i][97:101]
        Yend=int(YYs)+9
        old_exptname="exptname='HRC07p2d_shift2_chunk01'"
	new_exptname="exptname='"+case+'_'+shuf+'_chunk'+str(i+1).zfill(2)+"'"
        old_numtraj='num_traj=64'
        new_numtraj='num_traj='+str(num_traj)
        old_shuf="shuf='shift2'"
        new_shuf="shuf='"+shuf+"'"	
        old_stdate="stdate='1951-01-01'"
        new_stdate="stdate='"+Sdate+"'"
        old_endate="endate='1960-12-31'"
        new_endate="endate='"+str(Yend)+"-12-31'"

        text = open('proc_traj_chunk'+str(i+1).zfill(2)+'.m').read()
        open('proc_traj_chunk'+str(i+1).zfill(2)+'.m', "w").write(text.replace(old_exptname,new_exptname))
        text = open('proc_traj_chunk'+str(i+1).zfill(2)+'.m').read()
        open('proc_traj_chunk'+str(i+1).zfill(2)+'.m', "w").write(text.replace(old_numtraj,new_numtraj))
        text = open('proc_traj_chunk'+str(i+1).zfill(2)+'.m').read()
        open('proc_traj_chunk'+str(i+1).zfill(2)+'.m', "w").write(text.replace(old_stdate,new_stdate))
        text = open('proc_traj_chunk'+str(i+1).zfill(2)+'.m').read()
        open('proc_traj_chunk'+str(i+1).zfill(2)+'.m', "w").write(text.replace(old_endate,new_endate))
        text = open('proc_traj_chunk'+str(i+1).zfill(2)+'.m').read()
        open('proc_traj_chunk'+str(i+1).zfill(2)+'.m', "w").write(text.replace(old_shuf,new_shuf))

        # Modify the submit script
        old_chunk='chunk01'
        new_chunk='chunk'+str(i+1).zfill(2)
        text = open('proc_sub_chunk'+str(i+1).zfill(2)).read()
        open('proc_sub_chunk'+str(i+1).zfill(2),"w").write(text.replace(old_chunk,new_chunk))

