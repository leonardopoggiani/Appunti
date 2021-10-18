from numpy import ravel
from pandas import read_csv
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score
import json

# Read the data
training_data = read_csv('data/trainingData.csv')
training_labels = read_csv('data/trainingLabels.csv')
testing_data = read_csv('data/testingData.csv')
testing_labels = read_csv('data/testingLabels.csv')

# load best configuration
config_path = "config/modelConfiguration.json"
with open(config_path, "r") as f:
    params = json.load(f)

# train the model
model = MLPClassifier(**params).fit(training_data, ravel(training_labels))
# compute labels on testing data
labels = model.predict(testing_data)
# evaluate accuracy score
score = accuracy_score(ravel(testing_labels), labels)
print(score)
