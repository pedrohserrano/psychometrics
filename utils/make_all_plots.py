import sys
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import matplotlib
matplotlib.use('TkAgg')

color_ms = '#386cb0' #blue, This is the color chosen for patients with Multiple Sclerosis
color_hc = 'red'#This is the color chosen for health control participants

df_measures = pd.read_csv('../data/interim/df_measures.csv', encoding="utf-8")
df_measures_users = pd.read_csv('../data/interim/df_measures_users.csv', encoding="utf-8")
df_symbols = pd.read_csv('../data/interim/df_symbols.csv', encoding="utf-8")


users = list(zip(df_measures_users['userId'], [color_ms if ms==1 else color_hc for ms in df_measures_users['ms']]))
for user in users:
	df_user = df_symbols[df_symbols['userId']==user[0]]
	stamps = df_user['timestamp'].unique()
	if len(stamps) <= 2**2: 
		plot_size =  (2,2)
		fig_size = (12*1,8*1)
	elif len(stamps) <= 3**2:
		plot_size = (3,3)
		fig_size = (12*2,8*2)
	elif len(stamps) <= 4**2:
		plot_size = (4,4)
		fig_size = (12*3,8*3)
	elif len(stamps) <= 5**2:
		plot_size = (5,5)
		fig_size = (12*4,8*4)
	else:
		plot_size = (10,10)
		fig_size = (3*2**10, 2**10)
	plt.figure(figsize=(fig_size[0], fig_size[1]))
	for idx, i in enumerate(range(len(stamps))): 
		plt.subplot(plot_size[0],plot_size[1],idx+1)
		df_user_ts = df_user[df_user['timestamp']==stamps[i]]
		plt.scatter(df_user_ts['trial'], df_user_ts['response_ms'], color=user[1])
		plt.hlines(y=df_user_ts['sup_line'], xmin=0, xmax=max(df_user_ts['trial']), linestyles='--', color=user[1])
		plt.hlines(y=df_user_ts['inf_line'], xmin=0, xmax=max(df_user_ts['trial']), linestyles='--', color=user[1])
		plt.hlines(y=df_user_ts['response_ms_med'], xmin=0, xmax=max(df_user_ts['trial']), linestyles=':', color=user[1])
		plt.fill_between(range(len(df_user_ts['trial'])+1), df_user_ts['sup_line'].mean(), df_user_ts['inf_line'].mean(), color=user[1], alpha=0.2)
		plt.xticks(df_user_ts['trial'], df_user_ts['symbol'], rotation=90)
		plt.ylabel('Response in Miliseconds')
		grouped = df_symbols.groupby(['userId','timestamp'])['distract_points'].sum().reset_index()
		d_point = grouped[(grouped['userId']==user[0]) & (grouped['timestamp']==stamps[i])]['distract_points'].values
		plt.title('Test # '+str(idx)+' Score: '+str(max(df_user_ts['correct.answers']))+' Distraction Points: '+str(d_point[0])+' Median Time: '+str(df_user_ts['response_ms_med'].mean()))

	plt.tight_layout()
	figname = 'user_{}.png'.format(user[0])
	dest = os.path.join('../reports/time_response_png/', figname)
	plt.savefig(dest)
	#plt.savefig('../reports/time_response_svg/user_'+user[0]+'.svg')
	#plt.savefig('../reports/time_response_png/user_'+user[0]+'.png')
	plt.cla()