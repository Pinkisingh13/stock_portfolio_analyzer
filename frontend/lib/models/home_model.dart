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
    };
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
