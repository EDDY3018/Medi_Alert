// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
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
    Navigator.of(context)
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
      child: ElevatedButton(
        onPressed: _submitFeedback,
        child: Text('Submit'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
        ),
      ),
    );
  }

  Widget _buildShareAppButton() {
    return ElevatedButton.icon(
      onPressed: _shareApp,
      icon: Icon(Icons.share),
      label: Text('Share App'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: _logout,
      icon: Icon(Icons.exit_to_app),
      label: Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
      ),
    );
  }
}
