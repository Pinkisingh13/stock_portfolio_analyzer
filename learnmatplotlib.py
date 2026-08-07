import yfinance as yf
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

# Fetch data
# data = yf.Ticker("RELIANCE.NS").history(period="1mo")
# print(data["Close"].tail())
# print(data["Open"].tail())


# x = [1,2,3,4,5]
# y = [10,20,15,25, 30]

# plt.plot(data.index[-5:], data["Close"].tail(), color="red", label="Closing Data")
# plt.plot(data.index[-5:], data["Open"].tail(), color="green", label="Opening Data")
# plt.legend()
# plt.title("Reliance Stock Chart")
# plt.xlabel("Timestamps")
# plt.ylabel("Closing Stocks")
# plt.grid(True)
# plt.show()


#  Multiple Plotting

list_of_companies=["SBIN.NS", "ICICIBANK.NS","AXISBANK.NS", "HDFCBANK.NS", "PNB.NS"]
data = []
colors_for_stocks = ["Blue", "Brown", "Green", "Pink", "red"]

for stock in list_of_companies:
  stockdata = yf.Ticker(stock).history(period="1mo")
  stockdata["Daily Return"] = stockdata["Close"].pct_change()
  stockdata["Stock Name"] = stock
  # print(data)
  data.append(stockdata)

print(data)
for d, cl, sn in zip(data, colors_for_stocks, list_of_companies):

  print(d)
  plt.plot(d.index, d["Daily Return"], color=cl, label= sn)
plt.title("5 NSE Stocks")
plt.xlabel("TimeStamp")
plt.ylabel("Closing Price")
plt.legend()
plt.grid(True)
plt.show()



# for stock, cl in  zip(list_of_companies, colors_for_stocks):
#   stockdata = yf.Ticker(stock).history(period="1mo")
#   stockdata["Stock Name"] = stock
#   # print(data)
#   plt.plot(stockdata.index, stockdata["Close"], color=cl, label=stock)

# plt.title("5 NSE Stocks")
# plt.xlabel("Date")
# plt.ylabel("Price")
# plt.legend()
# plt.grid(True)
# plt.show()