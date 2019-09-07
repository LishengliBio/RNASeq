#!/bin/bash
sample=$1
dir_alignment='/extraspace/sli/circRNA01/alignment_ht2'
dir_circ='/extraspace/sli/circRNA01/circRNA/Circ'
dir_circfinder='/extraspace/sli/circRNA01/circRNA/CircFinder'
mkdir -p ${dir_circfinder}/${sample}
fa='/extraspace/sli/ref/fa/gencode_v28_genome.fa'
gtf='/extraspace/sli/ref/gtf/gencode_v28_annotation.gtf'
star='/extraspace/sli/softwares/bin/STAR'
gdir='/extraspace/sli/ref/fa/star_index'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fastq'
${star} --genomeDir ${gdir} --readFilesIn ${unmap_fq} --runThreadN 15 --chimSegmentMin 20 --chimScoreMin 1 --alignIntronMax 100000 \
--chimOutType Junctions SeparateSAMold --outFilterMismatchNmax 4 --alignTranscriptsPerReadNmax 100000 --outFilterMultimapNmax 2 --outFileNamePrefix ${dir_circfinder}/${sample}/${sample}
pstalign='/extraspace/sli/softwares/circRNA_finder/postProcessStarAlignment.pl'
star_align=${dir_circfinder}/${sample}
circ_finder_out=${dir_circfinder}/${sample}
cd ${star_align}
perl ${pstalign} ${star_align} ${circ_finder_out}
