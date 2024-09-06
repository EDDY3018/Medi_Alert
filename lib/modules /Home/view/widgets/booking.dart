// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, use_build_context_synchronously, deprecated_member_use

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:medi_alert/modules%20/Home/view/home_page.dart';
import 'package:medi_alert/utils/btNav.dart';

import 'package:medi_alert/utils/colors.dart';
import 'package:medi_alert/utils/navigator.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  List<Map<String, String>> _doctors = [];
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

  final now = DateTime.now();
  Future _submitBooking() async {
    if (_selectedDoctor == null ||
        selectedDate.isBefore(now) ||
        selectedTime == null ||
        _noteController.text.trim().isEmpty) {
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
      FirebaseFunctions.instance.httpsCallable('sendEmailNotification').call({
        'email': user.email,
        'doctorName': _selectedDoctor,
        'date': formattedDate,
        'time': formattedTime,
        'note': _noteController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );
      customNavigator(context, BTNAV(pageIndex: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        customNavigator(context, BTNAV(pageIndex: 0));

        return false;
      },
      child: Scaffold(
        backgroundColor: WHITE,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: WHITE,
          title: Text('Book Appointment'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              customNavigator(context, BTNAV(pageIndex: 0));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  width: 350,
                  height: 50,
                  child: CustomDropdown(
                    hintText: 'Select Doctor',
                    items: _doctors.map((doctor) {
                      return '${doctor['name']} (${doctor['staffID']})';
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDoctor = newValue;
                      });
                    },
                    decoration: CustomDropdownDecoration(
                        closedFillColor:
                            const Color.fromARGB(78, 215, 217, 224),
                        expandedBorder: Border.all(color: GREY),
                        hintStyle: TextStyle(color: PRIMARY)),
                  ),
                ),
              ),
              SizedBox(height: 30),
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
                        borderRadius: BorderRadius.circular(8),
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
                        color: PRIMARY,
                        borderRadius: BorderRadius.circular(8),
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
              SizedBox(height: 30),
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Leave a note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
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
      ),
    );
  }
}
