#! /usr/bin/env Rscript

library("sleuth")
k <- read_kallisto("abundance.h5")
save(k, file = "./kallisto_sleuth.RData")
