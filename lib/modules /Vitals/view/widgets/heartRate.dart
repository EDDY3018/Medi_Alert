// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/vitals_page.dart';
import 'package:medi_alert/utils/navigator.dart';
import 'package:torch_controller/torch_controller.dart';
import 'chart.dart';
import 'BPMhistory.dart';
import 'sensor.dart';

class HeartRatePage extends StatefulWidget {
  const HeartRatePage({super.key});

  @override
  State<HeartRatePage> createState() => _HeartRatePageState();
}

class _HeartRatePageState extends State<HeartRatePage> {
  bool _toggled = false;
  bool _isFinished = false;
  int? _score = 0;
  CameraController? _controller;
  TorchController _torchController = TorchController();

  int _timeToStartCounter = 20; // Countdown timer extended to 20 seconds
  final _chartKey = GlobalKey();
  final List<SensorValue> _data = <SensorValue>[]; // Array to store the values
  bool _isMeasuring = false;

  void _toggle() async {
    try {
      final cameras = await availableCameras();
      _controller = CameraController(cameras.first, ResolutionPreset.low);
      await _controller!.initialize();

      // Turn on the flashlight
      _torchController.toggle(intensity: 1);

      setState(() {
        _toggled = true;
      });

      // Start the countdown timer
      _startCountdown();

      // Monitor light intensity
      _startMonitoringLightIntensity();
    } catch (e) {
      setState(() {
        _toggled = false;
      });
    }
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timeToStartCounter > 0) {
          _timeToStartCounter--;
        } else {
          timer.cancel();
          _isMeasuring = true; // Start measuring
          _startCollectingData();
        }
      });
    });
  }

  void _startMonitoringLightIntensity() {
    _controller!.startImageStream((image) {
      if (!_toggled || _isMeasuring) return;

      double avgBrightness = 0.0;
      for (var plane in image.planes) {
        for (var pixel in plane.bytes) {
          avgBrightness += pixel;
        }
      }
      avgBrightness /= image.planes[0].bytes.length;

      if (avgBrightness < 50.0 && !_isMeasuring) {
        _isMeasuring = true;
        _startCollectingData();
      }
    });
  }

  void _startCollectingData() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_toggled) {
        timer.cancel();
        return;
      }

      setState(() {
        _score = (_score ?? 0) + 1; // Simulate BPM calculation
        _data.add(SensorValue(DateTime.now(), _score!.toDouble()));
      });

      if (_timeToStartCounter == 0) {
        _untoggle();
        _promptUserToRemoveFinger();
      }
    });
  }

  void _promptUserToRemoveFinger() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Measurement Complete"),
        content: const Text("Please remove your finger from the camera."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveAndNavigateToHistory();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  List<BPMRecord> _bpmHistory = [];

  void _saveAndNavigateToHistory() {
    if (_score != null) {
      _bpmHistory.add(BPMRecord(timestamp: DateTime.now(), bpm: _score!));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryPage(history: _bpmHistory),
        ),
      );
    }
  }

  void _untoggle() {
    setState(() {
      _toggled = false;
      _timeToStartCounter = 20; // Reset to 20 seconds
      _isFinished = true;
      _isMeasuring = false;
    });

    _torchController.toggle(intensity: 0);
    _controller?.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _controller != null && _toggled
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                )
              : SizedBox(
                  height: size.height * .3,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/heartBIT.png',
                    height: size.height * .3,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                customNavigator(context, VitalsPage());
                              },
                              icon: Icon(Icons.arrow_back)),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Heart Beat Rate',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                _toggled
                                    ? "Cover the camera and the flash with your finger"
                                    : "Camera feed will be displayed here\nCover the camera and the flash with your finger",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                        minHeight: size.height * .25,
                        minWidth: size.height * .25),
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_toggled) {
                          _untoggle();
                        } else {
                          _toggle();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        elevation: 6,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _isFinished
                                    ? (!_toggled
                                        ? "${_score!} BPM"
                                        : 'Measuring...')
                                    : 'Tap here to start',
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Raleway'),
                              ),
                              _toggled && _timeToStartCounter > 0
                                  ? Text(
                                      '${_timeToStartCounter}s left.',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Raleway'),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 20,
                              ),
                              const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 64,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromRGBO(255, 0, 0, .2)),
                      child: RepaintBoundary(
                        key: _chartKey,
                        child: ChartComp(allData: _data),
                      ),
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
