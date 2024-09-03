// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
import 'package:medi_alert/utils/navigator.dart';
import '../../../utils/btNav.dart';
import '../../../utils/colors.dart';
import '../../../utils/textStyles.dart';
import '../../../utils/textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? gender;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
// Inside _RegisterPageState class
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.reference(); // Reference to the database
 void _register() async {
  if (nameController.text.isEmpty ||
      studentIdController.text.isEmpty ||
      emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty ||
      gender == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("All fields are required")),
    );
    return;
  }

  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Passwords do not match")),
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );

    // Save user data to Firebase Realtime Database
    await _dbRef.child('users/${userCredential.user?.uid}').set({
      'fullName': nameController.text,
      'studentID': studentIdController.text,
      'email': emailController.text,
      'gender': gender,
    });

    // Await the navigation to the login page
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? "Registration failed")),
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  void _checkUserLoggedIn() async {
    User? user = _auth.currentUser;
    if (user != null) {
      customNavigator(
          context,
          BTNAV(
            pageIndex: 0,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  filterQuality: FilterQuality.low,
                  opacity: 0.04,
                  alignment: Alignment.center,
                  image: AssetImage('assets/bgImage.png'))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Register',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      style: WARN,
                      children: [
                        TextSpan(
                          text: 'An account for the ',
                        ),
                        TextSpan(text: 'Medi Alert ', style: TERMS),
                        TextSpan(
                            text:
                                'mobile app ensures personalised health management, secure data storage, and seamless access to your medical history and alerts across multiple devices.',
                            style: WARN),
                      ],
                    )),
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        child: Text(
                      "Full Name",
                      style: PHONE,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: '',
                controller: nameController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        child: Text(
                      "Student ID",
                      style: PHONE,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: '',
                controller: studentIdController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        child: Text(
                      "Email",
                      style: PHONE,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: '',
                controller: emailController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        child: Text(
                      "Password",
                      style: PHONE,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: '',
                controller: passwordController,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                        child: Text(
                      "Confirm",
                      style: PHONE,
                    )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextField(
                labelText: '',
                controller: confirmPasswordController,
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          Text('Male'),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Female',
                            groupValue: gender,
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: _register,
                  child: Container(
                    width: w,
                    height: 40,
                    decoration: BoxDecoration(
                        color: GREEN, borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: isLoading
                          ? LoadingIndicator(
                              indicatorType: Indicator.ballPulse,
                              colors: [Colors.white],
                            )
                          : Text(
                              'Next',
                              style: CONTAINERTEXT,
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  customNavigator(context, LoginPage());
                },
                child: Text(
                  'Already have an account? \t\t Login',
                  style: forgot,
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
