dir_wk = '/extraspace/sli/collaboration/XiangYu_circRNA/siPHAX/circRNA'
samples = ['siFFL_repA','siFFL_repB','siFFL_repC','siPHAX_repA','siPHAX_repB','siPHAX_repC']
for s in samples:
        print('Processing '+s)
        file_circ = dir_wk+'/Circ/'+s+'/'+s+'_circ2_result_ann.circ2'
        fh_circ = open(file_circ,'r')
        file_outCirc = dir_wk+'/Circ/'+s+'/'+s+'_filter_result.txt'
        fh_outCirc = open(file_outCirc,'w')
        fh_outCirc.write('CircRNA\tBacksplice_reads\tGene\n')
        print('Cric')
        for l in fh_circ:
                l =  l.strip()
                tmp = l.split('\t')
                tmp1 = tmp[3].split('/')
                if int(tmp1[1]) < 2: continue
                circ = tmp[0]+':'+str(tmp[1])+'|'+str(tmp[2])+':'+tmp[5]
                fh_outCirc.write(circ+'\t'+str(tmp1[1])+'\t'+tmp[14]+'\n')
        fh_circ.close()
        fh_outCirc.close()
        file_circfinder = dir_wk+'/CircFinder/'+s+'/'+s+'s_filteredJunctions.bed'
        fh_circfinder = open(file_circfinder,'r')
        file_outCircFinder = dir_wk+'/CircFinder/'+s+'/'+s+'_filter_result.txt'
        fh_outCircFinder = open(file_outCircFinder,'w')
        fh_outCircFinder.write('CircRNA\tBacksplice_read\n')
        print('CircFinder')
        for l in fh_circfinder:
                l = l.strip()
                tmp = l.split('\t')
                if int(tmp[4]) < 2: continue
                circ = tmp[0]+':'+str(tmp[1])+'|'+str(tmp[2])+':'+tmp[5]
                fh_outCircFinder.write(circ+'\t'+str(tmp[4])+'\n')
        fh_circfinder.close()
        fh_outCircFinder.close()
        file_ciri = dir_wk+'/Ciri/'+s+'/'+s+'_circrna.ciri'
        fh_ciri = open(file_ciri,'r')
        file_outCiri = dir_wk+'/Ciri/'+s+'/'+s+'_filter_result.txt'
        fh_outCiri = open(file_outCiri,'w')
        fh_outCiri.write('CircRNA\tBacksplice_read\tGene\n')
        print('Ciri')
        fh_ciri.readline()
        for l in fh_ciri:
                l = l.strip()
                tmp = l.split('\t')
                if int(tmp[4]) < 2: continue
                tmp1 = tmp[0].split(':')
                tmp2 = tmp1[1].split('|')
                start = int(tmp2[0]) - 1
                circ = tmp1[0]+':'+str(start)+'|'+str(tmp2[1])+':'+tmp[10]
                fh_outCiri.write(circ+'\t'+str(tmp[4])+'\t'+tmp[9]+'\n')
        fh_ciri.close()
        fh_outCiri.close()
        file_findcirc = dir_wk+'/FindCirc/'+s+'/'+s+'_final.bed'
        fh_findcirc = open(file_findcirc,'r')
        file_outFindCirc = dir_wk+'/FindCirc/'+s+'/'+s+'_filter_result.txt'
        fh_outFindCirc = open(file_outFindCirc,'w')
        fh_outFindCirc.write('CircRNA\tBacksplice_read\n')
        print('FindCirc')
        for l in fh_findcirc:
                l = l.strip()
                tmp = l.split('\t')
                if int(tmp[4]) < 2: continue
                circ = tmp[0]+':'+str(tmp[1])+'|'+str(tmp[2])+':'+tmp[5]
                fh_outFindCirc.write(circ+'\t'+str(tmp[4])+'\n')
        fh_findcirc.close()
        fh_outFindCirc.close()
