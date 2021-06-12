import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postify/providers/history_provider.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/screens/home.dart';
import 'package:postify/utils/size.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 2),
      () => Get.off(() => Home()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeProvider>(context).getData();
    Provider.of<HistoryProvider>(context).getHistory();
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: width,
          height: height,
          child: Center(
            child: SizedBox(
              width: width * 0.25,
              child: Image.asset(
                "assets/icon/icon250.png",
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ));
  }
}
