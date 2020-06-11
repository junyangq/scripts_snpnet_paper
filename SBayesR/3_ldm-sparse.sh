#!/bin/bash
set -beEuo pipefail

idx=${SLURM_ARRAY_TASK_ID:=1}

# idx=$1
tbl='3_ldm-sparse.batch.tsv'

batch_size=5000

chr=$(cat ${tbl} | awk 'NR>1' | awk -v idx=${idx} -v FS='\t' '($4 <= idx && idx <= $5){print $1}')
n_snps=$(cat ${tbl} | awk -v chr=${chr} -v FS='\t' '($1 == chr){print $2}')
chr_idx_s=$(cat ${tbl} | awk -v chr=${chr} -v FS='\t' '($1 == chr){print $4}')
chr_idx_e=$(cat ${tbl} | awk -v chr=${chr} -v FS='\t' '($1 == chr){print $5}')
chr_idx=$(perl -e "print(${idx} - ${chr_idx_s} + 1)")
snp_s=$(perl -e "print(${batch_size} * (${chr_idx} - 1) + 1)")
if [ "${idx}" == "${chr_idx_e}" ] ; then
    snp_e=${n_snps}
else
    snp_e=$(perl -e "print(${batch_size} * ${chr_idx})")
fi

echo "$chr ${snp_s}-${snp_e}"

ml load gctb
gctb \
--bfile /scratch/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/bfile/ukb24983_cal_c${chr}_v2_hg19_train_val \
--make-sparse-ldm \
--snp "${snp_s}-${snp_e}" \
--out /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/ldm_train_val/ukb24983_cal_chr${chr}
