# Introduction to Machine Learning in Epidemiology with R

This repository supports a two-hour R-Ladies Rome workshop led by Federica
Gazzelloni.

The workshop is an introduction to **machine learning**. Participants use
one prepared epidemiological dataset and one decision tree to understand the
main ideas.

## The question

> Can recent surveillance data help us predict whether a U.S. state will report
> West Nile virus activity during the next four weeks?

The purpose is to understand what a model learns, how it makes a prediction and
why it must be checked on data it has not seen before.

## The workshop workflow

```text
Ask a question
→ meet the data
→ define the outcome and predictors
→ split the data into training and test sets
→ train one decision tree
→ make predictions
→ compare predictions with observed outcomes
→ discuss limits
```

The main script uses ordinary R functions and two established package functions:

- `rpart()` trains the decision tree;
- `rpart.plot()` displays the tree.

There are no custom helper functions, model-tuning loops or framework-specific
task objects in the live workshop.

## Run the workshop code

Install the two packages once, if needed:

```r
source("install-packages.R")
```

Then run the complete example:

```r
source("run-workflow.R")
```

The code is in [`R/workshop.R`](R/workshop.R). It reads the prepared dataset,
uses 2022–2024 as training data and keeps 2025 as unseen test data.

## What participants learn

- Machine learning looks for patterns that help predict an outcome.
- The outcome is what we want to predict.
- Predictors are the information available to the model.
- Training data are used to learn the pattern.
- Test data are used to check the pattern on unseen observations.
- A confusion matrix shows correct and incorrect predictions.
- Prediction is not causation.
- Surveillance data reflect reporting systems as well as disease occurrence.

## Repository structure

```text
R/workshop.R                    short live-workshop script
data/processed/                 prepared teaching dataset
exercises/workshop-exercise.R   short participant exercise
solutions/workshop-exercise.R   exercise solution
figures/                        generated teaching figures
outputs/                        generated predictions and evaluation results
advanced/                       optional production-style workflow
app.R                           optional gradient-descent Shiny demonstration
ml-learning-workflow.qmd        optional conceptual learning companion
```

The material in `advanced/` is preserved for instructor reference. It uses
`mlr3`, three models, temporal resampling, threshold selection and detailed
evaluation. It is intentionally excluded from the two-hour introduction.

The Shiny demonstration and conceptual notebook are optional teaching
companions.

## Data and limits

The supplied dataset is derived from the CDC National Notifiable Diseases
Surveillance System weekly West Nile virus disease data.

- Observation: U.S. state × MMWR week.
- Workshop weeks: 18–44, when most reported activity occurs.
- Outcome: whether at least one case is reported in the following four weeks.
- Predictors: week, recent case count, recent active weeks and census region.

This is a teaching example, not an operational early-warning system. The counts
are provisional, reported activity is not the true infection process, and good
prediction does not establish a causal relationship.

See [`DATASET_RECOMMENDATION.md`](DATASET_RECOMMENDATION.md) for the dataset
decision and [`references/sources.md`](references/sources.md) for sources.

## Context

Federica's 2025 book, *Health Metrics and the Spread of Infectious Diseases*,
includes machine-learning applications in R. Wright et al. (2026), *Machine
Learning in Epidemiology*, provides a current methodological reference. They are
introduced as further resources; their more advanced code is not required for
this introductory session.
