import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postify/providers/history_provider.dart';
import 'package:postify/providers/page_controller.dart';
import 'package:postify/providers/request_provider.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/utils/colors.dart';
import 'package:postify/utils/http_method_colors.dart';
import 'package:postify/utils/size.dart';
import 'package:provider/provider.dart';

Map<int, String> month = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December"
};

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return context.watch<HistoryProvider>().getHistoryCount() == 0
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FeatherIcons.clipboard,
                size: width * 0.2,
                color: Colors.blue.withOpacity(0.5),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "No History",
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ],
          ))
        : Column(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.02),
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  keyboardType: TextInputType.url,
                  onChanged: (text) {
                    Provider.of<HistoryProvider>(context, listen: false)
                        .changeSearchKeyWord(text);
                  },
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: Icon(FeatherIcons.search,
                          color: Colors.blue.withOpacity(0.5)),
                    ),
                    suffixIcon:
                        context.watch<HistoryProvider>().searchKeyWord.length ==
                                0
                            ? SizedBox.shrink()
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _searchController.text = "";
                                    Provider.of<HistoryProvider>(context,
                                            listen: false)
                                        .changeSearchKeyWord("");
                                  });
                                },
                                icon: Icon(FeatherIcons.x,
                                    color: Colors.blue.withOpacity(0.5))),
                    border: InputBorder.none,
                    fillColor: Colors.blue.withOpacity(0.1),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.blue.withOpacity(0.5)),
                    hintText: "Search History",
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount:
                        context.watch<HistoryProvider>().getHistoryCount(),
                    padding: EdgeInsets.all(width * 0.02),
                    itemBuilder: (context, index) {
                      return (context
                                      .watch<HistoryProvider>()
                                      .searchKeyWord
                                      .length !=
                                  0 &&
                              !context
                                  .read<HistoryProvider>()
                                  .url[index]
                                  .contains(context
                                      .watch<HistoryProvider>()
                                      .searchKeyWord))
                          ? SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(bottom: height * 0.005),
                              child: InkWell(
                                onTap: () {
                                  setRequest(
                                      context
                                          .read<HistoryProvider>()
                                          .url[index],
                                      context
                                          .read<HistoryProvider>()
                                          .method[index],
                                      context
                                          .read<HistoryProvider>()
                                          .headers[index],
                                      context
                                          .read<HistoryProvider>()
                                          .body[index],
                                      context
                                          .read<HistoryProvider>()
                                          .syntax[index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  padding: EdgeInsets.only(left: width * 0.025),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: width * 0.135,
                                            child: Text(
                                              context
                                                  .read<HistoryProvider>()
                                                  .method[index],
                                              style: TextStyle(
                                                  color: getHttpMethodColor(
                                                      context
                                                          .read<
                                                              HistoryProvider>()
                                                          .method[index]),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.sp),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  context
                                                      .read<HistoryProvider>()
                                                      .url[index],
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: context
                                                            .watch<
                                                                ThemeProvider>()
                                                            .isDarkTheme
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  getDateTime(context
                                                      .read<HistoryProvider>()
                                                      .date[index]),
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: context
                                                            .watch<
                                                                ThemeProvider>()
                                                            .isDarkTheme
                                                        ? Colors.white
                                                            .withOpacity(0.5)
                                                        : Colors.black
                                                            .withOpacity(0.5),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: "Info",
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor: context
                                                              .read<
                                                                  ThemeProvider>()
                                                              .isDarkTheme
                                                          ? Color(0xFF1F1F1F)
                                                          : Colors.white,
                                                      title: SizedBox(
                                                        width: width * 0.9,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Request Info",
                                                              style: TextStyle(
                                                                fontSize:16.sp,
                                                                  color: !context
                                                                          .read<
                                                                              ThemeProvider>()
                                                                          .isDarkTheme
                                                                      ? Color(
                                                                          0xFF1F1F1F)
                                                                      : Colors
                                                                          .white),
                                                            ),
                                                            IconButton(
                                                              tooltip: "Copy",
                                                              icon: Icon(
                                                                  FeatherIcons
                                                                      .copy,
                                                                  color:
                                                                      primaryColor),
                                                              onPressed: () {
                                                                Clipboard
                                                                    .setData(
                                                                  ClipboardData(
                                                                    text: "URL:\n${context.read<HistoryProvider>().url[index]}\n\nMethod:\n${context.read<HistoryProvider>().method[index]}\n\nHeaders:\n${jsonDecode(context.read<HistoryProvider>().headers[index])}" +
                                                                        (context.read<HistoryProvider>().body[index].length !=
                                                                                0
                                                                            ? "\n\nBody:\n${context.read<HistoryProvider>().body[index]}"
                                                                            : ""),
                                                                  ),
                                                                );
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Copied to clipboard!",
                                                                    backgroundColor:
                                                                        primaryColor);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      content: SingleChildScrollView(
                                                                                                              child: Text(
                                                          "URL:\n${context.read<HistoryProvider>().url[index]}\n\nMethod:\n${context.read<HistoryProvider>().method[index]}\n\nHeaders:\n${jsonDecode(context.read<HistoryProvider>().headers[index])}" +
                                                              (context
                                                                          .read<
                                                                              HistoryProvider>()
                                                                          .body[
                                                                              index]
                                                                          .length !=
                                                                      0
                                                                  ? "\n\nBody:\n${context.read<HistoryProvider>().body[index]}"
                                                                  : ""),
                                                          style: TextStyle(
                                                            fontSize:16.sp,
                                                              color: !context
                                                                      .read<
                                                                          ThemeProvider>()
                                                                      .isDarkTheme
                                                                  ? Color(
                                                                      0xFF1F1F1F)
                                                                  : Colors.white),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            icon: Icon(
                                              FeatherIcons.info,
                                              color: context
                                                      .watch<ThemeProvider>()
                                                      .isDarkTheme
                                                  ? Colors.white
                                                      .withOpacity(0.5)
                                                  : Colors.black.withOpacity(
                                                      0.5,
                                                    ),
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: "Remove",
                                            onPressed: () {
                                              context
                                                  .read<HistoryProvider>()
                                                  .removeHistory(index);
                                            },
                                            icon: Icon(
                                              FeatherIcons.x,
                                              color: context
                                                      .watch<ThemeProvider>()
                                                      .isDarkTheme
                                                  ? Colors.white
                                                      .withOpacity(0.5)
                                                  : Colors.black.withOpacity(
                                                      0.5,
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          );
  }

  String getDateTime(String date) {
    String datePart = date.split("T")[0];
    String timePart = date.split("T")[1];

    timePart = timePart.split(".")[0];
    List<String> timePartSplitted = timePart.split(":");
    timePart = "${timePartSplitted[0]}:${timePartSplitted[1]}";

    List<String> datePartSplitted = datePart.split("-");
    datePart =
        "${datePartSplitted[0]} ${month[int.parse(datePartSplitted[1])]!.substring(0, 3)} ${datePartSplitted[2]}";

    String newDate = "$timePart    $datePart";
    return newDate;
  }

  setRequest(
      String url, String method, String headers, String body, String syntax) {
    Map<String, String> parsedHeaders =
        Map<String, String>.from(jsonDecode(jsonDecode(headers)));
    Provider.of<RequestProvider>(context, listen: false).changeURL(url);
    Provider.of<RequestProvider>(context, listen: false)
        .reqHeadersAddAll(parsedHeaders, true);
    Provider.of<RequestProvider>(context, listen: false)
        .changeHeadersCount(parsedHeaders.keys.length);
    for (int i = 1; i <= parsedHeaders.keys.length; i++) {
      Provider.of<RequestProvider>(context, listen: false)
        ..updateHeaders(i, {
          parsedHeaders.keys.toList()[i - 1]:
              parsedHeaders.values.toList()[i - 1]
        });
    }
    Provider.of<RequestProvider>(context, listen: false).changeMethod(method);
    Provider.of<RequestProvider>(context, listen: false).changeBody(body);
    Provider.of<RequestProvider>(context, listen: false).changeSyntax(syntax);
    Provider.of<PageControllerProvider>(context, listen: false).animatePage(1);
    Provider.of<RequestProvider>(context, listen: false).addParamsFromUrl(url);
  }
}
