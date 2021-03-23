#! /bin/bash


# get script path
script_path=$(dirname "$0")

# create output folder
mkdir -p "${script_path}/output"

# count per gene / pORF
coverageBed -s -a ../../moduleA_oORFs_genome_search/2_regions_selection/output/porf_nonAnnotatedRegions.bed -b ../../bam_files/RPF_ecoli_mid.bam > RPF_counts.txt

# get candidates > 5 RPF (validated)
awk '$7 >= 5' output/RPF_noncds.txt > output/RPF_translated.txt

# get candidates > 1 RPK (1 RPF per 10 nt length)
awk '$7/$9 >= 0.1 {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' output/RPF_noncds.txt > output/RPF_high.bed

# count per nucleotide
coverageBed -s -d -a output/RPF_high.bed -b ../../bam_files/RPF_ecoli_mid.bam > output/RPF_candidates_perNT.txt


# get FT candidates
Rscript --vanilla FT_on_RPF.R ../4_count_RPF/output/RPF_candidates_perNT.txt

