
# get parameters
get_param <- commandArgs(trailingOnly = TRUE)

# get pORFs
porfs <- read.table(get_param[1], sep = "\t", header = F, stringsAsFactors = F)
porf_plus <- porfs[porfs[,6] == '+',]
porf_minus <- porfs[porfs[,6] == '-',]

# read RPF counts per nucleotide
rpf <- read.table(get_param[2], sep = "\t", header = T, stringsAsFactors = F)

# find unique stops
stops_plus <- unique(porf_plus[,c(1,3)])
stops_minus <- unique(porf_minus[,c(1,2)])

# store candidates
store_all <- data.frame(matrix(NA, nrow = 0, ncol = 8))
store_best <- data.frame(matrix(NA, nrow = 0, ncol = 6))

# for each stop select the most probable candidate (plus)
for(i in 1:nrow(stops_plus)){
  # select all starts
  rpf_select <- rpf[rpf[,1]==stops_plus[i,1] & rpf[,3]==stops_plus[i,2],]
  # check if more than one
  u_rpf <- unique(rpf_select[,1:6])
  
  # get best and store
  if(nrow(u_rpf)==1){
    # store the only one
    store_best[nrow(store_best)+1,] <- u_rpf[1,]
    store_all[nrow(store_all)+1,] <- u_rpf[1,]
  } else {
    # for each get var and first/second half
    res <- sapply(1:nrow(u_rpf),function(j){
      # get counts
      rpf_sel <- rpf_select[rpf_select[,1]==u_rpf[j,1] & rpf_select[,2]==u_rpf[j,2],]
      # find mid
      half <- round(nrow(rpf)/2, digits=0)
      
      # return
      c(
        var(rpf_sel),
        (sum(rpf_sel[1:half,8])+1)/(sum(rpf_sel[(half+1):nrow(rpf_sel),8])+1) # add +1 to avoid division by 0
      )
    })
    # store
    store_best[nrow(store_best)+1,] <- u_rpf[which(res[,1]==max(res[,1]))[1],]
    store_all[nrow(store_all)+nrow(u_rpf),] <- cbind(u_rpf,res)
  }
}
# for each stop select the most probable candidate (minus)
for(i in 1:nrow(stops_minus)){
  # select all starts
  rpf_select <- rpf[rpf[,1]==stops_minus[i,1] & rpf[,2]==stops_minus[i,2],]
  # check if more than one
  u_rpf <- unique(rpf_select[,1:6])
  
  # get best and store
  if(nrow(u_rpf)==1){
    # store the only one
    store_best[nrow(store_best)+1,] <- u_rpf[1,]
    store_all[nrow(store_all)+1,] <- u_rpf[1,]
  } else {
    # for each get var and first/second half
    res <- sapply(1:nrow(u_rpf),function(j){
      # get counts
      rpf_sel <- rpf_select[rpf_select[,1]==u_rpf[j,1] & rpf_select[,3]==u_rpf[j,3],]
      # find mid
      half <- round(nrow(rpf)/2, digits=0)
      
      # return
      c(
        var(rpf_sel),
        (sum(rpf_sel[(half+1):nrow(rpf_sel),8])+1)/(sum(rpf_sel[1:half,8])+1) # add +1 to avoid division by 0 (to get 1. half turned around)
      )
    })
    # store
    store_best[nrow(store_best)+1,] <- u_rpf[which(res[,1]==max(res[,1]))[1],]
    store_all[nrow(store_all)+nrow(u_rpf),] <- cbind(u_rpf,res)
  }
}
