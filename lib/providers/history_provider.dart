import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postify/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider extends ChangeNotifier {
  int historyCount = 0;
  String searchKeyWord = "";
  //SharedPreference Data
  List<String> url = [];
  List<String> body = [];
  List<String> date = [];
  List<String> headers = [];
  List<String> method = [];
  List<String> syntax = [];

  bool hasHistory(){
    return url.length == 0 ? false : true;
  }

  clearAllHistory(){
    clearHistory();
    setHistory();
    Fluttertoast.showToast(msg: "History cleared!", backgroundColor: primaryColor);
    notifyListeners();
  }

  clearHistory(){
    historyCount = 0;
      url = [];
      method = [];
      headers = [];
      body = [];
      date = [];
      syntax = [];
  }

  changeSearchKeyWord(String keyword){
    searchKeyWord = keyword;
    notifyListeners();
  }

  int getHistoryCount() {
    getHistory();
    return historyCount;
  }

  addHistory(String reqUrl, String reqMethod, String reqHeaders, String reqBody,
      String reqSyntax) async {
    reverse();
    url.add(reqUrl);
    method.add(reqMethod);
    headers.add(jsonEncode(reqHeaders));
    body.add(reqBody);
    date.add(DateTime.now().toIso8601String());
    syntax.add(reqSyntax);
    historyCount = url.length;
    setHistory();
    print("history added!" + historyCount.toString());
    notifyListeners();
  }

  getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("historyCount") == null) {
      clearHistory();
    } else {
      historyCount = prefs.getInt("historyCount")!;
      url = prefs.getStringList("url")!.reversed.toList();
      method = prefs.getStringList("method")!.reversed.toList();
      headers = prefs.getStringList("headers")!.reversed.toList();
      body = prefs.getStringList("body")!.reversed.toList();
      date = prefs.getStringList("date")!.reversed.toList();
      syntax = prefs.getStringList("syntax")!.reversed.toList();
    }
  }

  setHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("url", url);
    prefs.setStringList("method", method);
    prefs.setStringList("headers", headers);
    prefs.setStringList("body", body);
    prefs.setStringList("date", date);
    prefs.setStringList("syntax", syntax);
    prefs.setInt("historyCount", historyCount);
    getHistory();
  }

  removeHistory(int index) {
    url.removeAt(index);
    method.removeAt(index);
    headers.removeAt(index);
    body.removeAt(index);
    date.removeAt(index);
    syntax.removeAt(index);
    reverse();
    setHistory();
    notifyListeners();
  }

  reverse() {
    historyCount = url.length;
    url = url.reversed.toList();
    method = method.reversed.toList();
    headers = headers.reversed.toList();
    body = body.reversed.toList();
    date = date.reversed.toList();
    syntax = syntax.reversed.toList();
  }
}
