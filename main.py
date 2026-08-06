import yfinance as yf
import pandas as pd
import numpy as np
import matplotlib as mp


list_of_stocks = ["RELIANCE.NS", "TCS.NS", "VEDL.NS", "HDFCBANK.NS", "ICICIBANK.NS"]

results = {}

def getreturns():
 for symbol in list_of_stocks:
    stocks = yf.Ticker(symbol)
    data = stocks.history(period="1mo")
    closing_data = data["Close"].values
    first_price = closing_data[0]
    last_price = closing_data[-1]
    monthly_return = (last_price - first_price) / first_price * 100
    # print(closing_data)
    # print(monthly_return)
    check_volatility(closing_data)
    

def check_volatility(cl_value):
    daily_returns = []
    difference = []
    squared = []
    sum_of_square = 0
    for i in range(1, len(cl_value)):
        yesterday = cl_value[i-1]
        today = cl_value[i]
        daily_return = (today - yesterday) / yesterday * 100
        daily_returns.append(daily_return)
    average = np.mean(daily_returns)
    # print(average)
    
    for i in daily_returns:
       difference.append(i - average)
    #    print(difference)
    squared = np.square(difference)
    sum_of_square = np.sum(squared) / (len(squared)-1)
    #    print(squared)
    # print(sum_of_square)
    volatality = np.sqrt(sum_of_square)
    print(volatality)

getreturns()