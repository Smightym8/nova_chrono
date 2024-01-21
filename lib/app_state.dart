import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  int _selectedPageIndex = 0;
  DateTime _selectedDate = DateTime.now();

  int get selectedPageIndex => _selectedPageIndex;
  DateTime get selectedDate => _selectedDate;

  set selectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }

  set selectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}