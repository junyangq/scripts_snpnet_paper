#!/bin/bash
set -beEuo pipefail

tbl="3_ldm-sparse.batch.tsv"
ldm_dir="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/ldm_train_val"
batch_size=5000
mldmlist="4_ldm-sparse-merge.mldmlist"

out="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/ukb24983_cal_cAUTO.train_val"

get_ldm_file () {
    local idx=$1

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

    echo "${ldm_dir}/ukb24983_cal_chr${chr}.snp${snp_s}-${snp_e}.ldm.sparse"
}

seq 143 | while read idx ; do get_ldm_file $idx ; done > ${mldmlist}

echo "merging ldm in: ${mldmlist}"

# ml load gctb

# We installed GCTB (a tool for Genome-wide Complex Trait Bayesian analysis) software as a software module in our HPC system.
# This `ml load gctb` updates the PATHs so that we can execute gctb software.

gctb --mldm ${mldmlist} --make-sparse-ldm --out ${out} 2>&1 | tee ${out}.log
