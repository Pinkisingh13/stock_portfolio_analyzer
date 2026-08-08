import yfinance as yf
import numpy as np
import pandas as pd

# df = pd.DataFrame(
#   {
#     "Stock_prices": [1, 2, 40, 60, 300],
#     "Name": ["stock1", "stock2", "stock3", "stock4", "stock5"]
#   }
# )

# print(df)

# print(df.head(2)) # First two data
# print(df.tail(2)) # Last two data

# print(df["Stock_prices"])
# print(df[["Stock_prices", "Name"]])
# print(df.iloc[-1:])


# loc — select by LABEL (name):Key: Uses names — column names, row index labels.
# Uses row/column names (labels).

# print(df.loc[:, "Stock_prices"])
# print(df.loc[0])
# print(df.loc[1, "Stock_prices"])
# print(df.loc[0:2, ['Stock_prices', 'Name']])

# df["Stock_prices"] = df["Stock_prices"] * 2
# print(df[df["Stock_prices"] > 20])
# print(df)

# print(df["Stock_prices"].plot())


# ------------------------------------------------------------------------

# Task to do: 

# Print first 5 rows.
# Print last 5 rows.
# Show only the Close column.
# Find the maximum close.
# Find the minimum close.
# Find the average close.
# Create a Daily Return column.
# Find the average daily return.
# Find the standard deviation.
# Plot the closing price.
# Plot the moving average.

# data = yf.Ticker("RELIANCE.NS").history(period="1mo")
# print(type(data))

# Print first 5 rows.
# print(data.head())

# Print last 5 rows
# print(data.tail())

# Show only the Close column.
# print(data["Close"])

# Find the maximum close.
# print(data["Close"].max())

# Find the minimum close.
# print(data["Close"].min())

# Find the average close.
# print(data["Close"].mean())

# Create a Daily Return column
# data["Daily Return"] = data["Close"].pct_change()
# print(data)

# Find the average daily return.
# print(data["Daily Return"].mean())

# Find the standard deviation
# print(data["Daily Return"].std())

# Plot the closing price
# data["Close"].plot()

# Plot the moving average
# data["Close"].rolling(window=20).mean().plot()

# ------------------------------------------------------------------------------

# Part 1: Time Series 
# Set datetime as index
# Filter by date range
# Resample (daily → weekly → monthly)
# Forward fill / backward fill missing data

data = yf.Ticker("RELIANCE.NS").history(period="1mo")
# print(type(data))
# print(data.index)
# print(data.index.min())
# print(data.index.max())
# print(data.index.month_name())
# print(data.index.day_name())

# print(data.loc["2026-08"])
# print(data.loc["2026-07"])
# print(data.loc["2026-07-10" : "2026-08-03"])

data.pop("Dividends")
data.pop("Stock Splits")
# print(data)
data["Year"] = data.index.year
# print(data)
data["Month"] = data.index.month_name()
data["WEEKDAY"] = data.index.day_name()
# print(data)

#  RESAMPLING AND CONVERTING

# weekly = data.resample("W-FRI").last()
# weekly["WEEKDAY"] = weekly.index.day_name()
# weekly["Month"] = weekly.index.month_name()
# weekly["Actual_Date"] = weekly.index 
# print(weekly)

# print(data.tail(10)[["Open", "High", "Low", "Close", "Volume"]])



# Part 2: Multi-Stock Analysis
# Combine multiple stocks in one DataFrame
# Merge/join DataFrames
# Correlation matrix
# Compare stocks side-by-side

# data = []
# list_of_stock = ["RELIANCE.NS", "TCS.NS"]


# for l in list_of_stock:
#   data_of_stocks = yf.Ticker(l).history(period="1mo")
#   # print(data_of_stocks)
#   data_of_stocks["StockName"] = l
#   data.append(data_of_stocks)


# data = pd.concat(data)
# print(data)
 
 
# Merge/join DataFrames

df1 = pd.DataFrame({
  "Name": ["jack", "jolly","sweety", "zin"],
  "Roll no":[20, 10, 40, 12]
})
df2 = pd.DataFrame({
  "Parents_Name": ["jack's parent", "jolly's parent","sweety's parent", "zin's parent"],
  "Address":["Mumbai", "United states", "China", "London"]
})

data = pd.merge(df1, df2, how="outer", left_on="Name", right_on="Parents_Name")
print(data)


# Part 3: Advanced Operations
# Apply custom functions
# Groupby and aggregation
# Pivot tables
# Multi-index DataFrames


# Part 4: Real Project
# Build complete portfolio analyzer using Pandas
# Replace your NumPy code with Pandas
# Export results to CSV
# Create summary statistics table