#!/bin/bash
sample=$1
ciri2='/extraspace/sli/softwares/CIRI_v2.0.6/CIRI2.pl'
dir_alignment='/extraspace/sli/circRNA01/alignment_ht2'
dir_circ='/extraspace/sli/circRNA01/circRNA/Circ'
dir_ciri='/extraspace/sli/circRNA01/circRNA/Ciri'
mkdir -p ${dir_ciri}/${sample}
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
fa='/extraspace/sli/ref/fa/gencode_v28_genome.fa'
gtf='/extraspace/sli/ref/gtf/gencode_v28_annotation.gtf'
ciri_out=${dir_ciri}/${sample}/${sample}'_circrna.ciri'
perl ${ciri2} -T 6 -I ${unmap_bwa_sam} -O ${ciri_out} -F ${fa} -A ${gtf} -G ${dir_ciri}/${sample}/${sample}'_ciri.log'
