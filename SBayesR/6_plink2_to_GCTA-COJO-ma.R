fullargs <- commandArgs(trailingOnly=FALSE)
args <- commandArgs(trailingOnly=TRUE)

script.name <- normalizePath(sub("--file=", "", fullargs[grep("--file=", fullargs)]))

suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))

####################################################################
in_f  <- args[1]
freq_f  <- args[2]
out_f <- args[3]
####################################################################

freq_df <- fread(freq_f, select=c('ID', 'ALT_FREQS'))

df <- fread(in_f, select=c('#CHROM', 'ID', 'REF', 'ALT', 'A1', 'OBS_CT', 'BETA', 'OR', 'SE', 'LOG(OR)_SE', 'P', 'ERRCODE'), colClasses=c('#CHROM'='character')) %>% 
left_join(freq_df, by='ID') %>%
rename('SNP'='ID', 'N'='OBS_CT') %>%
filter(`#CHROM` %in% lapply(1:22, function(i){sprintf('%d', i)})) %>%
filter(ERRCODE == '.') %>%
mutate(
    A2   = if_else(A1 == ALT, REF, ALT),
    freq = if_else(A1 == ALT, ALT_FREQS, 1-ALT_FREQS)
)

if('OR' %in% colnames(df)){
    df <- df %>% mutate(BETA = log(OR)) %>% rename('SE'='LOG(OR)_SE')
}

df %>%
rename('b'='BETA', 'se'='SE', 'p'='P') %>%
select(SNP, A1, A2, freq, b, se, p, N) %>%
fwrite(out_f, sep='\t', na = "NA", quote=F)
