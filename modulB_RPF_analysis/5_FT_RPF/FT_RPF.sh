#! /bin/bash
### script to count calibrated Ribo-Seq reads and perform Fourier Transform signal analysis
# call script 
# bash FT_RPF.sh high_expressed_ORFs.bed calibrated_RiboSeq.bam
# call using example data
# bash modulB_RPF_analysis/5_FT_RPF/FT_RPF.sh modulB_RPF_analysis/4_count_RPF/output/RPF_high.bed example_data/RPF_calibrated.bam

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# count per nucleotide
coverageBed -s -d -a $1 -b $2 > "${script_path}/output/RPF_candidates_perNT.txt"

# get FT candidates
Rscript --vanilla "${script_path}/FT_RPF.R" "${script_path}/output/RPF_candidates_perNT.txt" ${script_path}
