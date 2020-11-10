data <- read.delim("~/Desktop/GWAS_results_Depression.txt", sep = "")
hist(as.numeric(data$NMISS))