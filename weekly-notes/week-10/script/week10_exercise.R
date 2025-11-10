# ==============================================================================
# Logistic Regression with Equity Analysis
# Week 10: MUSA 5080 Public Policy Analytics
# ==============================================================================

# This script demonstrates how to:
# 1. Build a logistic regression model for binary classification
# 2. Evaluate model performance using multiple metrics
# 3. Analyze disparate impact across demographic groups
# 4. Test different decision thresholds
# 5. Make evidence-based policy recommendations

# ==============================================================================
# SETUP
# ==============================================================================

# Load required packages
library(tidyverse)   # For data manipulation and visualization
library(caret)       # For model training and confusion matrices
library(pROC)        # For ROC curves and AUC

# Set random seed for reproducibility
set.seed(2025)

# Configure visualization theme
theme_set(theme_minimal())

# ==============================================================================
# PART 1: DATA LOADING AND EXPLORATION
# ==============================================================================

# Load Georgia Department of Corrections recidivism data
# Source: National Institute of Justice Recidivism Challenge
recidivism_data <- read_csv(here("data/NIJ_s_Recidivism_Challenge_Full_Dataset_20240407.csv"))
# Examine data structure
glimpse(recidivism_data)

# Check outcome variable distribution
table(recidivism_data$Recidivism_Within_3years, useNA = "ifany")

# Calculate overall recidivism rate
mean(recidivism_data$Recidivism_Within_3years, na.rm = TRUE)

# Examine recidivism rates by race
recidivism_data %>%
  filter(!is.na(Race), !is.na(Recidivism_Within_3years)) %>%
  group_by(Race) %>%
  summarise(
    n = n(),
    recidivism_rate = mean(Recidivism_Within_3years),
    avg_age = mean(Age_at_Release, na.rm = TRUE),
    avg_prior_felonies = mean(Prior_Arrest_Episodes_Felony, na.rm = TRUE)
  ) %>%
  arrange(desc(recidivism_rate))

# CRITICAL QUESTION: Why do base rates differ across groups?
# Consider both individual factors and systemic factors (differential policing,
# economic opportunities, program access, etc.)

# ==============================================================================
# PART 2: DATA PREPARATION
# ==============================================================================

# Clean and prepare data for modeling
model_data <- recidivism_data %>%
  # Create binary outcome variable (must be numeric for glm)
  mutate(recidivism = as.integer(Recidivism_Within_3years == TRUE)) %>%
  # Select relevant features
  select(
    recidivism,                         # Outcome
    Age_at_Release,                     # Demographics
    Gender,
    Race,
    Gang_Affiliated,                    # Risk factors
    Dependents,
    Prior_Arrest_Episodes_Felony,       # Criminal history
    Prior_Arrest_Episodes_Violent,
    Prior_Conviction_Episodes_Prop,
    Condition_MH_SA,                    # Mental health / substance abuse
    Supervision_Risk_Score_First,       # Official risk score
    Percent_Days_Employed,              # Economic factors
    Education_Level                     # Education
  ) %>%
  # Remove missing values (in practice, consider imputation)
  na.omit()

# Check final sample characteristics
cat("Final sample size:", nrow(model_data), "individuals\n")
cat("Recidivism rate:", round(mean(model_data$recidivism), 3), "\n\n")

# Sample size by race
model_data %>%
  count(Race) %>%
  arrange(desc(n))

# ==============================================================================
# PART 3: TRAIN-TEST SPLIT
# ==============================================================================

# Create stratified train-test split (maintains outcome distribution)
trainIndex <- createDataPartition(
  y = model_data$recidivism,
  p = 0.70,           # 70% training, 30% testing
  list = FALSE
)

train_data <- model_data[trainIndex, ]
test_data <- model_data[-trainIndex, ]

# Verify split preserves outcome distribution
cat("Training set:\n")
cat("  N =", nrow(train_data), "\n")
cat("  Recidivism rate =", round(mean(train_data$recidivism), 3), "\n\n")

cat("Test set:\n")
cat("  N =", nrow(test_data), "\n")
cat("  Recidivism rate =", round(mean(test_data$recidivism), 3), "\n\n")

# ==============================================================================
# PART 4: MODEL TRAINING
# ==============================================================================

# Fit logistic regression model
# Note: We're excluding Race from predictors to avoid direct discrimination,
# but this doesn't eliminate bias (proxy variables may exist)
logit_model <- glm(
  recidivism ~ Age_at_Release + 
               Dependents + 
               Gang_Affiliated + 
               Prior_Arrest_Episodes_Felony + 
               Prior_Arrest_Episodes_Violent +
               Prior_Conviction_Episodes_Prop +
               Percent_Days_Employed + 
               Supervision_Risk_Score_First,
  data = train_data,
  family = "binomial"  # Specifies logistic regression
)

