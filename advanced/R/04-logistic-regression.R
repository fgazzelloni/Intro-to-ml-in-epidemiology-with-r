if (!exists("task_development")) source("advanced/R/03-task.R")

learner_logistic <- lrn(
  "classif.log_reg",
  id = "Logistic regression",
  predict_type = "prob"
)

message("Logistic regression learner defined as the interpretable baseline.")
