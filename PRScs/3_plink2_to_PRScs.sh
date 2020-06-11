#!/bin/bash
set -beEuo pipefail

GBE_ID=$1

ml load snpnet_yt

in_f=$(ls /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/${GBE_ID}.*.glm.*)
out_f="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/${GBE_ID}.sumstats.txt"

Rscript 3_plink2_to_PRScs.R $in_f $out_f
echo $out_f
