source("advanced/R/00-setup.R")
source("advanced/R/01-data.R")

development <- wnv_model_data[year <= 2024L]
features <- c(
  "cases_lag1", "cases_lag2", "cases_lag4", "cases_last4",
  "cases_last8", "active_weeks_last8", "week_sin", "week_cos", "region"
)

wnv_task <- TaskClassif$new(
  id = "wnv-exercise",
  backend = development[, c("activity_next_4w", features), with = FALSE],
  target = "activity_next_4w",
  positive = "yes"
)

baseline <- lrn("classif.log_reg", predict_type = "prob")
baseline$train(wnv_task)
print(baseline)
