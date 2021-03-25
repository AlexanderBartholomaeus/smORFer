#!/bin/bash
### script to count Ribo-Seq read for pORFs and extract high expressed candidates
# call script 
# bash count_RPF.sh pORFs.bed RiboSeq.bam 
# call using example data
# bash modulB_RPF_analysis/4_count_RPF/count_RPF.sh modulA_pORFs_genome_search/2_region_selection/output/pORFs_filtered.bed example_data/RPF.bam 

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# count per gene / pORF
coverageBed -s -a $1 -b $2 > "${script_path}/output/RPF_counts.txt"

# get candidates > 5 RPF (validated)
awk '$7 >= 5' "${script_path}/output/RPF_counts.txt" > "${script_path}/output/RPF_translated.txt"

# get candidates > 100 RPK (100 RPK = 1 RPF per 10 nt length = 0.1)
awk '$7/$9 >= 0.1 {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' "${script_path}/output/RPF_counts.txt" > "${script_path}/output/RPF_high.bed"

