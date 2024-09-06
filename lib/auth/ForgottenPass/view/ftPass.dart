// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, use_super_parameters, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, missing_required_param, sized_box_for_whitespace, deprecated_member_use, file_names, duplicate_ignore, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:medi_alert/auth/Login/view/login_page.dart';
import '../../../utils/colors.dart';
import '../../../utils/navigator.dart';
import '../../../utils/textStyles.dart';
import '../../../utils/textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Forgotten extends StatefulWidget {
  const Forgotten({Key? key}) : super(key: key);

  @override
  _ForgottenState createState() => _ForgottenState();
}

class _ForgottenState extends State<Forgotten> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  @override
  void initState() {
    super.initState();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return WillPopScope(
      child: Scaffold(
        backgroundColor: WHITE,
        appBar: AppBar(
          backgroundColor: WHITE,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              customNavigator(context, LoginPage());
            },
            child: Container(
              decoration: BoxDecoration(color: WHITE, boxShadow: [
                BoxShadow(color: WHITE, spreadRadius: 0, blurRadius: 10)
              ]),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.04,
                    alignment: Alignment.center,
                    image: AssetImage('assets/bgImage.png'))),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Forgotten Password",
                                    style: SIGNUP,
                                  )),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text(
                                    "Let's help you regain access to your account",
                                    style: hint,
                                  )),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Container(
                                    child: Text(
                                  "Phone number or Email",
                                  style: PHONE,
                                )),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(20),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _auth
                                      .sendPasswordResetEmail(
                                          email: emailController.text.trim())
                                      .then((value) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "We have sent you an email to recover your password. Please check it.",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white);
                                  }).catchError((error) {
                                    debugPrint(error.toString());
                                    Fluttertoast.showToast(
                                        msg: 'Invalid EMAIL',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white);
                                  });
                                  emailController.clear();
                                }
                              },
                              child: Container(
                                height: 40,
                                width: w,
                                decoration: BoxDecoration(
                                    color: GREEN,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Text(
                                    "Enter",
                                    style: CONTAINERTEXT,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        customNavigator(context, LoginPage());
        return false;
      },
    );
  }
}
