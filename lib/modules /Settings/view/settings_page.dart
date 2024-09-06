// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:share/share.dart';

import '../../../utils/btNav.dart';
import '../../../utils/navigator.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _feedbackController = TextEditingController();
  String fullName = 'Full Name';
  String studentID = 'Student ID';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();
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

  void _submitFeedback() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference feedbackRef =
          FirebaseDatabase.instance.ref().child('feedback').child(user.uid);

      feedbackRef.push().set({
        'feedback': _feedbackController.text,
        'timestamp': DateTime.now().toIso8601String(),
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully')),
        );
        _feedbackController.clear();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Write something to submit feedback'),
            backgroundColor: RED,
          ),
        );
      });
    }
  }

  void _shareApp() {
    Share.share('Check out this app! https://example.com/app', );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: WHITE,
        title: Text('Settings'),
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
            Text('Profile',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildTextField(label: fullName),
            SizedBox(height: 10),
            _buildTextField(label: studentID),
            SizedBox(height: 20),
            Text('Feedback',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildFeedbackField(),
            SizedBox(height: 20),
            _buildSubmitButton(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareAppButton(),
                _buildLogoutButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label}) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: WHITE,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                color: GREY,
                offset: Offset.zero)
          ]),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildFeedbackField() {
    return Container(
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: WHITE,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                blurRadius: 2,
                spreadRadius: 2,
                color: GREY,
                offset: Offset.zero)
          ]),
      child: TextField(
        controller: _feedbackController,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Write something',
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: _submitFeedback,
          child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: GREEN),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Submit",
                  style: TextStyle(color: WHITE, fontWeight: FontWeight.w700),
                ),
              ])),
        ));
  }

  Widget _buildShareAppButton() {
    return GestureDetector(
      onTap: _shareApp,
      child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: GREEN),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(Icons.share),
            Text(
              "Share App",
              style: TextStyle(color: WHITE, fontWeight: FontWeight.w700),
            ),
          ])),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _logout,
      child: Container(
          width: 120,
          height: 40,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(5), color: RED),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Icon(Icons.logout),
            Text(
              "Logout",
              style: TextStyle(color: WHITE, fontWeight: FontWeight.w700),
            ),
          ])),
    );
  }
}
