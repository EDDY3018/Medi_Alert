// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:share/share.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _feedbackController = TextEditingController();
  String fullName = 'Full Name';
  String studentID = 'Student ID';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(user.uid);

      try {
        DatabaseEvent event = await userRef.once();
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map<String, dynamic>;
          setState(() {
            fullName = data['fullName'] ?? 'Full Name';
            studentID = data['studentID'] ?? 'Student ID';
          });
        } else {
          // Handle case when data doesn't exist
          print('No data available');
        }
      } catch (e) {
        // Handle any errors that might occur
        print('Failed to fetch user data: $e');
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
          SnackBar(content: Text('Failed to submit feedback: $error')),
        );
      });
    }
  }

  void _shareApp() {
    Share.share('Check out this app! https://example.com/app');
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildTextField(label: fullName),
            SizedBox(height: 10),
            _buildTextField(label: studentID),
            SizedBox(height: 20),
            Text('Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
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
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
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
            Icon(Icons.logout),
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
