#!/bin/bash
# script to run the full module A
# call:
# bash run_moduleA.sh fasta.fa genome_name out_name min_ORF_length max_ORF_length regions_to_select.bed out_name2
# call using example data: 
# bash modulA_pORFs_genome_search/run_moduleA.sh example_data/ecoli_100k_nt.fa U00096 pORFs 9 150  example_data/ecoli_genes.bed pORFs_filtered


### Step4
# get script path
script_path=$(dirname "$0")
script_path="${script_path}/4_count_RPF"

# create output folder
mkdir -p "${script_path}/output"

# count per gene / pORF
coverageBed -s -a $1 -b $2 > "${script_path}/output/RPF_counts.txt"

# get candidates > 5 RPF (validated)
awk '$7 >= 5' "${script_path}/output/RPF_counts.txt" > "${script_path}/output/RPF_translated.txt"

# get candidates > 100 RPK (100 RPK = 1 RPF per 10 nt length = 0.1)
awk '$7/$9 >= 0.1 {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' "${script_path}/output/RPF_counts.txt" > "${script_path}/output/RPF_high.bed"


### Step5
# get script path
script_path=$(dirname "$0")
script_path="${script_path}/5_FT_RPF"

# create output folder
mkdir -p "${script_path}/output"

# count per nucleotide
coverageBed -s -d -a "modulB_RPF_analysis/4_count_RPF/output/RPF_high.bed" -b $3 > "${script_path}/output/RPF_candidates_perNT.txt"

# get FT candidates
Rscript --vanilla FT_on_RPF.R "${script_path}/output/RPF_candidates_perNT.txt"
