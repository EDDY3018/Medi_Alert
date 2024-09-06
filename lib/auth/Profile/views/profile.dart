// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medi_alert/modules%20/Exercise/model/exModel.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../modules /BMI/models/bmiProvider.dart';
import '../../../modules /Home/view/widgets/ppData.dart';
import '../../../utils/btNav.dart';
import '../../../utils/navigator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  String fullName = '';
  String studentID = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference userRef = _dbRef.child('users/${user.uid}');
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        setState(() {
          fullName = snapshot.child('fullName').value as String;
          studentID = snapshot.child('studentID').value as String;
        });
      }
    }
  }

  // Helper function to convert selected option to a string
  String getExerciseLabel(int selectedOption) {
    switch (selectedOption) {
      case 0:
        return 'Not Regular';
      case 1:
        return 'Sometimes';
      case 2:
        return 'Regular';
      default:
        return 'No option selected';
    }
  }

  // Helper function to get initials from full name
  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    String initials = '';
    if (nameParts.isNotEmpty) {
      initials = nameParts[0][0]; // First letter of the first name
      if (nameParts.length > 1) {
        initials += nameParts[1][0]; // First letter of the last name
      }
    }
    return initials.toUpperCase();
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
          title: Text('Profile'),
          backgroundColor: WHITE,
          leading: IconButton(
            onPressed: () {
              customNavigator(context, BTNAV(pageIndex: 0));
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: SECONDARY,
                child: Text(
                  getInitials(fullName),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: WHITE,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: TextEditingController(text: fullName),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: TextEditingController(text: studentID),
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: TextEditingController(
                    text: getExerciseLabel(
                        context.watch<ExerciseProvider>().selectedOption)),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'How often do you Exercise?',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PersonalDataCard(
                    title: 'Height',
                    data:
                        context.watch<BmiProvider>().height.toStringAsFixed(2),
                  ),
                  SizedBox(width: 10),
                  PersonalDataCard(
                    title: 'Weight',
                    data:
                        context.watch<BmiProvider>().weight.toStringAsFixed(2),
                  ),
                  SizedBox(width: 10),
                  PersonalDataCard(
                    title: 'BMI',
                    data: context.watch<BmiProvider>().bmi.toStringAsFixed(2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
