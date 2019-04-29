#!/bin/bash
sample=$1
dir_findcirc='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/FindCirc'
dir_circ='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/Circ'
mkdir -p ${dir_circ}/${sample}
fa='/extraspace/sli/ref/fa/gencode_v19_genome_hg19.fa'
bwa='/extraspace/sli/softwares/bin/bwa'
unmap_fq=${dir_findcirc}/${sample}/${sample}'_unmapped.fq'
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
${bwa} mem -t 8 -T 19 ${fa} ${unmap_fq} > ${unmap_bwa_sam} 2> ${outdir}/${sample}'_bwa.log'
circ2='/extraspace/sli/softwares/anaconda2/bin/CIRCexplorer2'
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
${circ2} parse -t BWA -b ${dir_circ}/${sample}/${sample}'_circ2_result.txt' ${unmap_bwa_sam} > ${dir_circ}/${sample}/${sample}'_test.parse.log'
ann_ref='/extraspace/sli/ref/Circ2_hg19_ref_ann.txt'
${circ2} annotate -r ${ann_ref} -g ${fa} -b ${dir_circ}/${sample}/${sample}'_circ2_result.txt' -o ${dir_circ}/${sample}/${sample}'_circ2_result_ann.circ2'

## Note: you can download the annotation file using circRNA_fetch_ 
#
