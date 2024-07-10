// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class DailyTipCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const DailyTipCard(
      {required this.title, required this.description, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: BLUE, width: 7),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Card(
          color: WHITE,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
