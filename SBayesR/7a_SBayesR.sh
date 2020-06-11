#!/bin/bash
set -beEuo pipefail

GBE_ID=$1

ml load gctb

gctb --sbayes R \
     --ldm /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/ukb24983_cal_cAUTO.train_val.ldm.sparse \
     --pi 0.95,0.02,0.02,0.01 \
     --gamma 0.0,0.01,0.1,1 \
     --gwas-summary "/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/sumstats_train_val/${GBE_ID}.ma" \
     --chain-length 10000 \
     --burn-in 2000 \
     --out-freq 100 \
     --out /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR/SBayesR/${GBE_ID}
