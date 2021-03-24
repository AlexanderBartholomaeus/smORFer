#!/bin/bash
### script to count TIS-Seq reads 
# call script 
#bash count_TIS.sh start_codons.bed TisSeq.bam 
# call using example data
#bash modulC_TIS_analysis/8_count_TIS/count_TIS.sh modulC_TIS_analysis/7_get_start_codon/output/start_codons.bed example_data/TIS.bam

# count per start counts for pORF
coverageBed -s -a $1 -b $2 > output/TIS_counts.txt

awk '$7 >= 5' output/TIS_counts.txt > output/TIS_candidates.txt

