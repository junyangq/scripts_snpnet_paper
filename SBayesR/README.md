# `SBayesR`

We apply `SBayesR` analysis implemented in [GCTB (a tool for Genome-wide Complex Trait Bayesian analysis)](https://cnsgenomics.com/software/gctb/#Overview).

## results

We have the performance evaluation results for the 4 phenotypes in the following files.
In [GCTB's tutorial](https://cnsgenomics.com/software/gctb/#Tutorial), they say use of `--exclude-mhc` is "Highly recommended when performing genome-wide analyses".
We have two sets of results with and without this option.

- [`SBayesR.eval.tsv`](SBayesR.eval.tsv)
- [`SBayesR-exclude-mhc.eval.tsv`](SBayesR-exclude-mhc.eval.tsv)

## scripts

In some analysis scripts, we call `gctb`. Please install [GCTB (a tool for Genome-wide Complex Trait Bayesian analysis)](https://cnsgenomics.com/software/gctb/#Overview) from their website to replicate those analysis.

- [`1_split_bfile_by_chr.sh`](1_split_bfile_by_chr.sh)
- [`2_bfile_nvars_cnt.sh`](2_bfile_nvars_cnt.sh)
  - [`2_bfile_nvars.tsv`](2_bfile_nvars.tsv)
- [`3_ldm-sparse.sh`](3_ldm-sparse.sh): this is the script used for the sparse ldm computation.
  - Job submission: `sbatch --chdir=./ -p mrivas --nodes=1 --mem=8000 --cpus-per-task=1 --time=2-0:00:00 --job-name=ldm --output=logs/ldm.%A_%a.out --error=logs/ldm.%A_%a.err --array=1-143 3_ldm-sparse.sh`
  - [`3_ldm-sparse.batch.comp.ipynb`](3_ldm-sparse.batch.comp.ipynb): this notebook generates the index file for the array job.
  - [`3_ldm-sparse.batch.tsv`](3_ldm-sparse.batch.tsv): the index file for the array job.
- [`4_ldm-sparse-merge.sh`](4_ldm-sparse-merge.sh): combine the ldm sparse matrix into one file.
  - [`4_ldm-sparse-merge.mldmlist`](4_ldm-sparse-merge.mldmlist): the list of ldm to merge.
- [`5_afreq.sh`](5_afreq.sh): compute allele frequencies of the variants (which is a required column in GCTA-COJO's ma format)
- [`6_plink2_to_GCTA-COJO-ma.sh`](6_plink2_to_GCTA-COJO-ma.sh): script to convert PLINK2 summary statistics into GCTA-COJO's ma format.
  - [`6_plink2_to_GCTA-COJO-ma.R`](6_plink2_to_GCTA-COJO-ma.R): R script for format conversion.
- [`7a_SBayesR.sh`](7a_SBayesR.sh): GCTB SBayesR
  - In their tutorial, they recommend to run it with `--exclude-mhc` option.
  - [`7b_SBayesR-exclude-mhc.sh`](7b_SBayesR-exclude-mhc.sh)
- [`8_beta_conv.sh`](8_beta_conv.sh): convert the beta into the format we've been using in plink/snpnet.
- [`9a_plink_score.sh`](9a_plink_score.sh): compute PRS with plink2 `--score`.
  - [`9b_plink_score-exclude-mhc.sh`](9b_plink_score-exclude-mhc.sh): no-MHC version.
- [`10a_performance_eval.ipynb`](10a_performance_eval.ipynb): the performance evaluation.
  - [`10b_performance_eval-exclude-mhc.ipynb`](10b_performance_eval-exclude-mhc.ipynb)
