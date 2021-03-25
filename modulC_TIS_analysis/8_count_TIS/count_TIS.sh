#!/bin/bash
### script to count TIS-Seq reads 
# call script 
#bash count_TIS.sh start_codons.bed TisSeq.bam 
# call using example data
#bash modulC_TIS_analysis/8_count_TIS/count_TIS.sh modulC_TIS_analysis/7_get_start_codon/output/start_codons.bed example_data/TIS.bam

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# count per start counts for pORF
coverageBed -s -a $1 -b $2 > "${script_path}/output/TIS_counts.txt"

awk '$7 >= 5' "${script_path}/output/TIS_counts.txt" > "${script_path}/output/TIS_candidates.txt"

