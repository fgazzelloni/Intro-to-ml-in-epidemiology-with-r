if (!exists("task_development")) source("advanced/R/03-task.R")

learner_forest <- lrn(
  "classif.ranger",
  id = "Random forest",
  predict_type = "prob",
  num.trees = 500,
  mtry = 3,
  min.node.size = 10,
  importance = "permutation",
  respect.unordered.factors = "order",
  num.threads = 1,
  seed = 20260927
)

message("Random forest learner defined with reproducible settings.")
