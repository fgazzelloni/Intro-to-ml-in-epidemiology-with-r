# Exercise 3: see how a threshold changes sensitivity and specificity

library(data.table)
source("R/utils.R")

predictions <- fread("outputs/holdout-predictions.csv")
forest <- predictions[model == "Random forest"]

thresholds <- c(0.05, 0.10, 0.20, 0.50)

# Complete this expression. Use prediction_metrics() once for each threshold.
# result <- rbindlist(lapply(thresholds, function(x) {
#   prediction_metrics(...)
# }))

# Which threshold gives the greatest sensitivity?
# What happens to specificity as the threshold is lowered?
