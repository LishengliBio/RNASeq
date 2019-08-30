#!/bin/bash

sample=$1
dir_fq='/home/D/cza/ATAC_HCC_tissue/LSL/fastq'
fq1=ls ${dir_fq}/${sample}/${sample}'_R1.fastq.gz'
fq2=ls ${dir_fq}/${sample}/${sample}'_R2.fastq.gz'
dir_out='/home/D/cza/ATAC_HCC_tissue/LSL/TRIM_results/'${sample}
mkdir -p ${dir_out}
filt_fn_r1=${dir_out}/${sample}'_filtered_R1.fastq.gz'
unp_fn_r1=${dir_out}/${sample}'_unpaired_R1.fastq.gz'
filt_fn_r2=${dir_out}/${sample}'_filtered_R2.fastq.gz'
unp_fn_r2=${dir_out}/${sample}'_unpaired_R2.fastq.gz'
java='/usr/bin/java'
trim='/home/D/pgm/java/trimmomatic.jar'
adapter='/home/D/ref/fasta/adapters/Adapters_PE.fa'
${java} -jar ${trim} PE ${fq1} ${fq2} ${dir_out}/${sample}/${filt_fn_r1} \
        ${dir_out}/${sample}/${unp_fn_r1} ${dir_out}/${sample}/${filt_fn_r2} ${dir_out}/${sample}/${unp_fn_r2} \
        'ILLUMINACLIP:'${adapter}':2:30:10' LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> ${dir_out}/${sample}/read_surviving_stat.txt
