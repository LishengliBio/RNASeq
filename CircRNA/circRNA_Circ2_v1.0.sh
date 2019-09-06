#!/bin/bash
sample=$1
dir_alignment='/extraspace/sli/circRNA01/alignment_ht2'
dir_circ='/extraspace/sli/circRNA01/circRNA/Circ'
mkdir -p ${dir_circ}/${sample}
fa='/extraspace/sli/ref/fa/gencode_v28_genome.fa'
bwa='/extraspace/sli/softwares/bin/bwa'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fastq'
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
${bwa} mem -t 8 -T 19 ${fa} ${unmap_fq} > ${unmap_bwa_sam} 2> ${dir_circ}/${sample}/${sample}'_bwa.log'
circ2='/extraspace/sli/softwares/anaconda2/bin/CIRCexplorer2'
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
${circ2} parse -t BWA -b ${dir_circ}/${sample}/${sample}'_circ2_result.txt' ${unmap_bwa_sam} > ${dir_circ}/${sample}/${sample}'_test.parse.log'
ann_ref='/extraspace/sli/ref/hg38_ref_Circ2.txt'
${circ2} annotate -r ${ann_ref} -g ${fa} -b ${dir_circ}/${sample}/${sample}'_circ2_result.txt' -o ${dir_circ}/${sample}/${sample}'_circ2_result_ann.circ2'
