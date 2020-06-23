# Compare performance of standard matrix multiplication and SNP-optimized multiplication
# ------ Table 3 ------- #

library(Rcpp)

set.seed(1223)

n <- 2000
p <- 8000
k <- 20

X <- matrix(sample(x = 0:3, replace = T, size = n*p, prob = c(0.7, 0.1, 0.1, 0.1)), n, p)
R <- matrix(rnorm(n*k), n, k)

cppFunction('NumericMatrix snp_mat_multiplication(IntegerMatrix X, NumericMatrix R) {
              int n = X.nrow(), p = X.ncol(), k = R.ncol();
              NumericMatrix out(p, k);
              
              for (int j = 0; j < p; ++j) {
                double reg[k][4];
                memset(*reg, 0, k*4*sizeof(double));
                for (int i = 0; i < n; ++i) 
                  if (X(i, j) != 0) {
                    int snp = X(i, j);
                    for (int u = 0; u < k; ++u) 
                      reg[u][snp] += R(i, u);
                  }
                for (int u = 0; u < k; ++u)
                  out(j, u) = reg[u][1] + 2 * reg[u][2] + 3 * reg[u][3];
              }

              return out;
            }')

cppFunction('NumericMatrix ord_mat_multiplication(IntegerMatrix X, NumericMatrix R) {
              int n = X.nrow(), p = X.ncol(), k = R.ncol();
              NumericMatrix out(p, k);
            
              for (int j = 0; j < p; ++j) {
                for (int u = 0; u < k; ++u) {
                  for (int i = 0; i < n; ++i)
                    out(j, u) += X(i, j) * R(i, u);
                }
              }
            
              return out;
            }')

prod_snp <- snp_mat_multiplication(X, R)
prod_ord <- ord_mat_multiplication(X, R)
all.equal(prod_snp, prod_ord)

microbenchmark::microbenchmark({prod_snp <- snp_mat_multiplication(X, R)})
microbenchmark::microbenchmark({prod_ord <- ord_mat_multiplication(X, R)})



# Generate a demo plot of the procedure
# ------ Figure 1 ------ #
# (does not correspond to the exact progress)

library(glmnet)
set.seed(10370)
n <- 500; p <- 100
k <- 50

beta <- rep(0, p)
beta[sample(p, size = k)] <- 0.5 * (runif(k)*2 - 1)

X <- matrix(rnorm(n*p), n, p)
y <- X %*% beta + rnorm(n)
glmfit <- glmnet(X, y)

beta_hat <- glmfit$beta

col.mat <- t(rbind(matrix("green4", 8, 10), matrix("red", 2, 10)))

valid.idx <- c(8, 12, 20, 25)
end.idx <- c(10, 15, 25, 30)
nz <- apply(beta_hat, 2, function(x) sum(x != 0))
size <- 100 + c(0, nz[valid.idx[1:3]])

pa <- par(mfrow = c(2, 2))
for (k in 1:4) {
  if (k > 1) {
    matplot(t(beta_hat[, 1:valid.idx[k-1]]), ylim=range(beta_hat), xlim=c(1, 40), col = "grey", lty = 1, pch = 20, type = "l",
            ylab = "Coefficients", xlab = "Lambda Index", main = paste0("Iteration ", k))
    matplot(valid.idx[k-1]:valid.idx[k], t(beta_hat[, valid.idx[k-1]:valid.idx[k]]), ylim=range(beta_hat), xlim=c(1, 40), col = "green4", lty = 1, pch = 20, type = "l",
            ylab = "Coefficients", xlab = "Lambda Index", add = T)
  }
  if (k == 1) {matplot(t(beta_hat[, 1:valid.idx[k]]), ylim=range(beta_hat), xlim=c(1, 40), col = "green4", lty = 1, pch = 20, type = "l",
                       ylab = "Coefficients", xlab = "Lambda Index", main = paste0("Iteration ", k))
  }
  matplot(valid.idx[k]:end.idx[k], t(beta_hat[, valid.idx[k]:end.idx[k]]), ylim=range(beta_hat), xlim=c(1, 40), col = "red", lty = 1, pch = 20, type = "l", add = T)
  abline(v = valid.idx[k], lty = 2, col = "grey", lwd = 2)
}
legend(-20, 1, legend = c("completed fit", "new valid fit", "new invalid fit"), lty = 1, col = c("grey", "green4", "red"), xpd = "NA")
par(pa)



