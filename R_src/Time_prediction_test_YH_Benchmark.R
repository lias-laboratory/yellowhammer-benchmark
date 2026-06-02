# The Yellowhammer benchmark - Program for obtaining the results of the time prediction test in Section 6.3. Prediction test
#   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
#   From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
#   Updated on 1st June 2026

rm(list = ls())
library(mgcv)
library(randomForest)

## Useful function
norm2 <- function(x) sqrt(sum(x^2, na.rm = TRUE))

## Loading Yellowhammer data and explanatory variables for the period 2002–2019
u <- read.csv("Data_Estimation_2002_2019.csv")

## Selected CLC & BIO explanatory variables
var_names_CLC <- c("CLC231", "CLC211", "CLC242", "CLC311", "CLC112", "CLC243", "CLC312","CLC313" , "CLC324")
var_names_BIO <- c("BIO1","BIO2")

## GLM4 model estimation
terms_GLM4<-c(var_names_BIO,paste0("I(", var_names_BIO, "^2)"),var_names_CLC,paste0("I(", var_names_CLC, "^2)"))
formula_GLM4=as.formula(paste("EMBCIT ~Longitude+Latitude+", paste(c(terms_GLM4,"Year") ,collapse = " + ")))
mdl_GLM4=glm(formula_GLM4, family = poisson(link = "log"), data = u)

## GAM4 model estimation
terms_BIO<- paste0("s(", var_names_BIO, ",k=4)")
terms_CLC<- paste0("s(", var_names_CLC, ",k=4)")
terms_GAM4<-unique(c(terms_BIO,terms_CLC))
formula_GAM4<- as.formula(paste("EMBCIT ~s(Longitude,k=4)+s(Latitude,k=4)+Year+", terms_GAM4 |> paste(collapse = " + ")))
mdl_GAM4=gam(formula_GAM4, family = poisson(link = "log"), data = u)

## Random Forest estimation
sel_var=c("EMBCIT","Latitude","Longitude","BIO1","BIO2",
          "CLC231","CLC211","CLC242","CLC311","CLC112","CLC243","CLC312","CLC313","CLC324" ) 
u2=u[,sel_var]
mdl_RF=randomForest(formula = EMBCIT ~ ., data = u2, ntree = 500,na.action = na.omit) 

## Calculation of estimation fitting variables
EmbCit=u[,"EMBCIT"]
EmbCit_estim_GLM4 <- predict(mdl_GLM4, newdata = u, type = "response")
FIT_estim_GLM4 <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GLM4) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
EmbCit_estim_GAM4 <- predict(mdl_GAM4, newdata = u, type = "response")
FIT_estim_GAM4 <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GAM4) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))
EmbCit_estim_RF <- predict(mdl_RF,u2)
FIT_estim_RF <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_RF) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))

## Calculation of validation fitting variables
# Simulation for the period 2002–2024
u_val <- read.csv("Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv")
EmbCit_sim_GLM4 <- predict(mdl_GLM4, newdata = u_val, type = "response")
EmbCit_sim_GAM4 <- predict(mdl_GAM4, newdata = u_val, type = "response")
EmbCit_sim_RF <- predict(mdl_RF, newdata = u_val, type = "response")

# Data storage for years > 2019
i <- 1
idx <- c()
for (j in 1:nrow(u_val)) {
  if (u_val[j,3]>2019){
    idx[i] <- j
    i <- i+1
  }
}
EmbCit_val <- u_val[idx, 2]
EmbCit_valid_GLM4 <- EmbCit_sim_GLM4[idx]
EmbCit_valid_GAM4 <- EmbCit_sim_GAM4[idx]
EmbCit_valid_RF <- EmbCit_sim_RF[idx]

FIT_valid_GLM4 <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GLM4) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
FIT_valid_GAM4 <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_GAM4) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))
FIT_valid_RF <- 100 * ( 1 - norm2(EmbCit_val - EmbCit_valid_RF) /norm2(EmbCit_val - mean(EmbCit_val, na.rm = TRUE)))

# Display of fittings - Table 4
cat("FIT on estimation data \n")
cat("GLM4 model:", FIT_estim_GLM4,"\n")
cat("GAM4 model:", FIT_estim_GAM4,"\n")
cat("Random Forest:", FIT_estim_RF,"\n")
cat("\n")
cat("FIT on validation data \n")
cat("GLM4 model:", FIT_valid_GLM4,"\n")
cat("GAM4 model:", FIT_valid_GAM4,"\n")
cat("Random Forest:", FIT_valid_RF,"\n")
