// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:percentages_with_animation/percentages_with_animation.dart';

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  List<SensorValue> _data = [];
  int _bpmValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Heart Rate'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Camera view takes all the space of the Expanded flex 3
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: HeartBPMDialog(
                context: context,
                onRawData: (value) {
                  setState(() {
                    _data.add(value);
                  });
                },
                onBPM: (value) {
                  setState(() {
                    _bpmValue = value;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Heart Rate Result'),
                        content: Text('Your heart rate is $_bpmValue BPM'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _data.clear();
                                _bpmValue = 0;
                              });
                            },
                            child: Text('Okay'),
                          ),
                        ],
                      ),
                    );
                  });
                },
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
                            'Place your fingertip over the rear-facing camera lens'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Parse the _bpmValue to the currentPercentage with a max value of 100
                  Container(
                    height: 90,
                    width: 100,
                    child: GradientCirclePercentage(
                      currentPercentage:
                          _bpmValue > 100 ? 100 : _bpmValue.toDouble(),
                      maxPercentage: 100,
                      size: 200,
                      duration: 2000,
                      percentageStrokeWidth: 10,
                      bottomColor: Colors.green,
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

 
  // ElevatedButton(
          //   onPressed: () {
          //     // Start heart rate monitoring
          //     showDialog(
          //       context: context,
          //       builder: (context) => HeartBPMDialog(
          //         context: context,
          //         onRawData: (value) {
          //           setState(() {
          //             _data.add(value);
          //           });
          //         },
          //         onBPM: (value) {
          //           setState(() {
          //             _bpmValue = value;
          //           });
          //         },
          //       ),
          //     );
          //   },
          //   child: Text('Start Monitoring'),
          // ),