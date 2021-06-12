import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:postify/providers/history_provider.dart';
import 'package:postify/providers/page_controller.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/screens/pages/history.dart';
import 'package:postify/screens/pages/request.dart';
import 'package:postify/screens/pages/response.dart';
import 'package:postify/screens/settings.dart';
import 'package:postify/utils/colors.dart';
import 'package:postify/utils/size.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsScreen(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Postify",
          style: TextStyle(
              color: primaryColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900),
        ),
        leading: Builder(
          builder: (context) => IconButton(
              icon: Icon(
                FeatherIcons.menu,
                color: primaryColor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              }),
        ),
      ),
      floatingActionButton: context.watch<PageControllerProvider>().pageIndex ==
                  0 &&
              context.watch<HistoryProvider>().hasHistory()
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            context.read<ThemeProvider>().isDarkTheme
                                ? Color(0xFF1F1F1F)
                                : Colors.white,
                        title: Text("Clear History?",
                            style: TextStyle(
                                color:
                                    !context.read<ThemeProvider>().isDarkTheme
                                        ? Color(0xFF1F1F1F)
                                        : Colors.white)),
                        content: Text(
                          "Are you sure, want to clear all history?",
                          style: TextStyle(
                              color: !context.read<ThemeProvider>().isDarkTheme
                                  ? Color(0xFF1F1F1F)
                                  : Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("CANCEL",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<HistoryProvider>(context,
                                      listen: false)
                                  .clearAllHistory();
                              Get.back();
                            },
                            child: Text("CLEAR ALL",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      );
                    });
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.delete),
              tooltip: "Clear History",
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 16.sp),
          currentIndex: context.watch<PageControllerProvider>().pageIndex,
          elevation: 0,
          onTap: (int index) {
            context.read<PageControllerProvider>().animatePage(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(FeatherIcons.clipboard), label: "History"),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.upload),
              label: "Request",
            ),
            BottomNavigationBarItem(
                icon: Icon(FeatherIcons.download), label: "Response"),
          ]),
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: PageView(
            controller: context.read<PageControllerProvider>().pageController,
            onPageChanged: (int index) {
              context.read<PageControllerProvider>().changePageIndex(index);
            },
            physics: BouncingScrollPhysics(),
            children: [HistoryPage(), RequestPage(), ResponsePage()],
          ),
        ),
      ),
    );
  }
}
