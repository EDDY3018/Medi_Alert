// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../../utils/greetings.dart';
import 'widgets/vitalWidgets.dart';

class VitalsPage extends StatefulWidget {
  const VitalsPage({super.key});

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              child: Image.asset(
                'assets/bgImage.png',
                scale: 10,
              ),
            ),
            SizedBox(width: 20),
            Container(
              child: Row(
                children: [
                  Text('Vitals', style: TextStyle(color: Colors.black)),
                ],
              ),
            )
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Discover', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            VitalsCard(
              title: 'Check Respiratory Rate',
              description:
                  'Monitoring respiratory rate helps track the efficiency of your breathing and can indicate changes in health status, particularly for conditions affecting the lungs or heart.',
              image: 'assets/respiratory_rate.png',
            ),
            SizedBox(height: 10),
            VitalsCard(
              title: 'Oxygen Saturation',
              description:
                  'Regularly check your blood oxygen levels using a pulse oximeter to ensure your body is receiving enough oxygen.',
              image: 'assets/oxygen_saturation.png',
            ),
            SizedBox(height: 10),
            VitalsCard(
              title: 'Heart Rate',
              description:
                  'Monitoring heart rate helps track cardiovascular health, fitness levels, and can indicate the presence of medical conditions.',
              image: 'assets/heart_rate.png',
            ),
          ],
        ),
      ),
    );
  }
}
