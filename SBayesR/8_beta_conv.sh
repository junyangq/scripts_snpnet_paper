#!/bin/bash
set -beEuo pipefail

data_dir="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR"

for GBE_ID in INI50 INI21001 HC382 HC269 ; do
for d in SBayesR SBayesR-exclude-mhc ; do
    cat ${data_dir}/${d}/${GBE_ID}.snpRes \
    | awk -v OFS='\t' '{print $3, $4, $2, $6, $5, $8}' > ${data_dir}/${d}/${GBE_ID}.snpRes.plink.tsv
done
done
