#!/bin/bash
sample=$1
dir_alignment='/extraspace/sli/circRNA01/alignment_ht2'
dir_findcirc='/extraspace/sli/circRNA01/circRNA/FindCirc'
mkdir -p ${dir_findcirc}/${sample}
unmap=${dir_alignment}/${sample}/${sample}'_unmapped.bam'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fastq'
unmap2anch='/extraspace/sli/softwares/find_circ/unmapped2anchors.py'
unmap_anchor=${dir_findcirc}/${sample}/${sample}'_unmapped_anchor.fastq'
python ${unmap2anch} ${unmap} > ${unmap_anchor}
bt2='/extraspace/sli/softwares/bin/bowtie2'
bt2_index='/extraspace/sli/ref/fa/bowtie2_index/gencode_v28'
fa='/extraspace/sli/ref/fa/gencode_v28_genome.fa'
find_circ='/extraspace/sli/softwares/find_circ/find_circ.py'
findcirc_log=${dir_findcirc}/${sample}/${sample}'.log'
findcirc_bed=${dir_findcirc}/${sample}/${sample}'.bed'
findcirc_read=${dir_findcirc}/${sample}/${sample}'.reads'
findcirc_final=${dir_findcirc}/${sample}/${sample}'_final.bed'
${bt2} -p 8 --reorder --quiet --mm --score-min=C,-15,0 -q -x ${bt2_index} -U ${unmap_anchor} | \
python ${find_circ} -G ${fa} -p find_circ -s ${findcirc_read} > ${findcirc_bed} 2> ${findcirc_log}
maxlen='/extraspace/sli/softwares/find_circ/maxlength.py'
grep CIRCULAR ${findcirc_bed} | grep -v chrM | awk '$5>=2' | grep UNAMBIGUOUS_BP | grep ANCHOR_UNIQUE | \
python ${maxlen} 100000 > ${findcirc_final}
