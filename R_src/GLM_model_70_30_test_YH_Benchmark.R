# The Yellowhammer benchmark - Program for obtaining the results of the 70/30 test in Section 6.2.1. GLM model
#   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
#   From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
#   Updated on 1st June 2026

rm(list = ls())

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

## Formulas for the GLM models tested
# GLM1: linear effects of BIO and CLC variables without interactions
terms_GLM1<-c(var_names_BIO,var_names_CLC)
formula_GLM1=as.formula(paste("EMBCIT ~", paste(terms_GLM1 ,collapse = " + ") ))
# GLM2: addition of longitude and latitude
formula_GLM2=as.formula(paste("EMBCIT ~Longitude+Latitude+", paste(c(terms_GLM1) ,collapse = " + ")))
# GLM3: addition of squared effects
terms_GLM3<-c(var_names_BIO,paste0("I(", var_names_BIO, "^2)"),var_names_CLC,paste0("I(", var_names_CLC, "^2)"))
formula_GLM3=as.formula(paste("EMBCIT ~Longitude+Latitude+", paste(c(terms_GLM3) ,collapse = " + ")))
# GLM4: addition of the year variable
formula_GLM4=as.formula(paste("EMBCIT ~Longitude+Latitude+", paste(c(terms_GLM3,"Year") ,collapse = " + ")))

## 70/30 test
# Fitting variables definition
n_sim <- nrow(indices_estim)
FIT_estim_GLM1 <- numeric(n_sim)
FIT_valid_GLM1 <- numeric(n_sim)
FIT_estim_GLM2 <- numeric(n_sim)
FIT_valid_GLM2 <- numeric(n_sim)
FIT_estim_GLM3 <- numeric(n_sim)
FIT_valid_GLM3 <- numeric(n_sim)
FIT_estim_GLM4 <- numeric(n_sim)
FIT_valid_GLM4 <- numeric(n_sim)

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
  mdl_GLM1=glm(formula_GLM1, family = poisson(link = "log"), data = u[idx,])
  mdl_GLM2=glm(formula_GLM2, family = poisson(link = "log"), data = u[idx,])
  mdl_GLM3=glm(formula_GLM3, family = poisson(link = "log"), data = u[idx,])
  mdl_GLM4=glm(formula_GLM4, family = poisson(link = "log"), data = u[idx,])
  
  # Calculation of estimation fitting variables
  EmbCit=u[idx,"EMBCIT"]
  EmbCit_estim_GLM1 <- predict(mdl_GLM1, newdata = u[idx,], type = "response")
  FIT_estim_GLM1[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GLM1) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
  EmbCit_estim_GLM2 <- predict(mdl_GLM2, newdata = u[idx,], type = "response")
  FIT_estim_GLM2[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GLM2) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
  EmbCit_estim_GLM3 <- predict(mdl_GLM3, newdata = u[idx,], type = "response")
  FIT_estim_GLM3[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GLM3) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
  EmbCit_estim_GLM4 <- predict(mdl_GLM4, newdata = u[idx,], type = "response")
  FIT_estim_GLM4[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GLM4) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
  
  # Calculation of validation fitting variables
  row_val <- indices_valid[j, ]
  ind_end_val <- which(is.na(row_val))[1]
  if (is.na(ind_end_val)) {
    idx_val <- row_val[!is.na(row_val)]
  } else {
    idx_val <- row_val[seq_len(ind_end_val - 1)]
  }
  EmbCit_val=u[idx_val,"EMBCIT" ]
  EmbCit_valid_GLM1 <- predict(mdl_GLM1 ,  newdata = u[idx_val,], type = "response")
  FIT_valid_GLM1[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GLM1) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
  EmbCit_valid_GLM2 <- predict(mdl_GLM2, newdata = u[idx_val,], type = "response")
  FIT_valid_GLM2[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GLM2) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
  EmbCit_valid_GLM3 <- predict(mdl_GLM3, newdata = u[idx_val,], type = "response")
  FIT_valid_GLM3[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GLM3) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
  EmbCit_valid_GLM4 <- predict(mdl_GLM4, newdata = u[idx_val,], type = "response")
  FIT_valid_GLM4[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GLM4) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
} 

# Display of fittings - Table 1
cat("FIT on estimation data \n")
cat("GLM1 - Mean:", mean(FIT_estim_GLM1[1:n_sim]), "Standard deviation:", sd(FIT_estim_GLM1[1:n_sim]),"\n")
cat("GLM2 - Mean:", mean(FIT_estim_GLM2[1:n_sim]), "Standard deviation:", sd(FIT_estim_GLM2[1:n_sim]),"\n")
cat("GLM3 - Mean:", mean(FIT_estim_GLM3[1:n_sim]), "Standard deviation:", sd(FIT_estim_GLM3[1:n_sim]),"\n")
cat("GLM4 - Mean:", mean(FIT_estim_GLM4[1:n_sim]), "Standard deviation:", sd(FIT_estim_GLM4[1:n_sim]),"\n")
cat("\n")
cat("FIT on validation data \n")
cat("GLM1 - Mean:", mean(FIT_valid_GLM1[1:n_sim]), "Standard deviation:", sd(FIT_valid_GLM1[1:n_sim]),"\n")
cat("GLM2 - Mean:", mean(FIT_valid_GLM2[1:n_sim]), "Standard deviation:", sd(FIT_valid_GLM2[1:n_sim]),"\n")
cat("GLM3 - Mean:", mean(FIT_valid_GLM3[1:n_sim]), "Standard deviation:", sd(FIT_valid_GLM3[1:n_sim]),"\n")
cat("GLM4 - Mean:", mean(FIT_valid_GLM4[1:n_sim]), "Standard deviation:", sd(FIT_valid_GLM4[1:n_sim]),"\n")