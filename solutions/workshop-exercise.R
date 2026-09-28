library(rpart)

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

table(wnv$outcome)

train <- subset(wnv, year <= 2024)
test <- subset(wnv, year == 2025)

tree <- rpart(
  outcome ~ week + recent_cases + recent_active_weeks,
  data = train,
  method = "class",
  control = rpart.control(maxdepth = 3, minsplit = 30, cp = 0.005)
)

test$predicted <- predict(tree, newdata = test, type = "class")
table(Actual = test$outcome, Predicted = test$predicted)

# The model learned associations that helped classify later observations.
# It did not prove that any predictor causes West Nile virus activity.
