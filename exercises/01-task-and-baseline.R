# Exercise 1: define a classification task and train the baseline

source("R/00-setup.R")
source("R/01-data.R")

development <- wnv_model_data[year <= 2024L]

features <- c(
  "cases_lag1", "cases_lag2", "cases_lag4", "cases_last4",
  "cases_last8", "active_weeks_last8", "week_sin", "week_cos", "region"
)

# 1. Create a TaskClassif called wnv_task.
# 2. Use activity_next_4w as the target and yes as the positive class.
# 3. Create classif.log_reg with probability predictions.
# 4. Train the learner and inspect it.

# Your code here.
