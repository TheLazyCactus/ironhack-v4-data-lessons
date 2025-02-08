import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import precision_recall_curve, auc

# Generate synthetic data
np.random.seed(42)

# Negative class: probabilities between 0 and 0.3
negative_probs = np.random.uniform(0, 0.7, 1000)

# Positive class: probabilities between 0.8 and 1
positive_probs = np.random.uniform(0.6, 1, 1000)

# Combine probabilities and labels
y_true = np.array([0] * 1000 + [1] * 1000)  # 0 = negative, 1 = positive
y_scores = np.concatenate([negative_probs, positive_probs])

# Calculate Precision-Recall curve
precision, recall, thresholds = precision_recall_curve(y_true, y_scores)
pr_auc = auc(recall, precision)

# Plot PR curve
plt.figure(figsize=(8, 6))
plt.plot(recall, precision, color='blue', lw=2, label=f'PR curve (AUC = {pr_auc:.2f})')
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.title('Precision-Recall Curve for Perfectly Separated Classes')
plt.legend(loc='lower left')
plt.show()