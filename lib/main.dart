// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:medi_alert/Splash/splash.dart';
import 'package:provider/provider.dart';

import 'modules /BMI/models/bmiProvider.dart';
import 'modules /Vitals/model/appointment.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => BmiProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
