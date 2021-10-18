from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import plot_confusion_matrix
import matplotlib.pyplot as plt


class IrisClassifier:

    def __init__(self, iterations=500):
        self.data = None
        self.x_train = None
        self.x_test = None
        self.y_train = None
        self.y_test = None
        self.epochs = iterations
        self.trained_model = None

    def ingestion(self):
        self.data = load_iris()

    def segregation(self):
        self.x_train, self.x_test, self.y_train, \
        self.y_test = train_test_split(self.data['data'], self.data['target'])

    def train(self):
        self.trained_model = MLPClassifier(max_iter=self.epochs, random_state=1).fit(self.x_train, self.y_train)

    def evaluation(self):
        score = self.trained_model.score(self.x_test, self.y_test)
        f = open("report.txt", "a")
        f.write('Test score: ' + str(score) + ' | ')
        plot_confusion_matrix(self.trained_model, self.x_test, self.y_test)
        plt.savefig('report.png')
        return score
