// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medi_alert/modules%20/Home/view/home_page.dart';
import 'package:medi_alert/utils/btNav.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';
import '../../../utils/navigator.dart';
import '../../../utils/textStyles.dart';
import '../../Exercise/view/exercise_page.dart';
import '../models/bmiProvider.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bmiController = TextEditingController();
  bool _isNextEnabled = false;
  String _bmiCategory = '';

  void _calculateBMI() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double height = double.tryParse(_heightController.text) ?? 0;

    if (weight > 0 && height > 0) {
      final bmi = weight / (height * height);
      _bmiController.text = bmi.toStringAsFixed(2);

      if (bmi < 18.5) {
        _bmiCategory = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        _bmiCategory = 'Normal weight';
      } else if (bmi >= 25 && bmi < 29.9) {
        _bmiCategory = 'Overweight';
      } else {
        _bmiCategory = 'Obese';
      }

      // Update the provider with the new BMI data
      context.read<BmiProvider>().updateBmi(weight, height, bmi);
    } else {
      _bmiController.text = '';
      _bmiCategory = '';
    }

    setState(() {
      _isNextEnabled = weight > 0 && height > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              customNavigator(context, HomePage());
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
        body: SingleChildScrollView(
          child: Container(
            height: h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    opacity: 0.04,
                    alignment: Alignment.center,
                    image: AssetImage('assets/bgImage.png'))),
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Enter details to calculate ',
                                style: USER,
                              ),
                              TextSpan(text: 'BMI', style: TERMS),
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: WARN,
                        children: [
                          TextSpan(
                              text:
                                  'Body mass index (BMI) is a measure of body fat based on height and weight that applies to mean and women.',
                              style: WARN),
                        ],
                      )),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                          child: Text(
                        "How much do you weigh? (Kg)",
                        style: PHONE,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GREY)),
                      child: TextField(
                        controller: _weightController,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ),
                    SizedBox(width: 50),
                    Container(
                        child: Text(
                      "Kg",
                      style: TERMS,
                    )),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                          child: Text(
                        "What is your height? (m)",
                        style: PHONE,
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GREY)),
                      child: TextField(
                        controller: _heightController,
                        keyboardType: TextInputType.datetime,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ),
                    SizedBox(width: 50),
                    Container(
                        child: Text(
                      "ft",
                      style: TERMS,
                    )),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            style: CALWARN,
                            children: [
                              TextSpan(text: 'Calculate', style: CALWARN),
                              TextSpan(text: ' (BMI)', style: TERMS),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: GREY)),
                      child: TextField(
                        readOnly: true,
                        controller: _bmiController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: CALWARN,
                          children: [
                            TextSpan(text: 'Your BMI is', style: CALWARN),
                            TextSpan(text: '  $_bmiCategory', style: TERMS),
                          ],
                        )),
                  ),
                ]),
                SizedBox(height: h * 0.2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _isNextEnabled ? customNavigator(context, BTNAV()) : null;
                    },
                    child: Container(
                      width: w,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _isNextEnabled ? GREEN : GREY,
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
