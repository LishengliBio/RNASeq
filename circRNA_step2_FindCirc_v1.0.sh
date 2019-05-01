#!/bin/bash
## Usage: bash circRNA_step2_FindCirc_v1.0 [sample name]
# Get the sample name from command line
sample=$1

# Set working directory and files
dir_alignment='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/alignment_ht2'
dir_findcirc='/extraspace/sli/collaboration/XiangYu_circRNA/TGF_treat/circRNA/FindCirc'
unmap=${dir_alignment}/${sample}/${sample}'_unmapped.bam'
unmap_fq=${dir_alignment}/${sample}/${sample}'_unmapped.fastq'
fa='/extraspace/sli/ref/fa/gencode_v19_genome.fa'
bt2_index='/extraspace/sli/ref/fa/bowtie2_index_hg19/gencode_v19_hg19'
unmap_anchor=${dir_findcirc}/${sample}/${sample}'_unmapped_anchor.fastq'

# Prepare softwares and tools
unmap2anch='/extraspace/sli/softwares/find_circ/unmapped2anchors.py'
unmap_anchor=${dir_findcirc}/${sample}/${sample}'_unmapped_anchor.fastq'
find_circ='/extraspace/sli/softwares/find_circ/find_circ.py'
bt2='/extraspace/sli/softwares/bin/bowtie2'
findcirc_log=${dir_findcirc}/${sample}/${sample}'.log'
findcirc_bed=${dir_findcirc}/${sample}/${sample}'.bed'
findcirc_read=${dir_findcirc}/${sample}/${sample}'.reads'
findcirc_final=${dir_findcirc}/${sample}/${sample}'_final.bed'

# Run FindCirc to call circRNA
python ${unmap2anch} ${unmap} > ${unmap_anchor}
${bt2} -p 8 --reorder --quiet --mm --score-min=C,-15,0 -q -x ${bt2_index} -U ${unmap_anchor} | \
python ${find_circ} -G ${fa} -p find_circ -s ${findcirc_log} > ${findcirc_bed} 2> ${findcirc_read}
maxlen='/extraspace/sli/softwares/find_circ/maxlength.py'
grep CIRCULAR ${findcirc_bed} | grep -v chrM | awk '$5>=2' | grep UNAMBIGUOUS_BP | grep ANCHOR_UNIQUE | \
python ${maxlen} 100000 > ${findcirc_final}

