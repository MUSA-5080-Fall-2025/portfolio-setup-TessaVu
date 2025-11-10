# Disease Testing Exercise - Student Worksheet

**Name:** ________________________    **Date:** _______________

## Your Patient Information

**Patient ID:** ________

**Truth (Red dot?):** ⃝ YES (has disease)   ⃝ NO (no disease)

**Model Prediction (Probability):** _______

**Deadly Variant? (Star):** ⃝ YES   ⃝ NO

---

## Round 1: Threshold = 0.50

### Step 1: Your Classification

**Decision rule:** If probability ≥ 0.50 → QUARANTINE

**Where should you go?**
⃝ Quarantine Table  
⃝ Stay at regular table

### Step 2: What Type of Case Are You?

Based on where you went and your truth:

⃝ **True Positive (TP)** - Correctly quarantined (have disease, high prob)  
⃝ **False Positive (FP)** - Incorrectly quarantined (no disease, high prob)  
⃝ **True Negative (TN)** - Correctly not quarantined (no disease, low prob)  
⃝ **False Negative (FN)** - Incorrectly not quarantined (have disease, low prob)

### Step 3: Class-wide Results

Work with your table to count:

```
           Predicted Positive   Predicted Negative
           (Quarantined)       (Not Quarantined)

Actually 
Positive   TP = _______         FN = _______
(Red Dot)

Actually
Negative   FP = _______         TN = _______
(No Dot)
```

### Step 4: Calculate Metrics

**Sensitivity (True Positive Rate):**
$$\text{Sensitivity} = \frac{TP}{TP + FN} = \frac{\_\_\_}{\_\_\_ + \_\_\_} = \_\_\_\_$$

*Interpretation:* What % of actually sick people did we catch? __________

**Specificity (True Negative Rate):**
$$\text{Specificity} = \frac{TN}{TN + FP} = \frac{\_\_\_}{\_\_\_ + \_\_\_} = \_\_\_\_$$

*Interpretation:* What % of healthy people did we correctly not quarantine? __________

**Precision (Positive Predictive Value):**
$$\text{Precision} = \frac{TP}{TP + FP} = \frac{\_\_\_}{\_\_\_ + \_\_\_} = \_\_\_\_$$

*Interpretation:* Of those quarantined, what % actually had disease? __________

**Accuracy:**
$$\text{Accuracy} = \frac{TP + TN}{\text{Total}} = \frac{\_\_\_ + \_\_\_}{48} = \_\_\_\_$$

*Interpretation:* What % did we classify correctly overall? __________

---

## Round 2: Threshold = 0.30

### Your Classification

**Decision rule:** If probability ≥ 0.30 → QUARANTINE

**Where should you go?**
⃝ Quarantine Table  
⃝ Stay at regular table

**Did your classification change from Round 1?** ⃝ YES  ⃝ NO

### Class-wide Results

```
           Predicted Positive   Predicted Negative

Actually 
Positive   TP = _______         FN = _______

Actually
Negative   FP = _______         TN = _______
```

### Calculate Metrics

**Sensitivity:** _______ (Did this go up ↑ or down ↓ from Round 1?)

**Specificity:** _______ (Did this go up ↑ or down ↓ from Round 1?)

**Precision:** _______

**Accuracy:** _______

### Deadly Variant Check

**How many people with stars (deadly variant) were caught?**
- Round 1 (threshold 0.50): _______
- Round 2 (threshold 0.30): _______

**Did lowering the threshold help catch deadly variants?** ⃝ YES  ⃝ NO

---

## Round 3: Threshold = 0.70

### Your Classification

**Decision rule:** If probability ≥ 0.70 → QUARANTINE

**Where should you go?**
⃝ Quarantine Table  
⃝ Stay at regular table

### Class-wide Results

```
           Predicted Positive   Predicted Negative

Actually 
Positive   TP = _______         FN = _______

Actually
Negative   FP = _______         TN = _______
```

### Calculate Metrics

**Sensitivity:** _______

**Specificity:** _______

**Precision:** _______

