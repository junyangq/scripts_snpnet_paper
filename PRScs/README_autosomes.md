Notes on autosome-only analysis.

It turned out that PRScs (with default params) takes sumstats on autosomes.

Our sumstats has all chromosomes (X, XY, Y, MT), but we generated autosome-only version of `bim` file and applied autosomal variants only filter when converting from PLINK sumstats to 


```{bash}
[ytanigaw@sh02-02n07 ~/repos/rivas-lab/biobank-methods-dev/notebook/snpnet-PRScs]$ bash 4_PRScs.sh INI50

The following have been reloaded with a version change:
  1) anaconda/sherlock2 => anaconda/Anaconda3-5.3.0-Linux-x86_64_20181113



--ref_dir=/oak/stanford/groups/mrivas/software/PRS-CS/ldblk_1kg_eur
--bim_prefix=/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/ukb24983_cal_cALL_v2_hg19_train_val
--sst_file=/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/sumstats_train_val/INI50.sumstats.txt
--a=1
--b=0.5
--phi=None
--n_gwas=269927
--n_iter=1000
--n_burnin=500
--thin=5
--out_dir=/oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/PRScs/INI50
--chrom=range(1, 23)
--beta_std=False
--seed=20200519


##### process chromosome 1 #####
... parse reference file: /oak/stanford/groups/mrivas/software/PRS-CS/ldblk_1kg_eur/snpinfo_1kg_hm3 ...
... 92617 SNPs on chromosome 1 read from /oak/stanford/groups/mrivas/software/PRS-CS/ldblk_1kg_eur/snpinfo_1kg_hm3 ...
... parse bim file: /oak/stanford/groups/mrivas/projects/biobank-methods-dev/snpnet-PRScs/ukb24983_cal_cALL_v2_hg19_train_val.bim ...
Traceback (most recent call last):
  File "/oak/stanford/groups/mrivas/users/ytanigaw/repos/getian107/PRScs/PRScs.py", line 160, in <module>
    main()
  File "/oak/stanford/groups/mrivas/users/ytanigaw/repos/getian107/PRScs/PRScs.py", line 147, in main
    vld_dict = parse_genet.parse_bim(param_dict['bim_prefix'], int(chrom))
  File "/oak/stanford/groups/mrivas/users/ytanigaw/repos/getian107/PRScs/parse_genet.py", line 41, in parse_bim
    if int(ll[0]) == chrom:
ValueError: invalid literal for int() with base 10: 'X'
```
