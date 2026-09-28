# Short participant exercise

wnv <- read.csv("data/processed/wnv_state_week.csv")
wnv <- subset(
  wnv,
  week >= 18 & week <= 44,
  select = c(year, week, cases_last4, active_weeks_last8, activity_next_4w)
)

names(wnv) <- c(
  "year", "week", "recent_cases", "recent_active_weeks", "outcome"
)
wnv$outcome <- factor(wnv$outcome, levels = c("no", "yes"))

# 1. How many observations have outcome "yes" and how many have outcome "no"?

# 2. Split the data: years up to 2024 for training and 2025 for testing.

# 3. Fit this decision tree with rpart():
#    outcome ~ week + recent_cases + recent_active_weeks

# 4. Predict the outcome for the test data with predict(..., type = "class").

# 5. Use table() to compare the observed and predicted outcomes.

# 6. In plain English, what has the model learned and what has it not proved?
