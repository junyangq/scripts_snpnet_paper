#!/bin/bash
set -beEuo pipefail

GBE_ID=$1

ml load R/3.6 gcc
# this configures the R environment in our HPC system

in_f=$(ls /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/${GBE_ID}.*glm.*)
freq_f="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/freq/ukb24983_cal_cALL_v2_hg19_train_val.afreq"
out_d="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/sumstats_train_val"
out_f="${out_d}/${GBE_ID}.ma"

if [ ! -d ${out_d} ] ; then mkdir -p ${out_d} ; fi

Rscript 6_plink2_to_GCTA-COJO-ma.R $in_f $freq_f $out_f
echo $out_f
