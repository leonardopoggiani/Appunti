import sqlite3
import pandas as pd

con = sqlite3.connect('example.db')

data = pd.read_csv("data/manipulatedDataset.csv")

data.to_sql('mobility', con, if_exists="replace")

print(pd.read_sql("SELECT * FROM mobility", con))

con.commit()

con.close()
