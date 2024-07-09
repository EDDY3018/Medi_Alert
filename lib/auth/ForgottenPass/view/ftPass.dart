// ignore: file_names
// ignore_for_file: library_private_types_in_public_api, use_super_parameters, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, missing_required_param, sized_box_for_whitespace, deprecated_member_use, file_names, duplicate_ignore, unused_local_variable

import 'package:flutter/material.dart';

import 'package:medi_alert/auth/Login/view/login_page.dart';
import '../../../utils/colors.dart';
import '../../../utils/navigator.dart';
import '../../../utils/textStyles.dart';
import '../../../utils/textfield.dart';

class Forgotten extends StatefulWidget {
  const Forgotten({Key? key}) : super(key: key);

  @override
  _ForgottenState createState() => _ForgottenState();
}

class _ForgottenState extends State<Forgotten> {
  final TextEditingController _phoneController = TextEditingController();
  void loginUser() {}
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
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage('assets/bgImage.png'))),
              child: SingleChildScrollView(
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
                                    "Lets help you regain access to your account",
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
                          CustomTextField(
                            labelText: '',
                            controller: _phoneController,
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                customNavigator(context, LoginPage());
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
        onWillPop: () async {
          // Navigate back to the previous page
          customNavigator(context, LoginPage());
          return false;
        });
  }
}
