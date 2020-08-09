#!/bin/bash

# count per start counts for pORF
coverageBed -s -a ../7_get_start_codon_only/output/TIS_start_codon_only.bed -b ../../bam_files/TIS_mid_sort.bam > output/TIS_counts.txt

awk '$7 >= 5' output/TIS_counts.txt > output/TIS_candidates.txt

