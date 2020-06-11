#!/bin/bash
set -beEuo pipefail

GBE_ID=$1

out_dir="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/PRScs/${GBE_ID}"


{
echo "#CHROM POS ID A2 A1 BETA" | tr " " "\t"
for c in $(seq 1 22) ; do
    cat ${out_dir}_pst_eff_a1_b0.5_phiauto_chr${c}.txt | awk -v FS='\t' -v OFS='\t' '{print $1, $3, $2, $5, $4, $6}'
done
} > ${out_dir}_pst_eff_a1_b0.5_phiauto_chrAUTO.txt
