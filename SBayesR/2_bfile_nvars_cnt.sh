#!/bin/bash
set -beEuo pipefail

for c in $(seq 1 22) ; do echo "$c $(wc -l /scratch/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/bfile/ukb24983_cal_c${c}_v2_hg19_train_val.bim)" | tr " " "\t" ; done > 2_bfile_nvars.tsv
