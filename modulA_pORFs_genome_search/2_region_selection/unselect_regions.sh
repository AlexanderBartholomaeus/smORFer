#!/bin/bash
### script to select putative ORF outside ofgiven regions of interest
# call script 
#bash unselect_regions.sh regions_to_unselect.bed putative_orfs.bed out_name
# call using example data
#bash modulA_pORFs_genome_search/2_region_selection/unselect_regions.sh example_data/ecoli_genes.bed modulA_pORFs_genome_search/1_pORF/output/pORFs.bed pORFs_filtered


# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# get pORFs in non-annotated regions
intersectBed -s -v -b $1 -a "${script_path}/output/${2}.bed" > "${script_path}/output/${2}_filtered.bed"
