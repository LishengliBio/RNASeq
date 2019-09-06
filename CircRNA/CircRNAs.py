#------------------------------------------
# Usage
#------------------------------------------
# python circRNA.py -d <working directory>

#------------------------------------------
# python modules and third-party softwares
#------------------------------------------

### Check required python modules and install missing ones

### Load required python modules 
import os
import time
import psutil
import re
import argparse

### Check and install required softwares

### Files and directories
trim = '/extraspace/sli/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar'
adapter_PE = '/extraspace/sli/ref/fa/Adapters_PE.fa'
adapter_SE = '/extraspace/sli/ref/fa/Adapters_SE.fa'
ht2 = '/extraspace/sli/softwares/bin/hisat2'
ht2_indx = '/extraspace/sli/ref/fa/hisat2_index/gencode_v28'
sambamba = '/extraspace/sli/softwares/bin/sambamba'
samtools = '/extraspace/sli/softwares/bin/samtools'
bam2fq = '/extraspace/sli/softwares/bin/bamToFastq'
unmap2anch = '/extraspace/sli/softwares/find_circ/unmapped2anchors.py'
bt2 = '/extraspace/sli/softwares/bin/bowtie2'
bt2_index = '/extraspace/sli/ref/fa/bowtie2_index/gencode_v28'
ref_fa = '/extraspace/sli/ref/fa/gencode_v28_genome.fa'
find_circ = '/extraspace/sli/softwares/find_circ/find_circ.py'
maxlen = '/extraspace/sli/softwares/find_circ/maxlength.py'
bwa = '/extraspace/sli/softwares/bin/bwa'
circ2 ='/extraspace/sli/softwares/Anaconda3/bin/CIRCexplorer2'
circ2_ann_ref = '/extraspace/sli/ref/hg38_ref_Circ2.txt'
ref_gtf = '/extraspace/sli/ref/gtf/gencode_v28_annotation.gtf'
star = '/extraspace/sli/softwares/bin/STAR'
star_index = '/extraspace/sli/ref/fa/star_index'
pstalign='/extraspace/sli/softwares/circRNA_finder/postProcessStarAlignment.pl'
ciri2='/extraspace/sli/softwares/CIRI_v2.0.6/CIRI2.pl'

### Get options
parser = argparse.ArgumentParser()
parser.add_argument("-d","--directory",help="Get working directory",type=str)
options = parser.parse_args()

#------------------
# Main functions
#------------------

### Trim raw reads per sample

def TrimPE(sample):
  dir_wk = options.directory
  fq1 = dir_wk+'/fastq/'+sample+'/'+sample+'_R1.fastq.gz'
  fq2 = dir_wk+'/fastq/'+sample+'/'+sample+'_R2.fastq.gz'
  dir_trim = dir_wk+'/Trim_results/'+sample
  filt_r1 = dir_trim+'/'+sample+'_filtered_R1.fastq.gz'
  unp_r1 = dir_trim+'/'+sample+'_unpaired_R1.fastq.gz'
  filt_r2 = dir_trim+'/'+sample+'_filtered_R2.fastq.gz'
  unp_r2 = dir_trim+'/'+sample+'_unpaired_R2.fastq.gz'
  cmd_mk = 'mkdir -p '+dir_trim
  os.system(cmd_mk)
  cmd_trimpe = 'java -jar '+trim+' PE '+fq1+' '+fq2+' '+filt_r1+' '+unp_r1+' '+filt_r2+' '+unp_r2+' \
          ILLUMINACLIP:'+adapter+':2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> \
          '+dir_trim+'/read_surviving_stat.txt'
  os.system(cmd_trimpe)      

def TrimSE(sample):
  dir_wk = options.directory
  fq = dir_wk+'/fastq/'+sample+'/'+sample+'.fastq.gz'
  dir_trim = dir_wk+'/Trim_results/'+sample
  filt = dir_trim+'/'+sample+'_filtered.fastq.gz'
  unp = dir_trim+'/'+sample+'_unpaired.fastq.gz'
  cmd_mk = 'mkdir -p '+dir_trim
  os.system(cmd_mk)
  cmd_trimse = 'java -jar '+trim+' SE '+fq+' '+filt+' '+unp+' \
          ILLUMINACLIP:'+adapter+':2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 2> \
          '+dir_trim+'/read_surviving_stat.txt'
  os.system(cmd_trimse)      

