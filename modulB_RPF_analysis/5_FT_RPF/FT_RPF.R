# load library
library(seqinr)
library(Biostrings)

# get parameters
get_param <- commandArgs(trailingOnly = TRUE)

# read RPF counts per nucleotide
rpf <- read.table(get_param[1], sep = "\t", header = F, stringsAsFactors = F)
# get genes
u_genes <- unique(rpf[,1:6])

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


### calculate FT for RPFs

# store FT results
storeFT <- matrix(NA, nrow=nrow(u_genes),ncol=4)
# for each unique genes
for(i in 1:nrow(u_genes)){
  # status print status every 100 genes / ORFs
  if(i == 1){
    cat('Start obtaining FT signals\n')
  }
  if(i %% 100 == 0){
    cat(paste0(i, ' genes/ORFs processed \n'))
  }
  # get counts for selected gene only
  rpf_sel <- rpf[rpf[,4]==u_genes[i,4],]
  # check if dividable by 3
  if(nrow(rpf_sel)%%3 == 0){
    # do FT transform (remove 50nt at start and end)
    ft <- get_FT_signal(rpf_sel[,8])
    storeFT[i,1:4] <- ft
  } else {
    # if not dividable by 3 print skipped
    cat(paste0('  ',u_genes[i,4],' skipped\n'))
  } 
}

# select candidates with high FT at period 3
idx <- which(storeFT[,2]/storeFT[,3] > cutoff) # this is the genes we would be interested

# create table
verified <- cbind(u_genes[idx,],round(storeFT[idx,2]/storeFT[idx,3], digits=6))
colnames(verified)[7] <- 'FT_ratio'

# write candidates
write.table(verified,paste0(get_param[2],'/output/RPF_3nt_translated.txt'), sep = "\t", col.names = F, row.names = F, quote = F)

