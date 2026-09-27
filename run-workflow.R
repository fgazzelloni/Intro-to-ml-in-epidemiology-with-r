scripts <- c(
  "R/00-setup.R",
  "R/01-data.R",
  "R/02-exploration.R",
  "R/03-task.R",
  "R/04-logistic-regression.R",
  "R/05-decision-tree.R",
  "R/06-random-forest.R",
  "R/07-resampling.R",
  "R/08-evaluation.R",
  "R/09-interpretation.R"
)

for (script in scripts) {
  message("\n--- Running ", script, " ---")
  source(script, local = globalenv())
}

writeLines(capture.output(sessionInfo()), "outputs/session-info.txt")
message("\nWorkflow complete. See figures/ and outputs/.")
