# Intro to Machine Learning in Epidemiology with R

## Project purpose

Develop a 2-hour R-Ladies Rome workshop introducing machine learning in epidemiology using R.

The workshop should be practical, reproducible, accessible to participants who know basic R, and grounded in a real epidemiological problem rather than being a generic introduction to machine-learning algorithms.

## Main methodological reference

Wright et al. (2026)
"Machine Learning in Epidemiology"
arXiv:2602.16352

https://arxiv.org/abs/2602.16352

Use the paper as a methodological reference, but do not simply reproduce its examples.

The paper uses the `mlr3` ecosystem and covers:
- supervised learning
- classification
- decision trees
- ensemble methods
- resampling
- model evaluation
- hyperparameter tuning
- interpretable machine learning
- unsupervised learning
- neural networks and generative methods

For this 2-hour introductory workshop, concentrate on the core supervised-learning workflow.

## Instructor

Federica Gazzelloni

Actuary, statistician, data scientist, author and instructor.
Founder/organiser of R-Ladies Rome.

Federica is the author of:

"Health Metrics and the Spread of Infectious Diseases:
Machine Learning Applications and Spatial Modelling Analysis with R"
CRC Press, 2025.

The book includes practical machine-learning applications using the
`mlr` framework.

The workshop should explicitly connect:

Federica's book / `mlr`
        ↓
modern `mlr3` ecosystem
        ↓
Machine Learning in Epidemiology (2026)
        ↓
practical epidemiological application

This connection should appear naturally in the workshop rather than
as a promotional interruption.

## Proposed title

Introduction to Machine Learning in Epidemiology with R

Subtitle:

From epidemiological questions to prediction, evaluation and interpretation

## Central question

Can we use epidemiological data to predict a health outcome, and how
do we determine whether the resulting prediction is trustworthy?

## Core conceptual workflow

Epidemiological question
        ↓
Data
        ↓
Define prediction task
        ↓
Train/test strategy
        ↓
Baseline model
        ↓
Machine-learning models
        ↓
Resampling
        ↓
Evaluation
        ↓
Interpretation
        ↓
Epidemiological conclusions

## Models

Use three models to demonstrate increasing flexibility:

1. Logistic regression
2. Decision tree
3. Random forest

The point is NOT to teach many algorithms.

The central comparison should be:

Does increasing model complexity improve prediction on unseen data?

## R framework

Prefer `mlr3` for the main implementation.

Use the mlr3 conceptual structure:

Task
→ Learner
→ Train
→ Predict
→ Evaluate

Example learners:

lrn("classif.log_reg")
lrn("classif.rpart")
lrn("classif.ranger")

Explain briefly that Federica's book uses `mlr`, while `mlr3` is the
newer ecosystem and is also used by the 2026 reference study.

## Dataset decision

Investigate three possibilities before selecting the final dataset.

### Preferred candidate: West Nile virus

Look for an open, reproducible epidemiological dataset suitable for
a classification problem.

Possible observational units:

county × week
county × year
state × week
state × year

Potential target:

elevated West Nile activity: yes/no

Potential predictors may include:

- previous cases/incidence
- geography
- time
- population
- mosquito surveillance
- temperature
- precipitation
- other appropriate surveillance variables

Do NOT construct a target or predictors that introduce data leakage.

### Alternative: Ebola

Investigate open Ebola outbreak datasets.

Use Ebola only if there is a clear observational unit, sufficiently
large sample, defensible prediction target and reproducible data source.

Avoid turning the workshop into an outbreak-modelling workshop.

### Fallback: Heart Disease

The Wright et al. paper uses the Heart Disease dataset.

This is the safest fallback because the ML workflow has already been
demonstrated and the data are readily available.

However, an infectious-disease dataset is preferred because it connects
more naturally with Federica's book and epidemiological work.

## Dataset evaluation criteria

Before selecting the dataset, compare candidates on:

- source
- licence
- accessibility from R
- number of observations
- outcome variable
- predictors
- missingness
- class balance
- geographic granularity
- temporal granularity
- reproducibility
- risk of data leakage
- suitability for cross-validation
- epidemiological relevance
- suitability for a live 2-hour workshop

Do not choose a dataset merely because it is interesting.

The complete analysis must run reliably during a live workshop.

## Proposed 2-hour structure

00–10  R-Ladies Rome introduction

10–20  What is machine learning in epidemiology?

20–25  Machine learning with R:
       mlr → mlr3 → reference paper

25–40  Meet the epidemiological dataset and formulate the
       prediction problem

40–55  Logistic regression as a baseline

55–70  Decision tree

70–85  Random forest

85–100 Model evaluation:
       cross-validation
       ROC/AUC
       sensitivity
       specificity
       confusion matrix

100–110 Model interpretation:
        feature importance
        optionally one PDP/ALE example

110–117 What machine learning can and cannot tell epidemiologists

117–120 Resources, conclusions and Q&A

## Important epidemiological messages

Prediction is not inference.

Prediction is not causation.

Variable importance is not causal importance.

Good predictive performance does not establish that predictors cause
the outcome.

Observed surveillance data are not necessarily equivalent to the true
disease process.

Data quality, representativeness, missingness and surveillance bias
matter even when the machine-learning pipeline is technically correct.

A more complex model is not automatically a better model.

Evaluation must concern performance on unseen data rather than training
performance.

## Teaching style

Follow R-Ladies Rome workshop style:

- welcoming and accessible
- practical
- code-led
- reproducible
- epidemiological question first, algorithm second
- explain concepts visually before introducing code
- avoid unnecessary mathematical notation
- short blocks of code
- frequent interpretation of results
- show what can go wrong
- leave participants with reusable R code

The workshop should be understandable to someone with basic R knowledge
but no formal machine-learning background.

## Intended repository structure

README.md
slides/
data/
R/
exercises/
solutions/
figures/
references/

Possible R scripts:

R/
  01-data.R
  02-exploration.R
  03-task.R
  04-logistic-regression.R
  05-decision-tree.R
  06-random-forest.R
  07-resampling.R
  08-evaluation.R
  09-interpretation.R

## Final resources

Include:

1. Wright et al. (2026), Machine Learning in Epidemiology
2. Federica Gazzelloni (2025),
   Health Metrics and the Spread of Infectious Diseases:
   Machine Learning Applications and Spatial Modelling Analysis with R
3. mlr3 documentation
4. workshop repository
5. original dataset documentation and citation

## Immediate next task

Do NOT start building slides yet.

First:

1. Investigate available West Nile datasets.
2. Investigate suitable Ebola datasets.
3. Examine the dataset/code used by Wright et al.
4. Compare the three options systematically.
5. Recommend the best dataset for the workshop.
6. Define the exact prediction target and observational unit.
7. Only after this decision, construct the reproducible R workflow.
