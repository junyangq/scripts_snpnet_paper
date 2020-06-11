# The elastic net in `snpnet`

In this directory, we have scripts used to apply elastic net using `snpnet`.

## elastic net with `snpnet`

- [`input_phe_file_prep.ipynb`](input_phe_file_prep.ipynb): this file was used to prepare the input phenotype file
- [`snpnet.elastic.net.sh`](snpnet.elastic.net.sh): this script was used to call `snpnet`.

### usage of the helper script

The usage of the wrapper script is:

```{bash}
snpnet.elastic.net.sh <phenotype name> <family> <alpha value in elastic net>
```

For example, we called the following to run elastic net with `alpha=0.9` for standing height (Global Biobank Engine phenotype ID: `INI50`).

```{bash}
snpnet.elastic.net.sh INI50 gaussian 0.9
```

## performance evaluation

- [`snpnet-elastic-net.eval.tsv`](snpnet-elastic-net.eval.tsv): this table has the evaluated performance.
  - `GBE_ID`: the phenotype ID in Global Biobank Engine
  - `alpha`: the value of the alpha parameter in elastic net
  - `n_variables`: the number of genetic variants (this does NOT include the number of covariates) in the model
  - `geno`: the r2 or AUC of the risk score computed only with the genetic variants.
  - `covar`: the r2 or AUC of the risk score computed only with the covariates.
  - `geno_covar`: : the r2 or AUC of the risk score computed with both the genetic variants and covariates.
  - `split`: this column indicate which of the train/val/test set was used for the evaluation.
- [`snpnet-elastic-net.eval.ipynb`](snpnet-elastic-net.eval.ipynb): this notebook was used to generate the table above.

## file location

- `/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net`

### phenotype

- `/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/phenotype.phe`

#### phenotype source files

The original file used in the snpnet v1 analysis was the followings:

- Standing height
  - `/oak/stanford/groups/mrivas/ukbb24983/phenotypedata/ukb9797_20170818_qt/INI50.phe`
- BMI
  - `/oak/stanford/groups/mrivas/ukbb24983/phenotypedata/ukb9797_20170818_qt/INI21001.phe`

Those files are already archived.

```{bash}
cd /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net

tar -I pigz -xvf /oak/stanford/groups/mrivas/ukbb24983/phenotypedata/phenotypedata_old.tar.gz old/ukb9797_20170818_qt/INI50.phe old/ukb9797_20170818_qt/INI21001.phe
```

- INI50: Standing height
  - `/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/INI50.phe`
- INI21001: BMI
  - `/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net/INI21001.phe`
- HC382: asthma
  - `/oak/stanford/groups/mrivas/ukbb24983/phenotypedata/extras/highconfidenceqc/v1_2017/phe/HC382.phe`
- HC269: high_cholesterol
  - `/oak/stanford/groups/mrivas/ukbb24983/phenotypedata/extras/highconfidenceqc/v1_2017/phe/HC269.phe`

### covariates

- `/oak/stanford/groups/mrivas/ukbb24983/sqc/population_stratification_w24983_20190809/ukb24983_GWAS_covar.20190809.phe`
- age, sex, PC1-PC10

### split

`/oak/stanford/groups/mrivas/users/ytanigaw/repos/rivas-lab/biobank-methods-dev/private_data/data-split/train.fam`

### genotype data

`/oak/stanford/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19.{pgen,psam,pvar.zst}`
