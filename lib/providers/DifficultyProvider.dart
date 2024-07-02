import 'package:flutter/material.dart';

class DifficultyProvider with ChangeNotifier {
  List<int> _selectedDifficultyIndices = [];

  List<int> get selectedDifficultyIndices => _selectedDifficultyIndices;

  void toggleDifficultyIndex(int index) {
    if (_selectedDifficultyIndices.contains(index)) {
      _selectedDifficultyIndices.remove(index);
    } else {
      _selectedDifficultyIndices.add(index);
    }
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
    "Principiante": 0,
    "Amatoriale": 1,
    "Intermedio": 2,
    "Chef": 3,
    "Chef Stellato": 4
  };

  List<String> get selectedDifficulties {
    List<String> selected = [];
    for (int index in _selectedDifficultyIndices) {
      selected.add(allDifficulties[index]);
    }
    return selected;
  }

  bool isSelected(int index) {
    return _selectedDifficultyIndices.contains(index);
  }

  bool get hasSelection => _selectedDifficultyIndices.isNotEmpty;

  void resetSelection() {
    _selectedDifficultyIndices.clear();
    notifyListeners();
  }
}
