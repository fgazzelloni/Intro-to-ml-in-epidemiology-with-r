# Introduction to Machine Learning in Epidemiology with R

This repository contains the reproducible code workflow for a two-hour R-Ladies Rome workshop led by Federica Gazzelloni.

## Workshop presentation

[Download the workshop presentation](slides/output/introduction-to-ml-in-epidemiology-with-r.pptx).

The workshop follows one question from start to finish:

> Can recent surveillance data help us predict whether a U.S. state will report West Nile virus activity during the next four weeks, and how do we judge whether the prediction is useful?

The workflow uses the modern [`mlr3`](https://mlr3.mlr-org.com/) ecosystem and compares three learners:

1. logistic regression as an interpretable baseline;
2. a decision tree;
3. a random forest.

The emphasis is the workflow—not a long list of algorithms:

```text
epidemiological question
→ data and data quality
→ prediction task
→ time-aware validation
→ baseline and flexible models
→ evaluation on unseen data
→ interpretation and limitations
```

## Data and prediction target

The source is the CDC National Notifiable Diseases Surveillance System (NNDSS) weekly dataset, filtered to `Arboviral diseases, West Nile virus disease`.

- Observation: state × MMWR week.
- Outcome: `yes` when at least one West Nile virus disease case is reported in the following four weeks; otherwise `no`.
- Predictors: lagged and rolling case counts, recent active weeks, week-of-year seasonality and U.S. census region.
- Development period: 2022–2024.
- Unseen test period: 2025.
- Validation: expanding time windows—2022 predicts 2023, then 2022–2023 predicts 2024.

The 2026 rows are partial and are never used for model fitting or evaluation. They only provide the four-week outcome for state-weeks at the end of 2025.

This is a teaching dataset, not an operational early-warning system. NNDSS weekly counts are provisional and can change. Reported surveillance activity is not the same as the true infection process.

## Run the complete workflow

From the project root:

```r
source("install-packages.R") # only if packages are missing
source("run-workflow.R")
```

The repository contains a frozen CDC snapshot so the live workshop does not depend on network access. To refresh it deliberately:

```r
Sys.setenv(REFRESH_CDC_DATA = "true")
source("run-workflow.R")
```

Refreshing can change results because CDC revises provisional data. Keep the supplied snapshot for a fully repeatable workshop run.

## Code sequence

| Script | Purpose |
|---|---|
| `R/00-setup.R` | Check packages, folders and reproducible settings |
| `R/01-data.R` | Read CDC data, interpret flags, combine New York reporting areas and create leakage-safe features |
| `R/02-exploration.R` | Examine class balance and seasonality |
| `R/03-task.R` | Create the `mlr3` task, untouched test year and temporal validation folds |
| `R/04-logistic-regression.R` | Define the baseline learner |
| `R/05-decision-tree.R` | Define a shallow decision tree |
| `R/06-random-forest.R` | Define a reproducible random forest |
| `R/07-resampling.R` | Compare models with expanding-window validation and choose thresholds without using 2025 |
| `R/08-evaluation.R` | Train on 2022–2024 and evaluate once on 2025 |
| `R/09-interpretation.R` | Inspect coefficients, a tree and permutation importance |

## Repository structure

```text
R/              modular workshop code
data/raw/       frozen CDC source snapshot
data/processed/ generated modelling dataset
exercises/      participant exercises
solutions/      complete solutions
figures/        generated teaching figures
outputs/        generated tables, predictions and session information
references/     source and reading notes
```

## Teaching messages

- Prediction is not inference.
- Prediction is not causation.
- Variable importance is not causal importance.
- A more complex model is not automatically better.
- Performance must be evaluated on data not used to train or tune the model.
- Random cross-validation would leak temporal information in this example.
- Sensitivity and specificity depend on the classification threshold; ROC AUC does not choose an operational threshold.
- Surveillance data reflect reporting systems as well as disease occurrence.

## Context

Federica's 2025 book, *Health Metrics and the Spread of Infectious Diseases*, presents machine-learning applications using the earlier `mlr` framework. This workshop carries the same epidemiological-first approach into `mlr3`, the modern successor used by Wright et al. (2026).

See [DATASET_RECOMMENDATION.md](DATASET_RECOMMENDATION.md) for the dataset decision and [references/sources.md](references/sources.md) for sources and caveats.

Learn more about the community on the [R-Ladies Rome website](https://rladiesrome.org/).

Chapter introduction: [R-Ladies Rome presentation](https://canva.link/hlxw2in5fwbosy2).
