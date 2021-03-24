#! /bin/bash
### script to extract start codon +- offset from a given BED file
# call script 
#bash start_codon.sh pORFs.bed 
# call using example data
#bash modulC_TIS_analysis/7_get_start_codon/start_codon.sh modulA_pORFs_genome_search/2_region_selection/output/pORFs_filtered.bed

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# get FT candidates
Rscript --vanilla get_start_codon.R $1
