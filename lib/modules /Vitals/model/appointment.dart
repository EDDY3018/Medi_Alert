
// Appointment Provider class
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentProvider extends ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
    _saveToPreferences();
  }

  void _saveToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> appointmentsAsStrings =
        _appointments.map((appointment) => appointment.subject).toList();
    await prefs.setStringList('appointments', appointmentsAsStrings);
  }

  void loadFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? appointmentsAsStrings = prefs.getStringList('appointments');
    if (appointmentsAsStrings != null) {
      _appointments = appointmentsAsStrings.map((subject) {
        return Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(minutes: 30)),
          subject: subject,
          color: Colors.blue,
        );
      }).toList();
      notifyListeners();
    }
  }
}
