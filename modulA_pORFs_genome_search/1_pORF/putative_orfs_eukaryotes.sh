#!/bin/bash
### script to call ORF detection perl script and parse output
# call: bash call_porf_perl_script.sh fasta.fa genome_name out_name min_ORF_length max_ORF_length
# example: bash call_porf_perl_script.sh myFolder/ecoli.fa U00096 pORFs 9 150

# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# predict small putative ORFs from genome including length restriction
perl "${script_path}/porf_bedformat.pl" $1 $2 "${script_path}/output/${3}.txt" "${script_path}/output/${3}.bed" $4 $5

# parse output (remove header)
sed '1d' "${script_path}/output/${3}.bed" > "${script_path}/output/${3}_noHead.bed"
rm "${script_path}/output/${3}.bed"
mv "${script_path}/output/${3}_noHead.bed" "${script_path}/output/${3}.bed"
