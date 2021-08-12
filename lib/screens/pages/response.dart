import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:postify/providers/page_controller.dart';
import 'package:postify/providers/postify.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/screens/preview.dart';
import 'package:postify/utils/colors.dart';
import 'package:postify/utils/http_method_colors.dart';
import 'package:postify/utils/http_status.dart';
import 'package:postify/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class ResponsePage extends StatefulWidget {
  const ResponsePage({Key? key}) : super(key: key);

  @override
  ResponsePageState createState() => ResponsePageState();
}

class ResponsePageState extends State<ResponsePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<Postify>().loading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                    context.watch<ThemeProvider>().isDarkTheme
                        ? "assets/animations/sending_rocket_dark.json"
                        : "assets/animations/sending_rocket_white.json",
                    width: width * 0.35,
                    fit: BoxFit.cover),
                Text(
                  "Sending request...",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
                SizedBox(height: height * 0.01),
                TextButton(
                    onPressed: () {
                      context.read<Postify>().cancelRequest();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: primaryColor.withOpacity(0.2)),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ))
              ],
            ),
          )
        : Builder(
            builder: (context) =>
                buildResponse(context.read<Postify>().response));
  }

  Widget buildResponse(http.Response response) {
    Widget widget = SizedBox.shrink();
    if (response.statusCode == 9000) {
      widget = Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.read<PageControllerProvider>().animatePage(1);
            },
            child: Icon(
              FeatherIcons.send,
              size: width * 0.25,
              color: Colors.blue.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            "Send request to get response",
            style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ));
    } else if (response.statusCode >= 99610) {
      widget = Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FeatherIcons.xCircle,
            size: width * 0.25,
            color: Colors.red.withOpacity(0.5),
          ),
          SizedBox(height: height * 0.01),
          Text(
            "Could not send request",
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: context.watch<ThemeProvider>().isDarkTheme
                    ? Colors.white
                    : Colors.black87),
          ),
          SizedBox(
            width: width * 0.9,
            child: Text(
              response.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.watch<ThemeProvider>().isDarkTheme
                    ? Colors.white.withOpacity(0.5)
                    : Colors.black54,
                fontSize: 16.sp,
              ),
            ),
          )
        ],
      ));
    } else {
      int resTime = context.read<Postify>().time.inMilliseconds;
      String time = "";
      http.Response resp = context.read<Postify>().response;
      TextStyle titleStyle = TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
          color: context.watch<ThemeProvider>().isDarkTheme
              ? Colors.white.withOpacity(0.8)
              : Colors.black);
      TextStyle bodyStyle = TextStyle(
          fontSize: 16.sp,
          color: context.watch<ThemeProvider>().isDarkTheme
              ? Colors.white.withOpacity(0.7)
              : Colors.black);

      if (resTime > 1000) {
        time = (resTime / 1000).toString() + "s";
      } else {
        time = resTime.toString() + "ms";
      }

      widget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.02,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Status",
                    style: TextStyle(
                        color: getStatusColor(
                            context.read<Postify>().response.statusCode),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp),
                  ),
                  Text(
                    context.read<Postify>().response.statusCode.toString(),
                    style: TextStyle(
                        color: getStatusColor(
                            context.watch<Postify>().response.statusCode),
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp),
                  ),
                ],
              ),
              Column(children: [
                Text(
                  "Time",
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp),
                ),
                Text(
                  time,
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.sp),
                )
              ]),
              Column(
                children: [
                  Text("Size",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp)),
                  Text(
                      (context.read<Postify>().response.contentLength! / 1000)
                              .toStringAsFixed(2) +
                          " KB",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp))
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                      unselectedWidgetColor:
                          Provider.of<ThemeProvider>(context).isDarkTheme
                              ? Colors.white
                              : Colors.black),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "Request Details",
                          style: titleStyle.copyWith(fontSize: 16.sp),
                        ),
                        IconButton(
                            icon: Icon(FeatherIcons.copy, color: primaryColor),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text:
                                      "Request Details (Postify Rest API Client)\n\nURL: ${resp.request!.url}\nMethod: ${resp.request!.method}\nHeaders: ${resp.request!.headers}"));
                              Fluttertoast.showToast(
                                  msg: "Copied to clipboard!",
                                  backgroundColor: primaryColor);
                            }),
                      ],
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    childrenPadding: EdgeInsets.all(width * 0.02),
                    children: [
                      Wrap(
                        children: [
                          Text(
                            "URL:  ",
                            style: titleStyle,
                          ),
                          Text(
                            resp.request!.url.toString(),
                            style: bodyStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Wrap(children: [
                        Text("Method:  ", style: titleStyle),
                        Text(
                          resp.request!.method.toString(),
                          style: bodyStyle.copyWith(
                              color: getHttpMethodColor(resp.request!.method),
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Wrap(
                        children: [
                          Text("Headers:  ", style: titleStyle),
                          Text(
                            resp.request!.headers.toString(),
                            style: bodyStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      unselectedWidgetColor:
                          Provider.of<ThemeProvider>(context).isDarkTheme
                              ? Colors.white
                              : Colors.black),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "Response Details",
                          style: titleStyle.copyWith(fontSize: 16.sp),
                        ),
                        IconButton(
                            icon: Icon(FeatherIcons.copy, color: primaryColor),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text:
                                      "Response Details (Postify Rest API Client)\n\nStatus: ${resp.statusCode} ${getStatusTitle(resp.statusCode)}\nHeaders: ${resp.headers}\nContent-Length: ${resp.contentLength}\nRedirect: ${resp.isRedirect ? 'Yes' : 'No'}"));
                              Fluttertoast.showToast(
                                  msg: "Copied to clipboard!",
                                  backgroundColor: primaryColor);
                            }),
                      ],
                    ),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    childrenPadding: EdgeInsets.all(width * 0.02),
                    children: [
                      Wrap(
                        children: [
                          Text("Status:  ", style: titleStyle),
                          Text(
                            resp.statusCode.toString() +
                                " " +
                                getStatusTitle(resp.statusCode),
                            style: bodyStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: getStatusColor(resp.statusCode)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Wrap(
                        children: [
                          Text("Headers: ", style: titleStyle),
                          Text(
                            resp.headers.toString(),
                            style: bodyStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Wrap(
                        children: [
                          Text("Content-Length:  ", style: titleStyle),
                          Text(
                            resp.contentLength.toString(),
                            style: bodyStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                      Wrap(
                        children: [
                          Text("Redirect:  ", style: titleStyle),
                          Text(
                            resp.isRedirect ? "Yes" : "No",
                            style: bodyStyle,
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.005,
                      ),
                    ],
                  ),
                ),
                HighlightView(
                  context.read<Postify>().response.body,
                  padding: EdgeInsets.all(width * 0.02),
                  language: getLanguage(
                      jsonEncode(context.read<Postify>().response.headers)),
                  theme: context.read<ThemeProvider>().syntaxThemeData[
                      context.read<ThemeProvider>().syntaxTheme]!,
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
          context.watch<Postify>().response.statusCode != 9000 &&
                  context.watch<Postify>().response.statusCode < 9000 &&
                  context.watch<PageControllerProvider>().pageIndex == 2
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: context.read<Postify>().response.body));
                          Fluttertoast.showToast(
                              msg: "Copied to clipboard!",
                              backgroundColor: primaryColor);
                        },
                        icon: Icon(FeatherIcons.copy, color: primaryColor),
                        label: Text("Copy",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Share.share(context.read<Postify>().response.body);
                        },
                        icon: Icon(FeatherIcons.share2, color: primaryColor),
                        label: Text("Share",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Get.to(
                              () => PreviewScreen(
                                    context.read<Postify>().response.body,
                                    getMimeType(jsonEncode(context
                                        .read<Postify>()
                                        .response
                                        .headers)),
                                    resp.request!.url.toString(),
                                  ),
                              transition: Transition.rightToLeft);
                        },
                        icon: Icon(FeatherIcons.eye, color: primaryColor),
                        label: Text("Preview",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      );
    }
    return widget;
  }

  getMimeType(String headers) {
    String mimeType = "text/plain";
    if (jsonDecode(headers.toLowerCase()).keys.contains("content-type")) {
      String contentType = jsonDecode(headers.toLowerCase())["content-type"]
          .toString()
          .split(",")[0]
          .replaceAll(" ", "");
      contentType = jsonDecode(headers.toLowerCase())["content-type"]
          .toString()
          .split(";")[0]
          .replaceAll(" ", "");
      mimeType = contentType;
    }
    return mimeType;
  }

  getLanguage(String headers) {
    String language = "plaintext";
    if (jsonDecode(headers.toLowerCase()).keys.contains("content-type")) {
      String contentType =
          jsonDecode(headers.toLowerCase())["content-type"].toString();
      if (contentType.contains("text/plain")) {
        language = "plaintext";
      } else if (contentType.contains("application/json")) {
        language = "json";
      } else if (contentType.contains("application/javascript")) {
        language = "javascript";
      } else if (contentType.contains("text/html")) {
        language = "html";
      } else if (contentType.contains("application/xml")) {
        language = "xml";
      } else {
        language = "plaintext";
      }
    }
    return language;
  }
}
