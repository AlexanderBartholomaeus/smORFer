# get parameters
get_param <- commandArgs(trailingOnly = TRUE)

# upstream offset in nucleotides
up_offset <- 3
down_offset <- 3

# get start codon only 
bed <- read.table(get_param[1], sep = "\t", stringsAsFactors = F, header =F)

# plus strand
bed_p <- bed[bed[,6]=='+',]
bed_p_u <- unique(bed_p[,2])
bed_p_f <- data.frame(
  fix.empty.names = FALSE,
  rep(bed[1,1], length(bed_p_u)),
  bed_p_u-0-up_offset,
  bed_p_u+3+down_offset,
  rep('porf_start', length(bed_p_u)),
  rep('.', length(bed_p_u)),
  rep('+', length(bed_p_u))
)
# minus strand
bed_m <- bed[bed[,6]=='-',]
bed_m_u <- unique(bed_m[,3])
bed_m_f <- data.frame(
  fix.empty.names = FALSE,
  rep(bed[1,1], length(bed_m_u)),
  bed_m_u-3-down_offset,
  bed_m_u+0+up_offset,
  rep('porf_start', length(bed_m_u)),
  rep('.', length(bed_m_u)),
  rep('-', length(bed_m_u))
)
bed_new <- rbind(bed_p_f,bed_m_f)
bed_new[bed_new[,2] < 0,2] <- 0

# write results
write.table(bed_new,paste0(get_param[2],'/output/start_codons.bed'),col.names = F, row.names = F, quote=F, sep='\t')
