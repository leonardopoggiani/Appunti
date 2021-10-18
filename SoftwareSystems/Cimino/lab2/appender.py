"""Simple operations with datasets."""
import pandas as pd


data1 = pd.read_csv("data/hotspotUrbanMobility-1.csv")
print(data1.shape)

data2 = pd.read_csv("data/hotspotUrbanMobility-2.csv")
print(data2.shape)

data1 = data1.append(data2, ignore_index=True)
print(data1.shape)

data1.to_csv("data/completeDataset.csv", index=False)
