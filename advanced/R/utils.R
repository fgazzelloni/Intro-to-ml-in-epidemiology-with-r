workshop_packages <- c(
  "data.table", "ggplot2", "mlr3", "mlr3learners", "pROC",
  "ranger", "rpart", "scales", "maps"
)

check_workshop_packages <- function(packages = workshop_packages) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0L) {
    stop(
      "Install the missing packages before continuing: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

check_project_root <- function() {
  if (!file.exists("PROJECT_BRIEF.md")) {
    stop(
      "Run this workflow from the project root (the folder containing PROJECT_BRIEF.md).",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

ensure_workshop_directories <- function() {
  dirs <- c("data/raw", "data/processed", "figures", "outputs")
  invisible(lapply(dirs, dir.create, recursive = TRUE, showWarnings = FALSE))
}

cdc_wnv_url <- paste0(
  "https://data.cdc.gov/resource/x9gk-5huc.csv?",
  "%24select=states%2Cyear%2Cweek%2Clabel%2Cm1%2Cm1_flag%2C",
  "m2%2Cm2_flag%2Cm3%2Cm3_flag%2Cm4%2Cm4_flag%2Clocation1%2C",
  "location2%2Csort_order&",
  "%24where=label%3D%27Arboviral%20diseases%2C%20West%20Nile%20virus%20disease%27&",
  "%24order=year%2Cweek%2Csort_order&%24limit=50000"
)

download_cdc_snapshot <- function(
    path = "data/raw/cdc_nndss_wnv_weekly_2022_2026.csv") {
  tmp <- tempfile(fileext = ".csv")
  on.exit(unlink(tmp), add = TRUE)
  utils::download.file(cdc_wnv_url, tmp, mode = "wb", quiet = FALSE)
  if (file.info(tmp)$size < 1000) {
    stop("The CDC download is unexpectedly small; the existing snapshot was not replaced.")
  }
  file.copy(tmp, path, overwrite = TRUE)
  invisible(path)
}

flagged_case_count <- function(value, flag) {
  data.table::fcase(
    !is.na(value), as.numeric(value),
    flag == "-", 0,
    default = NA_real_
  )
}

state_region_lookup <- function() {
  lookup <- data.table::data.table(
    state = toupper(state.name),
    region = as.character(state.region)
  )
  lookup <- data.table::rbindlist(list(
    lookup,
    data.table::data.table(state = "DISTRICT OF COLUMBIA", region = "South")
  ))
  lookup[, region := factor(region, levels = c("Northeast", "South", "North Central", "West"))]
  lookup
}

balanced_accuracy_at <- function(truth, probability, threshold) {
  truth <- factor(truth, levels = c("no", "yes"))
  response <- factor(ifelse(probability >= threshold, "yes", "no"), levels = levels(truth))
  tp <- sum(truth == "yes" & response == "yes")
  fn <- sum(truth == "yes" & response == "no")
  tn <- sum(truth == "no" & response == "no")
  fp <- sum(truth == "no" & response == "yes")
  sensitivity <- tp / (tp + fn)
  specificity <- tn / (tn + fp)
  mean(c(sensitivity, specificity))
}

choose_threshold <- function(truth, probability, grid = seq(0.02, 0.50, by = 0.01)) {
  scores <- vapply(
    grid,
    function(x) balanced_accuracy_at(truth, probability, x),
    numeric(1)
  )
  best <- which.max(scores)
  data.table::data.table(threshold = grid[best], validation_bacc = scores[best])
}

prediction_metrics <- function(truth, probability, threshold, model) {
  truth <- factor(truth, levels = c("no", "yes"))
  response <- factor(ifelse(probability >= threshold, "yes", "no"), levels = levels(truth))
  tp <- sum(truth == "yes" & response == "yes")
  fn <- sum(truth == "yes" & response == "no")
  tn <- sum(truth == "no" & response == "no")
  fp <- sum(truth == "no" & response == "yes")
  roc_object <- pROC::roc(truth, probability, levels = c("no", "yes"), quiet = TRUE)

  data.table::data.table(
    model = model,
    threshold = threshold,
    auc = as.numeric(pROC::auc(roc_object)),
    sensitivity = tp / (tp + fn),
    specificity = tn / (tn + fp),
    balanced_accuracy = mean(c(tp / (tp + fn), tn / (tn + fp))),
    accuracy = (tp + tn) / length(truth),
    positive_predictive_value = if ((tp + fp) == 0) NA_real_ else tp / (tp + fp),
    negative_predictive_value = if ((tn + fn) == 0) NA_real_ else tn / (tn + fn),
    tp = tp,
    fn = fn,
    tn = tn,
    fp = fp
  )
}

workshop_theme <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title.position = "plot",
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "bottom"
    )
}
