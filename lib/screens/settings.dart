import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/utils/colors.dart';
import 'package:postify/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Map<String, String> _syntaxSample = {
  "xml": """<!--XML Sample-->
<?xml version="1.0"?>
<users>
   <user id="1">
    <title>Sample Title 1</title>
    <body>Sample Body 1</title>
    <data>Sample Data 1</title>
   </user>
</users>
""",
  "html": """<!--HTML Sample-->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    Sample HTML
</body>
</html>
""",
  "plaintext": """Plain text sample.
Lorem ipsum dolor sit amet consectetur adipisicing elit.
Beatae fugiat ad architecto velit ut ipsum voluptates incidunt,
quibusdam, hic praesentium et. Ratione cumque dolorem delectus
porro excepturi possimus laborum fugiat!
""",
  "json": """///JSON Sample
[
  {
    "userId": 1,
    "id": 1,
    "title": "Sample Title 1",
    "body": "Sample Body 1",
    "data": ["sample", "data"]
  }
]
""",
  "javascript": """//JavaScript Sample 
function getData(){
var data = [
  {
    "userId": 1,
    "id": 1,
    "title": "Sample Title 1",
    "body": "Sample Body 1",
    "data": ["sample", "data"]
  }
]
return data;
}"""
};

String _selectedSyntaxLanguage = "json";

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(width * 0.02),
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                ],
              ),
              Expanded(
                  child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  ListTile(
                    onTap: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .switchDarkTheme();
                    },
                    leading: Icon(FeatherIcons.moon,
                        color: context.watch<ThemeProvider>().isDarkTheme
                            ? Colors.white
                            : Colors.black),
                    title: Text(
                      "Dark Theme",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: context.watch<ThemeProvider>().isDarkTheme
                              ? Colors.white
                              : Colors.black),
                    ),
                    trailing: Switch(
                      value: context.watch<ThemeProvider>().isDarkTheme,
                      onChanged: (x) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .switchDarkTheme();
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  ListTile(
                      leading: Icon(FeatherIcons.code,
                          color: context.watch<ThemeProvider>().isDarkTheme
                              ? Colors.white
                              : Colors.black),
                      title: Text("Syntax Theme",
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: context.watch<ThemeProvider>().isDarkTheme
                                  ? Colors.white
                                  : Colors.black))),
                  Divider(),
                  AnimatedSize(
                    vsync: this,
                    curve: Curves.easeOut,
                    clipBehavior: Clip.none,
                    duration: Duration(milliseconds: 400),
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: primaryColor.withOpacity(0.2))),
                        child: HighlightView(
                          _syntaxSample[_selectedSyntaxLanguage]!,
                          language: _selectedSyntaxLanguage,
                          theme: context.read<ThemeProvider>().syntaxThemeData[
                              context.watch<ThemeProvider>().syntaxTheme]!,
                          padding: EdgeInsets.all(width * 0.02),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  SingleChildScrollView(
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
                              setState(() {
                                _selectedSyntaxLanguage = "plaintext";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.05,
                              ),
                              side: BorderSide(
                                  color: _selectedSyntaxLanguage == "plaintext"
                                      ? Colors.teal
                                      : Colors.transparent,
                                  width: 2),
                              backgroundColor:
                                  _selectedSyntaxLanguage == "plaintext"
                                      ? Colors.teal.withOpacity(0.2)
                                      : Colors.blue.withOpacity(0.2),
                            ),
                            child: Text(
                              "Text",
                              style: TextStyle(
                                  color: _selectedSyntaxLanguage == "plaintext"
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
                              setState(() {
                                _selectedSyntaxLanguage = "json";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              side: BorderSide(
                                  color: _selectedSyntaxLanguage == "json"
                                      ? Colors.pink
                                      : Colors.transparent,
                                  width: 2),
                              backgroundColor: _selectedSyntaxLanguage == "json"
                                  ? Colors.pink.withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.2),
                            ),
                            child: Text(
                              "JSON",
                              style: TextStyle(
                                  color: _selectedSyntaxLanguage == "json"
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
                              setState(() {
                                _selectedSyntaxLanguage = "javascript";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05),
                              side: BorderSide(
                                  color: _selectedSyntaxLanguage == "javascript"
                                      ? Colors.yellow[800]!
                                      : Colors.transparent,
                                  width: 2),
                              backgroundColor:
                                  _selectedSyntaxLanguage == "javascript"
                                      ? Colors.yellow.withOpacity(0.2)
                                      : Colors.blue.withOpacity(0.2),
                            ),
                            child: Text(
                              "JavaScript",
                              style: TextStyle(
                                  color: _selectedSyntaxLanguage == "javascript"
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
                              setState(() {
                                _selectedSyntaxLanguage = "xml";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              side: BorderSide(
                                  color: _selectedSyntaxLanguage == "xml"
                                      ? Colors.purple
                                      : Colors.transparent,
                                  width: 2),
                              backgroundColor: _selectedSyntaxLanguage == "xml"
                                  ? Colors.purple.withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.2),
                            ),
                            child: Text(
                              "XML",
                              style: TextStyle(
                                  color: _selectedSyntaxLanguage == "xml"
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
                              setState(() {
                                _selectedSyntaxLanguage = "html";
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03),
                              side: BorderSide(
                                  color: _selectedSyntaxLanguage == "html"
                                      ? Colors.orange[700]!
                                      : Colors.transparent,
                                  width: 2),
                              backgroundColor: _selectedSyntaxLanguage == "html"
                                  ? Colors.orange.withOpacity(0.2)
                                  : Colors.blue.withOpacity(0.2),
                            ),
                            child: Text(
                              "HTML",
                              style: TextStyle(
                                  color: _selectedSyntaxLanguage == "html"
                                      ? Colors.orange[700]
                                      : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: buildThemeList(),
                  ),
                  SizedBox(height: height * 0.04),
                  Divider(
                      thickness: 2,
                      color: context.watch<ThemeProvider>().isDarkTheme
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2)),
                  SizedBox(height: height * 0.01),
                  Text("@aqeelshamz",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: context.watch<ThemeProvider>().isDarkTheme
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5))),
                              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: "GitHub",
                          icon: Icon(FeatherIcons.github,
                              color: context.watch<ThemeProvider>().isDarkTheme
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5)),
                          onPressed: () {
                            launch("https://github.com/aqeelshamz");
                          }),
                      IconButton(
                        tooltip: "Instagram",
                          icon: Icon(FeatherIcons.instagram,
                              color: context.watch<ThemeProvider>().isDarkTheme
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5)),
                          onPressed: () {
                            launch("https://instagram.com/aqeelshamz");
                          }),
                      IconButton(
                        tooltip: "Twitter",
                          icon: Icon(FeatherIcons.twitter,
                              color: context.watch<ThemeProvider>().isDarkTheme
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5)),
                          onPressed: () {
                            launch("https://twitter.com/aqeelshamz");
                          }),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                   Divider(
                      thickness: 2,
                      color: context.watch<ThemeProvider>().isDarkTheme
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2)),
                  SizedBox(height: height * 0.01),
                  Text("Postify v1.0.0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: context.watch<ThemeProvider>().isDarkTheme
                              ? Colors.white.withOpacity(0.5)
                              : Colors.black.withOpacity(0.5))),
                  SizedBox(height: height * 0.02),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  buildThemeList() {
    List<Widget> widgets = [];
    for (var themeName
        in context.read<ThemeProvider>().syntaxThemeData.keys.toList()) {
      widgets.add(
        ListTile(
          selected: context.watch<ThemeProvider>().syntaxTheme ==
              themeName.toString(),
          selectedTileColor: primaryColor.withOpacity(0.1),
          title: Text(
            themeName.toString(),
            style: TextStyle(
                color: context.watch<ThemeProvider>().syntaxTheme ==
                        themeName.toString()
                    ? primaryColor
                    : context.watch<ThemeProvider>().isDarkTheme
                        ? Colors.white
                        : Colors.black,
                fontSize: 16.sp),
          ),
          trailing:
              context.watch<ThemeProvider>().syntaxTheme == themeName.toString()
                  ? Icon(FeatherIcons.check, color: primaryColor)
                  : SizedBox.shrink(),
          onTap: () {
            Provider.of<ThemeProvider>(context, listen: false)
                .changeSyntaxTheme(themeName.toString());
          },
        ),
      );
    }
    return widgets;
  }
}
