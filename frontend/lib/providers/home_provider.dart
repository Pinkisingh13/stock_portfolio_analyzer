import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/home_model.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/services/localdatabse_service.dart';

class HomeProvider extends ChangeNotifier {
  final apiservice = ApiService();
  final localDb = SharedPreferenceService();
  StockAnalysisResponseModel? stockData;
  List<MultiStockItemModel>? multiStockData;
  List<StockAnalysisResponseModel> history = [];
  bool isLoading = false;

  // single stock data
  Future<void> callanalyzeSingleStock(
    String stockname,
    double price,
    int quantity,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await apiservice.analyzeSingleStock(
        stockName: stockname,
        buyPrice: price,
        quantity: quantity,
      );
      if (result != null) {
        stockData = result;
      } else {
        log('Failed to fetch data. Please check if backend is running.');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // multiple stock data
  Future<void> callanalyzeMultipleStocks(
    List<String> stockNames,
    List<double> prices,
    List<int> quantities,
  ) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await apiservice.analyzeMultipleStocks(
        stockNames: stockNames,
        prices: prices,
        quantities: quantities,
      );
      if (result != null) {
        multiStockData = result;
      } else {
        log('Failed to fetch multi-stock data.');
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMultiStockData() {
    multiStockData = null;
    notifyListeners();
  }

  // Save current report to history
  Future<void> saveToHistory() async {
    if (stockData != null) {
      log('Saving to history: ${stockData!.stockName}');
      await localDb.savehistory(stockData!);
      await loadHistory();
      log('History count after save: ${history.length}');
    } else {
      log('saveToHistory called but stockData is null!');
    }
  }

  // Load all history
  Future<void> loadHistory() async {
    history = await localDb.getHistory();
    log('Loaded history: ${history.length} items');
    notifyListeners();
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    await localDb.clearHistory();
    history = [];
    notifyListeners();
  }

  // Set stock data (for viewing history report)
  void setStockData(StockAnalysisResponseModel report) {
    stockData = report;
    notifyListeners();
  }

  // Clear current stock data (after viewing report)
  void clearStockData() {
    stockData = null;
    notifyListeners();
  }
}
