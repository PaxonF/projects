### Python Script ###
import pandas as pd
import matplotlib.pyplot as plt
import statsmodels.api as sm
import itertools
plt.style.use('fivethirtyeight')

# Set datetime index and y variable
df['month'] = pd.to_datetime(df['month'])
df.set_index(df['month'], inplace=True)
y = df['tpv']

# Instantiate SARIMA model and fit to data
mod = sm.tsa.statespace.SARIMAX(y, order=(0,1,1), seasonal_order=(1,1,1,12)
                                , enforce_stationarity=False
                                , enforce_invertibility=False
                               )
results = mod.fit(disp = -1)

# Forecast 200 months ahead of April 2014
pred_uc = results.get_forecast(steps=36)
pred_ci = pred_uc.conf_int()

# results.plot_diagnostics(figsize=(15, 12))
# plt.show()

# Create the plot
ax = y.plot(label='Actual', figsize=(15,12), color='black')
# #plt.show()
pred_uc.predicted_mean.plot(ax=ax, label='Forecasted', color='green')
#plt.show()
# Format the plot
ax.fill_between(pred_ci.index, pred_ci.iloc[:,0], pred_ci.iloc[:,1], color='k', alpha=.25)
#ax.fill_between(['2014-01','2019-01'], 2000,2500, color='r')
ax.set_xlabel('Month')
ax.set_ylabel('TPV (in 10 Billions)')
ax.tick_params(grid_color='k', grid_alpha=0.25)
ax.set_xlim(['2014-01','2022-01'])
plt.legend()
plt.xticks(rotation=-45)
plt.title('TPV Projections')
#plt.show()
# Output to Periscope
periscope.output(plt)