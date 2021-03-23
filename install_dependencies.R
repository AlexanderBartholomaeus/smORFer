### R script to install R dependencies

# recommended R versions

### install CRAN package
install.packages('seqinr')

### install Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("Biostrings", ask = FALSE, update = FALSE)

# print status
cat('Installation of R dependencies - DONE')