def Run_Trim(sample):
  dir_wk = options.directory
  fq1 = dir_wk+'/fastq/'+sample+'/'+sample+'_R1.fastq.gz'
  fq2 = dir_wk+'/fastq/'+sample+'/'+sample+'_R2.fastq.gz'
  fq = dir_wk+'/fastq/'+sample+'/'+sample+'.fastq.gz'
  file_trim_run = dir_wk+'/Trim_results/'+sample+'/'+sample+'.run'
  cmd_touch1 = 'touch '+file_trim_run
  if (os.path.isfile(fq1)) and (os.path.isfile(fq2)):
    os.system(cmd_touch1)
    TrimPE(sample)
  if os.path.isfile(fq):
    os.system(cmd_touch1)
    TrimSE(sample)
  file_trim_done = dir_wk+'/Trim_results/'+sample+'/'+sample+'.done'
  cmd_touch2 = 'touch '+file_trim_done
  os.system(cmd_touch2)

### Align reads per sample
def AlignPE(sample):
  dir_wk = options.directory
  dir_trim = dir_wk+'/Trim_results/'+sample
  dir_aln = dir_wk+'/Alignment_ht2/'+sample
  fq1 = dir_trim+'/'+sample+'_filtered_R1.fastq.gz'
  fq2 = dir_trim+'/'+sample+'_filtered_R2.fastq.gz'
  out_sam = dir_aln+'/'+sample+'_alignment.sam'
  cmd_mk = 'mkdir -p '+dir_aln
  os.system(cmd_mk)
  cmd_ht2 = ht2+' -x '+ht2_index+' -1 '+fq1+' -2 '+fq2+' -S '+out_sam
  out_bam = dir_aln+'/'+sample+'_alignment.bam'
  cmd_sam2bam = sambamba+' view '+out_sam+' -S -f bam -o '+out_bam
  out_unmap = dir_aln+'/'+sample+'_unmapped.bam'
  cmd_unmap = samtools+' view -b -hf 4 '+out_bam+' > '+out_unmap
  os.system(cmd_unmap)
  unmap_fq = dir_aln+'/'+sample+'_unmapped.fastq'
  cmd_unmapfq = bam2fq+' -i '+out_unmap+' -fq '+unmap_fq
  os.system(cmd_unmapfq)
  file_stat = dir_aln'/'+sample+'_alignment.stat'
  cmd_flag = samtools+' flagstat '+out_bam+' > '+file_stat
  os.system(cmd_flag)
  out_sortbam = dir_aln+'/'+sample+'_alignment_sorted.bam'
  cmd_bamsort = sambamba+' sort -o '+out_sortbam+' --tmpdir '+dir_aln+' -t 5 '+out_bam
  os.system(cmd_bamsort)
  cmd_rmsam = 'rm -f '+out_sam
  os.system(cmd_rmsam)
  cmd_rmbam = 'rm -f '+out_bam
  os.system(cmd_rmbam)
  
