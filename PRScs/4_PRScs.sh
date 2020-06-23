#!/bin/bash
set -beEuo pipefail

GBE_ID=$1

out_dir="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/PRScs/${GBE_ID}"

# PRScs.py is also provided in the PRScs repo (https://github.com/getian107/PRScs)

python /oak/stanford/groups/mrivas/users/ytanigaw/repos/getian107/PRScs/PRScs.py \
--ref_dir=/oak/stanford/groups/mrivas/software/PRS-CS/ldblk_1kg_eur \
--bim_prefix=/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/ukb24983_cal_cAUTO_v2_hg19_train_val \
--sst_file=/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/${GBE_ID}.sumstats.txt \
--n_gwas=269927 \
--out_dir=${out_dir} \
--seed=20200519 # our review response deadline, good number to remember!

exit 0

# Example usage of PRScs using their demo data
# cd /home/users/ytanigaw/repos/getian107/PRScs
# ./PRScs.py --ref_dir=/oak/stanford/groups/mrivas/software/PRS-CS/ldblk_1kg_eur --bim_prefix=test_data/test --sst_file=test_data/sumstats.txt --n_gwas=200000 --chrom=22 --phi=1e-2 --out_dir=test_out/eur
