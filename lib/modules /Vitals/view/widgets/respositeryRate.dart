// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:medi_alert/modules%20/Vitals/view/vitals_page.dart';
import 'package:medi_alert/utils/btNav.dart';
import 'package:medi_alert/utils/navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'RRhistory.dart';
import 'circular.dart';

class RespiratoryRatePage extends StatefulWidget {
  @override
  _RespiratoryRatePageState createState() => _RespiratoryRatePageState();
}

class _RespiratoryRatePageState extends State<RespiratoryRatePage> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  double _percent = 0.0;
  int _respiratoryRateValue = 0;
  bool _isDetecting = false; // Track if detection is in progress

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController?.initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _startDetection() {
    if (_isDetecting) return; // Prevent starting if already detecting

    setState(() {
      _isDetecting = true;
      _percent = 0.0; // Reset percentage to 0% when starting detection
    });

    _updatePercentage();
  }

  void _stopDetection() {
    setState(() {
      _isDetecting = false;
      _percent = 0.0; // Reset percentage to 0% when stopping detection
    });
  }

  void _updatePercentage() {
    if (_percent < 1.0 && _isDetecting) {
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          _percent += 0.01; // Update percentage
        });
        _updatePercentage(); // Continue updating percentage
      });
    } else if (_percent >= 1.0) {
      _percent = 1.0;
      _measureRespiratoryRate();
    }
  }

  // Simple logic to simulate respiratory rate measurement
  void _measureRespiratoryRate() {
    // Simulate respiratory rate detection with random values
    final random = Random();
    setState(() {
      _respiratoryRateValue =
          random.nextInt(20) + 12; // Simulated range: 12-32 breaths per minute
    });

    if (_respiratoryRateValue > 0) {
      _saveRespiratoryRateToHistory(_respiratoryRateValue);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RespiratoryRateHistoryPage(),
      ));
    }
  }

  Future<void> _saveRespiratoryRateToHistory(int rate) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history =
        prefs.getStringList('respiratory_rate_history') ?? [];

    // Format the time as 'hh:mm a'
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    // Add the respiratory rate with the formatted time to the history list
    history.add('Respiratory Rate: $rate breaths per minute - $formattedTime');
    await prefs.setStringList('respiratory_rate_history', history);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return WillPopScope(
      onWillPop: () async {
        customNavigator(
            context,
            BTNAV(
              pageIndex: 1,
            ));

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Check Respiratory Rate'),
          leading: GestureDetector(
              onTap: () {
                customNavigator(
                    context,
                    BTNAV(
                      pageIndex: 1,
                    ));
              },
              child: Icon(Icons.arrow_back, color: Colors.black, size: 30)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RespiratoryRateHistoryPage(),
                  ));
                },
                child: Icon(Icons.history, color: Colors.black, size: 30),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Camera preview
            Positioned.fill(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_cameraController!);
                  } else {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tap on Start Detection to show Camera. ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.photo_camera_front)
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            // Overlay with text and circular indicator
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Detecting face and chest.\nLook at the camera and remain still.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomCircularIndicator(
                          percent: _percent,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${(_percent * 100).toStringAsFixed(0)}%',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Start/Stop Detection button
            Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: GestureDetector(
                    onTap: _isDetecting ? _stopDetection : _startDetection,
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _isDetecting ? Colors.red : Colors.green),
                      child: Center(
                          child: Text(
                        _isDetecting ? 'Stop Detecting' : 'Start Detection',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                    )))
          ],
        ),
      ),
    );
  }
}

class CustomCircularIndicator extends StatelessWidget {
  final double percent;

  CustomCircularIndicator({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: CircularIndicatorPainter(percent: percent),
      ),
    );
  }
}
