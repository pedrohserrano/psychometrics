# -*- coding: utf-8 -*-

"""
This procedure will a fact table of distinct users with the summary of scores over the time
The table depends on the number of tests over the time (the size of the cohort)
It is necessary to run create_dataset.py before

Examples
run: python scores_dataset.py 2 'avg_test_ms'
run: python scores_dataset.py 12 'correct.answers'
"""

import pandas as pd
import numpy as np
import sys

# Loading data 
# ======================================================================================================
try:
    df_measures = pd.read_csv('~/SDMT-Analysis/data/interim/df_measures.csv', encoding="utf-8")
    df_measures_users = pd.read_csv('~/SDMT-Analysis/data/interim/df_measures_users.csv', encoding="utf-8")
except IOError as err:
    print("I/O error: {0}".format(err))
    raise

# Defining the group (Cohort Split off)
# ======================================================================================================

# Number of tests we want to evaluate reliabilty
number_tests = int(sys.argv[1]) #4 or 2 recomended
# Variable whose will be the score to measure
var_score = sys.argv[2] #'correct.answers' recomended
# Name of new dataset
name = sys.argv[3]
# Users id on this group 
group = df_measures_users[df_measures_users['events'] >= number_tests]['userId'].tolist()

# It makes an scaning of every user in order to get the first -number_tests- test that each individual performed
def create_subset(group, number_tests, df_measures):
	df_group= pd.DataFrame()
	for user in group:
	    df_user = df_measures[df_measures['userId']==str(user)].sort_values(by='timestamp', ascending=True)
	    df_user = df_user.iloc[0:number_tests]
	    df_user['test_number'] = np.arange(1,number_tests+1).tolist()
	    df_group = df_group.append(df_user)

	return df_group

# Creates the dataset of the score we want to measure
def scores_table (group, number_tests, df_measures):
    df_scores = pd.DataFrame()
    df_group = create_subset(group, number_tests, df_measures)
    df_scores['userId'] = group
    for i in range(1,number_tests+1):
        df_scores['test_number'+str(i)]=df_group[df_group['test_number'] == i][var_score].tolist()

    return df_scores

df_scores = scores_table (group, number_tests, df_measures)

print('Number of users: {}'.format(df_scores['userId'].count()))
print('Number of tests performed: {}'.format(number_tests))
print('Score measure: {}'.format(var_score))

# Saving data
df_scores.to_csv('~/SDMT-Analysis/data/interim/'+name+'.csv', sep=',', encoding="utf-8", index=False)
print('... Dataset '+name+'.csv created')

