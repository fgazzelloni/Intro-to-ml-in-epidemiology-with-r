if (!exists("learner_logistic")) source("advanced/R/04-logistic-regression.R")
if (!exists("learner_tree")) source("advanced/R/05-decision-tree.R")
if (!exists("learner_forest")) source("advanced/R/06-random-forest.R")

learners <- list(learner_logistic, learner_tree, learner_forest)
names(learners) <- vapply(learners, function(x) x$id, character(1))

validation_measures <- msrs(c(
  "classif.auc", "classif.bacc", "classif.sensitivity", "classif.specificity"
))

set.seed(20260927)
resample_results <- lapply(learners, function(learner) {
  resample(
    task = task_development,
    learner = learner,
    resampling = temporal_resampling,
    store_models = FALSE
  )
})

validation_fold_scores <- rbindlist(lapply(names(resample_results), function(model_name) {
  scores <- resample_results[[model_name]]$score(validation_measures)
  scores[, model := model_name]
  scores[, validation_year := validation_years[iteration]]
  scores[, .(
    model, validation_year,
    auc = classif.auc,
    balanced_accuracy_at_0_5 = classif.bacc,
    sensitivity_at_0_5 = classif.sensitivity,
    specificity_at_0_5 = classif.specificity
  )]
}), use.names = TRUE)

validation_predictions <- rbindlist(lapply(names(resample_results), function(model_name) {
  pred <- as.data.table(resample_results[[model_name]]$prediction())
  data.table(
    model = model_name,
    row_id = pred$row_ids,
    truth = pred$truth,
    probability = pred$prob.yes
  )
}))

selected_thresholds <- validation_predictions[
  , choose_threshold(truth, probability),
  by = model
]

fwrite(validation_fold_scores, "outputs/validation-fold-scores.csv")
fwrite(selected_thresholds, "outputs/selected-thresholds.csv")

message("Temporal validation completed. Thresholds were selected using validation years only.")
print(validation_fold_scores)
print(selected_thresholds)
