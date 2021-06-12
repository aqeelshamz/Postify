import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:postify/utils/colors.dart';
import 'package:postify/utils/size.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PreviewScreen extends StatefulWidget {
  final String bodyData;
  final String mimeType;
  final String url;
  PreviewScreen(this.bodyData, this.mimeType, this.url);

  @override
  PreviewScreenState createState() => PreviewScreenState();
}

class PreviewScreenState extends State<PreviewScreen> {
  WebViewController? _webController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        FeatherIcons.arrowLeft,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  Text(
                    "Preview",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ],
              ),
              Expanded(
                child: WebView(
                  gestureNavigationEnabled: true,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: Uri.dataFromString(widget.bodyData,
                          mimeType: widget.mimeType,
                          encoding: Encoding.getByName('utf-8'))
                      .toString(),
                  onWebViewCreated: (WebViewController controller) {
                    if (widget.mimeType.contains("image") &&
                        !widget.mimeType.contains("svg")) {
                      _webController = controller;
                      _webController!.evaluateJavascript(
                          "location.href='${widget.url}'");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
