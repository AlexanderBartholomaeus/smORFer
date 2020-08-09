#!/bin/bash

# count per gene / pORF
coverageBed -s -a ../../moduleA_oORFs_genome_search/2_regions_selection/output/porf_nonAnnotatedRegions.bed -b ../../bam_files/RPF_ecoli_mid.bam > RPF_noncds.txt

# get candidates > 5 RPF (validated)
awk '$7 >= 5' output/RPF_noncds.txt > output/RPF_validated.txt

# get candidates > 1 RPK (1 RPF per 10 nt length)
awk '$7/$9 >= 0.1 {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' output/RPF_noncds.txt > output/RPF_candidates.bed

# count per nucleotide
coverageBed -s -d -a output/RPF_candidates.bed -b ../../bam_files/RPF_ecoli_mid.bam > output/RPF_candidates_perNT.txt

