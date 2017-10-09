import scipy.stats as stats
import numpy as np
from math import *

class MSstats(object):
    def __init__(self, rv):
        self.rv = rv
    
    def eval_pdf(self):
        mean = self.rv.mean()
        std = self.rv.std()
        xs = np.linspace(mean - 4*std, mean + 4*std, 100)
        ys = self.rv.pdf(xs)
        return xs, ys

class MDC(object):
    def __init__(self, sem):
        self.sem = sem
    
    def compute_mdc(self):
        mdc = self.sem*1.96*sqrt(2)
        return mdc

    def interval_mdc(self, scores_vector):
    	count=[]
    	interval = [scores_vector.mean() - (self.sem*1.96*sqrt(2)), scores_vector.mean() + (self.sem*1.96*sqrt(2))]
    	for trial in scores_vector:
    		if (trial < interval[0] or trial > interval[1]):
    			count.append(1)
    	proportion=sum(count)*100/len(scores_vector)
    	return interval, proportion

class ICC(object):
	def __init__(self, x, y):
		self.x = x
		self.y = y

	def compute_icc(self):
		n = len(self.x)
		Sx = sum(self.x); Sy = sum(self.y)
		Sxx = sum(self.x*self.x); Sxy = sum( (self.x+self.y)**2 )/2; Syy = sum(self.y*self.y)
		fact = ((Sx + Sy)**2)/(n*2)
		SS_tot = Sxx + Syy - fact
		SS_among = Sxy - fact
		SS_error = SS_tot - SS_among
		MS_error = SS_error/n
		MS_among = SS_among/(n-1)
		ICC = (MS_among - MS_error) / (MS_among + MS_error)

		return ICC

class dCohen(object):
	def __init__(self, x, y):
		self.x = x
		self.y = y

	def effect_size(self):
	    diff = abs(self.x.mean() - self.y.mean())

	    nx, ny = len(self.x), len(self.y)
	    varx = self.x.var()
	    vary = self.y.var()
	    pooled_var = (nx * varx + ny * vary) / (nx + ny)
	    d = diff / sqrt(pooled_var)
	    return d

class Missing:
    def __init__(self, df):
        self.df = df
 
    def distribution_answers(self):
	    mis_val = self.df.isnull().sum()
	    mis_val_percent = 100 * self.df.isnull().sum()/len(self.df)
	    mis_val_table = pd.concat([mis_val, mis_val_percent], axis=1)
	    mis_val_table = mis_val_table.rename(columns = {0 : 'Missing Values', 1 : '% of Total Values'})
	    return  mis_val_table

class Intervals(object):
	def __init__(self, scores_vector): #population sample 
		self.scores_vector = scores_vector
		
	def create_int(self, N, sample_size): #N=number of experiments, sample_size=how many values from scores_vector pick up
		intervals = []
		sample_means = []
		for sample in range(N):
			sample = np.random.choice(a= self.scores_vector, size = sample_size)
			sample_mean = sample.mean()
			sample_means.append(sample_mean)
			sem = stats.sem(self.scores_vector)
			confidence_interval = (sample_mean - sem*1.96, sample_mean + sem*1.96)
			intervals.append(confidence_interval)
		return sample_means, intervals