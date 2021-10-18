from pandas import read_csv
from sklearn.neural_network import MLPClassifier
from numpy import ravel
import joblib

# Read the training data
training_data = read_csv('data/trainingData.csv')
training_labels = read_csv('data/trainingLabels.csv')

# train the model
initial_model = MLPClassifier(random_state=0).fit(training_data, ravel(training_labels))

# save the model
joblib.dump(initial_model, 'config/fitted_model.sav')

# Read new data
testing_data = read_csv('data/testingData.csv')
testing_labels = read_csv('data/testingLabels.csv')

# load the model
model = joblib.load('config/fitted_model.sav')

# Evaluate the initial model on new data
print('Evaluation score:')
print(model.score(testing_data, ravel(testing_labels)))