def AlignSE(sample):
  dir_wk = options.directory
  dir_trim = dir_wk+'/Trim_results/'+sample
  dir_aln = dir_wk+'/Alignment_ht2/'+sample
  fq = dir_trim+'/'+sample+'_filtered.fastq.gz'
  out_sam = dir_aln+'/'+sample+'_alignment.sam'
  cmd_mk = 'mkdir -p '+dir_aln
  os.system(cmd_mk)
  cmd_ht2 = ht2+' -x '+ht2_index+' -U '+fq+' -S '+out_sam
  out_bam = dir_aln+'/'+sample+'_alignment.bam'
  cmd_sam2bam = sambamba+' view '+out_sam+' -S -f bam -o '+out_bam
  out_unmap = dir_aln+'/'+sample+'_unmapped.bam'
  cmd_unmap = samtools+' view -b -hf 4 '+out_bam+' > '+out_unmap
  os.system(cmd_unmap)
  unmap_fq = dir_aln+'/'+sample+'_unmapped.fastq'
  cmd_unmapfq = bam2fq+' -i '+out_unmap+' -fq '+unmap_fq
  os.system(cmd_unmapfq)
  file_stat = dir_aln'/'+sample+'_alignment.stat'
  cmd_flag = samtools+' flagstat '+out_bam+' > '+file_stat
  os.system(cmd_flag)
  out_sortbam = dir_aln+'/'+sample+'_alignment_sorted.bam'
  cmd_bamsort = sambamba+' sort -o '+out_sortbam+' --tmpdir '+dir_aln+' -t 5 '+out_bam
  os.system(cmd_bamsort)
  cmd_rmsam = 'rm -f '+out_sam
  os.system(cmd_rmsam)
  cmd_rmbam = 'rm -f '+out_bam
  os.system(cmd_rmbam)

def Run_Align(sample):
  dir_wk = options.directory
  file_align_run = dir_wk+'/Alignment_ht2/'+sample+'/'+sample+'.run'
  cmd_touch1 = 'touch '+file_align_run
  dir_trim = dir_wk+'/Trim_results/'+sample
  dir_aln = dir_wk+'/Alignment_ht2/'+sample
  fq1 = dir_trim+'/'+sample+'_filtered_R1.fastq.gz'
  fq2 = dir_trim+'/'+sample+'_filtered_R2.fastq.gz'
  fq = dir_trim+'/'+sample+'_filtered.fastq.gz'
  if (os.path.isfile(fq1)) and (os.path.isfile(fq2)):
    os.system(cmd_touch1)
    AlignPE(sample)
  if os.path.isfile(fq):
    os.system(cmd_touch1)
    AlignSE(sample)
  file_align_done = dir_wk+'/Alignment_ht2/'+sample+'/'+sample+'.done'
  cmd_touch2 = 'touch '+file_align_done
  os.system(cmd_touch2)
 
### Call circRNAs using find_circ
def Run_FindCirc(sample):
  dir_wk = options.directory
  dir_aln = dir_wk+'/Alignment_ht2/'+sample
  dir_findcirc = dir_wk+'/circRNA/FindCirc/'+sample
  cmd_mk = 'mkdir -p '+dir_findcirc
  os.system(cmd_mk)
  file_findcirc_run = dir_findcirc+'/'+sample+'.run'
  cmd_touch1 = 'touch '+file_findcirc_run
  os.system(cmd_touch1)
  unmap_bam = dir_aln+'/'+sample+'_unmapped.bam'
  unmap_fq = dir_aln+'/'+sample'_unmapped.fastq'
  unmap_anchor = ${dir_findcirc}/${sample}/${sample}'_unmapped_anchor.fastq'
  cmd_anchor = 'python '+unmap2anch+' '+unmap_bam+' > '+unmap_anchor
  os.system(cmd_anchor)
  findcirc_log = dir_findcirc+'/'+sample'.log'
  findcirc_bed = ${dir_findcirc}/${sample}/${sample}'.bed'
  findcirc_read = ${dir_findcirc}/${sample}/${sample}'.reads'
  findcirc_final = ${dir_findcirc}/${sample}/${sample}'_final.bed'
  cmd_bt2 = bt2+' -p 5 --reorder --quiet --mm --score-min=C,-15,0 -q -x '+bt2_index+' -U '+unmap_anchor+' | \
  python'+ find_circ+' -G '+ref_fa+' -p find_circ -s '+findcirc_read+' > '+findcirc_bed+' 2> '+findcirc_log
  os.system(cmd_bt2)
  cmd_filter1 = 'grep CIRCULAR '+findcirc_bed+' | grep -v chrM | awk \'$5>=2\' | grep UNAMBIGUOUS_BP | grep ANCHOR_UNIQUE | \
  python '+maxlen+' 100000 > '+findcirc_final
  os.system(cmd_filter1)
  file_findcirc_done = dir_findcirc+'/'+sample+'.done'
  cmd_touch2 = 'touch '+file_findcirc_done
  os.system(cmd_touch2)

