# get parameters
get_param <- commandArgs(trailingOnly = TRUE)

# upstream offset in nucleotides
up_offset <- 3
down_offset <- 3

# read files
bed_start <- read.table(get_param[1], sep = "\t", stringsAsFactors = F, header = F)
bed_cds <- read.table(get_param[2], sep = "\t", stringsAsFactors = F, header = F)

# plus strand
bed_p <- bed_start[bed_start[,6]=='+',]
bed_p_u <- unique(bed_p[,c(1:2)])
bed_p_new <- bed_cds[bed_cds[,6]=='+',]
bed_p_new <- 
  bed_p_new[is.element(
    paste0(
      bed_p_new[,1],'_',
      bed_p_new[,2]
    ),
    paste0(
      bed_p_u[,1],'_',
      bed_p_u[,2]
    )
  ),]
# minus strand
bed_m <- bed_start[bed_start[,6]=='-',]
bed_m_u <- unique(bed_m[,c(1,3)])
bed_m_new <- bed_cds[bed_cds[,6]=='-',]
bed_m_new <- 
  bed_m_new[is.element(
    paste0(
      bed_m_new[,1],
      bed_m_new[,3]
    ),
    paste0(
      bed_m_u[,1],
      bed_m_u[,2]
    )
  ),]

# merge
bed_new <- rbind(bed_p_new,bed_m_new)

# write results
write.table(bed_new,paste0(get_param[3]),col.names = F, row.names = F, quote=F, sep='\t')
