// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medi_alert/modules%20/BMI/view/bmi_page.dart';
import 'package:medi_alert/utils/colors.dart';
import 'package:medi_alert/utils/navigator.dart';
import 'package:provider/provider.dart';

import '../../../utils/arrays.dart';
import '../../../utils/drawer.dart';
import '../../../utils/greetings.dart';
import '../../../utils/textStyles.dart';
import '../../BMI/models/bmiProvider.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
      drawer: AppDrawer(),
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
                PersonalDataCard(
                  title: 'Height',
                  data: context.watch<BmiProvider>().height.toStringAsFixed(2),
                ),
                SizedBox(width: 10),
                PersonalDataCard(
                  title: 'Weight',
                  data: context.watch<BmiProvider>().weight.toStringAsFixed(2),
                ),
                SizedBox(width: 10),
                PersonalDataCard(
                  title: 'BMI',
                  data: context.watch<BmiProvider>().bmi.toStringAsFixed(2),
                ),
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
            GestureDetector(
              onTap: () {
                customNavigator(context, BmiPage());
              },
              child: QuickActionCard(
                onTap: () {
                  customNavigator(context, BmiPage());
                },
                title: 'Log New Data',
                description:
                    'Quickly enter your current details such as Height, Weight, and how often you Exercise.',
              ),
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
            Column(
              children: dailyTips.map((tip) {
                return DailyTipCard(
                  title: tip['title']!,
                  description: tip['description']!,
                  image: tip['image']!,
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          elevation: 0,
          child: Image.asset(
            'assets/emegency.png',
            color: Colors.green,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomSheetContent();
              },
            );
          }),
    );
  }
}
