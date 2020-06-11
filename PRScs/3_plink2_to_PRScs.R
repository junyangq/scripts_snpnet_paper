fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
in_f  <- args[1]
out_f <- args[2]
####################################################################

df <- fread(in_f, select=c('#CHROM', 'ID', 'REF', 'ALT', 'A1', 'BETA', 'OR', 'P', 'ERRCODE'), colClasses=c('#CHROM'='character'))

df %>% rename('SNP'='ID') %>%
filter(`#CHROM` %in% lapply(1:22, function(i){sprintf('%d', i)})) %>%
filter(ERRCODE == '.') %>%
filter(str_detect(SNP, '^rs')) %>%
mutate('A2'=if_else(A1 == ALT, REF, ALT)) %>%
select(SNP, A1, A2, intersect(colnames(df), c('BETA', 'OR')), P) %>%
fwrite(out_f, sep='\t', na = "NA", quote=F)
