import 'package:flutter/material.dart';

Color getHttpMethodColor(String method) {
  return method == "POST"
      ? Colors.orange
      : method == "GET"
          ? Colors.green
          : method == "PUT"
              ? Colors.pink
              : method == "DELETE"
                  ? Colors.red
                  : method == "PATCH"
                      ? Colors.purple
                      : Colors.teal;
}
