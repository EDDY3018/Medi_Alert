import 'package:shared_preferences/shared_preferences.dart';

// Method to save respiratory rate data
void _saveRespiratoryRateToHistory(int rate) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('respiratory_rate_history') ?? [];

  // Add the new rate to the history
  history.add('Respiratory Rate: $rate breaths per minute - ${DateTime.now()}');
  
  // Save updated history back to shared preferences
  await prefs.setStringList('respiratory_rate_history', history);
}