# View model summary
summary(logit_model)

# Interpret coefficients as odds ratios
exp(coef(logit_model))

# INTERPRETATION NOTE:
# Coefficients show log-odds relationship
# Odds ratios > 1 indicate increased risk
# Odds ratios < 1 indicate decreased risk

# ==============================================================================
# PART 5: GENERATING PREDICTIONS
# ==============================================================================

# Generate predicted probabilities on test set
test_data <- test_data %>%
  mutate(
    predicted_prob = predict(logit_model, newdata = test_data, type = "response")
  )

# Examine distribution of predicted probabilities
summary(test_data$predicted_prob)

# Visualize predicted probabilities by actual outcome
ggplot(test_data, aes(x = predicted_prob, fill = as.factor(recidivism))) +
  geom_histogram(bins = 50, alpha = 0.7, position = "identity") +
  scale_fill_manual(
    values = c("steelblue", "coral"),
    labels = c("No Recidivism", "Recidivism")
  ) +
  labs(
    title = "Distribution of Predicted Probabilities",
    x = "Predicted Probability of Recidivism",
    y = "Count",
    fill = "Actual Outcome"
  )

# ==============================================================================
# PART 6: MODEL EVALUATION - OVERALL PERFORMANCE
# ==============================================================================

# ---- 6.1: Confusion Matrix at Default Threshold (0.5) ----

test_data <- test_data %>%
  mutate(predicted_class_50 = ifelse(predicted_prob > 0.5, 1, 0))

# Create confusion matrix
cm_50 <- confusionMatrix(
  as.factor(test_data$predicted_class_50),
  as.factor(test_data$recidivism),
  positive = "1"  # "1" is the positive class (recidivism)
)

print(cm_50)

# Extract key metrics
cat("\nKey Metrics at Threshold = 0.5:\n")
cat("Sensitivity (Recall):", round(cm_50$byClass["Sensitivity"], 3), 
    "- Proportion of actual recidivists correctly identified\n")
cat("Specificity:", round(cm_50$byClass["Specificity"], 3),
    "- Proportion of non-recidivists correctly identified\n")
cat("Precision (PPV):", round(cm_50$byClass["Precision"], 3),
    "- Proportion of predicted recidivists who actually recidivated\n")
cat("Accuracy:", round(cm_50$overall["Accuracy"], 3), "\n\n")

# ---- 6.2: ROC Curve and AUC ----

# Generate ROC curve
roc_obj <- roc(
  response = test_data$recidivism,
  predictor = test_data$predicted_prob
)

# Plot ROC curve
ggroc(roc_obj, color = "steelblue", size = 1.5) +
  geom_abline(slope = 1, intercept = 1, linetype = "dashed", color = "gray50") +
  labs(
    title = "ROC Curve: Recidivism Prediction Model",
    subtitle = paste0("AUC = ", round(auc(roc_obj), 3)),
    x = "1 - Specificity (False Positive Rate)",
    y = "Sensitivity (True Positive Rate)"
  ) +
  annotate("text", x = 0.5, y = 0.3, 
           label = "Random Classifier\n(AUC = 0.5)",
           color = "gray50", size = 3) +
  coord_fixed()

# Print AUC
cat("Area Under the Curve (AUC):", round(auc(roc_obj), 3), "\n")
cat("Interpretation: AUC of", round(auc(roc_obj), 2), 
    "indicates", ifelse(auc(roc_obj) > 0.8, "good", "acceptable"), 
    "discrimination\n\n")

# ---- 6.3: Performance Across Multiple Thresholds ----

# Test three different thresholds
thresholds_to_test <- c(0.3, 0.5, 0.7)

threshold_results <- map_df(thresholds_to_test, function(thresh) {
  # Generate predictions at this threshold
  preds <- ifelse(test_data$predicted_prob > thresh, 1, 0)
  
  # Calculate confusion matrix
  cm <- confusionMatrix(
    as.factor(preds),
    as.factor(test_data$recidivism),
    positive = "1"
  )
  
  # Extract metrics
  data.frame(
    threshold = thresh,
    accuracy = cm$overall["Accuracy"],
    sensitivity = cm$byClass["Sensitivity"],
    specificity = cm$byClass["Specificity"],
    precision = cm$byClass["Precision"],
    f1_score = cm$byClass["F1"],
    # Calculate false positive and false negative rates
    fpr = 1 - cm$byClass["Specificity"],
    fnr = 1 - cm$byClass["Sensitivity"]
  )
})

# Display results
print(threshold_results)

