// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

Widget buildOption(BuildContext context, int index, String title,
    String subtitle, int selectedOption, Function(int) onSelect) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () {
          onSelect(index);
        },
        child: Container(
          width: 200,
          height: 55,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: selectedOption == index ? Colors.green[100] : Colors.white,
            border: Border.all(
              color: selectedOption == index ? Colors.green : Colors.grey,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