### PLINK1.9 Script to generate synthetic SNP dataset used in Table 4 ### 
### ------ Table 4 ------- ###

plink \
  --make-bed \
  --out sample_chr_50K_100K \
  --simulate-missing 0 \
  --simulate-n 50000 \
  --seed 1550816629 \
  --simulate-qt myfile_qnt.sim

### myfile_qnt.sim ###

95000 null 0.05 0.95 0 0
5000 qtl 0.05 0.95 0.0001 0



### Create synthetic phenotype used in Table 4 (QPHE) ###
### ------ Table 4 ------- ###
### includes confounders age, sex and 5K significant SNPs ###
### target R2 = 0.5   ###

library(BEDMatrix)
library(data.table)
chr <- BEDMatrix("sample_chr_50K_100K.bed")
data.X <- chr[, ]
p <- ncol(data.X)
for (j in 1:p) {
  if (any(is.na(data.X[, j]))) print(j)
  data.X[is.na(data.X[, j]), j] <- mean(data.X[, j], na.rm = T)
}
n <- nrow(data.X)

set.seed(1223)
age <- sample(18:60, n, replace = T)
sex <- sample(c(0, 1), n, replace = T)
data.X <- cbind(age = age, sex = sex, data.X)
beta <- rep(0, p+2)
beta[1:2] <- rnorm(2) * 0.1
beta[2+((p-94999):p)] <- rnorm(5000) * 0.05
target.R2 <- 0.5
mu <- data.X %*% beta
mu <- mu - mean(mu)
sigma <- sqrt(var(mu) * (1-target.R2) / target.R2)
yq <- as.numeric(mu) + rnorm(n, 0, sigma)
probs <- exp(mu) / (1 + exp(mu))
yb <- as.integer(runif(n) <= probs)
pnames <- sapply(strsplit(rownames(chr), split = "_"), function(x) x[[1]])
phe.mat <- data.table(ID = pnames, age = age, sex = sex, QPHE = yq, BPHE = yb)
fwrite(phe.mat, "sample_phe_50K_100K.phe", sep = "\t")
phe.mat.std <- data.table(FID = pnames, IID = pnames, age = age, sex = sex, QPHE = yq, BPHE = yb)
fwrite(phe.mat.std, "sample_phe_50K_100K_std.phe", sep = "\t")



### runtime of bigstatsr in Table 4 ###
### ------ Table 4 ------ ###

library(bigstatsr)
library(bigsnpr)
library(BEDMatrix)
library(data.table)
library(MASS)
library(bigmemory)
library(BGData)
library(biglasso)


directory <- "#PARENT/#DIR/#OF/#DATA"

begin_attach <- Sys.time()
rds <- snp_readBed(file.path(directory, "/simulate/sample_chr_50K_100K.bed"), 
    backingfile = file.path(directory, "/simulate/sample_chr_50K_100K"))
obj.bigSNP <- snp_attach(rds)
end_attach <- Sys.time()
print("Time on attach: ")
print(end_attach - begin_attach)

G <- obj.bigSNP$genotypes
phe <- fread(file.path(directory, "/simulate/sample_phe_50K_100K.phe"))
data.y <- phe$QPHE

cov.mat <- cbind(phe$age, phe$sex)

pfactor <- rep(1, ncol(chr.bed)+2)
pfactor[1:2] <- 0

begin_fit <- Sys.time()
system.time({fit_bigstatsr <- big_spLinReg(G, data.y, ncores = 16, pf.covar = c(0, 0), nlambda = 50, eps = 1e-7, K = 2, 
    ind.sets = c(rep(1, 5e4 - 5), rep(2, 5)), n.abort = 100, covar.train = cov.mat, max.iter = 100000, dfmax = 1e6, 
    lambda.min = sqrt(0.01))})  # lambda.min is chosen so that the lambda sequence is the same as under the other methods
