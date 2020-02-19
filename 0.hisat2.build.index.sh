#!/bin/bash

file_fa='/extraspace/sli/ref/fa/mouse/GRCm38.p6.genome.fa'
file_indx='/extraspace/sli/ref/fa/mouse/hisat2_index/GRCm38.p6'

hisat2-build -p 20 ${file_fa} ${file_indx}
