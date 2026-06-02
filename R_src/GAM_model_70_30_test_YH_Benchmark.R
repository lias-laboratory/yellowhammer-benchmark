# The Yellowhammer benchmark - Program for obtaining the results of the 70/30 test in Section 6.2.2. GAM model
#   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
#   From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
#   Updated on 1st June 2026

rm(list = ls())
library(mgcv)

## Useful function
norm2 <- function(x) sqrt(sum(x^2, na.rm = TRUE))

## Loading Yellowhammer data and explanatory variables
u <- read.csv("Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv")

## Loading the 100 random samples for estimation (70%) and validation (30%)
indices_estim <- as.matrix(read.csv("Data_Estimation_70_V1.csv", header = F,sep=";"))
indices_valid <- as.matrix(read.csv("Data_Validation_30_V1.csv", header = F,sep=";"))

## Selected CLC & BIO explanatory variables
var_names_CLC <- c("CLC231", "CLC211", "CLC242", "CLC311", "CLC112", "CLC243", "CLC312","CLC313" , "CLC324")
var_names_BIO <- c("BIO1","BIO2")

## Formulas for the GAM models tested with a maximum number k=4 of degrees of freedom
# GAM1: BIO and CLC variables
terms_BIO<- paste0("s(", var_names_BIO, ",k=4)")
terms_CLC<- paste0("s(", var_names_CLC, ",k=4)")
terms_GAM1<-unique(c(terms_BIO,terms_CLC))
formula_GAM1 <- as.formula(paste("EMBCIT ~", terms_GAM1 |> paste(collapse = " + ")))
# GAM2: addition of longitude and latitude
formula_GAM2 <- as.formula(paste("EMBCIT ~s(Longitude,k=4)+s(Latitude,k=4)+", terms_GAM1 |> paste(collapse = " + ")))
# GAM3: addition of the year variable
formula_GAM3<- as.formula(paste("EMBCIT ~s(Longitude,k=4)+s(Latitude,k=4)+s(Year,k=4)+", terms_GAM1 |> paste(collapse = " + ")))

## 70/30 test
# Fitting variables definition
n_sim <- nrow(indices_estim)
FIT_estim_GAM1 <- numeric(n_sim)
FIT_valid_GAM1 <- numeric(n_sim)
FIT_estim_GAM2 <- numeric(n_sim)
FIT_valid_GAM2 <- numeric(n_sim)
FIT_estim_GAM3 <- numeric(n_sim)
FIT_valid_GAM3 <- numeric(n_sim)

# Loop over the 100 random draws
for (j in seq_len(n_sim)) {
  print(j)
  # Selection of estimation indices (columns up to the first NA)
  row_est <- indices_estim[j, ]
  ind_end <- which(is.na(row_est))[1]
  if (is.na(ind_end)) {
    idx <- row_est[!is.na(row_est)]
  } else {
    idx <- row_est[seq_len(ind_end - 1)]
  }
  idx <- as.integer(idx)

  # Model estimation
  mdl_GAM1=gam(formula_GAM1, family = poisson(link = "log"), data = u[idx,])
  mdl_GAM2=gam(formula_GAM2, family = poisson(link = "log"), data = u[idx,])
  mdl_GAM3=gam(formula_GAM3, family = poisson(link = "log"), data = u[idx,])

  # Calculation of estimation fitting variables
  EmbCit=u[idx,"EMBCIT"]
  EmbCit_estim_GAM1 <- predict(mdl_GAM1, newdata = u[idx,], type = "response")
  FIT_estim_GAM1[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GAM1) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
  EmbCit_estim_GAM2 <- predict(mdl_GAM2, newdata = u[idx,], type = "response")
  FIT_estim_GAM2[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GAM2) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
  EmbCit_estim_GAM3 <- predict(mdl_GAM3, newdata = u[idx,], type = "response")
  FIT_estim_GAM3[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GAM3) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))

  # Calculation of validation fitting variables
  row_val <- indices_valid[j, ]
  ind_end_val <- which(is.na(row_val))[1]
  if (is.na(ind_end_val)) {
    idx_val <- row_val[!is.na(row_val)]
  } else {
    idx_val <- row_val[seq_len(ind_end_val - 1)]
  }
  EmbCit_val=u[idx_val,"EMBCIT" ]
  EmbCit_valid_GAM1 <- predict(mdl_GAM1 ,  newdata = u[idx_val,], type = "response")
  FIT_valid_GAM1[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GAM1) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
  EmbCit_valid_GAM2 <- predict(mdl_GAM2, newdata = u[idx_val,], type = "response")
  FIT_valid_GAM2[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GAM2) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
  EmbCit_valid_GAM3 <- predict(mdl_GAM3, newdata = u[idx_val,], type = "response")
  FIT_valid_GAM3[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GAM3) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
} 

# Display of fittings - Table 2
cat("FIT on estimation data \n")
cat("GAM1 - Mean:", mean(FIT_estim_GAM1[1:n_sim]), "Standard deviation:", sd(FIT_estim_GAM1[1:n_sim]),"\n")
cat("GAM2 - Mean:", mean(FIT_estim_GAM2[1:n_sim]), "Standard deviation:", sd(FIT_estim_GAM2[1:n_sim]),"\n")
cat("GAM3 - Mean:", mean(FIT_estim_GAM3[1:n_sim]), "Standard deviation:", sd(FIT_estim_GAM3[1:n_sim]),"\n")
cat("\n")
cat("FIT on validation data \n")
cat("GAM1 - Mean:", mean(FIT_valid_GAM1[1:n_sim]), "Standard deviation:", sd(FIT_valid_GAM1[1:n_sim]),"\n")
cat("GAM2 - Mean:", mean(FIT_valid_GAM2[1:n_sim]), "Standard deviation:", sd(FIT_valid_GAM2[1:n_sim]),"\n")
cat("GAM3 - Mean:", mean(FIT_valid_GAM3[1:n_sim]), "Standard deviation:", sd(FIT_valid_GAM3[1:n_sim]),"\n")