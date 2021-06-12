import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  String method = "GET";
  String syntax = "Text";

  int paramsCount = 0;
  Map<int, String> params = {};

  int headersCount = 0;
  Map<int, Map<String, String>> headers = {};

  Map<String, String> reqHeaders = {};
  TextEditingController urlController = TextEditingController();

  bool bodyPreview = true;
  TextEditingController bodyController = TextEditingController();

  addParamsFromUrl(String url) {
    List<String> params = [];
    if (url.contains("?")) {
      String paramsPart = url.split("?")[1];
      if (paramsPart.contains("&")) {
        params = paramsPart.split("&");
      } else {
        params = [paramsPart];
      }
    }

    clearParams();
    for (var i in params) {
      changeParams(params.indexOf(i) + 1, i);
      incrementParamsCount();
    }
    notifyListeners();
  }

  clearParams() {
    params.clear();
    params = {};
    paramsCount = 0;
    notifyListeners();
  }

  changeParams(int key, String value) {
    params[key] = value;
    notifyListeners();
  }

  removeParams(int pos) {
    params.remove(pos);
    notifyListeners();
  }

  incrementParamsCount() {
    paramsCount++;
    notifyListeners();
  }

  changeSyntax(String newSyntax) {
    syntax = newSyntax;
    notifyListeners();
  }

  changeBodyPreview(bool newBodyPreview) {
    bodyPreview = newBodyPreview;
    notifyListeners();
  }

  changeBody(String newBody) {
    bodyController.text = newBody;
  }

  changeMethod(String newMethod) {
    method = newMethod;
    notifyListeners();
  }

  changeHeadersCount(int val) {
    headersCount = val;
  }

  incrementHeadersCount() {
    headersCount++;
    notifyListeners();
  }

  updateHeaders(int key, Map<String, String> value) {
    if(key == 0){
      key++;
    }
    headers[key] = value;
    notifyListeners();
  }

  updateReqHeaders(String key, String value) {
    reqHeaders[key] = value;
  }

  clearReqHeaders() {
    reqHeaders = {};
  }

  reqHeadersAddAll(Map<String, String> val, bool reset) {
    if (reset) {
      headers = {};
      reqHeaders = {};
    }
    reqHeaders.addAll(val);
  }

  removeHeader(int key) {
    headers.remove(key);
    notifyListeners();
  }

  changeURL(String newUrl) {
    urlController.text = newUrl;
  }
}
