'''
generate HRC07p2d CMS release files for several chunks

'''

import os
import glob
from gen_hrc07_release_chunks import gen_chunks
import scipy.io

flist=sorted(glob.glob('/projects/rsmas/kirtman/ycheng/rawCMS/ACTmatfiles/HRC07p2d/shift2/vertTrans_ACTvoltrans_HRC07p2d_*.mat'))

last=1
num=5
for i in range(last,last+num):
	#print('Now is generating Release and Voltag files for '+flist[i][96:117]) for shuf1
	print('Now is generating Release and Voltag files for '+flist[i][97:118]) #for shift1
	gen_chunks(i,flist[i])

