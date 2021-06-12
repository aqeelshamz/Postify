import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Postify extends ChangeNotifier {
  http.Client httpClient = http.Client();
  http.Response response = http.Response("", 9000);
  bool loading = false;
  Duration time = Duration(milliseconds: 0);
  String method = "";

  clearResponse() {
    response = http.Response("x", 9000);
  }

  void sendRequest(String reqUrl, String reqMethod, Map<String, String> headers,
      dynamic body) async {
    DateTime startTime = DateTime.now();
    method = reqMethod;
    loading = true;
    response = http.Response(
      "",
      9000,
    );
    notifyListeners();

    if (headers.values.contains("application/json")) {
      Map<String, dynamic> _reqBody = {};
      try {
        _reqBody = jsonDecode(body);
      } catch (e) {
        _reqBody = {};
      }
      body = jsonEncode(_reqBody);
    } else {
      body = body.toString();
    }
    //Set user-agent
    headers["user-agent"] = "Postify/1.0.0";

    Uri url = Uri.parse(reqUrl);
    httpClient = new http.Client();

    try {
      switch (method) {
        case "GET":
          response = await httpClient.get(url, headers: headers);
          break;
        case "POST":
          response = await httpClient.post(url, body: body, headers: headers);
          break;
        case "DELETE":
          response = await httpClient.delete(
            url,
            body: body,
            headers: headers,
          );
          break;
        case "PUT":
          response = await httpClient.put(
            url,
            body: body,
            headers: headers,
          );
          break;
        case "PATCH":
          response = await httpClient.patch(
            url,
            body: body,
            headers: headers,
          );
          break;
        case "HEAD":
          response = await httpClient.head(
            url,
          );
          break;
        default:
          response = http.Response(
            "",
            99612,
          );
      }
    } on http.ClientException catch(e) {
      response = http.Response(
        e.toString(),
        9000,
      );
    } on SocketException catch (e) {
      response = http.Response(
        e.message.toString().replaceAll("SocketException: ", "").replaceAll(
            " (OS Error: No address associated with hostname, errno = 7)", ""),
        e.message.contains("cancelled") ? 9000 : 99612,
      );
    } catch (e) {
      response = http.Response(
        "",
        99612,
      );
    }

    DateTime endTime = DateTime.now();
    time = endTime.difference(startTime);
    loading = false;
    notifyListeners();
  }

  void cancelRequest() {
    loading = false;
    response = http.Response("", 9000);
    httpClient.close();
    notifyListeners();
    print("closed");
  }
}
