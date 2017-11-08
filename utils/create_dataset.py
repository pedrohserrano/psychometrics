
# -*- coding: utf-8 -*-

"""
This procedure will create 3 datasets with aggregated data of scores from the population 
input: file in csv format downloaded directly from base
Example of use: 
python ~/SDMT-Analysis/src/data/create_dataset.py ~/SDMT-Analysis/data/processed/mijn-kwik-may.csv
"""

from datetime import datetime, timedelta
from dateutil.parser import parse as parse_datetime
import pandas as pd
import numpy as np
import sys

# Loading data and create variables
# ======================================================================================================

#df = pd.read_csv('../../data/processed/mijn-kwik-all.csv', parse_dates=True, encoding="utf-8") # Fixed dara_raw
df = pd.read_csv(sys.argv[1], parse_dates=True, encoding="utf-8")

# We only need the reverse tests, is that one whose has the numbers in the screen
df = df[df['value.type'] == 'reverse']
# Renaming the columns
df = df.rename(index=str, columns={"value.correct": "correct.answers", "value.nb": "total.answers"})
# Accuracy variable
df['accuracy.rate']=df['correct.answers']/df['total.answers']

# Paste MS labels
# ======================================================================================================

df_labels = pd.read_csv('../data/processed/users.csv', encoding="utf-8")

def create_labels(df_labels):#, df_measures):
    labels=[]
    for code in df_labels['code']:
        if ('A' in code):
            labels.append(int(1))
        elif ('B' in code):
            labels.append(int(0))
        else: 
            labels.append(None) # loop ends
        
    df_labels['ms']=labels
    labels_out = df_labels[['userId','ms']]
    
    return labels_out

# Missing values
# ======================================================================================================

# Missing values distribuution
def distribution_answers(df):
    mis_val = df.isnull().sum()
    mis_val_percent = 100 * df.isnull().sum()/len(df)
    mis_val_table = pd.concat([mis_val, mis_val_percent], axis=1)
    mis_val_table = mis_val_table.rename(columns = {0 : 'Missing Values', 1 : '% of Total Values'})
    return mis_val_table

missing = distribution_answers(df)
missing = missing[missing['Missing Values'] > 0] #showing only all those are not zero

print('Percetnage of missing values: {}'.format(missing['% of Total Values'].mean()))

# Formating timestamp variables
# ======================================================================================================

# Formating time
df['timestamp'] = pd.to_datetime(df['timestamp'])

# Max of answers of at least one individual in this dataset
max_answers=int(round(((len(df.columns.values)-7)/4)-1)) #64
print('Max answers: {}'.format(max_answers))


def times_of_response(df):

    ts_values = [4*n+2  for n in range(1,max_answers+2)]
    ts_variables = df.columns.values[ts_values]
    df[ts_variables] = df[ts_variables].apply(pd.to_datetime)
    # Now for symbols
    symbols_values = [4*n-1  for n in range(1,max_answers+2)]
    symbols_variables = df.columns.values[symbols_values]

    # Time spent of every test
    df_times = pd.DataFrame()
    df_times['test_time']=df['timestamp']-df['value.answers.0.timestamp']

    # Apply substraction of every timestamp
    for j in range(0,max_answers):
        df_times['time_'+str(j+1)]=df['value.answers.'+str(j+1)+'.timestamp']-df['value.answers.'+str(j)+'.timestamp']
        df_times['symbol_'+str(j+1)]=df['value.answers.'+str(j+1)+'.symbol']

    return df_times

# Construct measures dataset
# ======================================================================================================

# Valid responses

# 1. The test_time should be between 0 and 90 seconds
#     - Drop all those timestamp in the answer objects are not registrated (NA)
#     - Drop all those are not in ther 90 seconds of the expected test
#     - Drop all the users whose have no more than 3 events
# 2. The user finished the test

df_times = times_of_response(df)

# Taking the useful (for now) variables to define the dataset for study
df_short = df[['_id','userId','timestamp','correct.answers','total.answers','accuracy.rate']]
# Joining two created interm dataframes
df_measures = pd.concat([df_short, df_times], axis=1)

# Creating new variable Avgerage time of answering every item
df_measures['avg_test']=df_times.select_dtypes(exclude=['object']).mean(axis=1)
df_measures['avg_test'].fillna(0, inplace=True)
df_measures['avg_test_ms'] = df_measures['avg_test'].astype('timedelta64[ms]').astype(int)

# Rejecting datapoints where the participant is distracted, to perform an answer cannot take more than 20 seconds
df_measures = df_measures[df_measures['avg_test_ms']<20000] 

# Rejecting null values and events within 90 seconds of testing
df_measures = df_measures[(df_measures['test_time'].notnull())
            & (df_measures['test_time']>'00:00:00.000000')
            & (df_measures['test_time']<='00:01:30.000000')]#.sort_values(by='test_time')

# Creating new variable Hour of the day the test was performed
df_measures['hour'] = pd.Series(df_measures['timestamp']).map(lambda x: parse_datetime(str(x)).hour)
# Create variable of the day in str
all_ts = df_measures['timestamp']

