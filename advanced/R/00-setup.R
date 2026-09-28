source("advanced/R/utils.R")

check_project_root()
check_workshop_packages()
ensure_workshop_directories()

options(
  stringsAsFactors = FALSE,
  datatable.print.nrows = 20,
  width = 100
)
set.seed(20260927)

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(mlr3)
  library(mlr3learners)
})

message("Workshop environment is ready.")
