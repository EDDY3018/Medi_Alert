// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:medi_alert/utils/colors.dart';

import '../../../../utils/textStyles.dart'; // Alias the import

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _noteController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? _selectedDoctor;
  List<Map<String, String>> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() {
    _doctors = [
      {'name': 'Dr. John Doe', 'staffID': 'JD123'},
      {'name': 'Dr. Jane Smith', 'staffID': 'JS456'},
      {'name': 'Dr. Alice Brown', 'staffID': 'AB789'},
      {'name': 'Dr. Bob White', 'staffID': 'BW101'},
    ];

    setState(() {
      // You can uncomment and customize this code to store doctors in the database if needed.

      DatabaseReference doctorsRef =
          FirebaseDatabase.instance.ref().child('doctors');
      for (var doctor in _doctors) {
        doctorsRef.push().set(doctor);
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (picked.isBefore(DateTime.now())) {
        _showPastDateDialog(context);
      } else {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }

  void _showPastDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Date'),
          content: Text('Please select a date ahead of the current date.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _submitBooking() async {
    if (_selectedDoctor == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      String formattedTime = selectedTime!.format(context);

      DatabaseReference bookingRef = FirebaseDatabase.instance
          .ref()
          .child('appointments')
          .child(user.uid)
          .push();

      await bookingRef.set({
        'doctorName': _selectedDoctor,
        'date': formattedDate,
        'time': formattedTime,
        'note': _noteController.text,
      });

      // Notify user by email
      await FirebaseFunctions.instance
          .httpsCallable('sendEmailNotification')
          .call({
        'email': user.email,
        'doctorName': _selectedDoctor,
        'date': formattedDate,
        'time': formattedTime,
        'note': _noteController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 320,
              height: 40,
              decoration: BoxDecoration(color: GREY),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                isDense: true,
                value: _selectedDoctor,
                hint: Text('Select Doctor'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDoctor = newValue;
                  });
                },
                items: _doctors.map((doctor) {
                  return DropdownMenuItem<String>(
                    value: doctor['name'],
                    child: Text('${doctor['name']} (${doctor['staffID']})'),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "When should we expect you",
                  style: WHEN,
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      color: PRIMARY,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('d MMM yyyy').format(selectedDate),
                        style: DATE,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    width: 60,
                    height: 35,
                    decoration: BoxDecoration(
                      color: BLUE,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        selectedTime.format(context),
                        style: TIME,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Leave a note',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            Spacer(),
            GestureDetector(
              onTap: _submitBooking,
              child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: GREEN,
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: WHITE,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
