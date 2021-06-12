import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postify/providers/history_provider.dart';
import 'package:postify/providers/page_controller.dart';
import 'package:postify/providers/request_provider.dart';
import 'package:postify/providers/theme_provider.dart';
import 'package:postify/screens/splash_screen.dart';
import 'package:postify/providers/postify.dart';
import 'package:postify/utils/colors.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(460,790),
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Postify()),
          ChangeNotifierProvider(create: (context) => PageControllerProvider()),
          ChangeNotifierProvider(create: (context) => RequestProvider()),
          ChangeNotifierProvider(create: (context) => HistoryProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ],
        child: App()
      ),
    );
  }
}

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Builder(
          builder: (context) => GetMaterialApp(
            home: SplashScreen(),
            theme: ThemeData().copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
              ),
              scaffoldBackgroundColor:
                  context.watch<ThemeProvider>().isDarkTheme
                      ? Color(0xFF1F1F1F)
                      : Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: context.watch<ThemeProvider>().isDarkTheme
                      ? Color(0xFF1F1F1F)
                      : Colors.white,
                textTheme: GoogleFonts.poppinsTextTheme(),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: context.watch<ThemeProvider>().isDarkTheme
                      ? Color(0xFF1F1F1F)
                      : Colors.white,
                selectedIconTheme: IconThemeData(
                  color: primaryColor
                ),
                unselectedIconTheme: IconThemeData(
                  color: context.watch<ThemeProvider>().isDarkTheme
                      ? Colors.white.withOpacity(0.45)
                      : Colors.black45,
                ),
                selectedItemColor: primaryColor,
                unselectedItemColor: context.watch<ThemeProvider>().isDarkTheme
                      ? Colors.white.withOpacity(0.45)
                      : Colors.black45,
              ),
            ),
          ),
        );
  }
}