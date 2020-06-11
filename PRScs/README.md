# PRS-CS

As a benchmarking comparison of `snpnet` against the other methods, we apply [`PRS-CS`](https://github.com/getian107/PRScs).

## results

We have the performance evaluation results for the 4 phenotypes.

- [`PRScs.eval.tsv`](PRScs.eval.tsv)

## output

- `/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs`: the analysis results dir
- `/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/PRScs`: the results from `4_PRScs.sh`

## scripts

- [`1_bfile_prep.sh`](1_bfile_prep.sh)
  - MAF 0.1% threshold (as in the snpnet paper)
  - [`1_bfile_prep_autosomes.sh`](1_bfile_prep_autosomes.sh): the autosome-only plink bfile
- [`2_gwas.sh`](2_gwas.sh): apply GWAS
- [`3_plink2_to_PRScs.sh`](3_plink2_to_PRScs.sh): convert the PLINK sumstats to PRS-cs format.
  - [`3_plink2_to_PRScs.R`](3_plink2_to_PRScs.R)
- [`4_PRScs.sh`](4_PRScs.sh): apply PRS-cs.
- [`5_combine_PRScs.sh`](5_combine_PRScs.sh): the output from PRS-cs is organized by chromosome. We combine those results into one file and reformat the beta into the format we've been using for snpnet/plink.
- [`6_plink_score.sh`](6_plink_score.sh): compute PRS with plink `--score`.
- [`7_compute_covar_scores.ipynb`](7_compute_covar_scores.ipynb): fit covariate models (using the `train + val` set) and compute the covariate score
- [`8_performance_eval.ipynb`](8_performance_eval.ipynb): performance evaluation.

## Note

We focused on autosomal variants: see [`README_autosomes.md`](README_autosomes.md).
