import 'package:flutter/cupertino.dart';

class SelectedPageProvider extends ChangeNotifier {
  int _selectedPageIndex = 0;

  int get selectedPageIndex => _selectedPageIndex;

  set selectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }
}