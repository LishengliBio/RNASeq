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
star='/extraspace/sli/softwares/bin/STAR'
gdir='/extraspace/sli/ref/fa/star_index_hg19'
unmap_fq=${dir_findcirc}/${sample}/${sample}'_unmapped.fq'
${star} --genomeDir ${gdir} --readFilesIn ${unmap_fq} --runThreadN 15 --chimSegmentMin 20 --chimScoreMin 1 --alignIntronMax 100000 \
--chimOutType Junctions SeparateSAMold --outFilterMismatchNmax 4 --alignTranscriptsPerReadNmax 100000 --outFilterMultimapNmax 2 --outFileNamePrefix ${outdir}/${sample}
pstalign='/extraspace/sli/softwares/circRNA_finder/postProcessStarAlignment.pl'
star_align=${dir_ciri}/${sample}
circ_finder_out=${dir_ciri}/${sample}
perl ${pstalign} ${star_align} ${circ_finder_out}
