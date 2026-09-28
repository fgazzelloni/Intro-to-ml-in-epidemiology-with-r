# Introduction to Machine Learning in Epidemiology with R

This repository supports a two-hour R-Ladies Rome workshop led by Federica Gazzelloni.

Before the workshop, see the [R-Ladies Rome chapter introduction presentation](https://www.canva.com/design/DAHWamqing0/frTmZ74PJX4HukjQ-cOn8w/view?utm_content=DAHWamqing0&utm_campaign=designshare&utm_medium=link2&utm_source=uniquelinks&utlId=hca030ed1b4) for an introduction to the chapter, its community and its activities.

The workshop uses two complementary files:

1. [`ml-workflow.qmd`](ml-workflow.qmd) is the main teaching file. It explains
   how a model learns through loss and optimisation, including a batch gradient
   descent example, and then connects these ideas to an epidemiological
   prediction problem.
2. [`R/workshop.R`](R/workshop.R) is the shorter practice script for students.
   It uses one prepared dataset and one decision tree to follow a complete
   machine-learning workflow in R.

## The question

> Can recent surveillance data help us predict whether a U.S. state will report
> West Nile virus activity during the next four weeks?

The purpose is to understand what a model learns, how it makes a prediction and
why it must be checked on data it has not seen before.

## Before the workshop

1. Download or clone the repository.
2. Open `Intro-to-ml-in-epidemiology-with-r.Rproj` in RStudio.
3. Run `source("install-packages.R")` once.
4. Run `source("check-setup.R")` and look for `Workshop setup is ready.`

The installation script adds the two packages needed for the student practice:
`rpart` and `rpart.plot`.

## During the workshop

Start with [`ml-workflow.qmd`](ml-workflow.qmd). This is the instructor-led
explanation and the main workshop narrative.

### Content of `ml-workflow.qmd`

The teaching file moves from the mechanics of learning to an applied
epidemiology workflow:

1. **Model, loss, optimisation and learning**: distinguish the model from the
   measure of error and the procedure used to improve it.
2. **A small linear-regression example**: begin with a simple model,
   $\hat{y} = wx + b$, and initial parameter values.
3. **The loss function**: use mean squared error to measure the difference
   between observed and predicted values.
4. **Batch gradient descent**: calculate the gradients, update the slope and
   intercept, and repeat the process over several epochs as the loss falls.
5. **Comparison with `lm()`**: check that the parameters learned through
   gradient descent agree with the fitted linear model from base R.
6. **Why this matters for epidemiology**: connect the learning cycle to a real
   public-health prediction question.
7. **West Nile virus prediction task**: define the features and outcome, then
   split historical data into training and unseen test periods.
8. **Logistic regression**: predict the probability of future WNV activity and
   compare predicted classes with observed outcomes.
9. **Model comparison**: compare logistic regression, a decision tree and a
   random forest using the same holdout data.
10. **Visual evaluation**: inspect ROC curves, confusion matrices and a map of
    predicted probabilities.
11. **Interpretation and limits**: discuss generalisation, reporting systems
    and the difference between prediction and causation.

The central learning cycle is:

```text
data -> model -> predictions -> loss -> update -> repeat -> evaluation
```

Students then work through [`R/workshop.R`](R/workshop.R), either section by
section in RStudio or as a complete script:

```r
source("R/workshop.R")
```

The practice workflow is:

```text
Ask a question
-> meet the data
-> define the outcome and predictors
-> split the data into training and test sets
-> train one decision tree
-> make predictions
-> compare predictions with observed outcomes
-> discuss limits
```

The script uses ordinary R functions and two established package functions:

- `rpart()` trains the decision tree;
- `rpart.plot()` displays the tree.

There are no custom helper functions, model-tuning loops or framework-specific
task objects in the student practice script.

After the guided practice, students can use
[`exercises/workshop-exercise.R`](exercises/workshop-exercise.R). The completed
version is in [`solutions/workshop-exercise.R`](solutions/workshop-exercise.R).

## What participants learn

- Machine learning uses data to learn model parameters or structure.
- A loss function measures how far predictions are from observed values.
- Gradient descent updates model parameters in the direction that reduces loss.
- An epoch is one complete gradient update using the training data in the batch
  example.
- The outcome is what we want to predict.
- Predictors are the information available to the model.
- Training data are used to learn patterns.
- Test data are used to check predictions on unseen observations.
- A confusion matrix shows correct and incorrect predictions.
- Prediction is not causation.
- Surveillance data reflect reporting systems as well as disease occurrence.

## Repository structure

```text
ml-workflow.qmd                  main instructor-led explanation
R/workshop.R                    student practice workflow
exercises/workshop-exercise.R   participant exercise
solutions/workshop-exercise.R   completed exercise
install-packages.R              student package installation
check-setup.R                   pre-workshop setup check
data/processed/                 prepared teaching dataset
data/raw/                       frozen source-data snapshot
figures/                        teaching figures
outputs/                        saved model results
references/                     article and source notes
app.R                           optional interactive demonstration
_bunk/                          earlier drafts and experiments, not used live
```

The files in `_bunk/` are retained for reference but are not part of the current
workshop route.

## Data and limits

The supplied dataset is derived from the CDC National Notifiable Diseases
Surveillance System weekly West Nile virus disease data.

- Observation: U.S. state x MMWR week.
- Workshop weeks: 18-44, when most reported activity occurs.
- Outcome: whether at least one case is reported in the following four weeks.
- Predictors: week, recent case count, recent active weeks and census region.
- Training period: 2022-2024.
- Test period: 2025.

This is a teaching example, not an operational early-warning system. The counts
are provisional, reported activity is not the true infection process, and good
prediction does not establish a causal relationship.

See [`data/DATASET_RECOMMENDATION.md`](data/DATASET_RECOMMENDATION.md) for the
dataset decision and [`references/sources.md`](references/sources.md) for the
source list. The methodological article used in the teaching material is saved
as [`references/ml-in-epidemiology-article.pdf`](references/ml-in-epidemiology-article.pdf).

## Additional packages for the teaching file

The instructor needs these additional packages to run or render every section
of `ml-workflow.qmd`:

```r
install.packages(c(
  "ggplot2", "dplyr", "data.table", "maps", "pROC",
  "mlr3", "mlr3learners", "ranger"
))
```

These packages are not required for the shorter student practice in
`R/workshop.R`.
