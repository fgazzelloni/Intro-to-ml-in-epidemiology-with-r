# Packages used in the live introductory workshop.
required <- c("rpart", "rpart.plot")

missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing) == 0L) {
  message("The workshop packages are already installed.")
} else {
  install.packages(missing, repos = "https://cloud.r-project.org")
}
