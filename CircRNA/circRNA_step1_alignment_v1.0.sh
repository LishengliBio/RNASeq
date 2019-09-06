#!/bin/bash
sample=$1
dir_wk='/extraspace/sli/circRNA01'
dir_fq=${dir_wk}'/Trim_results'
fq1=${dir_fq}/${sample}/${sample}'_filtered_R1.fastq.gz'
fq2=${dir_fq}/${sample}/${sample}'_filtered_R2.fastq.gz'
ht2='/extraspace/sli/softwares/bin/hisat2'
ht2_indx='/extraspace/sli/ref/fa/hisat2_index/gencode_v28'
outdir=${dir_wk}'/alignment_ht2/'${sample}
mkdir -p ${outdir}
out_sam=${outdir}/${sample}'_alignment.sam'
${ht2} -x ${ht2_indx} -1 ${fq1} -2 ${fq2} -S ${out_sam}
sambamba='/extraspace/sli/softwares/bin/sambamba'
bamfile=${outdir}/${sample}'_alignment.bam'
${sambamba} view ${out_sam} -S -f bam -o ${bamfile}
samtools='/extraspace/sli/softwares/bin/samtools'
unmap=${outdir}/${sample}'_unmapped.bam'
${samtools} view -b -hf 4 ${bamfile} > ${unmap}
bam2fq='/extraspace/sli/softwares/bin/bamToFastq'
unmap_fq=${outdir}/${sample}'_unmapped.fastq'
${bam2fq} -i ${unmap} -fq ${unmap_fq}
file_stat=${dir_wk}'/alignment_ht2/'${sample}'/'${sample}'_alignment.stat'
${samtools} flagstat ${bamfile} > ${file_stat}
sortbam=${dir_wk}'/alignment_ht2/'${sample}'/'${sample}'_alignment_sorted.bam'
tmpdir=${dir_wk}'/alignment_ht2/'${sample}
${sambamba} sort -o ${sortbam} --tmpdir ${tmpdir} -t 8 ${bamfile}
rm -f ${out_sam}
rm -f ${bamfile}
