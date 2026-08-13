import 'dart:convert';

import 'package:frontend/models/home_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService{


Future<void> savehistory(StockAnalysisResponseModel report) async{
  final SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> history =  pref.getStringList("history") ?? [];
  history.add(jsonEncode(report.toJson()));
  await pref.setStringList("history", history);
}

Future<List<StockAnalysisResponseModel>> getHistory() async {
  final pref = await SharedPreferences.getInstance();
  List<String> history = pref.getStringList("history") ?? [];
  return history.map((e) => StockAnalysisResponseModel.fromJson(jsonDecode(e))).toList();
}


  Future<void> clearHistory() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("history");
  }

  Future<void> saveWithTimestamp(StockAnalysisResponseModel report, DateTime timestamp) async {
    final pref = await SharedPreferences.getInstance();
    final data = report.toJson();
    data['live_timestamp'] = timestamp.toIso8601String();
    await pref.setString('live_report_${report.stockName}', jsonEncode(data));
  }

  Future<DateTime?> getLastUpdateTimestamp(String stockName) async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('live_report_$stockName');
    if (data == null) return null;
    final json = jsonDecode(data);
    if (json['live_timestamp'] == null) return null;
    return DateTime.parse(json['live_timestamp']);
  }

  Future<void> saveMultiStockWithTimestamp(List<MultiStockItemModel> stocks, DateTime timestamp) async {
    final pref = await SharedPreferences.getInstance();
    final data = stocks.map((s) => {
      'Stock Name': s.stockName,
      'Current Price': s.currentPrice,
      'Bought Price': s.boughtPrice,
      'Quantity': s.quantity,
      'Profit Loss': s.profitLoss,
      'PL Percentage': s.profitLossPercentage,
      'Current Value': s.currentValue,
      'Portfolio Weight': s.portfolioWeight,
    }).toList();
    await pref.setString('live_multi_stock', jsonEncode({
      'stocks': data,
      'live_timestamp': timestamp.toIso8601String(),
    }));
  }

  Future<DateTime?> getMultiStockLastUpdateTimestamp() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString('live_multi_stock');
    if (data == null) return null;
    final json = jsonDecode(data);
    if (json['live_timestamp'] == null) return null;
    return DateTime.parse(json['live_timestamp']);
  }
}