# Visualize threshold trade-offs
threshold_results %>%
  select(threshold, sensitivity, specificity, precision) %>%
  pivot_longer(cols = c(sensitivity, specificity, precision),
               names_to = "metric",
               values_to = "value") %>%
  ggplot(aes(x = threshold, y = value, color = metric, group = metric)) +
  geom_line(size = 1.2) +
  geom_point(size = 3) +
  scale_color_brewer(palette = "Set1",
                     labels = c("Precision", "Sensitivity", "Specificity")) +
  scale_x_continuous(breaks = thresholds_to_test) +
  labs(
    title = "Performance Metrics Across Thresholds",
    subtitle = "The threshold-performance trade-off",
    x = "Probability Threshold",
    y = "Metric Value",
    color = "Metric"
  ) +
  theme(legend.position = "bottom")

# CRITICAL INSIGHT: As threshold increases:
# - Fewer people flagged as high-risk (more conservative)
# - Sensitivity decreases (miss more actual recidivists)
# - Specificity increases (fewer false accusations)
# - Precision usually increases (predictions more accurate when made)

# ==============================================================================
# PART 7: EQUITY ANALYSIS - GROUP-WISE PERFORMANCE
# ==============================================================================

# This is the most important section for policy analysis!

# ---- 7.1: Calculate Performance Metrics by Race ----

# First, calculate overall metrics for comparison
overall_metrics <- test_data %>%
  summarise(
    Group = "Overall",
    N = n(),
    Base_Rate = mean(recidivism),
    Sensitivity = sum(predicted_class_50 == 1 & recidivism == 1) / sum(recidivism == 1),
    Specificity = sum(predicted_class_50 == 0 & recidivism == 0) / sum(recidivism == 0),
    Precision = sum(predicted_class_50 == 1 & recidivism == 1) / sum(predicted_class_50 == 1),
    FPR = sum(predicted_class_50 == 1 & recidivism == 0) / sum(recidivism == 0),
    FNR = sum(predicted_class_50 == 0 & recidivism == 1) / sum(recidivism == 1)
  )

# Calculate metrics by race
race_metrics <- test_data %>%
  group_by(Race) %>%
  summarise(
    N = n(),
    Base_Rate = mean(recidivism),
    Sensitivity = sum(predicted_class_50 == 1 & recidivism == 1) / sum(recidivism == 1),
    Specificity = sum(predicted_class_50 == 0 & recidivism == 0) / sum(recidivism == 0),
    Precision = sum(predicted_class_50 == 1 & recidivism == 1) / sum(predicted_class_50 == 1),
    FPR = sum(predicted_class_50 == 1 & recidivism == 0) / sum(recidivism == 0),
    FNR = sum(predicted_class_50 == 0 & recidivism == 1) / sum(recidivism == 1)
  ) %>%
  rename(Group = Race)

# Combine overall and by-group metrics
equity_analysis <- bind_rows(overall_metrics, race_metrics)

# Display results
print("=" %>% rep(80) %>% paste0(collapse = ""))
print("EQUITY ANALYSIS: Model Performance by Race (Threshold = 0.5)")
print("=" %>% rep(80) %>% paste0(collapse = ""))
print(equity_analysis, width = Inf)
print("=" %>% rep(80) %>% paste0(collapse = ""))

# ---- 7.2: Visualize Disparate Impact ----

