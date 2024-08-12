// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:percentages_with_animation/percentages_with_animation.dart';

class RespiratoryRatePage extends StatefulWidget {
  @override
  _RespiratoryRatePageState createState() => _RespiratoryRatePageState();
}

class _RespiratoryRatePageState extends State<RespiratoryRatePage> {
  int _respiratoryRateValue = 0;

  void measureRespiratoryRate() {
    // Implement your method to measure respiratory rate
    // For example, using a specific sensor or manual counting
    // Update _respiratoryRateValue accordingly
    setState(() {
      _respiratoryRateValue = 18; // Example value
    });

    if (_respiratoryRateValue > 0) {
      showRespiratoryRateDetails();
    }
  }

  void showRespiratoryRateDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Respiratory Rate Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your respiratory rate is $_respiratoryRateValue breaths per minute',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _respiratoryRateValue = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Respiratory Rate'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: ElevatedButton(
                onPressed: measureRespiratoryRate,
                child: Text('Start Measuring'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Text(
                            'Follow the instructions to measure your\nrespiratory rate'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 90,
                    width: 100,
                    child: GradientCirclePercentage(
                      currentPercentage: _respiratoryRateValue.toDouble(),
                      maxPercentage:
                          40, // Example max value for respiratory rate
                      size: 200,
                      duration: 2000,
                      percentageStrokeWidth: 10,
                      bottomColor: Colors.red,
                      backgroundStrokeWidth: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
