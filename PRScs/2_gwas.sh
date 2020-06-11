#!/bin/bash
set -beEuo pipefail

ml load plink2/20200409

GBE_ID=$1

cat /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
| awk '($15 == "train" || $15 == "val"){print $1, $2}' \
| plink2 \
--memory 60000 --threads 10 \
--keep /dev/stdin \
--maf 0.001 --geno 0.1 \
--pfile /oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19 vzs \
--pheno /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/${GBE_ID}.phe \
--covar /oak/stanford/groups/mrivas/ukbb24983/sqc/population_stratification_w24983_20190809/ukb24983_GWAS_covar.20190809.phe \
--covar-name age sex PC1-PC10 \
--covar-variance-standardize \
--pheno-quantile-normalize \
--glm firth-fallback hide-covar omit-ref no-x-sex \
--out /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/${GBE_ID}