# Create bar chart comparing key metrics across groups
race_metrics %>%
  select(Group, FPR, FNR, Sensitivity, Specificity) %>%
  pivot_longer(cols = c(FPR, FNR, Sensitivity, Specificity),
               names_to = "Metric",
               values_to = "Rate") %>%
  ggplot(aes(x = Group, y = Rate, fill = Metric)) +
  geom_col(position = "dodge", alpha = 0.8) +
  scale_fill_brewer(palette = "Set2") +
  labs(
    title = "Model Performance Disparities Across Racial Groups",
    subtitle = "Using threshold = 0.5",
    x = "Race",
    y = "Rate",
    fill = "Metric",
    caption = "FPR = False Positive Rate, FNR = False Negative Rate"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ---- 7.3: Testing Threshold Adjustments for Equity ----

# Can we achieve more equitable outcomes by adjusting thresholds?

# Function to calculate key rates at a given threshold
calc_rates_by_threshold <- function(data, threshold) {
  data %>%
    mutate(pred = ifelse(predicted_prob > threshold, 1, 0)) %>%
    summarise(
      threshold = threshold,
      FPR = sum(pred == 1 & recidivism == 0) / sum(recidivism == 0),
      FNR = sum(pred == 0 & recidivism == 1) / sum(recidivism == 1),
      Sensitivity = sum(pred == 1 & recidivism == 1) / sum(recidivism == 1),
      Specificity = sum(pred == 0 & recidivism == 0) / sum(recidivism == 0)
    )
}

# Test range of thresholds for each racial group
threshold_range <- seq(0.3, 0.7, by = 0.05)

threshold_by_race <- test_data %>%
  nest_by(Race) %>%
  reframe(
    map_df(threshold_range, ~calc_rates_by_threshold(data, .x))
  ) %>%
  ungroup()

# Visualize FPR across thresholds by race
ggplot(threshold_by_race, aes(x = threshold, y = FPR, color = Race)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  geom_vline(xintercept = 0.5, linetype = "dashed", alpha = 0.5) +
  labs(
    title = "False Positive Rate by Threshold and Race",
    subtitle = "Could different thresholds equalize FPR?",
    x = "Probability Threshold",
    y = "False Positive Rate",
    color = "Race"
  )

# Visualize FNR across thresholds by race
ggplot(threshold_by_race, aes(x = threshold, y = FNR, color = Race)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  geom_vline(xintercept = 0.5, linetype = "dashed", alpha = 0.5) +
  labs(
    title = "False Negative Rate by Threshold and Race",
    subtitle = "The trade-off: equalizing FPR may worsen FNR disparities",
    x = "Probability Threshold",
    y = "False Negative Rate",
    color = "Race"
  )

# ==============================================================================
# PART 8: SYNTHESIS AND RECOMMENDATIONS
# ==============================================================================


## Fill in the sections below.
cat("\n")
cat("=" %>% rep(80) %>% paste0(collapse = ""))
cat("\nKEY FINDINGS & POLICY IMPLICATIONS\n")
cat("=" %>% rep(80) %>% paste0(collapse = ""))
cat("\n\n")

cat("1. MODEL PERFORMANCE:\n")
cat("   - AUC:", round(auc(roc_obj), 3), "\n")
cat("   - Overall accuracy at threshold=0.5:", 
    round(cm_50$overall["Accuracy"], 3), "\n")
cat("   - Interpretation: [Your assessment here]\n\n")

cat("2. THRESHOLD TRADE-OFFS:\n")
cat("   - Lower threshold (0.3): Higher sensitivity, more false positives\n")
cat("   - Higher threshold (0.7): Higher specificity, more false negatives\n")
cat("   - Decision depends on: relative costs of each error type\n\n")

cat("3. EQUITY CONCERNS:\n")
cat("   - [Identify which groups face higher FPR or FNR]\n")
cat("   - [Discuss potential causes: differential base rates, proxy variables]\n")
cat("   - [Consider impossibility of perfect fairness when base rates differ]\n\n")

cat("4. DEPLOYMENT RECOMMENDATION:\n")
cat("   Should this model be used for parole decisions?\n")
cat("   - Technical readiness: [Your assessment]\n")
cat("   - Ethical considerations: [Your analysis]\n")
cat("   - Required safeguards: [Your recommendations]\n")
cat("   - Alternatives: [Your suggestions]\n\n")

cat("=" %>% rep(80) %>% paste0(collapse = ""))


# ==============================================================================
# ADDITIONAL ANALYSES (OPTIONAL EXTENSIONS)
# ==============================================================================

# ---- Extension 1: Calibration Analysis ----
# Check if predicted probabilities match actual outcomes

test_data %>%
  mutate(prob_bin = cut(predicted_prob, breaks = seq(0, 1, by = 0.1))) %>%
  group_by(prob_bin) %>%
  summarise(
    mean_predicted = mean(predicted_prob),
    mean_observed = mean(recidivism),
    n = n()
  ) %>%
  filter(n > 10) %>%
  ggplot(aes(x = mean_predicted, y = mean_observed, size = n)) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Calibration Plot",
    subtitle = "Are predicted probabilities well-calibrated?",
    x = "Mean Predicted Probability",
    y = "Mean Observed Recidivism Rate",
    size = "N in bin"
  ) +
  coord_fixed()

# ---- Extension 2: Feature Importance ----
# Which variables matter most?

coef_df <- summary(logit_model)$coefficients %>%
  as.data.frame() %>%
  rownames_to_column("variable") %>%
  mutate(odds_ratio = exp(Estimate)) %>%
  filter(variable != "(Intercept)") %>%
  arrange(desc(abs(Estimate)))

ggplot(coef_df, aes(x = reorder(variable, Estimate), y = odds_ratio)) +
  geom_point(size = 3, color = "steelblue") +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  coord_flip() +
  scale_y_continuous(trans = "log10") +
  labs(
    title = "Feature Importance (Odds Ratios)",
    subtitle = "OR > 1 increases recidivism risk; OR < 1 decreases risk",
    x = "Variable",
    y = "Odds Ratio (log scale)"
  )

# The end!
