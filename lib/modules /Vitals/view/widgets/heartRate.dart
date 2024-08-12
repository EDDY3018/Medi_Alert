// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:percentages_with_animation/percentages_with_animation.dart';
import 'package:camera/camera.dart';

class HeartRatePage extends StatefulWidget {
  @override
  _HeartRatePageState createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  final List<SensorValue> _data = [];
  int _bpmValue = 0;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _cameraController = CameraController(camera, ResolutionPreset.high);

    await _cameraController?.initialize();
    _cameraController?.setFlashMode(FlashMode.torch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Heart Rate'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: _cameraController != null &&
                      _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : Center(child: CircularProgressIndicator()),
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
                          'Place your fingertip over the rear-facing\ncamera lens',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
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
                  if (_bpmValue >= 100) showHeartRateDetails(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showHeartRateDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Heart Rate Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your heart rate is $_bpmValue BPM',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _data.clear();
                  _bpmValue = 0;
                });
              },
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}


 // showDialog(
                    //   context: context,
                    //   builder: (context) => AlertDialog(
                    //     title: Text('Heart Rate Result'),
                    //     content: Text('Your heart rate is $_bpmValue BPM'),
                    //     actions: [
                    //       TextButton(
                    //         onPressed: () {
                    //           Navigator.of(context).pop();
                    //           setState(() {
                    //             _data.clear();
                    //             _bpmValue = 0;
                    //           });
                    //         },
                    //         child: Text('Okay'),
                    //       ),
                    //     ],
                    //   ),
                    // );
 
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