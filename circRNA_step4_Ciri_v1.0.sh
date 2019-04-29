#!/bin/bash
ciri2='/extraspace/sli/softwares/CIRI_v2.0.6/CIRI2.pl'
dir_findcirc='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/FindCirc'
dir_circ='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/Circ'
dir_ciri='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/Ciri'
mkdir -p ${dir_ciri}/${sample}
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
fa='/extraspace/sli/ref/fa/gencode_v19_genome_hg19.fa'
gtf='/extraspace/sli/ref/gtf/gencode_v19_annotation_hg19.gtf'
ciri_out=${dir_ciri}/${sample}/${sample}'_circrna.ciri'
perl ${ciri2} -T 6 -I ${unmap_bwa_sam} -O ${ciri_out} -F ${fa} -A ${gtf} -G ${dir_ciri}/${sample}/${sample}'_ciri.log'

