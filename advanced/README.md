# Optional advanced workflow

This folder preserves the earlier production-style workflow. It includes data
preparation, `mlr3`, three models, temporal resampling, threshold selection,
multiple performance measures and model interpretation.

Its exploration step also creates a `ggplot2` map of cumulative 2025 West Nile
virus disease counts. The map is labelled as provisional and not
population-adjusted, and is not used by the models.

It is useful as instructor reference or follow-up study, but it is not part of
the two-hour introductory workshop. The live workshop uses `R/workshop.R`.

To run this optional material from the project root:

```r
source("advanced/run-workflow.R")
```

Install its larger package set first if needed:

```r
source("advanced/install-packages.R")
```
