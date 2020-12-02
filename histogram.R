#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

filename <- args[1]
data <- read.delim(filename, sep = "")
hist(as.numeric(data$NMISS))