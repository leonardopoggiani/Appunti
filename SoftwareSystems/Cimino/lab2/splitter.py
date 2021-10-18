from pandas import read_csv
from sklearn.model_selection import train_test_split

data = read_csv('data/manipulatedDataset.csv')
print(data.describe())

# Random split 75% as training and 25% as testing
training_data, testing_data, training_labels, testing_labels = \
    train_test_split(data.iloc[:, 4:len(data.columns)], data.iloc[:, 1])

# Save as csv
training_data.to_csv('data/trainingData.csv', index=False)
testing_data.to_csv('data/testingData.csv', index=False)
training_labels.to_csv('data/trainingLabels.csv', index=False)
testing_labels.to_csv('data/testingLabels.csv', index=False)