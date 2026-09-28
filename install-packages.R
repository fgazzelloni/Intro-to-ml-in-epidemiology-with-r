# Packages used across the workshop project.
required <- c(
  "shiny",
  "ggplot2",
  "dplyr",
  "data.table",
  "maps",
  "pROC",
  "mlr3",
  "mlr3learners",
  "rpart",
  "rpart.plot"
)

missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing) == 0L) {
  message("All workshop packages are already installed.")
} else {
  install.packages(missing, repos = "https://cloud.r-project.org")
}
