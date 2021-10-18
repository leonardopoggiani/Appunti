from sklearn.neural_network import MLPClassifier
from pandas import read_csv
from numpy import ravel

# Read the data
training_data = read_csv('data/trainingData.csv')
training_labels = read_csv('data/trainingLabels.csv')
testing_data = read_csv('data/testingData.csv')
testing_labels = read_csv('data/testingLabels.csv')

# Build and train the classifier
mlp = MLPClassifier(max_iter=100).fit(training_data, training_labels)
print(mlp.predict(testing_data))  # produce the predictions
print(mlp.score(testing_data, testing_labels))  # compute the accuracy of the model
