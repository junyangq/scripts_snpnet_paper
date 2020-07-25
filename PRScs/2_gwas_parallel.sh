#!/bin/bash
set -beEuo pipefail

ml load plink2/20200706

# We installed PLINK2 software as a software module in our HPC system.
# This `ml load plink2/20200409` updates the PATHs so that we can execute plink2 software.

batch_idx=${SLURM_ARRAY_TASK_ID:=1}
if [ $# -gt 0 ] ; then batch_idx=$1 ; fi
GBE_ID=$2
n_batch=100

pfile="/oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19"

pvar_n_vars=$(zstdcat ${pfile}.pvar.zst | egrep -v '^#' | wc -l)
batch_size=$(perl -e "print(  int((${pvar_n_vars}-1)/${n_batch}) + 1  )")
idx_s=$(perl -e "print(  ${batch_size} *  (${batch_idx} - 1) + 1  )")
idx_e=$(perl -e "print(  ${batch_size} *   ${batch_idx} )")

out_d="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val"

if [ ! -f ${out_d} ] ; then mkdir -p ${out_d} ; fi

cat /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
| awk '($15 == "train" || $15 == "val"){print $1, $2}' \
| plink2 \
--memory 6000 --threads 2 \
--keep /dev/stdin \
--maf 0.001 --geno 0.1 \
--extract <(zstdcat ${pfile}.pvar.zst | egrep -v '^#' | awk -v idx_s=${idx_s} -v idx_e=${idx_e} '(idx_s <= NR && NR <= idx_e){print $3}') \
--pfile ${pfile} vzs \
--pheno /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/${GBE_ID}.phe \
--covar /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe \
--covar-name age sex PC1-PC10 \
--glm firth-fallback hide-covar omit-ref no-x-sex \
--out ${out_d}/${GBE_ID}.batch${batch_idx}
