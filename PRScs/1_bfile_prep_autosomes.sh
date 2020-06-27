#!/bin/bash
set -beEuo pipefail

# ml load plink2/20200409

# We installed PLINK2 software as a software module in our HPC system.
# This `ml load plink2/20200409` updates the PATHs so that we can execute plink2 software.


cat /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
| awk '($15 == "train" || $15 == "val"){print $1, $2}' \
| plink2 \
--memory 60000 --threads 6 \
--chr 1-22 \
--keep /dev/stdin \
--maf 0.001 --geno 0.1 \
--pfile /oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19 vzs \
--make-bed \
--out /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/ukb24983_cal_cAUTO_v2_hg19_train_val

cat /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
| awk '($15 == "train"){print $1, $2}' \
| plink2 \
--memory 60000 --threads 6 \
--chr 1-22 \
--keep /dev/stdin \
--maf 0.001 --geno 0.1 \
--pfile /oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19 vzs \
--make-bed \
--out /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/ukb24983_cal_cAUTO_v2_hg19_train
