# The elastic net in `snpnet`

In this directory, we have scripts used to apply elastic net using `snpnet`.

## Elastic net with `snpnet`

- [`input_phe_file_prep.ipynb`](input_phe_file_prep.ipynb): this file was used to prepare the input phenotype file.
- [`snpnet.elastic.net.sh`](snpnet.elastic.net.sh): this script was used to call [the helper script](https://github.com/rivas-lab/snpnet/blob/master/helpers/snpnet_wrapper.sh) in the `snpnet` repository.

### Usage of `snpnet.elastic.net.sh`

Because this script uses a helper script in the `snpnet` repository, please first clone the repository in your directory.

```{bash}
cd $HOME # please feel free to change to your favorite directory
git clone git@github.com:rivas-lab/snpnet.git
```

After cloning the repositiry in your file system, please note the location of the cloned repository.

Please open [`snpnet.elastic.net.sh`](snpnet.elastic.net.sh) and configure the location of the input files as well as some parameters.
The parameters specified here will be used to call [the helper script](https://github.com/rivas-lab/snpnet/blob/master/helpers/snpnet_wrapper.sh).

```{bash}
############################################################
# Let's configure the required and optional arguments for ${snpnet_wrapper} script
############################################################

snpnet_dir="$HOME/snpnet" # please specify the path to the cloned snpnet repository
snpnet_wrapper="${snpnet_dir}/helpers/snpnet_wrapper.sh"
genotype_pfile="/scratch/groups/mrivas/ukbb24983/cal/pgen/ukb24983_cal_cALL_v2_hg19"
project_dir="/scratch/groups/mrivas/projects/biobank-methods-dev/snpnet-elastic-net"
phe_file="${project_dir}/phenotype.phe"
covariates="age,sex,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10"
split_col="split"
```

- `snpnet_dir`: the location of the cloned `snpnet` repository.
- `snpnet_wrapper`: the location of [the helper script](https://github.com/rivas-lab/snpnet/blob/master/helpers/snpnet_wrapper.sh). In most applications, you don't need to update this as long as `snpnet_dir` is properly configured.
- `genotype_pfile`: the location of genotype dataset in PLINK2 format. We assume there are three files (`${genotype_pfile}.pgen`, `${genotype_pfile}.psam`, and `${genotype_pfile}.pvar.zst`).
- `project_dir`: the root directory of the output files.
- `phe_file`: the location of the phenotype file. An example R script to prepare the input phenotype dataset is provided as [`input_phe_file_prep.ipynb`](input_phe_file_prep.ipynb) in this directory. Please also look at the sample synthetic dataset in the snpnet repository.
- `covariates`: list of covariates separated with `,` symbol. In this example, we specified age, sex, and the first 10 (genetic) principal components (PCs).
- `split_col`: the name of the column in the input phenotype file that specifies the partition of individuals into training (`train`) and validation (`val`) sets. This column can have other strings (such as `test` for test set), but `snpnet` will focus on individuals tagged as `train` and `val` and ignore the other individuals.

Now, you have successfully configured the variables to execute `snpnet.elastic.net.sh`.

This script takes 3 command-line arguments.

```{bash}
snpnet.elastic.net.sh <phenotype name> <family> <alpha value in elastic net>
```

For example, we called the following to run elastic net with `alpha=0.9` for standing height (Global Biobank Engine phenotype ID: `INI50`).

```{bash}
snpnet.elastic.net.sh INI50 gaussian 0.9
```

## Performance evaluation

To evaluate the performance of the elastic-net models, we computed r2 (for continuous phenotypes) or AUC (for binary phenotypes) values using a notebook and saved the results into a tsv file.

- [`snpnet-elastic-net.eval.ipynb`](snpnet-elastic-net.eval.ipynb): this notebook was used to generate the table above.
- [`snpnet-elastic-net.eval.tsv`](snpnet-elastic-net.eval.tsv): this table has the evaluated performance.
  - `GBE_ID`: the phenotype ID in Global Biobank Engine.
  - `alpha`: the value of the alpha parameter in elastic net.
  - `n_variables`: the number of genetic variants (this does NOT include the number of covariates) in the model.
  - `geno`: the r2 or AUC of the risk score computed only with the genetic variants.
  - `covar`: the r2 or AUC of the risk score computed only with the covariates.
  - `geno_covar`: : the r2 or AUC of the risk score computed with both the genetic variants and covariates.
  - `split`: this column indicate which of the train/val/test set was used for the evaluation.

## File location

- [`README_filelocations.md`](README_filelocations.md): this document contains the list of file locations used in the analysis.
