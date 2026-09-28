if (!exists("fitted_learners")) source("advanced/R/08-evaluation.R")

forest_importance <- data.table(
  feature = names(fitted_learners[["Random forest"]]$model$variable.importance),
  importance = unname(fitted_learners[["Random forest"]]$model$variable.importance)
)[order(importance)]

fwrite(forest_importance[order(-importance)], "outputs/random-forest-importance.csv")

p_importance <- ggplot(forest_importance, aes(importance, reorder(feature, importance))) +
  geom_col(fill = "#1B9E77") +
  labs(
    title = "Random-forest permutation importance",
    subtitle = "Importance supports prediction; it does not establish causation",
    x = "Decrease in predictive performance after permutation",
    y = NULL
  ) +
  workshop_theme()

ggsave("figures/05-variable-importance.png", p_importance, width = 8, height = 5.5, dpi = 160)

tree_model <- fitted_learners[["Decision tree"]]$model
png("figures/06-decision-tree.png", width = 1500, height = 900, res = 150)
if (requireNamespace("rpart.plot", quietly = TRUE)) {
  rpart.plot::rpart.plot(
    tree_model,
    type = 2,
    extra = 104,
    roundint = FALSE,
    fallen.leaves = TRUE,
    box.palette = "Purples"
  )
} else {
  plot(tree_model, uniform = TRUE, margin = 0.1)
  text(tree_model, use.n = TRUE, cex = 0.7)
}
dev.off()

logistic_coefficients <- data.table(
  term = names(stats::coef(fitted_learners[["Logistic regression"]]$model)),
  coefficient = unname(stats::coef(fitted_learners[["Logistic regression"]]$model))
)
fwrite(logistic_coefficients, "outputs/logistic-coefficients.csv")

interpretation_notes <- c(
  "Interpretation guardrails",
  "=========================",
  "",
  "1. Variable importance describes predictive contribution in this fitted model.",
  "2. It does not estimate a causal effect or identify a modifiable risk factor.",
  "3. Recent case counts partly reflect surveillance and reporting practices.",
  "4. State-week predictions do not identify the place where exposure occurred.",
  "5. The model omits weather, mosquito surveillance, population and intervention data.",
  "6. Use the 2025 results as a teaching demonstration, not an operational warning system."
)
writeLines(interpretation_notes, "outputs/interpretation-notes.txt")

message("Interpretation outputs saved. Predictive importance is not causal importance.")
