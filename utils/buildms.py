import pandas as pd
import numpy as np

class MSscores:
	def __init__(self, df_measures):
		''' Constructor for this class. '''
		self.df_measures = df_measures

	def scores_time_series (self, score_variable):
	    """ Creates a new dataframe where enlist the score of every patient indexed on a same calendar axis
	    Example: score_variable='correct.answers' 
	    """
	    df_series , df_days_elapsed = pd.DataFrame(), pd.DataFrame()
	    date_counts = self.df_measures['day'].value_counts().sort_index()
	    for user in self.df_measures['userId']:
	        df_user = self.df_measures[self.df_measures['userId']==str(user)]
	        df_user = df_user[[score_variable, 'day']]
	        df_user['elapsed_days'] = pd.to_datetime(df_user['day']).diff(1)
	        df_user = df_user[df_user['elapsed_days'].dt.days > 0]
	        df_user.index = df_user['day']
	        df_user = pd.DataFrame(date_counts).join(df_user, how='left', lsuffix='_events', rsuffix='')
	        df_series[str(user)]=df_user[score_variable]
	        df_days_elapsed[str(user)]=df_user['elapsed_days'].dt.days
	    return df_series, df_days_elapsed

	def scores_table(self, score_variable, group, number_tests=2):
	    df_group, df_scores= pd.DataFrame(), pd.DataFrame()
	    for user in group:
	        df_user = self.df_measures[self.df_measures['userId']==str(user)].sort_values(by='timestamp', ascending=True)
	        df_user['elapsed_days'] = pd.to_datetime(df_user['day']).diff(1).dt.days
	        df_user['total_days'] = df_user['elapsed_days'].cumsum()
	        first_test= df_user.iloc[0:1]
	        df_user = df_user[df_user['elapsed_days'] > 0]
	        # Condition to take the retest value
	        if df_user['elapsed_days'].sum() >= 14:
	            retest = df_user[df_user['total_days']>=14].head(1)
	        elif df_user['elapsed_days'].sum() >= 7: 
	            retest = df_user[df_user['total_days']>=7].tail(1)
	        else: 
	            retest = df_user.tail(1)
	        # The first test is the first time point
	        df_user = first_test.append(retest)
	        df_user['test_number'] = np.arange(1,number_tests+1).tolist()
	        df_group = df_group.append(df_user)

	    df_scores['userId'] = group
	    for i in range(1,number_tests+1):
	        df_scores['test_number'+str(i)]=df_group[df_group['test_number'] == i][score_variable].tolist()

	    df_scores.columns = ['userId', 'test', 're-test']
	    print('Average Days Between Test-retest: {} (SD): {}'.format(round(df_group['total_days'].mean(),2), round(df_group['total_days'].std(),2)))
	    return df_scores

	def scores_first_last(self, score_variable, group, number_tests=2):
	    df_group, df_scores= pd.DataFrame(), pd.DataFrame()
	    for user in group:
	        df_user = self.df_measures[self.df_measures['userId']==str(user)].sort_values(by='timestamp', ascending=True)
	        df_user['elapsed_days'] = pd.to_datetime(df_user['day']).diff(1).dt.days
	        df_user['total_days'] = df_user['elapsed_days'].cumsum()
	        first_test= df_user.head(1)
	        last_test= df_user.tail(1)
	        df_user = first_test.append(last_test)
	        df_user['test_number'] = np.arange(1,number_tests+1).tolist()
	        df_group = df_group.append(df_user)

	    df_scores['userId'] = group
	    for i in range(1,number_tests+1):
	        df_scores['test_number'+str(i)]=df_group[df_group['test_number'] == i][score_variable].tolist()

	    df_scores.columns = ['userId', 'first', 'last']
	    print('Average Days Between First and Last: {} (SD): {}'.format(round(df_group['total_days'].mean(),2), round(df_group['total_days'].std(),2)))
	    return df_scores