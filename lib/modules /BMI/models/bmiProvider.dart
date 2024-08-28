import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiProvider with ChangeNotifier {
  double _weight = 0.0;
  double _height = 0.0;
  double _bmi = 0.0;

  double get weight => _weight;
  double get height => _height;
  double get bmi => _bmi;

  BmiProvider() {
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _weight = prefs.getDouble('weight') ?? 0.0;
    _height = prefs.getDouble('height') ?? 0.0;
    _bmi = prefs.getDouble('bmi') ?? 0.0;
    notifyListeners();
  }

  void updateBmi(double weight, double height, double bmi) async {
    _weight = weight;
    _height = height;
    _bmi = bmi;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('weight', _weight);
    prefs.setDouble('height', _height);
    prefs.setDouble('bmi', _bmi);
  }
}
