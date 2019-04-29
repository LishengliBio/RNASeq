#!/bin/bash

wk_dir='/extraspace/sli/softwares'

# add python lib to system path
mkdir -p /extraspace/sli/Python_workspace/lib
vi /home/sli/.bash_profile
#insert  export PYTHONPATH=$PYTHONPATH:/extraspace/sli/Python_workspace/lib/lib64/python2.7/site-packages
source .bash_profile

mkdir -p /extraspace/sli/softwares/bin

vi /home/sli/.bash_profile
#insert export PATH=$PATH:/extraspace/sli/softwares/bin
source .bash_profile

### Downlaod and install pre-required softwares and reference

## hisat2
cd /extraspace/sli/softwares
wget http://ccb.jhu.edu/software/hisat2/dl/hisat2-2.1.0-Linux_x86_64.zip
unzip hisat2-2.1.0-Linux_x86_64.zip
rm -f hisat2-2.1.0-Linux_x86_64.zip
cd hisat2-2.1.0-Linux_x86_64
cp hisat2* ../bin

## bowtie2
cd /extraspace/sli/softwares
wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.2/bowtie2-2.3.4.2-linux-x86_64.zip
unzip bowtie2-2.3.4.2-linux-x86_64.zip
rm -f bowtie2-2.3.4.2-linux-x86_64.zip
cd bowtie2-2.3.4.2-linux-x86_64
cp bowti2* ../bin

## STAR
cd /extraspace/sli/softwares
git clone https://github.com/alexdobin/STAR.git
cp /extraspace/sli/softwares/STAR/bin/Linux_x86_64/STAR /extraspace/sli/softwares/bin


## prepare reference files
cd /extraspace/sli/ref/fa
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/GRCh38.primary_assembly.genome.fa.gz
gunzip GRCh38.primary_assembly.genome.fa.gz
mv GRCh38.primary_assembly.genome.fa gencode_v28_genome.fa
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/gencode.v28.annotation.gtf.gz
gunzip gencode.v28.annotation.gtf.gz
mv gencode.v28.annotation.gtf gencode_v28_annotation.gtf

fa='/extraspace/sli/ref/fa/gencode_v28_genome.fa'
gtf='/extraspace/sli/ref/gtf/gencode_v28_annotation.gtf'

# build hisat2 index
ht2_build='/extraspace/sli/softwares/bin/hisat2-build'
mkdir -p /extraspace/sli/ref/fa/hisat2_index
cd /extraspace/sli/ref/fa/hisat2_index
nohup ${ht2_build} -p 8 ${fa} gencode_v28 &

# build bowtie2 index
bw_build='/extraspace/sli/softwares/bin/bowtie2-build'
mkdir -p bowtie2_index
cd ./bowtie2_index
nohup ${bw_build} ${fa} gencode_v28 --threads 8 &

# build bwa index
bwa='/extraspace/sli/softwares/bin/bwa'
mkdir -p /extraspace/sli/ref/fa/bwa_index
cd /extraspace/sli/ref/fa/bwa_index
nohup ${bwa} index ${fa} &

# build STAR index
star='/extraspace/sli/softwares/bin/STAR'
gdir='/extraspace/sli/ref/fa/star_index'
nohup ${star} --runThreadN 20 --runMode genomeGenerate --genomeDir ${gdir} --genomeFastaFiles ${fa} --sjdbGTFfile ${gtf} &

### prepare circRNA tools
## find_circ
# download find_circ
cd ${wk_dir}
git clone https://github.com/marvin-jens/find_circ.git
# prerequisites
py_dir='/extraspace/sli/Python_workspace/lib'
pip install --install-option="--prefix=${py_dir}" pysam
# test find_circ
cd /extraspace/sli/softwares/find_circ
cd test_data
make

### circexplorer2
cd /extraspace/sli/softwares
# py_dir='/extraspace/sli/Python_workspace/lib'
# git clone https://github.com/YangLab/CIRCexplorer2.git
# cd CIRCexplorer2
# pip install --install-option="--prefix=${py_dir}" pybedtools
# pip install --install-option="--prefix=${py_dir}" docopt

wget https://repo.anaconda.com/archive/Anaconda2-5.2.0-Linux-x86_64.sh
chmod +x Anaconda2-5.2.0-Linux-x86_64.sh
bash ./Anaconda2-5.2.0-Linux-x86_64.sh -p /extraspace/sli/softwares/anaconda2
pip install circexplorer2

### circRNA_finder
cd /extraspace/sli/softwares
git clone https://github.com/orzechoj/circRNA_finder.git

### ciri2
cd /extraspace/sli/softwares
wget https://iweb.dl.sourceforge.net/project/ciri/CIRI2/CIRI_v2.0.6.zip
unzip CIRI_v2.0.6.zip
cd CIRI_v2.0.6
chmod +x CIRI2.pl
