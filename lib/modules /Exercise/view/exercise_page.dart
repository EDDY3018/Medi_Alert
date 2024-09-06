// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Exercise/model/exModel.dart';
import 'package:provider/provider.dart';
import '../../BMI/view/bmi_page.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  @override
  void initState() {
    super.initState();
    // Load saved data from SharedPreferences when the page is initialized
    Provider.of<ExerciseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
                context,
                0,
                'Not Regular',
                'Few or None',
                exerciseProvider.selectedOption,
                (index) {
                  exerciseProvider.setSelectedOption(index);
                },
              ),
              SizedBox(height: 16.0),
              buildOption(
                context,
                1,
                'Sometimes',
                '1-2 times a week',
                exerciseProvider.selectedOption,
                (index) {
                  exerciseProvider.setSelectedOption(index);
                },
              ),
              SizedBox(height: 16.0),
              buildOption(
                context,
                2,
                'Regular',
                'About 5 times a week',
                exerciseProvider.selectedOption,
                (index) {
                  exerciseProvider.setSelectedOption(index);
                },
              ),
              SizedBox(height: h * 0.2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: exerciseProvider.selectedOption == -1
                      ? null
                      : () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BmiPage()));
                        },
                  child: Container(
                    width: w,
                    height: 40,
                    decoration: BoxDecoration(
                        color: exerciseProvider.selectedOption == -1
                            ? Colors.grey
                            : Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOption(BuildContext context, int index, String title,
      String description, int selectedOption, ValueChanged<int> onSelect) {
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        decoration: BoxDecoration(
          color: selectedOption == index ? Colors.green : Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(description),
          ],
        ),
      ),
    );
  }
}
