import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import roc_curve, auc

# Generate synthetic data
np.random.seed(42)

# Negative class: probabilities between 0 and 0.3
negative_probs = np.random.uniform(0, 0.7, 1000)

# Positive class: probabilities between 0.8 and 1
positive_probs = np.random.uniform(0.6, 1, 1000)

# Combine probabilities and labels
y_true = np.array([0] * 1000 + [1] * 1000)  # 0 = negative, 1 = positive
y_scores = np.concatenate([negative_probs, positive_probs])

# Calculate ROC curve
fpr, tpr, thresholds = roc_curve(y_true, y_scores)
roc_auc = auc(fpr, tpr)

# Plot ROC curve
plt.figure(figsize=(8, 6))
plt.plot(fpr, tpr, color='blue', lw=2, label=f'ROC curve (AUC = {roc_auc:.2f})')
plt.plot([0, 1], [0, 1], color='gray', linestyle='--', lw=2, label='Random guess')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate (FPR)')
plt.ylabel('True Positive Rate (TPR)')
plt.title('ROC Curve for Perfectly Separated Classes')
plt.legend(loc='lower right')
plt.show()