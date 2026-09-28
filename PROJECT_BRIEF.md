# Introduction to Machine Learning in Epidemiology with R

## Revised scope after code review

This is a two-hour introduction to machine learning, not an advanced R coding
course. The earlier workflow was too articulated for the available time: it
combined custom helper functions, three models, temporal resampling, threshold
selection and several evaluation procedures.

The revised workshop uses one prepared dataset, one small decision tree and
short blocks of ordinary R code. The code supports the explanation; it is not
the main teaching subject.

## Purpose

Help participants with basic R knowledge understand what supervised machine
learning does in an epidemiological setting.

By the end, participants should be able to explain:

1. what an outcome and a predictor are;
2. why data are divided into training and test sets;
3. what a model learns from training data;
4. how predictions are compared with observed outcomes;
5. why prediction is not causation.

## Teaching question

Can recent surveillance data help us predict whether a U.S. state will report
West Nile virus activity during the next four weeks?

## Dataset

Use the prepared CDC NNDSS West Nile virus state-week dataset already included
in the repository. Do not teach the raw-data engineering during the live
session.

For clarity, use only mosquito-season weeks and these variables:

- `week`;
- `recent_cases`;
- `recent_active_weeks`;
- `region`;
- `outcome`.

Use 2022–2024 for training and 2025 for testing. This makes the idea of unseen
data concrete without teaching cross-validation.

## Model

Use one shallow decision tree with `rpart()`.

A tree is suitable for the introduction because participants can see its
questions and follow a prediction from the top of the tree to a final class.
Random forests, tuning and model comparison are out of scope.

## Code principles

- One main script: `R/workshop.R`.
- No custom helper functions.
- No `mlr3` task, learner, resampling or benchmark objects in the live code.
- No tuning loops.
- Use familiar base R functions such as `read.csv()`, `subset()`, `table()` and
  `predict()`.
- Use `rpart()` to fit the tree and `rpart.plot()` to display it.
- Keep each code block connected to one teaching idea.

## Two-hour structure

```text
00–10  Welcome and R-Ladies Rome introduction
10–25  What machine learning is—and is not
25–40  Meet the West Nile surveillance dataset
40–55  Outcome, predictors, observations and the prediction question
55–70  Training data and unseen test data
70–90  Train and visualise one decision tree
90–105 Make predictions and read a confusion matrix
105–115 Interpretation, imbalance, surveillance bias and causality
115–120 Key messages, resources and questions
```

## Essential messages

- Machine learning learns patterns from examples in data.
- Performance must be checked on observations not used for training.
- Accuracy alone can be misleading when the outcome is uncommon.
- Prediction is not inference.
- Prediction is not causation.
- Surveillance data reflect reporting systems as well as disease occurrence.
- A technically correct model can still answer the wrong epidemiological
  question.

## Further study

The earlier production-style workflow is preserved in `advanced/`. It is useful
after the workshop for readers who want `mlr3`, multiple models, temporal
resampling, threshold selection and more detailed evaluation.

Main references:

1. Wright et al. (2026), *Machine Learning in Epidemiology*.
2. Federica Gazzelloni (2025), *Health Metrics and the Spread of Infectious
   Diseases: Machine Learning Applications and Spatial Modelling Analysis with
   R*.
3. CDC NNDSS weekly data documentation.
