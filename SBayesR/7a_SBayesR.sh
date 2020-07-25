#!/bin/bash
set -beEuo pipefail

GBE_ID=$1

ml load gctb/2.0.standard

# We installed GCTB (a tool for Genome-wide Complex Trait Bayesian analysis) software as a software module in our HPC system.
# This `ml load gctb/2.0.standard` updates the PATHs so that we can execute gctb software.

data_d="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-SBayesR"
out_d="${data_d}/SBayesR"

if [ ! -d ${out_d} ] ; then mkdir -p ${out_d} ; fi

gctb --sbayes R \
     --ldm "${data_d}/ukb24983_cal_cAUTO.train_val.ldm.sparse" \
     --pi 0.95,0.02,0.02,0.01 \
     --gamma 0.0,0.01,0.1,1 \
     --gwas-summary "${data_d}/sumstats_train_val/${GBE_ID}.ma" \
     --chain-length 10000 \
     --burn-in 4000 \
     --out-freq 100 \
     --out ${out_d}/${GBE_ID}
