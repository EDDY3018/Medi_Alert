// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/Vitals/view/widgets/oxygen.dart';
import 'package:medi_alert/utils/navigator.dart';

import '../../../utils/colors.dart';

import '../../../utils/drawer.dart';
import '../../Home/view/widgets/bottomSheet.dart';
import 'widgets/heartRate.dart';
import 'widgets/respositeryRate.dart';
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
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: WHITE,
        elevation: 0,
        child: Image.asset(
          'assets/emegency.png',
          color: GREEN,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return BottomSheetContent();
            },
          );
        },
      ),
      appBar: AppBar(
        title: Container(
          child: Text('Vitals', style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            width: 50,
            height: 50,
            child: Image.asset(
              'assets/bgImage.png',
              scale: 10,
            ),
          ),
        ],
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
            GestureDetector(
              onTap: () {
                customNavigator(context, RespiratoryRatePage());
              },
              child: VitalsCard(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RespiratoryRatePage()),
                  );
                },
                title: 'Check Respiratory Rate',
                description:
                    'Monitoring respiratory rate helps track the efficiency of your breathing and can indicate changes in health status, particularly for conditions affecting the lungs or heart.',
                image: 'assets/heartRate.png',
              ),
            ),
            SizedBox(height: 10),
            VitalsCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OxygenSaturationPage()),
                );
              },
              title: 'Oxygen Saturation',
              description:
                  'Regularly check your blood oxygen levels using a pulse oximeter to ensure your body is receiving enough oxygen.',
              image: 'assets/oxy.png',
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HeartRatePage()));
              },
              child: VitalsCard(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HeartRatePage()));
                },
                title: 'Heart Rate',
                description:
                    'Monitoring heart rate helps track cardiovascular health, fitness levels, and can indicate the presence of medical conditions.',
                image: 'assets/rate.png',
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
