#!/bin/bash
set -beEuo pipefail

ml load plink2/20200409

# We installed PLINK2 software as a software module in our HPC system.
# This `ml load plink2/20200409` updates the PATHs so that we can execute plink2 software.

GBE_ID=$1

out_d="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/"

if [ ! -f ${out_d} ] ; then mkdir -p ${out_d} ; fi

cat /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
| awk '($15 == "train" || $15 == "val"){print $1, $2}' \
| plink2 \
--memory 60000 --threads 10 \
--keep /dev/stdin \
--maf 0.001 --geno 0.1 \
--pfile /oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19 vzs \
--pheno /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/${GBE_ID}.phe \
--covar /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
--covar-name age sex PC1-PC10 \
--glm firth-fallback hide-covar omit-ref no-x-sex \
--out ${out_d}/${GBE_ID}

