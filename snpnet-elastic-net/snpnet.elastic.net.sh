#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f $0)
SRCDIR=$(dirname ${SRCNAME})
PROGNAME=$(basename $SRCNAME)
VERSION="0.0.1"
NUM_POS_ARGS="0"

############################################################
# functions
############################################################

show_default_helper () {
    cat ${SRCNAME} | grep -n Default | tail -n+3 | awk -v FS=':' '{print $1}' | tr "\n" "\t" 
}

show_default () {
    cat ${SRCNAME} \
        | tail -n+$(show_default_helper | awk -v FS='\t' '{print $1+1}') \
        | head  -n$(show_default_helper | awk -v FS='\t' '{print $2-$1-1}')
}

usage () {
cat <<- EOF
	$PROGNAME (version $VERSION)
	Run a
	
	Usage: $PROGNAME [options] input_file
	  input_file      The input file
	
	Options:
	  --cpus     (-t)  Number of CPU cores
	  --mem      (-m)  The memory amount
	
	Default configurations:
EOF
    show_default | awk -v spacer="  " '{print spacer $0}'
}

############################################################
# tmp dir
############################################################
tmp_dir_root="$LOCAL_SCRATCH"
if [ ! -d ${tmp_dir_root} ] ; then mkdir -p $tmp_dir_root ; fi
tmp_dir="$(mktemp -p ${tmp_dir_root} -d tmp-$(basename $0)-$(date +%Y%m%d-%H%M%S)-XXXXXXXXXX)"
# echo "tmp_dir = $tmp_dir" >&2
handler_exit () { rm -rf $tmp_dir ; }
trap handler_exit EXIT

############################################################
# parser start
############################################################
## == Default parameters (start) == ##
cpus=4
mem=30000
## == Default parameters (end) == ##

declare -a params=()
for OPT in "$@" ; do
    case "$OPT" in 
        '-h' | '--help' )
            usage >&2 ; exit 0 ; 
            ;;
        '-v' | '--version' )
            echo $VERSION ; exit 0 ;
            ;;
        '-c' | '--cpus' )
            cpus=$2 ; shift 2 ;
            ;;
        '-m' | '--mem' )
            mem=$2 ; shift 2 ;
            ;;
        '--'|'-' )
            shift 1 ; params+=( "$@" ) ; break
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2 ; exit 1
            ;;
        *)
            if [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-+ ]]; then
                params+=( "$1" ) ; shift 1
            fi
            ;;
    esac
done

if [ ${#params[@]} -lt ${NUM_POS_ARGS} ]; then
    echo "${PROGNAME}: ${NUM_POS_ARGS} positional arguments are required" >&2
    usage >&2 ; exit 1 ; 
fi

phenotype_name=${params[0]}
family=${params[1]}
alpha=${params[2]}
############################################################

echo "[job] cpus:${cpus} mem:${mem}"
echo ${params[@]}

############################################################
# Required arguments for ${snpnet_wrapper} script
############################################################
# genotype_pfile="/oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19"
# project_dir="/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net"
genotype_pfile="/scratch/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19"
project_dir="/scratch/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net"
results_dir="${project_dir}/${phenotype_name}_${alpha}"
phe_file="${project_dir}/phenotype.phe"

############################################################
# Additional optional arguments for ${snpnet_wrapper} script
############################################################
covariates="age,sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10"
split_col="split"
status_col="CoxStatus"

############################################################
# Configure other parameters
############################################################

# ${snpnet_wrapper} is the path to the wrapper script. An example file
# is provided in the snpnet package under the helpers subdirectory.
#
# You may find description of the options in the script. For example,
# ${snpnet_dir} specifies the directory of the snpnet package.

############################################################
# Run ${snpnet_wrapper} script
############################################################

echo "[$0 $(date +%Y%m%d-%H%M%S)] [start] hostname = $(hostname) SLURM_JOBID = ${SLURM_JOBID:=0}; phenotype = ${phenotype_name}" >&2

if [ ! -d ${results_dir} ] ; then mkdir -p ${results_dir} ; fi

if [ ! -f ${results_dir}/snpnet.RData ] ; then   
    bash ${snpnet_wrapper} \
    --snpnet_dir ${snpnet_dir} \
    --nCores ${cpus} --memory ${mem} \
    --alpha ${alpha} \
    --covariates ${covariates} \
    --split_col ${split_col} \
    --status_col ${status_col} \
    --verbose \
    --save_computeProduct \
    --glmnetPlus \
    ${genotype_pfile} \
    ${phe_file} \
    ${phenotype_name} \
    ${family} \
    ${results_dir}

fi

echo "[$0 $(date +%Y%m%d-%H%M%S)] [end] hostname = $(hostname) SLURM_JOBID = ${SLURM_JOBID:=0}; phenotype = ${phenotype_name}" >&2
