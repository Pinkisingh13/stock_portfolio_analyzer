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
}