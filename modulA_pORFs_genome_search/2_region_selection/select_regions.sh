#!/bin/bash
### script to reduce putative ORF to a given regions of interest
# call script 
#bash select_regions.sh regions_to_select.bed putative_orfs.bed out_name
# call using example data
#bash modulA_pORFs_genome_search/2_region_selection/select_regions.sh example_data/ecoli_genes.bed modulA_pORFs_genome_search/1_pORF/output/pORFs.bed pORFs_filtered


# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# get pORFs in non-annotated regions
intersectBed -s -b $1 -a "${script_path}/output/${2}.bed" > "${script_path}/output/${2}_filtered.bed"
