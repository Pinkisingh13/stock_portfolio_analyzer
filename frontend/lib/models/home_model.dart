class StockAnalysisResponseModel {
  final String message;
  final Map<String, double> close;
  final String stockName;
  final Map<String, double> dailyReturns;
  final double volatility;
  final double currentPrice;
  final double userBoughtPrice;
  final int quantity;
  final double profitLoss;
  final double profitLossPercentage;
  final double totalInvestmentAmount;
  final double currentPortfolioValue;
  final DayData bestDay;
  final DayData worstDay;
  final double sma20;
  final double sma50;
  final double sma200;
  final String shortTerm;
  final String momentum;
  final String longTerm;

  StockAnalysisResponseModel({
    required this.message,
    required this.close,
    required this.stockName,
    required this.dailyReturns,
    required this.volatility,
    required this.currentPrice,
    required this.userBoughtPrice,
    required this.quantity,
    required this.profitLoss,
    required this.profitLossPercentage,
    required this.totalInvestmentAmount,
    required this.currentPortfolioValue,
    required this.bestDay,
    required this.worstDay,
    required this.sma20,
    required this.sma50,
    required this.sma200,
    required this.shortTerm,
    required this.momentum,
    required this.longTerm,
  });

  factory StockAnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    return StockAnalysisResponseModel(
      message: json['message'],
      close: Map<String, double>.from(json['Close']),
      stockName: json['Stock Name'],
      dailyReturns: Map<String, double>.from(json['Daily Returns']),
      volatility: json['Volatility'].toDouble(),
      currentPrice: json['Current Price'].toDouble(),
      userBoughtPrice: json['User Bought Price'].toDouble(),
      quantity: json['Quantity'],
      profitLoss: json['Profit Loss'].toDouble(),
      profitLossPercentage: json['Profit Loss Percentage'].toDouble(),
      totalInvestmentAmount: json['Total Investment Amount'].toDouble(),
      currentPortfolioValue: json['Current Portfolio Value'].toDouble(),
      bestDay: DayData.fromJson(json['Best Day']),
      worstDay: DayData.fromJson(json['Worst Day']),
      sma20: (json['SMA20'] ?? 0).toDouble(),
      sma50: (json['SMA50'] ?? 0).toDouble(),
      sma200: (json['SMA200'] ?? 0).toDouble(),
      shortTerm: json['Short Term'] ?? '',
      momentum: json['Momentum'] ?? '',
      longTerm: json['Long Term'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'Close': close,
      'Stock Name': stockName,
      'Daily Returns': dailyReturns,
      'Volatility': volatility,
      'Current Price': currentPrice,
      'User Bought Price': userBoughtPrice,
      'Quantity': quantity,
      'Profit Loss': profitLoss,
      'Profit Loss Percentage': profitLossPercentage,
      'Total Investment Amount': totalInvestmentAmount,
      'Current Portfolio Value': currentPortfolioValue,
      'Best Day': {'date': bestDay.date, 'return': bestDay.returnValue},
      'Worst Day': {'date': worstDay.date, 'return': worstDay.returnValue},
      'SMA20': sma20,
      'SMA50': sma50,
      'SMA200': sma200,
      'Short Term': shortTerm,
      'Momentum': momentum,
      'Long Term': longTerm,
    };
  }
}

class MultiStockItemModel {
  final String stockName;
  final double volatility;
  final double meanDailyReturn;
  final double currentPrice;
  final double boughtPrice;
  final int quantity;
  final double profitLoss;
  final double profitLossPercentage;
  final double totalInvestment;
  final double currentValue;
  final double bestDayReturn;
  final String bestDayDate;
  final double worstDayReturn;
  final String worstDayDate;
  final double high30d;
  final double low30d;
  final double sma20;
  final double sma50;
  final double sma200;
  final String shortTerm;
  final String momentum;
  final String longTerm;
  final double portfolioWeight;

  MultiStockItemModel({
    required this.stockName,
    required this.volatility,
    required this.meanDailyReturn,
    required this.currentPrice,
    required this.boughtPrice,
    required this.quantity,
    required this.profitLoss,
    required this.profitLossPercentage,
    required this.totalInvestment,
    required this.currentValue,
    required this.bestDayReturn,
    required this.bestDayDate,
    required this.worstDayReturn,
    required this.worstDayDate,
    required this.high30d,
    required this.low30d,
    required this.sma20,
    required this.sma50,
    required this.sma200,
    required this.shortTerm,
    required this.momentum,
    required this.longTerm,
    required this.portfolioWeight,
  });

  factory MultiStockItemModel.fromJson(Map<String, dynamic> json) {
    return MultiStockItemModel(
      stockName: json['Stock Name'] ?? '',
      volatility: (json['Volatility'] ?? 0).toDouble(),
      meanDailyReturn: (json['Mean Daily Return'] ?? 0).toDouble(),
      currentPrice: (json['Current Price'] ?? 0).toDouble(),
      boughtPrice: (json['Bought Price'] ?? 0).toDouble(),
      quantity: (json['Quantity'] ?? 0).toInt(),
      profitLoss: (json['Profit Loss'] ?? 0).toDouble(),
      profitLossPercentage: (json['PL Percentage'] ?? 0).toDouble(),
      totalInvestment: (json['Total Investment'] ?? 0).toDouble(),
      currentValue: (json['Current Value'] ?? 0).toDouble(),
      bestDayReturn: (json['Best Day Return'] ?? 0).toDouble(),
      bestDayDate: json['Best Day Date'] ?? '',
      worstDayReturn: (json['Worst Day Return'] ?? 0).toDouble(),
      worstDayDate: json['Worst Day Date'] ?? '',
      high30d: (json['30D High'] ?? 0).toDouble(),
      low30d: (json['30D Low'] ?? 0).toDouble(),
      sma20: (json['SMA20'] ?? 0).toDouble(),
      sma50: (json['SMA50'] ?? 0).toDouble(),
      sma200: (json['SMA200'] ?? 0).toDouble(),
      shortTerm: json['Short Term'] ?? '',
      momentum: json['Momentum'] ?? '',
      longTerm: json['Long Term'] ?? '',
      portfolioWeight: (json['Portfolio Weight'] ?? 0).toDouble(),
    );
  }
}

class DayData {
  final String date;
  final double returnValue;

  DayData({required this.date, required this.returnValue});

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      date: json['date'],
      returnValue: json['return'].toDouble(),
    );
  }
}