end_fit <- Sys.time()
print("Time on fitting: ")
print(end_fit - begin_fit)


### runtime of biglasso in Table 4 ###

directory <- "#PARENT/#DIR/#OF/#DATA"


chr <- BEDMatrix(file.path(directory, "/simulate/sample_chr_50K_100K.bed"))
phe <- fread(file.path(directory, "/simulate/sample_phe_50K_100K.phe"))
start_extract <- Sys.time()
data.X <- chr[, ] + 0.0
end_extract <- Sys.time()
cov.mat <- cbind(phe$age, phe$sex)
data.X <- cbind(cov.mat, data.X)
print("Time of extracting from binary file: ")
print(end_extract - start_extract)

data.y <- phe$QPHE

start_convert <- Sys.time()
X <- bigstatsr::as_FBM(data.X, backingfile = file.path(directory, "/simulate/sample_chr_50K_100K_biglasso"))
desc <- sub("\\.bk$", ".desc", X$backingfile)
dput(X$bm.desc(), desc)
X.big <- attach.big.matrix(desc)
end_convert <- Sys.time()
print("Time of converting to a big matrix: ") ## 23.81 mins
print(end_convert - start_convert)

################################################################
# Alternative 1: use as.big.matrix function to data.X convert to 
# a big.matrix object. However the current version has the issue
# of ''long vector not supported'' for this size of data

# Alternative 2: use plink to output a raw format of the binary
# file as follows:
# plink --bfile sample_chr_50K_100K --recodeA --out sample_chr_50K_100K
# and then read it into a big.matrix object using the readRAW_big.matrix
# function from BGData. But additional effort is needed to include
# adjustment covariates into the big.matrix ...
################################################################

rm(data.X)
gc()

pfactor <- rep(1, ncol(X.big))
pfactor[1:2] <- 0

system.time({fit_biglasso <- biglasso(X.big, data.y, lambda.min = sqrt(0.01), penalty = "lasso", penalty.factor = pfactor, 
    nlambda = 50, verbose = T, output.time = T, ncores = 16)})


### runtime of PLINK in Table 4 (not R code) ###
plink \
--bfile ../simulate/sample_chr_50K_100K \
--pheno ../simulate/sample_phe_50K_100K_std.phe \
--pheno-name QPHE \
--covar ../simulate/sample_phe_50K_100K_std.phe \
--covar-number 1,2 \
--allow-no-sex \
--memory 64000 \
--lasso 0.5 \
--geno \
--maf 0.001 \
--out fit_plink_small

### runtime of snpnet in Table 4 ###
### it uses an EARLIER version of snpnet that depends on bed files:
### https://github.com/junyangq/snpnet/tree/V1.0

library(snpnet)

directory <- "#PARENT/#DIR/#OF/#DATA"

configs <- list(
  missing.rate = 0.1,
  MAF.thresh = 0.001,
  nCores = 16,
  bufferSize = 20000,
  meta.dir = "meta/",
  nlams.init = 20,
  nlams.delta = 5,
  chunkSize = 2000
)

genotype.dir <- file.path(directory, "/simulate/50K_100K/")
phenotype.file <- file.path(directory, "/simulate/sample_phe_50K_100K.phe")

system.time({out <- snpnet(
  genotype.dir = genotype.dir,
  phenotype.file = phenotype.file,
  phenotype = "QPHE",
  family = "gaussian",
  results.dir = "../compare/snpnet/tmp/",
  standardize.variant = TRUE,
  covariates = c("age", "sex"),
  niter = 50,
  lambda.min.ratio = sqrt(0.01),
  nlambda = 50, 
  validation = FALSE,
  num.snps.batch = 2000, # original: 2000
  configs = configs,
  use.glmnetPlus = TRUE,
  verbose = TRUE,
  save = TRUE,
  prevIter = 0,
  glmnet.thresh = 1e-7
)})