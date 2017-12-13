
# coding: utf-8

# In[1]:

import pandas as pd
import matplotlib.pylab as plt
import numpy as np
import statsmodels.formula.api as smf
from sklearn.model_selection import train_test_split

heights1 = pd.read_csv('C:\\Users\\paxon\\OneDrive\\Fall 2017\\STAT 420\\LinearRegression Assignment\\Data\\height_weight1.csv')
print(heights1.head())


# In[2]:

model1 = smf.ols(formula='height~1+weight', data = heights1).fit()
print(model1.summary())


# In[10]:

#Test our residuals
residual = model1.resid
#Test for normal residuals
plt.hist(residual, 50)
plt.show()

#Homoscadasity
plt.plot(model1.predict(heights1), residual, '.')
plt.show()


# In[12]:

model1_noint = smf.ols(formula='height~0+weight', data = heights1).fit()
print(model1_noint.summary())


# In[16]:

#Test our residuals
residual = model1_noint.resid
#Test for normal residuals
plt.hist(residual, 50)
plt.show()

#Homoscadasity
plt.plot(model1_noint.predict(heights1), residual, '.')
plt.show()


# In[17]:

#PROBLEM 2
heights2 = pd.read_csv('C:\\Users\\paxon\\OneDrive\\Fall 2017\\STAT 420\\LinearRegression Assignment\\Data\\height_weight2.csv')
print(heights1.head())


# In[18]:

model2_noint = smf.ols(formula='height~0+weight', data = heights2).fit()
print(model2_noint.summary())


# In[19]:

#Test our residuals
residual = model2_noint.resid
#Test for normal residuals
plt.hist(residual, 50)
plt.show()

#Homoscadasity
plt.plot(model2_noint.predict(heights2), residual, '.')
plt.show()


# In[51]:

#PROBLEM 3
car = pd.read_csv('C:\\Users\\paxon\\OneDrive\\Fall 2017\\STAT 420\\LinearRegression Assignment\\Data\\car.csv')
print(car.head())


# In[23]:

#1st Model
carmodel = smf.ols(formula='Price ~ 1 + Age + Make + Type + Miles', data = car).fit()
print(carmodel.summary())


# In[24]:

#Test our residuals
residual = carmodel.resid
#Test for normal residuals
plt.hist(residual, 50)
plt.show()

#Homoscadasity
plt.plot(carmodel.predict(car), residual, '.')
plt.show()


# In[34]:

#2nd Model
carmodel2 = smf.ols(formula='Price ~ 1 + np.log(Age) + np.log(Miles)', data = car).fit()
print(carmodel2.summary())


# In[39]:

#Test our residuals
residual = carmodel2.resid
#Test for normal residuals
plt.hist(residual, 50)
plt.show()

#Homoscadasity
plt.plot(carmodel2.predict(car), residual, '.')
plt.show()


# In[38]:

#3rd Model
carmodel3 = smf.ols(formula='Price ~ 1 + Make + Type', data = car).fit()
print(carmodel3.summary())


# In[40]:

#Test our residuals
residual = carmodel3.resid
#Test for normal residuals
plt.hist(residual, 50)
plt.show()

#Homoscadasity
plt.plot(carmodel3.predict(car), residual, '.')
plt.show()


# In[ ]:

#1st Model Prediction
# $21,856.96

