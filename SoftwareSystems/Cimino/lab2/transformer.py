import pandas as pd

dataset = pd.read_csv("data/completeDataset.csv")
print(dataset.describe())

dataset = dataset.drop("h24", axis=1)
dataset = dataset.loc[dataset['Anomalous'] < 1]

print(dataset.describe())

dataset.to_csv("data/manipulatedDataset.csv", index=False)