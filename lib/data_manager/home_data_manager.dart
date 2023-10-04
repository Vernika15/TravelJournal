import 'package:flutter/material.dart';

class HomeDataManager extends ChangeNotifier {
  int _selectedIndex = 0;
  late PageController _pageController;
  final int _currentPage = 1;

  int get selectedIndex {
    return _selectedIndex;
  }

  PageController get pageController {
    return _pageController;
  }

  int get currentPage {
    return _currentPage;
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setPageController() {
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
    notifyListeners();
  }
}
