// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medi_alert/auth/Register/view/register_page.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:medi_alert/utils/textStyles.dart';

import '../../../utils/btNav.dart';
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

  @override
  void initState() {
    super.initState();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _checkUserLoggedIn();
  }

  @override
  void dispose() {
    _emailFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login Successful'),
        backgroundColor: Colors.green,
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password are required")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to home page if successful
      if (context.mounted) {
        customNavigator(
          context,
          BTNAV(pageIndex: 0), // Navigate to home or desired page
        );
      }
    } on FirebaseAuthException catch (e) {
      // Catch various Firebase errors and show messages
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found for that email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        default:
          errorMessage = e.message ?? "An error occurred during login.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkUserLoggedIn() async {
    User? user = _auth.currentUser;
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Yuo have an existing account"),
          backgroundColor: Colors.green,
        ),
      );
      customNavigator(
          context,
          BTNAV(
            pageIndex: 0,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  filterQuality: FilterQuality.low,
                  opacity: 0.04,
                  alignment: Alignment.center,
                  image: AssetImage('assets/bgImage.png'),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'An account for the Medi Alert mobile app ensures personalized health management, secure data storage, and seamless access to your medical history and alerts across multiple devices.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Email", style: PHONE),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: '',
                      controller: emailController,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Password", style: PHONE),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      labelText: '',
                      controller: passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              customNavigator(context, Forgotten());
                            },
                            child: Text("Forgot Password", style: PHONE),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GestureDetector(
                        onTap: _login,
                        child: Container(
                          width: w,
                          height: 40,
                          decoration: BoxDecoration(
                            color: GREEN,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('Next', style: CONTAINERTEXT),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          customNavigator(context, RegisterPage());
                        },
                        child: Text(
                          'Don\'t have an account? Register',
                          style: forgot,
                        ),
                      ),
                    ),
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
                  child: Column(
                    children: [
                      Text(
                        "Please Wait...",
                        style: GoogleFonts.roboto(
                          color: BLACK,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      CircularProgressIndicator(
                        color: GREEN,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
