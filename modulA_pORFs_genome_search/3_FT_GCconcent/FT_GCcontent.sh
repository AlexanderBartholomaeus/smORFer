#!/bin/bash
### script to get ORFs with 3-nt sequence peridicity
# call: 
# bash FT_GCcontent.sh fasta.fa orfs.bed
# call using example data: 
# bash modulA_pORFs_genome_search/3_FT_GCcontent/FC_GCcontent.sh example_data/ecoli_100k_nt.fa modulA_pORFs_genome_search/1_pORF/output/pORFs.bed

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# get FT candidates
Rscript --vanilla FT_GCcontent.R $1 $2
