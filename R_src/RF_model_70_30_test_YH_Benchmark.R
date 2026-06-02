# The Yellowhammer benchmark - Program for obtaining the results of the 70/30 test in Section 6.2.3. Random Forest model
#   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
#   From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
#   Updated on 1st June 2026

rm(list = ls())
library(randomForest)

## Useful function
norm2 <- function(x) sqrt(sum(x^2, na.rm = TRUE))

## Loading Yellowhammer data and explanatory variables
u <- read.csv("Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv")

## Loading the 100 random samples for estimation (70%) and validation (30%)
indices_estim <- as.matrix(read.csv("Data_Estimation_70_V1.csv", header = F,sep=";"))
indices_valid <- as.matrix(read.csv("Data_Validation_30_V1.csv", header = F,sep=";"))

## Selected CLC & BIO explanatory variables
sel_var=c("EMBCIT","Latitude","Longitude","BIO1","BIO2",
          "CLC231", "CLC211", "CLC242", "CLC311", "CLC112", "CLC243", "CLC312","CLC313" , "CLC324" ) 
u2=u[,sel_var]
colnames(u2)

## 70/30 test
# Fitting variables definition
n_sim <- nrow(indices_estim)
FIT_estim <- numeric(n_sim)
FIT_valid <- numeric(n_sim)

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
  resRF=randomForest(formula = EMBCIT ~ ., data = u2[idx,], ntree = 500,na.action = na.omit) 
  
  # Calculation of estimation fitting variables
  EmbCit=u2[idx,"EMBCIT"]
  EmbCit_estim <- predict(resRF,u2[idx,])
  FIT_estim[j] <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))

  # Calculation of validation fitting variables
  row_val <- indices_valid[j, ]
  ind_end_val <- which(is.na(row_val))[1]
  if (is.na(ind_end_val)) {
    idx_val <- row_val[!is.na(row_val)]
  } else {
    idx_val <- row_val[seq_len(ind_end_val - 1)]
  }
  EmbCit_val=u2[idx_val,"EMBCIT" ]
  EmbCit_valid<- predict(resRF,u2[idx_val,])
  FIT_valid[j] <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
} 

# Display of fittings - Table 3
cat("FIT on estimation data \n")
cat("Random Forest - Mean:", mean(FIT_estim[1:n_sim]), "Standard deviation:", sd(FIT_estim[1:n_sim]),"\n")
cat("\n")
cat("FIT on validation data \n")
cat("Random Forest - Mean:", mean(FIT_valid[1:n_sim]), "Standard deviation:", sd(FIT_valid[1:n_sim]),"\n")