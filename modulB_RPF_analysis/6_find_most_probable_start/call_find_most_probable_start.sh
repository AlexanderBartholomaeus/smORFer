#! /bin/bash


# get bed for validted candidates
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6}' RPF_validated.bed
# generate RPF counts per nucleotide for validated candidates 
# ! this will possibly create a very huge results file
coverageBed -s -d -a RPF_validated.bed -b RPF_calibrated.bam > RPF_validated_per_nucleotide.txt

# get FT candidates
Rscript --vanilla find_most_probable_start.R RPF_validated.bed RPF_validated_per_nucleotide.txt
