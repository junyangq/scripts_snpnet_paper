## input file location

We used the following sets of files for the snpnet-elastic-net analysis.

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
