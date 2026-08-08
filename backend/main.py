import yfinance as yf
import pandas as pd
import numpy as np
import matplotlib.pyplot as mp
from fastapi import FastAPI


list_of_stocks = ["SBIN.NS", "ICICIBANK.NS", "AXISBANK.NS", "HDFCBANK.NS", "PNB.NS"]
volatility = []
dat = []
colors = ["blue", "green", "red", "orange", "purple"]

def getreturns():
    for symbol in list_of_stocks:
        stocks = yf.Ticker(symbol)
        data = stocks.history(period="1mo")
        data["Stock Name"] = symbol
        data["Daily Return"] = data["Close"].pct_change() * 100
        vol = data["Daily Return"].std()
        volatility.append(vol)
        dat.append(data)
        print(dat)
  

def plot_daily_returns():
    for s, n, cl in zip(dat, list_of_stocks, colors):
        mp.plot(s.index, s["Daily Return"], color=cl, label=n.split(".")[0])

    mp.title("Daily Returns Comparison")
    mp.xlabel("Date")
    mp.ylabel("Daily Return (%)")
    mp.legend()
    mp.grid(True, alpha=0.3)
    mp.axhline(y=0, color='black', linestyle='--', linewidth=0.5)
    mp.tight_layout()
    # mp.savefig("daily_returns.png", dpi=300, bbox_inches="tight")
    mp.show()

def plot_volatility_chart():
    stock_names_clean = [s.replace(".NS", "") for s in list_of_stocks]

    mp.bar(stock_names_clean, volatility, color=colors)
    mp.title("Stock Volatility Comparison")
    mp.xlabel("Stock")
    mp.ylabel("Daily Volatility (%)")
    mp.grid(True, alpha=0.3)
    mp.tight_layout()
    # mp.savefig("stock_volatility.png", dpi=300, bbox_inches="tight")
    mp.show()


getreturns()
plot_daily_returns()
plot_volatility_chart()

