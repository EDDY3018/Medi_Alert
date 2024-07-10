// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medi_alert/utils/colors.dart';

import '../../../utils/greetings.dart';
import '../../../utils/textStyles.dart';
import '../../Home/view/widgets/bottomSheet.dart';
import '../../Home/view/widgets/dailyTip.dart';
import '../../Home/view/widgets/ppData.dart';
import '../../Home/view/widgets/quickAction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Text(getGreeting(), style: TextStyle(color: Colors.black)),
                  SizedBox(width: 5),
                  Text('Padison', style: TextStyle(color: Colors.black)),
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'Personal Data',
                    style: DETAILS,
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PersonalDataCard(title: 'Height', data: '197.8'),
                SizedBox(width: 10),
                PersonalDataCard(title: 'Weight', data: '97.8'),
                SizedBox(width: 10),
                PersonalDataCard(title: 'BMI', data: '82.87'),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'Quick Actions',
                    style: DETAILS,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            QuickActionCard(
              title: 'Log New Data',
              description:
                  'Quickly enter your current details such as Height, Weight, and how often you Exercise.',
            ),
            SizedBox(height: 10),
            QuickActionCard(
              title: 'Set Alert Reminders',
              description:
                  'Set up and receive timely alerts to take your medications as prescribed, helping you stay on track with your treatment plan and maintain your health.',
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    'Daily Tips and Insights',
                    style: DETAILS,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            DailyTipCard(
              title: 'Stay Hydrated',
              description:
                  'Drinking enough water is crucial for maintaining overall health. Aim for at least 8 glasses a day to keep your body well-hydrated and functioning properly.',
              image: 'assets/water.png',
            ),
          ],
        ),
      ),
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
    );
  }
}
