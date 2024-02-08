import pandas as pd 
import numpy as np
from datetime import datetime
import warnings
warnings.filterwarnings("ignore")

# Read excel into dataframe
df = pd.read_excel("original-data/DiB whole sample Dec 2015 prices.xlsx")

# Create profit margins column
df['Profit Margin'] = (
    df['Secondary market prices of new sets in 2015'] / df['Primary market price at release']
)

# Get accurate retirement dates
df_retirement_list = []
for i in range(1981, 2016):
    df_retirement_list.append(pd.read_csv(str("original-data/"+str(i)+".csv")))

df_retirement = pd.concat(df_retirement_list, ignore_index=True)

print(df_retirement)
print(df)

df['Full Retirement Date'] = (
    ""
)
df['Years Since Retirement'] = (
    ""
)

df['Years Since Retirement Simple'] = (
    ""
)

for i in range(0, len(df['id'])):
    try:
        retirement_date = df_retirement.loc[df_retirement['number']==df['id'][i], 'US_dateLastAvailable'].iloc[0]
        years_since_retirement = datetime.strptime("2016-01-01T00:00:00Z", "%Y-%m-%dT%H:%M:%SZ") -  datetime.strptime(retirement_date, "%Y-%m-%dT%H:%M:%SZ")
        years_since_retirement = years_since_retirement.days / 365
    except:
        retirement_date = float('nan')
        years_since_retirement = float('nan')
    years_since_retirement_simple = 2016 - df['year of release'][i]

    df['Full Retirement Date'][i] = retirement_date
    df['Years Since Retirement'][i] = years_since_retirement
    df['Years Since Retirement Simple'][i] = years_since_retirement_simple

# Create yearly average returns column
df['Yearly Average Returns'] = (
    np.where(df['Years Since Retirement']>2, df['Profit Margin']**(1/df['Years Since Retirement']), float('nan'))
)

df['Yearly Average Returns Simple'] = (
    np.where(df['Years Since Retirement Simple']>2, df['Profit Margin']**(1/df['Years Since Retirement Simple']), float('nan'))
)

# Find the average yearly return of all sets
df = df.replace([np.inf, -np.inf], np.nan)
print(df['Yearly Average Returns'].dropna().sum() / len(df['Yearly Average Returns'].dropna()))
print(len(df['Yearly Average Returns'].dropna()))

print(df)

# Save CSV
df.to_csv('new-data/dataframe_appended.csv')