# Check that the introductory workshop can run from this folder.

required_files <- c(
  "R/workshop.R",
  "data/processed/wnv_state_week.csv",
  "exercises/workshop-exercise.R",
  "solutions/workshop-exercise.R"
)

missing_files <- required_files[!file.exists(required_files)]

if (length(missing_files) > 0L) {
  stop(
    "Workshop files are missing. Open the .Rproj file and try again: ",
    paste(missing_files, collapse = ", ")
  )
}

required_packages <- c("rpart", "rpart.plot")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_packages) > 0L) {
  stop(
    "Workshop packages are missing. Run source(\"install-packages.R\"): ",
    paste(missing_packages, collapse = ", ")
  )
}

wnv <- read.csv("data/processed/wnv_state_week.csv")
required_columns <- c(
  "state", "region", "year", "week", "cases_last4",
  "active_weeks_last8", "activity_next_4w"
)

if (!all(required_columns %in% names(wnv))) {
  stop("The prepared dataset does not have the expected workshop columns.")
}

message("Workshop setup is ready.")
