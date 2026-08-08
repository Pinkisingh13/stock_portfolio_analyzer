# this is api calling file
from fastapi import FastAPI
from pydantic import BaseModel
import yfinance as yf
import pandas as pd
import numpy as np
import matplotlib.pyplot as mp


app = FastAPI()


class StockDetails(BaseModel):
    stockname: str
    price: float
    quantity: int


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.post("/analyze/single-stock")
async def analyzestock(stockdetails: StockDetails):
    stockName = stockdetails.stockname
    ticker = yf.Ticker(stockName)
    data = ticker.history("1mo")
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
        }
    }
