required <- c(
  "data.table", "ggplot2", "mlr3", "mlr3learners", "pROC",
  "ranger", "rpart", "rpart.plot", "scales", "maps"
)

missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing) == 0L) {
  message("All advanced-workflow packages are already installed.")
} else {
  message("Installing: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = "https://cloud.r-project.org")
}
