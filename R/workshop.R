# Introduction to machine learning in epidemiology
#
# Teaching question:
# Can recent surveillance data help us predict whether a state will report
# West Nile virus activity during the next four weeks?

# 1. Read the prepared teaching dataset.
wnv <- read.csv("data/processed/wnv_state_week.csv")

# Keep the mosquito-season weeks and only the variables needed in class.
wnv <- subset(
  wnv,
  week >= 18 & week <= 44,
  select = c(
    state, region, year, week, cases_last4,
    active_weeks_last8, activity_next_4w
  )
)

# Give the variables short names that are easy to discuss.
names(wnv) <- c(
  "state", "region", "year", "week", "recent_cases",
  "recent_active_weeks", "outcome"
)
wnv$region <- factor(wnv$region)
wnv$outcome <- factor(wnv$outcome, levels = c("no", "yes"))

# 2. Meet the data and the outcome.
head(wnv)
table(wnv$outcome)
round(prop.table(table(wnv$outcome)), 3)

png("figures/intro-01-outcome.png", width = 1000, height = 650, res = 150)
barplot(
  prop.table(table(wnv$outcome)),
  col = c("#D9D9D9", "#6A3D9A"),
  ylim = c(0, 1),
  main = "Will a state report West Nile activity in the next four weeks?",
  ylab = "Share of state-weeks",
  xlab = "Observed outcome"
)
dev.off()

# 3. Split the data into what the model can learn from and unseen data.
# Earlier years are training data; 2025 is the test data.
train <- subset(wnv, year <= 2024)
test <- subset(wnv, year == 2025)

nrow(train)
nrow(test)

# 4. Train one small decision tree.
# A decision tree is useful here because learners can see its questions.
library(rpart)

tree <- rpart(
  outcome ~ week + recent_cases + recent_active_weeks + region,
  data = train,
  method = "class",
  control = rpart.control(maxdepth = 3, minsplit = 30, cp = 0.005)
)

print(tree)

png("figures/intro-02-decision-tree.png", width = 1500, height = 900, res = 150)
rpart.plot::rpart.plot(
  tree,
  type = 2,
  extra = 104,
  fallen.leaves = TRUE,
  box.palette = "Purples"
)
dev.off()

# 5. Ask the model to predict the unseen 2025 data.
test$probability_yes <- predict(tree, newdata = test, type = "prob")[, "yes"]
test$predicted <- factor(
  ifelse(test$probability_yes >= 0.50, "yes", "no"),
  levels = c("no", "yes")
)

# 6. Compare predictions with what was observed.
confusion <- table(Actual = test$outcome, Predicted = test$predicted)
print(confusion)

accuracy <- sum(diag(confusion)) / sum(confusion)
sensitivity <- confusion["yes", "yes"] / sum(confusion["yes", ])
specificity <- confusion["no", "no"] / sum(confusion["no", ])

performance <- data.frame(
  measure = c("accuracy", "sensitivity", "specificity"),
  value = c(accuracy, sensitivity, specificity)
)

print(performance)

write.csv(test, "outputs/intro-predictions.csv", row.names = FALSE)
write.csv(as.data.frame(confusion), "outputs/intro-confusion-matrix.csv", row.names = FALSE)
write.csv(performance, "outputs/intro-performance.csv", row.names = FALSE)

# 7. Interpretation for the workshop.
cat(
  "\nThe model learned patterns from earlier data and was checked on later data.\n",
  "Its predictions are not causal conclusions and are not an early-warning system.\n"
)
