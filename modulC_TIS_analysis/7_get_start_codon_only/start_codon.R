# get parameters
get_param <- commandArgs(trailingOnly = TRUE)

# get start codon only 
bed <- read.table(get_param[1], sep = "\t", stringsAsFactors = F, header =F)

# plus strand
bed_p <- bed[bed[,6]=='+',]
bed_p_u <- unique(bed_p[,2])
bed_p_f <- cbind(
  rep(bed[1,1], length(bed_p_u)),
  bed_p_u-0,
  bed_p_u+3,
  rep('porf_start', length(bed_p_u)),
  rep('.', length(bed_p_u)),
  rep('+', length(bed_p_u))
)
# minus strand
bed_m <- bed[bed[,6]=='-',]
bed_m_u <- unique(bed_m[,3])
bed_m_f <- cbind(
  rep(bed[1,1], length(bed_m_u)),
  bed_m_u-3,
  bed_m_u+0,
  rep('porf_start', length(bed_m_u)),
  rep('.', length(bed_m_u)),
  rep('-', length(bed_m_u))
)
bed_new <- rbind(bed_p_f,bed_m_f)

# write results
write.table(bed_new,'output/TIS_start_codon_only.bed',col.names = F, row.names = F, quote=F, sep='\t')
