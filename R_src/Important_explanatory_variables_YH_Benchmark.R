# The Yellowhammer benchmark - Program for plotting the figures in Section 6.1. Most important explanatory variables
#   Alassani A., Ouvrard R., Poinot T., Martin O., 2026. Yellowhammer benchmark presentation. LIAS internal report
#   From the GitHub platform https://github.com/lias-laboratory/yellowhammer-benchmark
#   Updated on 1st June 2026

rm(list = ls())
library(randomForest)
library(ggplot2)
library(corrplot)

## Loading Yellowhammer data and BIO/CLC explanatory variables
u <- read.csv("Yellowhammer_Clim_Bioclim_CLC_2002_2024.csv")

## Figure 4: Random forest for CLC variables with R package ‘random-Forest’
# CLC explanatory variables
u2=u[,c(2,28:71)]
colnames(u2)
# Random Forest model
res=randomForest(formula = EMBCIT ~ ., data = u2, ntree = 500, na.action = na.omit)
# Bar graph
imp=res$importance[order(-res$importance),]
barplot(imp)
imp_df <- data.frame(variable = names(imp), importance = imp)
p <- ggplot(imp_df, aes(x = reorder(variable, importance), y = importance)) +
  geom_col(fill = "#0072B2") +
  coord_flip() +
  labs(x = "CLC variable", y = "Importance (permutation)", title = "Importance of CLC variables (Random Forest)") +
  theme_minimal()
ggsave("Fig4_Importance_CLC_variables.eps", plot = p, device = "eps")

## Figure 5: Random forest for BIO variables with R package ‘random-Forest’
# BIO explanatory variables
u2=u[,c(2,9:27)]
colnames(u2)
# Random Forest model
res=randomForest(formula = EMBCIT ~ ., data = u2, ntree = 500, na.action = na.omit)
# Bar graph
imp=res$importance[order(-res$importance),]
barplot(imp)
imp_df <- data.frame(variable = names(imp), importance = imp)
p <- ggplot(imp_df, aes(x = reorder(variable, importance), y = importance)) +
  geom_col(fill = "#0072B2") +
  coord_flip() +
  labs(x = "BIO variable", y = "Importance (permutation)", title = "Importance of BIO variables (Random Forest)") +
  theme_minimal()
ggsave("Fig5_Importance_BIO_variables.eps", plot = p, device = "eps")

## Figure 6: Correlation between habitat variables, bioclimatic variables and climatic variables
# Correlation of CLC variables
u2=u[,c("CLC231","CLC211","CLC242","CLC311","CLC112","CLC243","CLC312","CLC313","CLC324")]
corr=cor(u2)
colnames(corr)=rownames(corr)=colnames(u2)
round(corr,2)
corrplot(
  corr,
  method = "color",
  col = colorRampPalette(c("blue", "white", "red"))(200),
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  number.cex=1,
  tl.cex = 1,
)
dev.print(device = postscript, "Fig6a_Correlation_CLC_variables.eps", width = 8, height = 8)
# Correlation of BIO variables
u2=u[,c("BIO1","BIO10","BIO11","BIO2")]
corr=cor(u2)
colnames(corr)=rownames(corr)=colnames(u2)
round(corr,2)
corrplot(
  corr,
  method = "color",
  col = colorRampPalette(c("blue", "white", "red"))(200),
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  number.cex=2,
  tl.cex = 2,
)
dev.print(device = postscript, "Fig6b_Correlation_BIO_variables.eps", width = 8, height = 8)
# Correlation of climatic variables
u2=u[,c("prec","tmax","tmin")]
corr=cor(u2)
colnames(corr)=rownames(corr)=colnames(u2)
round(corr,2)
corrplot(
  corr,
  method = "color",
  col = colorRampPalette(c("blue", "white", "red"))(200),
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  number.cex=2.5,
  tl.cex = 2.5,
)
dev.print(device = postscript, "Fig6c_Correlation_climatic_variables.eps", width = 8, height = 8)
