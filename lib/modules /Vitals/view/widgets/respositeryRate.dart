// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

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
  Timer? _detectionTimer;
  List<double> _breathData = [];
  final int _breathCountInterval = 10; // Interval for breath count

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

    // Start capturing frames
    _startFrameCapture();
  }

  void _startFrameCapture() {
    _cameraController?.startImageStream((image) {
      // Analyze image here
      _analyzeFrame(image);
    });
  }

  void _analyzeFrame(CameraImage image) {
    // Implement your image analysis logic here
    // For example, you might use a library to detect chest movement
    // Here we simulate breath detection
    double simulatedBreath = Random().nextDouble(); // Replace with actual analysis
    setState(() {
      _breathData.add(simulatedBreath);
      if (_breathData.length > _breathCountInterval) {
        _breathData.removeAt(0);
      }
      _calculateRespiratoryRate();
    });
  }

  void _calculateRespiratoryRate() {
    // Simple algorithm to estimate respiratory rate
    // Count the number of breaths detected in the interval
    int breathCount = _breathData.where((value) => value > 0.5).length;
    setState(() {
      _respiratoryRateValue = (breathCount / _breathCountInterval * 60).round();
    });
  }

  void _startDetection() {
    setState(() {
      _percent = 0.0;
    });
    Future.delayed(Duration(milliseconds: 50), () {
      if (_percent < 1.0) {
        setState(() {
          _percent += 0.01; // Slower increment
        });
        _startDetection();
      } else {
        _percent = 1.0;
        _measureRespiratoryRate();
      }
    });
  }

  void _measureRespiratoryRate() {
    // Ensure the detection timer is stopped
    _detectionTimer?.cancel();
    
    setState(() {
      _respiratoryRateValue = 18; // Placeholder value, replace with actual rate
    });

    if (_respiratoryRateValue > 0) {
      _saveRespiratoryRateToHistory(_respiratoryRateValue);
      _showRespiratoryRateDetails();
    }
  }

  void _showRespiratoryRateDetails() {
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
                  _percent = 0.0;
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

  Future<void> _saveRespiratoryRateToHistory(int rate) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history =
        prefs.getStringList('respiratory_rate_history') ?? [];

    history
        .add('Respiratory Rate: $rate breaths per minute - ${DateTime.now()}');
    await prefs.setStringList('respiratory_rate_history', history);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _detectionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Respiratory Rate'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController!);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
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
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: _startDetection,
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: Colors.green),
                child: Center(
                    child: Text(
                  'Start Detection',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
