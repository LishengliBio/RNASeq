#!/bin/bash
# Get the sample name from command line
sample=$1
# Set working directories and files
dir_findcirc='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/FindCirc'
dir_circ='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/Circ'
mkdir -p ${dir_circ}/${sample}
fa='/extraspace/sli/ref/fa/gencode_v19_genome_hg19.fa'
unmap_fq=${dir_findcirc}/${sample}/${sample}'_unmapped.fastq'
unmap_bwa_sam=${dir_circ}/${sample}/${sample}'_unmapped_bwa.sam'
ann_ref='/extraspace/sli/ref/Circ2_hg19_ref_ann.txt'

# Prepare softwares and tools
bwa='/extraspace/sli/softwares/bin/bwa'
circ2='/extraspace/sli/softwares/anaconda2/bin/CIRCexplorer2'

# Run Circ2 to call circRNAs
${bwa} mem -t 8 -T 19 ${fa} ${unmap_fq} > ${unmap_bwa_sam} 2> ${outdir}/${sample}'_bwa.log'
${circ2} parse -t BWA -b ${dir_circ}/${sample}/${sample}'_circ2_result.txt' ${unmap_bwa_sam} > ${dir_circ}/${sample}/${sample}'_test.parse.log'
${circ2} annotate -r ${ann_ref} -g ${fa} -b ${dir_circ}/${sample}/${sample}'_circ2_result.txt' -o ${dir_circ}/${sample}/${sample}'_circ2_result_ann.circ2'

## Note: you can download the annotation file using circRNA_circ_fetch_ann.py
# python fetch_ucsc.py hg19 ref /extraspace/sli/ref/Circ2_hg19_ref_ann.txt
