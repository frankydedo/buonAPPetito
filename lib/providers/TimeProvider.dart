import 'package:flutter/material.dart';

class Timeprovider with ChangeNotifier {
  int _selectedTimeIndex = -1;

  int get selectedTimeIndex => _selectedTimeIndex;

  void setSelectedTimeIndex(int index) {
    _selectedTimeIndex = index;
    notifyListeners();
  }

  List<String> get allDifficulties => [
    "< 15" ,
    "< 30" ,
    "< 60" ,
    "< 90" ,
    "> 90" 
    ];

  List<String> get selectedDifficulties {
    if (_selectedTimeIndex == -1) {
      return [];
    }
    return allDifficulties.sublist(0, _selectedTimeIndex + 1);
  }
}
