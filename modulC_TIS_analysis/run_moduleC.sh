#!/bin/bash
# script to run the full module C

### Step7
# get script path
script_path=$(dirname "$0")
script_path="${script_path}/7_get_start_codon"

# create output folder
mkdir -p "${script_path}/output"

# get FT candidates
Rscript --vanilla get_start_codon.R $1


### Step8
# get script path
script_path=$(dirname "$0")
script_path="${script_path}/8_count_TIS"

# create output folder
mkdir -p "${script_path}/output"

# count per start counts for pORF
coverageBed -s -a "modulC_TIS_analysis/7_get_start_codon/output/TIS_start_codon.bed" -b $2 > "${script_path}/output/TIS_counts.txt"

awk '$7 >= 5' "${script_path}/output/TIS_counts.txt" > "${script_path}/output/TIS_candidates.txt"
