#!/bin/bash

# get pORFs in non-annotated regions
intersectBed -s -v -b ../../annotation_bed_files/all_genes/ecoli_annotation.bed -a ../1_pORF/output/pORF.bed > output/porf_nonAnnotatedRegions.bed

