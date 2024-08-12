// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:heart_bpm/heart_bpm.dart';
// import 'package:percentages_with_animation/percentages_with_animation.dart';
// import 'package:camera/camera.dart';

// class HeartRatePage extends StatefulWidget {
//   @override
//   _HeartRatePageState createState() => _HeartRatePageState();
// }

// class _HeartRatePageState extends State<HeartRatePage> {
//   final List<SensorValue> _data = [];
//   int _bpmValue = 0;
//   CameraController? _cameraController;

//   @override
//   void initState() {
//     super.initState();
//     initializeCamera();
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   Future<void> initializeCamera() async {
//     final cameras = await availableCameras();
//     final camera = cameras.first;
//     _cameraController = CameraController(camera, ResolutionPreset.high);

//     await _cameraController?.initialize();
//     _cameraController?.setFlashMode(FlashMode.torch);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Check Heart Rate'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               child: _cameraController != null &&
//                       _cameraController!.value.isInitialized
//                   ? CameraPreview(_cameraController!)
//                   : Center(child: CircularProgressIndicator()),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               child: Column(
//                 children: [
//                   SizedBox(height: 30),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Row(
//                       children: [
//                         Text(
//                           'Place your fingertip over the rear-facing\ncamera lens',
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Container(
//                     height: 90,
//                     width: 100,
//                     child: GradientCirclePercentage(
//                       currentPercentage:
//                           _bpmValue > 100 ? 100 : _bpmValue.toDouble(),
//                       maxPercentage: 100,
//                       size: 200,
//                       duration: 2000,
//                       percentageStrokeWidth: 10,
//                       bottomColor: Colors.green,
//                       backgroundStrokeWidth: 2,
//                     ),
//                   ),
//                   if (_bpmValue >= 100) showHeartRateDetails(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   showHeartRateDetails() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Heart Rate Details',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Your heart rate is $_bpmValue BPM',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 setState(() {
//                   _data.clear();
//                   _bpmValue = 0;
//                 });
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:torch_controller/torch_controller.dart';
import 'chart.dart';
import 'history.dart';
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
