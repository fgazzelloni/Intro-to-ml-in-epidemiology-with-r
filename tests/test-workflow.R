required_files <- c(
  "figures/intro-01-outcome.png",
  "figures/intro-02-decision-tree.png",
  "outputs/intro-predictions.csv",
  "outputs/intro-confusion-matrix.csv",
  "outputs/intro-performance.csv"
)

stopifnot(all(file.exists(required_files)))
stopifnot(all(file.info(required_files)$size > 0))

predictions <- read.csv("outputs/intro-predictions.csv")
confusion <- read.csv("outputs/intro-confusion-matrix.csv")
performance <- read.csv("outputs/intro-performance.csv")

stopifnot(nrow(predictions) == 1377L)
stopifnot(all(c("outcome", "probability_yes", "predicted") %in% names(predictions)))
stopifnot(all(predictions$probability_yes >= 0 & predictions$probability_yes <= 1))
stopifnot(sum(confusion$Freq) == nrow(predictions))
stopifnot(setequal(performance$measure, c("accuracy", "sensitivity", "specificity")))
stopifnot(all(performance$value >= 0 & performance$value <= 1))

cat("All introductory workflow checks passed.\n")