### Call circRNAs using Circexplorer2
def Run_Circ(sample):
  dir_wk = options.directory
  dir_align = dir_wk+'/alignment_ht2/'+sample
  dir_circ = dir_wk+'/circRNA/Circ/'+sample
  cmd_mk = 'mkdir -p '+dir_circ
  os.system(cmd_mk)
  file_circ_run = dir_circ+'/'+sample+'.run'
  cmd_touch1 = 'touch '+file_circ_run
  os.system(cmd_touch1)
  unmap_fq = dir_align+'/'+sample+'_unmapped.fastq'
  unmap_bwa_sam = dir_circ+'/'+sample+'_unmapped_bwa.sam'
  cmd_bwa = bwa+' mem -t 5 -T 19 '+ref_fa+' '+unmap_fq+' > '+unmap_bwa_sam+' 2> '+dir_circ+'/'+sample'_bwa.log'
  os.system(cmd_bwa)
  unmap_bwa_sam=dir_circ+'/'+sample+'_unmapped_bwa.sam'
  cmd_circ2 = circ2+' parse -t BWA -b '+dir_circ+'/'+sample+'_circ2_result.txt '+unmap_bwa_sam+' > \
  '+dir_circ+'/'+sample+'_test.parse.log'
  os.system(cmd_circ2)
  cmd_circ2_ann = circ2+' annotate -r '+circ2_ann_ref+' -g '+ref_fa+' -b '+dir_circ+'/'+sample+'_circ2_result.txt\
   -o '+dir_circ+'/'+sample+'_circ2_result_ann.circ2'
   os.system(cmd_circ2_ann)
   file_circ_done = dir_circ+'/'+sample+'.done'
   cmd_touch2 = 'touch '+file_circ_done
   os.system(cmd_touch2)

### Call circRNAs using circ_finder
def Run_CircFinder(sample):
  dir_wk = options.directory
  dir_align = dir_wk+'/alignment_ht2/'+sample
  dir_circ = dir_wk+'/circRNA/Circ/'+sample
  dir_circfinder = dir_wk+'/circRNA/CircFinder/'+sample
  cmd_mk = 'mkdir -p '+dir_circfinder
  os.system(cmd_mk)
  file_circfinder_run = dir_circfinder+'/'+sample+'.run'
  cmd_touch1 = 'touch '+file_circfinder_run
  os.system(cmd_touch1)
  unmap_fq = dir_align+'/'+sample+'_unmapped.fastq'
  cmd_star = star+' --genomeDir '+star_index+' --readFilesIn '+unmap_fq+' --runThreadN 5 --chimSegmentMin 20 --chimScoreMin 1 --alignIntronMax 100000 \
  --chimOutType Junctions SeparateSAMold --outFilterMismatchNmax 4 --alignTranscriptsPerReadNmax 100000 --outFilterMultimapNmax 2 --outFileNamePrefix '+dir_circfinder+'/'+sample
  cmd_cd = 'cd '+dir_circfinder
  os.system(cmd_cd)
  cmd_pstaln = 'perl '+pstalign+' '+dir_circfinder+' '+dir_circfinder
  os.system(cmd_pstaln)
  file_circfinder_done = dir_circfinder+'/'+sample+'.done'
  cmd_touch2 = 'touch '+file_circfinder_done
  os.system(cmd_touch2)

### Call circRNAs using CIRI2
def Run_Ciri(sample):
  dir_wk = options.directory
  dir_align = dir_wk+'/alignment_ht2/'+sample
  dir_circ = dir_wk+'/circRNA/Circ/'+sample
  dir_ciri = dir_wk+'/circRNA/Ciri/'+sample
  cmd_mk = 'mkdir -p '+dir_ciri
  os.system(cmd_mk)
  file_ciri_run = dir_ciri+'/'+sample+'.run'
  cmd_touch1 = 'touch '+file_ciri_run
  os.system(cmd_touch1)
  unmap_bwa_sam = dir_circ+'/'+sample'_unmapped_bwa.sam'
  ciri_out = dir_ciri+'/'+sample+'_circrna.ciri'
  cmd_ciri2 = 'perl '+ciri2+' -T 6 -I '+unmap_bwa_sam+' -O '+ciri_out+' -F '+ref_fa+' -A '+ref_gtf+' -G '+dir_ciri+'/'+sample+'_ciri.log'
  os.system(cmd_ciri2)
  file_ciri_done = dir_ciri+'/'+sample+'.done'
  cmd_touch2 = 'touch '+file_ciri_done
  os.system(cmd_touch2)

