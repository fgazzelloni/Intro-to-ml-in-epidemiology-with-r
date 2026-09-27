library(data.table)
source("R/utils.R")

predictions <- fread("outputs/holdout-predictions.csv")
forest <- predictions[model == "Random forest"]
thresholds <- c(0.05, 0.10, 0.20, 0.50)

result <- rbindlist(lapply(thresholds, function(x) {
  prediction_metrics(
    truth = forest$truth,
    probability = forest$probability,
    threshold = x,
    model = "Random forest"
  )
}))

print(result[, .(threshold, sensitivity, specificity, balanced_accuracy)])
