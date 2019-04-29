#!/bin/bash
sample=$1
dir_alignment='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/alignment_ht2'
dir_circ='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/Circ'
dir_circfinder='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/CircFinder'
mkdir -p ${dir_circfinder}/${sample}
fa='/extraspace/sli/ref/fa/gencode_v19_genome_hg19.fa'
gtf='/extraspace/sli/ref/gtf/gencode_v19_annotation_hg19.gtf'
star='/extraspace/sli/softwares/bin/STAR'
gdir='/extraspace/sli/ref/fa/star_index_hg19'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fq'
${star} --genomeDir ${gdir} --readFilesIn ${unmap_fq} --runThreadN 15 --chimSegmentMin 20 --chimScoreMin 1 --alignIntronMax 100000 \
--chimOutType Junctions SeparateSAMold --outFilterMismatchNmax 4 --alignTranscriptsPerReadNmax 100000 --outFilterMultimapNmax 2 --outFileNamePrefix ${dir_circfinder}/${sample}
pstalign='/extraspace/sli/softwares/circRNA_finder/postProcessStarAlignment.pl'
star_align=${dir_circfinder}/${sample}
circ_finder_out=${dir_circfinder}/${sample}
perl ${pstalign} ${star_align} ${circ_finder_out}
