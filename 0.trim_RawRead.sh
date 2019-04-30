#!/bin/bash

sample=$1
dir_fq='/home/D/cza/ATAC_HCC_tissue/LSL/fastq'
fq1=`ls ${dir_fq}/${sample}/*_R1.fastq.gz`
fq2=`ls ${dir_fq}/${sample}/*_R2.fastq.gz`
dir_out='/home/D/cza/ATAC_HCC_tissue/LSL/TRIM_results'
mkdir -p ${dir_out}/${sample}
fn_r1=`echo ${fq1} | cut -d'/' -f 9`
fn_r2=`echo ${fq2} | cut -d'/' -f 9`
OLD_IFS="$IFS"
IFS="_"
fns_r1=($fn_r1)
fns_r2=($fn_r2)
IFS="$OLD_IFS"
filt_fn_r1=${fns_r1[0]}'_'${fns_r1[1]}'_filtered_R1.fastq.gz'
unp_fn_r1=${fns_r1[0]}'_'${fns_r1[1]}'_unpaired_R1.fastq.gz'
filt_fn_r2=${fns_r2[0]}'_'${fns_r2[1]}'_filtered_R2.fastq.gz'
unp_fn_r2=${fns_r2[0]}'_'${fns_r2[1]}'_unpaired_R2.fastq.gz'
java='/usr/bin/java'
trim='/home/D/pgm/java/trimmomatic.jar'
adapter='/home/D/ref/fasta/adapters/Adapters_PE.fa'
${java} -jar ${trim} PE ${fq1} ${fq2} ${dir_out}/${sample}/${filt_fn_r1} \
        ${dir_out}/${sample}/${unp_fn_r1} ${dir_out}/${sample}/${filt_fn_r2} ${dir_out}/${sample}/${unp_fn_r2} \
        'ILLUMINACLIP:'${adapter}':2:30:10' LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> ${dir_out}/${sample}/read_surviving_stat.txt
