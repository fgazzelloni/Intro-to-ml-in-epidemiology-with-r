if (!exists("task_development")) source("R/03-task.R")

learner_tree <- lrn(
  "classif.rpart",
  id = "Decision tree",
  predict_type = "prob",
  cp = 0.01,
  maxdepth = 5,
  minsplit = 40,
  xval = 0
)

message("Decision tree learner defined with a shallow maximum depth.")
