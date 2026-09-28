scripts <- c(
  "advanced/R/00-setup.R",
  "advanced/R/01-data.R",
  "advanced/R/02-exploration.R",
  "advanced/R/03-task.R",
  "advanced/R/04-logistic-regression.R",
  "advanced/R/05-decision-tree.R",
  "advanced/R/06-random-forest.R",
  "advanced/R/07-resampling.R",
  "advanced/R/08-evaluation.R",
  "advanced/R/09-interpretation.R"
)

for (script in scripts) {
  message("\n--- Running ", script, " ---")
  source(script, local = globalenv())
}

session_lines <- sub("[[:space:]]+$", "", capture.output(sessionInfo()))
writeLines(session_lines, "outputs/session-info.txt")
message("\nWorkflow complete. See figures/ and outputs/.")