def get_time_data(all_ts): 
    all_dates = []
    all_times = []
    for timestamp in all_ts:
        date, time = str(parse_datetime(str(timestamp))).split(' ')
        all_dates.append(date)
        all_times.append(time)
    return all_dates, all_times

all_dates, all_times = get_time_data(all_ts)

df_measures['day'] = all_dates
df_measures['moment'] = all_times

# Print valid scores
#print(df_measures['test_time'].describe())

print('Min score: {}'.format(min(df_measures['correct.answers'])), 
      'Max score: {}'.format(max(df_measures['correct.answers'])), 
      'Mean score: {}'.format(df_measures['correct.answers'].mean()))

# First aggregate dataset excluding non valid ms
df_measures = pd.merge(df_measures, create_labels(df_labels), on='userId', how='left')
df_measures = df_measures[~df_measures['ms'].isnull()]
#df_measures['ms_str'] = df_measures['ms'].apply(str) consider

# Second dataset, Aggregated by user for another kind of summaries
df_measures_users = df_measures.groupby('userId').mean()
df_measures_users['events'] = df_measures.groupby('userId').count()['_id']

# Paste median of correct aswers
df_measures_users = df_measures_users.join(pd.DataFrame(df_measures.groupby('userId').median()['correct.answers']), how='left',rsuffix='_median')
# Mínimun of events to perform test-retest statistical prove
mínimum_events = 2
# Rejected users not in minimum events
rejected_users = df_measures_users[df_measures_users['events'] < mínimum_events].index.values.tolist()
# Take the dataframe without those users
df_measures = df_measures[~df_measures['userId'].isin(rejected_users)]
# The same with the other dataframe
df_measures_users = df_measures_users[df_measures_users['events'] >= mínimum_events]
# Paste le label for the day the person starts the study
df_measures_users = df_measures_users.join(pd.DataFrame(df_measures.groupby('userId').min()['timestamp']), how='left')

# Symbols for every trial table
# ======================================================================================================

def create_symbols_table(df_measures):
    subset = pd.concat([df_measures[['_id','userId','correct.answers','ms','timestamp']]]*max_answers, ignore_index=True)
    times, symbols, trials = [], [], []
    for i in range(max_answers):
        trials += [i+1]*len(df_measures)
        times += list(df_measures['time_'+str(i+1)])
        symbols += list(df_measures['symbol_'+str(i+1)])

    milisec = [(pd.to_timedelta(i,'ms') / np.timedelta64(1, 'ms')) for i in times]
    times_symbols = pd.DataFrame([milisec, symbols, trials]).transpose()
    times_symbols.columns = ['response_ms','symbol','trial']
    times_symbols['response_ms'].fillna(0, inplace=True)
    df_symbols = pd.concat([subset, times_symbols], axis=1).sort_values(by=['timestamp','trial'], ascending=True)
    df_symbols = df_symbols[~df_symbols['symbol'].isnull()]

    return df_symbols

df_symbols = create_symbols_table(df_measures)

# Distract Points
# ======================================================================================================

# Median event
median_event = df_symbols.groupby('_id')['response_ms'].median()
df_symbols = df_symbols.join(median_event, on='_id', how='left', rsuffix='_med')

# SD of the group 
sd_group = df_symbols.groupby('ms')['response_ms'].std()
df_symbols = df_symbols.join(sd_group, on='ms', how='left', rsuffix='_sd')

# Boundaries to detect distraction
df_symbols['sup_line'] = df_symbols['response_ms_med'] + df_symbols['response_ms_sd']*2
df_symbols['inf_line'] = [max(x, 0) for x in (df_symbols['response_ms_med'] - df_symbols['response_ms_sd']*2)]

# Create dummy variable for every distraction point
df_symbols['distract_points'] = [1 if i == True else 0 for i in 
 (df_symbols['response_ms'] > df_symbols['sup_line']) | (df_symbols['response_ms'] < df_symbols['inf_line'])]

#paste to df_measures and measures_users
df_measures = df_measures.join(df_symbols.groupby('_id')['distract_points'].sum(), on='_id', how='left')
df_measures = df_measures.join(df_symbols.groupby('_id')['response_ms_med'].mean(), on='_id', how='left')
df_measures_users['distract_points'] = df_measures.groupby('userId').mean()['distract_points'].values


# Saving datasets
# ======================================================================================================

# How many MS patients in dataset
print('Percentage of MS in Dataset: {} %'.format(round(df_measures_users['ms'].sum()/df_measures_users['ms'].count()*100)))

df_measures_users.to_csv('../data/interim/df_measures_users.csv', sep=',', encoding="utf-8")
print('... Dataset df_measures_users.csv created')

df_measures.to_csv('../data/interim/df_measures.csv', sep=',', encoding="utf-8", index=False)
print('... Dataset df_measures.csv created')

df_symbols.to_csv('../data/interim/df_symbols.csv', sep=',', encoding="utf-8", index=False)
print('... Dataset df_symbols.csv created')





