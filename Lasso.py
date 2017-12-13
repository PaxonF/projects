import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import sklearn


from pylab import rcParams
from sklearn import preprocessing
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn import metrics
from sklearn.metrics import classification_report

icu = pd.read_csv('C:\\Users\\paxon\\OneDrive\\Fall 2017\\STAT 420\\Regression Assignment 2\\icudata.csv')
print(icu.head())

