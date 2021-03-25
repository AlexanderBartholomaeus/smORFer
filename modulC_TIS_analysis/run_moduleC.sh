#!/bin/bash
### Script to run the full module C
# call
# bash run_moduleC.sh pORFs.bed TisSeq.bam
# call using example data
# bash modulC_TIS_analysis/run_moduleC.sh modulA_pORFs_genome_search/2_region_selection/output/pORFs_filtered.bed example_data/TIS.bam

### Step7
# get script path
script_path=$(dirname "$0")
script_path1="${script_path}/7_get_start_codon"

# create output folder
mkdir -p "${script_path1}/output"

# get start codons of ORFs
Rscript --vanilla "${script_path1}/start_codon.R" $1 ${script_path1}


### Step8
# get script path
script_path2="${script_path}/8_count_TIS"

# create output folder
mkdir -p "${script_path2}/output"

# count TIS reads per start counts for pORF
coverageBed -s -a "${script_path1}/output/start_codons.bed" -b $2 > "${script_path2}/output/TIS_counts.txt"

awk '$7 >= 5' "${script_path2}/output/TIS_counts.txt" > "${script_path2}/output/TIS_candidates.txt"

