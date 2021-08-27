import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postify/providers/history_provider.dart';
import 'package:postify/providers/page_controller.dart';
import 'package:postify/providers/postify.dart';
import 'package:postify/providers/request_provider.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:postify/utils/size.dart';

String _url = "";

bool _showAdvanced = false;
String _tab = "headers";

FocusNode _focusNode = FocusNode();

String _body = "";

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          right: width * 0.01, bottom: height * 0.01),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _tab = "params";
                            context
                                .read<RequestProvider>()
                                .changeBodyPreview(true);
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: _tab == "params"
                              ? primaryColor.withOpacity(0.2)
                              : Colors.transparent,
                          side: BorderSide(
                              color: _tab == "params"
                                  ? primaryColor
                                  : Colors.transparent,
                              width: 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.005),
                        ),
                        child: Text(
                          context.read<RequestProvider>().params.keys.length ==
                                  0
                              ? "Params"
                              : "Params [ ${context.watch<RequestProvider>().params.keys.length} ]",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          right: width * 0.01, bottom: height * 0.01),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _tab = "headers";
                            context
                                .read<RequestProvider>()
                                .changeBodyPreview(true);
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: _tab == "headers"
                              ? primaryColor.withOpacity(0.2)
                              : Colors.transparent,
                          side: BorderSide(
                              color: _tab == "headers"
                                  ? primaryColor
                                  : Colors.transparent,
                              width: 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.005),
                        ),
                        child: Text(
                          context.watch<RequestProvider>().headers.length == 0
                              ? "Headers"
                              : "Headers [ ${context.watch<RequestProvider>().headers.length} ]",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: height * 0.01),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _tab = "body";
                            context
                                .read<RequestProvider>()
                                .changeBodyPreview(true);
                            if (context
                                    .read<RequestProvider>()
                                    .bodyController
                                    .text ==
                                "") {
                              context
                                  .read<RequestProvider>()
                                  .changeBodyPreview(false);
                              _focusNode.requestFocus();
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: _tab == "body"
                              ? primaryColor.withOpacity(0.2)
                              : Colors.transparent,
                          side: BorderSide(
                              color: _tab == "body"
                                  ? primaryColor
                                  : Colors.transparent,
                              width: 2),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.005),
                        ),
                        child: Text(
                          "Body",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ],
                ),
                _tab == "body"
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  right: width * 0.02, bottom: height * 0.01),
                              child: TextButton(
                                onPressed: () {
                                  changeSyntax("Text");
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05,
                                  ),
                                  side: BorderSide(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "Text"
                                          ? Colors.teal
                                          : Colors.transparent,
                                      width: 2),
                                  backgroundColor:
                                      context.watch<RequestProvider>().syntax ==
                                              "Text"
                                          ? Colors.teal.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                ),
                                child: Text(
                                  "Text",
                                  style: TextStyle(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "Text"
                                          ? Colors.teal
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: width * 0.02, bottom: height * 0.01),
                              child: TextButton(
                                onPressed: () {
                                  changeSyntax("JSON");
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03),
                                  side: BorderSide(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "JSON"
                                          ? Colors.pink
                                          : Colors.transparent,
                                      width: 2),
                                  backgroundColor:
                                      context.watch<RequestProvider>().syntax ==
                                              "JSON"
                                          ? Colors.pink.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                ),
                                child: Text(
                                  "JSON",
                                  style: TextStyle(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "JSON"
                                          ? Colors.pink
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: width * 0.02, bottom: height * 0.01),
                              child: TextButton(
                                onPressed: () {
                                  changeSyntax("JavaScript");
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.05),
                                  side: BorderSide(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "JavaScript"
                                          ? Colors.yellow[800]!
                                          : Colors.transparent,
                                      width: 2),
                                  backgroundColor:
                                      context.watch<RequestProvider>().syntax ==
                                              "JavaScript"
                                          ? Colors.yellow.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                ),
                                child: Text(
                                  "JavaScript",
                                  style: TextStyle(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "JavaScript"
                                          ? Colors.yellow[800]
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: width * 0.02, bottom: height * 0.01),
                              child: TextButton(
                                onPressed: () {
                                  changeSyntax("XML");
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03),
                                  side: BorderSide(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "XML"
                                          ? Colors.purple
                                          : Colors.transparent,
                                      width: 2),
                                  backgroundColor:
                                      context.watch<RequestProvider>().syntax ==
                                              "XML"
                                          ? Colors.purple.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                ),
                                child: Text(
                                  "XML",
                                  style: TextStyle(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "XML"
                                          ? Colors.purple
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: width * 0.02, bottom: height * 0.01),
                              child: TextButton(
                                onPressed: () {
                                  changeSyntax("HTML");
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03),
                                  side: BorderSide(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "HTML"
                                          ? Colors.orange[700]!
                                          : Colors.transparent,
                                      width: 2),
                                  backgroundColor:
                                      context.watch<RequestProvider>().syntax ==
                                              "HTML"
                                          ? Colors.orange.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2),
                                ),
                                child: Text(
                                  "HTML",
                                  style: TextStyle(
                                      color: context
                                                  .watch<RequestProvider>()
                                                  .syntax ==
                                              "HTML"
                                          ? Colors.orange[700]
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                Expanded(
                    child: (context.watch<RequestProvider>().bodyPreview)
                        ? ListView(
                            physics: BouncingScrollPhysics(),
                            children: _tab == "params"
                                ? buildParamFields()
                                : _tab == "body"
                                    ? buildBodyFields()
                                    : buildHeaderFields(),
                          )
                        : Column(
                            children: buildBodyFields(),
                          )),
              ],
            ),
          ),
          SizedBox(height: height * 0.01),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                !context.watch<RequestProvider>().bodyPreview
                    ? SizedBox.shrink()
                    : AnimatedSize(
                        vsync: this,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        clipBehavior: Clip.none,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: width * 0.02,
                                        bottom: height * 0.01),
                                    width: width * 0.15,
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<RequestProvider>()
                                            .changeMethod("GET");
                                      },
                                      style: TextButton.styleFrom(
                                        side: BorderSide(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "GET"
                                                ? Colors.green
                                                : Colors.transparent,
                                            width: 2),
                                        backgroundColor: context
                                                    .read<RequestProvider>()
                                                    .method ==
                                                "GET"
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2),
                                      ),
                                      child: Text(
                                        "GET",
                                        style: TextStyle(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "GET"
                                                ? Colors.green
                                                : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: width * 0.02,
                                        bottom: height * 0.01),
                                    width: width * 0.2,
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<RequestProvider>()
                                            .changeMethod("POST");
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: context
                                                    .read<RequestProvider>()
                                                    .method ==
                                                "POST"
                                            ? Colors.orange.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2),
                                        side: BorderSide(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "POST"
                                                ? Colors.orange
                                                : Colors.transparent,
                                            width: 2),
                                      ),
                                      child: Text(
                                        "POST",
                                        style: TextStyle(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "POST"
                                                ? Colors.orange
                                                : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: width * 0.02,
                                        bottom: height * 0.01),
                                    width: width * 0.15,
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<RequestProvider>()
                                            .changeMethod("PUT");
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: context
                                                    .read<RequestProvider>()
                                                    .method ==
                                                "PUT"
                                            ? Colors.pink.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2),
                                        side: BorderSide(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "PUT"
                                                ? Colors.pink
                                                : Colors.transparent,
                                            width: 2),
                                      ),
                                      child: Text(
                                        "PUT",
                                        style: TextStyle(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "PUT"
                                                ? Colors.pink
                                                : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: width * 0.02,
                                        bottom: height * 0.01),
                                    width: width * 0.2,
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<RequestProvider>()
                                            .changeMethod("DELETE");
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: context
                                                    .read<RequestProvider>()
                                                    .method ==
                                                "DELETE"
                                            ? Colors.red.withOpacity(0.2)
                                            : Colors.blue.withOpacity(0.2),
                                        side: BorderSide(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "DELETE"
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 2),
                                      ),
                                      child: Text(
                                        "DELETE",
                                        style: TextStyle(
                                            color: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "DELETE"
                                                ? Colors.red
                                                : Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                ]),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _showAdvanced = !_showAdvanced;
                                      });
                                    },
                                    icon: Icon(
                                      _showAdvanced
                                          ? FeatherIcons.chevronUp
                                          : FeatherIcons.chevronDown,
                                      color: context
                                              .watch<ThemeProvider>()
                                              .isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                              ],
                            ),
                            !_showAdvanced
                                ? SizedBox.shrink()
                                : Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: width * 0.02,
                                            bottom: height * 0.01),
                                        width: width * 0.2,
                                        child: TextButton(
                                          onPressed: () {
                                            context
                                                .read<RequestProvider>()
                                                .changeMethod("PATCH");
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "PATCH"
                                                ? Colors.purple.withOpacity(0.2)
                                                : Colors.blue.withOpacity(0.2),
                                            side: BorderSide(
                                                color: context
                                                            .read<
                                                                RequestProvider>()
                                                            .method ==
                                                        "PATCH"
                                                    ? Colors.purple
                                                    : Colors.transparent,
                                                width: 2),
                                          ),
                                          child: Text(
                                            "PATCH",
                                            style: TextStyle(
                                                color: context
                                                            .read<
                                                                RequestProvider>()
                                                            .method ==
                                                        "PATCH"
                                                    ? Colors.purple
                                                    : Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right: width * 0.02,
                                            bottom: height * 0.01),
                                        width: width * 0.2,
                                        child: TextButton(
                                          onPressed: () {
                                            context
                                                .read<RequestProvider>()
                                                .changeMethod("HEAD");
                                          },
                                          style: TextButton.styleFrom(
                                            backgroundColor: context
                                                        .read<RequestProvider>()
                                                        .method ==
                                                    "HEAD"
                                                ? Colors.teal.withOpacity(0.2)
                                                : Colors.blue.withOpacity(0.2),
                                            side: BorderSide(
                                                color: context
                                                            .read<
                                                                RequestProvider>()
                                                            .method ==
                                                        "HEAD"
                                                    ? Colors.teal
                                                    : Colors.transparent,
                                                width: 2),
                                          ),
                                          child: Text(
                                            "HEAD",
                                            style: TextStyle(
                                                color: context
                                                            .read<
                                                                RequestProvider>()
                                                            .method ==
                                                        "HEAD"
                                                    ? Colors.teal
                                                    : Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.sp),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            _showAdvanced && _url.length != 0
                                ? TextField(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: context
                                              .read<RequestProvider>()
                                              .urlController
                                              .text));
                                      Fluttertoast.showToast(
                                        msg: "Copied to clipboard!",
                                        backgroundColor: primaryColor,
                                      );
                                    },
                                    readOnly: true,
                                    controller: context
                                        .watch<RequestProvider>()
                                        .urlController,
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.01),
                                        child: Icon(
                                          FeatherIcons.copy,
                                          color: context
                                                  .watch<ThemeProvider>()
                                                  .isDarkTheme
                                              ? Colors.white.withOpacity(0.6)
                                              : Colors.black.withOpacity(0.6),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(width * 0.01)),
                                        borderSide: BorderSide.none,
                                      ),
                                      fillColor:
                                          Colors.blueGrey.withOpacity(0.1),
                                      contentPadding:
                                          EdgeInsets.all(width * 0.02),
                                      isDense: true,
                                      filled: true,
                                    ),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: context
                                              .watch<ThemeProvider>()
                                              .isDarkTheme
                                          ? Colors.white.withOpacity(0.6)
                                          : Colors.black.withOpacity(0.6),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                !context.watch<RequestProvider>().bodyPreview
                    ? SizedBox.shrink()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              height: width * 0.12,
                              alignment: Alignment.center,
                              child: TextField(
                                autofocus: false,
                                keyboardType: TextInputType.url,
                                controller: context
                                    .watch<RequestProvider>()
                                    .urlController,
                                onChanged: (text) {
                                  setState(() {
                                    _url = text;
                                  });
                                  context
                                      .read<RequestProvider>()
                                      .addParamsFromUrl(_url);
                                },
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color:
                                      context.watch<ThemeProvider>().isDarkTheme
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01),
                                    child: Icon(FeatherIcons.link,
                                        color: Colors.blue.withOpacity(0.5)),
                                  ),
                                  border: InputBorder.none,
                                  fillColor: Colors.blue.withOpacity(0.1),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.blue.withOpacity(0.5)),
                                  hintText: "Enter request URL",
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.01),
                            height: width * 0.12,
                            width: width * 0.12,
                            child: Tooltip(
                              message: "Send",
                              child: TextButton(
                                onPressed: () {
                                  _url = context
                                      .read<RequestProvider>()
                                      .urlController
                                      .text;
                                  _body = context
                                      .read<RequestProvider>()
                                      .bodyController
                                      .text;

                                  context.read<Postify>().clearResponse();
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');

                                  if (_url.length == 0) {
                                    Fluttertoast.showToast(
                                        msg: "Enter request URL",
                                        backgroundColor: Colors.red);
                                    return;
                                  }

                                  if (!_url.contains("http://") &&
                                      !_url.contains("https://")) {
                                    _url = "http://" + _url;
                                  }

                                  if (_url.contains("http://")) {
                                    _url = "http://" + _url.split("http://")[1];
                                  } else if (_url.contains("https://")) {
                                    _url =
                                        "https://" + _url.split("https://")[1];
                                  }

                                  if (_url.contains("?")) {
                                    print("contains ?");
                                    if (!_url.split("?")[1].contains("=")) {
                                      print(_url.split("?")[1].contains("="));
                                      _url = _url.replaceAll("?", "");
                                    }
                                  }

                                  // setState(() {
                                  context
                                      .read<RequestProvider>()
                                      .urlController
                                      .text = _url;
                                  // });

                                  context
                                      .read<PageControllerProvider>()
                                      .animatePage(2);

                                  addHeaders();
                                  context.read<Postify>().sendRequest(
                                      _url,
                                      context.read<RequestProvider>().method,
                                      context
                                          .read<RequestProvider>()
                                          .reqHeaders,
                                      _body);
                                  context.read<HistoryProvider>().addHistory(
                                      _url,
                                      context.read<RequestProvider>().method,
                                      jsonEncode(context
                                              .read<RequestProvider>()
                                              .reqHeaders)
                                          .toString(),
                                      _body.toString(),
                                      context.read<RequestProvider>().syntax);
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: Icon(
                                  FeatherIcons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildBodyFields() {
    List<Widget> widgets = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          context.read<RequestProvider>().bodyController.text == ""
              ? SizedBox.shrink()
              : Material(
                  color: Colors.red,
                  child: IconButton(
                    tooltip: "Delete Body",
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor:
                                  context.read<ThemeProvider>().isDarkTheme
                                      ? Color(0xFF1F1F1F)
                                      : Colors.white,
                              title: Text("Delete Body?",
                                  style: TextStyle(
                                      color: !context
                                              .read<ThemeProvider>()
                                              .isDarkTheme
                                          ? Color(0xFF1F1F1F)
                                          : Colors.white)),
                              content: Text(
                                "Are you sure, want to delete body?",
                                style: TextStyle(
                                    color: !context
                                            .read<ThemeProvider>()
                                            .isDarkTheme
                                        ? Color(0xFF1F1F1F)
                                        : Colors.white),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("CANCEL",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<RequestProvider>()
                                        .bodyController
                                        .text = "";
                                    context
                                        .read<RequestProvider>()
                                        .changeBodyPreview(true);
                                    Get.back();
                                  },
                                  child: Text("DELETE",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
          context.watch<RequestProvider>().bodyPreview
              ? Padding(
                  padding: EdgeInsets.only(left: width * 0.01),
                  child: Material(
                    color: Colors.blue,
                    child: IconButton(
                      tooltip: "Edit",
                      icon: Icon(FeatherIcons.edit, color: Colors.white),
                      onPressed: () {
                        Provider.of<RequestProvider>(context, listen: false)
                            .changeBodyPreview(false);
                      },
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: width * 0.01),
                  child: Material(
                    color: Colors.green,
                    child: IconButton(
                      tooltip: "Done",
                      icon: Icon(FeatherIcons.check, color: Colors.white),
                      onPressed: () {
                        Provider.of<RequestProvider>(context, listen: false)
                            .changeBodyPreview(true);
                      },
                    ),
                  ),
                )
        ],
      ),
      context.watch<RequestProvider>().bodyPreview
          ? GestureDetector(
              onTap: () {
                setState(() {
                  context.read<RequestProvider>().changeBodyPreview(false);
                  _focusNode.requestFocus();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: primaryColor.withOpacity(0.2))),
                child: HighlightView(
                  context.read<RequestProvider>().bodyController.text,
                  padding: EdgeInsets.all(width * 0.02),
                  language: context.watch<RequestProvider>().syntax == "HTML"
                      ? 'html'
                      : context.watch<RequestProvider>().syntax == "JSON"
                          ? 'json'
                          : context.watch<RequestProvider>().syntax ==
                                  "JavaScript"
                              ? 'javascript'
                              : context.watch<RequestProvider>().syntax == "XML"
                                  ? 'xml'
                                  : 'plaintext',
                  theme: context.read<ThemeProvider>().syntaxThemeData[
                      context.read<ThemeProvider>().syntaxTheme]!,
                  textStyle: TextStyle(fontSize: 16.sp),
                ),
              ),
            )
          : Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: primaryColor.withOpacity(0.2))),
                child: TextField(
                  autofocus: true,
                  focusNode: _focusNode,
                  controller: context.read<RequestProvider>().bodyController,
                  onChanged: (text) {
                    setState(() {
                      _body = text;
                    });
                  },
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "monospace",
                    color: context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black,
                  ),
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
    ];
    return widgets;
  }

  buildHeaderFields() {
    List<Widget> widgets = [];
    for (int i = 1; i <= context.read<RequestProvider>().headersCount; i++) {
      if (!context.read<RequestProvider>().headers.keys.toList().contains(i)) {
        continue;
      }
      widgets.add(Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            height: height * 0.06,
            child: TextField(
              controller:
                  context.watch<RequestProvider>().headers[i] != {"": ""}
                      ? new TextEditingController(
                          text: context
                              .read<RequestProvider>()
                              .headers[i]!
                              .keys
                              .toList()[0])
                      : null,
              onChanged: (text) {
                String value = context
                    .read<RequestProvider>()
                    .headers[i]![context
                        .read<RequestProvider>()
                        .headers[i]!
                        .keys
                        .toList()[0]
                        .toString()]
                    .toString();
                context.read<RequestProvider>().headers[i] = {text: value};
                addHeaders();
              },
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: context.watch<ThemeProvider>().isDarkTheme
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black),
              decoration: InputDecoration(
                hintText: "Key",
                hintStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white.withOpacity(0.2)
                        : null),
                border: InputBorder.none,
                fillColor: primaryColor.withOpacity(0.2),
                filled: true,
              ),
            ),
          )),
          SizedBox(
            width: width * 0.02,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            height: height * 0.06,
            child: TextField(
              controller: context.read<RequestProvider>().headers[i] != {"": ""}
                  ? new TextEditingController(
                      text: context.read<RequestProvider>().headers[i]![context
                          .read<RequestProvider>()
                          .headers[i]!
                          .keys
                          .toList()[0]])
                  : null,
              onChanged: (text) {
                String key = context
                    .read<RequestProvider>()
                    .headers[i]!
                    .keys
                    .toList()[0]
                    .toString();
                context.read<RequestProvider>().headers[i] = {key: text};
                addHeaders();
              },
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: context.watch<ThemeProvider>().isDarkTheme
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black),
              decoration: InputDecoration(
                hintText: "Value",
                hintStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white.withOpacity(0.2)
                        : null),
                border: InputBorder.none,
                fillColor: primaryColor.withOpacity(0.2),
                filled: true,
              ),
            ),
          )),
          Container(
            alignment: Alignment.center,
            height: height * 0.06,
            child: IconButton(
              onPressed: () {
                Provider.of<RequestProvider>(context, listen: false)
                    .removeHeader(i);
                addHeaders();
              },
              icon: Icon(
                FeatherIcons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ));
    }

    widgets.add(TextButton(
        onPressed: () {
          Provider.of<RequestProvider>(context, listen: false)
              .incrementHeadersCount();
          Provider.of<RequestProvider>(context, listen: false).updateHeaders(
              context.read<RequestProvider>().headersCount, {"": ""});
          addHeaders();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: height * 0.02)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FeatherIcons.plus),
            Row(
              children: [
                SizedBox(width: width * 0.02),
                Text(
                  "ADD HEADER",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        )));

    return widgets;
  }

  buildParamFields() {
    List<Widget> widgets = [];
    for (int key in context.read<RequestProvider>().params.keys.toList()) {
      bool condition = context.read<RequestProvider>().params[key].toString() !=
              "null" &&
          context.read<RequestProvider>().params[key]!.split("=").length == 2;
      widgets.add(Row(
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            height: height * 0.06,
            child: TextField(
              controller:
                  context.read<RequestProvider>().params[key] != " = " &&
                          condition
                      ? new TextEditingController(
                          text: context
                              .read<RequestProvider>()
                              .params[key]!
                              .split("=")[0],
                        )
                      : null,
              onChanged: (text) {
                String param =
                    context.read<RequestProvider>().params[key].toString();
                context.read<RequestProvider>().params[key] =
                    text + "=" + param.split("=")[1];
                addParamsInUrl();
              },
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: context.watch<ThemeProvider>().isDarkTheme
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black),
              decoration: InputDecoration(
                hintText: "Key",
                hintStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white.withOpacity(0.2)
                        : null),
                border: InputBorder.none,
                fillColor: primaryColor.withOpacity(0.2),
                filled: true,
              ),
            ),
          )),
          SizedBox(
            width: width * 0.02,
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            height: height * 0.06,
            child: TextField(
              controller:
                  (context.read<RequestProvider>().params[key] != " = " &&
                          condition)
                      ? new TextEditingController(
                          text: context
                              .read<RequestProvider>()
                              .params[key]!
                              .split("=")[1],
                        )
                      : null,
              onChanged: (text) {
                String param =
                    context.read<RequestProvider>().params[key].toString();
                context.read<RequestProvider>().params[key] =
                    param.split("=")[0] + "=" + text;
                addParamsInUrl();
              },
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: context.watch<ThemeProvider>().isDarkTheme
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black),
              decoration: InputDecoration(
                hintText: "Value",
                hintStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white.withOpacity(0.2)
                        : null),
                border: InputBorder.none,
                fillColor: primaryColor.withOpacity(0.2),
                filled: true,
              ),
            ),
          )),
          Container(
            alignment: Alignment.center,
            height: height * 0.06,
            child: IconButton(
              onPressed: () {
                Provider.of<RequestProvider>(context, listen: false)
                    .removeParams(key);
                addParamsInUrl();
              },
              icon: Icon(
                FeatherIcons.delete,
                color: Colors.red,
              ),
            ),
          )
        ],
      ));
    }

    widgets.add(TextButton(
        onPressed: () {
          setState(() {
            context.read<RequestProvider>().incrementParamsCount();
            context.read<RequestProvider>().changeParams(
                context.read<RequestProvider>().params.keys.toList().length + 1,
                " = ");
          });
          addParamsInUrl();
        },
        style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: height * 0.02)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FeatherIcons.plus),
            Row(
              children: [
                SizedBox(width: width * 0.02),
                Text(
                  "ADD PARAM",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        )));

    return widgets;
  }

  addParamsInUrl() {
    String url = _url;
    String hostPart = "";
    if (url.contains("?")) {
      hostPart = url.split("?")[0].toString();
    } else {
      hostPart = url;
    }

    String fullUrl = "$hostPart?";
    for (int key in context.read<RequestProvider>().params.keys.toList()) {
      if (fullUrl[fullUrl.length - 1] != "?") {
        fullUrl += "&";
      }
      fullUrl += context.read<RequestProvider>().params[key].toString();
    }

    if (context.read<RequestProvider>().paramsCount == 0 &&
        fullUrl.contains("?")) {
      fullUrl = fullUrl.split("?")[0].toString();
    }

    _url = fullUrl;
    // _urlController.text = fullUrl;
    context.read<RequestProvider>().changeURL(_url);
  }

  addHeaders() {
    Provider.of<RequestProvider>(context, listen: false).clearReqHeaders();
    for (int i = 1; i <= context.read<RequestProvider>().headersCount; i++) {
      if (!context.read<RequestProvider>().headers.keys.toList().contains(i)) {
        continue;
      }
      Provider.of<RequestProvider>(context, listen: false)
          .reqHeadersAddAll(context.read<RequestProvider>().headers[i]!, false);
    }
  }

  changeSyntax(String language) {
    setState(() {
      context.read<RequestProvider>().changeSyntax(language);
      _focusNode.requestFocus();

      String contentType = "";

      switch (language) {
        case "JSON":
          contentType = "application/json";
          break;
        case "JavaScript":
          contentType = "application/javascript";
          break;
        case "XML":
          contentType = "application/xml";
          break;
        case "HTML":
          contentType = "text/html";
          break;
        default:
          contentType = "text/plain";
          break;
      }

      bool _set = false;

      for (int i = 1; i <= context.read<RequestProvider>().headersCount; i++) {
        if (!context
            .read<RequestProvider>()
            .headers
            .keys
            .toList()
            .contains(i)) {
          continue;
        }
        if (context
            .read<RequestProvider>()
            .headers[i]!
            .keys
            .toList()[0]
            .toLowerCase()
            .contains("content-type")) {
          context.read<RequestProvider>().headers[i] = {
            "Content-Type": contentType
          };
          _set = true;
        }
      }

      if (!_set) {
        Provider.of<RequestProvider>(context, listen: false)
            .incrementHeadersCount();
        Provider.of<RequestProvider>(context, listen: false).updateHeaders(
            context.read<RequestProvider>().headersCount,
            {"Content-Type": contentType});

        addHeaders();
      }
    });
  }
}
