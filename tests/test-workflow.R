library(data.table)

required_files <- c(
  "data/processed/wnv_state_week.csv",
  "outputs/data-quality-summary.csv",
  "outputs/validation-fold-scores.csv",
  "outputs/selected-thresholds.csv",
  "outputs/holdout-performance.csv",
  "outputs/holdout-predictions.csv",
  "outputs/random-forest-importance.csv",
  "figures/01-class-balance.png",
  "figures/02-seasonality.png",
  "figures/03-holdout-roc.png",
  "figures/04-confusion-matrices.png",
  "figures/05-variable-importance.png",
  "figures/06-decision-tree.png"
)

stopifnot(all(file.exists(required_files)))
stopifnot(all(file.info(required_files)$size > 0))

model_data <- fread("data/processed/wnv_state_week.csv")
performance <- fread("outputs/holdout-performance.csv")
thresholds <- fread("outputs/selected-thresholds.csv")

stopifnot(nrow(model_data) == 10239L)
stopifnot(uniqueN(model_data$state) == 51L)
stopifnot(setequal(unique(model_data$year), 2022:2025))
stopifnot(setequal(unique(performance$model), c(
  "Logistic regression", "Decision tree", "Random forest"
)))
stopifnot(all(performance$auc >= 0 & performance$auc <= 1))
stopifnot(all(performance$sensitivity >= 0 & performance$sensitivity <= 1))
stopifnot(all(performance$specificity >= 0 & performance$specificity <= 1))
stopifnot(all(thresholds$threshold >= 0.02 & thresholds$threshold <= 0.50))

cat("All workflow checks passed.\n")
