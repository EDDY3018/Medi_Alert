// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/auth/Login/view/login_page.dart';
import 'package:medi_alert/auth/Register/view/register_page.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:medi_alert/utils/navigator.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: GREY, width: 5)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Image.asset(
                  'assets/Splash.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Column(
            children: [
              Text(
                'Smart Medical Alert App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Text(
                  'We will help you stay healthy by providing timely medication reminders, emergency alerts, and instant access to your vital health records',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: GestureDetector(
                  onTap: () {
                    customNavigator(context, LoginPage());
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 30,
                      ),
                      Container(
                        height: 40,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
