# Exercise 2: read and interpret the final results

library(data.table)

performance <- fread("outputs/holdout-performance.csv")
print(performance)

# 1. Which model has the highest AUC?
# 2. Which model has the highest sensitivity?
# 3. Does the same model have the highest specificity?
# 4. Why is accuracy alone a poor summary for this outcome?
# 5. Does any result support a causal claim about the predictors? Why or why not?
