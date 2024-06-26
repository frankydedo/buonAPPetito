import 'package:flutter/material.dart';

class DifficultyProvider with ChangeNotifier {
  int _selectedDifficultyIndex = -1;

  int get selectedDifficultyIndex => _selectedDifficultyIndex;

  void setSelectedDifficultyIndex(int index) {
    _selectedDifficultyIndex = index;
    notifyListeners();
  }

  List<String> get allDifficulties => [
    "Principiante",
    "Amatoriale",
    "Intermedio",
    "Chef",
    "Chef Stellato"
  ];

  Map<String, int> get difficultyLevels => {
    "Principiante": 1,
    "Amatoriale": 2,
    "Intermedio": 3,
    "Chef": 4,
    "Chef Stellato": 5
  };

  List<String> get selectedDifficulties {
    if (_selectedDifficultyIndex == -1) {
      return [];
    }
    return allDifficulties.sublist(0, _selectedDifficultyIndex + 1);
  }
}
