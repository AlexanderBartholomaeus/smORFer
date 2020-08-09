#!/bin/bash

# predict small putative ORFs from genome including length restriction
perl porf_bedformat.pl ../../annotation_genome_download/ecoli/ecoli_U00096_genome_100k_nt_truncated.fa U00096.3 output/pORFList.txt output/pORF.bed 9 150

sed '1d' output/pORF.bed > output/pORF_noHead.bed
rm output/pORF.bed
mv output/pORF_noHead.bed output/pORF.bed

