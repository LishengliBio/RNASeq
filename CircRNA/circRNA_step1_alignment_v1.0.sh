#!/bin/bash
### Usage: bash circRNA_step1_alignment_v1.0 [sample_name]
#Get the sample name from command line
sample=$1
# Set the working directories
dir_wk='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat'
dir_alignment=${dir_wk}'/alignmet_ht2'
mkdir -p ${dir_alignment}/${sample}
dir_tmp=${dir_alignment}/${sample}
# Prepare softwares or tools
ht2='/extraspace/sli/softwares/bin/hisat2'
sambamba='/extraspace/sli/softwares/bin/sambamba'
samtools='/extraspace/sli/softwares/bin/samtools'
bam2fq='/extraspace/sli/softwares/bin/bamToFastq'
# Prepare hisat2 index file
ht2_indx='/extraspace/sli/ref/fa/hisat2_index_hg19/gencode_v19_hg19'
# Prepare output files
out_sam=${dir_alingment}/${sample}/${sample}'_alignment.sam'
out_bam=${dir_alignment}/${sample}/${sample}'_alignment.bam'
unmap=${dir_alignment}/${sample}/${sample}'_unmapped.bam'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fq'
out_sortbam=${dir_alignment}/${sample}/${sample}'_alignment_sorted.bam'
# Get fastq files
fqs=(`ls ${dir_wk}/fastq/${sample}/*.fastq.gz`)
# Run alignment using hisat2
${ht2} -x ${ht2_indx} -1 ${fqs[0]} -2 ${fqs[1]} -S ${out_sam}
# Convert Sam file to Bam file
${sambamba} view ${out_sam} -S -f bam -o ${out_bam}
# Get the unmapped alignment in bam file
${samtools} view -b -hf 4 ${bamfile} > ${unmap}
# Get the unmapped sequence
${bam2fq} -i ${unmap} -fq ${unmap_fq}
# sort the bam file
${sambamba} sort -o ${out_sortbam} --tmpdir ${dir_tmp} -t 8 ${out_bam}
# remove the sam ban unsorted bam files
