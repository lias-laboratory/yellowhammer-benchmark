# The Yellowhammer benchmark - Program for the final GLM4 model estimation in Section 6.4. Final model
#   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
#   From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
#   Updated on 1st June 2026

rm(list = ls())

## Useful function
norm2 <- function(x) sqrt(sum(x^2, na.rm = TRUE))

## Loading Yellowhammer data and explanatory variables
u <- read.csv("Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv")

## Selected CLC & BIO explanatory variables
var_names_CLC <- c("CLC231", "CLC211", "CLC242", "CLC311", "CLC112", "CLC243", "CLC312","CLC313" , "CLC324")
var_names_BIO <- c("BIO1","BIO2")

## GLM4 model estimation
terms_GLM4<-c(var_names_BIO,paste0("I(", var_names_BIO, "^2)"),var_names_CLC,paste0("I(", var_names_CLC, "^2)"))
formula_GLM4=as.formula(paste("EMBCIT ~Longitude+Latitude+", paste(c(terms_GLM4,"Year") ,collapse = " + ")))
mdl_GLM4=glm(formula_GLM4, family = poisson(link = "log"), data = u)

## Calculation of estimation fitting variable
EmbCit=u[,"EMBCIT"]
EmbCit_estim_GLM4 <- predict(mdl_GLM4, newdata = u, type = "response")
FIT_estim_GLM4 <- 100 * ( 1 - norm2(EmbCit - EmbCit_estim_GLM4) /norm2(EmbCit - mean(EmbCit, na.rm = TRUE)))

## Saving GLM4 model parameters for niche model simulation with Matlab
coefficients <- coef(mdl_GLM4)
Variable_names <- names(coefficients)
write.table(coefficients, file = "Coef_GLM_final_model.txt", sep = "\t", row.names = FALSE)
write.table(Variable_names, file = "Names_GLM_final_model.txt", sep = "\t", row.names = FALSE)

# Display of fitting
cat("FIT of the final GLM4 model:",FIT_estim_GLM4,"\n")