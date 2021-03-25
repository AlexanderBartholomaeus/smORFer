#!/bin/bash
# script to run the full module A
# call:
# bash run_moduleA.sh fasta.fa genome_name out_name min_ORF_length max_ORF_length regions_to_select.bed out_name2
# call using example data: 
# bash modulA_pORFs_genome_search/run_moduleA.sh example_data/ecoli_100k_nt.fa U00096.3 pORFs 9 150  example_data/ecoli_genes.bed pORFs_filtered


### Step1
# get script path
script_path=$(dirname "$0")
script_path1="${script_path}/1_pORF"

# create output folder
mkdir -p "${script_path1}/output"

# predict small putative ORFs from genome including length restriction
perl "${script_path1}/porf_bedformat.pl" $1 $2 "${script_path1}/output/${3}.txt" "${script_path1}/output/${3}.bed" $4 $5

# parse output (remove header)
sed '1d' "${script_path1}/output/${3}.bed" > "${script_path1}/output/${3}_noHead.bed"
rm "${script_path1}/output/${3}.bed"
mv "${script_path1}/output/${3}_noHead.bed" "${script_path1}/output/${3}.bed"


### Step2
# get script path
script_path2="${script_path}/2_region_selection"

# create output folder
mkdir -p "${script_path2}/output"

# get pORFs in non-annotated regions
intersectBed -s -v -b $6 -a "${script_path1}/output/${3}.bed" > "${script_path2}/output/${3}_filtered.bed"


### Step3
# get script path
script_path3="${script_path}/3_FT_GCcontent"

# create output folder
mkdir -p "${script_path3}/output"

# get FT candidates
Rscript --vanilla "${script_path3}/FT_GCcontent.R" $1 "${script_path1}/output/${3}.bed" ${script_path3}

