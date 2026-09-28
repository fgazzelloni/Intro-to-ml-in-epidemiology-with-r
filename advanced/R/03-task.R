if (!exists("wnv_model_data")) source("advanced/R/01-data.R")

model_features <- c(
  "cases_lag1", "cases_lag2", "cases_lag4", "cases_last4",
  "cases_last8", "active_weeks_last8", "week_sin", "week_cos", "region"
)
target_column <- "activity_next_4w"

development_data <- wnv_model_data[year <= 2024L]
holdout_data <- wnv_model_data[year == 2025L]

task_development <- TaskClassif$new(
  id = "wnv-development-2022-2024",
  backend = development_data[, c(target_column, model_features), with = FALSE],
  target = target_column,
  positive = "yes"
)

task_holdout <- TaskClassif$new(
  id = "wnv-holdout-2025",
  backend = holdout_data[, c(target_column, model_features), with = FALSE],
  target = target_column,
  positive = "yes"
)

# Expanding-window validation: train on earlier years and validate on the next.
# This keeps later weeks out of the training set for every validation fold.
validation_years <- c(2023L, 2024L)
train_sets <- lapply(validation_years, function(y) which(development_data$year < y))
test_sets <- lapply(validation_years, function(y) which(development_data$year == y))

temporal_resampling <- rsmp("custom")
temporal_resampling$instantiate(task_development, train_sets, test_sets)

stopifnot(all(vapply(seq_along(validation_years), function(i) {
  max(development_data$year[temporal_resampling$train_set(i)]) <
    min(development_data$year[temporal_resampling$test_set(i)])
}, logical(1))))

message(
  "Task ready: ", task_development$nrow, " development rows and ",
  task_holdout$nrow, " unseen 2025 rows."
)