#---------------------
# System Operations
#---------------------
def GetSamples():
  samples = []
  samples = os.listdir(dir_wk+'/fastq')
  return samples

def SystemStatus():
  Status = []
  perc_cpu = psutil.cpu_percent()
  perc_mem = psutil.virtual_memory()
  Status.append(perc_cpu)
  Status.append(perc_mem[2])
  return Status

def InCompleteNum():
  number1 = 0
  for s in list_samples:
    file_done_trim = dir_wk+'/Trim_results/'+s+'/'+s+'.done'
    file_done_align = dir_wk+'/alignment_ht2/'+s+'/'+s+'.done'
    file_done_findcirc = dir_wk+'/circRNA/FindCirc/'+s+'/'+s+'.done'
    file_done_circ = dir_wk+'/circRNA/Circ/'+s+'/'+s+'.done'
    file_done_circfinder = dir_wk+'/circRNA/CircFinder/'+s+'/'+s+'.done'
    file_done_ciri = dir_wk+'/circRNA/Ciri/'+s+'/'+s+'.done'
    files_done = [file_done_trim,file_done_align,file_done_findcirc,file_done_circ,file_done_circfinder,file_done_ciri]
    s_done = 1
    for f in files_done:
      if not os.path.isfile(f):
        s_done = 0
        break
    if s_done == 0:
      number1 += 1
  return number1

def SubmitRun():
  dir_wk = options.directory
  InCmpNum = InCompleteNum()
  while int(InCmpNum) > 0:
    status = SystemStatus()
    while float(status[0]) < 80 and float(status[1]) < 80:
      for s in list_samples:
        file_run_trim = dir_wk+'/Trim_results/'+s+'/'+s+'.run'
        file_done_trim = dir_wk+'/Trim_results/'+s+'/'+s+'.done'
        file_run_align = dir_wk+'/alignment_ht2/'+s+'/'+s+'.run'
        file_done_align = dir_wk+'/alignment_ht2/'+s+'/'+s+'.done'
        file_run_findcirc = dir_wk+'/circRNA/FindCirc/'+s+'/'+s+'.run'
        file_run_circ = dir_wk+'/circRNA/Circ/'+s+'/'+s+'.run'
        file_run_circfinder = dir_wk+'/circRNA/CircFinder/'+s+'/'+s+'.run'
        file_run_ciri = dir_wk+'/circRNA/Ciri/'+s+'/'+s+'.run'
        if not os.path.isfile(file_run_trim):
          Run_Trim(s)
          break
        elsif (os.path.isfile(file_done_trim)) and (not os.path.isfile(file_run_align)):
          Run_align(s)
          break
        elsif (os.path.isfile(file_done_align)) and (not os.path.isfile(file_run_findcirc)):
          Run_FindCirc(s)
          break
        elsif (os.path.isfile(file_done_align)) and (not os.path.isfile(file_run_circ)):
          Run_Circ(s)
          break
        elsif (os.path.isfile(file_done_align)) and (not os.path.isfile(file_run_circfinder)):
          Run_CircFinder(s)
          break
        elsif (os.path.isfile(file_done_align)) and (not os.path.isfile(file_run_ciri)):
          Run_Ciri(s)
          break
        else:
          continue
      time.sleep(10)
      status = SystemStatus()
    print('System is full,waiting...')
    time.sleep(300)
    InCmpNum = InCompleteNum()

#---------------------
# Run
#---------------------

list_samples = GetSamples()
SubmitRun()
