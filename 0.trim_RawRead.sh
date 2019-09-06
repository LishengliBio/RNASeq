#!/bin/bash
sample=$1
dir_wk='/extraspace/sli/circRNA01'
fq1=${dir_wk}'/fastq02/'${sample}'/'${sample}'_R1.fastq.gz'
fq2=${dir_wk}'/fastq02/'${sample}'/'${sample}'_R2.fastq.gz'
dir_trim=${dir_wk}'/Trim_results'
mkdir -p ${dir_trim}/${sample}
filt_fn_r1=${sample}'_filtered_R1.fastq.gz'
unp_fn_r1=${sample}'_unpaired_R1.fastq.gz'
filt_fn_r2=${sample}'_filtered_R2.fastq.gz'
unp_fn_r2=${sample}'_unpaired_R2.fastq.gz'
trim='/extraspace/sli/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar'
adapter='/extraspace/sli/ref/Adapters_PE.fa'
java -jar ${trim} PE ${fq1} ${fq2} ${dir_trim}/${sample}/${filt_fn_r1} \
        ${dir_trim}/${sample}/${unp_fn_r1} ${dir_trim}/${sample}/${filt_fn_r2} ${dir_trim}/${sample}/${unp_fn_r2} \
        'ILLUMINACLIP:'${adapter}':2:30:10' LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> ${dir_trim}/${sample}/read_surviving_stat.txt
