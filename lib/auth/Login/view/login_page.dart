// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medi_alert/modules%20/BMI/view/bmi_page.dart';
import 'package:medi_alert/modules%20/Exercise/view/exercise_page.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:medi_alert/utils/textStyles.dart';

import '../../../utils/navigator.dart';
import '../../../utils/textfield.dart';
import '../../ForgottenPass/view/ftPass.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode? _emailFocusNode, _passwordFocusNode;
  bool _isLoading = false;
  bool _seePassword = false;
  @override
  initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  dispose() {
    super.dispose();
    _emailFocusNode!.dispose();
    _passwordFocusNode!.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Stack(
      children:[ Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    filterQuality: FilterQuality.low,
                    opacity: 0.04,
                    alignment: Alignment.center,
                    image: AssetImage('assets/bgImage.png'))),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'An account for the Medi Alert mobile app ensures personalised health management, secure data storage, and seamless access to your medical history and alerts across multiple devices.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                            child: Text(
                          "Full Name / ID",
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 20.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            customNavigator(context, Forgotten());
                          },
                          child: Container(
                              child: Text(
                            "Forgot Password",
                            style: PHONE,
                          )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        customNavigator(context, ExercisePage());
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      if (_isLoading)
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: WHITE,
                  ),
                  child: Column(children: [
                   
                   
                    Text(
                      "Please Wait ..",
                      style: GoogleFonts.roboto(
                        color: BLACK,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ]),
                )),
              ),
            ),
      ],
      
    );
  }
}
