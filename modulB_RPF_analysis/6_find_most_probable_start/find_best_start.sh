#! /bin/bash
# call script
# bash find_best_start.sh RPF_validated.bed RFP_calibrated.bed
# call using example data
# bash modulB_RPF_analysis/6_find_most_probable_start/find_best_start.sh modulB_RPF_analysis/4_count_RPF/output/RPF_translated.txt example_data/RPF_calibrated.bam

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# get bed for translated candidates
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' $1 > "${script_path}/output/RPF_translated.bed"
# generate RPF counts per nucleotide for validated candidates 
# ! this will possibly create a very huge results file
coverageBed -s -d -a "${script_path}/output/RPF_translated.bed" -b $2 > "${script_path}/output/RPF_translated_per_nt.txt"

# get FT candidates
Rscript --vanilla "${script_path}/find_best_start.R" $1 "${script_path}/output/RPF_translated_per_nt.txt" ${script_path}

