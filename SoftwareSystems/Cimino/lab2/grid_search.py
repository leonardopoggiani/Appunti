from sklearn.neural_network import MLPClassifier
from sklearn.model_selection import GridSearchCV
from pandas import read_csv
from numpy import ravel
import json

# Read the data
training_data = read_csv('data/trainingData.csv')
training_labels = read_csv('data/trainingLabels.csv')
# setup Grid Search for MLP
mlp = MLPClassifier()
# values to test
parameters = {'max_iter': (100, 200, 300, 500, 1000, 2000)}
# apply grid search
gs = GridSearchCV(mlp, parameters)
gs.fit(training_data, ravel(training_labels))
# save best configuration
config_path = 'config/modelConfiguration.json'

with open(config_path, 'w') as f:
    json.dump(gs.best_params_, f)
