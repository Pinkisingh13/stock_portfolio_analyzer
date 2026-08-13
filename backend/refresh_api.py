from fastapi import APIRouter
from pydantic import BaseModel
import yfinance as yf
import pandas as pd

router = APIRouter()

class RefreshRequest(BaseModel):
    symbols: list
    buy_prices: list
    quantities: list

@router.post("/api/refresh-prices")
async def refresh_prices(request: RefreshRequest):
    results = []

    for symbol, buy_price, qty in zip(request.symbols, request.buy_prices, request.quantities):
        ticker = yf.Ticker(symbol)
        data = ticker.history(period="1y")

        if data.empty or len(data) == 0:
            continue

        data["Daily Return"] = data["Close"].pct_change() * 100
        vol = data["Daily Return"].std()
        mean_return = data["Daily Return"].mean()
        current_price = data["Close"].iloc[-1]
        profit_loss = (current_price - buy_price) * qty
        total_investment = buy_price * qty
        current_value = current_price * qty
        pl_percentage = ((current_price - buy_price) / buy_price) * 100
        best_day_return = data["Daily Return"].max()
        worst_day_return = data["Daily Return"].min()
        best_day_date = str(data["Daily Return"].idxmax().date())
        worst_day_date = str(data["Daily Return"].idxmin().date())
        high_30d = data["Close"].max()
        low_30d = data["Close"].min()

        data["SMA200"] = data["Close"].rolling(200).mean()
        data["SMA50"] = data["Close"].rolling(50).mean()
        data["SMA20"] = data["Close"].rolling(20).mean()

        sma20 = data["SMA20"].iloc[-1] if not pd.isna(data["SMA20"].iloc[-1]) else 0
        sma50 = data["SMA50"].iloc[-1] if not pd.isna(data["SMA50"].iloc[-1]) else 0
        sma200 = data["SMA200"].iloc[-1] if not pd.isna(data["SMA200"].iloc[-1]) else 0

        short_term, medium_term, long_term = analyze_trend(sma20, sma50, sma200, current_price)

        results.append({
            "Stock Name": symbol,
            "Volatility": vol,
            "Mean Daily Return": mean_return,
            "Current Price": current_price,
            "Bought Price": buy_price,
            "Quantity": qty,
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

    total_current_value = sum(r["Current Value"] for r in results)

    for r in results:
        if total_current_value > 0:
            weight = (r["Current Value"] / total_current_value) * 100
            r["Portfolio Weight"] = weight
        else:
            r["Portfolio Weight"] = 0

    return results


def analyze_trend(sma20, sma50, sma200, currentprice):
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
