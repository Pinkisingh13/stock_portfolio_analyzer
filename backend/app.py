# this is api calling file
from fastapi import FastAPI
from pydantic import BaseModel
import yfinance as yf
import pandas as pd
import numpy as np
import matplotlib.pyplot as mp
from refresh_api import router as refresh_router


app = FastAPI()
app.include_router(refresh_router)


class SingleStockDetails(BaseModel):
    stockname: str
    price: float
    quantity: int


class MultipleStockDetails(BaseModel):
    stocksname: list
    price: list
    quantity: list


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.post("/analyze/single-stock")
async def analyzestock(stockdetails: SingleStockDetails):
    stockName = stockdetails.stockname
    ticker = yf.Ticker(stockName)
    data = ticker.history("1y")
    if data.empty or len(data) == 0:
        return {
            "status": "error",
            "message": f"No data found for {stockName}. Check the symbol or try again later."
        }

    data["Stock Name"] = stockName
    data["Daily Returns"] = data["Close"].pct_change() * 100
    vol = data["Daily Returns"].std()
    profit_loss = (data["Close"].iloc[-1] -
                   stockdetails.price) * stockdetails.quantity
    total_investment_amount = stockdetails.price * stockdetails.quantity
    current_portfolio_value = data["Close"].iloc[-1] * stockdetails.quantity
    profit_loss_percentage = (
        (data["Close"].iloc[-1] - stockdetails.price) / stockdetails.price)*100
    maxreturndate = data["Daily Returns"].idxmax()
    minreturndate = data["Daily Returns"].idxmin()
    maxreturnvalue = data["Daily Returns"].max()
    minreturnvalue = data["Daily Returns"].min()
    data["SMA200"] = data["Close"].rolling(200).mean()
    data["SMA50"] = data["Close"].rolling(50).mean()
    data["SMA20"] = data["Close"].rolling(20).mean()

    # Replace NaN with 0
    sma20 = data["SMA20"].iloc[-1] if not pd.isna(data["SMA20"].iloc[-1]) else 0
    sma50 = data["SMA50"].iloc[-1] if not pd.isna(data["SMA50"].iloc[-1]) else 0
    sma200 = data["SMA200"].iloc[-1] if not pd.isna(data["SMA200"].iloc[-1]) else 0

    short_term, medium_term, long_term = analyzesmatrend(
        sma20, sma50, sma200, data["Close"].iloc[-1])

    return {
        "message": "Successfully retrieve closing data",
        "Close": data["Close"].tail(),
        "Stock Name": stockName,
        "Daily Returns": data["Daily Returns"].tail(),
        "Volatility": vol,
        "Current Price": data["Close"].iloc[-1],
        "User Bought Price": stockdetails.price,
        "Quantity": stockdetails.quantity,
        "Profit Loss": profit_loss,
        "Profit Loss Percentage": profit_loss_percentage,
        "Total Investment Amount": total_investment_amount,
        "Current Portfolio Value": current_portfolio_value,
        "Best Day": {
            "date": maxreturndate,
            "return": maxreturnvalue
        },
        "Worst Day": {
            "date": minreturndate,
            "return": minreturnvalue
        },
        "SMA20": sma20,
        "SMA50": sma50,
        "SMA200": sma200,
        "Short Term": short_term,
        "Momentum": medium_term,
        "Long Term": long_term,
    }


@app.post("/analyze/multiple-stock")
async def analyzemultiplestocks(listofstocks: MultipleStockDetails):
    results = []

    for symbol, p, q in zip(listofstocks.stocksname, listofstocks.price, listofstocks.quantity):
        stocks = yf.Ticker(symbol)
        data = stocks.history(period="1y")

        # Skip if no data returned (invalid symbol or network error)
        if data.empty or len(data) == 0:
            continue

        data["Daily Return"] = data["Close"].pct_change() * 100
        vol = data["Daily Return"].std()
        mean_return = data["Daily Return"].mean()
        current_price = data["Close"].iloc[-1]
        profit_loss = (current_price - p) * q
        total_investment = p * q
        current_value = current_price * q
        pl_percentage = ((current_price - p) / p) * 100
        best_day_return = data["Daily Return"].max()
        worst_day_return = data["Daily Return"].min()
        best_day_date = str(data["Daily Return"].idxmax().date())
        worst_day_date = str(data["Daily Return"].idxmin().date())
        high_30d = data["Close"].max()
        low_30d = data["Close"].min()
        data["SMA200"] = data["Close"].rolling(200).mean()
        data["SMA50"] = data["Close"].rolling(50).mean()
        data["SMA20"] = data["Close"].rolling(20).mean()

        # Replace NaN with 0 (happens when not enough data for SMA calculation)
        sma20 = data["SMA20"].iloc[-1] if not pd.isna(data["SMA20"].iloc[-1]) else 0
        sma50 = data["SMA50"].iloc[-1] if not pd.isna(data["SMA50"].iloc[-1]) else 0
        sma200 = data["SMA200"].iloc[-1] if not pd.isna(data["SMA200"].iloc[-1]) else 0
        short_term, medium_term, long_term = analyzesmatrend(
            sma20=sma20, sma50=sma50, sma200=sma200, currentprice=current_price)
        
    
        results.append({
            "Stock Name": symbol,
            "Volatility": vol,
            "Mean Daily Return": mean_return,
            "Current Price": current_price,
            "Bought Price": p,
            "Quantity": q,
            "Profit Loss": profit_loss,
            "PL Percentage": pl_percentage,
            "Total Investment": total_investment,
            "Current Value": current_value,
            "Best Day Return": best_day_return,
            "Best Day Date": best_day_date,
            "Worst Day Return": worst_day_return,
            "Worst Day Date": worst_day_date,
            "30D High": high_30d,
            "30D Low": low_30d,
            "SMA20": sma20,
            "SMA50": sma50,
            "SMA200": sma200,
            "Short Term": short_term,
            "Momentum": medium_term,
            "Long Term": long_term,
        })
    total_current_value_of_portfolio = 0
    for r in results:
        total_current_value_of_portfolio+=r["Current Value"]

    for r in results:  
      if(total_current_value_of_portfolio > 0): 
          weight = (r["Current Value"] / total_current_value_of_portfolio) *100
          r ["Portfolio Weight"] = weight
      else: 
          r["Portfolio Weight"] = 0
    
    return results


def analyzesmatrend(sma20, sma50, sma200, currentprice):

    if currentprice > sma20:
        short_term = "Short-term strength"
    elif currentprice < sma20:
        short_term = "Short-term weakness"
    else:
        short_term = "Short-term neutral"

    if sma20 > sma50:
        medium_term = "Bullish/positive momentum"
    elif sma20 < sma50:
        medium_term = "Bearish/negative momentum"
    else:
        medium_term = "Neutral momentum"

    if sma50 > sma200:
        long_term = "Longer-term bullish structure"
    elif sma50 < sma200:
        long_term = "Longer-term bearish structure"
    else:
        long_term = "Longer-term neutral"

    return short_term, medium_term, long_term
