import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeStyles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme(
          background: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          primary: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          secondary: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          surface: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          error: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          onBackground: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          onError: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          onPrimary: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          onSecondary: isDarkTheme ? Colors.black : Color(0xffF1F5FB),
          onSurface: isDarkTheme ? Colors.black : Color(0xffF1F5FB)),
      scaffoldBackgroundColor: isDarkTheme ? Color(0xFF1F1F1F) : Colors.white,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
