// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medi_alert/utils/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: WHITE,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: SECONDARY,
              child: Icon(
                Icons.person,
                size: 50,
                color: WHITE,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'BMI',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
