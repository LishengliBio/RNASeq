#!/bin/bash
## Usage: bash circRNA_step2_FindCirc_v1.0 [sample name]
# Get the sample name from command line
sample=$1
dir_alignment='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/alignment_ht2'
dir_findcirc='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/FindCirc'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fq'
${bam2fq} -i ${unmap} -fq ${unmap_fq}
unmap2anch='/extraspace/sli/softwares/find_circ/unmapped2anchors.py'
unmap_anchor=${dir_findcirc}/${sample}/${sample}'_unmapped_anchor.fq'
python ${unmap2anch} ${unmap} > ${unmap_anchor}
bt2='/extraspace/sli/softwares/bin/bowtie2'
bt2_index='/extraspace/sli/ref/fa/bowtie2_index_hg19/gencode_v19_hg19'
fa='/extraspace/sli/ref/fa/gencode_v19_genome.fa'
unmap_anchor=${dir_findcirc}/${sample}/${sample}'_unmapped_anchor.fq'
find_circ='/extraspace/sli/softwares/find_circ/find_circ.py'
${bt2} -p 8 --reorder --quiet --mm --score-min=C,-15,0 -q -x ${bt2_index} -U ${unmap_anchor} | \
python ${find_circ} -G ${fa} -p find_circ -s ${sample}'.log' > ${sample}'.bed' 2> ${sample}'.reads'
maxlen='/extraspace/sli/softwares/find_circ/maxlength.py'
grep CIRCULAR ${sample}'.bed' | grep -v chrM | awk '$5>=2' | grep UNAMBIGUOUS_BP | grep ANCHOR_UNIQUE | \
python ${maxlen} 100000 > ${sample}'_final.bed'

