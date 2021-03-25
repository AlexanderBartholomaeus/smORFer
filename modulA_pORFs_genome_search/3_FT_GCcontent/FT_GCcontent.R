# load library
library(seqinr)
library(Biostrings)

# get parameters
get_param <- commandArgs(trailingOnly = TRUE)

# load genome (FASTA)
genome <- read.fasta(get_param[1])
# load genes/ORFs/pORFs (BED) 
genes <- read.table(get_param[2], sep = "\t", stringsAsFactors = F, header = F)

# cutoff for selection of candidates: (FT at period 3) / (FT between 1.5 and 3) 
cutoff <- 3

## function for fourier transform input counts
# counts: input count
# it will only take a vector which is of length 3 of dividable by 3, others are skipped
# output(in default mode): 4 values (FT at 1.5, FT at 3, mean of FT between 1.5 and 3, mean > 3) 
# normalze: per default it normalizes the transformed values by length (which we have to do)
# full_output: if TRUE will output list with all data, e.g. to plot 
get_FT_signal = function(counts, normalize = T, full_output = F){
  # check if length diviable by 3
  if( length(counts)%%3 == 0){
    # get frequency (x-axis) for FT transform
    # this is a bit complicated to explain and understand (we can try later)
    freq <- length(counts)/(0:(length(counts)-1))
    # perform fast FT
    ft <- abs(fft(counts))
    # normalize by length
    if(normalize){
      ft <- ft / length(counts)
    }
    # get identity of period 3 and 1.5 together with mean of inter-regions
    idx3 <- which(freq == 3)
    idx15 <- which(freq == 1.5)
    res <- c(
      ft[idx15],
      ft[idx3],
      mean(ft[(idx3+1):(idx15-1)]),
      mean(ft[(idx15+1):(length(ft))])
    )
    # return
    if(!full_output){
      res
    } else {
      list(
        res = res,
        ft = ft,
        freq = freq
      )
    }
    
    # else skip with message
  } else {
    cat('skipped\n')
    NULL
  }
}

##### caluclate FT for GC content for all genes

# matrix to store FT values
storeFT <- matrix(NA, nrow=nrow(genes),ncol=4)
# run for all genes
for(i in 1:nrow(genes)){
  # status print
  #print(i)
  # check if dividable by 3
  if((genes[i,3]-genes[i,2])%%3 == 0){
    # get nucleotide sequence
    g <- genome[[1]][(genes[i,2]+1):genes[i,3]]
    # if on minus strand do reverse complement to get real sequence
    if(genes[i,6]=='-'){
      # I know this is a bit hacky
      g <- unlist(
        strsplit(
          as.character(
            reverseComplement(
              DNAString(paste(g,collapse=''))
            )
          )
          ,''
        )
      )
    }
    # make 1 for G/C and 0 for other nucleotides
    g_gc <- as.numeric(is.element(g,c('g','c','G','C')))
    # get frequency (x-axis) for FT transform
    # this is a bit complicated to explain and understand (we can try later)
    ft <- get_FT_signal(g_gc)
    # store
    storeFT[i,1:4] <- ft
  } else {
    # if not dividable by 3 print skipped
    print('skipped')
  }
}
# select candidates with high FT at period 3
idx <- which(storeFT[,2]/storeFT[,3] > cutoff) # this is the genes we would be interested

# write candidates
write.table(genes[idx,],paste0(get_param[3],'/output/FT_passed.bed'), sep = "\t", col.names = F, row.names = F, quote = F)

