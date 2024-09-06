import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseProvider with ChangeNotifier {
 int _selectedOption = -1; // Default value for no selection

  // Getter to access selectedOption
  int get selectedOption => _selectedOption;

  // Function to update selectedOption and notify listeners
  void updateSelectedOption(int option) {
    _selectedOption = option;
    notifyListeners();
  }

  // Save selected option to SharedPreferences
  Future<void> _saveSelectedOptionToPrefs(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedExerciseOption', value);
  }

  // Load selected option from SharedPreferences
  Future<void> loadSelectedOptionFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedOption = prefs.getInt('selectedExerciseOption') ?? -1;
    notifyListeners();
  }
}
