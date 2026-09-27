if (!exists("resample_results")) source("R/07-resampling.R")

fitted_learners <- lapply(learners, function(learner) {
  learner <- learner$clone(deep = TRUE)
  learner$train(task_development)
  learner
})

holdout_predictions <- rbindlist(lapply(names(fitted_learners), function(model_name) {
  prediction <- fitted_learners[[model_name]]$predict(task_holdout)
  threshold <- selected_thresholds[model == model_name, threshold]
  data.table(
    model = model_name,
    row_id = holdout_data$row_id,
    state = holdout_data$state,
    year = holdout_data$year,
    week = holdout_data$week,
    truth = prediction$truth,
    probability = prediction$prob[, "yes"],
    response = factor(
      ifelse(prediction$prob[, "yes"] >= threshold, "yes", "no"),
      levels = c("no", "yes")
    ),
    threshold = threshold
  )
}))

holdout_metrics <- rbindlist(lapply(
  split(holdout_predictions, by = "model", keep.by = TRUE),
  function(x) prediction_metrics(
    truth = x$truth,
    probability = x$probability,
    threshold = unique(x$threshold),
    model = unique(x$model)
  )
))

fwrite(holdout_predictions, "outputs/holdout-predictions.csv")
fwrite(holdout_metrics, "outputs/holdout-performance.csv")

roc_objects <- lapply(split(holdout_predictions, by = "model"), function(x) {
  pROC::roc(x$truth, x$probability, levels = c("no", "yes"), quiet = TRUE)
})

p_roc <- pROC::ggroc(roc_objects, legacy.axes = TRUE, linewidth = 0.9) +
  geom_abline(intercept = 0, slope = 1, linetype = 2, colour = "grey55") +
  labs(
    title = "Performance on the unseen 2025 data",
    subtitle = "ROC curves compare probability rankings across all classification thresholds",
    x = "False-positive rate (1 - specificity)",
    y = "Sensitivity",
    colour = "Model"
  ) +
  coord_equal() +
  workshop_theme()

ggsave("figures/03-holdout-roc.png", p_roc, width = 8, height = 6, dpi = 160)

confusion_data <- holdout_predictions[
  , .N,
  by = .(model, truth, response)
]
confusion_grid <- CJ(
  model = names(fitted_learners),
  truth = c("no", "yes"),
  response = c("no", "yes"),
  unique = TRUE
)
confusion_data <- merge(
  confusion_grid,
  confusion_data,
  by = c("model", "truth", "response"),
  all.x = TRUE
)
confusion_data[is.na(N), N := 0L]
confusion_data[, `:=`(
  truth = factor(truth, levels = c("no", "yes")),
  response = factor(response, levels = c("no", "yes"))
)]

p_confusion <- ggplot(confusion_data, aes(response, truth, fill = N)) +
  geom_tile(colour = "white") +
  geom_text(aes(label = N), fontface = "bold") +
  scale_fill_gradient(low = "#F3EAF6", high = "#6A3D9A") +
  facet_wrap(~ model) +
  labs(
    title = "Confusion matrices on the unseen 2025 data",
    subtitle = "Thresholds were chosen on 2023-2024 validation data, not on 2025",
    x = "Predicted class",
    y = "Observed class",
    fill = "Weeks"
  ) +
  workshop_theme() +
  guides(fill = "none")

ggsave("figures/04-confusion-matrices.png", p_confusion, width = 10, height = 4.8, dpi = 160)

message("Final model evaluation completed on the untouched 2025 holdout set.")
print(holdout_metrics)
