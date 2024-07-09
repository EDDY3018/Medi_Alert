// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
import 'package:medi_alert/utils/navigator.dart';

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
              SizedBox(height: 100),
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
                  onTap: () {
                    customNavigator(context, LoginPage());
                  },
                  child: Container(
                    width: w,
                    height: 40,
                    decoration: BoxDecoration(
                        color: GREEN, borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        'Next',
                        style: CONTAINERTEXT,
                      ),
                    ),
                  ),
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
