import re
import numpy as np
dir_wk = '/extraspace/sli/collaboration/XiangYu_circRNA/siPHAX/circRNA/merge'
samples = ['siFFL_repA','siFFL_repB','siFFL_repC','siPHAX_repA','siPHAX_repB','siPHAX_repC']
for s in samples:
        print('Processing '+s)
        file_s = dir_wk+'/'+s+'_tools_circs.txt'
        fh_s = open(file_s,'r')
        file_out = dir_wk+'/'+s+'_tools_circs_filter.txt'
        fh_out = open(file_out,'w')
        fh_out.write('CircRNA\tMean_reads\n')
        fh_s.readline()
        for l in fh_s:
                l = l.strip()
                tmp = l.split('\t')
                if re.search(';',tmp[1]):
                        tmp1 = tmp[1].split(';')
                        Read_mean = int(np.sum([int(n) for n in tmp[2:]])/len(tmp1))
                        fh_out.write(tmp[0]+'\t'+str(Read_mean)+'\n')
        fh_s.close()
        fh_out.close()

