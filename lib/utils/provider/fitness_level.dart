import 'package:flutter/material.dart';
class FitnessLevelProvider with ChangeNotifier {
  int _selectedLevel = 1;

  int get selectedLevel => _selectedLevel;

  void setFitnessLevel(int level) {
    _selectedLevel = level;
    notifyListeners();
  }
}
