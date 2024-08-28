// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/BMI/view/bmi_page.dart';
import 'package:medi_alert/modules%20/Home/view/home_page.dart';
import 'package:medi_alert/utils/btNav.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:medi_alert/utils/navigator.dart';

import '../../../utils/textStyles.dart';
import 'widgets/selectWidget.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  int _selectedOption = -1;
  bool _isNextEnabled = false;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: WHITE,
        body: SingleChildScrollView(
          child: Container(
            height: h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.04,
                    alignment: Alignment.center,
                    image: AssetImage('assets/bgImage.png'))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'How often do you ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Exercise?',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Exercise is any physical activity that enhances or maintains fitness, health, and overall well-being. '
                    'Regular exercise improves cardiovascular health, strengthens muscles, aids weight management, and boosts mental health.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                buildOption(
                    context, 0, 'Not Regular', 'Few or None', _selectedOption,
                    (index) {
                  setState(() {
                    _selectedOption = index;
                  });
                }),
                SizedBox(height: 16.0),
                buildOption(context, 1, 'Sometimes', '1-2 times a week',
                    _selectedOption, (index) {
                  setState(() {
                    _selectedOption = index;
                  });
                }),
                SizedBox(height: 16.0),
                buildOption(context, 2, 'Regular', 'About 5 times a week',
                    _selectedOption, (index) {
                  setState(() {
                    _selectedOption = index;
                  });
                }),
                SizedBox(height: h * 0.2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: _selectedOption == -1
                        ? null
                        : () {
                            customNavigator(context, BmiPage());
                          },
                    child: Container(
                      width: w,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _selectedOption == -1 ? GREY : GREEN,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          'Next',
                          style: CONTAINERTEXT,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
