#!/bin/bash
# script to run the full module A
# call script
# bash run_moduleB.sh pORFs.bed RPF.bam RPF_calibrated.bam
# call with example data
# bash modulB_RPF_analysis/run_moduleB.sh modulA_pORFs_genome_search/2_region_selection/output/pORFs_filtered.bed example_data/RPF.bam example_data/RPF_calibrated.bam


### Step4
# get script path
script_path=$(dirname "$0")
script_path1="${script_path}/4_count_RPF"

# create output folder
mkdir -p "${script_path1}/output"

# count per gene / pORF
coverageBed -s -a $1 -b $2 > "${script_path1}/output/RPF_counts.txt"

# get candidates > 5 RPF (validated)
awk '$7 >= 5' "${script_path1}/output/RPF_counts.txt" > "${script_path1}/output/RPF_translated.txt"

# get candidates > 100 RPK (100 RPK = 1 RPF per 10 nt length = 0.1)
awk '$7/$9 >= 0.1 {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' "${script_path1}/output/RPF_counts.txt" > "${script_path1}/output/RPF_high.bed"



### Step5
# get script path
script_path2="${script_path}/5_FT_RPF"

# create output folder
mkdir -p "${script_path2}/output"

# count per nucleotide
coverageBed -s -d -a "${script_path1}/output/RPF_high.bed" -b $3 > "${script_path2}/output/RPF_candidates_perNT.txt"

# get FT candidates
Rscript --vanilla "${script_path2}/FT_RPF.R" "${script_path2}/output/RPF_candidates_perNT.txt" ${script_path2}

