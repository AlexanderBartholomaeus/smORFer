### commands to process gff/gtf to bed file

# read 
gff <- read.table('../annotation_genome_download/ecoli/ecoli_annotation.gff3', sep = "\t", stringsAsFactors = F, header = F, comment.char = '#', quote = '####')

# get CDS only
cds <- gff[gff[,3]=='CDS',]

# get pseudogenes
pseudo <- gff[gff[,3]=='pseudogene',]

# remove pseudogenes CDS from cds based on position
cds2 <- cds[
  !is.element(
    apply(cds[,4:5],1,paste, collapse='-'),
    apply(pseudo[,4:5],1,paste, collapse='-')
  ),]

# create bed
bed <- cbind(cds2[,c(1,4,5,6,6,7)])
bed[,4] <- gsub('.+;Parent=(gene-b[0-9]{1,6});.+',"\\1",cds2[,9]) # parse name
bed[,2] <- bed[,2]-1 # make 0-based

# write table
write.table(bed, 'ecoli_annotation_cds.bed', sep = "\t", col.names = F, row.names = F, quote = F)
