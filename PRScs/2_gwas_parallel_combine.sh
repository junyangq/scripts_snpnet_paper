#!/bin/bash
set -beEuo pipefail

GBE_ID=$1
n_batch=100

out_d="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val"

##################

get_plink_suffix () {
    local GBE_ID=$1

    GBE_CAT=$(echo $GBE_ID | sed -e "s/[0-9]//g")

    if [ "${GBE_CAT}" == "QT_FC" ] || [ "${GBE_CAT}" == "INI" ] ; then
        echo glm.linear
    else
        echo glm.logistic.hybrid
    fi
}

##################

suffix=$(get_plink_suffix ${GBE_ID})

# combine the log files

seq ${n_batch} | while read batch_idx ; do
    echo "## ${out_d}/${GBE_ID}.batch${batch_idx}.log"
    cat ${out_d}/${GBE_ID}.batch${batch_idx}.log
done | bgzip -l9 -@6 > ${out_d}/${GBE_ID}.log.gz

# combine the summary statistics files

{
    cat ${out_d}/${GBE_ID}.batch1.PHENO1.${suffix} | egrep '^#'

    seq ${n_batch} | while read batch_idx ; do
        cat ${out_d}/${GBE_ID}.batch${batch_idx}.PHENO1.${suffix} | egrep -v '^#'
    done
} | bgzip -l9 -@6 > ${out_d}/${GBE_ID}.${suffix}.gz
