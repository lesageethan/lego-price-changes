import pandas as pd 
import numpy as np

# Read excel into dataframe
df = pd.read_excel("original-data/DiB whole sample Dec 2015 prices.xlsx")

# Create profit margins column
df['Profit Margin'] = (
    df['Secondary market prices of new sets in 2015'] / df['Primary market price at release']
)

# Create years since release column
df['Years Since Release'] = (
    2016 - df['year of release']
)

# Create yearly average returns column
df['Yearly Average Returns'] = (
    df['Profit Margin']**(1/df['Years Since Release'])
)

# Find the average yearly return of all sets
df = df.replace([np.inf, -np.inf], np.nan)
print(df['Yearly Average Returns'].dropna().sum() / len(df['Yearly Average Returns'].dropna()))

# Save CSV
df.to_csv('new-data/dataframe_appended.csv')