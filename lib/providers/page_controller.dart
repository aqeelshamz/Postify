import 'package:flutter/cupertino.dart';

class PageControllerProvider extends ChangeNotifier {
  int pageIndex = 1;
  PageController pageController = PageController(initialPage: 1);

  changePageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

  animatePage(int index) {
    pageIndex=  index;
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
