from collections import defaultdict
dir_wk = '/extraspace/sli/collaboration/XiangYu_circRNA/siPHAX/circRNA'
samples = ['siFFL_repA','siFFL_repB','siFFL_repC','siPHAX_repA','siPHAX_repB','siPHAX_repC']
tools = ['Circ','CircFinder','Ciri','FindCirc']
for s in samples:
        print('Processing '+s)
        sample_circ = defaultdict(dict)
        for t in tools:
                print('Processing '+t)
                file_circ = dir_wk+'/'+t+'/'+s+'/'+s+'_filter_result.txt'
                fh_circ = open(file_circ,'r')
                fh_circ.readline()
                for l in fh_circ:
                        l = l.strip()
                        tmp = l.split('\t')
                        sample_circ[tmp[0]][t] = tmp[1]
                fh_circ.close()
        file_circs = dir_wk+'/merge/'+s+'_tools_circs.txt'
        fh_circs = open(file_circs,'w')
        fh_circs.write('CircRNA\tTools\tCirc\tCircFinder\tCiri\tFindCirc\n')
        for cc in sample_circ.keys():
                toolss = ';'.join(sample_circ[cc].keys())
                read_circ = 0
                read_circfinder = 0
                read_ciri = 0
                read_findcirc = 0
                if 'Circ' in sample_circ[cc].keys():
                        read_circ = sample_circ[cc]['Circ']
                if 'CircFinder' in sample_circ[cc].keys():
                        read_circfinder = sample_circ[cc]['CircFinder']
                if 'Ciri' in sample_circ[cc].keys():
                        read_ciri = sample_circ[cc]['Ciri']
                if 'FindCirc' in sample_circ[cc].keys():
                        read_findcirc = sample_circ[cc]['FindCirc']
                fh_circs.write(cc+'\t'+toolss+'\t'+str(read_circ)+'\t'+str(read_circfinder)+'\t'+str(read_ciri)+'\t'+str(read_findcirc)+'\n')
        fh_circs.close()
