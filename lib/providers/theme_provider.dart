import 'package:flutter/cupertino.dart';
import 'package:flutter_highlight/themes/androidstudio.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:flutter_highlight/themes/vs2015.dart';
import 'package:flutter_highlight/themes/xcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  bool isDarkTheme = false;
  String syntaxTheme = "GitHub";
  Map<String, Map<String, TextStyle>> syntaxThemeData = {
  "Android Studio": androidstudioTheme,
  "Atom One Light": atomOneLightTheme,
  "Atom One Dark": atomOneDarkTheme,
  "GitHub": githubTheme,
  "Night Owl": nightOwlTheme,
  "VS Code": vs2015Theme,
  "X Code": xcodeTheme
};

  switchDarkTheme(){
    isDarkTheme = !isDarkTheme;
    setData();
    notifyListeners();
  }

  changeSyntaxTheme(String theme){
    syntaxTheme = theme;
    setData();
    notifyListeners();
  }

  setData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkTheme", isDarkTheme);
    prefs.setString("syntaxTheme", syntaxTheme);
    notifyListeners();
  }

  getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool("darkTheme") == null ? false : prefs.getBool("darkTheme")!;
    syntaxTheme = prefs.getString("syntaxTheme") == null ? "GitHub" : prefs.getString("syntaxTheme")!;
    notifyListeners();
  }
}