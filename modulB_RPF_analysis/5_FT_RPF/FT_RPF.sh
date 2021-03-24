#! /bin/bash
### script to count calibrated Ribo-Seq reads and perform Fourier Transform signal analysis

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# count per nucleotide
coverageBed -s -d -a $1 -b $2 > "${script_path}/output/RPF_candidates_perNT.txt"

# get FT candidates
Rscript --vanilla FT_on_RPF.R "${script_path}/output/RPF_candidates_perNT.txt"
