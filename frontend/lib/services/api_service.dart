import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_model.dart';
import 'dart:developer';

class ApiService {
  static const String baseUrl = 'http://192.168.1.12:8000';
  
  // http://127.0.0.1:8000/analyze/single-stock

  Future<StockAnalysisResponseModel?> analyzeSingleStock({
    required String stockName,
    required double buyPrice,
    required int quantity,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/analyze/single-stock');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'stockname': stockName,
          'price': buyPrice,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return StockAnalysisResponseModel.fromJson(jsonData);
      } else {
        log('Error: ${response.statusCode}');
        log('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception occurred: $e');
      return null;
    }
  }

  Future<bool> testConnection() async {
    try {
      final url = Uri.parse('$baseUrl/');
      final response = await http.get(url);
      return response.statusCode == 200;
    } catch (e) {
      log('Connection test failed: $e');
      return false;
    }
  }
}