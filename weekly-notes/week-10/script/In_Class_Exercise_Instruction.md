# Georgia DOC Policy Advisory Challenge
## In-Class Group Activity - Week 10

---

## Your Role

You are policy analysts hired by the **Georgia Department of Corrections**. They are considering deploying a recidivism prediction model to inform parole decisions. Your team must analyze the model and make a **GO/NO-GO recommendation** to the Commissioner.

---

## Instructions

### Phase 1: Individual Exploration 
Run the provided R script (`week10_exercise.R`) and note:

1. What's the model's AUC?
2. At threshold 0.50, what's the sensitivity and specificity?
3. Which racial group has the highest false positive rate?
4. Which group has the highest false negative rate?
5. What happens if we change the threshold to 0.30 or 0.70?

### Phase 2: Group Analysis 
As a **table or half table team**, discuss your findings and complete the template below. Prepare to present your recommendation.

### Phase 3: Presentation 
Present your recommendation to the "Commissioner" (instructor). 

---

# Policy Recommendation Template

**Complete this as a group and be ready to present**

---

## Consulting Team Information

**Clever Team Name:** _____________

**Team Members:**

- _________________________
- _________________________
- _________________________
- _________________________
- _________________________
- _________________________

---

## 1. TECHNICAL ASSESSMENT

### Model Performance Metrics

**AUC (Area Under ROC Curve):** __________

**At threshold = 0.50:**

- Sensitivity (True Positive Rate): __________
- Specificity (True Negative Rate): __________
- Precision (Positive Predictive Value): __________
- Overall Accuracy: __________

### Technical Quality Rating
Select one:

- ☐ Excellent (AUC > 0.90)
- ☐ Good (AUC 0.80-0.90)
- ☐ Acceptable (AUC 0.70-0.80)
- ☐ Poor (AUC < 0.70)

### Brief Technical Summary (2-3 sentences)
Is the model accurate enough for high-stakes decision-making?

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

---

## 2. EQUITY ANALYSIS

### False Positive Rates by Race (at threshold 0.50)

| Racial Group | False Positive Rate | Sample Size |
|--------------|---------------------|-------------|
| Group 1:     |                     |             |
| Group 2:     |                     |             |
| Group 3:     |                     |             |
| Group 4:     |                     |             |

### False Negative Rates by Race (at threshold 0.50)

| Racial Group | False Negative Rate | Sample Size |
|--------------|---------------------|-------------|
| Group 1:     |                     |             |
| Group 2:     |                     |             |
| Group 3:     |                     |             |
| Group 4:     |                     |             |

### Disparity Analysis

**Largest disparity identified:**

Group _____________ has ______% higher false positive rate than Group _____________

**OR**

Group _____________ has ______% higher false negative rate than Group _____________

### Equity Concerns Summary (3-4 sentences)
What are the implications of these disparities? Who is harmed?

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

---

## 3. THRESHOLD RECOMMENDATION

### If we deploy this model, we recommend:

Select one:

- ☐ Threshold = 0.30 (Aggressive - prioritize catching recidivists)
- ☐ Threshold = 0.50 (Balanced - default)
- ☐ Threshold = 0.70 (Conservative - minimize false accusations)
- ☐ Other: ________

### Rationale for Threshold Choice (3-4 sentences)
Why this threshold? What does it optimize for? What are the trade-offs?

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

### This threshold prioritizes:
Select one:

- ☐ **High Sensitivity** - Catch more people who will reoffend (accept more false positives)
- ☐ **High Specificity** - Avoid false accusations (accept more false negatives)
- ☐ **Balance** - Try to minimize both types of errors

---

## 4. DEPLOYMENT RECOMMENDATION

### Our recommendation to Georgia DOC:

Select one:

- ☐ **DEPLOY** - Use this model to inform parole decisions
- ☐ **DO NOT DEPLOY** - Do not use this model
- ☐ **CONDITIONAL DEPLOY** - Deploy only with specific safeguards in place

### Key Reasons for Our Recommendation

Provide 3-5 bullet points supporting your decision:

- ___________________________________________________________________

- ___________________________________________________________________

- ___________________________________________________________________

- ___________________________________________________________________

- ___________________________________________________________________

### What about the equity concerns?

How do you justify your recommendation given the disparate impact you identified?

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

---

## 5. SAFEGUARDS OR ALTERNATIVES

### If DEPLOY - Required Safeguards

What protections must be in place before deployment?

1. ___________________________________________________________________

2. ___________________________________________________________________

3. ___________________________________________________________________

4. ___________________________________________________________________

**OR**

### If DO NOT DEPLOY - Alternative Approaches

What should Georgia DOC do instead?

1. ___________________________________________________________________

2. ___________________________________________________________________

3. ___________________________________________________________________

4. ___________________________________________________________________

---

## 6. LIMITATIONS & UNCERTAINTIES

### What we don't know (but wish we did)

What additional information would strengthen your recommendation?

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

### Weaknesses in our recommendation

What's the strongest argument AGAINST your recommendation?

________________________________________________________________________

________________________________________________________________________

________________________________________________________________________

---

## 7. BOTTOM LINE

### One-Sentence Recommendation

If the Commissioner only reads one thing, what should it be?

________________________________________________________________________

________________________________________________________________________

---