**Accuracy:** _______

---

## Comparison Across Thresholds

Fill in the table below with your results:

| Metric | Threshold = 0.30 | Threshold = 0.50 | Threshold = 0.70 |
|--------|-----------------|-----------------|-----------------|
| Sensitivity | | | |
| Specificity | | | |
| Precision | | | |
| False Positives (FP) | | | |
| False Negatives (FN) | | | |

### Observation Questions

1. **As threshold increases (0.30 → 0.50 → 0.70), what happens to sensitivity?**

   ⃝ Increases  ⃝ Decreases  ⃝ Stays the same

2. **As threshold increases, what happens to specificity?**

   ⃝ Increases  ⃝ Decreases  ⃝ Stays the same

3. **Can we maximize BOTH sensitivity and specificity at the same time?**

   ⃝ YES  ⃝ NO

4. **What is the fundamental trade-off?**

   ___________________________________________________________________

   ___________________________________________________________________

---

## Reflection Questions

### Question 1: Personal Experience

**If you were a False Positive (quarantined when healthy):**

How did it feel to be quarantined unnecessarily? 

___________________________________________________________________

___________________________________________________________________

What if this meant missing work for 2 weeks without pay? Or being unable to attend an important event?

___________________________________________________________________

___________________________________________________________________

**If you were a False Negative (missed when actually sick):**

How did it feel to be sent back when you actually had the disease?

___________________________________________________________________

___________________________________________________________________

What if you had the deadly variant (star)? What are the consequences of being missed?

___________________________________________________________________

___________________________________________________________________

### Question 2: Threshold Choice

**Scenario A: Rare, extremely deadly disease (like Ebola)**
- Disease is rare but 70% fatality rate
- Treatment is available and effective if caught early
- Quarantine costs $1,000/person, treatment costs $5,000

**Which threshold would you choose?** ⃝ 0.30  ⃝ 0.50  ⃝ 0.70

**Why?** 

___________________________________________________________________

___________________________________________________________________

___________________________________________________________________

**Scenario B: Common, mild illness (like common cold)**
- Disease is common but not serious (just annoying)
- No treatment available
- Quarantine means missing work (costs $2,000 in lost wages)

**Which threshold would you choose?** ⃝ 0.30  ⃝ 0.50  ⃝ 0.70

**Why?**

___________________________________________________________________

___________________________________________________________________

___________________________________________________________________

### Question 3: Metrics

**Which metric is MOST important for Scenario A (deadly disease)?**

⃝ Sensitivity - Don't miss any sick people  
⃝ Specificity - Don't quarantine healthy people  
⃝ Accuracy - Overall correct  
⃝ Precision - When we say "sick," be sure

**Why?**

___________________________________________________________________

___________________________________________________________________

**Which metric is MOST important for Scenario B (mild illness)?**

⃝ Sensitivity  
⃝ Specificity  
⃝ Accuracy  
⃝ Precision

**Why?**

___________________________________________________________________

___________________________________________________________________

### Question 4: Real-World Connections

**Think about COVID-19 testing. Rapid tests had lower sensitivity than PCR tests.**

When might you prefer a rapid test (lower sensitivity)?

___________________________________________________________________

___________________________________________________________________

When would you insist on PCR test (higher sensitivity)?

___________________________________________________________________

___________________________________________________________________

### Question 5: Equity Considerations

**What if the model's predictions were systematically wrong for certain groups?**

For example: The model gives lower probabilities for women even when they have the disease.

What would happen?

___________________________________________________________________

___________________________________________________________________

How could we detect this problem?

___________________________________________________________________

___________________________________________________________________

What should we do about it?

___________________________________________________________________

___________________________________________________________________

---

## Key Takeaways

**Write 3 key things you learned from this exercise:**

1. ___________________________________________________________________

   ___________________________________________________________________

2. ___________________________________________________________________

   ___________________________________________________________________

3. ___________________________________________________________________

   ___________________________________________________________________

**One question you still have:**

___________________________________________________________________

___________________________________________________________________

---
